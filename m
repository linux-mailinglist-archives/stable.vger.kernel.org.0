Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5E257AD1B
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiGTB0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbiGTBZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63026747A9;
        Tue, 19 Jul 2022 18:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD3A617B4;
        Wed, 20 Jul 2022 01:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC9C341CE;
        Wed, 20 Jul 2022 01:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279876;
        bh=A5NFtvWb2evrSfDZEiMFR1HpaxU2coNuc1Yos5cA4Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM3l7y5hNwIjmKOtopdSLX2RFqL0/Gms75P0HvYBDcOYaDHg/z8hcsicCbwNZy0PL
         UIyy5ZiWkw+l+/svfeAKNl5+0Kdl+gBGd6eT2VlrTQCiZiWF5VZvBD7U4xu1Qe8+/9
         zAUiw1tPZGeWTnTIyTS7K4zNB/9b+sMo4mFAAOSiP0gSHzqEQ2inz4xvbvoA6ZIekG
         VLRFvPUtAoHPy595SqQ1NoWt8ROggNAj0i4t4d7i8YnNZHQqWpJB6B1TwRCXvHeTzZ
         yK/a/SxOXoXCC/UywdgfFLSeTCp0VqgRky7ADaERTW7zB4XDOuD4dXon74N6dBsr1d
         tS8KU0BTZXzNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 08/16] drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Tablet 2 830
Date:   Tue, 19 Jul 2022 21:17:22 -0400
Message-Id: <20220720011730.1025099-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
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

