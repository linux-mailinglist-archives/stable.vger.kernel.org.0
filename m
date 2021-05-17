Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1753C383355
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhEQO53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242128AbhEQOyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95DA8619AD;
        Mon, 17 May 2021 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261485;
        bh=vciawKmsb5dGoMAlKr4/6aFk+QgjAN1DnFZO27HKZJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLTeZZfIZRFuHPa6dsjn3Lez4OgUmc2/swFHGb6TjwxSFy2eiI0Czwn1aqTXv8YyU
         2JdB440hwJat8qzTCJcfvyojIogN8C9PTs8oEJAgk73pbcsObbXZRQgKmBrtqpFSvF
         qqcUvDSPH+C1KQQftWAlXacbVwFre6vRe3Kp9pEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.12 351/363] soc: mediatek: pm-domains: Add a power domain names for mt8192
Date:   Mon, 17 May 2021 16:03:37 +0200
Message-Id: <20210517140314.462499954@linuxfoundation.org>
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

commit 3edc01bc53c639b1c98f57e7f1c026aae6a25a62 upstream.

Add the power domains names for the mt8192 SoC.

Fixes: a49d5e7a89d6 ("soc: mediatek: pm-domains: Add support for mt8192")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210225175000.824661-3-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mt8192-pm-domains.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/soc/mediatek/mt8192-pm-domains.h
+++ b/drivers/soc/mediatek/mt8192-pm-domains.h
@@ -12,6 +12,7 @@
 
 static const struct scpsys_domain_data scpsys_domain_data_mt8192[] = {
 	[MT8192_POWER_DOMAIN_AUDIO] = {
+		.name = "audio",
 		.sta_mask = BIT(21),
 		.ctl_offs = 0x0354,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -24,6 +25,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_CONN] = {
+		.name = "conn",
 		.sta_mask = PWR_STATUS_CONN,
 		.ctl_offs = 0x0304,
 		.sram_pdn_bits = 0,
@@ -45,12 +47,14 @@ static const struct scpsys_domain_data s
 		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8192_POWER_DOMAIN_MFG0] = {
+		.name = "mfg0",
 		.sta_mask = BIT(2),
 		.ctl_offs = 0x0308,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_MFG1] = {
+		.name = "mfg1",
 		.sta_mask = BIT(3),
 		.ctl_offs = 0x030c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -75,36 +79,42 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_MFG2] = {
+		.name = "mfg2",
 		.sta_mask = BIT(4),
 		.ctl_offs = 0x0310,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_MFG3] = {
+		.name = "mfg3",
 		.sta_mask = BIT(5),
 		.ctl_offs = 0x0314,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_MFG4] = {
+		.name = "mfg4",
 		.sta_mask = BIT(6),
 		.ctl_offs = 0x0318,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_MFG5] = {
+		.name = "mfg5",
 		.sta_mask = BIT(7),
 		.ctl_offs = 0x031c,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_MFG6] = {
+		.name = "mfg6",
 		.sta_mask = BIT(8),
 		.ctl_offs = 0x0320,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_DISP] = {
+		.name = "disp",
 		.sta_mask = BIT(20),
 		.ctl_offs = 0x0350,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -133,6 +143,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_IPE] = {
+		.name = "ipe",
 		.sta_mask = BIT(14),
 		.ctl_offs = 0x0338,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -149,6 +160,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_ISP] = {
+		.name = "isp",
 		.sta_mask = BIT(12),
 		.ctl_offs = 0x0330,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -165,6 +177,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_ISP2] = {
+		.name = "isp2",
 		.sta_mask = BIT(13),
 		.ctl_offs = 0x0334,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -181,6 +194,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_MDP] = {
+		.name = "mdp",
 		.sta_mask = BIT(19),
 		.ctl_offs = 0x034c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -197,6 +211,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_VENC] = {
+		.name = "venc",
 		.sta_mask = BIT(17),
 		.ctl_offs = 0x0344,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -213,6 +228,7 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_VDEC] = {
+		.name = "vdec",
 		.sta_mask = BIT(15),
 		.ctl_offs = 0x033c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -229,12 +245,14 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_VDEC2] = {
+		.name = "vdec2",
 		.sta_mask = BIT(16),
 		.ctl_offs = 0x0340,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_CAM] = {
+		.name = "cam",
 		.sta_mask = BIT(23),
 		.ctl_offs = 0x035c,
 		.sram_pdn_bits = GENMASK(8, 8),
@@ -263,18 +281,21 @@ static const struct scpsys_domain_data s
 		},
 	},
 	[MT8192_POWER_DOMAIN_CAM_RAWA] = {
+		.name = "cam_rawa",
 		.sta_mask = BIT(24),
 		.ctl_offs = 0x0360,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_CAM_RAWB] = {
+		.name = "cam_rawb",
 		.sta_mask = BIT(25),
 		.ctl_offs = 0x0364,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
 	},
 	[MT8192_POWER_DOMAIN_CAM_RAWC] = {
+		.name = "cam_rawc",
 		.sta_mask = BIT(26),
 		.ctl_offs = 0x0368,
 		.sram_pdn_bits = GENMASK(8, 8),


