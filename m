Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A3115E061
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgBNQNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392104AbgBNQNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5308246A4;
        Fri, 14 Feb 2020 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696784;
        bh=CzjAbN0XKQeBrgO/A8BIBteoB3pvZMtiDwAODdAw5Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJnl+fSfXEhE+wPHyjklSDiNgj3C9AngXWCJxF3wF24CXIDGPk4Uu7kK+bwIa4bfy
         ezpBLvBCVkagWhG4LLDGe9CY6CuJhrJ65ghUE56fdlXwfC30j26a7QccnQCilIknE2
         ZtvZmaI7uMMDKKl6e4tAOeEsfP3i7YVy3Eko5cNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 060/252] drm/amdgpu: remove set but not used variable 'amdgpu_connector'
Date:   Fri, 14 Feb 2020 11:08:35 -0500
Message-Id: <20200214161147.15842-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 4f2922d12d6c63d0f4aa4e859ad95aee6d0d4ea0 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/amdgpu_display.c: In function
‘amdgpu_display_crtc_scaling_mode_fixup’:
drivers/gpu/drm/amd/amdgpu/amdgpu_display.c:693:27: warning: variable
‘amdgpu_connector’ set but not used [-Wunused-but-set-variable]

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 686a26de50f91..a49767e60af04 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -667,7 +667,6 @@ bool amdgpu_display_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
 	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
 	struct amdgpu_encoder *amdgpu_encoder;
 	struct drm_connector *connector;
-	struct amdgpu_connector *amdgpu_connector;
 	u32 src_v = 1, dst_v = 1;
 	u32 src_h = 1, dst_h = 1;
 
@@ -679,7 +678,6 @@ bool amdgpu_display_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
 			continue;
 		amdgpu_encoder = to_amdgpu_encoder(encoder);
 		connector = amdgpu_get_connector_for_encoder(encoder);
-		amdgpu_connector = to_amdgpu_connector(connector);
 
 		/* set scaling */
 		if (amdgpu_encoder->rmx_type == RMX_OFF)
-- 
2.20.1

