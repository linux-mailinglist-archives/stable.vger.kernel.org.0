Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3730D701
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 11:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhBCKFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 05:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233206AbhBCKFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 05:05:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F4E64DD4;
        Wed,  3 Feb 2021 10:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612346691;
        bh=GMks07XDc1EABU1swgRkzaBoy8O3QwOGMCI1HAeaW6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZh68RYuA1QRn3d97csC1hJJ5UadVEoA9qRWIqc55aTdHZDoJnMLw+imIABlPSUIF
         HlZN2WnrY8JI4/tWR6NHMqM9+Jb9Fv7ubJKm+iCyzL4u9Tuy4l+2H9lxWbKicWjK03
         yOqVt8zP1pVCj9xBJE66QOtKO/Xn7++7prL1c850=
Date:   Wed, 3 Feb 2021 11:04:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi
 THUNK macro argument"
Message-ID: <YBp1QM3HFjV4kTwM@kroah.com>
References: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
 <YBlONpmGoM0/qG7R@kroah.com>
 <CA+icZUXeK4_5A8YzkuQUcP9jhZKvYrCtWbcgToV-FDE+VY=BvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXeK4_5A8YzkuQUcP9jhZKvYrCtWbcgToV-FDE+VY=BvQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 10:21:56AM +0100, Sedat Dilek wrote:
> On Tue, Feb 2, 2021 at 2:06 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Feb 01, 2021 at 08:50:52PM +0100, Sedat Dilek wrote:
> > > Hi,
> > >
> > > you have in Linux 5.10.13-rc1:
> > >
> > > "x86/entry: Emit a symbol for register restoring thunk"
> > >
> > > While that discussion Boris and Peter recommended to remove unused code via:
> > >
> > > "x86/entry: Remove put_ret_addr_in_rdi THUNK macro argument"
> > > ( upstream commit 0bab9cb2d980d7c075cffb9216155f7835237f98 )
> > >
> > > OK, this has no CC:stable but I have both as a series in my local Git
> > > and both were git-pulled from [1].
> > > What do you think?
> >
> > What bug is this fixing that requires this in 5.10?
> >
> 
> Commit 0bab9cb2d980d7c075cffb9216155f7835237f98 removed unused logic.
> 
> So-to-say:
> Fixes: 320100a5ffe5 ("x86/entry: Remove the TRACE_IRQS cruft")
> 
> The commit was first introduced with Linux v5.8-rc1:
> 
> $ git describe --contains 320100a5ffe5
> v5.8-rc1~21^2~28
> 
> As Linux v5.10.y is an LTS IMHO I hoped it is worth removing unused code.
> You better know the rules for stable-linux, so I leave it to you, Greg.

The rules are listed here:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

So please let me know what this patch fixes based on that and I will be
glad to merge it.

thanks,

greg k-h
