Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0BE2265EF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbgGTP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732078AbgGTP6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9B820773;
        Mon, 20 Jul 2020 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260724;
        bh=kAH2deOEsOqfQSsPVfGKwivtT8DMSu/09obRN5RciMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3yiTGwf86cxDdFX393xCU+CcuRKu3NDojuTik1ozFU4qLh5YJWT0E/Fjncvjxy8V
         GveKLu+eVK3FmoYHkNYczku6To0kAelglKdpy+6DRUaGTV4i+KTMVy4hHoeOsU79IN
         2l8TaAkPmiWkoU3i/lCfAkBbvhwNgB+vPhuoBWsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/215] scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled
Date:   Mon, 20 Jul 2020 17:35:55 +0200
Message-Id: <20200720152823.686881300@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diego Elio Pettenò <flameeyes@flameeyes.com>

[ Upstream commit 679b2ec8e060ca7a90441aff5e7d384720a41b76 ]

This kernel configuration is basically enabling/disabling sr driver quirks
detection. While these quirks are for fairly rare devices (very old CD
burners, and a glucometer), the additional detection of these models is a
very minimal amount of code.

The logic behind the quirks is always built into the sr driver.

This also removes the config from all the defconfig files that are enabling
this already.

Link: https://lore.kernel.org/r/20200223191144.726-1-flameeyes@flameeyes.com
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/configs/defconfig                | 1 -
 arch/arm/configs/rpc_defconfig              | 1 -
 arch/arm/configs/s3c2410_defconfig          | 1 -
 arch/ia64/configs/zx1_defconfig             | 1 -
 arch/m68k/configs/amiga_defconfig           | 1 -
 arch/m68k/configs/apollo_defconfig          | 1 -
 arch/m68k/configs/atari_defconfig           | 1 -
 arch/m68k/configs/bvme6000_defconfig        | 1 -
 arch/m68k/configs/hp300_defconfig           | 1 -
 arch/m68k/configs/mac_defconfig             | 1 -
 arch/m68k/configs/multi_defconfig           | 1 -
 arch/m68k/configs/mvme147_defconfig         | 1 -
 arch/m68k/configs/mvme16x_defconfig         | 1 -
 arch/m68k/configs/q40_defconfig             | 1 -
 arch/m68k/configs/sun3_defconfig            | 1 -
 arch/m68k/configs/sun3x_defconfig           | 1 -
 arch/mips/configs/bigsur_defconfig          | 1 -
 arch/mips/configs/fuloong2e_defconfig       | 1 -
 arch/mips/configs/ip27_defconfig            | 1 -
 arch/mips/configs/ip32_defconfig            | 1 -
 arch/mips/configs/jazz_defconfig            | 1 -
 arch/mips/configs/malta_defconfig           | 1 -
 arch/mips/configs/malta_kvm_defconfig       | 1 -
 arch/mips/configs/malta_kvm_guest_defconfig | 1 -
 arch/mips/configs/maltaup_xpa_defconfig     | 1 -
 arch/mips/configs/rm200_defconfig           | 1 -
 arch/powerpc/configs/85xx-hw.config         | 1 -
 arch/powerpc/configs/amigaone_defconfig     | 1 -
 arch/powerpc/configs/chrp32_defconfig       | 1 -
 arch/powerpc/configs/g5_defconfig           | 1 -
 arch/powerpc/configs/maple_defconfig        | 1 -
 arch/powerpc/configs/pasemi_defconfig       | 1 -
 arch/powerpc/configs/pmac32_defconfig       | 1 -
 arch/powerpc/configs/powernv_defconfig      | 1 -
 arch/powerpc/configs/ppc64_defconfig        | 1 -
 arch/powerpc/configs/ppc64e_defconfig       | 1 -
 arch/powerpc/configs/ppc6xx_defconfig       | 1 -
 arch/powerpc/configs/pseries_defconfig      | 1 -
 arch/powerpc/configs/skiroot_defconfig      | 1 -
 arch/sh/configs/sh03_defconfig              | 1 -
 arch/sparc/configs/sparc64_defconfig        | 1 -
 arch/x86/configs/i386_defconfig             | 1 -
 arch/x86/configs/x86_64_defconfig           | 1 -
 drivers/scsi/Kconfig                        | 9 ---------
 drivers/scsi/sr_vendor.c                    | 8 --------
 45 files changed, 60 deletions(-)

