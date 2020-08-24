Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2FA250BC6
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 00:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHXWmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 18:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXWmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 18:42:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB7FC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:42:38 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id t185so2639162pfd.13
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=iKC4hUumct3pxUwmjgmSJNjxXRqd8oGfxFxIXzBZz9A=;
        b=1AfuaWTK/v70fIlNLk84lsAcIDUGRwgrIYQwwr41xAFUSnDMVXGPceAkp9FwFIuIaR
         dzJy2ymKyqLBOfL7HHNzHU6EKo1fmeVfFHzrbH7wLofmkzXQ1gr09IAHvdi4W/aLp5v7
         6/NxhF0JBsS1T++r+neQTLxezCJudBGAybIBXTOakutOI7r35zdwrJ+pATNhwcJH7vve
         lTUCJHhbuTnxNb321BM+veoBqA9E4zYgBWClEVNWiYh9Cs3Xd2LBUeV0rhag33btNQa5
         IPdQe3D5E0RR2RShDm58EmcgJAjy/0mh4kvUgbSdNwjI8uauKrLyu3qC/WbbgMsGIBEW
         PEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=iKC4hUumct3pxUwmjgmSJNjxXRqd8oGfxFxIXzBZz9A=;
        b=aadg0kgT615NDcANHfT3jaJvgK5JVq3Jv9Xw8fHGoV2P6oJOkbJ8nMMCXb2owFLrU3
         O8eWTbJfAKiEBW0ih44eIImJkWykWFEmiSpOWYHuvl5rjcTWUF5reEfVOgr6yQAOwsP+
         8Z01kxqDGtZCd2fRsGL05kTRs8mYB/OTMM1CCDyirCplHZ3yBRCYvWFLzP3ggXBPPn2R
         00NciF1o3HT4XynyN+CPPL1x4AZpJsEzn15/wwtMmz+rxi71I85Xk8xFx8ODRaVqS1Yn
         ZLCsB+r7W0P/ncKkmEpkl/ngPNkD8oDew46GotUqy45qcz2KU7Za7ZV/SYsIJ8At97VQ
         sG/g==
X-Gm-Message-State: AOAM532KzaEBNxM8OuFD0MdGyQLs9cwUzs/BCPFvv2encW9yxUP/J9E/
        EdguflGwcEa4BL2EU1SknSPV+Nwo6EvGtRHS
X-Google-Smtp-Source: ABdhPJzEvC7kB+t3hQOWBWDPgTM5mLm685F6wHsPQZredtMjFMW2M3njgQ3yZaS3bGMNT/cjiiawTg==
X-Received: by 2002:aa7:95b8:: with SMTP id a24mr5475470pfk.219.1598308957422;
        Mon, 24 Aug 2020 15:42:37 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r14sm5024200pgn.83.2020.08.24.15.42.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 15:42:36 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.8 stable inclusion request
Message-ID: <eac5cc64-641f-58b9-5f58-7bc1c4393bbb@kernel.dk>
Date:   Mon, 24 Aug 2020 16:42:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can I get this patch queued up for 5.8? It's a backport of two
commits from upstream. Thanks!

From: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.8] io_uring: fix missing ->mm on exit

Upstream commits:

8eb06d7e8dd85 ("io_uring: fix missing ->mm on exit")
cbcf72148da4a ("io_uring: return locked and pinned page accounting")

do_exit() first drops current->mm and then runs task_work, from where
io_sq_thread_acquire_mm() would try to set mm for a user dying process.

[  208.004249] WARNING: CPU: 2 PID: 1854 at
	kernel/kthread.c:1238 kthread_use_mm+0x244/0x270
[  208.004287]  kthread_use_mm+0x244/0x270
[  208.004288]  io_sq_thread_acquire_mm.part.0+0x54/0x80
[  208.004290]  io_async_task_func+0x258/0x2ac
[  208.004291]  task_work_run+0xc8/0x210
[  208.004294]  do_exit+0x1b8/0x430
[  208.004295]  do_group_exit+0x44/0xac
[  208.004296]  get_signal+0x164/0x69c
[  208.004298]  do_signal+0x94/0x1d0
[  208.004299]  do_notify_resume+0x18c/0x340
[  208.004300]  work_pending+0x8/0x3d4

Reported-by: Roman Gershman <romange@gmail.com>
Tested-by: Roman Gershman <romange@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 493e5047e67c..a8b3a608c553 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4313,7 +4313,8 @@ static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
 				   struct io_kiocb *req)
 {
 	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
+			     !mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
 	}
-- 
2.24.0


-- 
Jens Axboe

