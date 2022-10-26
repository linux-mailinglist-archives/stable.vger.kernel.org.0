Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8D60DCFA
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 10:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiJZIXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJZIXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 04:23:20 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E146DAD98F;
        Wed, 26 Oct 2022 01:23:19 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o65so12716401iof.4;
        Wed, 26 Oct 2022 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzNbyPPcVQ06yeev+VZPvgsRDRgElT41X2KwodmxJR4=;
        b=PoJV92gpl81fTgOUudPQk0EUr1a0ofVT2vzNwJlkp/6G2D+hHAoQ/IXnyl9U5hiMPA
         kjPz2O6l6LH4eDDHbt1d/bvHqeKyQskFTQHgSAyh5D4lyklX8EZiyvktjqxdjb13myOz
         SPu3neg6BU+YURqTY9GplmiEN9v4+gg2qRKXZ7dGO9PXfwusEoMPpDz0EbOZg734G/Q2
         cNYZZsZP+Me6EF/ggAKG0SDzZMJZaMbHko18Rse2xquoLOF2EL0vqdJ/0ul79/eDKwbV
         VgjWMVP7L7p2NiwWSH4fxYyfsJtXb/MCTazHMvrA95fEovYKVTC3vlNNx5JES8tYYdB+
         +YDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LzNbyPPcVQ06yeev+VZPvgsRDRgElT41X2KwodmxJR4=;
        b=Mr33r0cggbkeVlOHdZI6Tm2eT8VXULj6IvlLgaCbkIHST5dDAyQGlply1ziMIamXzb
         CfIGSUL/htDswOzRNWSihqTcBm8e9scgmK2/O59SKDhiECpxINV6PzDllI4AldsIHj2r
         kA68Zx3k7TK+fu/kpjaeHXOSTKXrDY2FTH8hEj9iddIM9UJb1xQuVi6k2ev+ryhELXrV
         5lBwwMlA3jYzM57/yZlEPTDozUl7b554dtg6pCz1943Yp+4lOt+/hLBUYdl1b8iGqz2N
         DJhWrqRhxf9Ga0Z0bpcr52xt5o98s9PPQYb7Qe4FQIKzShGJh6576r8zfhBNqfCw/4+A
         tMcg==
X-Gm-Message-State: ACrzQf3wbGcN1KdBKoDkmGhHdOn0coU4qqIvh2W5WD8GN9mtduDF5Ev0
        eBtPP4JbpRyOUW0Jv5KEmjk=
X-Google-Smtp-Source: AMsMyM5bzxieIuKeFLoXM9dEIl7vNxo8FVdaCRKsASfkw11S8mYZepZugF36bcb+VyuVuymGFmSH2Q==
X-Received: by 2002:a6b:ba07:0:b0:6bd:1f64:2df3 with SMTP id k7-20020a6bba07000000b006bd1f642df3mr16529711iof.57.1666772599044;
        Wed, 26 Oct 2022 01:23:19 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id s13-20020a02b14d000000b00373dfe1ea7fsm1754424jah.114.2022.10.26.01.23.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Oct 2022 01:23:18 -0700 (PDT)
Date:   Wed, 26 Oct 2022 03:23:16 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Message-ID: <20221026082314.GA25910@qjv001-XeonWs>
References: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
 <ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 03:10:20PM -0700, Thinh Nguyen wrote:
> The gadget driver may have a certain expectation of how the request
> completion flow should be from to its configuration. Make sure the
> controller driver respect that. That is, don't set IMI (Interrupt on
> Missed Isoc) when usb_request->no_interrupt is set. Also, the driver
> should only set IMI to the last TRB of a chain.
> 
> Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  Changes in v3:
>  - Set IMI to only the last TRB of a chain
>  Changes in v2:
>  - None
> 
>  drivers/usb/dwc3/gadget.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 230b3c660054..5fe2d136dff5 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
>  		}
>  
> -		/* always enable Interrupt on Missed ISOC */
> -		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> +		if (!no_interrupt && !chain)
> +			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
>  		break;
>  
>  	case USB_ENDPOINT_XFER_BULK:
> -- 
> 2.28.0
>

No new issues seen with these changes. Changes look good to me.

Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com> 

Regards,
Jeff

