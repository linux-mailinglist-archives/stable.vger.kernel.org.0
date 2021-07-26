Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FF53D5676
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhGZIqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhGZIqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED8DD60E09;
        Mon, 26 Jul 2021 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627291631;
        bh=nsioqyqsx/ERD9+rPigoYqGIGSyJubDcCCXswbiwO8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UqTtybHErkulG66FB4l5zOIYs9V40/vFw1vb+FAS5dVGT7sBZTjn01ZpM8sVqSJ/I
         hIbtX1tBmxjWi8zKK3G+CJ3PjfMahOyjb1EjxGUUK9exB59sMCsRsc5ypdvDEOAya5
         VEFhMc0AyEK763t+r7xZs33OCacL0q0h70oymneg=
Date:   Mon, 26 Jul 2021 11:24:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19] net: dsa: mv88e6xxx: use correct
 .stats_set_histogram() on Topaz
Message-ID: <YP5/aBl19wCg7J+m@kroah.com>
References: <20210722163832.22971-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210722163832.22971-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 06:38:32PM +0200, Marek Behún wrote:
> commit 11527f3c4725640e6c40a2b7654e303f45e82a6c upstream.
> 
> Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
> introduced wrong .stats_set_histogram() method for Topaz family.
> 
> The Peridot method should be used instead.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Both now queued up, thanks.

greg k-h
