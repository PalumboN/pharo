"
SUnit tests for FileSystemDirectoryEntry
"
Class {
	#name : #DirectoryEntryTest,
	#superclass : #TestCase,
	#category : #'FileSystem-Tests-Core-Base'
}

{ #category : #accessing }
DirectoryEntryTest >> entry [
	^ FileLocator image resolve entry
]

{ #category : #tests }
DirectoryEntryTest >> testCreationTimeIsADateAndTimeInstance [
	"While creation is the message sent to a directory entry, creation returns a DateAndTime object"

	| creation |
	creation := self entry creation.
	self assert: creation class equals: DateAndTime
]

{ #category : #tests }
DirectoryEntryTest >> testIfAbsent [
	| reference entry |
	reference := FileLocator temp / 'plonk'.
	reference ensureCreateFile.
	entry := reference entry.
	[ entry ifAbsent: [ :file | self fail ].
	reference delete.
	self assert: (entry ifAbsent: [ 'plonk' ]) equals: 'plonk' ]
		ensure: [ reference ensureDelete ]
]

{ #category : #tests }
DirectoryEntryTest >> testIfExists [
	| reference entry |
	reference := FileLocator temp / 'plonk'.
	reference ensureCreateFile.
	entry := reference entry.
	[ self assert: (entry ifExists: [ :file | file basename ]) equals: 'plonk'.
	reference delete.
	entry ifExists: [ :file | self fail ] ]
		ensure: [ reference ensureDelete ]
]

{ #category : #tests }
DirectoryEntryTest >> testIfExistsIfAbsent [
	| reference entry |
	reference := FileLocator temp / 'plonk'.
	reference ensureCreateFile.
	entry := reference entry.
	[ self assert: (entry ifExists: [ true ] ifAbsent: [ false ]).
	reference delete.
	self assert: (entry ifExists: [ false ] ifAbsent: [ true ]) ]
		ensure: [ reference ensureDelete ]
]

{ #category : #tests }
DirectoryEntryTest >> testIsDirectory [
	| ref entry |
	ref := FileLocator imageDirectory resolve.
	entry := ref entry.
	self assert: entry isDirectory.
	self assert: FileLocator imageDirectory resolve equals: Smalltalk imageDirectory
]

{ #category : #tests }
DirectoryEntryTest >> testIsFile [
	self assert: self entry isFile.
	self deny: self entry isDirectory
]

{ #category : #tests }
DirectoryEntryTest >> testIsNotDirectory [
	self deny: self entry isDirectory
]

{ #category : #tests }
DirectoryEntryTest >> testIsNotFile [
	| ref |
	ref := FileLocator imageDirectory resolve.
	self deny: ref entry isFile
]

{ #category : #tests }
DirectoryEntryTest >> testModificationTimeIsADateAndTimeInstance [
	"While modification is the message sent to a directory entry, modification returns a DateAndTime object"

	| modification |
	modification := self entry modification.
	self assert: modification class equals: DateAndTime
]

{ #category : #tests }
DirectoryEntryTest >> testReference [
	| ref entry |
	ref := FileLocator image resolve.
	entry := ref entry.
	self assert: entry reference equals: ref
]

{ #category : #tests }
DirectoryEntryTest >> testRootEntry [
	"Check that the root entry contains sensible values.
	On Windows this requires a pseudo entry to be available."

	| rootEntry |

	rootEntry := (FileReference fileSystem: FileSystem disk path: Path root) entry.

	self assert: rootEntry isDirectory.
	self deny: rootEntry isFile.
	self assert: rootEntry size equals: 0.
	self assert: rootEntry isReadable.
	self assert: rootEntry isExecutable.
	self deny: rootEntry isWritable.
]

{ #category : #tests }
DirectoryEntryTest >> testSize [
	self assert: self entry size isInteger
]
