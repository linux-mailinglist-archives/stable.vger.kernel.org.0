Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65473B810F
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhF3LJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 07:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhF3LJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 07:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFFA61447;
        Wed, 30 Jun 2021 11:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625051201;
        bh=CJAxId1381zQAlIrCiuoBZ8izcZU0T+sz1hTGjqWUJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zmMSAk0FcWgBtUn4JmKogSutbzlWTiVMyPhZ9IgdbSLpKHWDlYs9AVxrFKu/XzLo3
         /uRthklJ+1IIyEm8HEDXBpLIQFZ3yDMrEDVq7tmLUgvX2TM0zX4C622rvhCXjQc+FP
         vvP7lsC9wnMocA8kD9mWY2VDMKnihIMYywXhlNpc=
Date:   Wed, 30 Jun 2021 13:06:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        jenhaochen@google.com, liumartin@google.com, minchan@google.com,
        nathan@kernel.org, ndesaulniers@google.com, oleg@redhat.com,
        tj@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] kthread_worker: Fix race between
 kthread_mod_delayed_work()
Message-ID: <YNxQPzcr7FaMERZd@kroah.com>
References: <162480383515619@kroah.com>
 <20210630110149.25086-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630110149.25086-1-pmladek@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 01:01:47PM +0200, Petr Mladek wrote:
> This is backport of the series for the following stable trees:
> 
>    + 4.9
>    + 4.14
>    + 4.19
> 
> The orignal series did not apply because of a conflict with the commit
> ("kthread: Convert worker lock to raw spinlock").
> 
> Petr Mladek (2):
>   kthread_worker: split code for canceling the delayed work timer
>   kthread: prevent deadlock when kthread_mod_delayed_work() races with
>     kthread_cancel_delayed_work_sync()
> 
>  kernel/kthread.c | 77 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 51 insertions(+), 26 deletions(-)
> 
> -- 
> 2.26.2
> 

What is the original git commit ids of these patches in Linus's tree?

thanks,

greg k-h
