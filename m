Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DA55BE118
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 11:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiITJBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 05:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiITJAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 05:00:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD6F6C10A;
        Tue, 20 Sep 2022 02:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D149EB8264D;
        Tue, 20 Sep 2022 09:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F8C433D7;
        Tue, 20 Sep 2022 09:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663664433;
        bh=Lt+A+WTpxhk3dZD3hAMkDrayEMrJWIiZOAr0Aio6a0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DpwsQxZqbgO4GYvR+BqSYobYpKO3aFmd005W1jSW7IBmZM9ckiW4lVRCoNAB/SaK6
         WAHSA8bQYYeHYBkKo9op18iDFDnfqJ6cJYy8ZJdr8/qtN4puWF0Q1dGxIwVTib7FzS
         XFSNvLkqjUCSyhhYHzFJMKBzqH/35cdskFD3t9+QNsLvt0tsEegB42bCQgAUuo/+AF
         yT3MtflV8gON3XEK19FZbWRKYv/+WU57McAxG5Ofz0fgdJdTmnP5J1OBIQ0f0WJJDz
         XXHY5AfqWbAtrMS8D9qSCdapFmiLVuuyUSabeQwg6bUqNAOq28WBvuaO79XvdqCJOk
         +iesX/kSVgkGg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oaZ7L-0002J7-7i; Tue, 20 Sep 2022 11:00:35 +0200
Date:   Tue, 20 Sep 2022 11:00:35 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Message-ID: <YymBM1wJLAsBDU4E@hovoldconsulting.com>
References: <20220822151027.27026-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822151027.27026-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mauro and Hans,

On Mon, Aug 22, 2022 at 05:10:27PM +0200, Johan Hovold wrote:
> Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
> type") tried to add an endpoint type sanity check for the single
> isochronous endpoint but instead broke the driver by checking the wrong
> descriptor or random data beyond the last endpoint descriptor.
> 
> Make sure to check the right endpoint descriptor.
> 
> Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: stable@vger.kernel.org	# 5.9
> Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> It's been two months and two completely ignored reminders so resending.
> 
> Can someone please pick this fix up and let me know when that has been
> done?

It's been another month so sending yet another reminder. This driver as
been broken since 5.9 and I posted this fix almost four months ago and
have sent multiple reminders since.

Can someone please pick this one and the follow-up cleanups up?

Johan
 
>  drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
> index 7835bb0f32fc..e012b21c4fd7 100644
> --- a/drivers/media/usb/b2c2/flexcop-usb.c
> +++ b/drivers/media/usb/b2c2/flexcop-usb.c
> @@ -511,7 +511,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
>  
>  	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
>  		return -ENODEV;
> -	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[1].desc))
> +	if (!usb_endpoint_is_isoc_in(&fc_usb->uintf->cur_altsetting->endpoint[0].desc))
>  		return -ENODEV;
>  
>  	switch (fc_usb->udev->speed) {
