Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FF2380880
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhENLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:35:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37196 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENLf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 07:35:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lhW5X-0002tI-CJ; Fri, 14 May 2021 19:34:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lhW5V-0002XN-1I; Fri, 14 May 2021 19:34:37 +0800
Date:   Fri, 14 May 2021 19:34:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4] crypto: ccp: Annotate SEV Firmware file names
Message-ID: <20210514113436.z63mxcalsdqyhzok@gondor.apana.org.au>
References: <20210426081748.25419-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426081748.25419-1-joro@8bytes.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 10:17:48AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Annotate the firmware files CCP might need using MODULE_FIRMWARE().
> This will get them included into an initrd when CCP is also included
> there. Otherwise the CCP module will not find its firmware when loaded
> before the root-fs is mounted.
> This can cause problems when the pre-loaded SEV firmware is too old to
> support current SEV and SEV-ES virtualization features.
> 
> Fixes: e93720606efd ("crypto: ccp - Allow SEV firmware to be chosen based on Family and Model")
> Cc: stable@vger.kernel.org # v4.20+
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/crypto/ccp/sev-dev.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
