Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB5120B318
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgFZOES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 10:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728091AbgFZOES (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 10:04:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16BF207E8;
        Fri, 26 Jun 2020 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593180257;
        bh=70xo0z/Zm4ksUxEnYOtjWol+3xqzHwZC+wHTJG+vE/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m6Wc6tBoY57e8LJ0WMKBNGreOVVAzxiNHezdVND/cFV/KMV+Ne1u1EyUG64nNB+Kd
         odqyfX7jpxI4s+E5Yf4eiH3l9y4l0QYaMUOtsV+mK7KwxpTBUEm7XJ9JT/0eOP4w09
         7mrgkrnFjwuO5ITTpyMG0uCE1Jef4MjhVgDAWD1o=
Date:   Fri, 26 Jun 2020 16:04:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [6/17/2020]
Message-ID: <20200626140413.GA4098272@kroah.com>
References: <20200617235308.132274-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617235308.132274-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 04:53:08PM -0700, Guenter Roeck wrote:
> Upstream commit 64611a15ca9d ("dm crypt: avoid truncating the logical block size")
>   upstream: v5.8-rc1
>     Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
>       in linux-4.4.y: b8cd70b724f0
>       in linux-4.9.y: 5dbde467ccd6
>       in linux-4.14.y: 0c7a7d8e62bd
>       in linux-4.19.y: a7f79052d1af
>       in linux-5.4.y: 6eed26e35cfd
>       upstream: v5.5-rc7
>     Affected branches:
>       linux-4.4.y (conflicts - backport needed)
>       linux-4.9.y (conflicts - backport needed)
>       linux-4.14.y
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
>       linux-5.7.y

Can you provide a backport for this?

> Upstream commit 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
>   upstream: v5.8-rc1
>     Fixes: b469e7e47c8a ("fanotify: fix handling of events on child sub-directory")
>       in linux-4.9.y: 987d8ff3a2d8
>       in linux-4.14.y: 515160e3c4f2
>       in linux-4.19.y: 20663629f6ae
>       upstream: v4.20-rc3
>     Affected branches:
>       linux-4.9.y (conflicts - backport needed)
>       linux-4.14.y (conflicts - backport needed)
>       linux-4.19.y
>       linux-5.4.y (already applied)
>       linux-5.6.y (already applied)
>       linux-5.7.y (already applied)

Do you have a backport?

For all other patches you listed, I've queued up the missing ones, some
already got merged since you sent this out.

thanks,

greg k-h
