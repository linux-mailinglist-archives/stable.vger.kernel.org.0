Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9962351E9
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgHALrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 07:47:01 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53209 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbgHALrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 07:47:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 16F55853;
        Sat,  1 Aug 2020 07:47:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 01 Aug 2020 07:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Sib1O
        62w2yxhncMaPWvNfuzEhbv3LUJCzsRWAef6uA=; b=eGQ6kt10yew9eU/0yiXswV
        guX87+N9hb2ln1KaaucTbGFgdCyvq5PUcKgj9xjETK7kix8JmBONsI0p9glS382a
        IDRoERKdkCKyb1rhAuUmdR3MsPhcR0hEZcNkUkMC0/8Ogo419ERqyAIYBH4TO0CE
        XtFbbHlyr64I+3JQwrgkB8NIk5L89CIZXMkSgHk6PZuS90K2OQJ0JHdtm/ZP5Duo
        +/S7CG65TTpbTGCjQuHa3y/N1ky5G9joxUUCursvcnu+axtR2Fn3hsW6Z8GqU5SH
        ShaHeEaBuxiCRZzegdevAZkdgkXxNLrtj+GtpaflvFRlmBjmqvexIyqTjb9oIUvQ
        ==
X-ME-Sender: <xms:M1YlX7Cl75QKy_mwCv4Tj-GCGiEtaActglB6ruHWg_-Hw2H6NHw3cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:M1YlXxjIG19mqRLVXxaMqEGDZE6HW4HBB3pejdyw3nyxJzMOmC1eGA>
    <xmx:M1YlX2kaGrKBFZjBFjl0AB4MLTwHH-ElPqBSjeVO7RviE3KWb0bpzQ>
    <xmx:M1YlX9wAh_RW6I_RAzww5f2RLx8m0oHoflwYLdbNOvn_PjRrB2xzEg>
    <xmx:M1YlX_PlF8d0wj7UkyksIAqcTpXotg1_3VeBFSbtUYRN7dGpTSz-Ya7Ly9Y>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5209230600B1;
        Sat,  1 Aug 2020 07:46:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] 9p/trans_fd: Fix concurrency del of req_list in" failed to apply to 4.4-stable tree
To:     wanghai38@huawei.com, asmadeus@codewreck.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 01 Aug 2020 13:46:34 +0200
Message-ID: <159628239477208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

