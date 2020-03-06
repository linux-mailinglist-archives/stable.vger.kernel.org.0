Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CCC17B406
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 02:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCFBwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 20:52:18 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46164 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgCFBwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 20:52:18 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA29p-0005uw-Cd; Fri, 06 Mar 2020 12:52:10 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:52:09 +1100
Date:   Fri, 6 Mar 2020 12:52:09 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Botila <andrei.botila@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - update xts sector size for large input
 length
Message-ID: <20200306015209.GL30653@gondor.apana.org.au>
References: <20200228104648.18898-1-andrei.botila@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228104648.18898-1-andrei.botila@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 12:46:48PM +0200, Andrei Botila wrote:
> From: Andrei Botila <andrei.botila@nxp.com>
> 
> Since in the software implementation of XTS-AES there is
> no notion of sector every input length is processed the same way.
> CAAM implementation has the notion of sector which causes different
> results between the software implementation and the one in CAAM
> for input lengths bigger than 512 bytes.
> Increase sector size to maximum value on 16 bits.
> 
> Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
> ---
> This patch needs to be applied from v4.12+ because dm-crypt has added support
> for 4K sector size at that version. The commit was
> 8f0009a225171 ("dm-crypt: optionally support larger encryption sector size").
> 
>  drivers/crypto/caam/caamalg_desc.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
