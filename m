Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5536343F7EC
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 09:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhJ2HmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 03:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhJ2HmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 03:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42D4F61130;
        Fri, 29 Oct 2021 07:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635493180;
        bh=BNmRC5GOkwqx4Q/ZC/VJG0QRTVmUp7+tuwyuAU64yUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q3+3YhU2P9T7ipwIiAtev3pKl4wwanz9lbtSd1j7kcQ8tv4YtEoOb6sS9wPhNJnuu
         RVuqj8wx3Tzr6wH4Q0kbT60/qboELJxSEMOD2VopW3q9STFzl9g5cq8jIvW/ktlrKZ
         D6Mz897N6M1mA/kw2VjaLYx6rJssRb46v31yccWw=
Date:   Fri, 29 Oct 2021 09:39:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/3] ipv4/ipv6: backport fixes for CVE-2021-20322
Message-ID: <YXulOpILxpS+ljKY@kroah.com>
References: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028190901.1839515-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 28, 2021 at 10:08:58PM +0300, Ovidiu Panait wrote:
> The following commits are needed to fix CVE-2021-20322:
> ipv4:
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e
> 
> ipv6:
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43
> 
> Commit [2] is already present in 4.19 stable, so backport the
> remaining three fixes with minor context adjustments.
> 
> Eric Dumazet (3):
>   ipv4: use siphash instead of Jenkins in fnhe_hashfun()
>   ipv6: use siphash in rt6_exception_hash()
>   ipv6: make exception cache less predictible
> 
>  net/ipv4/route.c | 12 ++++++------
>  net/ipv6/route.c | 25 ++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 13 deletions(-)
> 
> -- 
> 2.25.1
> 

You sent 0/3 but only 2 patches showed up?

Can you please resend all 3?

thanks,

greg k-h
