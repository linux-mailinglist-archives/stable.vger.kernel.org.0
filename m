Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0A445A11
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhKDS6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231732AbhKDS6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59EF561215;
        Thu,  4 Nov 2021 18:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636052165;
        bh=CcDMReQXBY3D/nKDnf1Gc91MmTMIn3J5IBQD97PZPzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=amP8fBa9HottuhbRVmEwBLag+7kGsNCthpyhTTI/jOqFsGfRb5x7ZR+JmHsp7MMy8
         xKU2bQl1UwWXZ4ZXMwObWalRohsHzgWeZoHRXdIilxH3hNFe/hwMjsrSBcgFVxycN3
         41kRii+pptD1oVa0p5rm5ehMu70H1aLg8qtcbJPU=
Date:   Thu, 4 Nov 2021 19:56:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Fan <yfa@google.com>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        pmladek@suse.com, sashal@kernel.org
Subject: Re: null console related kerne performance issue
Message-ID: <YYQsw+GBLr1WXidM@kroah.com>
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> Resend the email using plain text.
> 
> I found some kernel performance regression issues that might be
> related w/ 4.14.y LTS commit.
> 
> 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> 
> The issue is observed when "console=" is used as a kernel parameter to
> disable the kernel console.

What exact "performance issue" are you seeing?

And what kernel version are you seeing it on?

> I browsed android common kernel logs and the upstream stable kernel
> tree, found some related changes.
> 
> printk: handle blank console arguments passed in. (link:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0)
> Revert "init/console: Use ttynull as a fallback when there is no
> console" (link:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=a91bd6223ecd46addc71ee6fcd432206d39365d2)
> 
> It looks like upstream also noticed the regression introduced by the
> commit, and the workaround is to use "ttynull" to handle "console="
> case. But the "ttynull" was reverted due to some other reasons
> mentioned in the commit message.
> 
> Any insight or recommendation will be appreciated.

What problem exactly are you now seeing?  And does it also happen on
5.15?

thanks,

greg k-h
