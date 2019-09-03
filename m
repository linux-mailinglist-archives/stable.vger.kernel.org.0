Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB5EA6EC8
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfICQ2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbfICQ2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6A923789;
        Tue,  3 Sep 2019 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528110;
        bh=tV9a9uvOlH4HopRvLe6hsbfjnMkwSk+2KuG5xrr9efw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY0XNu1E2uX/707hqBAY2wIK/ifAHk6iB2MDT7Skf5fm6NkqTxq5JSq3C0yhyUiHX
         3dtMrINLx53oyf0lWfPCcw31ss8qxiMtnX56eCPDrblSm15W49mmsQ+kkTkC54hlCM
         ke1oKz3pltGlbRoTi7xLmuMwQ4FKxDhwjL5ILGgQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.rg, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 114/167] drm/amdkfd: Add missing Polaris10 ID
Date:   Tue,  3 Sep 2019 12:24:26 -0400
Message-Id: <20190903162519.7136-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Russell <kent.russell@amd.com>

[ Upstream commit 0a5a9c276c335870a1cecc4f02b76d6d6f663c8b ]

This was added to amdgpu but was missed in amdkfd

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.rg
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 5aba50f63ac6f..938d0053a8208 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -310,6 +310,7 @@ static const struct kfd_deviceid supported_devices[] = {
 	{ 0x67CF, &polaris10_device_info },	/* Polaris10 */
 	{ 0x67D0, &polaris10_vf_device_info },	/* Polaris10 vf*/
 	{ 0x67DF, &polaris10_device_info },	/* Polaris10 */
+	{ 0x6FDF, &polaris10_device_info },	/* Polaris10 */
 	{ 0x67E0, &polaris11_device_info },	/* Polaris11 */
 	{ 0x67E1, &polaris11_device_info },	/* Polaris11 */
 	{ 0x67E3, &polaris11_device_info },	/* Polaris11 */
-- 
2.20.1

