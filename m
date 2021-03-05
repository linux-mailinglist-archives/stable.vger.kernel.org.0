Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907C032E26E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEGpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEGpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 01:45:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB70A64FEB;
        Fri,  5 Mar 2021 06:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614926714;
        bh=oyN7zdSeit+p1FrTPyehlQePbGbEOC5rydu7fMGPkMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+O/hklq/6u6d/hiNq6qnsHIqKds1kVAwwovdO1syvxO+MIFXZ/wlgbXJZp6f+Xad
         kH3vgEbT7w2AZiWchEBHpvcPRAMPkQHMCG7YRSXnFVR9R1zLmPJbE2ic2TaSDB9wtd
         dmF9cyZCApHWTuDeI6HYWz+osabu3qan/u8QQmvY=
Date:   Fri, 5 Mar 2021 07:45:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     stable@vger.kernel.org, srinivas.kandagatla@linaro.org,
        stable-commits@vger.kernel.org
Subject: Re: Patch "soundwire: debugfs: use controller id instead of link_id"
 has been added to the 5.11-stable tree
Message-ID: <YEHTd2/kKQPyMdrl@kroah.com>
References: <161487107335140@kroah.com>
 <YEGww3u0QR3pYGhF@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEGww3u0QR3pYGhF@vkoul-mobl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 09:47:07AM +0530, Vinod Koul wrote:
> Hi Greg,
> 
> On 04-03-21, 16:17, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     soundwire: debugfs: use controller id instead of link_id
> > 
> > to the 5.11-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      soundwire-debugfs-use-controller-id-instead-of-link_id.patch
> > and it can be found in the queue-5.11 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Please drop this patch from stable, it was not tagged to stable and it
> is reverted

Now dropped, thanks.

greg k-h
