## Development Server

Start the development server on http://localhost:3000

```bash
npm run dev
```

## Deployment

Generate Static Site:

```bash
npx nuxi generate
```

Locally Preview Generated Site:

```bash
npx serve .output/public
```

## Carousel

Carousel images go in the /public/carousel/ directory and will be automatically parsed upon building the site

## Complete Before Launch to Public

- Make sure steam links included in Siteheader.vue (Line 10) and Sitefooter.vue (Line 7) components
- Replace placeholder carousel images in /public/carousel/
- Replace embed video code in Demovid.vue (Line 4) - Do NOT eliminate the parameters after the ?
- Replace "Coming September" and related text in Siteheader.vue (Line 6) and /content/infotext.md (Line 16) (infotext is parsed by Bodycontent.vue, and is where the main body text of the site goes)

## A Note on Nuxt Content

Nuxt Content is a Nuxt Module that allows for the parsing of markdown files to text. It's useful for modularity, allowing for the text within a component to be quickly swapped between different markdown files, without requiring multiple components. It's used here for the main text of the site. The ContentDoc module (Nuxt Content's including parsing component) is invoked in the Bodycontent.vue component and pointed at infotext.md in the /content directory. If in the future, alternate text is desired, for example for an FAQ, one can be added quickly via a new markdown file, and either an additional ContentDoc component within Bodycontent to parse it, OR the existing ContentDoc component could be dynamically redirected to the new markdown file with a button or via script.