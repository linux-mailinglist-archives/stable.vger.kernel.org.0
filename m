Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C602360744A
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 11:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiJUJkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 05:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJUJkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 05:40:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC623107AA3;
        Fri, 21 Oct 2022 02:40:01 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 187so1813673iov.10;
        Fri, 21 Oct 2022 02:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0AMdP5nyQsjEWucivjL2LhjJxgKcg/ZwGryVIjU/oE=;
        b=q14uyPyPwhGICUlwWqMJtTYsjaP1fPFnfrMnD/B+9XfD0itet3wfo60/jkLbcEYIxW
         a85xMB7EKClxg0kQR6EJHyq3Ygb5fe71QmRjlwGLOcNAy6C01viFSJSSEk37pgHmGmBk
         U5Eed/8nSXscyNRToKVkIYLU98Vvq3nMv417BrPd3kTD32F4SX+jMEwnVr0zKaD39gzG
         mQrHd8h4j3HwNEFUFajCwMtz4ljL8w7RmOLfjI35bZlNQMfj/DzItoJdf1T3VPKmWkbu
         vaREHzO0ZKFHMzrEtuyOatCxTcQXMaB36ZdyJANnECErLEeYYn28c0nqxk75+qauDrES
         JyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0AMdP5nyQsjEWucivjL2LhjJxgKcg/ZwGryVIjU/oE=;
        b=U4woSb5fAwKzWqc6AzJ+jmOhluPUpcaVktiGVKOCtu26p1hTyrsfugXW/0Q1xxvfsQ
         O3d7NjxGrB1s+ml1QVVVweo4zlLNkWBNwEhMGU042sdlOBsGgWY4xINvQfOc6TtBXbRZ
         xIcyF60/bBQ/UkPvGtHoVwuolspcu+b4zqEDhn9AWptrDCdNl6bxhspFLH6PK6GJcL7r
         1XkNAqsDZP5RcY+R3S5T1UTCI9LBwNo3DpoB82DXzhm5g4hyPonjWi7ePQq903+pmLWM
         MxYPyv5AxQHuK6E6g/IBUpWJxWNS38h+F++wTBXEKOpiAJyFaXuVgpk6Hie3PeaA1kM5
         dIKA==
X-Gm-Message-State: ACrzQf1WxmOOM4Fe90wAjDUQgRNwWsd2RBC9fGhRCUbcNjeWFlE4s6O8
        /4DlJon+KUtV/RZhGPupUhw=
X-Google-Smtp-Source: AMsMyM4VIJWgJ76jCpMpjLP3L9mL8MNan29z/oc8kwHFhsFu+xdUDAMlwpPo12qtWB6Kdj6BEyuOpg==
X-Received: by 2002:a02:62cc:0:b0:363:d7ea:f3d with SMTP id d195-20020a0262cc000000b00363d7ea0f3dmr13550619jac.120.1666345201021;
        Fri, 21 Oct 2022 02:40:01 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id 9-20020a920d09000000b002f90ff8bcbbsm3934717iln.37.2022.10.21.02.39.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Oct 2022 02:40:00 -0700 (PDT)
Date:   Fri, 21 Oct 2022 04:39:58 -0500
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
Message-ID: <20221021093956.GA25599@qjv001-XeonWs>
References: <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
 <20221019230555.gwovdtmnopwacirt@synopsys.com>
 <20221020164732.GA25496@qjv001-XeonWs>
 <20221020224714.6v7djacqvl5xkc2w@synopsys.com>
 <20221021005537.3vbtair35umh6vo2@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021005537.3vbtair35umh6vo2@synopsys.com>
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

