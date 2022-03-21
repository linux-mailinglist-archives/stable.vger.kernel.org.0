Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE04E2B2E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349584AbiCUOtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240430AbiCUOtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EE65FF1E
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 07:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EAA2B81711
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC304C340E8;
        Mon, 21 Mar 2022 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647874070;
        bh=7g8IA8wDExM9y3CWJrWbBdKs/6M9/qvs5e73PmguyAk=;
        h=From:To:Cc:Subject:Date:From;
        b=oU/yI8yrLofrTemuL6rE8UYVDXSCTGQjkat8rPouuhG62LUwl+0uUXQgpdH6p4wrA
         H0VGWIvNErVhcZFxLAe3XwmtS9qbfnQw97YZsOuHM9HrkCVhXDFGs6J7FMTPGORuXX
         qcCH8IUqt8fFTzXlOv0qkzoSd0TIPdAB01nEO1qdyuokJWgTv+7chkoAUuB4EQkY64
         +HD3NwDPtLC4g2SH3uQ4B4mP7jp8W1emxGNelq9XZ6DwFuzlU7BxS13pCGNZ5RyCF8
         TF6Hs+9XVxPtOkhKT2cbP3oNQgi4oD8IWucHvaWhHvUSAFBE0SzDUHZcAMcZyHaMr2
         vWE96/KM6XMOQ==
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH stable-5.15] MAINTAINERS: update Krzysztof Kozlowski's email
Date:   Mon, 21 Mar 2022 15:47:43 +0100
Message-Id: <20220321144743.17896-1-krzk@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 5125091d757a251a128ec38d2397c9d160394eac upstream.

Use Krzysztof Kozlowski's @kernel.org account in maintainer entries.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220307172805.156760-1-krzysztof.kozlowski@canonical.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .mailmap    |  1 +
 MAINTAINERS | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/.mailmap b/.mailmap
index 90e614d2bf7e..243fb1c728b3 100644
--- a/.mailmap
+++ b/.mailmap
@@ -196,6 +196,7 @@ Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
 Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski.k@gmail.com>
 Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski@samsung.com>
+Krzysztof Kozlowski <krzk@kernel.org> <krzysztof.kozlowski@canonical.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index c8103e57a70b..10ad85379afa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2494,7 +2494,7 @@ F:	sound/soc/rockchip/
 N:	rockchip
 
 ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
@@ -11406,7 +11406,7 @@ F:	drivers/regulator/max77802-regulator.c
 F:	include/dt-bindings/*/*max77802.h
 
 MAXIM MUIC CHARGER DRIVERS FOR EXYNOS BASED BOARDS
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
 L:	linux-pm@vger.kernel.org
 S:	Supported
@@ -11415,7 +11415,7 @@ F:	drivers/power/supply/max77693_charger.c
 
 MAXIM PMIC AND MUIC DRIVERS FOR EXYNOS BASED BOARDS
 M:	Chanwoo Choi <cw00.choi@samsung.com>
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
@@ -12087,7 +12087,7 @@ F:	include/linux/memblock.h
 F:	mm/memblock.c
 
 MEMORY CONTROLLER DRIVERS
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux-mem-ctrl.git
@@ -13206,7 +13206,7 @@ F:	include/uapi/linux/nexthop.h
 F:	net/ipv4/nexthop.c
 
 NFC SUBSYSTEM
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-nfc@lists.01.org (subscribers-only)
 L:	netdev@vger.kernel.org
 S:	Maintained
@@ -13489,7 +13489,7 @@ F:	Documentation/devicetree/bindings/regulator/nxp,pf8x00-regulator.yaml
 F:	drivers/regulator/pf8x00-regulator.c
 
 NXP PTN5150A CC LOGIC AND EXTCON DRIVER
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/extcon/extcon-ptn5150.yaml
@@ -14851,7 +14851,7 @@ F:	drivers/pinctrl/renesas/
 
 PIN CONTROLLER - SAMSUNG
 M:	Tomasz Figa <tomasz.figa@gmail.com>
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org
@@ -16427,7 +16427,7 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 F:	drivers/s390/scsi/zfcp_*
 
 S3C ADC BATTERY DRIVER
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-samsung-soc@vger.kernel.org
 S:	Odd Fixes
 F:	drivers/power/supply/s3c_adc_battery.c
@@ -16472,7 +16472,7 @@ F:	Documentation/admin-guide/LSM/SafeSetID.rst
 F:	security/safesetid/
 
 SAMSUNG AUDIO (ASoC) DRIVERS
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
@@ -16480,7 +16480,7 @@ F:	Documentation/devicetree/bindings/sound/samsung*
 F:	sound/soc/samsung/
 
 SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (RNG) DRIVER
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
@@ -16515,7 +16515,7 @@ S:	Maintained
 F:	drivers/platform/x86/samsung-laptop.c
 
 SAMSUNG MULTIFUNCTION PMIC DEVICE DRIVERS
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
@@ -16540,7 +16540,7 @@ F:	drivers/media/platform/s3c-camif/
 F:	include/media/drv-intf/s3c_camif.h
 
 SAMSUNG S3FWRN5 NFC DRIVER
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Krzysztof Opasiak <k.opasiak@samsung.com>
 L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Maintained
@@ -16560,7 +16560,7 @@ S:	Supported
 F:	drivers/media/i2c/s5k5baf.c
 
 SAMSUNG S5P Security SubSystem (SSS) DRIVER
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Vladimir Zapolskiy <vz@mleia.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
@@ -16596,7 +16596,7 @@ F:	include/linux/clk/samsung.h
 F:	include/linux/platform_data/clk-s3c2410.h
 
 SAMSUNG SPI DRIVERS
-M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Andi Shyti <andi@etezian.org>
 L:	linux-spi@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
-- 
2.32.0

