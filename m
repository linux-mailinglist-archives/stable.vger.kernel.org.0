Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35443607F08
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJUT13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 15:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJUT12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 15:27:28 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CCF26DB12;
        Fri, 21 Oct 2022 12:27:26 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d14so2193352ilf.2;
        Fri, 21 Oct 2022 12:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeAcvnCp34WaD1JZXaevQkrzww3ohn3wI62c5E4HGas=;
        b=UfJVebsKRyGKqbBeSTAKKTQ2KEgG4kyQq/jl9bXXfMSplRLwXj4Cc0i0vv7Giv/RD1
         7yQLO8+UmBBUyn7DM2iFfSQ48U804mkOcWXbWChe5SMvewOr0i2j94bApgTMvT9eZijk
         3DO0HUXGGBMJ4CrQZRc/L6DKYptfmo8m9c/mwIytAj1SRPcUCAT5n6e46dPQuZysAF39
         qeFkDbl87MTzFte1FWwNyF3w/4yviuaKOYpGTw2p32ZDL2jVJMppKcmH4d98qpBvK+ge
         4kr149sqQn0XltGbEFqEAw4lbrfDbD8A90ORcalkNAx4G70BmhgqcNu/Mp9HBtDhPaNm
         0lAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AeAcvnCp34WaD1JZXaevQkrzww3ohn3wI62c5E4HGas=;
        b=o+fvWh8H9QCbzfl4r6zhRBSz4EokoQH1CF3hvrl/la/DOuBbhnl7V92WBaywWbI+8Y
         CHmujTN/hBPsvQ4JOu7uvxjVV7mwuEkuwlFbSEOce74Ep48Hs614tnXDRqTLYr4sNdHI
         +8rnsDxX0EozFXhUBMiEIKiJGZY8ASlGvO8iHqNnH9nJMvVu+A4I0CIHQufdOHagQr10
         /NXLMQGJT/JmbIoG+qQAHlvwBxIxaY6MuJpmKmnd7/Lqqt5NYkfHXugBDJ3+TN1/qpi+
         A1Aa+SX1YVPl76EfBk6/yXcqr0qGdh9XFAYPr9Er5/zVnZNcQLXKvMUEOlyuuq7DFSWK
         jEYw==
X-Gm-Message-State: ACrzQf2RmUhZaxaeloESLk5Jo09psQFrx3GG/jmYW3fA6V7JmClmr1hB
        ECIaFDS290iCuj5A7mKOg8VifVLYDPrVSCXZ
X-Google-Smtp-Source: AMsMyM4ubY9KEWkRqD6y7j/FXM42OTY6d19RFpGsRgIhlqJ37RtKBQL3mfUo7Iy8b6Zn7udTBWW49g==
X-Received: by 2002:a05:6e02:12ec:b0:2fa:9024:b513 with SMTP id l12-20020a056e0212ec00b002fa9024b513mr14236135iln.120.1666380445086;
        Fri, 21 Oct 2022 12:27:25 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id n17-20020a02a191000000b003637fc54f79sm4452631jah.59.2022.10.21.12.27.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Oct 2022 12:27:24 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:27:22 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Jeffrey Vanhoof <jvanhoof@motorola.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dan.scally@ideasonboard.com" <dan.scally@ideasonboard.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "paul.elder@ideasonboard.com" <paul.elder@ideasonboard.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Vacura <W36195@motorola.com>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Message-ID: <20221021192720.GA7112@qjv001-XeonWs>
References: <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
 <20221019230555.gwovdtmnopwacirt@synopsys.com>
 <20221020164732.GA25496@qjv001-XeonWs>
 <20221020224714.6v7djacqvl5xkc2w@synopsys.com>
 <20221021005537.3vbtair35umh6vo2@synopsys.com>
 <20221021093956.GA25599@qjv001-XeonWs>
 <20221021164349.fft4yqnxuztsqdeu@synopsys.com>
 <20221021182841.GA25288@qjv001-XeonWs>
 <20221021190948.onxwtz3lo5c3xbrv@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021190948.onxwtz3lo5c3xbrv@synopsys.com>
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