On Fri, Oct 21, 2022 at 12:55:51AM +0000, Thinh Nguyen wrote:
> On Thu, Oct 20, 2022, Thinh Nguyen wrote:
> > On Thu, Oct 20, 2022, Jeff Vanhoof wrote:
> > > Hi Thinh,
> > > 
> > > On Wed, Oct 19, 2022 at 11:06:08PM +0000, Thinh Nguyen wrote:
> > > > Hi,
> > > > 
> > > > On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > > > > Hi Thinh,
> > > > > On Wed, Oct 19, 2022 at 07:08:27PM +0000, Thinh Nguyen wrote:
> > > > > > On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > > > 
> > > > <snip>
> > > > 
> > > > > > > 
> > > > > > > From what I can gather from the log, with the current changes it seems that
> > > > > > > after a missed isoc event few requests are staying longer than expected in the
> > > > > > > started_list (not getting reclaimed) and this is preventing the transmission
> > > > > > > from stopping/starting again, and opening the door for continuous stream of
> > > > > > > missed isoc events that cause what appears to the user as a frozen video.
> > > > > > > 
> > > > > > > So one thought, if IOC bit is not set every frame, but IMI bit is, when a
> > > > > > > missed isoc related interrupt occurs it seems likely that more than one trb
> > > > > > > request will need to be reclaimed, but the current set of changes is not
> > > > > > > handling this.
> > > > > > > 
> > > > > > > In the good transfer case this issue seems to be taken care of since the IOC
> > > > > > > bit is not set every frame and the reclaimation will loop through every item in
> > > > > > > the started_list and only stop if there are no additional trbs or if one has
> > > > > > 
> > > > > > It should stop at the request that associated with the interrupt event,
> > > > > > whether it's because of IMI or IOC.
> > > > > 
> > > > > In this case I was concerned that if multipled queued reqs did not have IOC bit
> > > > > set, but there was a missed isoc on one of the last reqs, whether or not we would
> > > > > reclaim all of the requests up to the missed isoc related req. I'm not sure if
> > > > > my concern is valid or not.
> > > > > 
> > > > 
> > > > There should be no problem. If there's an interrupt event indicating a
> > > > TRB completion, the driver will give back all the requests up to the
> > > > request associated with the interrupt event, and the controller will
> > > > continue processing the remaining TRBs. On the next TRB completion
> > > > event, the driver will again give back all the requests up to the
> > > > request associated with that event.
> > > >
> > > 
> > > I was testing with the following patch you suggested:
> > > 
> > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > index 61fba2b7389b..8352f4b5dd9f 100644
> > > > --- a/drivers/usb/dwc3/gadget.c
> > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > @@ -3657,6 +3657,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > >  		return 1;
> > > >  
> > > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > > +	    (event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain)
> > > > +		return 1;
> > > > +
> > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > >  		return 1;
> > > >
> > > 
> > > At this time the IMI bit was set for every frame. With these changes it
> > > appeared in case of missed isoc that sometimes not all requests would be
> > > reclaimed (enqueued != dequeued even 100ms after the last interrupt was
> > > handled). If the 1st req in the started_list was fine (IMI set, but not IOC),
> > > and a later req was the one actually missed, because of this status check the
> > > reclaimation could stop early and not clean up to the appropriate req. As
> > 
> > Oops. You're right.
> > 
> > > suggested yesterday, I also tried only setting the IMI bit when no_interrupt is
> > > not set, however I was still seeing the complete freezes. After analyzing this
> > > issue a bit, I have updated the diff to look more like this:
> > > 
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index dfaf9ac24c4f..bb800a81815b 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -1230,8 +1230,9 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
> > >  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
> > >  		}
> > >  
> > > -		/* always enable Interrupt on Missed ISOC */
> > > -		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> > > +		/* enable Interrupt on Missed ISOC */
> > > +		if ((!no_interrupt && !chain) || must_interrupt)
> > > +		    trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> > >  		break;
> > 
> > Either all or none of the TRBs of a request is set with IMI, and not
> > some.
> > 
> > >  
> > >  	case USB_ENDPOINT_XFER_BULK:
> > > @@ -3195,6 +3196,11 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > >  		return 1;
> > >  
> > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > +		(event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain
> > > +		&& (trb->ctrl & DWC3_TRB_CTRL_ISP_IMI))
> > > +		return 1;
> > > +
> > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > >  		return 1;
> > > 
> > > Where the trb must have the IMI set before returning early. This seemed to make
> > > the freezes recoverable.
> > 
> > Can you try this revised change:
> > 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 61fba2b7389b..a69d8c28d86b 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -3654,7 +3654,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> >  	if ((trb->ctrl & DWC3_TRB_CTRL_HWO) && status != -ESHUTDOWN)
> >  		return 1;
> >  
> > -	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> 
> I accidentally deleted a couple of lines here.
> 
> > +	if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
> >  		return 1;
> >  
> >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> 
> I meant to do this:
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 61fba2b7389b..cb65371572ee 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -3657,6 +3657,9 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>  		return 1;
>  
> +	if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
> +		return 1;
> +
>  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
>  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
>  		return 1;
> @@ -3673,6 +3676,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
>  	struct scatterlist *s;
>  	unsigned int num_queued = req->num_queued_sgs;
>  	unsigned int i;
> +	bool missed_isoc = false;
>  	int ret = 0;
>  
>  	for_each_sg(sg, s, num_queued, i) {
> @@ -3681,12 +3685,18 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
>  		req->sg = sg_next(s);
>  		req->num_queued_sgs--;
>  
> +		if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> +			missed_isoc = true;
> +
>  		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
>  				trb, event, status, true);
>  		if (ret)
>  			break;
>  	}
>  
> +	if (missed_isoc)
> +		ret = 1;
> +
>  	return ret;
>  }
>  
> 
> BR,
> Thinh

