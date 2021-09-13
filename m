Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F04097E9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbhIMPxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhIMPx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:53:26 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445A2C0611A2
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:49:55 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b200so12699802iof.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=XQbhsftjfFFTTBrt5ACSD0hUuR/N6KRGgHG2+l8BuOo=;
        b=CqX+ARCX/roDCA/98tbfYsGLM95UN7VqlhySJRd81/jbwCSkLYgBjiRGv7BLEJwF1v
         zVTcS6lgJ5Dfd7JknwpuL5MJlTZgBUG07e+jQpww+26l6wIWiWUEXRdJqf3baD0OgH3I
         jo8Al6v5EA3e5MDHaH/k2CsfZ4JQl2g2pSVtmieYNKg6I4aRyw02zY/cc+cD8juRqWaa
         jYH+zTHj4qbM9WS5IhBsXq61JehxXHscBt8s7HKOAxBDn8UkvNQHMFpDMdfESCDNdT5I
         nhka+sItLRvZUGsoAqMl4/ct7Lhsy42t89Eg0fKxDufyBex3CbX4U0BCrGG9C8yOMQvx
         7CkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=XQbhsftjfFFTTBrt5ACSD0hUuR/N6KRGgHG2+l8BuOo=;
        b=rm38jlAxWG+rdxYIL0v0ZaVe307LAYIBgwlIy0me3kx+Ot1kK3SHXSx0A/KW+lKWIX
         KY5mbAuta72iFM7jplDP71H5Ip6jcKm1xQn/hJRbLFWOjPPgG9NEtu3GdOB6LbPq8kuw
         eI4nX3J31sSoGaqtCjne97AaQGjpdutwZHD1+yS2z84rS0xJ8WGMfoi17j7zXGSEztK9
         kVj9saCuJuVYnE6/bzHp8cX0fbh9U6dFu9b23D7TnhPOXWQMuaRi37phkiPnY6nldy6T
         BjQGMvMZfSwwIkUd3edBFpfPP1fMexdrfNBexN6Br6f0JnHJ+BHAAc72W2pGd/y3JflD
         UR+w==
X-Gm-Message-State: AOAM530JpQ6asDcjT20MajOFcvGzFT2uqkoEBDeMahG+iuwknvmY2tGw
        EQIaMM9Ha3P4DJYksWGbypvOOP3AhwLWF4jdVTg=
X-Google-Smtp-Source: ABdhPJwyR2zJgfYzSnNtMuV8qNr4BLBEOZEWwqtQ1faHs3yuT1omCMmb1WafyQdhIockFU67lRz3wA==
X-Received: by 2002:a05:6602:2211:: with SMTP id n17mr9623301ion.142.1631548194469;
        Mon, 13 Sep 2021 08:49:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o5sm4600539iow.48.2021.09.13.08.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 08:49:53 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.13 stable backports
Message-ID: <14bc2778-6ec6-f794-64b1-d89fd1ba0296@kernel.dk>
Date:   Mon, 13 Sep 2021 09:49:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4413F2A025DF6C96EB906663"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------4413F2A025DF6C96EB906663
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Here's the 5.13 queue.

-- 
Jens Axboe


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-add-splice_fd_in-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-add-splice_fd_in-checks.patch"

From 0d496e0260bed6887eacd5eba46261efda715bfc Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:17:19 -0600
Subject: [PATCH 2/6] io_uring: add ->splice_fd_in checks

commit 26578cda3db983b17cabe4e577af26306beb9987 upstream.

