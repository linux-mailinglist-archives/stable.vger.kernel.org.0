Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9F52A642D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 13:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgKDMXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 07:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKDMXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 07:23:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C69D208C7;
        Wed,  4 Nov 2020 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604492597;
        bh=hDPqY7XLLLOPO0Wde2kcgM45xBoWvrmzTAojMIOX+qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOJngM9WoospdRMi8w8wYwiQpUzr/fLB6Rf3R1nBrsWNbq52R/nl6vZMZf9Flchpv
         4CzNmqwuZM1oly7V/OnO2fAhfCOvAaH687C+6wm441VlnU6PkutLZ26kzr13WHshXx
         Bba4ZKq6mARLSzJOjX5TJDQjxLkEYE1ERd1HQkHM=
Date:   Wed, 4 Nov 2020 13:24:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 0/3] null_blk fixes for 5.9 stable
Message-ID: <20201104122408.GA2183258@kroah.com>
References: <20201104095141.GA1673068@kroah.com>
 <20201104112747.182740-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104112747.182740-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 08:27:44PM +0900, Damien Le Moal wrote:
> Greg,
> 
> Here are three backported patches from this cycle for 5.9 stable. The
> upstream patches are:
> 1) 35bc10b2eafbb701064b94f283b77c54d3304842
> 2) f9c9104288da543cd64f186f9e2fba389f415630
> 3) aa1c09cb65e2ed17cb8e652bc7ec84e0af1229eb
> 
> Thanks.
> 
> Damien Le Moal (2):
>   null_blk: Fix zone reset all tracing
>   null_blk: Fix locking in zoned mode
> 
> Kanchan Joshi (1):
>   null_blk: synchronization fix for zoned device
> 
>  drivers/block/null_blk.h       |   1 +
>  drivers/block/null_blk_zoned.c | 157 ++++++++++++++++++++++++---------
>  2 files changed, 118 insertions(+), 40 deletions(-)

All now queued up, thanks.

greg k-h
