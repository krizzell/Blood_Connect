---
name: BloodConnect
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#5b403d'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#8f706c'
  outline-variant: '#e4beba'
  surface-tint: '#b91d20'
  primary: '#a20513'
  on-primary: '#ffffff'
  primary-container: '#c62828'
  on-primary-container: '#ffe0dd'
  inverse-primary: '#ffb4ac'
  secondary: '#b7131a'
  on-secondary: '#ffffff'
  secondary-container: '#db322f'
  on-secondary-container: '#fffbff'
  tertiary: '#005190'
  on-tertiary: '#ffffff'
  tertiary-container: '#006ab8'
  on-tertiary-container: '#dbe9ff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad6'
  primary-fixed-dim: '#ffb4ac'
  on-primary-fixed: '#410003'
  on-primary-fixed-variant: '#93000e'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ac'
  on-secondary-fixed: '#410002'
  on-secondary-fixed-variant: '#93000d'
  tertiary-fixed: '#d3e4ff'
  tertiary-fixed-dim: '#a2c9ff'
  on-tertiary-fixed: '#001c38'
  on-tertiary-fixed-variant: '#004881'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Be Vietnam Pro
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-mobile: 16px
  container-padding-desktop: 32px
  gutter: 24px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style
The design system is built on the principles of trust, urgency, and clarity. As a blood donation platform, the UI must balance the critical nature of medical services with a welcoming, modern aesthetic. 

The style is **Minimalist-Modern with Material Design 3 influences**. It prioritizes high legibility and a sense of calm efficiency. By leveraging generous whitespace and a refined color application, the design system ensures that users—whether donors or clinic staff—can navigate complex information without cognitive overload. The emotional response should be one of confidence and reliability, achieved through a structured grid and a "content-first" hierarchy.

## Colors
The palette is rooted in a spectrum of reds to immediately signify the medical focus while using specific tones to denote hierarchy and status.

- **Primary Red (#C62828):** Used for key brand elements, primary actions, and critical navigation items.
- **Secondary Red (#E53935):** Used for accents and hover states to provide a sense of vibrancy.
- **Surface & Background:** A pure white (#FFFFFF) is used for all main content cards and containers to maximize contrast. A light neutral (#F5F5F5) is utilized for page backgrounds to provide subtle separation.
- **Semantic Colors:** 
    - **Success (Green):** Confirms successful donation bookings or completed health checks.
    - **Warning/Searching (Orange):** Indicates urgent blood type shortages or "live" searches for donors.
    - **Pending (Blue):** Represents scheduled appointments or requests currently under review.

## Typography
This design system utilizes **Be Vietnam Pro** (as a high-quality alternative to Poppins that maintains the geometric, modern, and friendly tone required for this platform). 

The type scale is optimized for information density. Headlines are bold and authoritative to guide the user's eye, while body text uses a slightly increased line-height to ensure medical instructions and data are easily readable. For mobile devices, large headlines scale down to prevent excessive wrapping while maintaining visual impact.

## Layout & Spacing
The layout follows a **Fluid Grid** model based on an 8px square rhythm. 

- **Desktop:** A 12-column grid with 24px gutters and 32px side margins. Content is often centered in a max-width container of 1280px to prevent excessive line lengths.
- **Mobile:** A 4-column grid with 16px gutters and 16px margins. 
- **Spacing Logic:** Vertical stacks should use "stack-md" (16px) for related elements and "stack-lg" (32px) for distinct sections. This ensures a clean, breathable interface that emphasizes the "Minimalist" brand pillar.

## Elevation & Depth
Elevation is communicated through **Ambient Shadows** and **Tonal Layering**, following Material Design 3 logic.

- **Level 0 (Flat):** The main background surface.
- **Level 1 (Card):** Used for content sections. Features a very soft, diffused shadow (0px 2px 8px, 4% opacity black) and a 1px subtle border (#EEEEEE) to define boundaries without visual noise.
- **Level 2 (Interactive/Floating):** Used for buttons and active states. The shadow becomes more pronounced (0px 4px 12px, 8% opacity red-tinted) to indicate the element is tappable and sits above the surface.
- **Backdrop Blurs:** Used sparingly for navigation bars and modal overlays to maintain context while focusing the user's attention.

## Shapes
The shape language is **Rounded (0.5rem / 8px base)**. 

This level of corner radius strikes a balance between professional precision and approachable friendliness. 
- **Standard (8px):** Primary buttons, input fields, and small cards.
- **Large (16px):** Main content containers and large dashboard widgets.
- **Pill (Circular):** Used exclusively for status chips (e.g., "Urgent," "Completed") and floating action buttons (FABs).

## Components

### Buttons
- **Primary:** Solid Red (#C62828) fill with white text. 8px rounded corners. Use for "Donate Now" or "Book Appointment."
- **Secondary:** Outlined with Primary Red and 1px stroke. Used for secondary actions like "Learn More."
- **Ghost:** No fill or border, red text. Used for low-priority actions in lists.

### Input Fields
- **Style:** Outlined with a 1px #E0E0E0 border. On focus, the border transitions to Primary Red with a 2px stroke.
- **Labels:** Use "Label-lg" typography, floating or placed directly above the field.

### Chips
- **Status Chips:** Pill-shaped with a light tinted background and dark saturated text (e.g., Light Green background with Dark Green text for "Success").
- **Action Chips:** Gray background, used for filtering blood types (A+, B-, etc.).

### Cards
- **Container:** White background, Level 1 shadow, 16px internal padding.
- **Content:** Headline-sm for titles, Body-md for descriptive text.

### Lists
- **Interaction:** Use subtle gray hover states (#F5F5F5).
- **Dividers:** Horizontal 1px lines (#EEEEEE), inset by 16px to maintain vertical alignment with text.

### Progress Indicators
- **Style:** Linear bars for blood supply levels. Use a rounded track and Primary Red for the "filled" state to represent the volume of blood collected.