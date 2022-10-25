Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EF360C2BF
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJYEp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJYEpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:45:55 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B8F57566;
        Mon, 24 Oct 2022 21:45:52 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id n73so9396943iod.13;
        Mon, 24 Oct 2022 21:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLtHempB4jrBtCU0+LcnDz6mCrviXokD1rcmrihbunk=;
        b=Zf3ScGf6y4EbHXmisbN8ycWBRYlnuQaNqVgLYRNdfd4utRAg4tXqB+aLwutOhVOZuT
         zLLAt6FnfP2AVLVr6MpmGo4ZUgDEyuObwtUDH6QnNIPcoHhAhcVCiZiJDJEqvFZptdfl
         RjxIwt1HlqqEArC7j3ptOplQcWCkWJKnrp1bmgySLgwYN8PIz6s1QIVq/DM9yrD/RI0A
         bX5WWXjd/Yh3+alwmti9oGi3oDoyVrogbsv9M1tyebT+MNXGvxZClVBRv8Cq2PTvx4pY
         qhCI1vfNFwZL4K60gCrFJKllE0NKupJ2+9hRS8qjOi8jj34946hxDDUybD+NOJw4AbRn
         LTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLtHempB4jrBtCU0+LcnDz6mCrviXokD1rcmrihbunk=;
        b=5JRDaHIj9hKv0BkRI3PtgZZrhomVrd+DlhbrcrZxj5JMqUZdM9IYNOy7A7Pcoza+cU
         FI2ebYatMQuL92rQ14CfglG1iOAF9zTP0NgKP6WFn0nVcu786r3ZDusrE5nk5dx6Vc+i
         DEAN26lqoIcNF/vYbOE7EhFAeDLYEUkpOh6aJfDtySMnnVd6C9jVI8pSRyk8gv23xLeh
         3tkH9KjARu47fIPFci4OGTPtoA/INKOlOEVzRRTP5oRQ7Ed5haiWCxHqvf2bXKHNHG0R
         iXoMtXAu3sc+z8h5ZC3qQHpDQztFnVnTR9MTDPNNouAX4RsO5Dd08jlXz1Lrpsebvs09
         hmkQ==
X-Gm-Message-State: ACrzQf279MhwWP7MOYOSDvi6oBClBZYDvPUVHJlEX3ULltwqS0FY2mS+
        zU49sEqfGJKg6CiM1dVDkmJ17UtGbH/AslSk
X-Google-Smtp-Source: AMsMyM5TVYMzWWgUA9pJP6fUVjDmOr7APib2RCIr07TPFjlGY/SEkD2aWOgplh4FFOwrmEaJYPknBg==
X-Received: by 2002:a5d:9859:0:b0:6bb:4dff:8a8b with SMTP id p25-20020a5d9859000000b006bb4dff8a8bmr21317233ios.159.1666673151385;
        Mon, 24 Oct 2022 21:45:51 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id d7-20020a026207000000b0037508cc0bc2sm181588jac.12.2022.10.24.21.45.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Oct 2022 21:45:51 -0700 (PDT)
Date:   Mon, 24 Oct 2022 23:45:48 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Stop processing more requests
 on IMI
Message-ID: <20221025044545.GA12741@qjv001-XeonWs>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <699a342b618611be834b06d9d64abae7d01486cd.1666661013.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699a342b618611be834b06d9d64abae7d01486cd.1666661013.git.Thinh.Nguyen@synopsys.com>
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

On Mon, Oct 24, 2022 at 06:27:57PM -0700, Thinh Nguyen wrote:
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
>  Changes in v2:
>  - No need to check for CHN=0 since only the last TRB has its status
>    updated to missed isoc
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

Testing shows that the changes appear to work to prevent the arm-smmu panic I
was seeing after missed isoc errors. Also, changes to reclaim trbs only up to
the associated interrupt event make sense.

Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>

Regards,
Jeff
 
