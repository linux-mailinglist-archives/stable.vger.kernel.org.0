Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A72537DA
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHZTH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 15:07:29 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44521 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZTH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 15:07:26 -0400
Received: by mail-lj1-f195.google.com with SMTP id g6so3607039ljn.11
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 12:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XIwmx9TJvsrGYokJuGDtagSqo3x02TlpZfQJFPxsiSw=;
        b=iqJB1st29NYcYmISejWaZQdw5t5te4T8Zb3UsbGkKYvXlaJ5MO2UrQTKsekxjIZkBp
         aWMId4Bsntk0duwLSfWEw4IiBYVttjspABMfxMvatpS+lwrZb/REHTSnlP1aHcF9bgXy
         XZO3/7EDEhB/xo8QPcOyQ5nwKxj4+z1TBw3S046H1yUBxMICeQLYDVLTLQKLWLfU3PXo
         YVZdCtg/gLqJgZAIWfOq45M/4uVGXtFwCAKEjaXQg/h4os3YuJE+NQ0n1/izW1ZyHC1Y
         5rPpN/wsDzE0ljAxYanP4pse9J0j9uXWRBcmRaBglk3EU6vi5/yO9PL+SXfKG3YV5+7N
         h7tw==
X-Gm-Message-State: AOAM532cI/fXtdRAK1iu5hW3iz+/PAg7n9hnQ1R6WmBPDaF0+Q33ELGq
        5i9U1Cjm0wSJuHL2G1L+Ppk=
X-Google-Smtp-Source: ABdhPJwcTv66XJIRacV/WLhuuQ/ZJxZLe+4ARKEiPpCjXYE/VE99zmvGNVtHjrAwazCnTe+U9Btynw==
X-Received: by 2002:a2e:b8cb:: with SMTP id s11mr8591689ljp.110.1598468842191;
        Wed, 26 Aug 2020 12:07:22 -0700 (PDT)
Received: from [192.168.1.8] ([213.87.147.111])
        by smtp.gmail.com with ESMTPSA id m7sm759388lfd.77.2020.08.26.12.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:21 -0700 (PDT)
Subject: Re: [PATCH v5.4 6/6] kbuild: add variables for compression tools
To:     Matthias Maennich <maennich@google.com>, stable@vger.kernel.org
Cc:     kernel-team@android.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20200826162828.3330007-1-maennich@google.com>
 <20200826162828.3330007-7-maennich@google.com>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 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
Message-ID: <4916bb81-e9d3-8425-ceeb-7e9321068848@linux.com>
Date:   Wed, 26 Aug 2020 22:07:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826162828.3330007-7-maennich@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patch introduces build error, see fix:
e4a42c82e943 kbuild: fix broken builds because of GZIP,BZIP2,LZOP variables

Thanks,
Denis

