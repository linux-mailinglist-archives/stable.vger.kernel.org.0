Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805BF15DD4B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbgBNP5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388335AbgBNP5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 695E4206D7;
        Fri, 14 Feb 2020 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695861;
        bh=NCPh7QAILdwW6sZgMyC9KMgO2sRrkiBpBn7WM+PIb8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQQSwOXDoKuagdimiAOQ2/2zvPKZgMy5Ea6v959X/f+SEGm0imciF8KGt2bmCpTVk
         CFMMPkZp5b3V3Ftmotcf8BzETFLXTl+W3KO/uXskNHB7oqw4/bL/0F0QBUWgNYQy75
         xBtIj1rY2iPTrrfzJZFh/jNo4MlnJGr6qjP1t6vU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Pan, Xinhui" <Xinhui.Pan@amd.com>, Feifei Xu <Feifei.Xu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 408/542] drm/amdgpu: add the lost mutex_init back
Date:   Fri, 14 Feb 2020 10:46:40 -0500
Message-Id: <20200214154854.6746-408-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Pan, Xinhui" <Xinhui.Pan@amd.com>

[ Upstream commit bd0522112332663e386df1b8642052463ea9b3b9 ]

Initialize notifier_lock.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/1016
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 332b9c24a2cd0..a2f788ad7e1c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2797,6 +2797,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	mutex_init(&adev->notifier_lock);
 	mutex_init(&adev->virt.dpm_mutex);
 	mutex_init(&adev->psp.mutex);
+	mutex_init(&adev->notifier_lock);
 
 	r = amdgpu_device_check_arguments(adev);
 	if (r)
-- 
2.20.1

