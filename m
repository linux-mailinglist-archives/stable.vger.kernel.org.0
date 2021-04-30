Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9736FC2D
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhD3OV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233173AbhD3OVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82AA86146D;
        Fri, 30 Apr 2021 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792460;
        bh=yDSGE84PxeX08Iwur9LdUJe56jkviOGDSpoOQ3yU7/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6nkZXbHKaa+6ZpsPQaPwzTdJ+vqAopYuLJQb2Kx/QJA9otKyLJgVpAm453LDLvPH
         COQQ6B3+P5WxEgjofsuAs8MWY1UDIxCCOpc1ebryKSiJv5Le0AD2YIgqJJ9RzkDeOH
         dy/uAEK+K3VRg169PI7W+3Nc0tbuB+AMG3iinzP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 2/3] drm/amd/display: Update modifier list for gfx10_3
Date:   Fri, 30 Apr 2021 16:20:51 +0200
Message-Id: <20210430141910.771329106@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
References: <20210430141910.693887691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

commit 6d638b3ffd27036c062d32cb4efd4be172c2a65e upstream.

[Why]
Current list supports modifiers that have DCC_MAX_COMPRESSED_BLOCK
set to AMD_FMT_MOD_DCC_BLOCK_128B, while AMD_FMT_MOD_DCC_BLOCK_64B
is used instead by userspace.

[How]
Replace AMD_FMT_MOD_DCC_BLOCK_128B with AMD_FMT_MOD_DCC_BLOCK_64B
for modifiers with DCC supported.

Fixes: faa37f54ce0462 ("drm/amd/display: Expose modifiers")
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Tested-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4184,7 +4184,7 @@ add_gfx10_3_modifiers(const struct amdgp
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
@@ -4196,7 +4196,7 @@ add_gfx10_3_modifiers(const struct amdgp
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |


