Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6973D4618C9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378611AbhK2OeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378796AbhK2OcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 09:32:21 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D60C0698D7
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 05:06:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b1so44277728lfs.13
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 05:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjnQOEpXvHFr1onOqtjnt0Q0N+sdiy94/AI2AfR0PGM=;
        b=kjhfZlJ4+z4x7lnQZ4W9DU7AdxmoHxbzH37ttXLd30FBrsmTrKUpXDZFD8cz0rQkf7
         yiXq6dsb9WK+JneHavIhd6VBI5rVib+FlVTp/ytIAE05Yr8GEsWl3Ua5yTqixXfnN5DU
         SYRoLRIwmtIi9wDf+dERdunzEy5ChePrW9UdvBuGAZb1y5VvZIRCRmjO2XISaJ352Eg1
         gcX0SgQWBp8qVoGgDJSIJ7Iy2QkPUAXNo92V/xQ82wV4SH6sJ/5d67txq4hcnTHXlyOx
         4uYwv1QA4JZc94vZ9/xGA3THsyUF7S7UFv08W2Mq4Ot4FJ/IMsEf15iy4my0lfHMmFa3
         MsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjnQOEpXvHFr1onOqtjnt0Q0N+sdiy94/AI2AfR0PGM=;
        b=rQQNAsJ7O8Kre7Z0dICo7Burph3/YybeKBRTRnNb2jjyEMTYY6XoIErgDLOk44dHSq
         8JxnZsaDiZPjVTKdLNBeORZdfaXgR7kWRawMRhxmXRCmfNRrORx1bEYI01s2x/XRvzxj
         GBJiz8yuNU/AcJcPd/meW3AdGtxyYrseaVIh+9obJcFy554PhLeg0XdDCPPkMTPGGUgD
         7nTSLjL3ILtmal8PeRCwVkrFNTuDlMNygRoUkRU67O0lsuS3TX/Rr0/aRXpykZr1AhtF
         VcT87F6UctQsH1iU3JdD5zk/h+Wuir0ROJG1c+L0XZeY0uAzpaQmn9qahIQe7Pv2pTWA
         CZcQ==
X-Gm-Message-State: AOAM530RutlNBGeWz4xDKc+QI9SfanPb1MKhpDAa3OaHL7JXGaVHNSla
        RyoZg4JYb5FSaqokxOzYo8Kh9melNug=
X-Google-Smtp-Source: ABdhPJygVTQrh+NdjD8Zfzk3ZOWHh0v3GYx9em/F/hikbm+GD+wm+b3sI99+DKirHYN7h4tdTCygBw==
X-Received: by 2002:a05:6512:2111:: with SMTP id q17mr47083807lfr.371.1638191193333;
        Mon, 29 Nov 2021 05:06:33 -0800 (PST)
Received: from octofox.metropolis ([5.18.187.11])
        by smtp.gmail.com with ESMTPSA id m15sm1334959lfg.165.2021.11.29.05.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 05:06:32 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] xtensa: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Mon, 29 Nov 2021 05:06:26 -0800
Message-Id: <20211129130626.25163-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit d67ed2510d28a1eb33171010d35cf52178cfcbdd upstream.

CONFIG_OF can be set by a randconfig or by a user -- without setting the
early flattree option (OF_EARLY_FLATTREE).  This causes build errors.
However, if randconfig or a user sets USE_OF in the Xtensa config,
the right kconfig symbols are set to fix the build.

Fixes these build errors:

../arch/xtensa/kernel/setup.c:67:19: error: ‘__dtb_start’ undeclared here (not in a function); did you mean ‘dtb_start’?
   67 | void *dtb_start = __dtb_start;
      |                   ^~~~~~~~~~~
