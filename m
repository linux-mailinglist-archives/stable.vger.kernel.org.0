Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6671940C55A
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhIOMgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhIOMgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 08:36:18 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C79C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 05:34:59 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b7so3195607iob.4
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 05:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=26nVZ/rQronZcbXRDqCU60v5FgFOhXx5ukeGO8DdS3c=;
        b=yKq4pSbwo5aoxqWmLP9q0fmhXulJbN75jET6FWiA5mRQxV8aKtpKT9gerH7zh19V6r
         f47TFhKw4f7q/sGWm3306G9L23U4WMtotyr+dl2RmqnfwWsMiLDYvQcQHjEh8k5Bs4O0
         tPL7EAmHnRdLs3oIJXnpXihurASZYsd88AO6SuRossNxrhDbuHRxoYNwJZfaP6cHlaem
         DH/glyaKF82SPQh2gBafm9TUWkdxl64xBEfFbuJAMSFCn8uBIMAihHn9mXpEe7bzYZ/+
         KulV/AYboEE3vEJ+BkfRY+qrKmW1rtTMttSvGSKhWrgSCGFdZf9WcrA3/wDPk9+kR8Ou
         MdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=26nVZ/rQronZcbXRDqCU60v5FgFOhXx5ukeGO8DdS3c=;
        b=LGpmdEza+2uoqXb/jbitaOUX7ToRcaJQHpA3/Ep4K7yWcu/gzFci0Bbf+qOG2h2Cng
         ZQF4Y3fkuSwW6cFYp1Xye57RF2rJkpFBm6DnyySmrctpQj7sZUUvnQsyIjimfe27KOmt
         +tIgMc1EJ4uVoPlaFwlO1YYSm3HHQlj+fKvmAffW+japmsO+792Xm+B/PeIvAODU1g9C
         Tzf9XC7tRaxQwjNscOxo17blu0w8Dbk4ILl6hwxO4LY2Z/5mmJoGUMjuQfsTOZyljq9Z
         Jgr6XfQz1mDS7xicOI0JF5n4rbAW1dfZf68ygGvyx1crUG7n/aOk3PcndcbdHB1KwUKg
         Xpyg==
X-Gm-Message-State: AOAM533OJnCbJq2HLFTOiX7YodO3LgBBlOzAcjgUXUwdoX6eGAhVAedb
        HBiOnpB7l6beXfVk/dLq4L6mXJPJkP1FYg==
X-Google-Smtp-Source: ABdhPJywx5DEkTQB2a6mqbv1uGukEf8GCnoyOyIu5BFeKedd4jWuzWvwIksF4MFuOhQvVkW3Up47LQ==
X-Received: by 2002:a02:2402:: with SMTP id f2mr18886159jaa.28.1631709298729;
        Wed, 15 Sep 2021 05:34:58 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r18sm8456987ioa.13.2021.09.15.05.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 05:34:57 -0700 (PDT)
Subject: Re: 5.13 stable backports
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
References: <14bc2778-6ec6-f794-64b1-d89fd1ba0296@kernel.dk>
 <YUHWwWvmAup4ZU6i@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf2be99e-7b9b-c057-5248-202f610256e2@kernel.dk>
