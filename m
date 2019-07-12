Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AB66B45
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 12:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfGLK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 06:59:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:51856 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfGLK7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 06:59:46 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 49E7D1A1CD9;
        Fri, 12 Jul 2019 03:59:45 -0700 (PDT)
X-Riseup-User-ID: F4CB9AC67F059115AB0E9AA10D86D24AF0D3331CB13A721470605CB2BC6B6F72
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id D95F622332A;
        Fri, 12 Jul 2019 03:59:42 -0700 (PDT)
Subject: Re: [PATCH] kconfig: fix missing choice values in auto.conf
To:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kbuild@vger.kernel.org
Cc:     Ulf Magnusson <ulfalizer@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20190712060709.20609-1-yamada.masahiro@socionext.com>
From:   =?UTF-8?Q?Joonas_Kylm=c3=a4l=c3=a4?= <joonas.kylmala@iki.fi>
Openpgp: preference=signencrypt
Autocrypt: addr=joonas.kylmala@iki.fi; prefer-encrypt=mutual; keydata=
 mQINBFuAFyMBEACWAPtxMyFIyFCANHBamWWdV/TQ7OwGCjxv+18fxn88eMd5pwy9W00fbgQ1
 Hj54wckednit7BcksxwKkf7BDBF3HfGP7hohD34nH3Njf6a37kJA4UqHAQceam96pI9Vmn8n
 DYJFRer4wMrBhED8tXSQvKYUHi2wc+imi9mBRYG6Bs1AU/W1Mr7vVK48GxUMlbyCqhSrijHB
 ObG/gK1cygOeguMDO1XJbcTvD0iu3OJpT04m0YJCJS1TBDdO4Ok81Cka1tGEdGQ5UUdzGM1e
 O+XMy3R8l+PjZm4v+tx7vkFQPkJLtm0m2Yl/BqLYQXso0vmwSv9vwfQagRkHMdNg4qhAUmIE
 AivEVkIjwq8L7T6O1+u5qeP4CocT8oeOjOgIJVxkC552JCTDlvY/VhAesZ1G14a0lg8KCwbi
 HuMIOoiuzs6qzLkI5FDlIjMJ9OAKwaE30IIYHvLws0EKb7g1R9jGm5SvhZ5EsAiZogh1bTxi
 VaN/XRMQQkyN/xoPen/JoW+9UWm7fSZZRZ+/EGfSwEQ9Wd+DYtiXO+jBTPPBlyhUd/2PjxuG
 rOb4yP/O2NnZ2ZHu/Qmk+OoqNA7WmEe4nQI82KF6E6c/ujbBMa+7QD58myTyXauTwIXBpk0V
 mywlH3BuMf4cq9ETWOvh9xNHSdk7Chc1SQK5tZElUy5LKWwWlwARAQABtChKb29uYXMgS3ls
 bcOkbMOkIDxqb29uYXMua3lsbWFsYUBpa2kuZmk+iQJUBBMBCAA+FiEE15qk8YCqV2OoX8gz
 Ey3rzmVSJjUFAluAFyMCGyMFCQlmAYAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQEy3r
 zmVSJjVbjQ/8D+9AHV1hrbHiAEsSUrfKrzTWXekAyaQUQwwXZrXgvQiG2S+VCXYhoB5QCbPv
 VGxXRmSU+By4ZJ4GOMhMsYtV8tMyXyJgH3ubD85UUpJSH8Z6lIl5UTPuJw2Ty47s2aX0cRKS
 4pXfZgVJVSwCuQxXsjv/SNDP4ZGRlVaDbI8x3mxHINrKy3UgMJs6bJy6Pa8dQBRp+TlfyQyF
 cujFZJ9eA7s+v82LrUY4dQMfsZ6UmQndj0x7/6x7Zhi97+uF/TGu/PTPK4DaR8AoRU5cWjeX
 HVXHWjeQpuAWu7hg83Bl0uiBaw61U3Skw1Sn0X/bYB/diM+t4kpcG1aJGJWAWZi3NhP6mPKl
 7PLa2510J/bTvTQHmlQWbYaFgsAAOS5Ul8BIhoWOFJXYHAV0X9AkE/K1eSxseNTOzceDOz2p
 /03wGANbU5L6vkc8sD+y8lfQLyWy+pFATT7hEsk5IJzWiICYmsz2SxnYXBDA+T32jSICI0N4
 s4jSbo1ynfjFLkdjLx9bYGKhGdIMvkemQTOpoPgzbu7swbhdGU+wHsdllAB+/qIkFpO0nMc0
 +/z3JjvLMGfrpoPftJKJQefi+RzcQgUMtr4mlY3l5BkgdAtCAY+TGKR81pqKpkve23rnjUzt
 8yp0dTRABpLvKKWqYI4P2bbTNWYuDCOYHZgs/1bQc3ZhRbG5Ag0EW4AXIwEQAMVkkY/lzahy
 r8H1ApUS5qE0zmoGwryk5SfU80MM7GRDjV4xNf1DMG+GOvIShp96jL+PYxlsmCN1/6cKzVCI
 M+Fb2JkQAOmXdEm6V6cnps4urukwvi9nwugHVUybJ1Vhyn1C13ZYIjGv9th65l5ix5s/NVPM
 88KCnyFk3fv+hhOuIh8QZflglhd4zslxRjxZQLiR6HlJv/jmqGAcDSY3vu5SDYphYs2WvXMY
 dTaJtYZ72mtrgh8htAxNRvl21TUzLg2PlOsg84uar3isSLc5qNpfSu3U/2EQHHk0ilmZDHLG
 f0EdzDdQx31PaUyK2m5iD6lg0uKHe4lb7GKw/KVQqZkORHQzkuj7a8X/Zlf9m3LYORbbsBsN
 xFofL5ES6p/0nkLDn3EQ/U+6XOtklZMMbjkhCuxyt+gte1vOpgtcqvJXzSY2dPasZo8/I59J
 NbqRV4pcMENjXH1IqhgfuuyfA/LBQ5Co4DPxHxOzXWrHLHlOK0Q3Qp5drnO7ZfydVi5QOiJf
 uak6JE3LjxeBYU02kz7dd+jTPG6hQ7W/Bf5Wp6NJHVqtg2l7o8oqaPwCLJVY+UbCaQG4++cD
 vCsSJmLO7KK6ljOouSf7v1+miUpSd2gxsw6pwfD0pYFQZrRDr8xUYJIIZE6gnC8ovCt4ZoPf
 4QP839/Dd7xnGN16M24EA0LjABEBAAGJAjwEGAEIACYWIQTXmqTxgKpXY6hfyDMTLevOZVIm
 NQUCW4AXIwIbDAUJCWYBgAAKCRATLevOZVImNRVbD/9RtVd8KmwHZPuhL9H3/BqF/kDhquba
 +i979Muv3pX8SGS72GjrRv7mrClfl/BFseggbp4PIK7hiHqNn5ydMf/ZPT89bq2Re1mCM7bq
 hZhLoOr7TeTJCXolN9jR3MfX3/0QFVv3Z8+dXEpFBIZE+QQEn2WsdKki1nxnVuuQcpJTsT+0
 wdk4gFIn9AT2CGgjtORLrXs4ZjsYbIUcOxgKNzz18TyoelyywVU33cL1LtdnBzuNz3xlYNkt
 LI5sOyeQ2nxeOz5/w73MU3hKMolWnpccb6li4BKjq6f4pbtEHzxeG/nrVcViJU7sI34iOZu7
 8OWZi9rvhnPTF1FUcQ0Y9bAnyiXUwP1tMZkXu5QoS4NFInvsW2BlVoqo80IVLgITu7eoz3I/
 3VniDu6zLAqgc3I7hO9tcZ+NiZEmLbWKpwRKPe0Ui3IfmE33ECoKzVN+Y4TuBl9UrtNYbBN6
 NTjlRX5JVRGyqBd/1UpmyXc8V+LGjoz8VxwhKDPowPxN55kOaaPNcGk3siGVZls1xpRLDI9s
 XiiCs4cAT7o+5vz7GXv0gda5mH2H/v6S25nGxzoiinpcjeup8JJ9M64QC5CNVgg/rCgFwA2d
 GBofCExy51CODjqDmPQv1V18ofFpuY+Wujl9+n8VVcN801zSELtjoWKLgDMLMBzh7UrKi219
 gKPkEg==
