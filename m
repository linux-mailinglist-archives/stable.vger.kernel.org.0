Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1CB60D1BD
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiJYQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiJYQml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 12:42:41 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CC78D0CA;
        Tue, 25 Oct 2022 09:42:40 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id l6so7129396ilq.3;
        Tue, 25 Oct 2022 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O6g1hbnky80FJhPyDLOX43YfKw7yq7aiql7vKH0EPA=;
        b=iLZthTml+mTipRWyi63LkuBSYGchrDIA+6JMWDaMlpHktctYcXffBEJmn7gkYrKEuk
         GhmW7LvgZWiKvv6wBhA+n2LgaurCTfPni8h3hP2sOrTRVK21yGyWxDi3jHjk+XChixs1
         A+HumJAau6TyilEXLxehbNgF6D8YjtSKibjLcmybZ5ucI3uE1IFjW8qu+sqaLBWpnpIp
         ulxSzJWOFKY573XJq0Vm4ClvKAqqZ9OSg7pFo2An1wVfatVLx3HWjgWB5hjzEKx2V569
         E71kFSQo4Yf98hfXO3Y9Chce1J4zajwU/ZQkIlvnHyMao64hMO09/2uaZ+9R/teNkuUr
         U+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3O6g1hbnky80FJhPyDLOX43YfKw7yq7aiql7vKH0EPA=;
        b=T7s/l26jvZ21SckhJX0e62EeTXg3P0CJYj4SCOyj11tBfDWC9EG9IG7nqPA+0WeECf
         bb4WFQvU90Udf42pEI6x9JJuOIWw9junrp/w/NTdCKh4oU/Emp1I+4Ci5lnZWDUvMADg
         tGKchSe8OIqxhiYDWOOUX9B7yZGBLyyyIctPpFgX+e1dfYZfGE+RKETBC2r4d7oLMz0Y
         bgQKP+3MmE7QFt7Jfb1QucpR6+O+VUcK/LDxY1qflJqah1pGqzDxD3w1w/TU/VlWRM9O
         EjJz+73qsmL5eZf2pMESKs4XUwpAglRnh8+6cH/SJ9JWHdGVLg/LTlTWC8/+ZOUaDa+/
         gn7Q==
X-Gm-Message-State: ACrzQf0ctXUIGgaoGKHmr1NjVhaS1Qy1UGJ2PLyAEDUENWH0iB+MMemE
        9EvK93LHdnnKE+M7r9h93M0o66u0VWmC5iEp
X-Google-Smtp-Source: AMsMyM5esWVAasNJo+fQ1Eb/glpHoyJEakGYl7+hP3ToWQ7XU0ICTBgRcbsO6KbyYg9wRtqNtICzHw==
X-Received: by 2002:a05:6e02:17cf:b0:2fa:3986:a518 with SMTP id z15-20020a056e0217cf00b002fa3986a518mr25127920ilu.65.1666716159895;
        Tue, 25 Oct 2022 09:42:39 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id y19-20020a056602165300b006bbfb3856d6sm1314001iow.5.2022.10.25.09.42.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Oct 2022 09:42:39 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:42:37 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Stop processing more requests
 on IMI
Message-ID: <20221025164235.GA5795@qjv001-XeonWs>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <699a342b618611be834b06d9d64abae7d01486cd.1666661013.git.Thinh.Nguyen@synopsys.com>
 <20221025044545.GA12741@qjv001-XeonWs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025044545.GA12741@qjv001-XeonWs>
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

Hi Thinh,

On Mon, Oct 24, 2022 at 11:45:48PM -0500, Jeff Vanhoof wrote:
> On Mon, Oct 24, 2022 at 06:27:57PM -0700, Thinh Nguyen wrote:
> > When servicing a transfer completion event, the dwc3 driver will reclaim
> > TRBs of started requests up to the request associated with the interrupt
> > event. Currently we don't check for interrupt due to missed isoc, and
> > the driver may attempt to reclaim TRBs beyond the associated event. This
> > causes invalid memory access when the hardware still owns the TRB. If
> > there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
> > to stop servicing further.
> > 
> > Note that only the last TRB of chained TRBs has its status updated with
> > missed isoc.
> > 
> > Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> > Cc: stable@vger.kernel.org
> > Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
> > Reported-by: Dan Vacura <w36195@motorola.com>
> > Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> > ---
> >  Changes in v2:
> >  - No need to check for CHN=0 since only the last TRB has its status
> >    updated to missed isoc
> > 
> >  drivers/usb/dwc3/gadget.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index dd8ecbe61bec..230b3c660054 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -3248,6 +3248,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> >  		return 1;
> >  
> > +	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
> > +	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> > +		return 1;
> > +
> >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> >  		return 1;
> > -- 
> > 2.28.0
> >
> 
> Testing shows that the changes appear to work to prevent the arm-smmu panic I
> was seeing after missed isoc errors. Also, changes to reclaim trbs only up to
> the associated interrupt event make sense.
> 
> Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
> Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
> 
> Regards,
> Jeff
> 

I just followed up with Dan and he mentioned that he was still seeing the arm-smmu panic on his baseline. I will work with him this afternoon to better understand what may be going on there. Let's hold off on merging these changes in until we figure out what is going on. He and I are testing off of different baselines (5.10 vs 5.15), different USB speeds (USB 3 vs 2), and are using different hardware, so I don't know yet why we are seeing a difference here.

Regards,
Jeff

