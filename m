Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1011D378836
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbhEJLU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhEJLJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E73610A7;
        Mon, 10 May 2021 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644700;
        bh=EXK4iLNayhUOC3WWOSq/Lehhdmm+cANa20sK4cCvN84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGBXRjJjjEvV/UNHjwmGUac/DYcG75iepqz1/NTn/wHab5UZzEfXO1o6lvDf+XBsB
         J1BcpIc3x220mmKAUwvz/9HppEARhMaEeD7MjmftNkygKPldO8BenWFbibZPqP3RZG
         lW611tzh7oBdSlxfJ7O+agH5wt7hDN/ffP1OcO54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 153/384] drm/amd/display/dc/dce/dce_aux: Remove duplicate line causing field overwritten issue
Date:   Mon, 10 May 2021 12:19:02 +0200
Message-Id: <20210510102019.923319661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 3e3527f5b765c6f479ba55e5a570ee9538589a74 ]

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/gpu/drm/amd/amdgpu/../display/dc/dce112/dce112_resource.c:59:
 drivers/gpu/drm/amd/amdgpu/../include/asic_reg/dce/dce_11_2_sh_mask.h:10014:58: warning: initialized field overwritten [-Woverride-init]
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:214:16: note: in expansion of macro ‘AUX_SW_DATA__AUX_SW_AUTOINCREMENT_DISABLE__SHIFT’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:127:2: note: in expansion of macro ‘AUX_SF’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce112/dce112_resource.c:177:2: note: in expansion of macro ‘DCE_AUX_MASK_SH_LIST’
 drivers/gpu/drm/amd/amdgpu/../include/asic_reg/dce/dce_11_2_sh_mask.h:10014:58: note: (near initialization for ‘aux_shift.AUX_SW_AUTOINCREMENT_DISABLE’)
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:214:16: note: in expansion of macro ‘AUX_SW_DATA__AUX_SW_AUTOINCREMENT_DISABLE__SHIFT’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:127:2: note: in expansion of macro ‘AUX_SF’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce112/dce112_resource.c:177:2: note: in expansion of macro ‘DCE_AUX_MASK_SH_LIST’
 drivers/gpu/drm/amd/amdgpu/../include/asic_reg/dce/dce_11_2_sh_mask.h:10013:56: warning: initialized field overwritten [-Woverride-init]
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:214:16: note: in expansion of macro ‘AUX_SW_DATA__AUX_SW_AUTOINCREMENT_DISABLE_MASK’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:127:2: note: in expansion of macro ‘AUX_SF’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce112/dce112_resource.c:181:2: note: in expansion of macro ‘DCE_AUX_MASK_SH_LIST’
 drivers/gpu/drm/amd/amdgpu/../include/asic_reg/dce/dce_11_2_sh_mask.h:10013:56: note: (near initialization for ‘aux_mask.AUX_SW_AUTOINCREMENT_DISABLE’)
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:214:16: note: in expansion of macro ‘AUX_SW_DATA__AUX_SW_AUTOINCREMENT_DISABLE_MASK’
 drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_aux.h:127:2: note: in expansion of macro ‘AUX_SF’

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
index 277484cf853e..d4be5954d7aa 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
@@ -99,7 +99,6 @@ struct dce110_aux_registers {
 	AUX_SF(AUX_SW_CONTROL, AUX_SW_GO, mask_sh),\
 	AUX_SF(AUX_SW_DATA, AUX_SW_AUTOINCREMENT_DISABLE, mask_sh),\
 	AUX_SF(AUX_SW_DATA, AUX_SW_DATA_RW, mask_sh),\
-	AUX_SF(AUX_SW_DATA, AUX_SW_AUTOINCREMENT_DISABLE, mask_sh),\
 	AUX_SF(AUX_SW_DATA, AUX_SW_INDEX, mask_sh),\
 	AUX_SF(AUX_SW_DATA, AUX_SW_DATA, mask_sh),\
 	AUX_SF(AUX_SW_STATUS, AUX_SW_REPLY_BYTE_COUNT, mask_sh),\
-- 
2.30.2