diff --git a/arch/alpha/configs/defconfig b/arch/alpha/configs/defconfig
index f4ec420d7f2df..3a132c91d45bc 100644
--- a/arch/alpha/configs/defconfig
+++ b/arch/alpha/configs/defconfig
@@ -36,7 +36,6 @@ CONFIG_BLK_DEV_CY82C693=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_AIC7XXX=m
 CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
 # CONFIG_AIC7XXX_DEBUG_ENABLE is not set
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 3b82b64950d96..c090643b1ecbc 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -32,7 +32,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 73ed73a8785a0..153009130dab3 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -202,7 +202,6 @@ CONFIG_EEPROM_AT24=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index 8c92e095f8bb9..d42f79a33e912 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -35,7 +35,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 9a33c1c006a1f..cf8103fa2f347 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -334,7 +334,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 7fdbc797a05d4..5636288a4b457 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -319,7 +319,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index f1763405a5396..015a7f401ffd5 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -334,7 +334,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 91154d6acb313..1209430e61e13 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -316,7 +316,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index c398c4a94d95c..a41b16067f5c3 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -318,7 +318,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 350d004559be8..8af104a8c000a 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -325,7 +325,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index b838dd820348e..354ff30e22c9c 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -358,7 +358,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 3f8dd61559cf0..eac7685cea427 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -315,7 +315,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index ae3b2d4f636c7..0f38c4a3c87ae 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -316,7 +316,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index cd61ef14b5828..6ede6869db1cd 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -324,7 +324,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 151f5371cd3d4..8644c47899382 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -313,7 +313,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 1dcb0ee1fe989..f2fd0da2346e5 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -313,7 +313,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index f14ad0538f4e3..eea9b613bb740 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -112,7 +112,6 @@ CONFIG_BLK_DEV_TC86C001=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_ATA=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 7a7af706e8981..c5f66b7f2b227 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -99,7 +99,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 82d942a6026e5..638d7cf5ef01d 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -99,7 +99,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 370884018aad1..7b1fab5183170 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -50,7 +50,6 @@ CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 328d4dfeb4cbe..982b990469afd 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -191,7 +191,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 59eedf55419da..211bd3d6e6cb3 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -239,7 +239,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 8ef612552a196..62b1969b4f55b 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -247,7 +247,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/malta_kvm_guest_defconfig b/arch/mips/configs/malta_kvm_guest_defconfig
index d2a008c9907c6..9185e0a0aa455 100644
--- a/arch/mips/configs/malta_kvm_guest_defconfig
+++ b/arch/mips/configs/malta_kvm_guest_defconfig
@@ -245,7 +245,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 970df6d427283..636311d67a533 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -245,7 +245,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2c7adea7638f5..30d7c3db884e4 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -203,7 +203,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index 9575a38c9155b..b507df6ac69fa 100644
--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -2,7 +2,6 @@ CONFIG_AQUANTIA_PHY=y
 CONFIG_AT803X_PHY=y
 CONFIG_ATA=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BROADCOM_PHY=y
 CONFIG_C293_PCIE=y
diff --git a/arch/powerpc/configs/amigaone_defconfig b/arch/powerpc/configs/amigaone_defconfig
index cf94d28d0e310..340140160c7b5 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -47,7 +47,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index 9ff493dd8439b..6c5a4414e9ee4 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -45,7 +45,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index fbfcc85e4dc01..a68c7f3af10ed 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -62,7 +62,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 2975e64629aa8..161351a18517b 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -41,7 +41,6 @@ CONFIG_BLK_DEV_RAM_SIZE=8192
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_IPR=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 4b6d31d4474e8..08b7f4cef2434 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -60,7 +60,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 4e6e95f926460..5cad09f935621 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -119,7 +119,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index 6658cceb928c6..2a7c53cc2f83e 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -111,7 +111,6 @@ CONFIG_BLK_DEV_NVME=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index b250e6f5a7ca7..5569d36066dc7 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -110,7 +110,6 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 0d746774c2bde..33a01a9e86be4 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -60,7 +60,6 @@ CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 9dca4cffa623d..1372a1a7517ad 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -372,7 +372,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 26126b4d4de33..d58686a66388f 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -97,7 +97,6 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1253482a67c0d..2e25b264f70fb 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -83,7 +83,6 @@ CONFIG_EEPROM_AT24=m
 # CONFIG_OCXL is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index e5beb625ab888..87db9a84b5eca 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -46,7 +46,6 @@ CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_SCSI=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 6c325d53a20a0..bde4d21a8ac8e 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -73,7 +73,6 @@ CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 59ce9ed584306..18806b4fb26a9 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -137,7 +137,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index d0a5ffeae8dfd..3087c5e351e7e 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -136,7 +136,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 90cf4691b8c35..9ea30fcb44282 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -114,15 +114,6 @@ config BLK_DEV_SR
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called sr_mod.
 
-config BLK_DEV_SR_VENDOR
-	bool "Enable vendor-specific extensions (for SCSI CDROM)"
-	depends on BLK_DEV_SR
-	help
-	  This enables the usage of vendor specific SCSI commands. This is
-	  required to support multisession CDs with old NEC/TOSHIBA cdrom
-	  drives (and HP Writers). If you have such a drive and get the first
-	  session only, try saying Y here; everybody else says N.
-
 config CHR_DEV_SG
 	tristate "SCSI generic support"
 	depends on SCSI
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index e3b0ce25162ba..b9db2ec6d0361 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -66,9 +66,6 @@
 
 void sr_vendor_init(Scsi_CD *cd)
 {
-#ifndef CONFIG_BLK_DEV_SR_VENDOR
-	cd->vendor = VENDOR_SCSI3;
-#else
 	const char *vendor = cd->device->vendor;
 	const char *model = cd->device->model;
 	
@@ -100,7 +97,6 @@ void sr_vendor_init(Scsi_CD *cd)
 		cd->vendor = VENDOR_TOSHIBA;
 
 	}
-#endif
 }
 
 
@@ -114,10 +110,8 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 	struct ccs_modesel_head *modesel;
 	int rc, density = 0;
 
-#ifdef CONFIG_BLK_DEV_SR_VENDOR
 	if (cd->vendor == VENDOR_TOSHIBA)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
-#endif
 
 	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
@@ -205,7 +199,6 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 		}
 		break;
 
-#ifdef CONFIG_BLK_DEV_SR_VENDOR
 	case VENDOR_NEC:{
 			unsigned long min, sec, frame;
 			cgc.cmd[0] = 0xde;
@@ -298,7 +291,6 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 		sector = buffer[11] + (buffer[10] << 8) +
 		    (buffer[9] << 16) + (buffer[8] << 24);
 		break;
-#endif				/* CONFIG_BLK_DEV_SR_VENDOR */
 
 	default:
 		/* should not happen */
-- 
2.25.1



