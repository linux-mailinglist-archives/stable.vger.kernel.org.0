Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFE7F314
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406346AbfHBJx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405471AbfHBJx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:53:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D8B82086A;
        Fri,  2 Aug 2019 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739637;
        bh=lTZt4r7kCi74yRtU/qLbL73nW1wDah+lru5/+Pv60Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBLvPAbwpdkdTfbD17hbbjR3CQWsSoBPOOjvxaZZSleJgr+1tMAiJL4Jd3MMnHv3L
         h94Gz97/Sqm+I9Hrv/q16s3x3Jj2L/DeXjXOsN5MAe88X2ITfOlOMnjxtIEpIZMCwm
         /aimHhFoznGej6otsOUXcSGIAAvszt6iWHzIac5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c1b25598aa60dcd47e78@syzkaller.appspotmail.com,
        Fabio Estevam <festevam@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 12/25] ath10k: Change the warning message string
Date:   Fri,  2 Aug 2019 11:39:44 +0200
Message-Id: <20190802092103.461535975@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 265df32eae5845212ad9f55f5ae6b6dcb68b187b upstream.

The "WARNING" string confuses syzbot, which thinks it found
a crash [1].

Change the string to avoid such problem.

[1] https://lkml.org/lkml/2019/5/9/243

Reported-by: syzbot+c1b25598aa60dcd47e78@syzkaller.appspotmail.com
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath10k/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1025,7 +1025,7 @@ static int ath10k_usb_probe(struct usb_i
 	}
 
 	/* TODO: remove this once USB support is fully implemented */
-	ath10k_warn(ar, "WARNING: ath10k USB support is incomplete, don't expect anything to work!\n");
+	ath10k_warn(ar, "Warning: ath10k USB support is incomplete, don't expect anything to work!\n");
 
 	return 0;
 


