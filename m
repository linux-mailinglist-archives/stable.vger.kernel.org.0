Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9DC397933
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhFARio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234597AbhFARim (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 13:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9314B61378;
        Tue,  1 Jun 2021 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622569021;
        bh=NJJqhKDfnCfI2THUK3CEqsihvmYvWDONjwaD68QLLC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ucspr8RJAbcEW5CEamuCrxG49lCLTFvxlWoii/gvqXRzw1b+yIJ8BnYjguf8dEqbr
         oBbpfqyTz0UVv0Jyly+YjpQ6ymDpS+BPycgS54fIIn7c3fhzWeP+T9BTyVBMjvC5ix
         3qHU6y9kobaUDTRaboGGvVHvSXA6mVB39rWSIvvYGWSpG/eh03Iz+Lb7ily3EAw8ZT
         xCVa/qwWUEs8gLVGEvoRlN1PlI5ZE9CHPdcD0kTJkJBLb3Lq1HPDefinsaPGIqWEjE
         veUuttzTLQ5PT7r5vB2OH2IU7XuUqTgsK5W4E/RDbl25MpImSmFzeg7wnbZbf1lFaj
         hAQOCQhwyDmAg==
Date:   Tue, 1 Jun 2021 20:36:57 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
Message-ID: <20210601173657.4bgqj2ndvryzrbzo@kernel.org>
References: <20210531045131.110616-1-jarkko@kernel.org>
 <bbd2c61c-edd7-f830-aafe-2881ba7d2614@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbd2c61c-edd7-f830-aafe-2881ba7d2614@molgen.mpg.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 07:33:44AM +0200, Paul Menzel wrote:
> Dear Jarkko,
> 
> 
> Am 31.05.21 um 06:51 schrieb Jarkko Sakkinen:
> > Do not torn down the system when getting invalid status from a TPM chip.
> 
> Nit: Do not *tear* down …?

Oops, a typo, thank you.

> > This can happen when panic-on-warn is used.
> 
> Hmm, I’d say it works as expected then? Shouldn’t an invalid status of an
> important device like TPM considered a warning?

By warning do you mean WARN() or pr_warn()?

/Jarkko
