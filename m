Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552413A1D54
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFIS7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhFIS7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3C7661364;
        Wed,  9 Jun 2021 18:57:37 +0000 (UTC)
Date:   Wed, 9 Jun 2021 20:57:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v3] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
Message-ID: <YMEPHy2rnMvAnWt6@kroah.com>
References: <20210609132619.45017-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609132619.45017-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 04:26:19PM +0300, Jarkko Sakkinen wrote:
> Do not tear down the system when getting invalid status from a TPM chip.
> This can happen when panic-on-warn is used.
> 
> Instead, introduce TPM_TIS_INVALID_STATUS bitflag and use it to trigger
> once the error reporting per chip. In addition, print out the value of
> TPM_STS for improved forensics.
> 
> Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
> Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
> Cc: stable@vger.kernel.org
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
