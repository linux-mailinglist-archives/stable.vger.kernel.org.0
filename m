Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B393B1472
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFWHSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWHR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 03:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B106102A;
        Wed, 23 Jun 2021 07:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624432541;
        bh=BgxrxjPzH+TyXUjc4tSXaXwHoacawx7cosXq0U0yMoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r99Z/4CqMTkiIjfqVTfdjBcAoAHcfsO4a5zfflyolehlAVKFunTDG/b2M5MupSO7S
         q4OULcgVLmxBf9kohdICvcJSKRY6xylxBcP/Px0i8gNZgIVipCMdeS9IYb4/OQNwSM
         vFywFUdnyeuVMnEM2Tf57efAJE5U2MeUzUi0d5j8=
Date:   Wed, 23 Jun 2021 09:15:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdns3: Fixed incorrect gadget state
Message-ID: <YNLfm4Xx888Fzsr+@kroah.com>
References: <20210623065426.30638-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623065426.30638-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 08:54:26AM +0200, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> For delayed status phase, the usb_gadget->state was set
> to USB_STATE_ADDRESS and it has never been updated to
> USB_STATE_CONFIGURED.
> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
> As a result of this bug the controller was not able to enter to
> Test Mode while using MSC function.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
