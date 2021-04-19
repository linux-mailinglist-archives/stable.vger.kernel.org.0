Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B348364C12
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbhDSUsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240295AbhDSUqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EE1613CF;
        Mon, 19 Apr 2021 20:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865122;
        bh=qcaz2jB7fq9VIbH3JTlATGPVy+TRwlcy5hkg5pGsbyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzRHmx8pXA+Zr2SWa0AyMefA9ozAhl+MVjcHe9wnRehJ6BtufondfknaBbXuCS+ry
         XAb7h6HmHZkOA2eavDCVOq73GtEdXvWAf1BWe7RxHsR5ThBV+Cg7C7BZmQf1Gy5nmo
         5UMm3f5Z42CJ4+8qKwFv2j1DrzG1+PjuceUlP7hHa2aGlBakJoi0Il/obxF2sQfoEL
         8OEk0nIl2IMzjbMRCYldTy9Dh+fD0SlUvjrVXLsL2RMd2x3c+xx2mn6f3RwC+sdJYi
         RboPtH0sKeofZE37iq62qS5Z64ttJHXZX9k3wlhpsuEgRz8rMTeAyOvl/cdP6xGbVU
         igwdv0LIl3l+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/12] HID: wacom: Assign boolean values to a bool variable
Date:   Mon, 19 Apr 2021 16:45:08 -0400
Message-Id: <20210419204517.6770-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204517.6770-1-sashal@kernel.org>
References: <20210419204517.6770-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

[ Upstream commit e29c62ffb008829dc8bcc0a2ec438adc25a8255e ]

Fix the following coccicheck warnings:

./drivers/hid/wacom_wac.c:2536:2-6: WARNING: Assignment of
0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 274a55702784..187eda37dca1 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2496,7 +2496,7 @@ static void wacom_wac_finger_slot(struct wacom_wac *wacom_wac,
 	    !wacom_wac->shared->is_touch_on) {
 		if (!wacom_wac->shared->touch_down)
 			return;
-		prox = 0;
+		prox = false;
 	}
 
 	wacom_wac->hid_data.num_received++;
-- 
2.30.2

