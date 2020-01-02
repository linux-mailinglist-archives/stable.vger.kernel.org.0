Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497F812E181
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 02:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgABB35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 20:29:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgABB35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 20:29:57 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF79622525;
        Thu,  2 Jan 2020 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577928597;
        bh=ZfVuae8TiuM5Ey3KcURqPf1xRQKQdi9o73S9PkzWj0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XaQT7daQEnoGsVsfCBk2UkRPbHTf4T0d0cF82moSS1qjs6Lj6dQKCME5UtPJibU5v
         KG6++x1gxbxQtUeGoQXvSB0+WOeYzsa8xgGWTv3+CH/QSqOKNGjnbTi1B+vNtTu0Ku
         zd4SII3wXusBurnI38AOrpjjvuQIhS7gwi4E4Gdg=
Date:   Wed, 1 Jan 2020 20:29:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yangbo.lu@nxp.com, ulf.hansson@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-of-esdhc: re-implement erratum
 A-009204 workaround" failed to apply to 5.4-stable tree
Message-ID: <20200102012955.GH16372@sasha-vm>
References: <1577635577211202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577635577211202@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 05:06:17PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From f667216c5c7c967c3e568cdddefb51fe606bfe26 Mon Sep 17 00:00:00 2001
>From: Yangbo Lu <yangbo.lu@nxp.com>
>Date: Thu, 19 Dec 2019 11:23:35 +0800
>Subject: [PATCH] mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround
>
>The erratum A-009204 workaround patch was reverted because of
>incorrect implementation.
>
>8b6dc6b mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add
>        erratum A-009204 support"
>
>This patch is to re-implement the workaround (add a 5 ms delay
>before setting SYSCTL[RSTD] to make sure all the DMA transfers
>are finished).

For 5.4 I took in 22dc132d5448 ("mmc: sdhci-of-esdhc: fix up erratum
A-008171 workaround") to resolve the conflict. I'm not sure if the above
patch is needed on older kernels.

-- 
Thanks,
Sasha
