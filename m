Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA3242B174
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbhJMA6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236952AbhJMA5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8504060FDA;
        Wed, 13 Oct 2021 00:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086543;
        bh=Z4A8KBGrqXdKQgf8HEzuoBslpGCjbeYzuutvvudWqeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1cW6TrtLWKqouI6iifYOszDLL5OECPhJR9RDFcXKYOD0xV6DndMJJugo1lvtpauM
         jrXV62z/7i6DcCPoqxfqXrYIe9nOE8zB1I0ezuOl7Rcx2l6DE5Evf/VZxdBPoMwys+
         3jHc/KUpH+XbIs4TFnoIl2LZG2l2sxP3jxGQPZgJZ9moAwHTbF3Dqiwr8yaxTrAr/g
         MKh6w9ByIkEV9rwBSYioEu+PiH7hWUkYP/ijAVGdfsh3rzTA+JtLYSrsQ/VuV5tQgR
         c3IdcaxZatZzDvWuXqzYcciH0dh/199eyAAk+gCsxgI3RmoFM+ko0HwaHhKvzCn8eS
         mbkDiSpD8fiQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 06/11] drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI
Date:   Tue, 12 Oct 2021 20:55:26 -0400
Message-Id: <20211013005532.700190-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005532.700190-1-sashal@kernel.org>
References: <20211013005532.700190-1-sashal@kernel.org>
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
index 3c410d236c49..f3274eb6b341 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -33,6 +33,8 @@ config DRM_AMD_DC_HDCP
 
 config DRM_AMD_DC_SI
 	bool "AMD DC support for Southern Islands ASICs"
+	depends on DRM_AMDGPU_SI
+	depends on DRM_AMD_DC
 	default n
 	help
 	  Choose this option to enable new AMD DC support for SI asics
-- 
2.33.0

