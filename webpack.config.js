const HtmlWebpackPlugin = require('html-webpack-plugin');
const path = require('path');

const config = {
    entry: {
        "pandemic": './index.js',
        demo: './src/demo.js'
    },
    mode: process.env.WEBPACK_SERVE ? 'development' : 'production',
    output: {
        filename: '[name].js',
        library: 'pandemic',
        libraryTarget: 'umd'
    },
    devServer: {
        port: 4444,
    },
    module: {
        rules: [
            {
                test: /\.(css)$/,
                use: ['style-loader', 'css-loader'],
            },
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
            {
                test: /\.wasm$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                    },
                }]
            },
            {
                test: /\.csv$/,
                loader: 'csv-loader',
                options: {
                    dynamicTyping: true,
                    header: true,
                    skipEmptyLines: true
                }
            }
],
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
        fallback: { crypto: false, path: false, fs: false }
    },
    plugins: [
        new HtmlWebpackPlugin({
            chunks: ['demo'],
            // filename: "src/demo.html",
            template: "src/demo.html",
            // inject: false,
        })
    ],
}

module.exports = (env) => {

    console.log(process.env.WEBPACK_SERVE ? 'SERVING DEVELOPMENT ...' : 'BUILDING PRODUCTION ...');

    if (process.env.WEBPACK_SERVE) {
        config.devtool = 'eval-cheap-source-map';
        config.stats = {warnings: false};
    }

    return config;
}