Message-ID: <0daa3b66-2dd0-079e-05ea-c65eb4fa6815@iki.fi>
Date:   Fri, 12 Jul 2019 13:59:39 +0300
MIME-Version: 1.0
In-Reply-To: <20190712060709.20609-1-yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

thanks a lot for this patch! I tested this and it fixes what is says in
the commit message:

Tested-by: Joonas Kylmälä <joonas.kylmala@iki.fi>

Masahiro Yamada:
> Since commit 00c864f8903d ("kconfig: allow all config targets to write
> auto.conf if missing"), Kconfig creates include/config/auto.conf in the
> defconfig stage when it is missing.
> 
> Joonas Kylmälä reported incorrect auto.conf generation under some
> circumstances.
> 
> Apply the following diff:
> 
> | --- a/arch/arm/configs/imx_v6_v7_defconfig
> | +++ b/arch/arm/configs/imx_v6_v7_defconfig
> | @@ -345,14 +345,7 @@ CONFIG_USB_CONFIGFS_F_MIDI=y
> |  CONFIG_USB_CONFIGFS_F_HID=y
> |  CONFIG_USB_CONFIGFS_F_UVC=y
> |  CONFIG_USB_CONFIGFS_F_PRINTER=y
> | -CONFIG_USB_ZERO=m
> | -CONFIG_USB_AUDIO=m
> | -CONFIG_USB_ETH=m
> | -CONFIG_USB_G_NCM=m
> | -CONFIG_USB_GADGETFS=m
> | -CONFIG_USB_FUNCTIONFS=m
> | -CONFIG_USB_MASS_STORAGE=m
> | -CONFIG_USB_G_SERIAL=m
> | +CONFIG_USB_FUNCTIONFS=y
> |  CONFIG_MMC=y
> |  CONFIG_MMC_SDHCI=y
> |  CONFIG_MMC_SDHCI_PLTFM=y
> 
> And then, run:
> 
> $ make ARCH=arm mrproper imx_v6_v7_defconfig
> 
> CONFIG_USB_FUNCTIONFS=y is correctly contained in the .config, but not
> in the auto.conf.
> 
> Please note drivers/usb/gadget/legacy/Kconfig is included from a choice
> block in drivers/usb/gadget/Kconfig. So USB_FUNCTIONFS is a choice value.
> 
> This is probably a similar situation described in commit beaaddb62540
> ("kconfig: tests: test defconfig when two choices interact").
> 
> When sym_calc_choice() is called, the choice symbol forgets the
> SYMBOL_DEF_USER unless all of its choice values are explicitly set by
> the user.
> 
> The choice symbol is given just one chance to recall it because
> set_all_choice_values() is called if SYMBOL_NEED_SET_CHOICE_VALUES
> is set.
> 
> When sym_calc_choice() is called again, the choice symbol forgets it
> forever, since SYMBOL_NEED_SET_CHOICE_VALUES is a one-time aid.
> Hence, we cannot call sym_clear_all_valid() again and again.
> 
> It is crazy to set and clear internal flags. However, we cannot simply
> get rid of "sym->flags &= flags | ~SYMBOL_DEF_USER;" Doing so would
> re-introduce the problem solved by commit 5d09598d488f ("kconfig: fix
> new choices being skipped upon config update").
> 
> To work around the issue, conf_write_autoconf() stopped calling
> sym_clear_all_valid().
> 
> conf_write() must be changed accordingly. Currently, it clears
> SYMBOL_WRITE after the symbol is written into the .config file. This
> is needed to prevent it from writing the same symbol multiple times in
> case the symbol is declared in two or more locations. I added the new
> flag SYMBOL_WRITTEN, to track the symbols that have been written.
> 
> Anyway, this is a cheesy workaround in order to suppress the issue
> as far as defconfig is concerned.
> 
> Handling of choices is totally broken. sym_clear_all_valid() is called
> every time a user touches a symbol from the GUI interface. To reproduce
> it, just add a new symbol drivers/usb/gadget/legacy/Kconfig, then touch
> around unrelated symbols from menuconfig. USB_FUNCTIONFS will disappear
> from the .config file.
> 
> I added the Fixes tag since it is more fatal than before. But, this
> has been broken since long long time before, and still it is.
> We should take a closer look to fix this correctly somehow.
> 
> Fixes: 00c864f8903d ("kconfig: allow all config targets to write auto.conf if missing")
> Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> Reported-by: Joonas Kylmälä <joonas.kylmala@iki.fi>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
>  scripts/kconfig/confdata.c | 7 +++----
>  scripts/kconfig/expr.h     | 1 +
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index cbb6efa4a5a6..e0972b255aac 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -895,7 +895,8 @@ int conf_write(const char *name)
>  				     "# %s\n"
>  				     "#\n", str);
>  			need_newline = false;
> -		} else if (!(sym->flags & SYMBOL_CHOICE)) {
> +		} else if (!(sym->flags & SYMBOL_CHOICE) &&
> +			   !(sym->flags & SYMBOL_WRITTEN)) {
>  			sym_calc_value(sym);
>  			if (!(sym->flags & SYMBOL_WRITE))
>  				goto next;
> @@ -903,7 +904,7 @@ int conf_write(const char *name)
>  				fprintf(out, "\n");
>  				need_newline = false;
>  			}
> -			sym->flags &= ~SYMBOL_WRITE;
> +			sym->flags |= SYMBOL_WRITTEN;
>  			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
>  		}
>  
> @@ -1063,8 +1064,6 @@ int conf_write_autoconf(int overwrite)
>  	if (!overwrite && is_present(autoconf_name))
>  		return 0;
>  
> -	sym_clear_all_valid();
> -
>  	conf_write_dep("include/config/auto.conf.cmd");
>  
>  	if (conf_touch_deps())
> diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
> index 8dde65bc3165..017843c9a4f4 100644
> --- a/scripts/kconfig/expr.h
> +++ b/scripts/kconfig/expr.h
> @@ -141,6 +141,7 @@ struct symbol {
>  #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
>  #define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
>  #define SYMBOL_CHANGED    0x0400  /* ? */
> +#define SYMBOL_WRITTEN    0x0800  /* track info to avoid double-write to .config */
>  #define SYMBOL_NO_WRITE   0x1000  /* Symbol for internal use only; it will not be written */
>  #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
>  #define SYMBOL_WARNED     0x8000  /* warning has been issued */
> 
