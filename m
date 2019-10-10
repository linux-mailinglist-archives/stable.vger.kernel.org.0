Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE1D22C3
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbfJJI2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfJJI2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:28:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614C22196E;
        Thu, 10 Oct 2019 08:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696089;
        bh=v6x9hYKXzHtTOXwGSjqSfQkeGOgIPJcA2WPsi3ZTt0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjBy2pkNARCq2i29cBpWjpkAPLIaaml+eMrPwAMzYbztrPUttSf4jeyaIYGz8xI8s
         ieRTP69U+zlH9HB4FRYpUCIPDoKHTfY3sM5abBRW7UKRAeh10TpbkB+7Wk2Mij1C5h
         ZU1pt1XIw6gcX+dYtEjL1eOHj47/lU/gQ+sPsiiU=
Date:   Thu, 10 Oct 2019 10:28:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        "open list:TPM DEVICE DRIVER" <linux-integrity@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent
 future TPM operations
Message-ID: <20191010082807.GC326087@kroah.com>
References: <20191009212831.29081-1-jarkko.sakkinen@linux.intel.com>
 <20191009212831.29081-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009212831.29081-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 12:28:31AM +0300, Jarkko Sakkinen wrote:
> From: Vadim Sukhomlinov <sukhomlinov@google.com>
> 
> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
> 
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.
> 
> Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> [dianders: resolved merge conflicts with mainline]
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-chip.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

This is already in the 4.14.148 4.19.78 5.1.18 5.2.1 5.3 releases.

thansk,

greg k-h
