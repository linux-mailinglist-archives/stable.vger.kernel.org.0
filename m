Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F333302C0
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhCGPsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhCGPsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:48:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 150226501E;
        Sun,  7 Mar 2021 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615132091;
        bh=5yvD+KY+8EPQZt/w8bdUCmccJ4Sa3wYz47atB6Adspo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEIYmI2pCH6ogHRa1T1M6mUw25P61nFCAc9xjnsiSg7K797IGZFe4JwjQ04DYEW9N
         RUp724ezxmDlyPw9/XTVvVpvKUnLf1avj9GcN0at1i9PbSbaSBmw7hPUPUDNtrK/vn
         4cz6M/cOVBSv58I8nCzVeu5hmDQ6e+TUFUlXVPFY=
Date:   Sun, 7 Mar 2021 16:48:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: stable kernel checksumming fails
Message-ID: <YET1uTT61awy0X6S@kroah.com>
References: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
 <YETm+6sQqek6kY/A@kroah.com>
 <20210307154354.qbbsy355d5zfubnf@chatter.i7.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307154354.qbbsy355d5zfubnf@chatter.i7.local>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 10:43:54AM -0500, Konstantin Ryabitsev wrote:
> On Sun, Mar 07, 2021 at 03:45:15PM +0100, Greg KH wrote:
> > > checksumming the downloaded kernel manually gives an "Okay" though.
> > > 
> > > 
> > > is this just me (on Fedora 33) ?
> > 
> > Fails for me on Arch:
> > 
> > Verifying checksum on linux-5.11.4.tar.xz
> > /usr/bin/sha256sum: /home/gregkh/Downloads/linux-tarball-verify.gZo313NCk.untrusted/sha256sums.txt: no properly formatted SHA256 checksum lines found
> > FAILED to verify the downloaded tarball checksum
> > 
> > 
> > Konstantin, anything change recently?
> 
> I think it's just cache invalidation problems. I've committed a tiny change to
> the script that always grabs that file from the origin servers instead of
> going via the CDN.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/commit/?id=71e570c5f090b5740e323f98504bf38592785b49
> 
> This should sidestep the problem.
> 
> -K

Nice, fixed it for me, thanks!

Ronald, does it now work for you too?

greg k-h
