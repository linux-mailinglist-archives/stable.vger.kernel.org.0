Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD52FC8D2
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbhATCab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A992245C;
        Wed, 20 Jan 2021 01:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106005;
        bh=kMn8CfxQziRnH48xb4v4RCCNXXh+0G5URM2cOoDmtm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELfPLZ8zOUh7ySsHr9hICofuPW8t7z1Q4MEMxm+xuyBhH0lW0uR6AQx7vGHxRFaYo
         wkIdAYpoxYT2ERAZaDMK5kTJexJmcwYpJwLywzRqOD+IpYKVTGyZ/lEOmfjLzbUhRY
         IX5h+Y5OxfoF2cLoPKD+a9wdCVGE/PSj3Vnb++ZRX6dYF4IX/Giep9OsnelnK+VISe
         52FE/CQSMl5Zga5rNTuGbC1cV4QjdaOXcdEu9SuTrY+IJ7IfPDRcOlotITvxybOZQJ
         hb/oEnYNAdFjXEh4VAQWLCk4J3HrdYSBkfYJeH2WjqfEqSrzXwgS7HqotT2RmCSmi5
         pITLoiBDWeclA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Zhao <Victor.Zhao@amd.com>,
        "Emily . Deng" <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 32/45] drm/amdgpu/psp: fix psp gfx ctrl cmds
Date:   Tue, 19 Jan 2021 20:25:49 -0500
Message-Id: <20210120012602.769683-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit f14a5c34d143f6627f0be70c0de1d962f3a6ff1c ]

psp GFX_CTRL_CMD_ID_CONSUME_CMD different for windows and linux,
according to psp, linux cmds are not correct.

v2: only correct GFX_CTRL_CMD_ID_CONSUME_CMD.

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Reviewed-by: Emily.Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h b/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
index 4137dc710aafd..7ad0434be293b 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
+++ b/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
@@ -47,7 +47,7 @@ enum psp_gfx_crtl_cmd_id
     GFX_CTRL_CMD_ID_DISABLE_INT     = 0x00060000,   /* disable PSP-to-Gfx interrupt */
     GFX_CTRL_CMD_ID_MODE1_RST       = 0x00070000,   /* trigger the Mode 1 reset */
     GFX_CTRL_CMD_ID_GBR_IH_SET      = 0x00080000,   /* set Gbr IH_RB_CNTL registers */
-    GFX_CTRL_CMD_ID_CONSUME_CMD     = 0x000A0000,   /* send interrupt to psp for updating write pointer of vf */
+    GFX_CTRL_CMD_ID_CONSUME_CMD     = 0x00090000,   /* send interrupt to psp for updating write pointer of vf */
     GFX_CTRL_CMD_ID_DESTROY_GPCOM_RING = 0x000C0000, /* destroy GPCOM ring */
 
     GFX_CTRL_CMD_ID_MAX             = 0x000F0000,   /* max command ID */
-- 
2.27.0

