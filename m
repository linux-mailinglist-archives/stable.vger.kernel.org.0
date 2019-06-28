Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2E359284
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 06:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF1EUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 00:20:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55988 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfF1EUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 00:20:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hgiMf-0004xZ-I0; Fri, 28 Jun 2019 12:19:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hgiMd-00026c-WE; Fri, 28 Jun 2019 12:19:56 +0800
Date:   Fri, 28 Jun 2019 12:19:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Haren Myneni <haren@linux.vnet.ibm.com>
Cc:     mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] crypto/NX: Set receive window credits to max number
 of CRBs in RxFIFO
Message-ID: <20190628041955.bwh6anp63xiwxoyu@gondor.apana.org.au>
References: <1560884962.22818.9.camel@hbabu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560884962.22818.9.camel@hbabu-laptop>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 12:09:22PM -0700, Haren Myneni wrote:
>     
> System gets checkstop if RxFIFO overruns with more requests than the
> maximum possible number of CRBs in FIFO at the same time. The max number
> of requests per window is controlled by window credits. So find max
> CRBs from FIFO size and set it to receive window credits.
> 
> Fixes: b0d6c9bab5e4 ("crypto/nx: Add P9 NX support for 842 compression engine")
> CC: stable@vger.kernel.org # v4.14+   
> Signed-off-by:Haren Myneni <haren@us.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
