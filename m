Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DA52245DF
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQVfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 17:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQVfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 17:35:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695BAC0619D2;
        Fri, 17 Jul 2020 14:35:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 22so16796642wmg.1;
        Fri, 17 Jul 2020 14:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xD3P6zxh/wy50/KlLOtT7FxG3otaDrHyxXNJVg8NnD8=;
        b=NSOZ3AopEjuXvowHc7o3w9XALyvZl+VVgdZcNvQ/H3Bv3bwE3Eh/faSjf69MABiBCD
         OXef1H+DLwfThk/resJnINnj4hzskoOwLKJb0HNsvc+V1POISP4qa+NRWRbdzwrDDN7T
         XaEKbj/5E1xiL6Cu0FSc/XbhZ0HWztZzoMKiKz8FpzjN9ib3sug1aU5AvzfJKY/2zv82
         42KF6+gAPOEFgo1YtB9NKPkLpS8h6gz+yrmFaMFCgL6NBU7c7VnyduYs2lJOX70ieDQs
         paPgfXXHl8qnF2oQSV5zSnj1x5KO/McpT2UwEBE5dieAswW6Poe4p+430q9enGfV5Y95
         jWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xD3P6zxh/wy50/KlLOtT7FxG3otaDrHyxXNJVg8NnD8=;
        b=etqd+FHAFghlsNqjnmMZI9vZdmlItWszaYpof1bAr5zEZCdj5Yo6jXN181S91jBCCS
         u3imgm+0Whi1i90z1MSHb5e0WDziRQy0c6DI5TSmKjrWlPvfJyh5MMCqNYzTyGENNqIh
         8Q6PdWoNAsr9GJlMKApjqCnEQZK9StO35lZIXVpV8Vq6sMD4Rm4uVRPe5JuJkrVyRWwJ
         5eJ01Jn8uZV8faaSThZZ7VogZrQ3IeSqZY4lli8V7XcvRjG2SDJheRRc1USCaWMb+dyQ
         hguA6RgnD32zC0leU8q5D+rC8QgzFGUyxU8uhxaMYBfE3yoshMqz82p+UHn+ns0hW9XP
         Krfw==
X-Gm-Message-State: AOAM530eDsUNWJqog/oj5O9XVEb1JDljlpDw29pzZ8G7bt7bADbxa2si
        Var9RFO+4ulYyBbAe3QiMC8=
X-Google-Smtp-Source: ABdhPJwkM6ohJugQ386es/MCzx2X/YpHm6f3XNOHwVx4tNj8W/dqrs8vsJ++nTX12KC7vw1nH9/8wQ==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr11582964wmj.31.1595021714053;
        Fri, 17 Jul 2020 14:35:14 -0700 (PDT)
Received: from arrakis.kwizart.net (amontpellier-652-1-69-19.w109-210.abo.wanadoo.fr. [109.210.52.19])
        by smtp.gmail.com with ESMTPSA id q7sm16546558wra.56.2020.07.17.14.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 14:35:13 -0700 (PDT)
From:   Nicolas Chauvet <kwizart@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        Nicolas Chauvet <kwizart@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] pci: tegra: Revert raw_violation_fixup for tegra124
Date:   Fri, 17 Jul 2020 23:35:10 +0200
Message-Id: <20200717213510.171726-1-kwizart@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As reported in https://bugzilla.kernel.org/206217 , raw_violation_fixup
is causing more harm than good in some common use-cases.

This patch is a partial revert of the 191cd6fb5 commit:
 "PCI: tegra: Add SW fixup for RAW violations"
that was first introduced in 5.3-rc1 kernel.
This fix the following regression since then.

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

After that, the ethernet NIC isn't functional anymore even after reloading
the r8169 module.
After a reboot, this is reproducible by copying a large file over the
NIC to the MMC.

For some reasons this cannot be reproduced when the same file is copied
to a tmpfs.

* Little background on the fixup, by Manikanta Maddireddy:
  "In the internal testing with dGPU on Tegra124, CmplTO is reported by
dGPU. This happened because FIFO queue in AFI(AXI to PCIe) module
get full by upstream posted writes. Back to back upstream writes
interleaved with infrequent reads, triggers RAW violation and CmpltTO.
This is fixed by reducing the posted write credits and by changing
updateFC timer frequency. These settings are fixed after stress test.

In the current case, RTL NIC is also reporting CmplTO. These settings
seems to be aggravating the issue instead of fixing it."

v1: first non-RFC version
 - Disable raw_violation_fixup and fully remove unused code and macros

Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
Reviewed-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Cc: <stable@vger.kernel.org> # 5.4.x
---
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

