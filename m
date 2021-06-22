Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEDE3B0122
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFVKTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFVKTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 06:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64982613B4;
        Tue, 22 Jun 2021 10:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624357038;
        bh=yWSbMd+C0EmZ2hw9Y5/RP7iXaJ4z25nGRFU4jOS5Kl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVgd9UIECd3hzNFddMs+Z/LCMeAMZ5Dqg/Zqf9qUcFug4lagVfZa9HbpVE6NQGJ/l
         oUrUFUgofA1RhvsUx4wG9YUEZu3AcZHuxwTQjfmg3vx9cpVHbIj6KAFftLMyf3tZ8R
         oe2gq09xCD7Mi91An5HtrWlqD8QaGRaOs44V935A=
Date:   Tue, 22 Jun 2021 12:17:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal
 restore failures" failed to apply to 4.4-stable tree
Message-ID: <YNG4q++kHwWtVupg@kroah.com>
References: <162427273275124@kroah.com>
 <YNDQHgGztJAWO2H+@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNDQHgGztJAWO2H+@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 07:45:02PM +0200, Borislav Petkov wrote:
> On Mon, Jun 21, 2021 at 12:52:12PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Ok, how's this below?
> 
> It should at least capture the gist of what this commit is trying to
> achieve as the FPU mess has changed substantially since 4.4 so I'm
> really cautious here not to break any existing setups.
> 
> I've boot-tested this in a VM but Greg, I'd appreciate running it
> through some sort of stable testing framework if you're using one.

This applied to 4.4.y and 4.9.y, but we still need a 4.14.y and 4.19.y
version if at all possible.

thanks,

greg k-h
