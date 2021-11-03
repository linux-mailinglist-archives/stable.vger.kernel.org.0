Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BCC4447B7
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhKCRwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhKCRwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913FC608FB;
        Wed,  3 Nov 2021 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635961768;
        bh=r3E/ue33S593YT2EzfrJ0Ey+T6bI2zK6NIeYCIVG23g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xUbGhtMCad86BzhAjLyQfSco/K1i7FZpDNq+ncDbOjOw3u/5u7IqR5dcC2yaybqU3
         8C/hKr6qzBEGwj708lFTSURuYoo2ah/BfaZVCxPknwW8A4I7bd4EPa9duoNOxhGRUQ
         9Z7n10EWskKmOd5FH/m0O64qsPSQ/LWA4NafB4ZY=
Date:   Wed, 3 Nov 2021 18:49:25 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
Cc:     "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>,
        "ivansprundel@ioactive.com" <ivansprundel@ioactive.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.19-stable tree
Message-ID: <YYLLpajhUvBKFCAb@kroah.com>
References: <163559866411243@kroah.com>
 <CH0PR01MB715319BCF6C1A8C0F1F631C9F28C9@CH0PR01MB7153.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR01MB715319BCF6C1A8C0F1F631C9F28C9@CH0PR01MB7153.prod.exchangelabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 03:15:59PM +0000, Marciniszyn, Mike wrote:
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Saturday, October 30, 2021 8:58 AM
> > To: Marciniszyn, Mike <mike.marciniszyn@cornelisnetworks.com>;
> > Dalessandro, Dennis <dennis.dalessandro@cornelisnetworks.com>;
> > ivansprundel@ioactive.com; jgg@nvidia.com
> > Cc: stable@vger.kernel.org
> > Subject: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
> > struct" failed to apply to 4.19-stable tree
> > 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm tree,
> > then please email the backport, including the original git commit id to
> > <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Greg,
> 
> The only thing required for 4.19 for this patch is that:
> 
> 829ca44ecf60 ("IB/qib: Use struct_size() helper")
> 
> Is there first as a prereq.
> 
> How do you want to see that in the signature block meta language?

The documentation in:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
describes how to do this properly.

I've queued both of these up now for 4.19.y.

thanks,

greg k-h
