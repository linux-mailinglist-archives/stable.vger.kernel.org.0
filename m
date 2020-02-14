Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2905815EA17
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392116AbgBNQNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392109AbgBNQNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88796246B7;
        Fri, 14 Feb 2020 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696788;
        bh=BHIfYJMas2lvRb0ipLb/9rRj9do8UXSNjYrnTNbwiCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SghAdiBY9mDit94mDNqPCN9/PhlUvXaSJ3mMW3s9j8o64y+Ju835LMt+d+GeuMiit
         NuvvH73ACUMtYSbal/gQNhLcn4xaxK2tpd4xW3vEpvyMr9/ZMgS2fA1weMOpBBrvEZ
         jFpytqOmzrUapOGXENeVWA8GeA+2yJUmRzORCfKs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 063/252] drm/gma500: remove set but not used variable 'htotal'
Date:   Fri, 14 Feb 2020 11:08:38 -0500
Message-Id: <20200214161147.15842-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit dfa703b6f91818fa9f652c00e3589c104c518930 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/gma500/oaktrail_hdmi.c: In function htotal_calculate:
drivers/gpu/drm/gma500/oaktrail_hdmi.c:160:6: warning: variable htotal set but not used [-Wunused-but-set-variable]

It is introduced by commit 39ec748f7174 ("gma600: Enable HDMI support"),
but never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1573828027-122323-2-git-send-email-zhengbin13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi.c b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
index c6d72de1c0548..70323d3461c82 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -157,9 +157,7 @@ static void oaktrail_hdmi_audio_disable(struct drm_device *dev)
 
 static unsigned int htotal_calculate(struct drm_display_mode *mode)
 {
-	u32 htotal, new_crtc_htotal;
-
-	htotal = (mode->crtc_hdisplay - 1) | ((mode->crtc_htotal - 1) << 16);
+	u32 new_crtc_htotal;
 
 	/*
 	 * 1024 x 768  new_crtc_htotal = 0x1024;
-- 
2.20.1

