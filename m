Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF19E4FED
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440595AbfJYPSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:18:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35694 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439061AbfJYPSy (ORCPT <rfc822;stable@vger.kernel.orG>);
        Fri, 25 Oct 2019 11:18:54 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1MN-0001dK-0d; Fri, 25 Oct 2019 23:18:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1MC-0007iE-KM; Fri, 25 Oct 2019 23:18:28 +0800
Date:   Fri, 25 Oct 2019 23:18:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-crypto@vger.kernel.org, dsaxena@plexity.net, mpm@selenic.com,
        romain.perier@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, daniel.thompson@linaro.org,
        ralph.siemsen@linaro.org, milan.stevanovic@se.com,
        ryan.harkin@linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Fix RNG wait loop timeout
Message-ID: <20191025151828.l4gdnuw3ud5gkfw2@gondor.apana.org.au>
References: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:32:45PM +0530, Sumit Garg wrote:
> Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
> data rate which takes approx. 700us to produce 16 bytes of output data
> as per testing results. So configure the timeout as 1000us to also take
> account of lack of udelay()'s reliability.
> 
> Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/char/hw_random/omap-rng.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
