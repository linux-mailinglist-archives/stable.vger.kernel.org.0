Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6F439840
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 16:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJYOOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 10:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhJYOOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 10:14:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0564560E0B;
        Mon, 25 Oct 2021 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635171139;
        bh=I4JNUjo2l0toXhJpZ7pZ77SVKZY8eENiJokTW0RZp3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wph0LlGtgjkw7DNfybXjlKTUQ9c/BUTUTPyx8oHwcR5RyGPiiAM5O1d+elln8Mw/k
         nsMzWV9vFrQX1Y4iXeRSt4b1NKEjHv0zuVcwQuCxoXGX2PWSE6zbPFepEYi8q4VhcB
         Fycn02fTQ3VIpZDyMmPzMSaJzDkH4MoT1wg09yb0=
Date:   Mon, 25 Oct 2021 16:12:17 +0200
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
 prevent recursion" failed to apply to 4.19-stable tree
Message-ID: <YXa7QQnKHfnjONjq@kroah.com>
References: <163507501713625@kroah.com>
 <20211025100148.61deba41@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025100148.61deba41@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 10:01:48AM -0400, Steven Rostedt wrote:
> On Sun, 24 Oct 2021 13:30:17 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> >
> 
> Below should be the fix for 4.19 and 4.14

This, and the 5.4 and 5.10 versions now queued up, thanks.

greg k-h
