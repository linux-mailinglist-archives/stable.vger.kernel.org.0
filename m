Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5443837AF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhEQPqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245264AbhEQPmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049A86141E;
        Mon, 17 May 2021 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262549;
        bh=Q0nfotbIixjjTwx/kaU5wYNJLwRaGDZ5BZ/dgOPjPFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2SfSF6uONSb0U+biisN8VqgAfTaFeZxsnXOvI/6SBhU0ODZd6+ps8VbEa9OR+V4B
         HGjeNL77zj4yu7THaI4F/cG5+0gdZcqWIm8mdFeTdco4FSL2Z7KHwaWXXiap68HX9u
         +70aDw0pFjCB0DJlqD3ZaYV0Yog/XrTSTg9EL4DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.11 318/329] soc: mediatek: pm-domains: Add a power domain names for mt8183
Date:   Mon, 17 May 2021 16:03:49 +0200
Message-Id: <20210517140312.853197610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
@@ -28,30 +30,35 @@ static const struct scpsys_domain_data s
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
 		.sram_pdn_ack_bits = GENMASK(12, 12),
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
@@ -64,6 +71,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_DISP] = {
+		.name = "disp",
 		.sta_mask = PWR_STATUS_DISP,
 		.ctl_offs = 0x030c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -82,6 +90,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_CAM] = {
+		.name = "cam",
 		.sta_mask = BIT(25),
 		.ctl_offs = 0x0344,
 		.sram_pdn_bits = GENMASK(9, 8),
@@ -104,6 +113,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_ISP] = {
+		.name = "isp",
 		.sta_mask = PWR_STATUS_ISP,
 		.ctl_offs = 0x0308,
 		.sram_pdn_bits = GENMASK(9, 8),
@@ -126,6 +136,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VDEC] = {
+		.name = "vdec",
 		.sta_mask = BIT(31),
 		.ctl_offs = 0x0300,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -138,6 +149,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VENC] = {
+		.name = "venc",
 		.sta_mask = PWR_STATUS_VENC,
 		.ctl_offs = 0x0304,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -150,6 +162,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VPU_TOP] = {
+		.name = "vpu_top",
 		.sta_mask = BIT(26),
 		.ctl_offs = 0x0324,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -176,6 +189,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8183_POWER_DOMAIN_VPU_CORE0] = {
+		.name = "vpu_core0",
 		.sta_mask = BIT(27),
 		.ctl_offs = 0x33c,
 		.sram_pdn_bits = GENMASK(11, 8),
@@ -193,6 +207,7 @@ static const struct scpsys_domain_data s
 		.caps = MTK_SCPD_SRAM_ISO,
 	},
 	[MT8183_POWER_DOMAIN_VPU_CORE1] = {
+		.name = "vpu_core1",
 		.sta_mask = BIT(28),
 		.ctl_offs = 0x0340,
 		.sram_pdn_bits = GENMASK(11, 8),


