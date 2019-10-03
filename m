Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8071CA8C8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbfJCQcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391959AbfJCQcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:32:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499712133F;
        Thu,  3 Oct 2019 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120370;
        bh=FdSpS9PdX8CaNXfj0Fl/oV1rmce5v6VKCnvC7P0Fu/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9bYLO3IpfbVAnPx2M0Xpp2Agi2PQol3uGrj9dkOt3D6r1FI8+CQcs67Wl0WflDXW
         EDOWvpKlZkQ/QEKIXRihxI6VTW234IJwv+/nmmRV97Z7L0x2aP/BO5/y7057+X/51U
         IGheSEF4kiINuyKYSBJPpGtUo7UUwkM22TuDiqdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Easton <kevin@guarana.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Subject: [PATCH 5.2 196/313] libertas: Add missing sentinel at end of if_usb.c fw_table
Date:   Thu,  3 Oct 2019 17:52:54 +0200
Message-Id: <20191003154552.277643242@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
 drivers/net/wireless/marvell/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index f1622f0ff8c9e..fe3142d85d1e4 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -50,7 +50,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static const struct usb_device_id if_usb_table[] = {
-- 
2.20.1



