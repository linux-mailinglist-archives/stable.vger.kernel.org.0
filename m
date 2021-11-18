Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9A4556E7
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbhKRI0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:26:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244270AbhKRI0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 03:26:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AEDE61361;
        Thu, 18 Nov 2021 08:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637223812;
        bh=754HzQeRSa4U0WKlwM/2vq9iGP9k2bKesd46flafvxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RfdcBvJsuGTw//As2G1IWXaH1710+QQqgWWfqrDuhq7eNXr0jl5Uayx037IkZrTUq
         CciS+XroAyox8eOnFydFVTglS6jiCboQeyH9904TsvEWgdhH/RiP5mHVh8dKoZ059V
         5uHsUk0Rpi1ZnJZkX+DFWxZ+tu2IKNdXrGWBMsVI=
Date:   Thu, 18 Nov 2021 09:23:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Szabolcs Sipos <labuwx@balfug.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Message-ID: <YZYNgUv51hs6suNE@kroah.com>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
 <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
 <YZP6CL+CDMyzQ6aA@kroah.com>
 <5931c469-c0bf-4e93-e7e3-443b5ca60fb3@denx.de>
 <YZSixJVYJxE7COuy@kroah.com>
 <182bce57-8a46-9631-3ecf-7eb7a89593ce@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182bce57-8a46-9631-3ecf-7eb7a89593ce@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 09:27:17PM +0100, Marek Vasut wrote:
> On 11/17/21 7:35 AM, Greg Kroah-Hartman wrote:
> > On Tue, Nov 16, 2021 at 08:58:15PM +0100, Marek Vasut wrote:
> > > On 11/16/21 7:35 PM, Greg Kroah-Hartman wrote:
> > > > On Tue, Nov 16, 2021 at 06:41:08PM +0100, Szabolcs Sipos wrote:
> > > > > On 10/11/21 09:44, Greg Kroah-Hartman wrote:
> > > > > > On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
> > > > > > > Hello everyone,
> > > > > > > 
> > > > > > > The following new device USB ID has landed in linux-next recently:
> > > > > > > 
> > > > > > > 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> > > > > > > 
> > > > > > > It would be nice if it could be backported to stable. I verified it works on
> > > > > > > 5.14.y as a simple cherry-pick .
> > > > > > 
> > > > > > A patch needs to be in Linus's tree before we can add it to the stable
> > > > > > releases.  Please let us know when it gets there and we will be glad to
> > > > > > pick it up.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > Hello Greg,
> > > > > 
> > > > > The patch has reached Linus's tree:
> > > > > 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> > > > > 
> > > > > Could you please add it to stable (5.15.y)?
> > > > 
> > > > I will queue it up for the next set of kernels after the current ones are
> > > > released.
> > > 
> > > btw while you're bringing it up, is there some sure-fire method I can use to
> > > verify the patch is in Linus tree, besides having a separate checkout of
> > > that tree ?
> > 
> > Without the tree/branch checked out?  Not that I know of, sorry.
> 
> I have a local checkout of Linus tree, except I also have other remotes in
> it, that's what I meant.
> 
> > > I usually have both Linus tree as origin and next in one git tree, so I was
> > > wondering if there is a recommended way to avoid mistakes like the one I
> > > made above (and checking at git.kernel.org apparently also has its
> > > downsides).
> > 
> > Having both in one git tree is fine.  Just switch between branches (one
> > that tracks Linus's and one that tracks linux-next) and you can see what
> > is happening in each of them.
> 
> I can do some "git log linus/master | grep the-commit" , but that does not
> seem to be the most efficient approach, or is it ?

git log linux/master path/to/file/you/care/about.c

will give you just the log of the specific file as you know what one you
are looking for here, right?

> > There's other "tricks" to see if patches have been added to branches by
> > adding them to a branch and then rebasing and seeing the end result, but
> > those get tricky to try to explain in simple emails...
> 
> Some sort of git-cherry-pick and git-rebase ?

Yes, create a branch:
	git checkout -b my_new_branch linux/master
add the patch
	git cherry-pick SHA_to_pick

And then later on after you have updated linux/master:
	git rebase linux/master
and see if anything is still left here or not:
	git log linux/master..HEAD

if the commit is merged, then the log will be empty.

have fun!

greg k-h
