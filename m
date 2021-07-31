Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF13DC65D
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhGaOon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhGaOon (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 10:44:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C140C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:44:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mt6so19399963pjb.1
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 07:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S4m6wbbRZcjiiWDM7HOysQzUpiwccX+wzX8bPiKcwUU=;
        b=Qngn5E8VM4GZfzaMjj9OYQfmuApzu6uoy0ZPVfVR04OMYjDSo20Q6VGIZPJIqYDpUN
         bkS9tRnZizfqgohm0GBc8pFw3Ymmqm1JtJFEeP+SU/0/UpEq3T/usXyXlKAmJ+o+tcle
         u8iDB8Dtvt9wkHgX0w8ULVLNwuxkONg+DvVyL6TSIv1JhzplSf66JTqKQSAjddKDpoGL
         YVegp5phW3wx8LOIP2VZIhctdvDr3FC0ogTa+qGPEAMKnYJ0CqUgRWswLgD0RlsyLXvk
         BjZYE55c+/BKNiBs+xabxXDexc3dO4XseZ+z8YqvSAYhxmBfDlGt397yRO2yKpofYvP1
         z7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S4m6wbbRZcjiiWDM7HOysQzUpiwccX+wzX8bPiKcwUU=;
        b=D3GogfdmOe0FlPDvvz5/sC/iuCXqYk9dsF4YC6V+Pf4Cxb4Itr3VUQKL/dpT9qk5Hg
         Dl/0mBfYYmeFJ90CWCm4u3In6XU4bAgOLEvz4ECJYwyTdqD0Zgr2ZDaJOV1Qf2lo4dUk
         J8zDcb07o6DROFBw77uxWJPUYJiXrGV9pfrOdIStyhb9HhQQo39lkMw+sMijkxD3ptKt
         STC35bgywuIciceKXA5MjL+GgRg0lkC59PYGdOi73792Y/Oeicn9KxnFTL3FqkttXggJ
         1i1H0qJZPXc+gn7ROjuvHZP4TR5QLyH7THHIil/PVfT4mz7Jb3DyU71NdKa8i/a+ZY1Q
         7JAA==
X-Gm-Message-State: AOAM530PvSTeGU8ds137ye7DtD6sdhPTebUumWMQ4qkG0Rn5i21q1+IZ
        TD5c0689oo2UgGoh/dsScNrThKnHrtbf1Ejt
X-Google-Smtp-Source: ABdhPJz/yFXPSEU8y35G8O3tSLXdMLSQHdhW3u1ORrK0J9movrBqYDQvU1LqL8dANVqcapSodoo6kg==
X-Received: by 2002:a17:90a:d910:: with SMTP id c16mr8588477pjv.62.1627742676321;
        Sat, 31 Jul 2021 07:44:36 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id h16sm6121402pfr.39.2021.07.31.07.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 07:44:35 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix race in unified task_work
 running" failed to apply to 5.13-stable tree
To:     gregkh@linuxfoundation.org, forza@tnonline.net
Cc:     stable@vger.kernel.org
References: <162771380065153@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3a7acb2-41ad-8c7b-c3d2-8f8d5b40f250@kernel.dk>
Date:   Sat, 31 Jul 2021 08:44:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <162771380065153@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/21 12:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.13-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a tested 5.13-stable port.

From: Jens Axboe <axboe@kernel.dk>
Subject: io_uring: fix race in unified task_work running

commit 110aa25c3ce417a44e35990cf8ed22383277933a upstream.

We use a bit to manage if we need to add the shared task_work, but
a list + lock for the pending work. Before aborting a current run
of the task_work we check if the list is empty, but we do so without
grabbing the lock that protects it. This can lead to races where
we think we have nothing left to run, where in practice we could be
racing with a task adding new work to the list. If we do hit that
race condition, we could be left with work items that need processing,
but the shared task_work is not active.

Ensure that we grab the lock before checking if the list is empty,
so we know if it's safe to exit the run or not.

Link: https://lore.kernel.org/io-uring/c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net/
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Forza <forza@tnonline.net>
Tested-by: Forza <forza@tnonline.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>


diff --git a/fs/io_uring.c b/fs/io_uring.c
index df4288776815..3be33819ee42 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1890,7 +1890,7 @@ static void tctx_task_work(struct callback_head *cb)
 
 	clear_bit(0, &tctx->task_state);
 
-	while (!wq_list_empty(&tctx->task_list)) {
+	while (true) {
 		struct io_ring_ctx *ctx = NULL;
 		struct io_wq_work_list list;
 		struct io_wq_work_node *node;
@@ -1900,6 +1900,9 @@ static void tctx_task_work(struct callback_head *cb)
 		INIT_WQ_LIST(&tctx->task_list);
 		spin_unlock_irq(&tctx->task_lock);
 
+		if (wq_list_empty(&list))
+			break;
+
 		node = list.first;
 		while (node) {
 			struct io_wq_work_node *next = node->next;

-- 
Jens Axboe

