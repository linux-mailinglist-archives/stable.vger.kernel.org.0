Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05C456A4B
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 07:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhKSGhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 01:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 01:37:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A6461101;
        Fri, 19 Nov 2021 06:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637303650;
        bh=NOGQh8//ImED3ZSXNLHFe1B3kwT9YtEODJhVob7C6yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4m9B/6ruVNnPZ9qqEZT4IXH0vD+W+HobXTFi6lCquqNHPT4QPbtj/0/A0RCXEgDe
         SIJW1spW0ZD1KpiPRJZ+Ou4GvZJO1+GZY9D2CwpjlSZcEwM/MB+M5ctM8OmvqEb+Ph
         iVgJNkayooFHFKKFA3hJikAog/V7cLiF07zXXphs=
Date:   Fri, 19 Nov 2021 07:34:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chris Rankin <rankincj@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [OOPS] Linux 5.14.19 crashes and burns!
Message-ID: <YZdFYFpTswGqO/o1@kroah.com>
References: <CAK2bqV+NuRYNU0dHni9Cmfvi5CZ7Ycp6rGrNRDLzrdU9xkSXaw@mail.gmail.com>
 <99d07599-3d72-d389-cfc2-f463230037a5@leemhuis.info>
 <ed000478-2a60-0066-c337-a04bffc112b1@leemhuis.info>
 <YZYc6uSpp76Sz4vO@kroah.com>
 <YZZdUxGbKJKz0x8i@kroah.com>
 <CAK2bqVJyi-g0b=dSDPS5ELb1d8joKark4k4+6AGQdtuM81k2kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2bqVJyi-g0b=dSDPS5ELb1d8joKark4k4+6AGQdtuM81k2kg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 11:02:30PM +0000, Chris Rankin wrote:
> Hi,
> 
> Yes, 5.14.20 fixes the boot problem in 5.14.19. Thank you. However,
> this WARNING is still present, as with every other 5.14.x kernel I
> have been able to test:
> 
> [   95.796055] ------------[ cut here ]------------
> [   95.819648] WARNING: CPU: 3 PID: 1 at
> drivers/gpu/drm/ttm/ttm_bo.c:409 ttm_bo_release+0x1c/0x266 [ttm]

Does this work with 5.15.3?

I would suggest asking the graphics developers about this, as this is
their code :)

thanks,

greg k-h