../arch/xtensa/kernel/setup.c: In function 'xtensa_dt_io_area':
../arch/xtensa/kernel/setup.c:201:14: error: implicit declaration of function 'of_flat_dt_is_compatible'; did you mean 'of_machine_is_compatible'? [-Werror=implicit-function-declaration]
  201 |         if (!of_flat_dt_is_compatible(node, "simple-bus"))
../arch/xtensa/kernel/setup.c:204:18: error: implicit declaration of function 'of_get_flat_dt_prop' [-Werror=implicit-function-declaration]
  204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
../arch/xtensa/kernel/setup.c:204:16: error: assignment to 'const __be32 *' {aka 'const unsigned int *'} from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
      |                ^
../arch/xtensa/kernel/setup.c: In function 'early_init_devtree':
../arch/xtensa/kernel/setup.c:228:9: error: implicit declaration of function 'early_init_dt_scan'; did you mean 'early_init_devtree'? [-Werror=implicit-function-declaration]
  228 |         early_init_dt_scan(params);
../arch/xtensa/kernel/setup.c:229:9: error: implicit declaration of function 'of_scan_flat_dt' [-Werror=implicit-function-declaration]
  229 |         of_scan_flat_dt(xtensa_dt_io_area, NULL);

xtensa-elf-ld: arch/xtensa/mm/mmu.o:(.text+0x0): undefined reference to `xtensa_kio_paddr'

Fixes: da844a81779e ("xtensa: add device trees support")
Fixes: 6cb971114f63 ("xtensa: remap io area defined in device tree")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/vectors.h |  2 +-
 arch/xtensa/kernel/setup.c        | 12 ++++++------
 arch/xtensa/mm/mmu.c              |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/xtensa/include/asm/vectors.h b/arch/xtensa/include/asm/vectors.h
index 7111280c8842..2d3e0cca9ba0 100644
--- a/arch/xtensa/include/asm/vectors.h
+++ b/arch/xtensa/include/asm/vectors.h
@@ -31,7 +31,7 @@
 #endif
 #define XCHAL_KIO_SIZE			0x10000000
 
-#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_OF)
+#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_USE_OF)
 #define XCHAL_KIO_PADDR			xtensa_get_kio_paddr()
 #ifndef __ASSEMBLY__
 extern unsigned long xtensa_kio_paddr;
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 6a0167ac803c..901990b8296c 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -65,7 +65,7 @@ int initrd_is_mapped = 0;
 extern int initrd_below_start_ok;
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 void *dtb_start = __dtb_start;
 #endif
 
@@ -127,7 +127,7 @@ __tagtable(BP_TAG_INITRD, parse_tag_initrd);
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static int __init parse_tag_fdt(const bp_tag_t *tag)
 {
@@ -137,7 +137,7 @@ static int __init parse_tag_fdt(const bp_tag_t *tag)
 
 __tagtable(BP_TAG_FDT, parse_tag_fdt);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 static int __init parse_tag_cmdline(const bp_tag_t* tag)
 {
@@ -185,7 +185,7 @@ static int __init parse_bootparam(const bp_tag_t *tag)
 }
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 #if !XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY
 unsigned long xtensa_kio_paddr = XCHAL_KIO_DEFAULT_PADDR;
@@ -234,7 +234,7 @@ void __init early_init_devtree(void *params)
 		strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 }
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 /*
  * Initialize architecture. (Early stage)
@@ -255,7 +255,7 @@ void __init init_arch(bp_tag_t *bp_start)
 	if (bp_start)
 		parse_bootparam(bp_start);
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 	early_init_devtree(dtb_start);
 #endif
 
diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
index 9d1ecfc53670..470843188f2f 100644
--- a/arch/xtensa/mm/mmu.c
+++ b/arch/xtensa/mm/mmu.c
@@ -98,7 +98,7 @@ void init_mmu(void)
 
 void init_kio(void)
 {
-#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_OF)
+#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_USE_OF)
 	/*
 	 * Update the IO area mapping in case xtensa_kio_paddr has changed
 	 */
-- 
2.20.1

