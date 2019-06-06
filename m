Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD49436C9C
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 08:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFFGx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 02:53:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38930 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfFFGx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 02:53:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmHZ-0006xN-RD; Thu, 06 Jun 2019 14:53:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmHZ-0006kr-4v; Thu, 06 Jun 2019 14:53:53 +0800
Date:   Thu, 6 Jun 2019 14:53:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH] crypto: lrw - use correct alignmask
Message-ID: <20190606065353.ur5ljwzceiofbzzs@gondor.apana.org.au>
References: <20190530175308.196938-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530175308.196938-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 10:53:08AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit c778f96bf347 ("crypto: lrw - Optimize tweak computation")
> incorrectly reduced the alignmask of LRW instances from
> '__alignof__(u64) - 1' to '__alignof__(__be32) - 1'.
> 
> However, xor_tweak() and setkey() assume that the data and key,
> respectively, are aligned to 'be128', which has u64 alignment.
> 
> Fix the alignmask to be at least '__alignof__(be128) - 1'.
> 
> Fixes: c778f96bf347 ("crypto: lrw - Optimize tweak computation")
> Cc: <stable@vger.kernel.org> # v4.20+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/lrw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
