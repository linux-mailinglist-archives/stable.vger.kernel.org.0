Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AC555DE81
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbiF1CVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243539AbiF1CU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9353C24947;
        Mon, 27 Jun 2022 19:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E1F0B81C00;
        Tue, 28 Jun 2022 02:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88504C36AEF;
        Tue, 28 Jun 2022 02:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382800;
        bh=i1MqkCT0NLl9iJ1uNyGtqAn7ESc3mIGPD1O+e/eGeVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnlfJ4bkhA1DIQAynZABBlpOp+77wZt65WdJDa+1v34ksXmmjsjMPazcklbN0PRMQ
         tlSvjf70isQN7L8ZGs2OEC/uF9cH6x2PPfDrpH5Vw4fFAtfxM9H+S5atk6e6GVJdRt
         6bnYeIiITIkbIes+kgBavNtFWisyaU4xFFe33y4pRwdB0J5xbANi7jZpIESx5CbnOs
         JvzU0OW6hU7z7MCYYCPh5mh8i64fyXoOUTjLYV1QcrpHfB4941Uk/v3Sa/zeapS66L
         hn915ywx4RxJntfS8Mc15ba4cI2PZjSEUdHj/FIcphFt9vKk1KjoSmBdI1osxGBt+4
         S6WFXab1MfAfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Matuszczyk <maccraft123mc@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 27/53] drm: panel-orientation-quirks: Add quirk for Aya Neo Next
Date:   Mon, 27 Jun 2022 22:18:13 -0400
Message-Id: <20220628021839.594423-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Matuszczyk <maccraft123mc@gmail.com>

[ Upstream commit be33d52ef5b4bdfec04cfdad39368c343bac97a3 ]

The device is identified by "NEXT" in board name, however there are
different versions of it, "Next Advance" and "Next Pro", that have
different DMI board names.
Due to a production error a batch or two have their board names prefixed
by "AYANEO", this makes it 6 different DMI board names. To save some
space in final kernel image DMI_MATCH is used instead of
DMI_EXACT_MATCH.

Signed-off-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220619111952.8487-1-maccraft123mc@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 4e853acfd1e8..df87ba99a87c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -152,6 +152,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "AYA NEO 2021"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO NEXT */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_BOARD_NAME, "NEXT"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Chuwi HiBook (CWI514) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
-- 
2.35.1