On Fri, Oct 21, 2022 at 07:09:55PM +0000, Thinh Nguyen wrote:
> On Fri, Oct 21, 2022, Jeff Vanhoof wrote:
> > Hi Thinh,
> > 
> > On Fri, Oct 21, 2022 at 04:43:52PM +0000, Thinh Nguyen wrote:
> > > On Fri, Oct 21, 2022, Jeff Vanhoof wrote:
> > > > Hi Thinh,
> > > > 
> > > > On Fri, Oct 21, 2022 at 12:55:51AM +0000, Thinh Nguyen wrote:
> > > > > On Thu, Oct 20, 2022, Thinh Nguyen wrote:
> > > > > > On Thu, Oct 20, 2022, Jeff Vanhoof wrote:
> > > > > > > Hi Thinh,
> > > > > > > 
> > > > > > > On Wed, Oct 19, 2022 at 11:06:08PM +0000, Thinh Nguyen wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > > > > > > > > Hi Thinh,
> > > > > > > > > On Wed, Oct 19, 2022 at 07:08:27PM +0000, Thinh Nguyen wrote:
> > > > > > > > > > On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > > > > > > > 
> > > > > > > > <snip>
> > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > From what I can gather from the log, with the current changes it seems that
> > > > > > > > > > > after a missed isoc event few requests are staying longer than expected in the
> > > > > > > > > > > started_list (not getting reclaimed) and this is preventing the transmission
> > > > > > > > > > > from stopping/starting again, and opening the door for continuous stream of
> > > > > > > > > > > missed isoc events that cause what appears to the user as a frozen video.
> > > > > > > > > > > 
> > > > > > > > > > > So one thought, if IOC bit is not set every frame, but IMI bit is, when a
> > > > > > > > > > > missed isoc related interrupt occurs it seems likely that more than one trb
> > > > > > > > > > > request will need to be reclaimed, but the current set of changes is not
> > > > > > > > > > > handling this.
> > > > > > > > > > > 
> > > > > > > > > > > In the good transfer case this issue seems to be taken care of since the IOC
> > > > > > > > > > > bit is not set every frame and the reclaimation will loop through every item in
> > > > > > > > > > > the started_list and only stop if there are no additional trbs or if one has
> > > > > > > > > > 
> > > > > > > > > > It should stop at the request that associated with the interrupt event,
> > > > > > > > > > whether it's because of IMI or IOC.
> > > > > > > > > 
> > > > > > > > > In this case I was concerned that if multipled queued reqs did not have IOC bit
> > > > > > > > > set, but there was a missed isoc on one of the last reqs, whether or not we would
> > > > > > > > > reclaim all of the requests up to the missed isoc related req. I'm not sure if
> > > > > > > > > my concern is valid or not.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > There should be no problem. If there's an interrupt event indicating a
> > > > > > > > TRB completion, the driver will give back all the requests up to the
> > > > > > > > request associated with the interrupt event, and the controller will
> > > > > > > > continue processing the remaining TRBs. On the next TRB completion
> > > > > > > > event, the driver will again give back all the requests up to the
> > > > > > > > request associated with that event.
> > > > > > > >
> > > > > > > 
> > > > > > > I was testing with the following patch you suggested:
> > > > > > > 
> > > > > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > > > > index 61fba2b7389b..8352f4b5dd9f 100644
> > > > > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > > > > @@ -3657,6 +3657,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > > > > > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > > > > > >  		return 1;
> > > > > > > >  
> > > > > > > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > > > > > > +	    (event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain)
> > > > > > > > +		return 1;
> > > > > > > > +
> > > > > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > > > > > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > > > > > >  		return 1;
> > > > > > > >
> > > > > > > 
> > > > > > > At this time the IMI bit was set for every frame. With these changes it
> > > > > > > appeared in case of missed isoc that sometimes not all requests would be
> > > > > > > reclaimed (enqueued != dequeued even 100ms after the last interrupt was
> > > > > > > handled). If the 1st req in the started_list was fine (IMI set, but not IOC),
> > > > > > > and a later req was the one actually missed, because of this status check the
> > > > > > > reclaimation could stop early and not clean up to the appropriate req. As
> > > > > > 
> > > > > > Oops. You're right.
> > > > > > 
> > > > > > > suggested yesterday, I also tried only setting the IMI bit when no_interrupt is
> > > > > > > not set, however I was still seeing the complete freezes. After analyzing this
> > > > > > > issue a bit, I have updated the diff to look more like this:
> > > > > > > 
> > > > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > > > index dfaf9ac24c4f..bb800a81815b 100644
> > > > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > > > @@ -1230,8 +1230,9 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
> > > > > > >  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
> > > > > > >  		}
> > > > > > >  
> > > > > > > -		/* always enable Interrupt on Missed ISOC */
> > > > > > > -		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> > > > > > > +		/* enable Interrupt on Missed ISOC */
> > > > > > > +		if ((!no_interrupt && !chain) || must_interrupt)
> > > > > > > +		    trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> > > > > > >  		break;
> > > > > > 
> > > > > > Either all or none of the TRBs of a request is set with IMI, and not
> > > > > > some.
> > > > > > 
> > > > > > >  
> > > > > > >  	case USB_ENDPOINT_XFER_BULK:
> > > > > > > @@ -3195,6 +3196,11 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > > > > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > > > > >  		return 1;
> > > > > > >  
> > > > > > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > > > > > +		(event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain
> > > > > > > +		&& (trb->ctrl & DWC3_TRB_CTRL_ISP_IMI))
> > > > > > > +		return 1;
> > > > > > > +
> > > > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > > > > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > > > > >  		return 1;
> > > > > > > 
> > > > > > > Where the trb must have the IMI set before returning early. This seemed to make
> > > > > > > the freezes recoverable.
> > > > > > 
> > > > > > Can you try this revised change:
> > > > > > 
> > > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > > index 61fba2b7389b..a69d8c28d86b 100644
> > > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > > @@ -3654,7 +3654,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_HWO) && status != -ESHUTDOWN)
> > > > > >  		return 1;
> > > > > >  
> > > > > > -	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > > > 
> > > > > I accidentally deleted a couple of lines here.
> > > > > 
> > > > > > +	if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
> > > > > >  		return 1;
> > > > > >  
> > > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > > > 
> > > > > I meant to do this:
> > > > > 
> > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > index 61fba2b7389b..cb65371572ee 100644
> > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > @@ -3657,6 +3657,9 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > > >  		return 1;
> > > > >  
> > > > > +	if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
> > > > > +		return 1;
> > > > > +
> > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > > >  		return 1;
> > > > > @@ -3673,6 +3676,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> > > > >  	struct scatterlist *s;
> > > > >  	unsigned int num_queued = req->num_queued_sgs;
> > > > >  	unsigned int i;
> > > > > +	bool missed_isoc = false;
> > > > >  	int ret = 0;
> > > > >  
> > > > >  	for_each_sg(sg, s, num_queued, i) {
> > > > > @@ -3681,12 +3685,18 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> > > > >  		req->sg = sg_next(s);
> > > > >  		req->num_queued_sgs--;
> > > > >  
> > > > > +		if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> > > > > +			missed_isoc = true;
> > > > > +
> > > > >  		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
> > > > >  				trb, event, status, true);
> > > > >  		if (ret)
> > > > >  			break;
> > > > >  	}
> > > > >  
> > > > > +	if (missed_isoc)
> > > > > +		ret = 1;
> > > > > +
> > > > >  	return ret;
> > > > >  }
> > > > >  
> > > > > 
> > > > > BR,
> > > > > Thinh
> > > > 
> > > > I tried out the following patch diff you provided and I did not see any iommu
> > > > related crashes with these changes:
> > > > 
> > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > index dfaf9ac24c4f..50287437d6de 100644
> > > > --- a/drivers/usb/dwc3/gadget.c
> > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > @@ -3195,6 +3195,9 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > >         if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > >                 return 1;
> > > >  
> > > > +       if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
> > > > +               return 1;
> > > > +
> > > >         if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > >             (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > >                 return 1;
> > > > @@ -3211,6 +3214,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> > > >         struct scatterlist *s;
> > > >         unsigned int num_queued = req->num_queued_sgs;
> > > >         unsigned int i;
> > > > +       bool missed_isoc = false;
> > > >         int ret = 0;
> > > >  
> > > >         for_each_sg(sg, s, num_queued, i) {
> > > > @@ -3219,12 +3223,18 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> > > >                 req->sg = sg_next(s);
> > > >                 req->num_queued_sgs--;
> > > >  
> > > > +               if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> > > > +                       missed_isoc = true;
> > > > +
> > > >                 ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
> > > >                                 trb, event, status, true);
> > > >                 if (ret)
> > > >                         break;
> > > >         }
> > > >  
> > > > +       if (missed_isoc)
> > > > +               ret = 1;
> > > > +
> > > >         return ret;
> > > >  }
> > > >  
> > > > 
> > > > As we discussed earlier, when uvc's complete function is called, if an -EXDEV
> > > > is returned in the request's status, the uvc driver will begin to cancel its
> > > > queue. With the current skip interrupt implementation in the uvc driver, if
> > > > this occurs while the uvc driver is pumping the current frame, then there is no
> > > > guarentee that the last request(s) will have had 'no_interrupt=0'. If the last
> > > > requests passed to dwc3 had 'no_interrupt=1', these requests would eventually
> > > > be placed at the end of the started_list. Since the IOC bit will not be set,
> > > > and if no missed isoc event occurs on these requests, then the dwc3 driver will
> > > > not be interrupted, leaving those remaining requests sitting in the
> > > > started_list, and dwc3 will not perform an 'End Transfer' as expected. Once the
> > > > uvc driver begins to pump the requests for the next frame, then it most likely
> > > > will result in additional missed isoc events, with the result being an extended
> > > > video freeze seen by the user.
> > > > 
> > > > I hope that other uvc driver maintainers can chime in here to help determine the
> > > > correct path forward. With the skip interrupt implementation, the uvc driver should
> > > > guarentee that the last request sent to dwc3 has 'no_interrupt=0', otherwise
> > > 
> > > Rather than guarenteeing no_interrupt or not, it's more important that
> > > the UVC maintains a constant queue of requests to the controller driver.
> > > Isoc transfers are meant to be sent at a constant rate which the
> > > endpoint is configured.
> > >
> > 
> > I agree with you on this, but it will probably always be a race with uvc
> > queuing up one req at a time and dwc3 starting to transmit almost immediately.
> > We can configure the streaming_interval on a product to kind of slow down or
> 
> No, it doesn't work that way. The controller would only send the data
> when the host requests for it. The host will request for data every
> 125us. So a UVC request will complete roughly every 125us. There should
> be no race with uvc.
>

