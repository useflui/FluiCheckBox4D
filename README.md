# FluiCheckBox4D

`FluiCheckBox4D` is a modern and highly customizable checkbox component for Delphi VCL, following the "Flui" library style. It utilizes GDI+ for high-quality anti-aliased rendering, featuring rounded corners, gradients, and flexible label positioning.

## Features
- **GDI+ Rendering**: Smooth, anti-aliased drawing for a modern look.
- **Customizable Rounding**: Adjust the corner radius of the checkbox.
- **Gradient Support**: Background gradients for the unchecked state.
- **Label Alignment**: Position the label at the top, bottom, left, or right of the checkbox.
- **Custom Colors**: Full control over border, background (start/end), checked state, and checkmark colors.

## Properties
| Property | Type | Description |
| --- | --- | --- |
| `Checked` | Boolean | Gets or sets whether the checkbox is checked. |
| `Rounding` | Integer | Corner radius for the checkbox box. |
| `BorderColor` | TColor | Color of the checkbox border. |
| `UseGradient` | Boolean | Toggle background gradient for the unchecked state. |
| `ColorStart` | TColor | Start color for the background gradient. |
| `ColorEnd` | TColor | End color for the background gradient. |
| `CheckedColor` | TColor | Solid background color when checked. |
| `CheckmarkColor`| TColor | Color of the checkmark tick. |
| `LabelPosition`| Enum | Positioning of the caption (`lpLeft`, `lpRight`, `lpTop`, `lpBottom`). |
| `Caption` | string | The text associated with the checkbox. |

## Installation
1. Open Delphi.
2. Go to `File > Open...` and select `FluiCheckBox4D.dpk`.
3. Right-click on the package in the Project Manager and select **Install**.
4. The component will appear in the **Flui** category of the Tool Palette.

## Reference Components
This component was built to complement the existing Flui library:
- [FluiPanel4D](https://github.com/TheJoaoVitorio/FluiPanel4D)
- [FluiToast4D](https://github.com/TheJoaoVitorio/FluiToast4D)
- [FluiEdit4D](https://github.com/TheJoaoVitorio/FluiEdit4D)

## Author
Created by **TheJoaoVitorio**.
