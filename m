Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473CC6A38C7
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjB0ChS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjB0ChB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:37:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4909F1E1C5;
        Sun, 26 Feb 2023 18:36:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8980BB80CB6;
        Mon, 27 Feb 2023 02:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530D2C433A8;
        Mon, 27 Feb 2023 02:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463831;
        bh=JWiQ7+3JyVc2fD+9T5YWzyxrXvfI/mOoxSEV5pZf5lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkgQYuXVn+V8QB7Pn7/k3SZsdZIEbwQFAGPUPyWeGgeFL9xNWGRawFfmXiNAQH8qg
         hirXRMXHIGMOJBpgkgw/zhMiQOlYIimtZFd+iG2HiJEp0E4aOfiWy6lB1b5E2/fEmk
         RamNou1m2Bz7zPGr5Te43WakWQTCToK9P3LPrakRG4NtlCkb+duE++M+mEdtuZprVX
         Tww6y7RUTzygpUO0uk0X2MRNX7Vt+gsSjD0orh7K4yAF88h8D1fVPwsQbHoIBCsJOS
         Iq4M8GeFvPBJ9eQV8iaqrFRMuwp1HKNwOQYhbzyuvAhFKkuBZeWbXa31El7Z+GzkQ7
         0MNYeJu2ZkcFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darrell Kavanagh <darrell.kavanagh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 16/19] drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5
Date:   Sun, 26 Feb 2023 21:09:51 -0500
Message-Id: <20230227020957.1052252-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020957.1052252-1-sashal@kernel.org>
References: <20230227020957.1052252-1-sashal@kernel.org>
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

From: Darrell Kavanagh <darrell.kavanagh@gmail.com>

[ Upstream commit 38b2d8efd03d2e56431b611e3523f0158306451d ]

Another Lenovo convertable where the panel is installed landscape but is
reported to the kernel as portrait.

Signed-off-by: Darrell Kavanagh <darrell.kavanagh@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230214164659.3583-1-darrell.kavanagh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index ce739ba45c551..8768073794fbf 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -278,6 +278,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Lenovo IdeaPad Duet 3 10IGL5 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
 		.matches = {
 		  /* Non exact match to match all versions */
-- 
2.39.0

