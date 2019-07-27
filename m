Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4C77BF0
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfG0U6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 16:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388150AbfG0U6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jul 2019 16:58:33 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1912147A;
        Sat, 27 Jul 2019 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564261112;
        bh=3jvANDc9LliVkm8hGLHYQZv+x16Th48I4QDkZbmlC6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=II9jiPzdrI+X4JBvEQZPZzwwbe8udv2GD1DPtQdcgt3uAUH42j6Ns4TjtF4+j3A52
         t2RreywU7Fkp19ReS5PSHVd/GnVN6TX0e+/SXsiKLnJRCKVqM4iGw9cEuOTzxTxrVR
         UFYXnJK9yLozZQRP4wclydPjJBiHLgaAeZ3Dvc+4=
Date:   Sat, 27 Jul 2019 21:58:26 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Marek Vasut <marek.vasut@gmail.com>,
        stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rob Herring <robh@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] iio: adc: gyroadc: fix uninitialized return code
Message-ID: <20190727215826.70212910@archlinux>
In-Reply-To: <20190718140227.GA3813@kunai>
References: <20190718135758.2672152-1-arnd@arndb.de>
        <20190718140227.GA3813@kunai>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Jul 2019 16:02:27 +0200
Wolfram Sang <wsa@the-dreams.de> wrote:

> On Thu, Jul 18, 2019 at 03:57:49PM +0200, Arnd Bergmann wrote:
> > gcc-9 complains about a blatant uninitialized variable use that
> > all earlier compiler versions missed:
> > 
> > drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > Return -EINVAL instead here and a few lines above it where
> > we accidentally return 0 on failure.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> 
> Yes, I checked the other error paths, too, and they look proper to me.
> 
> Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 

Thanks for sorting that second case as well.

Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

