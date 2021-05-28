Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6828394544
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhE1Plo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235849AbhE1Plo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 11:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B99096139A;
        Fri, 28 May 2021 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622216408;
        bh=U+Gs0hl/UM08mQKG5cakZH1dF07RvGFxbOmkAxsF9Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MYqeducB6vtTEfTOufo1g+kOewIBiK5BvOidRnytY5ciwyQJtAPiniH+np3oRTkWa
         c4u+anuqGD/KMukjbGZ9qpAC4/SicOkUDiJcrfzxD+HfEv0+/WowW42LdlJjkh/d6w
         tAlRay+Mc3LUsZWdCayaf1RkbpcN/sH9kht8uKoY=
Date:   Fri, 28 May 2021 17:40:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: btrtl: rename USB fw for RTL8761
Message-ID: <YLEO1UzRoZ6aj8UT@kroah.com>
References: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528152645.25577-1-joakim.tjernlund@infinera.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 05:26:44PM +0200, Joakim Tjernlund wrote:
> From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> 
> According Realteks own BT drivers firmware RTL8761B is for UART
> and RTL8761BU is for USB.
> 
> Change existing 8761B to UART and add an 8761BU entry for USB
> 
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> ---
>  drivers/bluetooth/btrtl.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
> index e7fe5fb22753..ccef8b2cfee2 100644
> --- a/drivers/bluetooth/btrtl.c
> +++ b/drivers/bluetooth/btrtl.c
> @@ -132,12 +132,19 @@ static const struct id_table ic_id_table[] = {
>  	  .cfg_name = "rtl_bt/rtl8761a_config" },
>  
>  	/* 8761B */
> -	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
> +	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_UART),
>  	  .config_needed = false,
>  	  .has_rom_version = true,
>  	  .fw_name  = "rtl_bt/rtl8761b_fw.bin",
>  	  .cfg_name = "rtl_bt/rtl8761b_config" },
>  
> +	/* 8761BU */
> +	{ IC_INFO(RTL_ROM_LMP_8761A, 0xb, 0xa, HCI_USB),
> +	  .config_needed = false,
> +	  .has_rom_version = true,
> +	  .fw_name  = "rtl_bt/rtl8761bu_fw.bin",
> +	  .cfg_name = "rtl_bt/rtl8761bu_config" },
> +
>  	/* 8822C with UART interface */
>  	{ IC_INFO(RTL_ROM_LMP_8822B, 0xc, 0xa, HCI_UART),
>  	  .config_needed = true,
> -- 
> 2.31.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
