Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90932E1788
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgLWCSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgLWCSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E0B23341;
        Wed, 23 Dec 2020 02:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689835;
        bh=7smt5Nbw/mwOG2CpwBEnVx/tDr69zosBjPJScyDkKb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzNSjTdxQnou4rChDgn38dEMbxSnDH4J7sGrxV7/NLjejx2YFONwCPgr6NaTab4SV
         3546wF7Uc8IkbOhTtq8k+IRpHRDpICsLNzr94ehL6OFHXhAJB/mpCzEgDh5XcTclQ0
         SlE0W+v5xtyWB6ht+EFBPp+Fs+kiTCTn6YueBPibpIZOVvSMvGhfwatPh+/zoOxAP8
         rF9S3P/GpECXj2dHpWWESL5y/jaO1Qu2Uk9pfkA0pD30s2T/a+jJAzlqwcN57RVbVq
         b3kxfPck7A+t76l/s5ga3L7rB+k0YjEkvJawO8fQqxC0+ofLGzAJEWB9TgzoqrPKcN
         I6/wojApY2BFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Wang <kevin1.wang@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 036/217] drm/amdgpu: add missing clock gating info in amdgpu_pm_info
Date:   Tue, 22 Dec 2020 21:13:25 -0500
Message-Id: <20201223021626.2790791-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

[ Upstream commit 71037bfc78bf63a6640792ace925741767fb6bfc ]

add missing clock gating informations in amdgpu_pm_info
1. AMD_CG_SUPPORT_VCN_MGCG
2. AMD_CG_SUPPORT_HDP_DS
3. AMD_CG_SUPPORT_HDP_SD
4. AMD_CG_SUPPORT_IH_CG
5. AMD_CG_SUPPORT_JPEG_MGCG

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 529816637c731..0cfba189cde6c 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -63,6 +63,11 @@ static const struct cg_flag_name clocks[] = {
 	{AMD_CG_SUPPORT_DRM_LS, "Digital Right Management Light Sleep"},
 	{AMD_CG_SUPPORT_ROM_MGCG, "Rom Medium Grain Clock Gating"},
 	{AMD_CG_SUPPORT_DF_MGCG, "Data Fabric Medium Grain Clock Gating"},
+	{AMD_CG_SUPPORT_VCN_MGCG, "VCN Medium Grain Clock Gating"},
+	{AMD_CG_SUPPORT_HDP_DS, "Host Data Path Deep Sleep"},
+	{AMD_CG_SUPPORT_HDP_SD, "Host Data Path Shutdown"},
+	{AMD_CG_SUPPORT_IH_CG, "Interrupt Handler Clock Gating"},
+	{AMD_CG_SUPPORT_JPEG_MGCG, "JPEG Medium Grain Clock Gating"},
 
 	{AMD_CG_SUPPORT_ATHUB_MGCG, "Address Translation Hub Medium Grain Clock Gating"},
 	{AMD_CG_SUPPORT_ATHUB_LS, "Address Translation Hub Light Sleep"},
-- 
2.27.0

