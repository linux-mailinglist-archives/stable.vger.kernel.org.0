Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6A2534E6
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgHZQ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgHZQ2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:51 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7A8C0613ED
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q12so1972888qvm.19
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8H3XgcOmOoNvmSuV4rJYIDWpnf3ENBRg6T4MvewnKfk=;
        b=G5W+/Os1+dJjHutoktb9Rh9Um3081d+ky2OMn4cpewJHI1FpkqUBduFEJsRLq1cFHi
         /yYwghFjr7BQ0LV7hy5/+8xdsBImX18vmoJ7hYV+v7GnN15hsH+AnMO5j6BzdRqdgAIS
         qW+BCtgIuocKtr2G1YGT41nwhOEHXvxa9a+S4+gOQkMIWBJ4UmHDyndTL2iDLylOYw4L
         xAPec0M3N+mgmJqsq3p/7bR32CZnbutojgaEgj5SMtHTpdpaT9jr2wjNnWZ8rYeBrMCr
         oAOl5vspbVmI9WndfBtKQzFNpgUiriBmp5vEPBUaRGhjWLpZXd/KyL2VwFS4Hng57eUb
         3H7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8H3XgcOmOoNvmSuV4rJYIDWpnf3ENBRg6T4MvewnKfk=;
        b=S4JZicye1UXgzF4pQ2ORpi7gCWmapsyTc0ipirX/d63tZoK2Bce4ItXROmC4249Zs4
         cHddG+bZof4y4rI8CLkWQiN5l1cA6NiIsSFv+MGaV6ugXShuCIqpI7Hl4snV27KRE57Z
         R45Id9kBlWUu6/6IUkENjnahI3NxpHtg7zfaj/CFYdHONgW0ZVZaWM12Pn1paIJYnuXr
         PvD74/WW6FSjgZEDbkLJU7b1JVpbmeVplEvtxUhvcVXu3sPAqUhRMgDPsDn9FJjw0cWN
         EkrNo8Yg62mQ24eDYtOkCOxm6obpdPjYullNk/juaTLG0wbSkmMshU5SwpeAjfaaviwh
         sKiw==
X-Gm-Message-State: AOAM533HRYAUkeo4R2ME/QYbB30X5ozdS1UhcZiiw4A+5kcmR9AOZGfD
        NLq9ZJqjts1p99EH67kSO1q/t7PkEvoCCQrEAnN27cXwOSCUfVJK0b29ZHXh/W9p2XpPGkmJQn6
        hOZAodIFq++fFB1cHQph6RK24XfEfopPamJ7k4hoCif4oe4OUrCEXlNBZi+ToWaeV5EE=
X-Google-Smtp-Source: ABdhPJzCxcgLjK7AkhHxNklENdUDcsE1JXkq/LcyK3DEGu/oPnXuReLIWXgJGrvtabvv7Yv0IzBKZCJvgQ3USg==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:ad4:4365:: with SMTP id
 u5mr14710124qvt.109.1598459328397; Wed, 26 Aug 2020 09:28:48 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:28 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-7-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 6/6] kbuild: add variables for compression tools
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Allow user to use alternative implementations of compression tools,
such as pigz, pbzip2, pxz. For example, multi-threaded tools to
speed up the build:
$ make GZIP=pigz BZIP2=pbzip2

Variables _GZIP, _BZIP2, _LZOP are used internally because original env
vars are reserved by the tools. The use of GZIP in gzip tool is obsolete
since 2015. However, alternative implementations (e.g., pigz) still rely
on it. BZIP2, BZIP, LZOP vars are not obsolescent.

The credit goes to @grsecurity.

As a sidenote, for multi-threaded lzma, xz compression one can use:
$ export XZ_OPT="--threads=0"

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
(cherry picked from commit 8dfb61dcbaceb19a5ded5e9c9dcf8d05acc32294)
Signed-off-by: Matthias Maennich <maennich@google.com>
Change-Id: Idaa5daac69c820c78e32b4630f3d72739e74be12
---
 Makefile                          | 25 +++++++++++++++++++++++--
 arch/arm/boot/deflate_xip_data.sh |  2 +-
 arch/ia64/Makefile                |  2 +-
 arch/m68k/Makefile                |  8 ++++----
 arch/parisc/Makefile              |  2 +-
 kernel/gen_kheaders.sh            |  2 +-
 scripts/Makefile.lib              | 12 ++++++------
 scripts/Makefile.package          |  8 ++++----
 scripts/package/buildtar          |  6 +++---
 scripts/xz_wrap.sh                |  2 +-
 10 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/Makefile b/Makefile
index 7c001e21e28e..3521ba6097a7 100644
--- a/Makefile
+++ b/Makefile
@@ -426,6 +426,26 @@ PYTHON2		= python2
 PYTHON3		= python3
 CHECK		= sparse
 BASH		= bash
+GZIP		= gzip
+BZIP2		= bzip2
+LZOP		= lzop
+LZMA		= lzma
+LZ4		= lz4c
+XZ		= xz
+
+# GZIP, BZIP2, LZOP env vars are used by the tools. Support them as the command
+# line interface, but use _GZIP, _BZIP2, _LZOP internally.
+_GZIP          := $(GZIP)
+_BZIP2         := $(BZIP2)
+_LZOP          := $(LZOP)
+
+# Reset GZIP, BZIP2, LZOP in this Makefile
+override GZIP=
+override BZIP2=
+override LZOP=
+
+# Reset GZIP, BZIP2, LZOP in recursive invocations
+MAKEOVERRIDES += GZIP= BZIP2= LZOP=
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
@@ -474,6 +494,7 @@ CLANG_FLAGS :=
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE PAHOLE LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON PYTHON2 PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
+export _GZIP _BZIP2 _LZOP LZMA LZ4 XZ
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS
@@ -981,10 +1002,10 @@ export mod_strip_cmd
 mod_compress_cmd = true
 ifdef CONFIG_MODULE_COMPRESS
   ifdef CONFIG_MODULE_COMPRESS_GZIP
-    mod_compress_cmd = gzip -n -f
+    mod_compress_cmd = $(_GZIP) -n -f
   endif # CONFIG_MODULE_COMPRESS_GZIP
   ifdef CONFIG_MODULE_COMPRESS_XZ
-    mod_compress_cmd = xz -f
+    mod_compress_cmd = $(XZ) -f
   endif # CONFIG_MODULE_COMPRESS_XZ
 endif # CONFIG_MODULE_COMPRESS
 export mod_compress_cmd
diff --git a/arch/arm/boot/deflate_xip_data.sh b/arch/arm/boot/deflate_xip_data.sh
index 40937248cebe..739f0464321e 100755
--- a/arch/arm/boot/deflate_xip_data.sh
+++ b/arch/arm/boot/deflate_xip_data.sh
@@ -56,7 +56,7 @@ trap 'rm -f "$XIPIMAGE.tmp"; exit 1' 1 2 3
 # substitute the data section by a compressed version
 $DD if="$XIPIMAGE" count=$data_start iflag=count_bytes of="$XIPIMAGE.tmp"
 $DD if="$XIPIMAGE"  skip=$data_start iflag=skip_bytes |
-gzip -9 >> "$XIPIMAGE.tmp"
+$_GZIP -9 >> "$XIPIMAGE.tmp"
 
 # replace kernel binary
 mv -f "$XIPIMAGE.tmp" "$XIPIMAGE"
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 32240000dc0c..f817f3d5e758 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -40,7 +40,7 @@ $(error Sorry, you need a newer version of the assember, one that is built from
 endif
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = cat $(real-prereqs) | gzip -n -f -9 > $@
+cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
 
 quiet_cmd_objcopy = OBJCOPY $@
 cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 5d9288384096..ce6db5e5a5a3 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -135,10 +135,10 @@ vmlinux.gz: vmlinux
 ifndef CONFIG_KGDB
 	cp vmlinux vmlinux.tmp
 	$(STRIP) vmlinux.tmp
-	gzip -9c vmlinux.tmp >vmlinux.gz
+	$(_GZIP) -9c vmlinux.tmp >vmlinux.gz
 	rm vmlinux.tmp
 else
-	gzip -9c vmlinux >vmlinux.gz
+	$(_GZIP) -9c vmlinux >vmlinux.gz
 endif
 
 bzImage: vmlinux.bz2
@@ -148,10 +148,10 @@ vmlinux.bz2: vmlinux
 ifndef CONFIG_KGDB
 	cp vmlinux vmlinux.tmp
 	$(STRIP) vmlinux.tmp
-	bzip2 -1c vmlinux.tmp >vmlinux.bz2
+	$(_BZIP2) -1c vmlinux.tmp >vmlinux.bz2
 	rm vmlinux.tmp
 else
-	bzip2 -1c vmlinux >vmlinux.bz2
+	$(_BZIP2) -1c vmlinux >vmlinux.bz2
 endif
 
 archclean:
diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 36b834f1c933..ad4ba8b5d1e4 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -156,7 +156,7 @@ vmlinuz: bzImage
 	$(OBJCOPY) $(boot)/bzImage $@
 else
 vmlinuz: vmlinux
-	@gzip -cf -9 $< > $@
+	@$(_GZIP) -cf -9 $< > $@
 endif
 
 install:
diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index e13ca842eb7e..c1510f0ab3ea 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -88,7 +88,7 @@ find $cpio_dir -type f -print0 |
 find $cpio_dir -printf "./%P\n" | LC_ALL=C sort | \
     tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
     --owner=0 --group=0 --numeric-owner --no-recursion \
-    -Jcf $tarfile -C $cpio_dir/ -T - > /dev/null
+    -I $XZ -cf $tarfile -C $cpio_dir/ -T - > /dev/null
 
 echo $headers_md5 > kernel/kheaders.md5
 echo "$this_file_md5" >> kernel/kheaders.md5
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 342618a2bccb..75d3684aceec 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -230,7 +230,7 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-      cmd_gzip = cat $(real-prereqs) | gzip -n -f -9 > $@
+      cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
 
 # DTC
 # ---------------------------------------------------------------------------
@@ -322,19 +322,19 @@ printf "%08x\n" $$dec_size |						\
 )
 
 quiet_cmd_bzip2 = BZIP2   $@
