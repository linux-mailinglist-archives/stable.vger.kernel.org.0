Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCB735CB74
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbhDLQYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243711AbhDLQYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CFFC61287;
        Mon, 12 Apr 2021 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244635;
        bh=FNUg1XRVrOeOXuEXVMppXQbDhVGuqH6mQqna3Sckp14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvLtEjwfc9pXkWzymVd3UIHgjJ2nSu0ZhkzZiSAEJQeFnH795aQ5P4khRUnENyleG
         6dzc/gHNO6RW9+d2QfGVdk8geckAAK1XTBZiDR/sthJr9YwyF1j2zoTfVhplgH+S/j
         c46Zh00VSNQl8Q4J+RRcP7X5cU54XROUVcIr/6euaPTnasHcBqe1as35oTtjXS0obJ
         astHl+HIIOzB505aXmZuMhcPtXYXXbD1631MMrIHNFFfxn2RNg1a1fB+fWd6KdGo7v
         sQU3P+Aw/2OniSDtuHrrQW7m3ip3bXJTDVEWsHCtZTspqbvFfT6IAb2Iu7Mjl/Ts83
         dktyOyDUnoe3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 47/51] drm/amd/display: Add missing mask for DCN3
Date:   Mon, 12 Apr 2021 12:22:52 -0400
Message-Id: <20210412162256.313524-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit df7232c4c676be29f1cf45058ec156c1183539ff ]

[Why]
DCN3 is not reusing DCN1 mask_sh_list, causing
SURFACE_FLIP_INT_MASK missing in the mapping.

[How]
Add the corresponding entry to DCN3 list.

Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h
index 5fa150f34c60..2e89acf46e54 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h
@@ -133,6 +133,7 @@
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_SURFACE_DCC_EN, mask_sh),\
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_SURFACE_DCC_IND_BLK, mask_sh),\
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_SURFACE_DCC_IND_BLK_C, mask_sh),\
+	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_FLIP_INTERRUPT, SURFACE_FLIP_INT_MASK, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, DET_BUF_PLANE1_BASE_ADDRESS, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, CROSSBAR_SRC_CB_B, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, CROSSBAR_SRC_CR_R, mask_sh),\
-- 
2.30.2

