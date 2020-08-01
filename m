Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34A62351EA
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 13:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgHALrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 07:47:02 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37571 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbgHALrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 07:47:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 974EC762;
        Sat,  1 Aug 2020 07:47:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 01 Aug 2020 07:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Nx2i1H
        uHEXt7ju0QUGlEiLzFGEDHH1oFd7LnR3QpbvI=; b=twm0TmIgmrz4owO8deisQ4
        k8Bj2V7cDh4RC3ST6VsghqGBzi1hBwBxxtNQzVQKUoMg+c71qSVin6wVOO9fQE5W
        /BYjT9dO6uJWpoERBrMkkBfbI4Et9GSMU+zgTAHApssXBm0RXKfcu02uf2U7vkRU
        G0oPLydQWObA0a2+RXan/Iq/39jHQILZ3Hh2UZru7fsW36zKoJcgsxU5JaasSEIV
        BzM6ZVU1es/fpqJih2/0d0Qcu9C/mGeyomr3X55RvEQyTk7k1NoYdsNFlMQmhc8R
        +WLGMzRStDzAPM7l9k1NVvM1jr6sqnaFBItL/z9b4g7uZ9iY8iUQNDkm3S7PcDTQ
        ==
X-ME-Sender: <xms:NVYlXxCX8n3DFKiVNHpYsK0yqsxIGulpY_bB5LrqoVEorYwFbYiJJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NVYlX_jNuP4ZseEoI9pw0qttEdfi3ZhcLjU3a37AmArr2lKnkLvuCQ>
    <xmx:NVYlX8navGUWu-gnjQ-fNMA9U8G7oovVDvD2TfqiDWl4kgQRqcPwAQ>
    <xmx:NVYlX7wpKUKmLeg0bophc-3kx84BsPDBKsQUwGJfzGWPNgxkTxFeQg>
    <xmx:NVYlX9PHW9ooSRBbNODX-I0jYJvtAb9L3RYo9aj-kD-OI24EUQqdq1z8K2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5B35328005E;
        Sat,  1 Aug 2020 07:47:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] 9p/trans_fd: Fix concurrency del of req_list in" failed to apply to 4.9-stable tree
To:     wanghai38@huawei.com, asmadeus@codewreck.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 01 Aug 2020 13:46:34 +0200
Message-ID: <1596282394253233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74d6a5d5662975aed7f25952f62efbb6f6dadd29 Mon Sep 17 00:00:00 2001
From: Wang Hai <wanghai38@huawei.com>
Date: Fri, 12 Jun 2020 17:08:33 +0800
Subject: [PATCH] 9p/trans_fd: Fix concurrency del of req_list in
 p9_fd_cancelled/p9_read_work

p9_read_work and p9_fd_cancelled may be called concurrently.
In some cases, req->req_list may be deleted by both p9_read_work
and p9_fd_cancelled.

We can fix it by ignoring replies associated with a cancelled
request and ignoring cancelled request if message has been received
before lock.

Link: http://lkml.kernel.org/r/20200612090833.36149-1-wanghai38@huawei.com
Fixes: 60ff779c4abb ("9p: client: remove unused code and any reference to "cancelled" function")
Cc: <stable@vger.kernel.org> # v3.12+
Reported-by: syzbot+77a25acfa0382e06ab23@syzkaller.appspotmail.com
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 9c9196d30a59..12ecacf0c55f 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -362,6 +362,10 @@ static void p9_read_work(struct work_struct *work)
 		if (m->rreq->status == REQ_STATUS_SENT) {
 			list_del(&m->rreq->req_list);
 			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
+		} else if (m->rreq->status == REQ_STATUS_FLSHD) {
+			/* Ignore replies associated with a cancelled request. */
+			p9_debug(P9_DEBUG_TRANS,
+				 "Ignore replies associated with a cancelled request\n");
 		} else {
 			spin_unlock(&m->client->lock);
 			p9_debug(P9_DEBUG_ERROR,
@@ -703,11 +707,20 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 {
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
+	spin_lock(&client->lock);
+	/* Ignore cancelled request if message has been received
+	 * before lock.
+	 */
+	if (req->status == REQ_STATUS_RCVD) {
+		spin_unlock(&client->lock);
+		return 0;
+	}
+
 	/* we haven't received a response for oldreq,
 	 * remove it from the list.
 	 */
-	spin_lock(&client->lock);
 	list_del(&req->req_list);
+	req->status = REQ_STATUS_FLSHD;
 	spin_unlock(&client->lock);
 	p9_req_put(req);
 

