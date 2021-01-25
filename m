Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A405F3026F8
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 16:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbhAYPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 10:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbhAYO7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 09:59:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5A6208CA;
        Mon, 25 Jan 2021 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611586699;
        bh=USilElEcapQDLbjrL5xkQI0SwX/jVGB0EdSP0RsOtVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KO+zXquYR6DAlQ9MC2T8kAL9J9e/YGLDFkZu3S8r0V0GL7k2Ee0GvivwC0Vo07HKz
         oiIxhKNosXnyV3w77hdD7WkNkvvaKJ/V4LSbnt8fBIJCA4xwY/u7XYxxu2aIZy9011
         mV20Ys1NZ0tZ7mJNLP4fj6cHU7JoAOGc5vEh4s20=
Date:   Mon, 25 Jan 2021 15:58:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     pmladek@suse.com, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org, stable-commits@vger.kernel.org
Subject: Re: Patch "printk: fix buffer overflow potential for print_text()"
 has been added to the 5.10-stable tree
Message-ID: <YA7ciGUMJE2yls61@kroah.com>
References: <1611495423221153@kroah.com>
 <87zh0ym5wi.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh0ym5wi.fsf@jogness.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 09:39:33PM +0106, John Ogness wrote:
> Hi Greg,
> 
> On 2021-01-24, <gregkh@linuxfoundation.org> wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     printk: fix buffer overflow potential for print_text()
> 
> We just learned that this patch introduces a new problem. I have just
> posted a patch to fix the new problem:
> 
> https://lkml.kernel.org/r/20210124202728.4718-1-john.ogness@linutronix.de
> 
> You may want to hold off on applying the first fix until the second fix
> has been accepted. Then you can apply both.

Thanks, now queued up.  Can you let stable@vger.kernel.org know when
this one has been merged by Linus so we know to take both?

thanks,

greg k-h
