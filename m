Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D0F3C9D48
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhGOKxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhGOKxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9700B61380;
        Thu, 15 Jul 2021 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626346260;
        bh=lHam7mL5PaYt/BeVx4rCpbjwMpjMQuN0o82Uzudx2GI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KCwvaVSrlqHlthHI8ejqRlTshmwN1Mhywr6bbsoVB2jwjHezasssoffSztH9n3p2k
         G1zMOACeULXxc+xiKNcpv2upqyHfoHYYC7G8pQXNHBCaKDfM5+nBDzrneTE9Xll+dx
         ticudQIgKj2bCvXg8ekpy7qLttOX90aR9dF6INrs=
Date:   Thu, 15 Jul 2021 12:50:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     stable@vger.kernel.org, herbert@gondor.apana.org.au,
        thomas.lendacky@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH stable-5.4] crypto: ccp - Annotate SEV Firmware file names
Message-ID: <YPATDUsDzIb1iote@kroah.com>
References: <1626005849185115@kroah.com>
 <20210712121250.23392-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712121250.23392-1-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 02:12:50PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> [ Upstream commit c8671c7dc7d51125ab9f651697866bf4a9132277 ]
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
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/ccp/psp-dev.c | 4 ++++
>  1 file changed, 4 insertions(+)

Now applied, thanks!

greg k-h
