Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2899C3C76B4
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 20:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhGMSw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhGMSw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 14:52:26 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCC6C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 11:49:34 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a6so31523198ljq.3
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRjP314M1GpUJgRSbgMGoaSYR4Jg4jHqUSa68YgJXO4=;
        b=e4sNa/Sg9kxdAqw8spcbO5TswTuu+YuZY4qDNyyT4dhSXDPimR6bb2lWnbbuTInGqB
         vYUg38sUbSqtZrcvWZKELF4PIlu5pb7g5GNPYB2a3PjVTtamIQpdhfHkcPbrrm/2URQS
         WJcBQQ/7EzRD+zl/dWIaXSSXiQFQ87HU4XNVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRjP314M1GpUJgRSbgMGoaSYR4Jg4jHqUSa68YgJXO4=;
        b=guf/LZlsZV5K6auALsX1ZVCX6JBhnGiyhlguJLIIqGQ8YOcdLzXJaDgwVNCEhf2Uqq
         GMiaUOoLX0A+9odpa4hs3Ybto/rYXp0/VinlmkjzvTBHDTt0H8FTiQD/LrS/ZRXRBUp9
         TNSS1NVfXNVAs7k8wMQ+HGixhz+lk1zN1AcXJ8Tk7hLEhGp1AuNdkMqP/dfos118VreQ
         WhPyqxFI5y8m8iHZAgkv9zCby2sTOFbWofK8aCT9VTlX5lTPe/dbKdmuHRX6pA2ez5me
         s9TaztahJN0pF9ReRZ/PyxJ2jk89+hxar10y0i+bktM0GCfKPc1x1QFpS44dLqO65TUh
         aC2g==
X-Gm-Message-State: AOAM530X4tmdoXlOYV7B0N4QHxq8MTiGhRD/iIFwlz1CKYZyFKEYxzcv
        olupRTWYJZFs/ZE4rDC28xNRMa/vDcRSJQNwWsE=
X-Google-Smtp-Source: ABdhPJxgku7A6LN565bd4+RF86eGXRWbg83mpO5yKSJmPIe/nbTAJYRnzIY9UovgPOpLYPl3CznBPw==
X-Received: by 2002:a05:651c:1aa:: with SMTP id c10mr5501330ljn.56.1626202172396;
        Tue, 13 Jul 2021 11:49:32 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id m18sm1651763lfh.270.2021.07.13.11.49.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 11:49:31 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id 11so27467343ljv.1
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 11:49:30 -0700 (PDT)
X-Received: by 2002:a2e:a276:: with SMTP id k22mr5215151ljm.465.1626202170413;
 Tue, 13 Jul 2021 11:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000069c40405be6bdad4@google.com> <000000000000b00c1105c6f971b2@google.com>
In-Reply-To: <000000000000b00c1105c6f971b2@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 13 Jul 2021 11:49:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgWv1s1FbTxS+T7kbF-7LLm9Nz1eC+WBn+kr1WdYGtisA@mail.gmail.com>
Message-ID: <CAHk-=wgWv1s1FbTxS+T7kbF-7LLm9Nz1eC+WBn+kr1WdYGtisA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
To:     syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>
Cc:     brauner@kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gscrivan@redhat.com, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 9:12 PM syzbot
<syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:

Hmm.

This issue is reported to have been already fixed:

    Fix commit: 9b5b8722 file: fix close_range() for unshare+cloexec

and that fix is already in the reported HEAD commit:

> HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..

and the oops report clearly is from that:

> CPU: 1 PID: 8445 Comm: syz-executor493 Not tainted 5.14.0-rc1-syzkaller #0

so the alleged fix is already there.

So clearly commit 9b5b872215fe ("file: fix close_range() for
unshare+cloexec") does *NOT* fix the issue.

This was originally bisected to that 582f1fb6b721 ("fs, close_range:
add flag CLOSE_RANGE_CLOEXEC") in

     https://syzkaller.appspot.com/bug?id=1bef50bdd9622a1969608d1090b2b4a588d0c6ac

which is where the "fix" is from.

It would probably be good if sysbot made this kind of "hey, it was
reported fixed, but it's not" very clear.

The KASAN report looks like a use-after-free, and that "use" is
actually the sanity check that the file count is non-zero, so it's
really a "struct file *" that has already been free'd.

That bogus free is a regular close() system call

>  filp_close+0x22/0x170 fs/open.c:1306
>  close_fd+0x5c/0x80 fs/file.c:628
>  __do_sys_close fs/open.c:1331 [inline]
>  __se_sys_close fs/open.c:1329 [inline]

And it was opened by a "creat()" system call:

> Allocated by task 8445:
>  __alloc_file+0x21/0x280 fs/file_table.c:101
>  alloc_empty_file+0x6d/0x170 fs/file_table.c:150
>  path_openat+0xde/0x27f0 fs/namei.c:3493
>  do_filp_open+0x1aa/0x400 fs/namei.c:3534
>  do_sys_openat2+0x16d/0x420 fs/open.c:1204
>  do_sys_open fs/open.c:1220 [inline]
>  __do_sys_creat fs/open.c:1294 [inline]
>  __se_sys_creat fs/open.c:1288 [inline]
>  __x64_sys_creat+0xc9/0x120 fs/open.c:1288
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

But it has apparently already been closed from a workqueue:

> Freed by task 8445:
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164

So it's some kind of confusion and re-use of a struct file pointer.

Which is certainly consistent with the "fix" in 9b5b872215fe ("file:
fix close_range() for unshare+cloexec"), but it very much looks like
that fix was incomplete and not the full story.

Some fdtable got re-allocated? The fix that wasn't a fix ends up
re-checking the maximum file number under the file_lock, but there's
clearly something else going on too.

Christian?

                Linus
