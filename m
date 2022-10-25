Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC6B60C2D1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJYEv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJYEvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:51:55 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C11C107CCF;
        Mon, 24 Oct 2022 21:51:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n73so9402793iod.13;
        Mon, 24 Oct 2022 21:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNgL2wjNRdh2GczKnFpFkr5L5ObE69cEXgJ9ULuz+v4=;
        b=RpVpW+FeaRTCQ9qDhK5bYJcDnJZi7uI6sNLs79q0SbqcHP5V6rX0f30SYsg6m44kcd
         xCA3vV/g2Ev5sGiFWaExKSaZ8wWsOiEazQwWHJKkEWcWh74jKUAp0PGQ7inp7Sxh2gJL
         Q/2Hmxf5NOg0AJWub5Wdtv/t+ZwyhVUhWdf3rHnGkvWvDSs8BzT/ya69PTgAALFcj9Qh
         5MTqQVJDvAvDZaw6QH3to0ujDBn0lMjti+5+baSybSnovrbCe+UQgh7zTyN2kEGeyKod
         5DpwtkPtYDjOliOk8zlvmzIIzii0Ux3Qipmm/Zn9lfFgaUaypcoAfC/1p57Oxlz98IOl
         2Nxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZNgL2wjNRdh2GczKnFpFkr5L5ObE69cEXgJ9ULuz+v4=;
        b=gGDEwzdd8Z+/0RQllnedR9PXz/Ew/9xCKuZ6jnJsyq6j2PlaWXra21Oi5IqiYi50PF
         ZmVt4/iLwCqIciJG19uY+EbIK2tVx70O0kxjOkjmhrCFt0ZMZZAOTuirHYTE2X0wbxhu
         hI5b8hl/kCwI3u4H6a7GHDcQPz4NMz/IoqzYFu+mPbP5zNjw03WkOg/o8eTJnq1dAV+J
         bxNPizmrnAB3JhbdZq6nPtSlTKQx4MnU9attOxQAoaiu5IB2FFRU9QtAOEj4Tb4F8p27
         J8Py9C8KEDcn7C9XiFx7/ELKMHKlEyl7e0eLDsq63pNFvwUrZkAdaFY0qmzFo+pAPc7f
         2cJw==
X-Gm-Message-State: ACrzQf3YQsIhL7WB3mzH543CZrUxvrcCtUVksI+jPWakZyhKE1BOuWJy
        5pAjxjZSeNEgMvBJKYtAoO0=
X-Google-Smtp-Source: AMsMyM60a5D5jCGCBz3s6WL62ycVM3Tod51CpUG+vNB3YnvREadb5b3/eglDZ27GhuyO2G/cd3WuDA==
X-Received: by 2002:a05:6638:2710:b0:363:ac95:d86a with SMTP id m16-20020a056638271000b00363ac95d86amr25696472jav.272.1666673513090;
        Mon, 24 Oct 2022 21:51:53 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id s1-20020a92c5c1000000b0030005ae9241sm672125ilt.43.2022.10.24.21.51.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Oct 2022 21:51:52 -0700 (PDT)
Date:   Mon, 24 Oct 2022 23:51:50 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Message-ID: <20221025045148.GA15715@qjv001-XeonWs>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
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

On Mon, Oct 24, 2022 at 06:28:04PM -0700, Thinh Nguyen wrote:
> The gadget driver may have a certain expectation of how the request
> completion flow should be from to its configuration. Make sure the
> controller driver respect that. That is, don't set IMI (Interrupt on
> Missed Isoc) when usb_request->no_interrupt is set.
> 
> Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  Changes in v2:
>  - None
> 
>  drivers/usb/dwc3/gadget.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 230b3c660054..702bdf42ad2f 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
>  		}
>  
> -		/* always enable Interrupt on Missed ISOC */
> -		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> +		if (!req->request.no_interrupt)
> +			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
>  		break;
>  
>  	case USB_ENDPOINT_XFER_BULK:
> -- 
> 2.28.0
>

No new issue seen during testing. Described changes make sense to do.

Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>

Regards,
Jeff

