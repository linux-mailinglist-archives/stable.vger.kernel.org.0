Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E32924A105
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 16:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgHSOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 10:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgHSOCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 10:02:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C732E2076E;
        Wed, 19 Aug 2020 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597845741;
        bh=Eg6ikpBkB7Xas8XZDMecFJ4XVl0wBAxUBwNV1kJRTis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HnvnRs/+N02eZ5ozRch2zMh4kzXnL6a17f09rOwHnmoO9KhTyHDwtYZo68R9JE/Dk
         DJyVbRr0pL5gKxjHPhkD3hO5gFeFFVYwRQRbFIFUl5O7o+n3VoRa045kROgxuiZisv
         YDTtSEBZmc2DxIgPobofpypkz4ZaFkMg4Q1Uo7ng=
Date:   Wed, 19 Aug 2020 16:02:43 +0200
From:   gregkh <gregkh@linuxfoundation.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     =?iso-8859-1?Q?Jo=E3o?= Henrique <johnnyonflame@hotmail.com>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [BACKPORT v5.4 PATCH] pinctrl: ingenic: Properly detect GPIO
 direction when configured for IRQ
Message-ID: <20200819140243.GA3333888@kroah.com>
References: <1597837696152155@kroah.com>
 <20200819134953.25842-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200819134953.25842-1-paul@crapouillou.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 03:49:53PM +0200, Paul Cercueil wrote:
> The PAT1 register contains information about the IRQ type (edge/level)
> for input GPIOs with IRQ enabled, and the direction for non-IRQ GPIOs.
> So it makes sense to read it only if the GPIO has no interrupt
> configured, otherwise input GPIOs configured for level IRQs are
> misdetected as output GPIOs.
> 
> Fixes: ebd6651418b6 ("pinctrl: ingenic: Implement .get_direction for GPIO chips")
> Reported-by: João Henrique <johnnyonflame@hotmail.com>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20200622214548.265417-2-paul@crapouillou.net
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> 
> Notes:
>     Original git commit ID: 84e7a946da71f678affacea301f6d5cb4d9784e8

Now queued up, thanks!

greg k-h
