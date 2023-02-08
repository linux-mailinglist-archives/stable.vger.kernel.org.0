Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C5E68F189
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 16:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjBHPDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 10:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBHPDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 10:03:07 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6529531E2F;
        Wed,  8 Feb 2023 07:03:06 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 425323200645;
        Wed,  8 Feb 2023 10:03:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 08 Feb 2023 10:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675868584; x=1675954984; bh=Tp4WrLE6w4
        CxHre1AULQK7ewiIbrA5XQqc0WYdu9Gfs=; b=nIY1/+FnvifwoKLHY0jMM8XETK
        jDNsI+G8FylzoPlNFzLDoyOaYIi7+Gx9rEHmpaIhGRQxJuDCXCxV4PLMa+R6rM/H
        KLiAA0t2HI5zlyKNso8SSTflCSXHQYF/EkdYS0H93UK+qGmhvYAiaIoydws1Bccj
        QnILyqIeu7I7bSs8VcIcmWIOndB+pA4Ht5/M/8/pjHz/ENBiLCL/2NchrnmpfQ8N
        ceVvPOufyE+7MKCp2mEPoZ4Nn4PvX5aB2XewHq6vJiY4FH81kN12ys1/wHVTwUcJ
        uSHoo0hz3i3bvKfM5bh15lxmwQ+Gxi0BEXCeya07pxzOUX6l82D7OIJpodfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675868584; x=1675954984; bh=Tp4WrLE6w4CxHre1AULQK7ewiIbr
        A5XQqc0WYdu9Gfs=; b=WBzUiBlFO08QKb3DU4+mujE1e0WUADxEiJCnwDfKA3ZW
        9MreeJIXpFSiCfDVdAuw8JB/BnxCxPDoA/AsKJQGUtlmr6yg9pLwGQrZ0c1iZNcI
        ESWF7APe8gGY9zo/CdjuB8cfkAiVG2KLCcYCQi6RNmfm/2C4FDshbWqj2T6jH2wf
        IZyNiE9hp+7MaPTwgfCbR+UlQ6RxIaxjQAFrwYBiMkXn/8t37rS8YCfVzHto+peH
        TEi2hi66I+3o0pIlwtmEgSyl/lZEvYe+B6skJBNhMBISHcU5YGqNfTQ5NRVOyaJR
        SCPIgjjRCsnxuw9guGvzijW/KFrp0fIoMa2zLkCkww==
X-ME-Sender: <xms:p7njYx5LUSTrkCaSTstnrapp5huACPHfCzG82-3ZBdkScAEN9p0DNw>
    <xme:p7njY-4LuAsvkTYQa2ktixnXqEbl0alsLNB9D6d7Zj7Of7BUymBq8Y-wEy_gp8-wT
    KU7wNR-ESvgXA>
X-ME-Received: <xmr:p7njY4dA3bLB5h0QbQ2poGkk_D7uaZVMmhsdGCExyZIeqLErEgqaj8v0XlkobdfM8MrupxZ5bmUNsx5DT8UsemknMO6IpDWjj05__g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:qLnjY6IvhcNPsk0cNJnkuWIpByfr30hp2we6wM5hErv4Yg9yyDrbhA>
    <xmx:qLnjY1KYHIrH6KqOviIA_yj39ka7DPR4Nrk16HK0bmXqLTdq-0R5NQ>
    <xmx:qLnjYzwjhYe77B0TRAYec9mX5MFc_w0Yu7szbr6TvrzpjnjCZlUugQ>
    <xmx:qLnjY89YiTlvoCsdHn_6_h8uC1ESyS5BC7sS_OXQvb17otHGD14ZJQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 10:03:03 -0500 (EST)
Date:   Wed, 8 Feb 2023 16:03:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Mark Pearson <mpearson-lenovo@squebb.ca>
Cc:     linux-usb@vger.kernel.org, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: add quirk for Alcor Link AK9563 smartcard
 reader
Message-ID: <Y+O5pLXHW/0goHMy@kroah.com>
References: <mpearson-lenovo@squebb.ca>
 <20230208144648.1079898-1-mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208144648.1079898-1-mpearson-lenovo@squebb.ca>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 08, 2023 at 09:46:48AM -0500, Mark Pearson wrote:
> The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
> doesn't work. If LPM is enabled the reader will provide an invalid
> usb config descriptor. Added quirk to disable LPM.
> 
> Verified fix on Lenovo P16 G1 and T14 G3
> 
> Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
> Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>

No blank lines needed between tested-by and cc: stable.

> ---
>  drivers/usb/core/quirks.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 079e183cf3bf..9b1c56646ac5 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -535,6 +535,9 @@ static const struct usb_device_id usb_quirk_list[] = {
>  	/* INTEL VALUE SSD */
>  	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> +	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
> +	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },

Please follow the instructions in the comment right above this structure
definition for where to put the entry in the list.

thanks,

greg k-h
