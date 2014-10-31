import os
import sys
import fnmatch
import re
import ycm_core
import json
import itertools

flags = []

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
compilation_database_folder = 'build/osx_x64_debug/make'

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def pairwise(iterable):
  "s -> (s0,s1), (s1,s2), (s2, s3), ..."
  a, b = itertools.tee(iterable)
  next(b, None)
  return itertools.izip(a, b)


def removeClosingSlash(path):
  if path.endswith('/'):
    path = path[:-1]
  return path

def debugLog(msg):
  print msg
  sys.stdout.flush()

def searchForTranslationUnitWhichIncludesPath(compileCommandsPath, path):
  path = removeClosingSlash(path)
  path = os.path.normpath(path)
  m = re.match( r'(.*/include)', path)
  if m:
    path = m.group(1)
    debugLog ("path: " + path)
  else:
    debugLog ("Path regex does not match")
    return None
  jsonData = open(compileCommandsPath)
  data = json.load(jsonData)
  for translationUnit in data:
    switches = translationUnit["command"].split()
    for currentSwitch, nextSwitch in pairwise(switches):
      matchObj = re.match( r'(-I|-isystem)(.*)', currentSwitch)
      includeDir = ""
      if currentSwitch == "-I" or currentSwitch == "-isystem":
        includeDir = nextSwitch
      elif matchObj:
        includeDir = matchObj.group(2)
      includeDir = removeClosingSlash(includeDir)
      includeDir = os.path.normpath(includeDir)
      if includeDir == path:
        debugLog ("Found " + translationUnit["file"])
        # TODO finally
        jsonData.close()
        return str(translationUnit["file"])
  jsonData.close()
  debugLog ("Not Found")
  return None

def findFirstSiblingSrc(dirname):
  fileMatches = []
  for root, dirnames, filenames in os.walk(dirname):
    for filename in filenames:
      if filename.endswith(tuple(SOURCE_EXTENSIONS)):
        return os.path.join(root, filename);
  return None

def getFirstEntryOfACompilationDB(compileCommandsPath):
  jsonData = open(compileCommandsPath)
  data = json.load(jsonData)
  # TODO finally
  jsonData.close()
  return str(data[0]["file"])

def GetCompilationInfoForFile( filename ):
  debugLog ("GetCompilationInfoForFile: filename: " + filename)

  basename = os.path.split( filename ) [ 1 ]
  dirname = os.path.dirname( filename )

  # The compilation_commands.json file generated by CMake does not have entries
  # for header files. So we do our best by asking the db for flags for a
  # corresponding source file, if any. If one exists, the flags for that file
  # should be good enough.
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        debugLog ("Matching src file, based on method0: " + replacement_file)
        compilation_info = database.GetCompilationInfoForFile(
          replacement_file )
        if compilation_info.compiler_flags_:
          return compilation_info

    # If still not found a candidate translation unit,
    # then try to browse the json db to find one,
    # which uses the directory of our header as an include path (-I, -isystem).
    compilation_database_file = compilation_database_folder + "/" + "compile_commands.json"
    candidateSrcFile = searchForTranslationUnitWhichIncludesPath(compilation_database_file, dirname)
    if candidateSrcFile != None:
      debugLog ("Matching src file, based on searchForTranslationUnitWhichIncludesPath: " + candidateSrcFile)
    else:
      candidateSrcFile = findFirstSiblingSrc(dirname)
      if candidateSrcFile != None:
        debugLog ("Matching src file, based on findFirstSiblingSrc: " + candidateSrcFile)
      else:
        candidateSrcFile = getFirstEntryOfACompilationDB(compilation_database_file)
        if candidateSrcFile != None:
          debugLog ("Matching src file, based on getFirstEntryOfACompilationDB: " + candidateSrcFile)

    if (candidateSrcFile == None):
      debugLog("Could not find any matches")
      candidateSrcFile = ""
    return database.GetCompilationInfoForFile(candidateSrcFile)

  # Src file
  result = database.GetCompilationInfoForFile( filename )
  candidateSrcFile = filename
  # TODO this is a bit redundant with the header part
  if not result.compiler_flags_:
    candidateSrcFile = findFirstSiblingSrc(dirname)
    if candidateSrcFile != None:
      debugLog ("Matching src file, based on findFirstSiblingSrc: " + candidateSrcFile)
    else:
      candidateSrcFile = getFirstEntryOfACompilationDB(compilation_database_file)
      if candidateSrcFile != None:
        debugLog ("Matching src file, based on getFirstEntryOfACompilationDB: " + candidateSrcFile)

    if (candidateSrcFile == None):
      debugLog("Could not find any matches")
      candidateSrcFile = ""

  return database.GetCompilationInfoForFile(candidateSrcFile)


def FlagsForFile( filename, **kwargs ):
  if database:
    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object
    compilation_info = GetCompilationInfoForFile( filename )
    if not compilation_info:
      return None

    final_flags = MakeRelativePathsInFlagsAbsolute(
      compilation_info.compiler_flags_,
      compilation_info.compiler_working_dir_ )

    try:

      # Xcode 5.1
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/c++/v1')
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include')
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/5.1/include')

      #final_flags.remove( '-stdlib=libc++' )
      #final_flags.append( '-nostdinc++' )

      # Xcode 6
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1')
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include')
      #final_flags.append('-isystem')
      #final_flags.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/6.0/include')

      #binary distribution of LLVM+Clang
      final_flags.append('-isystem')
      final_flags.append('/Users/mg/local/clang+llvm-3.5.0-macosx-apple-darwin/bin/../include/c++/v1')
      final_flags.append('-isystem')
      final_flags.append('/Users/mg/local/clang+llvm-3.5.0-macosx-apple-darwin/bin/../lib/clang/3.5.0/include')

      final_flags.append('-isystem')
      final_flags.append('/usr/include')
      final_flags.append('-isystem')
      final_flags.append('/usr/local/include')

    except ValueError:
      pass
  else:
    relative_to = DirectoryOfThisScript()
    final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

  return {
    'flags': final_flags,
    'do_cache': True
  }
