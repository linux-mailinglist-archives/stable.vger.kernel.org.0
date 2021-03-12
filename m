Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBC338DE8
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhCLM4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:56:02 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:51211 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231407AbhCLMzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:55:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 96D891941E4E;
        Fri, 12 Mar 2021 07:55:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q7cGQu
        WYdetcuI8QxN/d/ma/zZ5cYFb9n57PgO3XHW8=; b=BlcfULSKlKAumXJ+z8XuKd
        98evCDMqRdPTjiKirQaQfr+yFPgRxcW+jDquiitSG1r7UgcSu64RZZY43YOG0Wqc
        UdReRRZqPAu7ezFWql6BvlDHJUYxJ1TOTXitaOiuOmdLVKjMDJoADX7/yNzarKwo
        wI4XbtVsZ0r9nHTgVIxhcI9mcp10Y7Bb6afWu4EWSkeXDoql6X8Sg/vmEpIU1ErW
        dL/45ru03SqPci4jnRvafGwKXFVjl/Uyxw0BHOLLse9QxebbyhOJhRmUdZGZviSm
        PkwEekYTdLJSnsm9htsFDcowTX8Ib2X2ZPVVMs6lnMIrgacxN0WLNMBorUAowETQ
        ==
X-ME-Sender: <xms:ymRLYNt7PQRmSIFfsMjzGv4aeQsmtyytdcNccb3aFfmmcrd2mCC9Eg>
    <xme:ymRLYGeaTmskCMRBnCr9Kj-R_StKQvY5Q4ImUs1vG5-3-SktzxhzWXndUOEv_yfuw
    2wYvxz6qC8OUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ymRLYAyghO8bV1yQ5XMsSGwufbYrVGYfkE_wi131aqphmRmdQYdrVw>
    <xmx:ymRLYENZNls8E1FFd1-3BbumCO94tx9AA_L_xgWGV2574jGwwm-QKQ>
    <xmx:ymRLYN_3XUqyt_KuGULNQgzFZsEo5SAIiJfvz__80QR1wu6c-5Z0vw>
    <xmx:ymRLYKEyif3UlUAGcAkeEyXHFIGFmmHRjMEb0utnfTlxaCUXYkfniA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5603E240065;
        Fri, 12 Mar 2021 07:55:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390/qeth: fix notification for pending buffers during" failed to apply to 5.4-stable tree
To:     jwi@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:55:37 +0100
Message-ID: <161555373781141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7eefda7f353ef86ad82a2dc8329e8a3538c08ab6 Mon Sep 17 00:00:00 2001
From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 9 Mar 2021 17:52:21 +0100
Subject: [PATCH] s390/qeth: fix notification for pending buffers during
 teardown

The cited commit reworked the state machine for pending TX buffers.
In qeth_iqd_tx_complete() it turned PENDING into a transient state, and
uses NEED_QAOB for buffers that get parked while waiting for their QAOB
completion.

But it missed to adjust the check in qeth_tx_complete_buf(). So if
qeth_tx_complete_pending_bufs() is called during teardown to drain
the parked TX buffers, we no longer raise a notification for af_iucv.

Instead of updating the checked state, just move this code into
qeth_tx_complete_pending_bufs() itself. This also gets rid of the
special-case in the common TX completion path.

Fixes: 8908f36d20d8 ("s390/qeth: fix af_iucv notification race")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d0a56afec028..a814698387bc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1390,9 +1390,6 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
-		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
-
 	/* Empty buffer? */
 	if (buf->next_element_to_fill == 0)
 		return;
@@ -1465,6 +1462,9 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
+			if (drain)
+				qeth_notify_skbs(queue, buf,
+						 TX_NOTIFY_GENERALERROR);
 			qeth_tx_complete_buf(buf, drain, 0);
 
 			list_del(&buf->list_entry);