I wasn't very clear here. I was talking about the UVC Gadget Driver, about how
uvcg_video_pump queues up requests to the dwc3 driver via uvcg_video_ep_queue
(->usb_ep_queue->dwc3_gadget_ep_queue).

> > delay the usb transfers, but between dwc3 and uvc driver it would be nice to
> > have an interface that would allow pre-queuing a certain number of reqs before
> > the transfer is actually started. If that is not possible, then uvc could
> > instead prepare a number of reqs ahead of time and attempt to queue them each
> > as fast a possible in a very tight loop.
> 
> All UVC gadget driver has to do is to maintain multiple requests
> prepared ahead of time and don't starve the controller driver. That is,
> don't let the queue reaches 0. Let's say uvc can only pump 16 requests
> at a time, split at least every 8 request with no_interrupt=0. So that
> uvc will have time to feed more requests when it gets the notification
> of 8 requests completed. It would have roughly 8x125us to queue more
> requests before underrun.
>

I think we are saying the same thing. I'll try to be more clear going forward. :)

> >  
> > > I recalled Dan mentioned that UVC gadget driver can queue up to 64
> > > requests with no_interrupt=1 up to 15 requests. But I keep seeing that
> > > the gadget driver only "pumps" 16 requests and doesn't continue until
> > > they are completed. We can almost guarantee that it's going to be
> > > underrun. Can UVC "pumps" multiple times at once?
> > > 
> > 
> > uvc will usually pump when new frames comes in or when a req's complete gets
> > called. uvc should fill up front all the reqs required to transfer a frame (up
> > to 64), but once the available reqs are filled or the frame completely queued
> > up, it would take a new incoming frame or a kick via the complete call to have
> > it attempt to fill any remaining reqs in the queue again. To me this looks
> > ok to do, but for heavy transfers we have a somewhat smaller queue as a buffer,
> > 48 reqs vs 64 reqs (64 - 16).
> > 
> > To note, for the very last request of a frame/buffer (the end of it) the uvc
> > driver does set the no_interrupt to 0 for this request.
> > 
> > > > if a missed isoc error occurs, it becomes very likely that the next immediate set of
> > > > frames could be dropped/cancelled because the dwc3 driver could not perform a timely
> > > > 'End Transfer'.
> > > > 
> > > > For testing I implemented the following changes to see what I could do for this
> > > > issue. Note that I am on an older implementation and it's missing a lot of the
> > > 
> > > Please use the latest kernel, there are a lot of fixes/improvement to
> > > dwc3 every kernel version.
> > >
> > 
> > I've been debugging the sg implementation and the skip interrupt implementation
> > seperately, backporting what can be backported. I'm working off of a 5.10
> > kernel debugging various issues Dan Vacura was seeing on a 5.15 kernel on a
> > newer product. What we had on our 5.10 based kernel was stable for uvc/dwc3, so
> > we needed to understand what came in since that time that broke stability.
> >  
> > > > sg related implementation. The idea here is that if the queue is empty, and that
> > > > req_int_count is non-zero then the last request likely had 'no_interrupt=1' set.
> > > > And if this is the case then we will want to send some dummy request to dwc3 with
> > > > 'no_interrupt=0' set to make sure that no requests get stuck in its started_list.
> > > 
> > > This is not efficient and unnecessary.
> > >
> > 
> > Agree, but to fix this in the uvc driver the correct way seemed a bit more
> > complicated at first. I was thinking that the driver would always send one last
> > request of the frame buffer once an error is seen, but I'm now thinking of a
> > simpler solution. If we can update the uvc pump to prepare a number of requests
> > and make sure that the last request has no_interrupt set to 0 before queuing
> > them all up in a tight loop to the dwc3 driver, this would effectively solve
> > this problem too. A bit of extra smarts this area might also address some
> > of your concerns about uvc not pumping a lot of data at once (especially for
> > the beginning of a frame). I believe we should prepare more reqs up front
> > if the req queue is empty and less reqs if its already busy.
> > 
> > I'm hoping that someone can step up to help here :). If not, then this will be
> > my next activity.
> >  
> > > <snip>
> > > 
> > > > 
> > > > 
> > > > Alternatively we may just not want to cancel the queue upon receiving -EXDEV
> > > > and this could solve the problem too, but I don't think that it's such a great
> > > > idea, especially if things start falling behind.
> > > > 
> > > > I hope that someone more fluent in this area of code can take a crack at
> > > > improving/fixing this issue. 
> > > > 
> > > > The changes above do seem to help dwc3 timely end its transfers, but mainly for
> > > > cases where some requests are missed but the next immediate ones are not (i'm
> > > > talking within a couple of hundred microseconds). Most of the time if missed
> > > > isocs occurs for a frame that the remaining reqs in the started_list will
> > > > likely also error out and the list will be emptied and dwc3 will still timely
> > > > send 'End Transfer'. In reality this is to cover a corner case that can
> > > > adversely affect the quality of the video being watched. Just wanted to be
> > > > upfront with these details.
> > > > 
> > > > Thinh, any pointers on how we should proceed from here? It looks like your
> > > > changes are working well.
> > > > 
> > > 
> > > You can add the underrun detection check to dwc3 whenever it receives a
> > > new request.
> > > 
> > > ie. When the new request comes, check if the last prepared TRB's HWO bit
> > > is cleared and if the endpoint is started, send End Transfer command to
> > > reschedule the isoc transfers for the incoming requests.
> > > 
> > > This is probably the simpler workaround to the underrun issue of UVC.
> > > 
> > 
> > This sounds like a good optimization too by itself. Would it be possible for
> > you to implement something here to help get me started? Even if it's not
> > perfect, I'll take what I can get. We are running up against the clock for
> > trying to close things out (changes must be released to mainline and backported
> > to 5.15 for Android).
> > 
> 
> At the moment, I have very limited bandwidth to implement and run tests.
> However, if you or someone provide a patch, I can help review.
> 
> It should look something like this (pseudo code):
> 
> ep_queue(request) {
> 	add_pending_list(request)
> 	if (ep is isoc and enabled) {
> 		if (prev_trb.HWO == 0) {
> 			send_cmd(End Transfer)
> 			return;
> 		}
> 	}
> }
> 
> On End Transfer command completion:
> 	reclaim_and_giveback_requests(started_list)
> 
> BR,
> Thinh

Thanks,
Jeff