I tried out the following patch diff you provided and I did not see any iommu
related crashes with these changes:

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dfaf9ac24c4f..50287437d6de 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3195,6 +3195,9 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
        if (event->status & DEPEVT_STATUS_SHORT && !chain)
                return 1;
 
+       if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC && !chain)
+               return 1;
+
        if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
            (trb->ctrl & DWC3_TRB_CTRL_LST))
                return 1;
@@ -3211,6 +3214,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
        struct scatterlist *s;
        unsigned int num_queued = req->num_queued_sgs;
        unsigned int i;
+       bool missed_isoc = false;
        int ret = 0;
 
        for_each_sg(sg, s, num_queued, i) {
@@ -3219,12 +3223,18 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
                req->sg = sg_next(s);
                req->num_queued_sgs--;
 
+               if (DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+                       missed_isoc = true;
+
                ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
                                trb, event, status, true);
                if (ret)
                        break;
        }
 
+       if (missed_isoc)
+               ret = 1;
+
        return ret;
 }
 

As we discussed earlier, when uvc's complete function is called, if an -EXDEV
is returned in the request's status, the uvc driver will begin to cancel its
queue. With the current skip interrupt implementation in the uvc driver, if
this occurs while the uvc driver is pumping the current frame, then there is no
guarentee that the last request(s) will have had 'no_interrupt=0'. If the last
requests passed to dwc3 had 'no_interrupt=1', these requests would eventually
be placed at the end of the started_list. Since the IOC bit will not be set,
and if no missed isoc event occurs on these requests, then the dwc3 driver will
not be interrupted, leaving those remaining requests sitting in the
started_list, and dwc3 will not perform an 'End Transfer' as expected. Once the
uvc driver begins to pump the requests for the next frame, then it most likely
will result in additional missed isoc events, with the result being an extended
video freeze seen by the user.

I hope that other uvc driver maintainers can chime in here to help determine the
correct path forward. With the skip interrupt implementation, the uvc driver should
guarentee that the last request sent to dwc3 has 'no_interrupt=0', otherwise
if a missed isoc error occurs, it becomes very likely that the next immediate set of
frames could be dropped/cancelled because the dwc3 driver could not perform a timely
'End Transfer'.

For testing I implemented the following changes to see what I could do for this
issue. Note that I am on an older implementation and it's missing a lot of the
sg related implementation. The idea here is that if the queue is empty, and that
req_int_count is non-zero then the last request likely had 'no_interrupt=1' set.
And if this is the case then we will want to send some dummy request to dwc3 with
'no_interrupt=0' set to make sure that no requests get stuck in its started_list.

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index a00786bc6e60..cb82af6bf453 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -253,6 +253,70 @@ uvc_video_alloc_requests(struct uvc_video *video)
  * Video streaming
  */
 
