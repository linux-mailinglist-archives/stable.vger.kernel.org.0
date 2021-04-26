Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA66C36AE2A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhDZHlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233619AbhDZHjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FFB3613DA;
        Mon, 26 Apr 2021 07:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422693;
        bh=QojXK7wiujZJFaHKj2KA7Q+Urf1xSi2RlQTyuC9KNFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AoqWRuIO/RQOkU/WqNpDsrTqDaW3atRMnG9HxKeuWodBY9g7xRQxqjsDtZIlmPyp1
         PQ4BW6fZMSdmiQudipRu5wTmXNc6d+ORllIJVIkiEX7XVfE6TqF7m2ST1rI10ccykL
         RiCOJjaMAyTh9PYAcBcl9V4/qXJOgUIRWdtFyg4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/20] HID: wacom: Assign boolean values to a bool variable
Date:   Mon, 26 Apr 2021 09:30:02 +0200
Message-Id: <20210426072817.053088518@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bf0621e44619..b21cf764afc0 100644
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



