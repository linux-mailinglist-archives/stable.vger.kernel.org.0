Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC7E63097F
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiKSCNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbiKSCMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFEC61B86;
        Fri, 18 Nov 2022 18:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B17662831;
        Sat, 19 Nov 2022 02:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D3DC433B5;
        Sat, 19 Nov 2022 02:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823932;
        bh=k8lrQeCvaTJykMFGCQm8vcB1H/Ui9AwSIVF6Zts0x1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rq2xopwnbrs7BhVoTMlgSSgP1g2IENdoAGIuCKOfhM0xY4/A8DZEs9u7HOC2v37YP
         M35xL7PNWZnuiczNxSaKOaOUpVtdlKkaLLEXftmLPO2W0PF0Sc4ddFuON9CKzRxXZn
         UGWh7YWmg6h9GwArK8wdj7DoDMsepIL65FI18q0Qx1YIkjud791Eg7eKORPita0xcD
         LxNIz2VjAmVAPvjAyY3Z/wSiuQhLI62WM/32XEXji8UppkN4HfagAjipQTpsyur32m
         RKrbxK8IGL4nKFKHODRjHTLYsxE6IEO76HVVOlL6Pa7wRTDlbx9FtypMTL7iKlgPGD
         jfiA6IsJE1Srw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 25/44] drm: panel-orientation-quirks: Add quirk for Nanote UMPC-01
Date:   Fri, 18 Nov 2022 21:11:05 -0500
Message-Id: <20221119021124.1773699-25-sashal@kernel.org>
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

[ Upstream commit 308451d9c7fece33d9551230cb8e5eb7f3914988 ]

The Nanote UMPC-01 is a mini laptop with a 1200x1920 portrait screen
mounted in a landscape oriented clamshell case. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20220919133258.711639-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 8a0c0e0bb5bd..f0f6fa306521 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -319,6 +319,12 @@ static const struct dmi_system_id orientation_data[] = {
 		 DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Nanote UMPC-01 */
+		.matches = {
+		 DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "UMPC-01"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
-- 
2.35.1

