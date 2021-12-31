Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE020482377
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 11:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhLaKak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 05:30:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42968 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhLaKak (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 05:30:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2013A61704;
        Fri, 31 Dec 2021 10:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2A6C36AEB;
        Fri, 31 Dec 2021 10:30:38 +0000 (UTC)
Date:   Fri, 31 Dec 2021 11:30:34 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] fs/mount_setattr: always cleanup mount_kattr
Message-ID: <20211231103034.szasg7xymtfhh552@wittgenstein>
References: <20211230192309.115524-1-christian.brauner@ubuntu.com>
 <CAHk-=winoYrnz+KQA5Mqrw9f=PeyvKT2SsyAx=ZCUoBxm4kDpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=winoYrnz+KQA5Mqrw9f=PeyvKT2SsyAx=ZCUoBxm4kDpA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 30, 2021 at 03:14:33PM -0800, Linus Torvalds wrote:
> On Thu, Dec 30, 2021 at 11:23 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Would you be ok with applying this fix directly? I
> 
> Done.
> 
> That said, I would have liked a "Fixes:" tag, or some indication of
> how far back the stable people should take this..

Ugh, I missed to add that.
From a pure upstream stable perspective the only relevant and still
supported kernel that should get this fix is 5.15.

I can make it a custom to mark all patches that should go to stable with
the first kernel version where a given fix should be applied. In this
case this whould've meant I'd given it:

Cc: <stable@vger.kernel.org> # v5.12+

For upstream stable maintainers it should be clear that since the only
supported stable version within the range is v5.15.
For downstream users/distros it should help to identify whether they
still run/maintain a kernel that falls within the range of kernels that
would technically be eligible for this fix.

I haven't seen whether we prefer the Cc: with # v*.**+ syntax to a
simple Cc: without it nowadays.

> 
> I assume it's 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP"), and

Yes, that's correct. Thanks!

> that's what I added manually to it as I applied it, but relying on me
> noticing and getting things right can be a risky business..

Noted. :)

Christian
