Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A2630988
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiKSCNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiKSCMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D87D49099;
        Fri, 18 Nov 2022 18:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF7DB82672;
        Sat, 19 Nov 2022 02:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACBFC4314C;
        Sat, 19 Nov 2022 02:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823934;
        bh=crlVn6UUuZzHzKIKE7nBQg2KCq61S0dGC5C5q4gum0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoDl5nEXHWQdnxXV/dMUwgkE74X+gHzY9AdBm9k0luZt2hQjnx0Ht4L7v76hJ2tks
         Jec/EzQoumPd0eQjJ80djTz2W7gkgl4J+7J/e5J5DXDJ5XrgzZsQTxrRHEexwR4C2t
         RSjw1GeOLp0hleRVlDCo/bXjLXDyze7KT2YtdIVmOl25pyZ7HI5F/ClLj2OhV6RMdZ
         V716v5CT0625wGgpobhYfdt/uwBBriLY6BRia2RSAv1A6MH1xPG45L0jh+2snh+9v3
         ssHGbdkAp37+vyKPR/tPLavJp3l9ckeG+ZKO0si54R9ubxRnvgeWgMYeErWHStFQTL
         xyIy7oPEYPBvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rudolf Polzer <rpolzer@google.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 26/44] drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
Date:   Fri, 18 Nov 2022 21:11:06 -0500
Message-Id: <20221119021124.1773699-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 653f2d94fcda200b02bd79cea2e0307b26c1b747 ]

Like the Acer Switch One 10 S1003, for which there already is a quirk,
the Acer Switch V 10 (SW5-017) has a 800x1280 portrait screen mounted
in the tablet part of a landscape oriented 2-in-1. Add a quirk for this.

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20221106215052.66995-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f0f6fa306521..52d8800a8ab8 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -134,6 +134,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Acer Switch V 10 (SW5-017) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Anbernic Win600 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Anbernic"),
-- 
2.35.1

