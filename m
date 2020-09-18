Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62E126F709
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 09:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgIRHbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 03:31:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57690 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgIRHbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 03:31:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJArg-0003ak-Su; Fri, 18 Sep 2020 17:31:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 17:31:28 +1000
Date:   Fri, 18 Sep 2020 17:31:28 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Message-ID: <20200918073128.GA24168@gondor.apana.org.au>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
 <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 06:35:55PM +0000, Corentin Labbe wrote:
> Ciphers produce invalid results on BE.
> Key and IV need to be written in LE.
> Furthermore, the non-optimized function is too complicated to convert,
> let's simply fallback on BE for the moment.
> 
> Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Does the BE failure get caught by the selftest?

If so please just leave it enabled so that it can be fixed properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
