Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6516A2D9ABC
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388143AbgLNPRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:17:48 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41203 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730225AbgLNPRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 10:17:41 -0500
Received: by mail-lf1-f68.google.com with SMTP id r24so30970964lfm.8;
        Mon, 14 Dec 2020 07:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sD0L7cvnHrdAVd9N+7GUeurtQrheTVAAtj0Fz2YvVYI=;
        b=MMUohzpq+4VIiuSPbE0WK3QDiORLg9nmqis+BFdag6hBvkzRsqGrIyYdf+l5ykeP7B
         xGiKyqLysvoqN9Mpf6lRqxDQ58z4uwM1GbIirbiLyDZa3q0uvXFctL69masInzIZvVtJ
         mH8mMwqfyIQpDuDaVnVjxTauqvEL7loozF9s3cqVLg6QlChPziZUf62MSXG7p7i0xuXL
         9OXth1/cmV8ht0GQbthJXqE3DG76OA70JuWL/gKfCejoif0UrOco2uksDK1JvhP4iTop
         wTZtzo1leZMn/taoFwFlwnG04gFGgGJ9cYK8uCU4P2dfwJbQGedMV/KjT4kEBosKIpSJ
         Jnrw==
X-Gm-Message-State: AOAM530EANjf8lS+RKw85w7pG60Wm9BSzpQuYNgff1qzz4vE55h2RdQV
        GNleHGYtKozznvtsMaOrLkc=
X-Google-Smtp-Source: ABdhPJwxEmSDpkz9sYndOr2O52YN/Uc3a97LJXT01owGO13vKROe7tmXkEIGWDuUgqTAvKXJbT49yQ==
X-Received: by 2002:ac2:5c46:: with SMTP id s6mr3858102lfp.207.1607959018984;
        Mon, 14 Dec 2020 07:16:58 -0800 (PST)
Received: from xi.terra (c-b3cbe455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.203.179])
        by smtp.gmail.com with ESMTPSA id e1sm1815564lfs.279.2020.12.14.07.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 07:16:57 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kopan-00080a-EG; Mon, 14 Dec 2020 16:16:54 +0100
Date:   Mon, 14 Dec 2020 16:16:53 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Johan Hovold <johan@kernel.org>,
        syzbot <syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in yurex_write/usb_submit_urb
Message-ID: <X9eB5ZZMq6q5j4eW@localhost>
References: <X9dDkwlOTFeo9eZ6@localhost>
 <000000000000af6ec005b66dbaa2@google.com>
 <X9d+dZq/IA+tiw5v@localhost>
 <CAAeHK+xLiLjGMJLuWpyPHMO=zD6k33s5VYSBDMMbTkAEauF3dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+xLiLjGMJLuWpyPHMO=zD6k33s5VYSBDMMbTkAEauF3dA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 04:06:49PM +0100, Andrey Konovalov wrote:
> On Mon, Dec 14, 2020 at 4:02 PM Johan Hovold <johan@kernel.org> wrote:
> >
> > On Mon, Dec 14, 2020 at 06:48:03AM -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > WARNING in yurex_write/usb_submit_urb
> >
> > It appears syzbot never tested the patch from the thread. Probably using
> > it's mail interface incorrectly, I don't know and I don't have time to
> > investigate. The patch itself is correct.
> 
> Hi Johan,
> 
> I wasn't CCed on the testing request, so I can't say what exactly was wrong.

Here's the patch and the "syz test" command in a reply:

	https://lore.kernel.org/r/20201214104444.28386-1-johan@kernel.org

Probably needs to go in the same mail, right?

How about including the command needed to test a patch in the syzbot
report mail to assist the casual user of its interfaces? I had to browse
the web page you link to and still got it wrong apparently.

> Could you send me the patch you were trying to test?

Does this work better:

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing

Johan


From 3bb77b2ac604d70b06f45a850e326dda9c99c9cd Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 14 Dec 2020 11:30:53 +0100
Subject: [PATCH] USB: yurex: fix control-URB timeout handling

Make sure to always cancel the control URB in write() so that it can be
reused after a timeout or spurious CMD_ACK.

Currently any further write requests after a timeout would fail after
triggering a WARN() in usb_submit_urb() when attempting to submit the
already active URB.

Reported-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com
Fixes: 6bc235a2e24a ("USB: add driver for Meywa-Denki & Kayac YUREX")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/yurex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 73ebfa6e9715..c640f98d20c5 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -496,6 +496,9 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);
 
+	/* make sure URB is idle after timeout or (spurious) CMD_ACK */
+	usb_kill_urb(dev->cntl_urb);
+
 	mutex_unlock(&dev->io_mutex);
 
 	if (retval < 0) {
-- 
2.26.2