Date:   Wed, 15 Sep 2021 06:34:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YUHWwWvmAup4ZU6i@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------298B91F2C28ABD5E116D8EAC"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 9/15/21 5:19 AM, Greg Kroah-Hartman wrote:
> On Mon, Sep 13, 2021 at 09:49:53AM -0600, Jens Axboe wrote:
>> >From eda6d3d1acf23f63e8e29219b1379e479cf90d7d Mon Sep 17 00:00:00 2001
>> From: Pavel Begunkov <asml.silence@gmail.com>
>> Date: Mon, 13 Sep 2021 09:13:30 -0600
>> Subject: [PATCH 1/6] io_uring: place fixed tables under memcg limits
>>
>> commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.
>>
>> Fixed tables may be large enough, place all of them together with
>> allocated tags under memcg limits.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/autofs/modules.builtin          |  1 +
>>  fs/btrfs/modules.builtin           |  1 +
>>  fs/configfs/modules.builtin        |  1 +
>>  fs/crypto/modules.builtin          |  0
>>  fs/debugfs/modules.builtin         |  0
>>  fs/devpts/modules.builtin          |  0
>>  fs/ecryptfs/modules.builtin        |  1 +
>>  fs/efivarfs/modules.builtin        |  1 +
>>  fs/exportfs/modules.builtin        |  1 +
>>  fs/ext2/modules.builtin            |  1 +
>>  fs/ext4/modules.builtin            |  1 +
>>  fs/fat/modules.builtin             |  2 ++
>>  fs/fuse/modules.builtin            |  1 +
>>  fs/hugetlbfs/modules.builtin       |  0
>>  fs/io-wq.h.rej                     | 25 +++++++++++++++++++++++++
>>  fs/io_uring.c                      |  8 ++++----
>>  fs/iomap/modules.builtin           |  0
>>  fs/isofs/modules.builtin           |  1 +
>>  fs/jbd2/modules.builtin            |  1 +
>>  fs/kernfs/modules.builtin          |  0
>>  fs/lockd/modules.builtin           |  1 +
>>  fs/modules.builtin                 |  9 +++++++++
>>  fs/nfs/modules.builtin             |  4 ++++
>>  fs/nfs_common/modules.builtin      |  2 ++
>>  fs/nls/modules.builtin             |  1 +
>>  fs/notify/dnotify/modules.builtin  |  0
>>  fs/notify/fanotify/modules.builtin |  0
>>  fs/notify/inotify/modules.builtin  |  0
>>  fs/notify/modules.builtin          |  0
>>  fs/proc/modules.builtin            |  0
>>  fs/pstore/modules.builtin          |  1 +
>>  fs/quota/modules.builtin           |  0
>>  fs/ramfs/modules.builtin           |  0
>>  fs/squashfs/modules.builtin        |  1 +
>>  fs/sysfs/modules.builtin           |  0
>>  fs/tracefs/modules.builtin         |  0
>>  fs/xfs/modules.builtin             |  1 +
>>  37 files changed, 62 insertions(+), 4 deletions(-)
>>  create mode 100644 fs/autofs/modules.builtin
>>  create mode 100644 fs/btrfs/modules.builtin
>>  create mode 100644 fs/configfs/modules.builtin
>>  create mode 100644 fs/crypto/modules.builtin
>>  create mode 100644 fs/debugfs/modules.builtin
>>  create mode 100644 fs/devpts/modules.builtin
>>  create mode 100644 fs/ecryptfs/modules.builtin
>>  create mode 100644 fs/efivarfs/modules.builtin
>>  create mode 100644 fs/exportfs/modules.builtin
>>  create mode 100644 fs/ext2/modules.builtin
>>  create mode 100644 fs/ext4/modules.builtin
>>  create mode 100644 fs/fat/modules.builtin
>>  create mode 100644 fs/fuse/modules.builtin
>>  create mode 100644 fs/hugetlbfs/modules.builtin
>>  create mode 100644 fs/io-wq.h.rej
>>  create mode 100644 fs/iomap/modules.builtin
>>  create mode 100644 fs/isofs/modules.builtin
>>  create mode 100644 fs/jbd2/modules.builtin
>>  create mode 100644 fs/kernfs/modules.builtin
>>  create mode 100644 fs/lockd/modules.builtin
>>  create mode 100644 fs/modules.builtin
>>  create mode 100644 fs/nfs/modules.builtin
>>  create mode 100644 fs/nfs_common/modules.builtin
>>  create mode 100644 fs/nls/modules.builtin
>>  create mode 100644 fs/notify/dnotify/modules.builtin
>>  create mode 100644 fs/notify/fanotify/modules.builtin
>>  create mode 100644 fs/notify/inotify/modules.builtin
>>  create mode 100644 fs/notify/modules.builtin
>>  create mode 100644 fs/proc/modules.builtin
>>  create mode 100644 fs/pstore/modules.builtin
>>  create mode 100644 fs/quota/modules.builtin
>>  create mode 100644 fs/ramfs/modules.builtin
>>  create mode 100644 fs/squashfs/modules.builtin
>>  create mode 100644 fs/sysfs/modules.builtin
>>  create mode 100644 fs/tracefs/modules.builtin
>>  create mode 100644 fs/xfs/modules.builtin
>>
>> diff --git a/fs/autofs/modules.builtin b/fs/autofs/modules.builtin
>> new file mode 100644
>> index 000000000000..3425a57879aa
>> --- /dev/null
>> +++ b/fs/autofs/modules.builtin
>> @@ -0,0 +1 @@
>> +fs/autofs/autofs4.ko
> 
> <snip>
> 
> Something went really wrong with this backport :(

Wow yes, I think it was my 'update what's new script'. Guess I didn't
notice, sorry about that.

> Can you fix it up and resend these?

Here's the series again. The actual change was fine, just had to get
rid of the garbage.

-- 
Jens Axboe


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0006-io_uring-fail-links-of-cancelled-timeouts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0006-io_uring-fail-links-of-cancelled-timeouts.patch"

From 526007049cf7a5f4ec3a0f09afc30a56807f168c Mon Sep 17 00:00:00 2001
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


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io-wq-fix-race-between-adding-work-and-activating-a-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io-wq-fix-race-between-adding-work-and-activating-a-.pa";
 filename*1="tch"

From 8ef3b04b6470ed607ad161cc2e65aefe530411ed Mon Sep 17 00:00:00 2001
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


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io-wq-fix-wakeup-race-when-adding-new-work.patch"

From d94e66a1a2eb4dcd498df1d7fb14996a8b40e1d0 Mon Sep 17 00:00:00 2001
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


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-io_uring-fix-io_try_cancel_userdata-race-for-iowq.patch"

From 93bd93c0172c18a33e6823fbeb613a6e78b811ed Mon Sep 17 00:00:00 2001
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


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-add-splice_fd_in-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-add-splice_fd_in-checks.patch"

From 27a0c5a2da7f638a253ebac7be3b1a092cdcec09 Mon Sep 17 00:00:00 2001
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


--------------298B91F2C28ABD5E116D8EAC
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-place-fixed-tables-under-memcg-limits.patch"

From 671e10f7f397419ef68d39f0a0c6ded590eedc84 Mon Sep 17 00:00:00 2001
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
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.33.0


--------------298B91F2C28ABD5E116D8EAC--