On 8/26/20 7:28 PM, Matthias Maennich wrote:
> From: Denis Efremov <efremov@linux.com>
> 
> Allow user to use alternative implementations of compression tools,
> such as pigz, pbzip2, pxz. For example, multi-threaded tools to
> speed up the build:
> $ make GZIP=pigz BZIP2=pbzip2
> 
> Variables _GZIP, _BZIP2, _LZOP are used internally because original env
> vars are reserved by the tools. The use of GZIP in gzip tool is obsolete
> since 2015. However, alternative implementations (e.g., pigz) still rely
> on it. BZIP2, BZIP, LZOP vars are not obsolescent.
> 
> The credit goes to @grsecurity.
> 
> As a sidenote, for multi-threaded lzma, xz compression one can use:
> $ export XZ_OPT="--threads=0"
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> (cherry picked from commit 8dfb61dcbaceb19a5ded5e9c9dcf8d05acc32294)
> Signed-off-by: Matthias Maennich <maennich@google.com>
> Change-Id: Idaa5daac69c820c78e32b4630f3d72739e74be12
> ---
>  Makefile                          | 25 +++++++++++++++++++++++--
>  arch/arm/boot/deflate_xip_data.sh |  2 +-
>  arch/ia64/Makefile                |  2 +-
>  arch/m68k/Makefile                |  8 ++++----
>  arch/parisc/Makefile              |  2 +-
>  kernel/gen_kheaders.sh            |  2 +-
>  scripts/Makefile.lib              | 12 ++++++------
>  scripts/Makefile.package          |  8 ++++----
>  scripts/package/buildtar          |  6 +++---
>  scripts/xz_wrap.sh                |  2 +-
>  10 files changed, 45 insertions(+), 24 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 7c001e21e28e..3521ba6097a7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -426,6 +426,26 @@ PYTHON2		= python2
>  PYTHON3		= python3
>  CHECK		= sparse
>  BASH		= bash
> +GZIP		= gzip
> +BZIP2		= bzip2
> +LZOP		= lzop
> +LZMA		= lzma
> +LZ4		= lz4c
> +XZ		= xz
> +
> +# GZIP, BZIP2, LZOP env vars are used by the tools. Support them as the command
> +# line interface, but use _GZIP, _BZIP2, _LZOP internally.
> +_GZIP          := $(GZIP)
> +_BZIP2         := $(BZIP2)
> +_LZOP          := $(LZOP)
> +
> +# Reset GZIP, BZIP2, LZOP in this Makefile
> +override GZIP=
> +override BZIP2=
> +override LZOP=
> +
> +# Reset GZIP, BZIP2, LZOP in recursive invocations
> +MAKEOVERRIDES += GZIP= BZIP2= LZOP=
>  
>  CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
>  		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
> @@ -474,6 +494,7 @@ CLANG_FLAGS :=
>  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
>  export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE PAHOLE LEX YACC AWK INSTALLKERNEL
>  export PERL PYTHON PYTHON2 PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
> +export _GZIP _BZIP2 _LZOP LZMA LZ4 XZ
>  export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
>  
>  export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS
> @@ -981,10 +1002,10 @@ export mod_strip_cmd
>  mod_compress_cmd = true
>  ifdef CONFIG_MODULE_COMPRESS
>    ifdef CONFIG_MODULE_COMPRESS_GZIP
> -    mod_compress_cmd = gzip -n -f
> +    mod_compress_cmd = $(_GZIP) -n -f
>    endif # CONFIG_MODULE_COMPRESS_GZIP
>    ifdef CONFIG_MODULE_COMPRESS_XZ
> -    mod_compress_cmd = xz -f
> +    mod_compress_cmd = $(XZ) -f
>    endif # CONFIG_MODULE_COMPRESS_XZ
>  endif # CONFIG_MODULE_COMPRESS
>  export mod_compress_cmd
> diff --git a/arch/arm/boot/deflate_xip_data.sh b/arch/arm/boot/deflate_xip_data.sh
> index 40937248cebe..739f0464321e 100755
> --- a/arch/arm/boot/deflate_xip_data.sh
> +++ b/arch/arm/boot/deflate_xip_data.sh
> @@ -56,7 +56,7 @@ trap 'rm -f "$XIPIMAGE.tmp"; exit 1' 1 2 3
>  # substitute the data section by a compressed version
>  $DD if="$XIPIMAGE" count=$data_start iflag=count_bytes of="$XIPIMAGE.tmp"
>  $DD if="$XIPIMAGE"  skip=$data_start iflag=skip_bytes |
> -gzip -9 >> "$XIPIMAGE.tmp"
> +$_GZIP -9 >> "$XIPIMAGE.tmp"
>  
>  # replace kernel binary
>  mv -f "$XIPIMAGE.tmp" "$XIPIMAGE"
> diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
> index 32240000dc0c..f817f3d5e758 100644
> --- a/arch/ia64/Makefile
> +++ b/arch/ia64/Makefile
> @@ -40,7 +40,7 @@ $(error Sorry, you need a newer version of the assember, one that is built from
>  endif
>  
>  quiet_cmd_gzip = GZIP    $@
> -cmd_gzip = cat $(real-prereqs) | gzip -n -f -9 > $@
> +cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
>  
>  quiet_cmd_objcopy = OBJCOPY $@
>  cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
> diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
> index 5d9288384096..ce6db5e5a5a3 100644
> --- a/arch/m68k/Makefile
> +++ b/arch/m68k/Makefile
> @@ -135,10 +135,10 @@ vmlinux.gz: vmlinux
>  ifndef CONFIG_KGDB
>  	cp vmlinux vmlinux.tmp
>  	$(STRIP) vmlinux.tmp
> -	gzip -9c vmlinux.tmp >vmlinux.gz
> +	$(_GZIP) -9c vmlinux.tmp >vmlinux.gz
>  	rm vmlinux.tmp
>  else
> -	gzip -9c vmlinux >vmlinux.gz
> +	$(_GZIP) -9c vmlinux >vmlinux.gz
>  endif
>  
>  bzImage: vmlinux.bz2
> @@ -148,10 +148,10 @@ vmlinux.bz2: vmlinux
>  ifndef CONFIG_KGDB
>  	cp vmlinux vmlinux.tmp
>  	$(STRIP) vmlinux.tmp
> -	bzip2 -1c vmlinux.tmp >vmlinux.bz2
> +	$(_BZIP2) -1c vmlinux.tmp >vmlinux.bz2
>  	rm vmlinux.tmp
>  else
> -	bzip2 -1c vmlinux >vmlinux.bz2
> +	$(_BZIP2) -1c vmlinux >vmlinux.bz2
>  endif
>  
>  archclean:
> diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
> index 36b834f1c933..ad4ba8b5d1e4 100644
> --- a/arch/parisc/Makefile
> +++ b/arch/parisc/Makefile
> @@ -156,7 +156,7 @@ vmlinuz: bzImage
>  	$(OBJCOPY) $(boot)/bzImage $@
>  else
>  vmlinuz: vmlinux
> -	@gzip -cf -9 $< > $@
> +	@$(_GZIP) -cf -9 $< > $@
>  endif
>  
>  install:
> diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
> index e13ca842eb7e..c1510f0ab3ea 100755
> --- a/kernel/gen_kheaders.sh
> +++ b/kernel/gen_kheaders.sh
> @@ -88,7 +88,7 @@ find $cpio_dir -type f -print0 |
>  find $cpio_dir -printf "./%P\n" | LC_ALL=C sort | \
>      tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
>      --owner=0 --group=0 --numeric-owner --no-recursion \
> -    -Jcf $tarfile -C $cpio_dir/ -T - > /dev/null
> +    -I $XZ -cf $tarfile -C $cpio_dir/ -T - > /dev/null
>  
>  echo $headers_md5 > kernel/kheaders.md5
>  echo "$this_file_md5" >> kernel/kheaders.md5
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 342618a2bccb..75d3684aceec 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -230,7 +230,7 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
>  # ---------------------------------------------------------------------------
>  
>  quiet_cmd_gzip = GZIP    $@
> -      cmd_gzip = cat $(real-prereqs) | gzip -n -f -9 > $@
> +      cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
>  
>  # DTC
>  # ---------------------------------------------------------------------------
> @@ -322,19 +322,19 @@ printf "%08x\n" $$dec_size |						\
>  )
>  
>  quiet_cmd_bzip2 = BZIP2   $@
> -      cmd_bzip2 = { cat $(real-prereqs) | bzip2 -9; $(size_append); } > $@
> +      cmd_bzip2 = { cat $(real-prereqs) | $(_BZIP2) -9; $(size_append); } > $@
>  
>  # Lzma
>  # ---------------------------------------------------------------------------
>  
>  quiet_cmd_lzma = LZMA    $@
> -      cmd_lzma = { cat $(real-prereqs) | lzma -9; $(size_append); } > $@
> +      cmd_lzma = { cat $(real-prereqs) | $(LZMA) -9; $(size_append); } > $@
>  
>  quiet_cmd_lzo = LZO     $@
> -      cmd_lzo = { cat $(real-prereqs) | lzop -9; $(size_append); } > $@
> +      cmd_lzo = { cat $(real-prereqs) | $(_LZOP) -9; $(size_append); } > $@
>  
>  quiet_cmd_lz4 = LZ4     $@
> -      cmd_lz4 = { cat $(real-prereqs) | lz4c -l -c1 stdin stdout; \
> +      cmd_lz4 = { cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout; \
>                    $(size_append); } > $@
>  
>  # U-Boot mkimage
> @@ -381,7 +381,7 @@ quiet_cmd_xzkern = XZKERN  $@
>                       $(size_append); } > $@
>  
>  quiet_cmd_xzmisc = XZMISC  $@
> -      cmd_xzmisc = cat $(real-prereqs) | xz --check=crc32 --lzma2=dict=1MiB > $@
> +      cmd_xzmisc = cat $(real-prereqs) | $(XZ) --check=crc32 --lzma2=dict=1MiB > $@
>  
>  # ASM offsets
>  # ---------------------------------------------------------------------------
> diff --git a/scripts/Makefile.package b/scripts/Makefile.package
> index 56eadcc48d46..4ea20e6b7e2b 100644
> --- a/scripts/Makefile.package
> +++ b/scripts/Makefile.package
> @@ -45,7 +45,7 @@ if test "$(objtree)" != "$(srctree)"; then \
>  	false; \
>  fi ; \
>  $(srctree)/scripts/setlocalversion --save-scmversion; \
> -tar -cz $(RCS_TAR_IGNORE) -f $(2).tar.gz \
> +tar -I $(_GZIP) -c $(RCS_TAR_IGNORE) -f $(2).tar.gz \
>  	--transform 's:^:$(2)/:S' $(TAR_CONTENT) $(3); \
>  rm -f $(objtree)/.scmversion
>  
> @@ -127,9 +127,9 @@ util/PERF-VERSION-GEN $(CURDIR)/$(perf-tar)/);              \
>  tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
>  rm -r $(perf-tar);                                                  \
>  $(if $(findstring tar-src,$@),,                                     \
> -$(if $(findstring bz2,$@),bzip2,                                    \
> -$(if $(findstring gz,$@),gzip,                                      \
> -$(if $(findstring xz,$@),xz,                                        \
> +$(if $(findstring bz2,$@),$(_BZIP2),                                 \
> +$(if $(findstring gz,$@),$(_GZIP),                                  \
> +$(if $(findstring xz,$@),$(XZ),                                     \
>  $(error unknown target $@))))                                       \
>  	-f -9 $(perf-tar).tar)
>  
> diff --git a/scripts/package/buildtar b/scripts/package/buildtar
> index 2f66c81e4021..4ae3698cd84a 100755
> --- a/scripts/package/buildtar
> +++ b/scripts/package/buildtar
> @@ -28,15 +28,15 @@ case "${1}" in
>  		opts=
>  		;;
>  	targz-pkg)
> -		opts=--gzip
> +		opts="-I ${_GZIP}"
>  		tarball=${tarball}.gz
>  		;;
>  	tarbz2-pkg)
> -		opts=--bzip2
> +		opts="-I ${_BZIP2}"
>  		tarball=${tarball}.bz2
>  		;;
>  	tarxz-pkg)
> -		opts=--xz
> +		opts="-I ${XZ}"
>  		tarball=${tarball}.xz
>  		;;
>  	*)
> diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
> index 7a2d372f4885..76e9cbcfbeab 100755
> --- a/scripts/xz_wrap.sh
> +++ b/scripts/xz_wrap.sh
> @@ -20,4 +20,4 @@ case $SRCARCH in
>  	sparc)          BCJ=--sparc ;;
>  esac
>  
> -exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
> +exec $XZ --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
> 
