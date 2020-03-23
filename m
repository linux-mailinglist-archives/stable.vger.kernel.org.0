Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBAB18F987
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgCWQUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 12:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgCWQUD (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 23 Mar 2020 12:20:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF462051A;
        Mon, 23 Mar 2020 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584980403;
        bh=hMsmiW2U7Jx3qdijBJcvnRvlL8wQbCgSKHa9RB4sS9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f2MFYvycrPMtGcm5yiJUduM1M0ZBlhHmoPcSWXDPXBqKmjx1iPJQakHZ//v5p2t2l
         4XhUcw2Eb4ta9fl6TZT/z0osvBWc4y+eypXhk5F9yZjD3Nkeern17zQznoJRhh7SZ0
         lQHMj3ki4Z1xDaH/XDGHJPnuzsMcaAVzFT4vEvFA=
Date:   Mon, 23 Mar 2020 12:20:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     eugen.hristev@microchip.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: at91-sama5d2_adc: fix
 differential channels in" failed to apply to 4.14-stable tree
Message-ID: <20200323162001.GU4189@sasha-vm>
References: <1584973066113204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1584973066113204@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 03:17:46PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From a500f3bd787f8224341e44b238f318c407b10897 Mon Sep 17 00:00:00 2001
>From: Eugen Hristev <eugen.hristev@microchip.com>
>Date: Tue, 28 Jan 2020 12:57:39 +0000
>Subject: [PATCH] iio: adc: at91-sama5d2_adc: fix differential channels in
> triggered mode
>
>The differential channels require writing the channel offset register (COR).
>Otherwise they do not work in differential mode.
>The configuration of COR is missing in triggered mode.
>
>Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
>Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

This patch depended on f0c8d1f6dc8e ("iio: adc: at91-sama5d2_adc: fix
channel configuration for differential channels") which is itself a
stable tagged commit, so I took it too.

Both depended on 073c662017f2 ("iio: adc: at91-sama5d2_adc: add support
for DMA"). I've fixed them up to remove the DMA bits and queued for
4.14.

-- 
Thanks,
Sasha
