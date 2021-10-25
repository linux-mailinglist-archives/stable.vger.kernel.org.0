Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6614399B3
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 17:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhJYPKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 11:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233811AbhJYPKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 11:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D79E660D43;
        Mon, 25 Oct 2021 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635174466;
        bh=li4gRPoykeQyLqnlRVzlu5ss2w0LVrrOUMFyFb1SZfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Trj17tCjGN0Q3WgcZSowYnkktUJ1nNhNnlN+drpjQzrr0ii04FqwACAZyKSl3vDCe
         r3eknGaYnfpXPgy/JwJvAgIOxTzerHRLaLSPfNw4TYDBwbceCJ4bK1inmvPXKZk0Os
         kRe7COtL6g7uO/d8lT60d5q0ebRbr5gGuYDNDF7U=
Date:   Mon, 25 Oct 2021 17:07:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     James.Bottomley@hansenpartnership.com, aou@eecs.berkeley.edu,
        benh@kernel.crashing.org, bp@alien8.de, colin.king@canonical.com,
        deller@gmx.de, guoren@kernel.org, hpa@zytor.com, jikos@kernel.org,
        joe.lawrence@redhat.com, jpoimboe@redhat.com, jszhang@kernel.org,
        mbenes@suse.cz, mhiramat@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, npiggin@gmail.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org,
        pmladek@suse.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, yun.wang@linux.alibaba.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Have all levels of checks
 prevent recursion" failed to apply to 4.9-stable tree
Message-ID: <YXbIQELuy3sitOfj@kroah.com>
References: <163507502363143@kroah.com>
 <20211025103103.3c96521b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025103103.3c96521b@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 10:31:03AM -0400, Steven Rostedt wrote:
> On Sun, 24 Oct 2021 13:30:23 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> This should fix 4.9 and 4.4.

Now queued up, thanks.

greg k-h
