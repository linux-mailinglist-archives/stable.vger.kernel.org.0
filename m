Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC65E6A325D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBZPfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBZPe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:34:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2537C178;
        Sun, 26 Feb 2023 07:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75C94B80C6D;
        Sun, 26 Feb 2023 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7F3C433B3;
        Sun, 26 Feb 2023 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422862;
        bh=A+e8D+RLUmzm4wg7IFhxKvLKj5UAXwDHdY9Yicl2EJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVIFbo+xEDytPmV23KJbnr+Dvy2ErMgF6FLw7eZxm7YGJ8rLQnYpg6pV+47Ow88bE
         hvg1tTF8CdlqgOIjtnHgaO73JW/Jgnh+Lnz9tIaMyIvcVbOLxHTsffn9zpbyLRqAEr
         x5DnTVHI+Ib3Z6K88k+MAvy8GB3QUEVhTWdXP9litTv417eXuIAkfQsL2cN7w0vbXh
         vr3EijRsoPZAfM2nbraKzRC3eR2wDJM4m6GQW8t9Xufj5DBRYLxWhuZ/osOLZGaEuS
         TSh6jlPCixuf3PcTYZPbxHE13QZ6MQd4stdvrjWmcPeHJfPdKO6gOWkr5UqNwYTGaG
         3+VE//2lIfiFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Zimmermann <tim@linux4.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/49] thermal: intel: intel_pch: Add support for Wellsburg PCH
Date:   Sun, 26 Feb 2023 09:46:21 -0500
Message-Id: <20230226144650.826470-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Zimmermann <tim@linux4.de>

[ Upstream commit 40dc1929089fc844ea06d9f8bdb6211ed4517c2e ]

Add the PCI ID for the Wellsburg C610 series chipset PCH.

The driver can read the temperature from the Wellsburg PCH with only
the PCI ID added and no other modifications.

Signed-off-by: Tim Zimmermann <tim@linux4.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_pch_thermal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index dabf11a687a15..9e27f430e0345 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -29,6 +29,7 @@
 #define PCH_THERMAL_DID_CNL_LP	0x02F9 /* CNL-LP PCH */
 #define PCH_THERMAL_DID_CML_H	0X06F9 /* CML-H PCH */
 #define PCH_THERMAL_DID_LWB	0xA1B1 /* Lewisburg PCH */
+#define PCH_THERMAL_DID_WBG	0x8D24 /* Wellsburg PCH */
 
 /* Wildcat Point-LP  PCH Thermal registers */
 #define WPT_TEMP	0x0000	/* Temperature */
@@ -350,6 +351,7 @@ enum board_ids {
 	board_cnl,
 	board_cml,
 	board_lwb,
+	board_wbg,
 };
 
 static const struct board_info {
@@ -380,6 +382,10 @@ static const struct board_info {
 		.name = "pch_lewisburg",
 		.ops = &pch_dev_ops_wpt,
 	},
+	[board_wbg] = {
+		.name = "pch_wellsburg",
+		.ops = &pch_dev_ops_wpt,
+	},
 };
 
 static int intel_pch_thermal_probe(struct pci_dev *pdev,
@@ -495,6 +501,8 @@ static const struct pci_device_id intel_pch_thermal_id[] = {
 		.driver_data = board_cml, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_LWB),
 		.driver_data = board_lwb, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_WBG),
+		.driver_data = board_wbg, },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, intel_pch_thermal_id);
-- 
2.39.0

