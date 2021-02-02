Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0D30CE71
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhBBWGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhBBWGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D1F64E49;
        Tue,  2 Feb 2021 22:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612303556;
        bh=Am2h83SX/xua8J9WpGAt8r9U556UepXuAT1XcD30xn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCQksDIa70vQlA+WxZxbQrV7z3EBOaepd3rD1ZynxYjY+BKQngeDEW5RQu9t0HLJW
         b0rBdBNibI6gncCh2M2+e7Tavtz6qHVilPmN4C+LQiwcA/okegcW5EToCvqrF6jPSl
         2IaKcvfienZfC780XYLoi9/YdT3HMHdCWXDMa1Z7zmlHN90a8MJL3TiO3wavdxyD7L
         /TGaHMV0/tOscEwsuamjh0Pk44VmTdEPyExV3XBuVTKJZVP1HX+RW6kYMvvFFWqCD9
         hrHWUJsQSB2BNZTg/Y2165NPX/eYEg+bzHN2UqcJzmY01piKgXHqpv9qb1jYQqMO3q
         bW06U1R4ldy1g==
Date:   Wed, 3 Feb 2021 00:05:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Message-ID: <YBnMvTF9ebCPtL1A@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
 <f2c8ada9-cd62-c078-0371-fb2ae449f53f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2c8ada9-cd62-c078-0371-fb2ae449f53f@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 07:43:04AM -0800, Guenter Roeck wrote:
> On 2/2/21 7:33 AM, jarkko@kernel.org wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > An unexpected status from TPM chip is not irrecovable failure of the
> > kernel. It's only undesirable situation. Thus, change the WARN_ONCE
> > instance inside tpm_tis_status() to pr_warn_once().
> > 
> > In addition: print the status in the log message because it is actually
> > useful information lacking from the existing log message.
> > 
> > Suggested-by:  Guenter Roeck <linux@roeck-us.net>
> > Cc: stable@vger.kernel.org
> > Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in tpm_ibmvtpm_probe()")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks.

/Jarkko
