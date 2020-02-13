Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81715BB8B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 10:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgBMJWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 04:22:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42404 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgBMJWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 04:22:37 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2AhQ-00048Q-8n; Thu, 13 Feb 2020 17:22:20 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2AhM-0006pA-UD; Thu, 13 Feb 2020 17:22:16 +0800
Date:   Thu, 13 Feb 2020 17:22:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree - dec auth tag size from cryptlen map
Message-ID: <20200213092216.jcbhelawxd6dgzat@gondor.apana.org.au>
References: <20200202161914.9551-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200202161914.9551-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 02, 2020 at 06:19:14PM +0200, Gilad Ben-Yossef wrote:
> Remove the auth tag size from cryptlen before mapping the destination
> in out-of-place AEAD decryption thus resolving a crash with
> extended testmgr tests.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: stable@vger.kernel.org # v4.19+
> ---
>  drivers/crypto/ccree/cc_buffer_mgr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
