Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5A60DD01
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 10:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiJZIZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 04:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiJZIY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 04:24:58 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDCD8C003;
        Wed, 26 Oct 2022 01:24:57 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n191so2814432iod.13;
        Wed, 26 Oct 2022 01:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buYFuFBeHW1yRmYT990PjExWcZsoxGaJftL7treaLbM=;
        b=QyOdOS5egF/FD0qFXmZuWuKrFNoE3Q7FqTPPTUkIV458/sUYmvW8XjdQak8+Gv1QqI
         Mtws8/gPfKbaEbrW1zjfPzY2+WW63f6Z4uBeIWlGxfpcKOEcY+eP5R7cZIu+Ou5cg8Z7
         sMUXEhKcppD1JfXRLgFYmiq3xbbxgmA00KxDnj45anU6aCKgtwGai4sipc6i+Eoq+EHU
         kFkuKI8nTNNYajkbcumPSehNqSoVSh9g8MFyd4foSYJSpVCTjqsZfHL1rAvKEe+JFV6N
         v+XlcRgHAGvpIa+4ukj1XGXVTP1/nhATFx9IZmUe7ZbtEpSjeHsy7GLTKX0FDUiEhrBe
         olEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buYFuFBeHW1yRmYT990PjExWcZsoxGaJftL7treaLbM=;
        b=ZWrML/63mTZPc8e3dZOle+6MpW7m8xaZM+ujOgIGlTuo2AANNvL5EGC1r5Y85k6NCA
         vRHY89soMOLXzYE0oneLeY4KpJNyVUVzT9VV7MWQLbfp9wATUcRrrKwgl5e3PSqHKN3e
         JjjIp7fijO1V7axToe3Eo3atm3t2MKr87Xtu6+boYEjFAl/oDDNs/XKjKNZFAuqPVv6c
         jZSvh2Jf1+hRqAnu99eCIkEYPl/vLEBO8jKzqLVmBcqe5LALzuMQW2yAgNTANWtJmJb+
         J4IeZONSAhDcsGfVvE0+mN5ZCcyjcn0oMILE3O7CxejiotfG3fTbVsYnZ47hnQIHvT80
         L1EQ==
X-Gm-Message-State: ACrzQf1ji7AvHZXErMLhNRmWRp73Vg7+xlOUwApOoCM4hauJkHRqZbAi
        vW3zriWsLHpldI9HDVojcEo=
X-Google-Smtp-Source: AMsMyM5Tw4bjkFWvB3C5F7PmdoZZuNVzRQR9pYikZI1KCclsUUj6rWu5PG30f0vG0GQS/gYOwsRksg==
X-Received: by 2002:a02:8807:0:b0:363:937f:6 with SMTP id r7-20020a028807000000b00363937f0006mr28430442jai.136.1666772696858;
        Wed, 26 Oct 2022 01:24:56 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id x23-20020a029717000000b0036e605a3e79sm1800087jai.17.2022.10.26.01.24.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Oct 2022 01:24:56 -0700 (PDT)
Date:   Wed, 26 Oct 2022 03:24:54 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v3 1/2] usb: dwc3: gadget: Stop processing more requests
 on IMI
Message-ID: <20221026082451.GA31359@qjv001-XeonWs>
References: <cover.1666735451.git.Thinh.Nguyen@synopsys.com>
 <b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com>
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

On Tue, Oct 25, 2022 at 03:10:14PM -0700, Thinh Nguyen wrote:
> When servicing a transfer completion event, the dwc3 driver will reclaim
> TRBs of started requests up to the request associated with the interrupt
> event. Currently we don't check for interrupt due to missed isoc, and
> the driver may attempt to reclaim TRBs beyond the associated event. This
> causes invalid memory access when the hardware still owns the TRB. If
> there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
> to stop servicing further.
> 
> Note that only the last TRB of chained TRBs has its status updated with
> missed isoc.
> 
> Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> Cc: stable@vger.kernel.org
> Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
> Reported-by: Dan Vacura <w36195@motorola.com>
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  Changes in v3:
>  - None
>  Changes in v2:
>  - No need to check for CHN=0 since only the last TRB has its status
>  updated to missed isoc
> 
> 
>  drivers/usb/dwc3/gadget.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index dd8ecbe61bec..230b3c660054 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -3248,6 +3248,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>  		return 1;
>  
> +	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
> +	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> +		return 1;
> +
>  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
>  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
>  		return 1;
> -- 
> 2.28.0
>

No new issues seen with these changes. Changes look good to me.

Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com> 

Regards,
Jeff
 
