Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A2A226AD3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbgGTPvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgGTPv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655242064B;
        Mon, 20 Jul 2020 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260286;
        bh=sP9B73e0xwSR8Y4T1aDBY6e5qADDYogqs+CnBzhq2Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liQJt9jn51Z79ZixiNZ8JXWD7kUvSkd7au0woamLcIlRM3BnCB2+BQzkn30ICjfns
         a7JADB7sljAhbz+Eh4k3p8H/pHga6To2Ks1Q9/Z5HEsfZqVhUOecnugALHUXA50JFw
         c/GVm8TFI0sMw7gs0p69uDpH4/AUw5EkwINZNWbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/133] scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled
Date:   Mon, 20 Jul 2020 17:36:35 +0200
Message-Id: <20200720152806.028495676@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
 arch/alpha/defconfig                        | 1 -
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

diff --git a/arch/alpha/defconfig b/arch/alpha/defconfig
index f4ec420d7f2df..3a132c91d45bc 100644
--- a/arch/alpha/defconfig
+++ b/arch/alpha/defconfig
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
index bd71d5bf98c91..9c69a9020e77d 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -206,7 +206,6 @@ CONFIG_EEPROM_AT24=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index b504c8e2fd52b..7fd4176ea0f6d 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -36,7 +36,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 93a3c3c0238ce..bd55d9ba7049c 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -341,7 +341,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index e3d0efd6397d0..83789fd6780df 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -328,7 +328,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 75ac0c76e8849..db0c0fa6075b9 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -336,7 +336,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index c6e492700188c..6a64904a5a4c6 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -326,7 +326,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index b00d1c477432d..dcfa9a3d1a0b6 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -328,7 +328,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 85cac3770d898..916dbe2d61c3e 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -335,7 +335,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index b3a5d1e99d277..2f5c020895749 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -358,7 +358,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 0ca22608453fd..40240c32418ec 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -325,7 +325,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 8e3d10d12d9ca..34b7038f7de71 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -326,7 +326,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index ff7e653ec7fac..6375a7c86471d 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -333,7 +333,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 612cf46f6d0cb..0c38799e9a674 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -323,7 +323,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index a6a7bb6dc3fd5..8180ef6b69839 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -323,7 +323,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 5e73fe755be6c..bd6654299a9c5 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -123,7 +123,6 @@ CONFIG_BLK_DEV_TC86C001=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_ATA=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 499f51498ecbf..8f3e08d8607bb 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -111,7 +111,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 91a9c13e2c820..9855addcd7d5c 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -107,7 +107,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index ebff297328aed..a5f6be4b949b1 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -54,7 +54,6 @@ CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 9ad1c94376c8d..aa101c27ed258 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -206,7 +206,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 81058295d35f5..4338c2189c0f8 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -245,7 +245,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 5c10cddc39d36..224718f453930 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -252,7 +252,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/malta_kvm_guest_defconfig b/arch/mips/configs/malta_kvm_guest_defconfig
index bb694f5065f14..03cf2abe2d651 100644
--- a/arch/mips/configs/malta_kvm_guest_defconfig
+++ b/arch/mips/configs/malta_kvm_guest_defconfig
@@ -254,7 +254,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 99a19cf5f9ba8..f64074aa06b62 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -250,7 +250,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 1a3e1fec4e86f..194df200daada 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -218,7 +218,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index c03d0fb166658..9144e4cbc42e9 100644
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
index 12f397d403c67..8ddab7c240d97 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -48,7 +48,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index a203b1cf67d3d..796d34734b91a 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -46,7 +46,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 67c39f4acede1..0123e3b009013 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -63,7 +63,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 59e47ec853366..9df11592880d1 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -42,7 +42,6 @@ CONFIG_BLK_DEV_RAM_SIZE=8192
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_IPR=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 6daa56f8895cb..4504380c7a922 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -61,7 +61,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 62948d198d7f9..212a68b65d9fe 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -121,7 +121,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index 6ab34e60495f4..5a533c9f6b3d9 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -109,7 +109,6 @@ CONFIG_BLK_DEV_NVME=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 5033e630afead..d9fdf05599c98 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -93,7 +93,6 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 41d85cb3c9a2f..a5e36faef391a 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -61,7 +61,6 @@ CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 7ee736f207740..7032d4244ec5f 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -374,7 +374,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 0dd5cf7b566de..780552be29f9f 100644
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
index ffeaed63675b1..82611dea62bdb 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -77,7 +77,6 @@ CONFIG_EEPROM_AT24=y
 # CONFIG_CXL is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index 2156223405a16..ecc736504a04f 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -47,7 +47,6 @@ CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_SCSI=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 4d4e1cc6402fa..fc45ec682e7a7 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -74,7 +74,6 @@ CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 0eb9f92f37179..ce75be940567e 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -149,7 +149,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index e32fc1f274d85..45b0f4d84d83b 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -148,7 +148,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a8ac480276323..7cb6e2b9e180a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -144,15 +144,6 @@ config BLK_DEV_SR
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



