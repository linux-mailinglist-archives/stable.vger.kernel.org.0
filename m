Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573271D0C57
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEMJeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgEMJeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:34:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D880B206B8;
        Wed, 13 May 2020 09:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589362477;
        bh=krWUtZS3+ln09cHUNehaWdJiKkVlr6kYDi9iq3SUN9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fw5ryV7L7c3Z6WWgtoMufJsApa016DP9F76r6zb5Qsyv6tZmuaFpmTAX87sc4CQeL
         5mmUw/mVzv1Si9ptI+8mn3sG4fX+yh5R9VfIrWggjjJWQwhul8Dc0FP/KdfMTp2hLo
         +NGv3AYfjiAaDgfpM+U7A4fu1QxCIPVrR/OiX05c=
Date:   Wed, 13 May 2020 11:34:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4.4 02/16] gpiolib: Fix references to
 gpiod_[gs]et_*value_cansleep() variants
Message-ID: <20200513093435.GA830571@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-3-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:00PM +0100, Lee Jones wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Commit 372e722ea4dd4ca1 ("gpiolib: use descriptors internally") renamed
> the functions to use a "gpiod" prefix, and commit 79a9becda8940deb
> ("gpiolib: export descriptor-based GPIO interface") introduced the "raw"
> variants, but both changes forgot to update the comments.
> 
> Readd a similar reference to gpiod_set_value(), which was accidentally
> removed by commit 1e77fc82110ac36f ("gpio: Add missing open drain/source
> handling to gpiod_set_value_cansleep()").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20190701142738.25219-1-geert+renesas@glider.be
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/gpio/gpiolib.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

What is the upstream git commit id for this patch?  Please add it and
resend.

thanks,

greg k-h