-      cmd_bzip2 = { cat $(real-prereqs) | bzip2 -9; $(size_append); } > $@
+      cmd_bzip2 = { cat $(real-prereqs) | $(_BZIP2) -9; $(size_append); } > $@
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-      cmd_lzma = { cat $(real-prereqs) | lzma -9; $(size_append); } > $@
+      cmd_lzma = { cat $(real-prereqs) | $(LZMA) -9; $(size_append); } > $@
 
 quiet_cmd_lzo = LZO     $@
-      cmd_lzo = { cat $(real-prereqs) | lzop -9; $(size_append); } > $@
+      cmd_lzo = { cat $(real-prereqs) | $(_LZOP) -9; $(size_append); } > $@
 
 quiet_cmd_lz4 = LZ4     $@
-      cmd_lz4 = { cat $(real-prereqs) | lz4c -l -c1 stdin stdout; \
+      cmd_lz4 = { cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout; \
                   $(size_append); } > $@
 
 # U-Boot mkimage
@@ -381,7 +381,7 @@ quiet_cmd_xzkern = XZKERN  $@
                      $(size_append); } > $@
 
 quiet_cmd_xzmisc = XZMISC  $@
-      cmd_xzmisc = cat $(real-prereqs) | xz --check=crc32 --lzma2=dict=1MiB > $@
+      cmd_xzmisc = cat $(real-prereqs) | $(XZ) --check=crc32 --lzma2=dict=1MiB > $@
 
 # ASM offsets
 # ---------------------------------------------------------------------------
diff --git a/scripts/Makefile.package b/scripts/Makefile.package
index 56eadcc48d46..4ea20e6b7e2b 100644
--- a/scripts/Makefile.package
+++ b/scripts/Makefile.package
@@ -45,7 +45,7 @@ if test "$(objtree)" != "$(srctree)"; then \
 	false; \
 fi ; \
 $(srctree)/scripts/setlocalversion --save-scmversion; \
-tar -cz $(RCS_TAR_IGNORE) -f $(2).tar.gz \
+tar -I $(_GZIP) -c $(RCS_TAR_IGNORE) -f $(2).tar.gz \
 	--transform 's:^:$(2)/:S' $(TAR_CONTENT) $(3); \
 rm -f $(objtree)/.scmversion
 
@@ -127,9 +127,9 @@ util/PERF-VERSION-GEN $(CURDIR)/$(perf-tar)/);              \
 tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
-$(if $(findstring bz2,$@),bzip2,                                    \
-$(if $(findstring gz,$@),gzip,                                      \
-$(if $(findstring xz,$@),xz,                                        \
+$(if $(findstring bz2,$@),$(_BZIP2),                                 \
+$(if $(findstring gz,$@),$(_GZIP),                                  \
+$(if $(findstring xz,$@),$(XZ),                                     \
 $(error unknown target $@))))                                       \
 	-f -9 $(perf-tar).tar)
 
diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 2f66c81e4021..4ae3698cd84a 100755
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -28,15 +28,15 @@ case "${1}" in
 		opts=
 		;;
 	targz-pkg)
-		opts=--gzip
+		opts="-I ${_GZIP}"
 		tarball=${tarball}.gz
 		;;
 	tarbz2-pkg)
-		opts=--bzip2
+		opts="-I ${_BZIP2}"
 		tarball=${tarball}.bz2
 		;;
 	tarxz-pkg)
-		opts=--xz
+		opts="-I ${XZ}"
 		tarball=${tarball}.xz
 		;;
 	*)
diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
index 7a2d372f4885..76e9cbcfbeab 100755
--- a/scripts/xz_wrap.sh
+++ b/scripts/xz_wrap.sh
@@ -20,4 +20,4 @@ case $SRCARCH in
 	sparc)          BCJ=--sparc ;;
 esac
 
-exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
+exec $XZ --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
-- 
2.28.0.297.g1956fa8f8d-goog

