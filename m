Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDAF3D0F61
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbhGUMlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 08:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232494AbhGUMlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 08:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3265061241;
        Wed, 21 Jul 2021 13:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626873719;
        bh=gNFceyOne/t+iza4smxFjp2g49d5EgQN9HSlDf37VI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSiUX3+YUXnZdaa7j97Bb+/ug7HGjJhPFkzm7KXvJ6ICL7s9by89jmxqvTYuFd1MZ
         SShXpo4QPO3DMAAf0loGMk0p1D6ZolShSNUKYLhsZla9Ztoax+885rIuI9Mo84LxfY
         uaqcMAHf/CeaeAntF5Rf1GhGV/WNFTjQaykq7Qda7C9B9lj0J72EBZEEvnchy7hHhd
         p9IxjlKtMFq37u3xZFnjYFpN7/6G+sXJurxLRNiK6MC2AvB3qFqBG+XhTTiRWBXla3
         EJ1gND1QGlYdwtmS34wYMRgbMSY6PdKEiYVUqCA6axj5HOzChDgrz/2sMe2fUCtwTA
         XjXxe3BNtxMsg==
Received: by pali.im (Postfix)
        id 8AF4779B; Wed, 21 Jul 2021 15:21:56 +0200 (CEST)
Date:   Wed, 21 Jul 2021 15:21:56 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Backporting armada-3700-rwtm-firmware DTS changes to stable
 kernel
Message-ID: <20210721132156.qsgodbs53glltijh@pali>
References: <20210720222559.k4zoqr2rk62pj7ky@pali>
 <YPdWVTB0tWvsgKR3@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YPdWVTB0tWvsgKR3@sashalap>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 20 July 2021 19:03:49 Sasha Levin wrote:
> On Wed, Jul 21, 2021 at 12:25:59AM +0200, Pali Rohár wrote:
> > Hello Greg & Sasha, I would like to ask you for your opinion about
> > backporting DTS patches to stable kernel which allows usage of hwrng on
> > Marvell Armada 3700 devices.
> > 
> > Driver is already part of 5.4 kernel, just DTS bindings are not there.
> > I do not know if such backport is suitable for stable kernels. In file
> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > is written that "New device IDs and quirks are also accepted" where
> > "device id" could mean also small DTS change...
> 
> We could, that's how I've been parsing that rule.
> 
> > What do you think? Question is about these 3 small commits:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90ae47215de3fec862aeb1a0f0e28bb505ab1351
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d2f6d0c99f7f95600e633c7dc727745faaf95e
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a52a48973b355b3aac5add92ef50650ae37c2bd
> 
> If it was actually tested on 5.4, I could queue it up for the next
> release cycle.

Hello Sasha! Now I tested these patches on top of stable 5.4 and hwrng
is working fine.
