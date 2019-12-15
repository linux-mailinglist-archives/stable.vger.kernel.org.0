Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E083211FAA7
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 20:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfLOTF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 14:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOTF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 14:05:56 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC313206D8;
        Sun, 15 Dec 2019 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576436756;
        bh=/g5i5BqbdNr4y/kxFB2hRDSicqfnqyEo/tkY+k+4Eok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vLM1GTAorvxYXKUEKwoazgn/xAc4rXSNVywQw0ANYlnPPmv68m1MopX9eTVURQL1w
         uAd7QYB2YDToO6/pPsS0dz4Bk/hxMhJFZAvbjbjjgMdb27t2ydayfymkqDmL48kofl
         yFYkqnmaaEDibUtoluYoMmohEV98EfVH6+4a25B8=
Date:   Sun, 15 Dec 2019 14:05:54 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jarkko.nikula@bitmer.com, stable@vger.kernel.org, tony@atomide.com
Subject: Re: FAILED: patch "[PATCH] ARM: dts: omap3-tao3530: Fix incorrect
 MMC card detection" failed to apply to 4.9-stable tree
Message-ID: <20191215190554.GR18043@sasha-vm>
References: <157641681111754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157641681111754@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 02:33:31PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 287897f9aaa2ad1c923d9875914f57c4dc9159c8 Mon Sep 17 00:00:00 2001
>From: Jarkko Nikula <jarkko.nikula@bitmer.com>
>Date: Sat, 16 Nov 2019 17:16:51 +0200
>Subject: [PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection
> GPIO polarity
>
>The MMC card detection GPIO polarity is active low on TAO3530, like in many
>other similar boards. Now the card is not detected and it is unable to
>mount rootfs from an SD card.
>
>Fix this by using the correct polarity.
>
>This incorrect polarity was defined already in the commit 30d95c6d7092
>("ARM: dts: omap3: Add Technexion TAO3530 SOM omap3-tao3530.dtsi") in v3.18
>kernel and later changed to use defined GPIO constants in v4.4 kernel by
>the commit 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags
>cell for OMAP2+ boards").
>
>While the latter commit did not introduce the issue I'm marking it with
>Fixes tag due the v4.4 kernels still being maintained.
>
>Fixes: 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards")
>Cc: linux-stable <stable@vger.kernel.org> # 4.4+
>Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
>Signed-off-by: Tony Lindgren <tony@atomide.com>

Fixed up context and queued for 4.9 and 4.4.

-- 
Thanks,
Sasha
