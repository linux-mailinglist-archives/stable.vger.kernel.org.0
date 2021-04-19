Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346F0364BDF
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242979AbhDSUq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242787AbhDSUph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9304613B4;
        Mon, 19 Apr 2021 20:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865099;
        bh=H6iah+mQr1vIFnloxJ/XlQqwhw27TWSEsolJisjrfAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRsjD+BFlIWAv+FJy4kFXlfXlbGLDBYHcMgzlQEAnF9UciqiZXQXoDui4QhXmAowa
         fv1Sd9QvO8UaRvFIXjDxzJQDSZcoVABtuOGIGZxWn1kkIuy5O1qykFHY78MhXNfDc7
         lgc6lzRYBv1qSQSAPNkPXLxTgUfAfPq57Bl4QvRDbAjagXUBr6AvcHkvGU9TrSuC3O
         hQ+cri9inDxT0Z31DHrXXqp+uwrkYg4TaNiti2aDXSM1y4E95cd7U0//QBflZhWfl6
         CevgOrp5RsJquSVdRvkS8101N5dvI0KgcW5QAb/R+n8YNYPB7yGGmWYnoxrrjWBom0
         HDw8cTCuVZMJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/14] HID: wacom: Assign boolean values to a bool variable
Date:   Mon, 19 Apr 2021 16:44:43 -0400
Message-Id: <20210419204454.6601-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
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
index f1928c1ac139..01a1f893c06c 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2533,7 +2533,7 @@ static void wacom_wac_finger_slot(struct wacom_wac *wacom_wac,
 	    !wacom_wac->shared->is_touch_on) {
 		if (!wacom_wac->shared->touch_down)
 			return;
-		prox = 0;
+		prox = false;
 	}
 
 	wacom_wac->hid_data.num_received++;
-- 
2.30.2

