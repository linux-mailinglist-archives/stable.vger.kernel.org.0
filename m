Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9583282BF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhCAPoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237075AbhCAPoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 10:44:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B75A264D5D;
        Mon,  1 Mar 2021 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614613406;
        bh=yVXjrjD/Kcq7kpzZNWglcQv7ziGMi7fQx2ZsPOrMfRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q3jm0flby8NQpOAgjNbJf/SVQOwaB9Mx1aHHEpC/dyRk5OYXuFKvR3au7Q9rVhdxZ
         Xqhu3U4xA6lKLeLKh2RZb91yeNXb8iW97W3SjLYI4u89S2GxGMQRBpq5vFzthxMyDK
         O001Rsv6DR8oydZlUOL5jZVbx2Psl+KAeBtuoJBs=
Date:   Mon, 1 Mar 2021 16:43:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nikos Tsironis <ntsironis@arrikto.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm era: Update in-core bitset after
 committing the metadata" failed to apply to 5.4-stable tree
Message-ID: <YD0Lm6qwqDp0mRqo@kroah.com>
References: <161460644719394@kroah.com>
 <e8307822-5358-c3e3-7361-481034d0685e@arrikto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8307822-5358-c3e3-7361-481034d0685e@arrikto.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 05:27:26PM +0200, Nikos Tsironis wrote:
> On 3/1/21 3:47 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> Hi Greg,
> 
> Attached is the backport, which applies to all stable branches until
> 4.4-stable.

Now queued up, thanks.

greg k-h
