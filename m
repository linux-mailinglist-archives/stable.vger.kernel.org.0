Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D2E15C5E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEGGDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbfEGFfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF8821726;
        Tue,  7 May 2019 05:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207310;
        bh=cPZo9AmpcZJ5rukK0yocOfPyUIQc/OAjyydpmRqxFf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2ye/7gbELg8KEuF43Z6q4gtdla6VcKepFP0VJ2F1bFLX373KiN0Oq390rnz82E1s
         aMHu/5yYkCC3srBA9ECIhQCw/oskiTMW8K22bxKvP+XO0/vldYhCfJZZJXwG9xiYgV
         ewX2u4GW5LdBsyP8haOUhTdu8WIVPddgS07YVsUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 79/99] drm/imx: don't skip DP channel disable for background plane
Date:   Tue,  7 May 2019 01:32:13 -0400
Message-Id: <20190507053235.29900-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 7bcde275eb1d0ac8793c77c7e666a886eb16633d ]

In order to make sure that the plane color space gets reset correctly.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 058b53c0aa7e..1bb3e598cb84 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -70,7 +70,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	if (disable_partial)
 		ipu_plane_disable(ipu_crtc->plane[1], true);
 	if (disable_full)
-		ipu_plane_disable(ipu_crtc->plane[0], false);
+		ipu_plane_disable(ipu_crtc->plane[0], true);
 }
 
 static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
-- 
2.20.1

