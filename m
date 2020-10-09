Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D527C288A4F
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgJIOIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 10:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgJIOIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 10:08:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D8C822261;
        Fri,  9 Oct 2020 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602252517;
        bh=QynOZqMqqwqbeeMWsYd/k/XPjWFdrMkGUv+eB1jU7Tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIJl9a5L+jWU8lm6AwF3IcC/HVkLsLiRWNFsYIGLj+4zs4b6rZgGQnBuX17Dpq0pY
         mKsbfrVb0s68psbA2DOWdJo2xCMhmpEUHU66pXLCpaJCw0HYjFFipCx9mX4rG/BUNl
         WtiRG70pygZteGA9kRht5Mi3scysGZwAiddmHLM0=
Date:   Fri, 9 Oct 2020 16:09:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     paulmck@kernel.org, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Move RCU is watching check after
 recursion check" failed to apply to 4.14-stable tree
Message-ID: <20201009140923.GD573779@kroah.com>
References: <1601808916133245@kroah.com>
 <20201005113401.67628dbf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005113401.67628dbf@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 05, 2020 at 11:34:01AM -0400, Steven Rostedt wrote:
> On Sun, 04 Oct 2020 12:55:16 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> The below should work for 4.14 and 4.9.

Now queued up, thanks.

greg k-h
