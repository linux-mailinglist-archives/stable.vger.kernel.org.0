Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38BE3B8154
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhF3LeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 07:34:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45470 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3LeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 07:34:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 41FE622717;
        Wed, 30 Jun 2021 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625052706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U1K7Ltsy8MownvHFRk4edGOVOu4GBEc9jhy5L2uix1k=;
        b=uBfLZXpu/B5QPQLVTrF+CY6YGYN906eRiOsLJgQ9AFA8e33Z2/iC6lYYywCtrgnxWlkxXU
        V9L0g1UYbY0nW4ByC0XnSGr/PYwuLMDC/y82pNo30DH6KP3TOw1DO7axJQs2JjI1eX6WqV
        fzqqvesWJlam9Ykt2DQkh9qM0VtGqc4=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 22A8AA3B85;
        Wed, 30 Jun 2021 11:31:46 +0000 (UTC)
Date:   Wed, 30 Jun 2021 13:31:45 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] kthread_worker: Fix race between
 kthread_mod_delayed_work()
Message-ID: <YNxWIb1GBU0hOE8B@alley>
References: <162480383515619@kroah.com>
 <20210630110149.25086-1-pmladek@suse.com>
 <YNxQPzcr7FaMERZd@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNxQPzcr7FaMERZd@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2021-06-30 13:06:39, Greg KH wrote:
> On Wed, Jun 30, 2021 at 01:01:47PM +0200, Petr Mladek wrote:
> > This is backport of the series for the following stable trees:
> > 
> >    + 4.9
> >    + 4.14
> >    + 4.19
> > 
> > The orignal series did not apply because of a conflict with the commit
> > ("kthread: Convert worker lock to raw spinlock").
> > 
> > Petr Mladek (2):
> >   kthread_worker: split code for canceling the delayed work timer
> >   kthread: prevent deadlock when kthread_mod_delayed_work() races with
> >     kthread_cancel_delayed_work_sync()
> > 
> >  kernel/kthread.c | 77 ++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 51 insertions(+), 26 deletions(-)
> > 
> > -- 
> > 2.26.2
> > 
> 
> What is the original git commit ids of these patches in Linus's tree?

commit 34b3d5344719d14fd2185b2d9459b3abcb8cf9d8 ("kthread_worker: split code for canceling the delayed work timer")
commit 5fa54346caf67b4b1b10b1f390316ae466da4d53 ("kthread: prevent deadlock when kthread_mod_delayed_work() races with kthread_cancel_delayed_work_sync())"

The original commits have already been taken for the newer stable trees.

I am sorry for the inconvenience.

Best Regards,
Petr
