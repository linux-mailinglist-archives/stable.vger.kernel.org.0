Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F942E3C50
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391649AbgL1OBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408003AbgL1OA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1790B207AB;
        Mon, 28 Dec 2020 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164041;
        bh=vSw5rw6Fpr1fBMWW2xn9lqLpppnGa1ffPchi8EClX20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whUMwF6IV66L2KhiEV6q5S4xzsH91qLof9QDCrRoOR8R1qCHcA2JO2FcpJGBtseMY
         35ckYL8X2NuwcLEENUJUirh81sdrPX7V5hdSUjgADdoV2EC1IVtg1XTFd24XtNM8DE
         MCOCfPUDNVd40I048nr6oZUChMy+vIFyl++pM0qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/717] drm/msm: Add missing stub definition
Date:   Mon, 28 Dec 2020 13:40:36 +0100
Message-Id: <20201228125022.810951469@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit a0b21e0ad29420b04911a98d360b9586168eeae5 ]

DRM_MSM fails to build with DRM_MSM_DP=n; add the missing stub.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index b9dd8f8f48872..0b2686b060c73 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -423,6 +423,11 @@ static inline int msm_dp_display_disable(struct msm_dp *dp,
 {
 	return -EINVAL;
 }
+static inline int msm_dp_display_pre_disable(struct msm_dp *dp,
+					struct drm_encoder *encoder)
+{
+	return -EINVAL;
+}
 static inline void msm_dp_display_mode_set(struct msm_dp *dp,
 				struct drm_encoder *encoder,
 				struct drm_display_mode *mode,
-- 
2.27.0



