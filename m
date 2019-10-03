Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5CCABB8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfJCP6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbfJCP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118E3207FF;
        Thu,  3 Oct 2019 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118330;
        bh=uJycNw4DL+U+YCISpHKsr1iB52emBHrVSbHwAuMW0VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lp4lHbiLVDStTXKmA8jEarTnlxGJEDsbR8KR2W1jYwqXSDLmc1SGV9fYGOjW/YwGy
         If3+oTnLURSjGNLtsDQkCFWcVh/tcNjzm98zHwOuL3Na9Mh3Mz8iB4+opVtT/Up2vO
         nrHxgozRLRh5GE2VX7UNd+/DGaTTCBUrsHbbfRWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Easton <kevin@guarana.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Subject: [PATCH 4.4 71/99] libertas: Add missing sentinel at end of if_usb.c fw_table
Date:   Thu,  3 Oct 2019 17:53:34 +0200
Message-Id: <20191003154331.703444750@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Easton <kevin@guarana.org>

[ Upstream commit 764f3f1ecffc434096e0a2b02f1a6cc964a89df6 ]

This sentinel tells the firmware loading process when to stop.

Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Signed-off-by: Kevin Easton <kevin@guarana.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index dff08a2896a38..d271eaf1f9499 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -49,7 +49,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static struct usb_device_id if_usb_table[] = {
-- 
2.20.1



