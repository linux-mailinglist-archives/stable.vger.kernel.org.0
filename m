Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8C57ACA2
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiGTBYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241691AbiGTBXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC671BD3;
        Tue, 19 Jul 2022 18:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAF06176B;
        Wed, 20 Jul 2022 01:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FE5C341CF;
        Wed, 20 Jul 2022 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279824;
        bh=A5NFtvWb2evrSfDZEiMFR1HpaxU2coNuc1Yos5cA4Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAxxzGSwbZix1oLHY+a5Zf/9p5ppL2bSMHGIe/FHY+E+QGgYjM9WqYT/JhnLffn5j
         efd4vVcVnu1PMqoSDgBG/YUfs1VHMBCkk7uMVxwF7PZ+PrCIg4/EiMcut82Kdo2Z8E
         rcxhjGrTz/fL8UJ9wLAmsbdp5aaPPI4EhVgTlj1L5Yu+c6bIp4NYNG9YyKsATBcLcC
         zmocIMey00tlG58vRjEnEHLdFNNx+XPxoGGmb9UhXaoOTHLpqFtpSE9f9A5bKS6wQx
         rXAm+MtT3e9eOAJekPsVLUheCLPR2KXMPJ2ZNhZZu0zno4YiLtlr4fcNuFM6J7MbQD
         umV3dchY0Mt0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 13/25] drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Tablet 2 830
Date:   Tue, 19 Jul 2022 21:16:04 -0400
Message-Id: <20220720011616.1024753-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 144248515246e52a3706de1ee928af29a63794b8 ]

The Lenovo Yoga Tablet 2 830F / 830L use a panel which has been mounted
90 degrees rotated. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220623112710.15693-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f5ab891731d0..ad75e7712ebb 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -266,6 +266,21 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Tablet 2 830F / 830L */
+		.matches = {
+		 /*
+		  * Note this also matches the Lenovo Yoga Tablet 2 1050F/L
+		  * since that uses the same mainboard. The resolution match
+		  * will limit this to only matching on the 830F/L. Neither has
+		  * any external video outputs so those are not a concern.
+		  */
+		 DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "VALLEYVIEW C0 PLATFORM"),
+		 DMI_MATCH(DMI_BOARD_NAME, "BYT-T FFD8"),
+		 /* Partial match on beginning of BIOS version */
+		 DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
-- 
2.35.1

