Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D223582D3E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiG0QzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiG0QyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:54:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93CD4D4DF;
        Wed, 27 Jul 2022 09:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0EA64CE2301;
        Wed, 27 Jul 2022 16:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C0C433D6;
        Wed, 27 Jul 2022 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939735;
        bh=F8ZiAE7YZXuQSsyBrtT3P/GZVlUNUGHQ+fXJZiNmSOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+9fIqaS3ium9F6SOTNmgYgOOhGngfbrJnO5ZZ+NuyO++l+GnMHRYr+wNt72ttvtv
         JBeUGadJu7euQqHTNaCgrVu5BWDDQzNmA9/UHW4k/bH7pk1gYNjgACZR2UeocKeucx
         F/2jL20YU48f5WWkSCWee9lk8w7fq0ZDi+dr+ff8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/105] drm/imx/dcss: fix unused but set variable warnings
Date:   Wed, 27 Jul 2022 18:11:10 +0200
Message-Id: <20220727161015.469788131@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 523be44c334bc4e4c014032738dc277b8909d009 ]

Fix unused but set variable warning building with `make W=1`:

drivers/gpu/drm/imx/dcss/dcss-plane.c:270:6: warning:
 variable ‘pixel_format’ set but not used [-Wunused-but-set-variable]
  u32 pixel_format;
      ^~~~~~~~~~~~

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20200911014414.4663-1-bobo.shaobowang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-plane.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-plane.c b/drivers/gpu/drm/imx/dcss/dcss-plane.c
index f54087ac44d3..46a188dd02ad 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-plane.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-plane.c
@@ -268,7 +268,6 @@ static void dcss_plane_atomic_update(struct drm_plane *plane,
 	struct dcss_plane *dcss_plane = to_dcss_plane(plane);
 	struct dcss_dev *dcss = plane->dev->dev_private;
 	struct drm_framebuffer *fb = state->fb;
-	u32 pixel_format;
 	struct drm_crtc_state *crtc_state;
 	bool modifiers_present;
 	u32 src_w, src_h, dst_w, dst_h;
@@ -279,7 +278,6 @@ static void dcss_plane_atomic_update(struct drm_plane *plane,
 	if (!fb || !state->crtc || !state->visible)
 		return;
 
-	pixel_format = state->fb->format->format;
 	crtc_state = state->crtc->state;
 	modifiers_present = !!(fb->flags & DRM_MODE_FB_MODIFIERS);
 
-- 
2.35.1



