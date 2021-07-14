Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A553C85B1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhGNOAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 10:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbhGNOAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 10:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F1B61374;
        Wed, 14 Jul 2021 13:57:58 +0000 (UTC)
Date:   Wed, 14 Jul 2021 15:57:56 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>
Cc:     brauner@kernel.org, dvyukov@google.com, gregkh@linuxfoundation.org,
        gscrivan@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
Message-ID: <20210714135756.ammzl2vfiepzg3ve@wittgenstein>
References: <00000000000069c40405be6bdad4@google.com>
 <000000000000b00c1105c6f971b2@google.com>
 <20210714135157.mz7utfhctbja4ilo@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210714135157.mz7utfhctbja4ilo@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 03:51:57PM +0200, Christian Brauner wrote:
> On Mon, Jul 12, 2021 at 09:12:20PM -0700, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=178919b0300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=20276914ec6ad813
> > dashboard link: https://syzkaller.appspot.com/bug?extid=283ce5a46486d6acdbaf
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120220f2300000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115f37b4300000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
> > BUG: KASAN: use-after-free in atomic64_read include/asm-generic/atomic-instrumented.h:605 [inline]
> > BUG: KASAN: use-after-free in atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
> > BUG: KASAN: use-after-free in filp_close+0x22/0x170 fs/open.c:1306
> > Read of size 8 at addr ffff888025a40a78 by task syz-executor493/8445
> 
> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/ 595fac5cecba71935450ec431eb8dfa963cf45fe 

Hm, git.kernel.org doesn't seem to have caught up. Let's try:

#syz test: https://gitlab.com/brauner/linux.git 595fac5cecba71935450ec431eb8dfa963cf45fe 
