{ stdenv, requireFile, lib }:

let requireXcode = version: sha256:
  let
    xip = "Xcode_" + version +  ".xip";
    # TODO(alexfmpe): Find out how to validate the .xip signature in Linux
    unxip = if stdenv.buildPlatform.isDarwin
            then ''
              open -W ${xip}
              rm -rf ${xip}
            ''
            else ''
              xar -xf ${xip}
              rm -rf ${xip}
              pbzx -n Content | cpio -i
              rm Content Metadata
            '';
    app = requireFile rec {
      name     = "Xcode.app";
      url      = "https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${version}/${xip}";
      hashMode = "recursive";
      inherit sha256;
      message  = ''
        Unfortunately, we cannot download ${name} automatically.
        Please go to ${url}
        to download it yourself, and add it to the Nix store by running the following commands.
        Note: download (~ 5GB), extraction and storing of Xcode will take a while

        ${unxip}
        nix-store --add-fixed --recursive sha256 Xcode.app
        rm -rf Xcode.app
      '';
    };
    meta = with lib; {
      homepage = "https://developer.apple.com/downloads/";
      description = "Apple's XCode SDK";
      license = licenses.unfree;
      platforms = platforms.darwin ++ platforms.linux;
    };

  in app.overrideAttrs ( oldAttrs: oldAttrs // { inherit meta; });

in lib.makeExtensible (self: {
  xcode_8_1 = requireXcode "8.1" "18xjvfipwzia66gm3r9p770xdd4r375vak7chw5vgqnv9yyjiq2n";
  xcode_8_2 = requireXcode "8.2" "13nd1zsfqcp9hwp15hndr0rsbb8rgprrz7zr2ablj4697qca06m2";
  xcode_9_1 = requireXcode "9.1" "0ab1403wy84ys3yn26fj78cazhpnslmh3nzzp1wxib3mr1afjvic";
  xcode_9_2 = requireXcode "9.2" "1bgfgdp266cbbqf2axcflz92frzvhi0qw0jdkcw6r85kdpc8dj4c";
  xcode_9_3 = requireXcode "9.3" "12m9kb4759s2ky42b1vf7y38qqxn2j99s99adzc6ljnmy26ii12w";
  xcode_9_4 = requireXcode "9.4" "00az1cf9pm8zmvzs6yq04prdmxp8xi3ymxw94jjh4mh7hlbkhcb7";
  xcode_9_4_1 = requireXcode "9.4.1" "0y9kphj86c14jl6aibv57sd7ln0w06vdhzm8ysp0s98rfgyq2lbw";
  xcode_10_1 = requireXcode "10.1" "1ssdbg4v8r11fjf4jl38pwyry2aia1qihbxyxapz0v0n5gfnp05v";
  xcode_10_2 = requireXcode "10.2" "1xzybl1gvb3q5qwlwchanzpws4sb70i3plf0vrzvlfdp2hsb3pg7";
  xcode_10_2_1 = requireXcode "10.2.1" "11sdb54nr0x7kp987qq839x6k5gdx7vqdxjiy5xm5279n1n47bmg";
  xcode_10_3 = requireXcode "10.3" "1i628vfn6zad81fsz3zpc6z15chhskvyp8qnajp2wnpzvrwl6ngb";
  xcode_11 = requireXcode "11" "1r03j3kkp4blfp2kqpn538w3dx57ms930fj8apjkq6dk7fv3jcqh";
  xcode_11_1 = requireXcode "11.1" "1c2gzc4jhhx5a7ncg19sh1r99izhipybaqxl1ll52x5y8689awc1";
  xcode_11_2 = requireXcode "11.2" "1lm3q8zpvm184246h5j9mw4c1y9kk9sxnr3j98kfm0312n0l98gj";
  xcode_11_3 = requireXcode "11.3" "04rv6xlywy8xqfx9ma8ygsdw4yhckk2mq0qnklxnfly899iw4wza";
  xcode_11_3_1 = requireXcode "11.3.1" "1p6nicj91kr6ad3rmycahd1i7z4hj7ccjs93ixsiximjzaahx3q4";
  xcode_11_4 = requireXcode "11.4" "065rpb3rdk19nv3rwyf9bk32ccbd0lld12gj12l89cyg65mhpyy7";
  xcode_11_5 = requireXcode "11.5" "1dizazq9nz1vjkc5gy7dd4x760mkfjiifk1hf6d9mscchdq8rfkw";
  xcode_11_6 = requireXcode "11.6" "1y4fhw1kiphzxdb4wpv697z5r0algvaldwq5iqv266797rnfql4x";
  xcode_11_7 = requireXcode "11.7" "0422rdc4j5qwyk59anbybxyfv0p26x0xryszm0wd8i44g66smlmj";
  xcode_12 = requireXcode "12" "1w3xm268pyn5m04wv22invd5kr2k4jqllgrzapv6n1sxxynxrh8z";
  xcode_12_0_1 = requireXcode "12.0.1" "1p6vd5ai0hh3cq6aflh4h21ar0shxnz8wlkaxwq7liwsdmkwzbl0";
  xcode_12_1 = requireXcode "12.1" "1widy74dk43wx8iqgd7arzf6q4kzdmaz8pfwymzs8chnq9dqr3wp";
  xcode_12_2 = requireXcode "12.2" "17i0wf4pwrxwfgjw7rpw9mcd59nkmys1k5h2rqsw81snzyxy9j0v";
  xcode_12_3 = requireXcode "12.3" "0kwf1y4llysf1p0nsbqyzccn7d77my0ldagr5fi3by4k0xy3d189";
  xcode = self."xcode_${lib.replaceStrings ["."] ["_"] (if (stdenv.targetPlatform ? xcodeVer) then stdenv.targetPlatform.xcodeVer else "12.3")}";
})