+/*
+ * uvcg_video_check_pump_fake - Pumps fake/empty video data into a USB request
+ *
+ * This function fills an available USB requests (listed in req_free) with
+ * fake/empty video data to ensure that the last request had no_interrupt == 0
+ */
+static void uvcg_video_check_pump_fake(struct work_struct *work)
+{
+       struct uvc_video *video = container_of(work, struct uvc_video, pump);
+       struct uvc_video_queue *queue = &video->queue;
+       struct usb_request *req = NULL;
+       unsigned long flags;
+       uint8_t *data = NULL;
+       int ret;
+
+       if (video->ep->enabled && list_empty(&queue->irqqueue) &&
+                       video->req_int_count != 0) {
+               /* Retrieve the first available USB request, protected by the
+                * request lock.
+                */
+               spin_lock_irqsave(&video->req_lock, flags);
+               if (list_empty(&video->req_free)) {
+                       spin_unlock_irqrestore(&video->req_lock, flags);
+                       return;
+               }
+               req = list_first_entry(&video->req_free, struct usb_request,
+                                       list);
+               list_del(&req->list);
+               spin_unlock_irqrestore(&video->req_lock, flags);
+
+               /* Set up the fake/empty uvc request */
+               data = req->buf;
+               data[0] = 2;
+               data[1] = UVC_STREAM_EOH | video->fid | UVC_STREAM_EOF;
+               req->length = 2;
+               req->no_interrupt = 0;
+
+               /* Queue the USB request */
+               spin_lock_irqsave(&queue->irqlock, flags);
+               ret = uvcg_video_ep_queue(video, req);
+               spin_unlock_irqrestore(&queue->irqlock, flags);
+
+               if (ret < 0) {
+                       uvcg_queue_cancel(queue, 0);
+               } else {
+                       /* Endpoint now owns the request */
+                       req = NULL;
+
+                       /* Reset req_int_count to force an interrupt on the next request
+                        * and to avoid going through uvcg_video_check_pump_fake again.
+                        */
+                       video->req_int_count = 0;
+               }
+       }
+
+       if (!req)
+               return;
+
+       spin_lock_irqsave(&video->req_lock, flags);
+       list_add_tail(&req->list, &video->req_free);
+       spin_unlock_irqrestore(&video->req_lock, flags);
+       return;
+}
+
 /*
  * uvcg_video_pump - Pump video data into the USB requests
  *
@@ -268,6 +332,8 @@ static void uvcg_video_pump(struct work_struct *work)
        unsigned long flags;
        int ret;
 
+       uvcg_video_check_pump_fake(work);
+
        while (video->ep->enabled) {
                /* Retrieve the first available USB request, protected by the
                 * request lock.
@@ -318,7 +384,8 @@ static void uvcg_video_pump(struct work_struct *work)
                        /* Endpoint now owns the request */
                        req = NULL;
                }
-               video->req_int_count++;
+               if (buf->state != UVC_BUF_STATE_DONE)
+                       video->req_int_count++;
        }
 
        if (!req)


Alternatively we may just not want to cancel the queue upon receiving -EXDEV
and this could solve the problem too, but I don't think that it's such a great
idea, especially if things start falling behind.

I hope that someone more fluent in this area of code can take a crack at
improving/fixing this issue. 

The changes above do seem to help dwc3 timely end its transfers, but mainly for
cases where some requests are missed but the next immediate ones are not (i'm
talking within a couple of hundred microseconds). Most of the time if missed
isocs occurs for a frame that the remaining reqs in the started_list will
likely also error out and the list will be emptied and dwc3 will still timely
send 'End Transfer'. In reality this is to cover a corner case that can
adversely affect the quality of the video being watched. Just wanted to be
upfront with these details.

Thinh, any pointers on how we should proceed from here? It looks like your
changes are working well.

Thanks,
Jeff

