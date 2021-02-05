Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8B310530
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhBEGvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhBEGvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 01:51:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA49864DD6;
        Fri,  5 Feb 2021 06:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612507865;
        bh=X7GYbSfvvXJg6kAYNUBJ5Pi5+psXsNsp35yY3EsylEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbxaNwxkJqPzCiEqCCJG2SrKkfhzipmdETongyrD/E98ykjf/c0TiuPaqwyW9MB1H
         dJYYCrEhGiYd/dXerkUmX/fSJ8tLo2xaytOuYviJj18G3KEYzNfvfLG7vVtxx+AZD3
         xr22+pW+Dctn465DSn/MEs9s0Zbg25xmrTGnNV2c=
Date:   Fri, 5 Feb 2021 07:51:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
        stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <YBzq1trVOiBfxDVp@kroah.com>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 12:50:43AM +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> In tpm2_del_space() chip->ops is used for flushing the sessions. However
> this function may be called after tpm_chip_unregister() which sets
> the chip->ops pointer to NULL.
> Avoid a possible NULL pointer dereference by checking if chip->ops is still
> valid before accessing it.
> 
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> ---
>  drivers/char/tpm/tpm2-space.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
