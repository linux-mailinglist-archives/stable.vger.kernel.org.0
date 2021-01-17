Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EEC2F92D2
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbhAQOUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:20:39 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50971 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728217AbhAQOUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:20:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7508319C02FE;
        Sun, 17 Jan 2021 09:19:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ABEnu/
        7VbC0nxE0lNITklxXTFSQbLI9CcAhC1c04zyU=; b=BBMm6JIefPH54937rtnrZ7
        GsaNpuHu/5AhESt7ykxc3h4skAeffcfz05cq58osqFK/+6pNSmrKh1IHvVp+Y64i
        rPAAa7BrBmA04G5gfNIkbPrfkYaBFPDtqnmTpEtpv9twuH6jgX6qRQ9fcdW+eVOy
        rQTmAWo1DbWMO4I0ihRGSxqPy3KcEQqYyZYg8rmHJBEwXAqBoV7/4f+6Gb7IHYXc
        fuAVYyx0N54qV5THUuCF02DV5w2tQHDw6i72CrKCcokNLBDmF/YeI9IrwGz8rUSB
        UQRMfIeR8y5h1EtDlauxuDxXc0fRoZbD3kj7N3W9WgdRYL9PY8HzuOQ2LbYoB5oQ
        ==
X-ME-Sender: <xms:iEcEYKds_HESTMqLQwYXvCALuHcs8I6yLQefsdc8XcxCiAgMtjOU4w>
    <xme:iEcEYPFW37slq4ZLlCabnMENzLZ4p_0-F0T2285NsTlqDf2F6S2eij9Jt94fsT1OS
    0LlDkIFBfP1mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:iEcEYDVLjy3VPB37e3VohJe6fdw7SWR8FgW59Uq9uY3SVwqcyk4OKQ>
    <xmx:iEcEYGKxWtxOgDye4x2ZB4jKRIvnhqHY9bps2W9-y75gAy-gMZYa3A>
    <xmx:iEcEYL-gc6ksimALGhYHmERLA69HTLO93zmcXqqbyiOFkv544IFBvQ>
    <xmx:iEcEYFWRWKPyYv-Zyy1JsNjbN1fZmqqNpaUtRE6EcDCtrfHEmUVpKA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02B6124005B;
        Sun, 17 Jan 2021 09:19:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: don't take files/mm for a dead task" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:19:50 +0100
Message-ID: <161089319028116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 621fadc22365f3cf307bcd9048e3372e9ee9cdcc Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 11 Jan 2021 04:00:31 +0000
Subject: [PATCH] io_uring: don't take files/mm for a dead task

In rare cases a task may be exiting while io_ring_exit_work() trying to
cancel/wait its requests. It's ok for __io_sq_thread_acquire_mm()
because of SQPOLL check, but is not for __io_sq_thread_acquire_files().
Play safe and fail for both of them.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7af74c1ec909..b0e6d8e607a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1106,6 +1106,9 @@ static void io_sq_thread_drop_mm_files(void)
 
 static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 {
+	if (current->flags & PF_EXITING)
+		return -EFAULT;
+
 	if (!current->files) {
 		struct files_struct *files;
 		struct nsproxy *nsproxy;
@@ -1133,6 +1136,8 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	struct mm_struct *mm;
 
+	if (current->flags & PF_EXITING)
+		return -EFAULT;
 	if (current->mm)
 		return 0;
 

