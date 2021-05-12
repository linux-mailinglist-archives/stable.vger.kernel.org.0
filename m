Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7137B8FF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhELJWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhELJWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F6861177;
        Wed, 12 May 2021 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620811258;
        bh=wl83599w3a6Mymugb+X2H4Z9k3wGffmTnbVldUY2F8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TNT3QjlZnmBVSMY4Drk4/FiKWPauk46MQWSi1P0VYPpxXnsfg18E2d1ZJZ+2EFYdr
         u3QggaLiKdJiJgFVqnFpCgwnB0KAUy8r/dtOk3Xkjr/HcrvyAHDclw10VPHqLtMeKY
         uK5a+Cd6gZ18amim4QnLSUz99lfe7r+AN/d8iYeA=
Date:   Wed, 12 May 2021 11:20:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Map all PIDs to command lines"
 failed to apply to 4.9-stable tree
Message-ID: <YJud95h50YUr0zl/@kroah.com>
References: <16206366172647@kroah.com>
 <20210510120445.55926bfe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510120445.55926bfe@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 12:04:45PM -0400, Steven Rostedt wrote:
> On Mon, 10 May 2021 10:50:17 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> 
> Looks like the following two commits also need to be backported, and then
> this one should apply fine. The two commits do fix the code, so there
> should be no issues backporting them:
> 
>   eaf260ac04d9b4cf9f458d5c97555bfff2da526e
>   ("tracing: Treat recording comm for idle task as a success")
> 
> 
>   e09e28671cda63e6308b31798b997639120e2a21
>   ("tracing: Use strlcpy() instead of strcpy() in __trace_find_cmdline()")
> 
> After backporting the above two, I was able to apply and test this patch to
> both 4.9 and 4.4.

That worked, thanks!

greg k-h
