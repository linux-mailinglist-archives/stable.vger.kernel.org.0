Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0470715BAF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfEGFhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfEGFhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC57206A3;
        Tue,  7 May 2019 05:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207458;
        bh=jPj+qfC0PBo8njGqOIse2gC4CujCR4C+5GWUAVWXAMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Khcy91furzOPc5CfiC16BhSjb/Tt2MzESJCJvGBe/GH208ZxG7gcvcmQsNixApvLl
         cfBORxeSFdZxnW6RSNL2MuQwm3kzOLW6u3RWmIUI0izct9sRQ8oMGVLOyp+lxmXljS
         /8brE8okXEUN+8baFjnk6LV1ZMW4CdVCnTVUjyr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 54/81] drm/imx: don't skip DP channel disable for background plane
Date:   Tue,  7 May 2019 01:35:25 -0400
Message-Id: <20190507053554.30848-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
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
index 7d4b710b837a..11e2dcdd6b18 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -78,7 +78,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	if (disable_partial)
 		ipu_plane_disable(ipu_crtc->plane[1], true);
 	if (disable_full)
-		ipu_plane_disable(ipu_crtc->plane[0], false);
+		ipu_plane_disable(ipu_crtc->plane[0], true);
 }
 
 static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
-- 
2.20.1

