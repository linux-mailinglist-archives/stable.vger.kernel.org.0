Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76A815E2B6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393239AbgBNQYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:24:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391698AbgBNQYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5843A247B4;
        Fri, 14 Feb 2020 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697494;
        bh=BQJuOhwiFzR0YfTDvjEyEhX4oiBSP7DJekFRr255qos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jU24lNhviS08lE3UgVHeQzIpc+YsW5Cr+RuSDK/HLPSBItzDcnqeItrrKkSJHG9j
         ioS3UyG+kel8vx+rao006mNvJc6CstRGMpcALYQnkZ4cJagbpdXTtKfnAblR1RAPtg
         3D8NBJfLiKRcchy/HE7bd1NamrKa3r9v1XIiDwuQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 023/100] drm/amdgpu: remove set but not used variable 'dig'
Date:   Fri, 14 Feb 2020 11:23:07 -0500
Message-Id: <20200214162425.21071-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit d1d09dc417826f5a983e0f4f212f227beeb65e29 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/atombios_dp.c: In function
‘amdgpu_atombios_dp_link_train’:
drivers/gpu/drm/amd/amdgpu/atombios_dp.c:716:34: warning: variable ‘dig’
set but not used [-Wunused-but-set-variable]

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atombios_dp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atombios_dp.c b/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
index 120a5fd992081..5448127daf27c 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_dp.c
@@ -712,7 +712,6 @@ void amdgpu_atombios_dp_link_train(struct drm_encoder *encoder,
 	struct drm_device *dev = encoder->dev;
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_encoder *amdgpu_encoder = to_amdgpu_encoder(encoder);
-	struct amdgpu_encoder_atom_dig *dig;
 	struct amdgpu_connector *amdgpu_connector;
 	struct amdgpu_connector_atom_dig *dig_connector;
 	struct amdgpu_atombios_dp_link_train_info dp_info;
@@ -720,7 +719,6 @@ void amdgpu_atombios_dp_link_train(struct drm_encoder *encoder,
 
 	if (!amdgpu_encoder->enc_priv)
 		return;
-	dig = amdgpu_encoder->enc_priv;
 
 	amdgpu_connector = to_amdgpu_connector(connector);
 	if (!amdgpu_connector->con_priv)
-- 
2.20.1