->splice_fd_in is used only by splice/tee, but no other request checks
it for validity. Add the check for most of request types excluding
reads/writes/sends/recvs, we don't want overhead for them and can leave
them be as is until the field is actually used.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f44bc2acd6777d932de3d71a5692235b5b2b7397.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1b6d338e3a0..065ceeaf4463 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3474,7 +3474,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3525,7 +3525,8 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3571,8 +3572,8 @@ static int io_shutdown_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
-	    sqe->buf_index)
+	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->shutdown.how = READ_ONCE(sqe->len);
@@ -3720,7 +3721,8 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3753,7 +3755,8 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3784,7 +3787,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3909,7 +3912,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -3980,7 +3984,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4067,7 +4071,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4113,7 +4117,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4148,7 +4152,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4186,7 +4190,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4222,7 +4226,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4283,7 +4287,8 @@ static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4710,7 +4715,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4758,7 +4763,8 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5368,7 +5374,7 @@ static int io_poll_update_prep(struct io_kiocb *req,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
@@ -5603,7 +5609,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tr->addr = READ_ONCE(sqe->addr);
@@ -5662,7 +5668,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5811,7 +5818,8 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5868,7 +5876,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
-- 
2.33.0


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"

From eda6d3d1acf23f63e8e29219b1379e479cf90d7d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:13:30 -0600
Subject: [PATCH 1/6] io_uring: place fixed tables under memcg limits

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/autofs/modules.builtin          |  1 +
 fs/btrfs/modules.builtin           |  1 +
 fs/configfs/modules.builtin        |  1 +
 fs/crypto/modules.builtin          |  0
 fs/debugfs/modules.builtin         |  0
 fs/devpts/modules.builtin          |  0
 fs/ecryptfs/modules.builtin        |  1 +
 fs/efivarfs/modules.builtin        |  1 +
 fs/exportfs/modules.builtin        |  1 +
 fs/ext2/modules.builtin            |  1 +
 fs/ext4/modules.builtin            |  1 +
 fs/fat/modules.builtin             |  2 ++
 fs/fuse/modules.builtin            |  1 +
 fs/hugetlbfs/modules.builtin       |  0
 fs/io-wq.h.rej                     | 25 +++++++++++++++++++++++++
 fs/io_uring.c                      |  8 ++++----
 fs/iomap/modules.builtin           |  0
 fs/isofs/modules.builtin           |  1 +
 fs/jbd2/modules.builtin            |  1 +
 fs/kernfs/modules.builtin          |  0
 fs/lockd/modules.builtin           |  1 +
 fs/modules.builtin                 |  9 +++++++++
 fs/nfs/modules.builtin             |  4 ++++
 fs/nfs_common/modules.builtin      |  2 ++
 fs/nls/modules.builtin             |  1 +
 fs/notify/dnotify/modules.builtin  |  0
 fs/notify/fanotify/modules.builtin |  0
 fs/notify/inotify/modules.builtin  |  0
 fs/notify/modules.builtin          |  0
 fs/proc/modules.builtin            |  0
 fs/pstore/modules.builtin          |  1 +
 fs/quota/modules.builtin           |  0
 fs/ramfs/modules.builtin           |  0
 fs/squashfs/modules.builtin        |  1 +
 fs/sysfs/modules.builtin           |  0
 fs/tracefs/modules.builtin         |  0
 fs/xfs/modules.builtin             |  1 +
 37 files changed, 62 insertions(+), 4 deletions(-)
 create mode 100644 fs/autofs/modules.builtin
 create mode 100644 fs/btrfs/modules.builtin
 create mode 100644 fs/configfs/modules.builtin
 create mode 100644 fs/crypto/modules.builtin
 create mode 100644 fs/debugfs/modules.builtin
 create mode 100644 fs/devpts/modules.builtin
 create mode 100644 fs/ecryptfs/modules.builtin
 create mode 100644 fs/efivarfs/modules.builtin
 create mode 100644 fs/exportfs/modules.builtin
 create mode 100644 fs/ext2/modules.builtin
 create mode 100644 fs/ext4/modules.builtin
 create mode 100644 fs/fat/modules.builtin
 create mode 100644 fs/fuse/modules.builtin
 create mode 100644 fs/hugetlbfs/modules.builtin
 create mode 100644 fs/io-wq.h.rej
 create mode 100644 fs/iomap/modules.builtin
 create mode 100644 fs/isofs/modules.builtin
 create mode 100644 fs/jbd2/modules.builtin
 create mode 100644 fs/kernfs/modules.builtin
 create mode 100644 fs/lockd/modules.builtin
 create mode 100644 fs/modules.builtin
 create mode 100644 fs/nfs/modules.builtin
 create mode 100644 fs/nfs_common/modules.builtin
 create mode 100644 fs/nls/modules.builtin
 create mode 100644 fs/notify/dnotify/modules.builtin
 create mode 100644 fs/notify/fanotify/modules.builtin
 create mode 100644 fs/notify/inotify/modules.builtin
 create mode 100644 fs/notify/modules.builtin
 create mode 100644 fs/proc/modules.builtin
 create mode 100644 fs/pstore/modules.builtin
 create mode 100644 fs/quota/modules.builtin
 create mode 100644 fs/ramfs/modules.builtin
 create mode 100644 fs/squashfs/modules.builtin
 create mode 100644 fs/sysfs/modules.builtin
 create mode 100644 fs/tracefs/modules.builtin
 create mode 100644 fs/xfs/modules.builtin

diff --git a/fs/autofs/modules.builtin b/fs/autofs/modules.builtin
new file mode 100644
index 000000000000..3425a57879aa
--- /dev/null
+++ b/fs/autofs/modules.builtin
@@ -0,0 +1 @@
+fs/autofs/autofs4.ko
diff --git a/fs/btrfs/modules.builtin b/fs/btrfs/modules.builtin
new file mode 100644
index 000000000000..c625a36770c8
--- /dev/null
+++ b/fs/btrfs/modules.builtin
@@ -0,0 +1 @@
+fs/btrfs/btrfs.ko
diff --git a/fs/configfs/modules.builtin b/fs/configfs/modules.builtin
new file mode 100644
index 000000000000..75bb304ca48b
--- /dev/null
+++ b/fs/configfs/modules.builtin
@@ -0,0 +1 @@
+fs/configfs/configfs.ko
diff --git a/fs/crypto/modules.builtin b/fs/crypto/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/debugfs/modules.builtin b/fs/debugfs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/devpts/modules.builtin b/fs/devpts/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/ecryptfs/modules.builtin b/fs/ecryptfs/modules.builtin
new file mode 100644
index 000000000000..6216eb603190
--- /dev/null
+++ b/fs/ecryptfs/modules.builtin
@@ -0,0 +1 @@
+fs/ecryptfs/ecryptfs.ko
diff --git a/fs/efivarfs/modules.builtin b/fs/efivarfs/modules.builtin
new file mode 100644
index 000000000000..e877f7a6ff24
--- /dev/null
+++ b/fs/efivarfs/modules.builtin
@@ -0,0 +1 @@
+fs/efivarfs/efivarfs.ko
diff --git a/fs/exportfs/modules.builtin b/fs/exportfs/modules.builtin
new file mode 100644
index 000000000000..6e653c2a0b47
--- /dev/null
+++ b/fs/exportfs/modules.builtin
@@ -0,0 +1 @@
+fs/exportfs/exportfs.ko
diff --git a/fs/ext2/modules.builtin b/fs/ext2/modules.builtin
new file mode 100644
index 000000000000..f4c027967504
--- /dev/null
+++ b/fs/ext2/modules.builtin
@@ -0,0 +1 @@
+fs/ext2/ext2.ko
diff --git a/fs/ext4/modules.builtin b/fs/ext4/modules.builtin
new file mode 100644
index 000000000000..87c8fe1b7c30
--- /dev/null
+++ b/fs/ext4/modules.builtin
@@ -0,0 +1 @@
+fs/ext4/ext4.ko
diff --git a/fs/fat/modules.builtin b/fs/fat/modules.builtin
new file mode 100644
index 000000000000..a4c36176a69d
--- /dev/null
+++ b/fs/fat/modules.builtin
@@ -0,0 +1,2 @@
+fs/fat/fat.ko
+fs/fat/vfat.ko
diff --git a/fs/fuse/modules.builtin b/fs/fuse/modules.builtin
new file mode 100644
index 000000000000..36a0c8d41d7a
--- /dev/null
+++ b/fs/fuse/modules.builtin
@@ -0,0 +1 @@
+fs/fuse/fuse.ko
diff --git a/fs/hugetlbfs/modules.builtin b/fs/hugetlbfs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/io-wq.h.rej b/fs/io-wq.h.rej
new file mode 100644
index 000000000000..b911d356dca5
--- /dev/null
+++ b/fs/io-wq.h.rej
@@ -0,0 +1,25 @@
+--- fs/io-wq.h
++++ fs/io-wq.h
+@@ -94,9 +95,20 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
+ typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+ typedef void (io_wq_work_fn)(struct io_wq_work *);
+ 
+-struct io_wq_data {
+-	unsigned long *hash_map;
++struct io_wq_hash {
++	refcount_t refs;
++	unsigned long map;
++	struct wait_queue_head wait;
++};
++
++static inline void io_wq_put_hash(struct io_wq_hash *hash)
++{
++	if (refcount_dec_and_test(&hash->refs))
++		kfree(hash);
++}
+ 
++struct io_wq_data {
++	struct io_wq_hash *hash;
+ 	io_wq_work_fn *do_work;
+ 	free_work_fn *free_work;
+ };
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58ae2eab99ef..a1b6d338e3a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7195,11 +7195,11 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 {
 	struct io_rsrc_data *data;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return NULL;
 
-	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
+	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL_ACCOUNT);
 	if (!data->tags) {
 		kfree(data);
 		return NULL;
@@ -7477,7 +7477,7 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
 
-	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
+	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL_ACCOUNT);
 	if (!table->files)
 		return false;
 
@@ -7485,7 +7485,7 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 
 		table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!table->files[i])
 			break;
 		nr_files -= this_files;
diff --git a/fs/iomap/modules.builtin b/fs/iomap/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/isofs/modules.builtin b/fs/isofs/modules.builtin
new file mode 100644
index 000000000000..7f55c4f4a938
--- /dev/null
+++ b/fs/isofs/modules.builtin
@@ -0,0 +1 @@
+fs/isofs/isofs.ko
diff --git a/fs/jbd2/modules.builtin b/fs/jbd2/modules.builtin
new file mode 100644
index 000000000000..ca3ee1e7d87a
--- /dev/null
+++ b/fs/jbd2/modules.builtin
@@ -0,0 +1 @@
+fs/jbd2/jbd2.ko
diff --git a/fs/kernfs/modules.builtin b/fs/kernfs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/lockd/modules.builtin b/fs/lockd/modules.builtin
new file mode 100644
index 000000000000..3166e33857b4
--- /dev/null
+++ b/fs/lockd/modules.builtin
@@ -0,0 +1 @@
+fs/lockd/lockd.ko
diff --git a/fs/modules.builtin b/fs/modules.builtin
new file mode 100644
index 000000000000..28063ed6d4f5
--- /dev/null
+++ b/fs/modules.builtin
@@ -0,0 +1,9 @@
+fs/binfmt_script.ko
+fs/mbcache.ko
+fs/configfs/configfs.ko
+fs/exportfs/exportfs.ko
+fs/ext2/ext2.ko
+fs/ext4/ext4.ko
+fs/jbd2/jbd2.ko
+fs/nls/nls_base.ko
+fs/xfs/xfs.ko
diff --git a/fs/nfs/modules.builtin b/fs/nfs/modules.builtin
new file mode 100644
index 000000000000..69e4c62e80ed
--- /dev/null
+++ b/fs/nfs/modules.builtin
@@ -0,0 +1,4 @@
+fs/nfs/nfs.ko
+fs/nfs/nfsv2.ko
+fs/nfs/nfsv3.ko
+fs/nfs/nfsv4.ko
diff --git a/fs/nfs_common/modules.builtin b/fs/nfs_common/modules.builtin
new file mode 100644
index 000000000000..cd9997308742
--- /dev/null
+++ b/fs/nfs_common/modules.builtin
@@ -0,0 +1,2 @@
+fs/nfs_common/nfs_acl.ko
+fs/nfs_common/grace.ko
diff --git a/fs/nls/modules.builtin b/fs/nls/modules.builtin
new file mode 100644
index 000000000000..fc1e1ebb52b3
--- /dev/null
+++ b/fs/nls/modules.builtin
@@ -0,0 +1 @@
+fs/nls/nls_base.ko
diff --git a/fs/notify/dnotify/modules.builtin b/fs/notify/dnotify/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/notify/fanotify/modules.builtin b/fs/notify/fanotify/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/notify/inotify/modules.builtin b/fs/notify/inotify/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/notify/modules.builtin b/fs/notify/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/proc/modules.builtin b/fs/proc/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/pstore/modules.builtin b/fs/pstore/modules.builtin
new file mode 100644
index 000000000000..df9f660810d4
--- /dev/null
+++ b/fs/pstore/modules.builtin
@@ -0,0 +1 @@
+fs/pstore/pstore.ko
diff --git a/fs/quota/modules.builtin b/fs/quota/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/ramfs/modules.builtin b/fs/ramfs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/squashfs/modules.builtin b/fs/squashfs/modules.builtin
new file mode 100644
index 000000000000..1e576034deba
--- /dev/null
+++ b/fs/squashfs/modules.builtin
@@ -0,0 +1 @@
+fs/squashfs/squashfs.ko
diff --git a/fs/sysfs/modules.builtin b/fs/sysfs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/tracefs/modules.builtin b/fs/tracefs/modules.builtin
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/xfs/modules.builtin b/fs/xfs/modules.builtin
new file mode 100644
index 000000000000..b84139d4cd94
--- /dev/null
+++ b/fs/xfs/modules.builtin
@@ -0,0 +1 @@
+fs/xfs/xfs.ko
-- 
2.33.0


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io-wq-fix-race-between-adding-work-and-activating-a-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io-wq-fix-race-between-adding-work-and-activating-a-.pa";
 filename*1="tch"

From 77da4ba9b7fa7c7502decb6c72dc67d1701063be Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 13 Sep 2021 09:24:07 -0600
Subject: [PATCH 5/6] io-wq: fix race between adding work and activating a free
 worker

commit 94ffb0a282872c2f4b14f757fa1aef2302aeaabb upstream.

The attempt to find and activate a free worker for new work is currently
combined with creating a new one if we don't find one, but that opens
io-wq up to a race where the worker that is found and activated can
put itself to sleep without knowing that it has been selected to perform
this new work.

Fix this by moving the activation into where we add the new work item,
then we can retain it within the wqe->lock scope and elimiate the race
with the worker itself checking inside the lock, but sleeping outside of
it.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3de639ddb2d0..6612d0aa497e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -237,9 +237,9 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool ret;
+	bool do_create = false, first = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -248,25 +248,18 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock_irq(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock_irq(&wqe->lock);
-		if (do_create)
-			create_io_worker(wqe->wq, wqe, acct->index, first);
+	raw_spin_lock_irq(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock_irq(&wqe->lock);
+	if (do_create) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -798,7 +791,8 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	bool do_wake;
+	unsigned work_flags = work->flags;
+	bool do_create;
 	unsigned long flags;
 
 	/*
@@ -814,12 +808,16 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
-			!atomic_read(&acct->nr_running);
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe);
+	rcu_read_unlock();
+
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if (do_wake)
-		io_wqe_wake_worker(wqe, acct);
+	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	    !atomic_read(&acct->nr_running)))
+		io_wqe_create_worker(wqe, acct);
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
-- 
2.33.0


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"

From 2f4f76bce352273326816322727c722e9510b5eb Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 13 Sep 2021 09:20:44 -0600
Subject: [PATCH 4/6] io-wq: fix wakeup race when adding new work

commit 87df7fb922d18e96992aa5e824aa34b2065fef59 upstream.

When new work is added, io_wqe_enqueue() checks if we need to wake or
create a new worker. But that check is done outside the lock that
otherwise synchronizes us with a worker going to sleep, so we can end
up in the following situation:

CPU0				CPU1
lock
insert work
unlock
atomic_read(nr_running) != 0
				lock
				atomic_dec(nr_running)
no wakeup needed

Hold the wqe lock around the "need to wakeup" check. Then we can also get
rid of the temporary work_flags variable, as we know the work will remain
valid as long as we hold the lock.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c7171d975896..3de639ddb2d0 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -798,7 +798,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 	unsigned long flags;
 
 	/*
@@ -811,14 +811,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
+			!atomic_read(&acct->nr_running);
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
+	if (do_wake)
 		io_wqe_wake_worker(wqe, acct);
 }
 
-- 
2.33.0


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"

From 64c61f893278119e3f5df49500dcd0fb249922dd Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:18:44 -0600
Subject: [PATCH 3/6] io_uring: fix io_try_cancel_userdata race for iowq

commit dadebc350da2bef62593b1df007a6e0b90baf42a upstream.

WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
Call Trace:
 io_async_cancel fs/io_uring.c:6014 [inline]
 io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
 io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
 io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
 io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io_try_cancel_userdata() can be called from io_async_cancel() executing
in the io-wq context, so the warning fires, which is there to alert
anyone accessing task->io_uring->io_wq in a racy way. However,
io_wq_put_and_exit() always first waits for all threads to complete,
so the only detail left is to zero tctx->io_wq after the context is
removed.

note: one little assumption is that when IO_WQ_WORK_CANCEL, the executor
won't touch ->io_wq, because io_wq_destroy() might cancel left pending
requests in such a way.

Cc: stable@vger.kernel.org
Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 065ceeaf4463..da91ae44bff0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6289,6 +6289,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -9098,8 +9099,8 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 
-- 
2.33.0


--------------4413F2A025DF6C96EB906663
Content-Type: text/x-patch; charset=UTF-8;
 name="0006-io_uring-fail-links-of-cancelled-timeouts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0006-io_uring-fail-links-of-cancelled-timeouts.patch"

From 8eaf2726518467ec3357abb629ef432661470d6e Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 13 Sep 2021 09:27:44 -0600
Subject: [PATCH 6/6] io_uring: fail links of cancelled timeouts

commit 2ae2eb9dde18979b40629dd413b9adbd6c894cdf upstream.

When we cancel a timeout we should mark it with REQ_F_FAIL, so
linked requests are cancelled as well, but not queued for further
execution.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index da91ae44bff0..925f7f27af1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1307,6 +1307,8 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail_links(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-- 
2.33.0


--------------4413F2A025DF6C96EB906663--
