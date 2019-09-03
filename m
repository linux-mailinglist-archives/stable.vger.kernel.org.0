Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C81A7036
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfICQZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbfICQZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E4D23697;
        Tue,  3 Sep 2019 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527950;
        bh=3HZcg6Wa9KHkOEdnpkOwcP6R0/P6zfM1cCkAiJLfuVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KryyxzS6sCfmWJzps3F/DvOnbU+2LhntOudlxb2vJNc0a3Zuzsfy66F81WxNkNErO
         FDiHzUEiDHi5UP55layqjllxKSLRafw9YAiyii0iNjoePXqfjNFq0m5B371Wk4H7vs
         lrIpZDKeYVIfkRW7mEjdkmVDNpyhkLb1OuHrhOyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 017/167] drm/i915: Rename PLANE_CTL_DECOMPRESSION_ENABLE
Date:   Tue,  3 Sep 2019 12:22:49 -0400
Message-Id: <20190903162519.7136-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>

[ Upstream commit 53867b46fa8443713b3aee520d6ca558b222d829 ]

Rename PLANE_CTL_DECOMPRESSION_ENABLE to resemble the bpsec name -
PLANE_CTL_RENDER_DECOMPRESSION_ENABLE

Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180822015053.1420-2-dhinakaran.pandiyan@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_reg.h      | 2 +-
 drivers/gpu/drm/i915/intel_display.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 16f5d2d938014..4e070afb2738b 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6531,7 +6531,7 @@ enum {
 #define   PLANE_CTL_YUV422_UYVY			(1 << 16)
 #define   PLANE_CTL_YUV422_YVYU			(2 << 16)
 #define   PLANE_CTL_YUV422_VYUY			(3 << 16)
-#define   PLANE_CTL_DECOMPRESSION_ENABLE	(1 << 15)
+#define   PLANE_CTL_RENDER_DECOMPRESSION_ENABLE	(1 << 15)
 #define   PLANE_CTL_TRICKLE_FEED_DISABLE	(1 << 14)
 #define   PLANE_CTL_PLANE_GAMMA_DISABLE		(1 << 13) /* Pre-GLK */
 #define   PLANE_CTL_TILED_MASK			(0x7 << 10)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3bd44d042a1d9..f5367bdc04049 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3561,11 +3561,11 @@ static u32 skl_plane_ctl_tiling(uint64_t fb_modifier)
 	case I915_FORMAT_MOD_Y_TILED:
 		return PLANE_CTL_TILED_Y;
 	case I915_FORMAT_MOD_Y_TILED_CCS:
-		return PLANE_CTL_TILED_Y | PLANE_CTL_DECOMPRESSION_ENABLE;
+		return PLANE_CTL_TILED_Y | PLANE_CTL_RENDER_DECOMPRESSION_ENABLE;
 	case I915_FORMAT_MOD_Yf_TILED:
 		return PLANE_CTL_TILED_YF;
 	case I915_FORMAT_MOD_Yf_TILED_CCS:
-		return PLANE_CTL_TILED_YF | PLANE_CTL_DECOMPRESSION_ENABLE;
+		return PLANE_CTL_TILED_YF | PLANE_CTL_RENDER_DECOMPRESSION_ENABLE;
 	default:
 		MISSING_CASE(fb_modifier);
 	}
@@ -8812,13 +8812,13 @@ skylake_get_initial_plane_config(struct intel_crtc *crtc,
 		fb->modifier = I915_FORMAT_MOD_X_TILED;
 		break;
 	case PLANE_CTL_TILED_Y:
-		if (val & PLANE_CTL_DECOMPRESSION_ENABLE)
+		if (val & PLANE_CTL_RENDER_DECOMPRESSION_ENABLE)
 			fb->modifier = I915_FORMAT_MOD_Y_TILED_CCS;
 		else
 			fb->modifier = I915_FORMAT_MOD_Y_TILED;
 		break;
 	case PLANE_CTL_TILED_YF:
-		if (val & PLANE_CTL_DECOMPRESSION_ENABLE)
+		if (val & PLANE_CTL_RENDER_DECOMPRESSION_ENABLE)
 			fb->modifier = I915_FORMAT_MOD_Yf_TILED_CCS;
 		else
 			fb->modifier = I915_FORMAT_MOD_Yf_TILED;
-- 
2.20.1

