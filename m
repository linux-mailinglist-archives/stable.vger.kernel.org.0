Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17F364C41
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhDSUuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241092AbhDSUsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2540613E1;
        Mon, 19 Apr 2021 20:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865140;
        bh=SkoBSXbmmv0oXSDIFiqFXAQ3njA2bHxvanTYMuRaALA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzQqdaZUKcXFAro0nVBA5c+j7UlBNA/gWobIQuvcNYlB3yNfOsstz+ihmt4obOBM+
         ywWGjG2+8Ge67HbuGqWWk/j+CbUBxK6hMCvwIhCNqYc4A7hY4a34B7cBNUDjF/5uvZ
         AJOIqPpIja5cyMPYCZ+rnSP2XaVM7PwOB4jHKxUFVGmfLwlTx8er3cxM6pSagH2vi2
         Ldvm7jbYLNQVjBCZnTcKnbwLsfJqcJxa1HlCyK47p5Hiy9CsbvmOYzB4LH1trNLubU
         vXUN1+4XcW7afDyG49i4sda1k6AWFiJrjjeWUUe8RqqpS+dMZvm87UGDOb3b6NV6Qz
         1V6TKF6MEClAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/11] HID: wacom: Assign boolean values to a bool variable
Date:   Mon, 19 Apr 2021 16:45:27 -0400
Message-Id: <20210419204536.6924-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204536.6924-1-sashal@kernel.org>
References: <20210419204536.6924-1-sashal@kernel.org>
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
index 8c0718b3754e..5e4c4ae6e193 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2391,7 +2391,7 @@ static void wacom_wac_finger_slot(struct wacom_wac *wacom_wac,
 	    !wacom_wac->shared->is_touch_on) {
 		if (!wacom_wac->shared->touch_down)
 			return;
-		prox = 0;
+		prox = false;
 	}
 
 	wacom_wac->hid_data.num_received++;
-- 
2.30.2

