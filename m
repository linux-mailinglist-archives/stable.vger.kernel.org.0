Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215F538340C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbhEQPFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242396AbhEQPCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B30619CE;
        Mon, 17 May 2021 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261651;
        bh=l7PV+H2H11lVL5U3PyAONVIJQwb3NvpftLLKAQ8XyAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYTXnu+qJ4PGJhbKRkf73O3W3Naq7bAgjhTVYcSAmYhn7l2TB/XUsG1aPUpmtOm1q
         Kcl7kjTTdG1Yp6eNQAJSKbexFgsydssQt1GnLGrog7a6QA17L6B5gW8wmsGK5gP9Vn
         kHdG8Bqry2T4kg/2EmaGjliD4A5GmJ8FJ02ehGzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.12 350/363] soc: mediatek: pm-domains: Add a power domain names for mt8183
Date:   Mon, 17 May 2021 16:03:36 +0200
Message-Id: <20210517140314.428894847@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

commit e57b8112258ed46dff23b49d6e400f54a8dbf1c3 upstream.

Add the power domains names for the mt8183 SoC. This removes the debugfs
errors like the following:

  debugfs: Directory 'power-domain' with parent 'pm_genpd' already present!

Fixes: eb9fa767fbe1 ("soc: mediatek: pm-domains: Add support for mt8183")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210225175000.824661-2-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mt8183-pm-domains.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/soc/mediatek/mt8183-pm-domains.h
+++ b/drivers/soc/mediatek/mt8183-pm-domains.h
@@ -12,12 +12,14 @@
 
 static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 	[MT8183_POWER_DOMAIN_AUDIO] = {
+		.name = "audio",
 		.sta_mask = PWR_STATUS_AUDIO,
 		.ctl_offs = 0x0314,
 		.sram_pdn_bits = GENMASK(11, 8),
 		.sram_pdn_ack_bits = GENMASK(15, 12),
 	},
 	[MT8183_POWER_DOMAIN_CONN] = {
+		.name = "conn",
 		.sta_mask = PWR_STATUS_CONN,
 		.ctl_offs = 0x032c,
 		.sram_pdn_bits = 0,
@@ -28,12 +30,14 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_MFG_ASYNC] = {
+		.name = "mfg_async",
 		.sta_mask = PWR_STATUS_MFG_ASYNC,
 		.ctl_offs = 0x0334,
 		.sram_pdn_bits = 0,
 		.sram_pdn_ack_bits = 0,
 	},
 	[MT8183_POWER_DOMAIN_MFG] = {
+		.name = "mfg",
 		.sta_mask = PWR_STATUS_MFG,
 		.ctl_offs = 0x0338,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -41,18 +45,21 @@ static const struct scpsys_domain_data s
 		.caps = MTK_SCPD_DOMAIN_SUPPLY,
 	},
 	[MT8183_POWER_DOMAIN_MFG_CORE0] = {
+		.name = "mfg_core0",
 		.sta_mask = BIT(7),
 		.ctl_offs = 0x034c,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8183_POWER_DOMAIN_MFG_CORE1] = {
+		.name = "mfg_core1",
 		.sta_mask = BIT(20),
 		.ctl_offs = 0x0310,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8183_POWER_DOMAIN_MFG_2D] = {
+		.name = "mfg_2d",
 		.sta_mask = PWR_STATUS_MFG_2D,
 		.ctl_offs = 0x0348,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -65,6 +72,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_DISP] = {
+		.name = "disp",
 		.sta_mask = PWR_STATUS_DISP,
 		.ctl_offs = 0x030c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -83,6 +91,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_CAM] = {
+		.name = "cam",
 		.sta_mask = BIT(25),
 		.ctl_offs = 0x0344,
 		.sram_pdn_bits = GENMASK(9, 8),
@@ -105,6 +114,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_ISP] = {
+		.name = "isp",
 		.sta_mask = PWR_STATUS_ISP,
 		.ctl_offs = 0x0308,
 		.sram_pdn_bits = GENMASK(9, 8),
@@ -127,6 +137,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VDEC] = {
+		.name = "vdec",
 		.sta_mask = BIT(31),
 		.ctl_offs = 0x0300,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -139,6 +150,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VENC] = {
+		.name = "venc",
 		.sta_mask = PWR_STATUS_VENC,
 		.ctl_offs = 0x0304,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -151,6 +163,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VPU_TOP] = {
+		.name = "vpu_top",
 		.sta_mask = BIT(26),
 		.ctl_offs = 0x0324,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -177,6 +190,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VPU_CORE0] = {
+		.name = "vpu_core0",
 		.sta_mask = BIT(27),
 		.ctl_offs = 0x33c,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -194,6 +208,7 @@ static const struct scpsys_domain_data s
 		.caps = MTK_SCPD_SRAM_ISO,
 	},
 	[MT8183_POWER_DOMAIN_VPU_CORE1] = {
+		.name = "vpu_core1",
 		.sta_mask = BIT(28),
 		.ctl_offs = 0x0340,
 		.sram_pdn_bits = GENMASK(11, 8),


