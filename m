Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF44D42B134
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhJMA5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236321AbhJMA5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881E660EBB;
        Wed, 13 Oct 2021 00:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086501;
        bh=dilo0xnTgQMspiRmJhCZhv2NP+IgRvNKPOZfOjw0JUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpvIjIxqjui9sDZNNbVfvVKkJft12uv0WeVWDizVgYm+DRw3IxFKfWT3DJ5Q20glm
         CZnboqrR7fUOAzzjhMi256AvC5Qf28X5M5QI9cqfaONrmgTsr6sELer+1p/tSWZeHI
         8KwzPMF43K9bIH4Betq7prZlb+TzDRmtRdYBrnOLp4euCGLT/yapCBq2y6CLGLQIwH
         //gR+8EcWlkW0+OONd39XcLQE6mjDVlFmaO6cPDqgvBoFRQGnHblK3jaGeXenVo69p
         DcAwUc3S6kHzusRfYinYgEVTaihM9t4p9pSkOoHV/AMQFZ8/6zBugprAFqY6NG+qDZ
         lO2YWnjZWnaYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 08/17] drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI
Date:   Tue, 12 Oct 2021 20:54:32 -0400
Message-Id: <20211013005441.699846-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4702b34d1de9582df9dfa0e583ea28fff7de29df ]

Depends on DRM_AMDGPU_SI and DRM_AMD_DC

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index 7dffc04a557e..127667e549c1 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -25,6 +25,8 @@ config DRM_AMD_DC_HDCP
 
 config DRM_AMD_DC_SI
 	bool "AMD DC support for Southern Islands ASICs"
+	depends on DRM_AMDGPU_SI
+	depends on DRM_AMD_DC
 	default n
 	help
 	  Choose this option to enable new AMD DC support for SI asics
-- 
2.33.0

