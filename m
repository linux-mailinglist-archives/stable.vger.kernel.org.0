Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4A18ACDC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 07:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSGhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 02:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSGhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 02:37:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052A920409;
        Thu, 19 Mar 2020 06:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584599864;
        bh=oPWpILqTq5s87t3JQQsEntj3t1mDjfnvzdz5BBHI5kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eR+Y/2UTHhc9/1kKAKH41G0TJxyCqkT6AsLmoVVkC2NillWUn+TMuCqKrh7Xu5WEE
         zkT2B+r/KQqHSpPq98+D2fH3KARzCx9IGljE0g38XKPafWYcWlNhmR5a/N2XrIRR2J
         FyCe/qLyMuhOQXpMgwpwe0D3yfQbv3yl6DqmypAk=
Date:   Thu, 19 Mar 2020 07:37:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] locks: fix a potential use-after-free problem when
 wakeup a waiter
Message-ID: <20200319063742.GB3274814@kroah.com>
References: <2082b1e11fdbf3b64f0da022fb15a8b615c3678c.camel@codethink.co.uk>
 <20200318222906.GJ4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318222906.GJ4189@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 06:29:06PM -0400, Sasha Levin wrote:
> On Wed, Mar 18, 2020 at 10:09:20PM +0000, Ben Hutchings wrote:
> > This commit (included in 5.6-rc5) seems to be needed for 5.4 and 5.5
> > branches:
> > 
> > commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da
> > Author: yangerkun <yangerkun@huawei.com>
> > Date:   Wed Mar 4 15:25:56 2020 +0800
> > 
> >    locks: fix a potential use-after-free problem when wakeup a waiter
> 
> I've queued it up for 5.5 and 5.4, thanks!
> 
> > I'm a bit surprised that it hasn't yet been applied, while some fixes
> > from 5.6-rc6 have.
> 
> Greg, I wonder if it makes sense to have you push a "Greg is here
> --->" "bookmark" in the form of a tag/branch on linux-stable-rc.git? at
> the very least it'll make it easy to see if something was missed or
> still waiting in the queue.

To quote Jeff Layton:

	Hi Greg, there is a performance regression with this patch. We're
	sorting through potential ways to address it at the moment, but you may
	want to hold off until we have a fix for that merged.
	
	Sorry for the hassle!

Which is why I dropped it for now.

I'll go drop it again :)

thanks,

greg k-h
