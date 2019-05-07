Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA92A15B32
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEGFwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbfEGFj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9B12173B;
        Tue,  7 May 2019 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207568;
        bh=nFYURFvuVpxQr6PZfuvJhJPBqwO7DVZfkSLmcBK9RhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yt+zQlppAv87d2kOnr6B10znPN/5jgNBeh00Y6NNy064O+WPuEI1q9/XE+BJInv1z
         RVydpuOEUqvX2UZQl7sZ3fjUeqlfZr4/2VvqTET6T00Q7bOj47Pwq5qKwVq5B/u8qx
         MEJj0QMLhqdQnQ4a26b8xbhfwvnsxRMnskckihEo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 31/95] drm/imx: don't skip DP channel disable for background plane
Date:   Tue,  7 May 2019 01:37:20 -0400
Message-Id: <20190507053826.31622-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
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
index d976391dfa31..957fbf8c55eb 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -79,7 +79,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	if (disable_partial)
 		ipu_plane_disable(ipu_crtc->plane[1], true);
 	if (disable_full)
-		ipu_plane_disable(ipu_crtc->plane[0], false);
+		ipu_plane_disable(ipu_crtc->plane[0], true);
 }
 
 static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
-- 
2.20.1

