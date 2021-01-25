Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A4F3031AB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbhAYSvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbhAYSvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74426224D1;
        Mon, 25 Jan 2021 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600634;
        bh=kMn8CfxQziRnH48xb4v4RCCNXXh+0G5URM2cOoDmtm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1F61VAS3wvZaNQEZNh+IPF/XiBJ2y6OGYLEO6WbHWZmG2VuvU0+UGT7OguGR1H1Rc
         mPg3FMlzpwvxfLuDRu/ou6g2yLk1YNnFm2u3eX6GVilDR6L+TYiyTnYTBXlQ56w9M1
         z5x2QJLQKv6A0iriKU1CfP7PP33an2+AI2O1wfBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Zhao <Victor.Zhao@amd.com>,
        "Emily.Deng" <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/199] drm/amdgpu/psp: fix psp gfx ctrl cmds
Date:   Mon, 25 Jan 2021 19:38:03 +0100
Message-Id: <20210125183218.850058628@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



