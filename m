Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1406602F2
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjAFPTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 10:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbjAFPSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 10:18:41 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A468111F;
        Fri,  6 Jan 2023 07:18:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pDoTy-00Ebwp-VF; Fri, 06 Jan 2023 23:18:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Jan 2023 23:18:10 +0800
Date:   Fri, 6 Jan 2023 23:18:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Message-ID: <Y7g7sp6UJJrYKihK@gondor.apana.org.au>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 03:27:39PM +0100, Roberto Sassu wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> The helper mpi_read_raw_from_sgl sets the number of entries in
> the SG list according to nbytes.  However, if the last entry
> in the SG list contains more data than nbytes, then it may overrun
> the buffer because it only allocates enough memory for nbytes.
> 
> Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  lib/mpi/mpicoder.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
