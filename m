Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363996C8CF
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 07:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfGRFls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 01:41:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57798 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfGRFls (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 01:41:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hnzAk-0007AX-DF; Thu, 18 Jul 2019 13:41:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hnzAg-0005eJ-UB; Thu, 18 Jul 2019 13:41:38 +0800
Date:   Thu, 18 Jul 2019 13:41:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Cfir Cohen <cfir@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp/gcm - use const time tag comparison.
Message-ID: <20190718054138.nzz24mi6mawlrpa4@gondor.apana.org.au>
References: <20190702173256.50485-1-cfir@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702173256.50485-1-cfir@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:32:56AM -0700, Cfir Cohen wrote:
> Avoid leaking GCM tag through timing side channel.
> 
> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
