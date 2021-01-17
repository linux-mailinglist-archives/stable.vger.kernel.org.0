Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4112F92CD
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbhAQORu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:17:50 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38381 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728852AbhAQORt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:17:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0A0721981C74;
        Sun, 17 Jan 2021 09:16:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xCpsCy
        R5ZRRvoKFmDRx/slLqtxajSU1XRUrlPTKETs4=; b=Wm0+YLGYkXky44bH60JmaB
        B7ucwnaoxiDth7zfsnmKoYT2lHT4SpdB7grjv5aWwmgnvGV764MbadqLKqkjUiDl
        84r4EkYtnRv2RDdnL5wDEOe1t1G8npe0KitvT+56a6xegn/VEvAZt+Drypq8dfn5
        9hdydeJ0gZDLppiE0RnaUSuvy0cn2u1YHObLpxjTN90xdC9OfJrKtxsMjtUfbQVN
        iO28bVNNVYjilIJ1lyl89PTqf2/AZvIrr6jw9X++Z/HjRdn3VnlkwcpCYz8DQ2B1
        PrHiq/4aaPDbwu6b4dCfBqFuGhu2N9YHwc2qFdkGzo4S8WWPc9gczJtgTqahQHeg
        ==
X-ME-Sender: <xms:ykYEYCpJroWQgAHC6utPTBQ4PJlaoINYfprVvzHY6YcezY4mNnCOcw>
    <xme:ykYEYAr_nqeCXlOVLiZ-rlK9aRx0s7xCwD-ZmkNWjYkDQ2y3J_U5ENuOxWqWwS7RJ
    BjY7B6Tf_81PA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ykYEYHPrbfjVvtBob6sj5Dd8RiZtRN7GQMEUTudG-LIM5mTcZNvldg>
    <xmx:ykYEYB7-PZVRl9ZPFEAthsQXzGP2nb6rr8tTZYZhfrB2Bqq9y_HNXQ>
    <xmx:ykYEYB7rn8HLPirsNWxW4oD9_uEZJI642pqKDNywsz-H6ko9Vs222w>
    <xmx:y0YEYBH-xaJ51b2tq94JB1nQYDycE7qsCMWojmgBhGA2D55FEhjyHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43D3524005B;
        Sun, 17 Jan 2021 09:16:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: fix interrupted close commands" failed to apply to 5.4-stable tree
To:     pc@cjr.nz, duncf@duncf.ca, pshilov@microsoft.com,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:16:40 +0100
Message-ID: <16108930002214@kroah.com>
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

From 2659d3bff3e1b000f49907d0839178b101a89887 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Wed, 13 Jan 2021 14:16:16 -0300
Subject: [PATCH] cifs: fix interrupted close commands

Retry close command if it gets interrupted to not leak open handles on
the server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reported-by: Duncan Findlay <duncf@duncf.ca>
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_send_rqst()")
Cc: stable@vger.kernel.org
Reviewd-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 067eb44c7baa..794fc3b68b4f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype, rsp);
 
 	/* retry close in a worker thread if this one is interrupted */
-	if (rc == -EINTR) {
+	if (is_interrupt_error(rc)) {
 		int tmp_rc;
 
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,

