namespace java tachyon.thrift

include "common.thrift"
include "exception.thrift"

struct FileInfo {
  1: i64 fileId
  2: string name
  3: string path
  4: string ufsPath
  5: i64 length
  6: i64 blockSizeBytes
  7: i64 creationTimeMs
  8: bool isCompleted
  9: bool isFolder
  10: bool isPinned
  11: bool isCacheable
  12: bool isPersisted
  13: list<i64> blockIds
  15: i32 inMemoryPercentage
  16: i64 lastModificationTimeMs
  17: i64 ttl
}

struct CompleteFileTOptions {
  1: optional i64 ufsLength
}

struct CreateTOptions {
  1: optional i64 blockSizeBytes
  2: optional bool persisted
  3: optional bool recursive
  4: optional i64 ttl
}

struct MkdirTOptions {
  1: optional bool persisted
  2: optional bool recursive
  3: optional bool allowExists
}

struct SetStateTOptions {
  1: optional bool pinned
  2: optional i64 ttl
  3: optional bool persisted
}

service FileSystemMasterService extends common.TachyonService {

  /**
   * Marks a file as completed.
   * @param fileId
   * @param options
   * @throws TachyonTException
   */
  void completeFile( /** the id of the file */ 1: i64 fileId,
       /** the options for completing the file */ 2: CompleteFileTOptions options)
      throws (1: exception.TachyonTException e)

  /**
<<<<<<< HEAD
   * Creates a file and returns the id of the file
=======
   * Creates a file.
   * @param path
   * @param options
   * @return fileId
   * @throws TachyonTException
   * @throws ThriftIOException
>>>>>>>  use javadoc in file_master.thrift
   */
  i64 create( /** the path of the file */ 1: string path,
      /** the options for completing the file */ 2: CreateTOptions options)
      throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
<<<<<<< HEAD
   * Frees the given file from Tachyon and returns whether the free operation succeeded
=======
   * Frees the given file from Tachyon.
   * @param fileId
   * @param recursive
   * @return whether the free operation succeeded
   * @throws TachyonTException
>>>>>>>  use javadoc in file_master.thrift
   */
  bool free( /** the id of the file */ 1: i64 fileId,
      /** whether to free recursively */ 2: bool recursive)
    throws (1: exception.TachyonTException e)

  /**
   * Returns the file block information for the given file and file block index.
   * @param fileId
   * @param fileBlockIndex
   * @return the file block information for the given file and file block index.
   * @throws TachyonTException
   */
  common.FileBlockInfo getFileBlockInfo( /** the id of the file */ 1: i64 fileId,
      /** the index of the file block */ 2: i32 fileBlockIndex)
      throws (1: exception.TachyonTException e)

  /**
   * Returns the list of file blocks information for the given file.
   * @param fileId
   * @return the list of file blocks information for the given file
   * @throws TachyonTException
   */
  list<common.FileBlockInfo> getFileBlockInfoList( /** the id of the file */ 1: i64 fileId)
    throws (1: exception.TachyonTException e)

  /**
   * Returns the file id for the given path.
   * @param path
   * @return the file id for the given path
   */
  i64 getFileId( /** the path of the file */ 1: string path)

  /**
   * Returns the file information.
   * @param fileId
   * @return the file information
   * @throws TachyonTException
   */
  FileInfo getFileInfo( /** the id of the file */ 1: i64 fileId)
    throws (1: exception.TachyonTException e)

  /**
   * If the id points to a file, the method returns a singleton with its file information.
   * If the id points to a directory, the method returns a list with file information for the
   * directory contents.
   * @param fileId
   * @return list of file info
   * @throws TachyonTException
   */
  list<FileInfo> getFileInfoList( /** the id of the file */ 1: i64 fileId)
    throws (1: exception.TachyonTException e)

  /**
   * Generates a new block id for the given file.
   * @param fileId
   * @return a new block id for the given file
   * @throws TachyonTException
   */
  i64 getNewBlockIdForFile( /** the id of the file */ 1: i64 fileId)
    throws (1: exception.TachyonTException e)

  /**
   * Returns the UFS address of the root mount point.
   * @return the UFS address of the root mount point
   */
  // TODO(gene): Is this necessary?
  string getUfsAddress()

  /**
   * Loads metadata for the object identified by the given Tachyon path from UFS into Tachyon.
   * @param ufsPath
   * @param recursive
   * @return meta data object id
   * @throws TachyonTException
   * @throws ThriftIOException
   */
  // TODO(jiri): Get rid of this.
  i64 loadMetadata( /** the path of the under file system */ 1: string ufsPath,
      /** whether to load meta data recursively */ 2: bool recursive)
      throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
   * Creates a directory.
   * @param path
   * @param options
   * @return whether the mkdir operation succeeded
   * @throws TachyonTException
   * @throws ThriftIOException
   */
  bool mkdir( /** the path of the directory */ 1: string path,
    /** the options of this command */ 2: MkdirTOptions options)
    throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
   * Creates a new "mount point", mounts the given UFS path in the Tachyon namespace at the given
   * path. The path should not exist and should not be nested under any existing mount point.
   * @param tachyonPath
   * @param ufsPath
   * @return whether the mount operation succeeded
   * @throws TachyonTException
   * @throws ThriftIOException
   */
  bool mount( /** the path of tachyon mount point */ 1: string tachyonPath,
      /** the path of the under file system */ 2: string ufsPath)
      throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
   * Deletes a file or a directory.
   * @param id
   * @param recursive
   * @return whether the remove operation succeeded
   * @throws TachyonTException
   * NOTE: Unfortunately, the method cannot be called "delete" as that is a reserved Thrift keyword.
   */
  bool remove( /** the id of the file or directory */ 1: i64 id,
      /** whether to remove recursively */ 2: bool recursive)
      throws (1: exception.TachyonTException e)

  /**
   * Renames a file or a directory.
   * @param fileId
   * @param dstPath
   * @return whether the rename operation succeeded
   * @throws TachyonTException
   * @throws ThriftIOException
   */
  bool rename( /** the id of the file */ 1: i64 fileId,
      /** the desinationpath of the file */ 2: string dstPath)
      throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
   * Sets file state.
   * @param fileId
   * @param options
   */
  void setState( /** the id of the file */ 1: i64 fileId,
       /** the options of setting the file state */ 2: SetStateTOptions options)

  /**
   * Deletes an existing "mount point", voiding the Tachyon namespace at the given path. The path
   * should correspond to an existing mount point. Any files in its subtree that are backed by UFS
   * will be persisted before they are removed from the Tachyon namespace.
   * @param tachyonPath
   * @return whether the unmount operation succeeded
   * @throws TachyonTException
   * @throws ThriftIOException
   */
  bool unmount( /** the path of the tachyon mount point */ 1: string tachyonPath)
      throws (1: exception.TachyonTException e, 2: exception.ThriftIOException ioe)

  /**
   * Returns the set of pinned files.
   * @return the set of pinned files
   */
  set<i64> workerGetPinIdList()
}
