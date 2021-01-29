Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53370308351
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 02:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhA2Biv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 20:38:51 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:36559 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhA2Bir (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 20:38:47 -0500
Received: by mail-io1-f69.google.com with SMTP id f7so5638916ioz.3
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 17:38:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lm16eCirJMAjlWtITfJJw0jmgaMJxdBabVfxLijbAp0=;
        b=sejScSJsL2V8wLAxi+XRV7ZZ6MGkYLuXEBni/x6wbtp8UhIh4EboqfI1qVVsgk9i+G
         sCex4BwEWYWcBMzgpKVwf0/HnvosOwk0lZOR/GNMULqxTWbNYrWg8STYywOqnN42qAON
         evSIlXuuGWIG3IcplExOnoeSbUGguoPkdU9F+FdFyxGCfc2Q6H1KC0TxWf4Sq3Wjwp85
         DOmDFyjB3UupQuvEJL2/sAObTZHA3RMgxTQBdT32kyYM7mkuSeKFCYWI6aMG9/FqFn8V
         st4URuy8mdjle2+/dzIiyuGLvt1HWIAPsUsxvypFAEUX45KlyC75KIZdBzcsT83xHLaN
         smWA==
X-Gm-Message-State: AOAM5323mIFJ+CDzAYy3q8x0YeEjT+zBSLPLTutemihcopTCjB+AIZnY
        8oliMOjbctOXYnJNnMhPacviXzqQ5MP41J4Drp3qECytgs4M
X-Google-Smtp-Source: ABdhPJzaeeto+90vKfwCqIzrB5cp8eqdHC8gCKgD33zO40cOrw2abKT9qoVAFdgqqOolzOUWECqyCPq1B3LE/EP9Hzwa53UUwB8D
MIME-Version: 1.0
X-Received: by 2002:a6b:f714:: with SMTP id k20mr2029676iog.70.1611884286518;
 Thu, 28 Jan 2021 17:38:06 -0800 (PST)
Date:   Thu, 28 Jan 2021 17:38:06 -0800
In-Reply-To: <000000000000619ae405b9f8cf6e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000512a7f05ba000ead@google.com>
Subject: Re: WARNING in io_uring_cancel_task_requests
From:   syzbot <syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has bisected this issue to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=133f3090d00000
start commit:   d03154e8 Add linux-next specific files for 20210128
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10bf3090d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=173f3090d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3d9bd0c6ce9efbc3ef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a924c4d00000

Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
