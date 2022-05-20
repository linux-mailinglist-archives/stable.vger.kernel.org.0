Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02E252E496
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 07:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345664AbiETF5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 01:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbiETF5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 01:57:32 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3EE13326E;
        Thu, 19 May 2022 22:57:31 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nrvda-00FhyN-PW; Fri, 20 May 2022 15:57:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 May 2022 13:57:23 +0800
Date:   Fri, 20 May 2022 13:57:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - set to zero DH parameters before free
Message-ID: <Yoctw20I9WNHF9Wz@gondor.apana.org.au>
References: <20220509131927.55387-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509131927.55387-1-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 02:19:27PM +0100, Giovanni Cabiddu wrote:
> Set to zero the context buffers containing the DH key before they are
> freed.
> This is a defense in depth measure that avoids keys to be recovered from
> memory in case the system is compromised between the free of the buffer
> and when that area of memory (containing keys) gets overwritten.
> 
> Cc: stable@vger.kernel.org
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thansk.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
