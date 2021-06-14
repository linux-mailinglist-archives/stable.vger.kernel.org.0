Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC63A5E96
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 10:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhFNIwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 04:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhFNIwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 04:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85DB761380;
        Mon, 14 Jun 2021 08:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623660596;
        bh=qpaqj25xtHBZnnCQMuu4+k+LMxm7M/eBHS4KhuNwB2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l7jvAe75jlS6FC7wc3iRkvNhgFSlFbjfbKa0L2mMx20DWrk+Dg4hnh7015fNayE5K
         SaclXAQCGrV+yfOEN0ziGPXr6DGDicDom4wjlyYAQ+UFsKqpomY4eIy32F8b0NIore
         ar717aUX/zsxKJY2hOIpejrAYsBiM1zvhBYV89d8=
Date:   Mon, 14 Jun 2021 10:49:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mark-pk.tsai@mediatek.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip
 address in ftrace_bug()" failed to apply to 5.4-stable tree
Message-ID: <YMcYMZFDV1VIDlMf@kroah.com>
References: <1623585795198152@kroah.com>
 <20210613212607.5d1de4f8@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613212607.5d1de4f8@rorschach.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 13, 2021 at 09:26:07PM -0400, Steven Rostedt wrote:
> On Sun, 13 Jun 2021 14:03:15 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> 
> The function probe_kernel_read() was renamed to
> copy_from_kernel_nofault() somewhere between 5.4 and 5.10, and since
> this patch uses copy_from_kernel_nofault(), it doesn't exist in those
> earlier kernels. Here's a new version using the older name (and this
> should work for 4.4 through 5.10)

Now queued up, thanks.

greg k-h
