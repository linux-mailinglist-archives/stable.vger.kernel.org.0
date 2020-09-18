Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB626F888
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgIRIk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 04:40:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57838 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgIRIk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 04:40:56 -0400
X-Greylist: delayed 4302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 04:40:53 EDT
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJBSF-0004Ir-TJ; Fri, 18 Sep 2020 18:09:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 18:09:15 +1000
Date:   Fri, 18 Sep 2020 18:09:15 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Message-ID: <20200918080915.GA24549@gondor.apana.org.au>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
 <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
 <20200918073128.GA24168@gondor.apana.org.au>
 <20200918080658.GA22656@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918080658.GA22656@Red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 10:06:58AM +0200, LABBE Corentin wrote:
>
> But I think only me will see it and since I already have this on my TODO list, I dont see any interest to leave it failing.
> Furthermore, having a clean BE boot will permit to enable BE boots for thoses SoCs on kernelCI.

I'll happily accept patches that fix the actual bug but not ones
just papering over it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
