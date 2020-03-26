Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AB194CE7
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgCZXYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgCZXYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193C220A8B;
        Thu, 26 Mar 2020 23:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265083;
        bh=gmDm55ev+jBU5e+PcU2wskqxgzx4vGLTtfMr1tuFboE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBt6SHKgUaEAbg4cSciVRd5j0DA6u2tRtKTNBv+5YnDut2oelnTvT6SYgkHDq1BI3
         1Mxks5L6LVypPiSvF+g5qAZLKtFT35bUyBB3bciZ4TrtbQE+jNhvhrv9eO0f1dnX2+
         B9Skef/dbkQgDx5BGsWCHe6+O42SDl2XHQAkHb9c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Zhu <James.Zhu@amd.com>, Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/19] drm/amdgpu: fix typo for vcn1 idle check
Date:   Thu, 26 Mar 2020 19:24:22 -0400
Message-Id: <20200326232431.7816-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

[ Upstream commit acfc62dc68770aa665cc606891f6df7d6d1e52c0 ]

fix typo for vcn1 idle check

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
index 93b3500e522b8..4f0f0de832937 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -1375,7 +1375,7 @@ static int vcn_v1_0_set_clockgating_state(void *handle,
 
 	if (enable) {
 		/* wait for STATUS to clear */
-		if (vcn_v1_0_is_idle(handle))
+		if (!vcn_v1_0_is_idle(handle))
 			return -EBUSY;
 		vcn_v1_0_enable_clock_gating(adev);
 	} else {
-- 
2.20.1

