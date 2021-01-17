Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE462F92D4
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbhAQOV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:21:27 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58329 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728217AbhAQOV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:21:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BD83419C0CB1;
        Sun, 17 Jan 2021 09:20:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JnDVi9
        48XseY/Q6OwGrtoXoYx8IPbtvs4+9DktAoVwo=; b=lwtV555/ryflTSFjxS9/32
        90LC4GK+EIAT8QhjNiMkK50veTDtfmE/OPZ1k1RJ6vUVw1wNh000U9KWfF6ONnBs
        6ymlIF3iE9YgO6f55FvAwVAtadUlGtlIBNuS4+idcdBllUbUZsdIo8I5yNUK4F2G
        QviPj1bWKHHdBFGADRZ9J9zNueOasBzB94YpWQXrFA2VGk+BeMKCHoJCQEAuPf22
        kYHDwn0SkUOAmJk7DJaON0oN0HMuaOJEuaLglReKZnpP1Fl/1mOsB6e63VO+jTYh
        RTm8oNTZp3xIu8+tjjXMZB2ylrYMqpp1b6rwLdzfUn6wHT+mg9bxB/enzFzX5ftw
        ==
X-ME-Sender: <xms:t0cEYCSJX6XQSD697tOU7Wddi1Uzi4ZY766a2xCshwak907r0DX6JQ>
    <xme:t0cEYHzYCSyVLXSmVBGb-9XKa2Z1_lnHmqWMuwX7PmSgQZW_xMyh7l5lTVLC5MkgQ
    Y4sbF-e4LVvxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:t0cEYP3sYKqgqAY7xCyWaKszfD5lmjQkuyRwMweyVD8wSizXE4udug>
    <xmx:t0cEYOChT8RTlJq_-ni3szIHf9uxGUX2nJskxlHQ_QE5zMsHasgnWg>
    <xmx:t0cEYLjwGtgKgp660RCxpA_H0MPyPF93Juao4XP2Iwb62CuaqvwAOA>
    <xmx:t0cEYLLMjbUQjvHUebg1HMzaN4Bm_ZVxCwiLhVc2V2Sl3xhDSRzsig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69A1F24005B;
        Sun, 17 Jan 2021 09:20:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: drop mm and files after task_work_run" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:20:38 +0100
Message-ID: <1610893238217220@kroah.com>
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

From d434ab6db524ab1efd0afad4ffa1ee65ca6ac097 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 11 Jan 2021 04:00:30 +0000
Subject: [PATCH] io_uring: drop mm and files after task_work_run

__io_req_task_submit() run by task_work can set mm and files, but
io_sq_thread() in some cases, and because __io_sq_thread_acquire_mm()
and __io_sq_thread_acquire_files() do a simple current->mm/files check
it may end up submitting IO with mm/files of another task.

We also need to drop it after in the end to drop potentially grabbed
references to them.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f305c097bd5..7af74c1ec909 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7056,6 +7056,7 @@ static int io_sq_thread(void *data)
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			io_run_task_work();
+			io_sq_thread_drop_mm_files();
 			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -7093,6 +7094,7 @@ static int io_sq_thread(void *data)
 	}
 
 	io_run_task_work();
+	io_sq_thread_drop_mm_files();
 
 	if (cur_css)
 		io_sq_thread_unassociate_blkcg();

