
# Digital Forensics

 ## File Metadata Analysis

 File metadata can provide useful information during digital forensic investigations. Different file types contain different types of metadata and require different tools to extract it.

---

 ## 1\. PDF File Metadata

 ### Tool: `pdfinfo`

 `pdfinfo` is a command-line utility included with the **Poppler** utilities package. It can be used to extract metadata and general information from PDF files.

 ### Installation

```
sudo apt install poppler-utils
```

 ### Usage

```
pdfinfo DOCUMENT.pdf
```

 ### Information You May Find

 - PDF version
- Page count
- Page size
- File size
- Title
- Author
- Creator
- Producer
- Creation date
- Modification date
- Encryption status

 ### Example

```
pdfinfo report.pdf
```

---

 ## 2\. Image / Photo EXIF Metadata

 ### Tool: `exiftool`

 `exiftool` is a command-line tool used to read and analyze metadata embedded in images and many other file formats.

 For photographs, it can be particularly useful for examining **EXIF (Exchangeable Image File Format)** data.

 ### Installation

```
sudo apt install libimage-exiftool-perl
```

 ### Usage

```
exiftool IMAGE.jpg
```

 ### Information You May Find

 - Camera make
- Camera model
- Date and time
- Image dimensions
- Exposure settings
- ISO
- Focal length
- Software used to edit the image
- GPS coordinates, if available
- Copyright information
- File timestamps
- EXIF metadata

 ### Example

```
exiftool photo.jpg
```

---

 ## Quick Reference

 | File Type | Tool | Installation | Usage |
| --- | --- | --- | --- |
| PDF | `pdfinfo` | `sudo apt install poppler-utils` | `pdfinfo DOCUMENT.pdf` |
| Image | `exiftool` | `sudo apt install libimage-exiftool-perl` | `exiftool IMAGE.jpg` |

---

 ## Important Forensic Considerations

 Metadata can be valuable during an investigation, but it should **not automatically be considered reliable evidence**.

 Metadata may be:

 - Modified by users
- Rewritten by applications
- Removed during file transfer
- Altered by image-editing software
- Missing from the original file

 Therefore, important metadata findings should be **corroborated with other forensic artifacts** whenever possible.

---

 ## Useful Commands

 ### PDF

```
pdfinfo DOCUMENT.pdf
```

 ### Image

```
exiftool IMAGE.jpg
```

 ### Save Output to a Text File

```
pdfinfo DOCUMENT.pdf > pdf_metadata.txt
```

```
exiftool IMAGE.jpg > image_metadata.txt
```

---

 ## Conclusion

 `pdfinfo` and `exiftool` are useful command-line tools for quickly examining file metadata during digital forensic analysis.

 - Use **`pdfinfo`** for PDF metadata.
- Use **`exiftool`** for image EXIF and other metadata.
- Always verify significant findings using additional forensic evidence.
