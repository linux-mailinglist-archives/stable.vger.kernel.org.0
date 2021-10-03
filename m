Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D505420205
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 16:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhJCOWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 10:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhJCOWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 10:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D529161B00;
        Sun,  3 Oct 2021 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633270851;
        bh=kDWj9I7Ab7CPaPyLUQejAur68ba7v9Loq1Kzj+92twA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zXYDAtT/N72XpF2UXC8EvInY50KDr9JuuItN3MzCsksmn3m/oBU6M9mIJ+euVnn+K
         dVV98FHjne51jiJz2tC09ARDLBRPgyF/1HLLhnDQ4QKWMwSNiEYyAi/K0jVVJU9Jw8
         ZzWmKMJYt6uUx+xdcZ78h1O+ECvLk2SsAg2AOAoU=
Date:   Sun, 3 Oct 2021 16:20:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ndesaulniers@google.com, arnd@kernel.org, axboe@kernel.dk,
        josef@toxicpanda.com, keescook@chromium.org,
        linux@rasmusvillemoes.dk, naresh.kamboju@linaro.org,
        nathan@kernel.org, pavel@ucw.cz, sfr@canb.auug.org.au,
        torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nbd: use shifts rather than multiplies"
 failed to apply to 5.10-stable tree
Message-ID: <YVm8QSSvOWMwbLZW@kroah.com>
References: <163327073885127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163327073885127@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 03, 2021 at 04:18:58PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oops, nevermind this wasn't intended for 5.10 or 5.4, sorry for the
noise.

greg k-h
