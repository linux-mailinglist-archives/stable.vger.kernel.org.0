Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF68224A88
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgGRKHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 06:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgGRKHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 06:07:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05DFC0619D2;
        Sat, 18 Jul 2020 03:07:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l2so20784458wmf.0;
        Sat, 18 Jul 2020 03:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbUgyZeiuM6+BVUIAI4OdILY3CSnWGCM8BoQyFdGMKs=;
        b=OC0B+1hbj5tnPzu0RoOh98I75oY4HQYUY3L9uBR+BE/JwnGX2voM2S3XIWFKi1AYTN
         9IIxlMLOmcKJaGS4kCR5soTLRcKvhawmfcBqe5SS9m53rUHpbE8XYTuuZSj4DcSd1SkB
         6y2AOOnx9xfyfUF0gvR3snn54TyBGVllxY+KvMT0DXfqNl1ie24GeWmbHbebY82vkN/k
         aocOTxiqyY8uIN2t0SBoKZa9V/azqrxVeEygbUVxCwQn+ZwAxxbj0Gmr4Y4seX6BwULs
         i3uS5M6FEzjZJMC4/6XYy6s0HujfStbAhS+hpkNl2wh3VJeeixis/OXBYckuikLli8G4
         O1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbUgyZeiuM6+BVUIAI4OdILY3CSnWGCM8BoQyFdGMKs=;
        b=F788rEwRvDTCgrEkfZojaO03ue8zb/Mo4CFHXh8XnRpXBzsaQclqY3m4FyoGCP33Hw
         QI2huOvdYd3l38LGErZ3MRbll45xP4yPrnrs9LBmHA+DTZZX5x7OcLI+IYKhnZTjvD3r
         uwyV/Smjije6CwIgyTo77z//dg8YL56pryhslTzjA842AIX6cwKpF2xCT+fbFaF/mNhF
         a70WgYu0QB6Kat91f2hu5MZLiI0HrMq7cdjV7cz4wr6UxsK8njGcALDFDJksPaULUd7x
         fG0Ar0GkvsA+vtMPDryA/TQ4dR2y2t+58CxpIQWs27pD6Hd1rjO6NYsb0XkueR8uVX0a
         GRQA==
X-Gm-Message-State: AOAM532iB/N7gLAY+gR6oA/MO84UAsJQdHZD2Q9t6blhXDvwhPXyqtq3
        n1cWDZJJh9k0NJsVsOYZj/9P76eksYY=
X-Google-Smtp-Source: ABdhPJxcbaX83DdQaX3e5Oi0V4G5NBOFKyvw4yFH3H3mNbNDinbarEXp3AInlsVTsksLfM00eURSlQ==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr13753156wmj.31.1595066833465;
        Sat, 18 Jul 2020 03:07:13 -0700 (PDT)
Received: from arrakis.kwizart.net (amontpellier-652-1-69-19.w109-210.abo.wanadoo.fr. [109.210.52.19])
        by smtp.gmail.com with ESMTPSA id a123sm18899653wmd.28.2020.07.18.03.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 03:07:12 -0700 (PDT)
From:   Nicolas Chauvet <kwizart@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        Nicolas Chauvet <kwizart@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] PCI: tegra: Revert tegra124 raw_violation_fixup
Date:   Sat, 18 Jul 2020 12:07:10 +0200
Message-Id: <20200718100710.15398-1-kwizart@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As reported in https://bugzilla.kernel.org/206217 , raw_violation_fixup
is causing more harm than good in some common use-cases.

This patch is a partial revert of commit:
 191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")
that was first introduced in 5.3-rc1 kernel. This fix the following
regression since then.

* Description:
When both the NIC and MMC are used one can see the following message:

  NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out

and

  pcieport 0000:00:02.0: AER: Uncorrected (Non-Fatal) error received: 0000:01:00.0
  r8169 0000:01:00.0: AER: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
  r8169 0000:01:00.0: AER:   device [10ec:8168] error status/mask=00004000/00400000
  r8169 0000:01:00.0: AER:    [14] CmpltTO                (First)
  r8169 0000:01:00.0: AER: can't recover (no error_detected callback)
  pcieport 0000:00:02.0: AER: device recovery failed

After that, the ethernet NIC isn't functional anymore even after
reloading the r8169 module. After a reboot, this is reproducible by
copying a large file over the NIC to the MMC.

For some reason this is not reproducible when files are copied to a tmpfs.

* Little background on the fixup, by Manikanta Maddireddy:
  "In the internal testing with dGPU on Tegra124, CmplTO is reported by
