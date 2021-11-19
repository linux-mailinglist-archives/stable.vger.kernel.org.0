Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512C2456F0D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhKSMtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 07:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235292AbhKSMtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 07:49:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E00E361AE2;
        Fri, 19 Nov 2021 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637326003;
        bh=uSChNcUmks77k/avVb3rI2CZd3bmAwkii9eTi2F7Ddk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXNBTa+6fkmvuy9Z/LhQWSZl4CULCzE9tmnsLDALOGyDHWJq/LWjDpasHDfhVxYdx
         /9p6llAQGhgZr2OXEYPN+JR7zlg304mxu+8AP2QUH+Gg3FcXawlWqF7oX4uZB274AE
         BoYlrEXGHdrxZwxqi0nfqkBfa+gVA4J/JBU1RiG8=
Date:   Fri, 19 Nov 2021 13:46:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mhiramat@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bootconfig: init: Fix memblock leak in
 xbc_make_cmdline()" failed to apply to 5.14-stable tree
Message-ID: <YZecsMUG7meUg9ym@kroah.com>
References: <1634553054181194@kroah.com>
 <20211116161258.55b5e50d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116161258.55b5e50d@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 04:12:58PM -0500, Steven Rostedt wrote:
> On Mon, 18 Oct 2021 12:30:54 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> This should apply to both 5.14 and 5.10.

Now queued up, thanks.

greg k-h
