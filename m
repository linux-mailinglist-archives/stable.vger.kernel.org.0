Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB9B3C87E2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhGNPqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhGNPqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 11:46:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9D46128D;
        Wed, 14 Jul 2021 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626277425;
        bh=d3SepSHR1zsaIRMdkArdFgOSddc3shwTd4YG7BFwsIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SebiK21tNzMm0ghmyLFb0800rIaLPx3doW48bB9z/Cf4mIX/tzPTzbbzkaKlC3bZ6
         3vaNpmcoeIMgzOVMQFN5TIdJnJutxcvdKOTgNdu3Ytzy274JKv/I7p9JOdqmqyzIJe
         xz9ycnGFXXOnvMG7fyZlNIprVdqoBTIx3X4CVqa4=
Date:   Wed, 14 Jul 2021 17:43:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO8GLupNQWpqsrT6@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
 <YO8EQZF4+iQ13QU/@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO8EQZF4+iQ13QU/@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 11:35:29AM -0400, Theodore Y. Ts'o wrote:
> On Wed, Jul 14, 2021 at 09:52:53AM -0400, Sasha Levin wrote:
> > On Wed, Jul 14, 2021 at 11:18:14AM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
> > > > Alternatively I could just invent a new tag to replace the "Fixes:"
> > > > ("Fixes-no-backport?") to be used on patches which fix a known previous
> > > > commit but which we don't want backported.
> > > 
> > > No please, that's not needed, I'll just ignore these types of patches
> > > now, and will go drop these from the queues.
> > > 
> > > Sasha, can you also add these to your "do not apply" script as well?
> > 
> > Sure, but I don't see how this is viable in the long term. Look at
> > distros that don't follow LTS trees and cherry pick only important
> > fixes, and see how many of those don't have a stable@ tag.
> 
> I've been talking to an enterprise distro who chooses not to use the
> LTS releases, and it's mainly because they tried it, and there was too
> many regressions leading to their customers filing problem reports
> which get escalated to their engineers, leading to unhappy customers
> and extra work for their engineers.  (And they have numbers to back up
> this assertion; this isn't just a gut feel sort of thing.)

When did they last actually do this?  Before or after we started testing
stable releases better?

I have numbers to back up the other side, along with the security
research showing that to ignore these stable releases puts systems at
documented risk.

But enterprise distros really are a small market these days, a rounding
error compared to Android phones, so maybe we just ignore what they do
as it's a very tiny niche market these days?  :)

thanks,

greg k-h