dGPU. This happened because FIFO queue in AFI(AXI to PCIe) module
get full by upstream posted writes. Back to back upstream writes
interleaved with infrequent reads, triggers RAW violation and CmpltTO.
This is fixed by reducing the posted write credits and by changing
updateFC timer frequency. These settings are fixed after stress test.

In the current case, RTL NIC is also reporting CmplTO. These settings
seems to be aggravating the issue instead of fixing it."

Fixes: 191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")
Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
Reviewed-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Cc: stable@vger.kernel.org
---

v1: first non-RFC version
    Disable raw_violation_fixup and fully remove unused code and macros

v2: Update the commit message

 drivers/pci/controller/pci-tegra.c | 32 ------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 235b456698fc..b532d5082fb6 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -181,13 +181,6 @@
 
 #define AFI_PEXBIAS_CTRL_0		0x168
 
-#define RP_PRIV_XP_DL		0x00000494
-#define  RP_PRIV_XP_DL_GEN2_UPD_FC_TSHOLD	(0x1ff << 1)
-
-#define RP_RX_HDR_LIMIT		0x00000e00
-#define  RP_RX_HDR_LIMIT_PW_MASK	(0xff << 8)
-#define  RP_RX_HDR_LIMIT_PW		(0x0e << 8)
-
 #define RP_ECTL_2_R1	0x00000e84
 #define  RP_ECTL_2_R1_RX_CTLE_1C_MASK		0xffff
 
@@ -323,7 +316,6 @@ struct tegra_pcie_soc {
 	bool program_uphy;
 	bool update_clamp_threshold;
 	bool program_deskew_time;
-	bool raw_violation_fixup;
 	bool update_fc_timer;
 	bool has_cache_bars;
 	struct {
@@ -659,23 +651,6 @@ static void tegra_pcie_apply_sw_fixup(struct tegra_pcie_port *port)
 		writel(value, port->base + RP_VEND_CTL0);
 	}
 
-	/* Fixup for read after write violation. */
-	if (soc->raw_violation_fixup) {
-		value = readl(port->base + RP_RX_HDR_LIMIT);
-		value &= ~RP_RX_HDR_LIMIT_PW_MASK;
-		value |= RP_RX_HDR_LIMIT_PW;
-		writel(value, port->base + RP_RX_HDR_LIMIT);
-
-		value = readl(port->base + RP_PRIV_XP_DL);
-		value |= RP_PRIV_XP_DL_GEN2_UPD_FC_TSHOLD;
-		writel(value, port->base + RP_PRIV_XP_DL);
-
-		value = readl(port->base + RP_VEND_XP);
-		value &= ~RP_VEND_XP_UPDATE_FC_THRESHOLD_MASK;
-		value |= soc->update_fc_threshold;
-		writel(value, port->base + RP_VEND_XP);
-	}
-
 	if (soc->update_fc_timer) {
 		value = readl(port->base + RP_VEND_XP);
 		value &= ~RP_VEND_XP_UPDATE_FC_THRESHOLD_MASK;
@@ -2416,7 +2391,6 @@ static const struct tegra_pcie_soc tegra20_pcie = {
 	.program_uphy = true,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = true,
 	.ectl.enable = false,
@@ -2446,7 +2420,6 @@ static const struct tegra_pcie_soc tegra30_pcie = {
 	.program_uphy = true,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,
@@ -2459,8 +2432,6 @@ static const struct tegra_pcie_soc tegra124_pcie = {
 	.pads_pll_ctl = PADS_PLL_CTL_TEGRA30,
 	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
 	.pads_refclk_cfg0 = 0x44ac44ac,
-	/* FC threshold is bit[25:18] */
-	.update_fc_threshold = 0x03fc0000,
 	.has_pex_clkreq_en = true,
 	.has_pex_bias_ctrl = true,
 	.has_intr_prsnt_sense = true,
@@ -2470,7 +2441,6 @@ static const struct tegra_pcie_soc tegra124_pcie = {
 	.program_uphy = true,
 	.update_clamp_threshold = true,
 	.program_deskew_time = false,
-	.raw_violation_fixup = true,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,
@@ -2494,7 +2464,6 @@ static const struct tegra_pcie_soc tegra210_pcie = {
 	.program_uphy = true,
 	.update_clamp_threshold = true,
 	.program_deskew_time = true,
-	.raw_violation_fixup = false,
 	.update_fc_timer = true,
 	.has_cache_bars = false,
 	.ectl = {
@@ -2536,7 +2505,6 @@ static const struct tegra_pcie_soc tegra186_pcie = {
 	.program_uphy = false,
 	.update_clamp_threshold = false,
 	.program_deskew_time = false,
-	.raw_violation_fixup = false,
 	.update_fc_timer = false,
 	.has_cache_bars = false,
 	.ectl.enable = false,
-- 
2.25.4

