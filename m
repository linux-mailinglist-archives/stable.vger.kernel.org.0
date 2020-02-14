Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2115E433
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392700AbgBNQe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393322AbgBNQZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFC02479C;
        Fri, 14 Feb 2020 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697506;
        bh=yFT/HfqTv96zbqzm723myqHdTunLNrOuSTQ4e9ESzqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP3YhyCf02FyQ9FO2GTI05z5dLPTnHrGI0VPgS0lYgZlv++6PLydR8bwHak+6F5Zg
         +c0VrUHgTq/gRCzA+4Dw6g4E+2FO6JXRLouxH/FT5fWSb9/YIEp523RF+WvyWkby9p
         nB59UYeFdGgYKi8rOseYL0BjqXMDrUnDQ0kAUHi4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 033/100] drm/radeon: remove set but not used variable 'radeon_connector'
Date:   Fri, 14 Feb 2020 11:23:17 -0500
Message-Id: <20200214162425.21071-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 5952c48993375a9da2de39be30df475cf590b0ce ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/radeon/radeon_display.c: In function radeon_crtc_scaling_mode_fixup:
drivers/gpu/drm/radeon/radeon_display.c:1685:27: warning: variable radeon_connector set but not used [-Wunused-but-set-variable]

It is not used since commit 377bd8a98d7d ("drm/radeon:
use a fetch function to get the edid")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 446d990623069..b26e4eae7ac54 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1736,7 +1736,6 @@ bool radeon_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct radeon_encoder *radeon_encoder;
 	struct drm_connector *connector;
-	struct radeon_connector *radeon_connector;
 	bool first = true;
 	u32 src_v = 1, dst_v = 1;
 	u32 src_h = 1, dst_h = 1;
@@ -1749,7 +1748,6 @@ bool radeon_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
 			continue;
 		radeon_encoder = to_radeon_encoder(encoder);
 		connector = radeon_get_connector_for_encoder(encoder);
-		radeon_connector = to_radeon_connector(connector);
 
 		if (first) {
 			/* set scaling */
-- 
2.20.1

