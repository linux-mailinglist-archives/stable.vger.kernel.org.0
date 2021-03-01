Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6043278E6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 09:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhCAIHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 03:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232748AbhCAIHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 03:07:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A1564E42;
        Mon,  1 Mar 2021 08:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614586026;
        bh=eYrKiRldcGd1/qq+sxHlcpmOrp2wd88rQgkH0JmzMWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RvWeE1sPx0qe4txJaTyOiAnGuNX+mLLY4p8Do+UwiMsq18H8uw2VduUeZbCs29Yum
         UDihHV0SreF2nc73wquBoDwBM9FuwwQOmcImPUk83qQCcw3JZA17EIFSwYL+rxLmai
         HGZZ9+8pLgZyB1uNpKb1GCCsR50Orbvzp4SFlzuM=
Date:   Mon, 1 Mar 2021 09:07:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: futex breakage in 4.9 stable branch
Message-ID: <YDygp3WYafzcgt+s@kroah.com>
References: <161408880177110@kroah.com>
 <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 01:13:08AM +0100, Ben Hutchings wrote:
> On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> > I'm announcing the release of the 4.9.258 kernel.
> > 
> > All users of the 4.9 kernel series must upgrade.
> > 
> > The updated 4.9.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
> > and can be browsed at the normal kernel.org git web browser:
> >         
> 
> The backported futex fixes are still incomplete/broken in this version.
> If I enable lockdep and run the futex self-tests (from 5.10):
> 
> - on 4.9.246, they pass with no lockdep output
> - on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
>   lockdep splat
> 
> I have a local branch that essentially updates futex and rtmutex in
> 4.9-stable to match 4.14-stable.  With this, the tests pass and lockdep
> is happy.
> 
> Unfortunately, that branch has about another 60 commits.  Further, the
> more we change futex in 4.9, the more difficult it is going to be to
> update the 4.9-rt branch.  But I don't see any better option available
> at the moment.
> 
> Thoughts?

There were some posted futex fixes for 4.9 (and 4.4) on the stable list
that I have not gotten to yet.

Hopefully after these are merged (this week), these issues will be
resolved.

If not, then yes, they need to be fixed and any help you can provide
would be appreciated.

As for "difficulty", yes, it's rough, but the changes backported were
required, for obvious reasons :(

thanks,

greg k-h
