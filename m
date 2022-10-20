Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5515606633
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJTQr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 12:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJTQrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 12:47:42 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED1B1DB273;
        Thu, 20 Oct 2022 09:47:38 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 137so33655iou.9;
        Thu, 20 Oct 2022 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hja3ecI+y63g+N3+beyMUAJk1Z0DCQwjT33b1vzUxY=;
        b=NzDcGvmhZIc/WXXz3+zpuV2vh3I/8NtP44+U1Br0rS5hKJAwbLiNb/BWToTde5HHzO
         lm/Y85BiQfevMlUh8IragQKkgZds2R4ZCSJclOWmWjDS7rubA7Geoixv5bxel2YM0F6J
         3zWw1XQg9dWH0SFuLdzZ5O/K985tsxMNzzYEMbrkrCKGcjxcy7Qs5XQc09EFG7DAHP+x
         WlyjFLE+lUX/zQooB+iagDd+5HqdWlJa5f0dGZ0rVLAKP9O7fGU8m61nFVwE69Jypjed
         UN1b1786IDqr8pXHr5EiMBbhRT+UXv5LAnKGSOzxkz46x00ZRO4xpGN8OoJOAVq+Ohc2
         eZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1hja3ecI+y63g+N3+beyMUAJk1Z0DCQwjT33b1vzUxY=;
        b=HIQ814JGN7FDFpeGqJIi0Fut16Fr/IzPCRagVmirUJkdKx5wVzHJJYoz+xZZZ/nnOH
         8A3rhwjcS+49OTCL9C+6vKUxtNCrJsOvMGfXTCzom5EbqHaeRSn38BVi2ARWPTq6B5on
         Nxc1RRNwH3k5+s2Oa8K700WsqwMZcJ8tb5TU4aZ4YtaAt9Ss6jbpizY2R2HTWjhj9+rg
         ORXon8OyQtqINZPAcqUIRTbWBwsm7dSBH7pnS7gBuNFAmihSQ91C91HsZ9gvnqcOXlXk
         vOLrOOT/eRtmL2oCFAGzj2lAZeTUT6r7w+G4UgDsljgXwbwm4QqrBPKLIg5K/QgXvEN8
         ehNw==
X-Gm-Message-State: ACrzQf1+ZMjOLsUpLgng7kSVVKGo8urF/7+7CDxXTJFTY3ALDQgsVFAM
        fo1dVN9k56oIgesn3Z4oIc4=
X-Google-Smtp-Source: AMsMyM7KjwiUn2XAgtkLzTjWyFbIw27ivEV1ptwDlf9oDk0JFZaDqHnCf7FBNGXhSOeiu/J70H0peQ==
X-Received: by 2002:a02:a510:0:b0:363:7345:2f5f with SMTP id e16-20020a02a510000000b0036373452f5fmr10156740jam.314.1666284457442;
        Thu, 20 Oct 2022 09:47:37 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id p16-20020a056638217000b00363dddc0037sm3258954jak.130.2022.10.20.09.47.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Oct 2022 09:47:37 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:47:34 -0500
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
Message-ID: <20221020164732.GA25496@qjv001-XeonWs>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
 <20221019230555.gwovdtmnopwacirt@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019230555.gwovdtmnopwacirt@synopsys.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thinh,

On Wed, Oct 19, 2022 at 11:06:08PM +0000, Thinh Nguyen wrote:
> Hi,
> 
> On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > Hi Thinh,
> > On Wed, Oct 19, 2022 at 07:08:27PM +0000, Thinh Nguyen wrote:
> > > On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> 
> <snip>
> 
> > > > 
> > > > From what I can gather from the log, with the current changes it seems that
> > > > after a missed isoc event few requests are staying longer than expected in the
> > > > started_list (not getting reclaimed) and this is preventing the transmission
> > > > from stopping/starting again, and opening the door for continuous stream of
> > > > missed isoc events that cause what appears to the user as a frozen video.
> > > > 
> > > > So one thought, if IOC bit is not set every frame, but IMI bit is, when a
> > > > missed isoc related interrupt occurs it seems likely that more than one trb
> > > > request will need to be reclaimed, but the current set of changes is not
> > > > handling this.
> > > > 
> > > > In the good transfer case this issue seems to be taken care of since the IOC
> > > > bit is not set every frame and the reclaimation will loop through every item in
> > > > the started_list and only stop if there are no additional trbs or if one has
> > > 
> > > It should stop at the request that associated with the interrupt event,
> > > whether it's because of IMI or IOC.
> > 
> > In this case I was concerned that if multipled queued reqs did not have IOC bit
> > set, but there was a missed isoc on one of the last reqs, whether or not we would
> > reclaim all of the requests up to the missed isoc related req. I'm not sure if
> > my concern is valid or not.
> > 
> 
> There should be no problem. If there's an interrupt event indicating a
> TRB completion, the driver will give back all the requests up to the
> request associated with the interrupt event, and the controller will
> continue processing the remaining TRBs. On the next TRB completion
> event, the driver will again give back all the requests up to the
> request associated with that event.
>

I was testing with the following patch you suggested:

> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 61fba2b7389b..8352f4b5dd9f 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -3657,6 +3657,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>  		return 1;
>  
> +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> +	    (event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain)
> +		return 1;
> +
>  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
>  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
>  		return 1;
>

At this time the IMI bit was set for every frame. With these changes it
appeared in case of missed isoc that sometimes not all requests would be
reclaimed (enqueued != dequeued even 100ms after the last interrupt was
handled). If the 1st req in the started_list was fine (IMI set, but not IOC),
and a later req was the one actually missed, because of this status check the
reclaimation could stop early and not clean up to the appropriate req. As
suggested yesterday, I also tried only setting the IMI bit when no_interrupt is
not set, however I was still seeing the complete freezes. After analyzing this
issue a bit, I have updated the diff to look more like this:

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dfaf9ac24c4f..bb800a81815b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1230,8 +1230,9 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		/* enable Interrupt on Missed ISOC */
+		if ((!no_interrupt && !chain) || must_interrupt)
+		    trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
@@ -3195,6 +3196,11 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+		(event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain
+		&& (trb->ctrl & DWC3_TRB_CTRL_ISP_IMI))
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;

Where the trb must have the IMI set before returning early. This seemed to make
the freezes recoverable.

> > > 
> > > > its HWO bit set. Although I am a bit surprised that we are not yet seeing iommu
> > > > related panics here too since the trb is being reclaimed and given back even
> > > > the HWO bit still set, but maybe I am misunderstanding something. In my earlier
> > > > testing, if a missed isoc event was received and we attempted to
> > > > reclaim/giveback a trb with its HWO bit set, a iommu related panic would be
> > > > seen.
> > > 
> > > If the controller processed the TRB, it would clear the HWO bit after
> > > completion. There are cases which the HWO bit is still set for some
> > > TRBs, but the request is completed (e.g. short transfers causing the
> > > controller to stop processing further). That those cases, the driver
> > > would clear the HWO bit manually.
> > > 
> > > > 
> > > > Can you propose an additional change to handle freeing up the extra trbs in the
> > > > missed isoc case? I think that somehow the HWO bit should be checked before
> > > > entering dwc3_gadget_ep_cleanup_completed_request in order to avoid the trb
> > > > being given back too soon.
> > > 
> > > We should not check for TRBs of requests beyond the request associated
> > > with the interrupt event.
> > > 
> > > > 
> > > > Your thoughts?
> > > > 
> > > 
> > > The capture shows underrun, and it causes missed isoc.
> > > 
> > > Let's take a look at the first missed isoc request (req ffffff88f834db00)
> > > 
> > >            <...>-22551   [002] d..2 13985.789684: dwc3_ep_queue: ep2in: req ffffff88f834db00 length 0/49152 zsi ==> -115
> > >            <...>-22551   [002] dn.2 13985.789728: dwc3_prepare_trb: ep2in: trb ffffffc016071970 (E152:D149) buf 00000000ea800000 size 1x 49152 ctrl 00000461 (Hlcs:Sc:isoc-first)
> > > 
> > > Each request uses a one TRB. From above, you can see that there are only
> > > 3 intervals prepared (E152 - D149 = 3).
> > > 
> > > The timestamp of the last request completion is 13985.788919.
> > > The timestamp which the queued request is 13985.789728.
> > > We can roughly estimate the diff is at least 809us.
> > > 
> > > 3 intervals (3x125us) is less than 809us. So missed isoc is expected:
> > > 
> > >     irq/399-dwc3-15269   [002] d..1 13985.790754: dwc3_event: event (f9acc08a): ep2in: Transfer In Progress [63916] (sIM)
> > >     irq/399-dwc3-15269   [002] d..1 13985.790758: dwc3_complete_trb: ep2in: trb ffffffc016071970 (E154:D152) buf 00000000ea800000 size 1x 49152 ctrl 3e6a0460 (hlcs:Sc:isoc-first)
> > >     irq/399-dwc3-15269   [002] d..1 13985.790808: dwc3_gadget_giveback: ep2in: req ffffff88f834db00 length 0/49152 zsi ==> -18
> > > 
> > > 
> > > After this point, the uvc driver keeps playing catch up to stay in sync
> > > with the host. It tries, but it couldn't catch up. Also, occasionally
> > > something seems to be blocking dwc3, creating time gaps. Maybe because
> > > of a spin_lock held somewhere?
> > >
> > 
> > Could the time gaps be created by the interrupt frequency changes? They
> > completely change up the timing of when the transfers are kicked in dwc3 and
> > when uvc_video_complete/uvcg_video_pump is called.
> 
> You can check all the "fastrpc_msg" tracepoints in the log. These steps
> seem to slow down the queuing process in uvc.
>

The large time gaps appear related to the low fps used for the camera
configuration. I was able to confirm this by adding additional trace points in
the uvc driver to see if pump was being called after new work was queued up
by v4l2.

Some additional thoughts:

On the scheduling side, one issue I've seen:
1) uvc/dwc3 may take a few millisecs to queue up the requests for a single
frame. How quickly this is completed could make for some of the differences
seen from one platform to another.

2) If the isoc transfer has not yet started and uvc begins to queue up requests to
dwc3, it appears that the isoc transfer will almost immediately start. And if
the remaining requests for the frame do not come quickly enough, there is a
potential for the transfer to stop or a missed isoc event to occur.

Maybe this happens frequently on my platform because the debug kernel I am
using has a bit too much overhead. Will allowing a bit more time for initially
queuing up some data before kicking off the transfer be prudent? Is 500us
really enough for a mobile platform? We've always have had issues with random
frame drops, but on much older platforms I was able to reduce the frequency of
them by delaying the start by pushing out the frame_number by 16 or 32.

Also, one problem I am seeing specifically with the skip interrupts:
1) If a missed isoc event occurs, dwc3_gadget_giveback will call the request's
->complete callback where the status -EXDEV is passed. In uvc_video_complete it
will begin to cancel the queue if this status is seen. If this occurs while in
the middle of queuing up the requests for the same frame, then it's quite
possible that the last set of requests will have had no_interrupt=1 set.

2) In dwc3 after the missed isoc event, if the remaining set of requests in the
started_list do not have the IOC bit set, then no further interrupts will
occur. And because the started_list is not emptied the transfer will not be
stopped. Only after uvc queues up the requests for the next frame (which may
come much later, i.e. 30-100ms) will the transfers appear to continue, however
additional missed isoc events will be received and the cycle could continue.

I believe that this is a problem that should be addressed somehow. Not sure if
the uvc driver needs to send a dummy request when an error is received, or if
it should just send one more additional request with the no_interrupt bit not
set, or if it needs to just send the complete frame in spite of the
error. Hopefully I'm not just completely lost on this stuff.

Using the above patch, I grabbed the following trace snippets to show what is being seen:

Normal looking missed isoc related trace where enqueued == dequeued and transfer ends as expected:
   kworker/u17:5-8169    [000] d..2   187.669572: dwc3_gadget_ep_cmd: ep2in: cmd 'Start Transfer' [49540406] params 00000000 efff5f30 00000000 --> status: Successful
    irq/398-dwc3-9882    [000] d..1   187.672504: dwc3_complete_trb: ep2in: trb ffffffc016396f30 (E250:D244) buf 00000000ed470000 size 1x 0 ctrl 12550c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.672804: dwc3_complete_trb: ep2in: trb ffffffc016396f40 (E250:D245) buf 00000000ec5e0000 size 1x 0 ctrl 12558060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.672885: dwc3_complete_trb: ep2in: trb ffffffc016396f50 (E250:D246) buf 00000000ecd30000 size 1x 0 ctrl 12560060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.672942: dwc3_complete_trb: ep2in: trb ffffffc016396f60 (E250:D247) buf 00000000ecd40000 size 1x 0 ctrl 12568060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.672993: dwc3_complete_trb: ep2in: trb ffffffc016396f70 (E250:D248) buf 00000000edfb0000 size 1x 0 ctrl 12570060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.673049: dwc3_complete_trb: ep2in: trb ffffffc016396f80 (E250:D249) buf 00000000edfa0000 size 1x 0 ctrl 12578c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.674615: dwc3_complete_trb: ep2in: trb ffffffc016396f90 (E254:D250) buf 00000000eca80000 size 1x 0 ctrl 12580060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   187.674722: dwc3_complete_trb: ep2in: trb ffffffc016396fa0 (E254:D251) buf 00000000edfa0000 size 1x 49152 ctrl 12588060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   187.674793: usb_gadget_giveback_request: ep2in: req ffffff894498a600 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   187.675008: dwc3_complete_trb: ep2in: trb ffffffc016396fb0 (E254:D252) buf 00000000edfb0000 size 1x 49152 ctrl 12590060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   187.675093: usb_gadget_giveback_request: ep2in: req ffffff892bcd3500 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   187.675120: dwc3_complete_trb: ep2in: trb ffffffc016396fc0 (E254:D253) buf 00000000ecd40000 size 1x 49152 ctrl 12598060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   187.675207: usb_gadget_giveback_request: ep2in: req ffffff8918f48200 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   187.675225: dwc3_complete_trb: ep2in: trb ffffffc016396fd0 (E254:D254) buf 00000000ecd30000 size 1x 49152 ctrl 125a0c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   187.675274: usb_gadget_giveback_request: ep2in: req ffffff892bcd3600 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   187.675364: dwc3_gadget_ep_cmd: ep2in: cmd 'End Transfer' [50d08] params 00000000 00000000 00000000 --> status: Successful

Abnormal trace where the 'End Transfer' is delayed by a few frames:
   kworker/u17:5-8169    [000] dn.2   190.804817: dwc3_gadget_ep_cmd: ep2in: cmd 'Start Transfer' [ab500406] params 00000000 efff5290 00000000 --> status: Successful
    irq/398-dwc3-9882    [000] d..1   190.809070: dwc3_complete_trb: ep2in: trb ffffffc016396290 (E51:D42) buf 00000000ef6b0000 size 1x 0 ctrl 2ad40c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d..1   190.809478: dwc3_complete_trb: ep2in: trb ffffffc0163962a0 (E53:D43) buf 00000000ef060000 size 1x 49152 ctrl 2ad48060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.809534: usb_gadget_giveback_request: ep2in: req ffffff8918f48200 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.809752: dwc3_complete_trb: ep2in: trb ffffffc0163962b0 (E54:D44) buf 00000000ec5a0000 size 1x 49152 ctrl 2ad50060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.809878: usb_gadget_giveback_request: ep2in: req ffffff8859af4e00 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.809966: dwc3_complete_trb: ep2in: trb ffffffc0163962c0 (E54:D45) buf 00000000ef180000 size 1x 49152 ctrl 2ad58060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810037: usb_gadget_giveback_request: ep2in: req ffffff8918f48000 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.810058: dwc3_complete_trb: ep2in: trb ffffffc0163962d0 (E54:D46) buf 00000000ef070000 size 1x 49152 ctrl 2ad60060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810139: usb_gadget_giveback_request: ep2in: req ffffff894498a500 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.810159: dwc3_complete_trb: ep2in: trb ffffffc0163962e0 (E54:D47) buf 00000000eeae0000 size 1x 49152 ctrl 2ad68c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810238: usb_gadget_giveback_request: ep2in: req ffffff88bddb9f00 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.810293: dwc3_complete_trb: ep2in: trb ffffffc0163962f0 (E54:D48) buf 00000000ec0d0000 size 1x 49152 ctrl 2ad70060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810368: usb_gadget_giveback_request: ep2in: req ffffff892bcd3500 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.810389: dwc3_complete_trb: ep2in: trb ffffffc016396300 (E54:D49) buf 00000000ec0e0000 size 1x 0 ctrl 2ad78060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   190.810454: dwc3_complete_trb: ep2in: trb ffffffc016396310 (E54:D50) buf 00000000ec0f0000 size 1x 0 ctrl 2ad80060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d..1   190.810526: dwc3_complete_trb: ep2in: trb ffffffc016396320 (E54:D51) buf 00000000efa20000 size 1x 49152 ctrl 2ad88060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810591: usb_gadget_giveback_request: ep2in: req ffffff8859af5800 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.810609: dwc3_complete_trb: ep2in: trb ffffffc016396330 (E54:D52) buf 00000000efa30000 size 1x 49152 ctrl 2ad90c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.810676: usb_gadget_giveback_request: ep2in: req ffffff88bddb8300 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
...
    irq/398-dwc3-9882    [000] d..1   190.919720: dwc3_complete_trb: ep2in: trb ffffffc016396340 (E56:D53) buf 00000000efa40000 size 1x 49152 ctrl 2ad98060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.919804: usb_gadget_giveback_request: ep2in: req ffffff894498a900 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.920065: dwc3_complete_trb: ep2in: trb ffffffc016396350 (E57:D54) buf 00000000efa50000 size 1x 49152 ctrl 2ada0060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.920116: usb_gadget_giveback_request: ep2in: req ffffff88bddb8b00 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.920175: dwc3_complete_trb: ep2in: trb ffffffc016396360 (E57:D55) buf 00000000efa60000 size 1x 49152 ctrl 2ada8c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.920223: usb_gadget_giveback_request: ep2in: req ffffff892bcd3600 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
...
    irq/398-dwc3-9882    [000] d..1   190.992902: dwc3_complete_trb: ep2in: trb ffffffc016396370 (E59:D56) buf 00000000efa90000 size 1x 49152 ctrl 2adb0060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.993014: usb_gadget_giveback_request: ep2in: req ffffff88a0b9b400 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.993365: dwc3_complete_trb: ep2in: trb ffffffc016396380 (E60:D57) buf 00000000efaa0000 size 1x 49152 ctrl 2adb8060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.993439: usb_gadget_giveback_request: ep2in: req ffffff8859af4f00 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   190.993528: dwc3_complete_trb: ep2in: trb ffffffc016396390 (E60:D58) buf 00000000efab0000 size 1x 49152 ctrl 2adc0c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   190.993622: usb_gadget_giveback_request: ep2in: req ffffff8859af4e00 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
...
    irq/398-dwc3-9882    [000] d..1   191.104270: dwc3_complete_trb: ep2in: trb ffffffc0163963a0 (E61:D59) buf 00000000ee950000 size 1x 49152 ctrl 2adc8060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   191.104410: usb_gadget_giveback_request: ep2in: req ffffff8918f48000 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   191.104648: dwc3_complete_trb: ep2in: trb ffffffc0163963b0 (E61:D60) buf 00000000ed530000 size 1x 49152 ctrl 2add0060 (hlcs:sc:isoc-first)
    irq/398-dwc3-9882    [000] d...   191.104745: usb_gadget_giveback_request: ep2in: req ffffff894498a500 length 0/49152 sgs 0/0 stream 0 zsi status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   191.104834: dwc3_complete_trb: ep2in: trb ffffffc0163963c0 (E61:D61) buf 00000000ef610000 size 1x 49152 ctrl 2add8c60 (hlcs:SC:isoc-first)
    irq/398-dwc3-9882    [000] d...   191.104925: usb_gadget_giveback_request: ep2in: req ffffff8859af5800 length 0/49152 sgs 0/0 stream 0 zsI status -18 --> 0
    irq/398-dwc3-9882    [000] d..1   191.105098: dwc3_gadget_ep_cmd: ep2in: cmd 'End Transfer' [50d08] params 00000000 00000000 00000000 --> status: Successful

Where you can see that in between frames enqueued != dequeued, and this can
cause the video to freeze/skip for more than a single frame. The length of the
freeze is all timing related and depends on if an interrupt occurs on the last
req or not in the started_list.

So, to sort of rehash things again, we came up with the patch:
[PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of release after missed isoc
to workaround the iommu related crashes being seen with the skip interrupt solution.

As an alternative solution, we are now using the diff mentioned above, and it
seems to avoid the crash, however we are seeing longer freezes with it, I believe
due to the explaination I provided above.

If you agree with my analysis, what should we do from here? What's the best way to ensure
that the started_list can get cleaned up after a missed isoc with the skip interrupt solution
enabled? 


> > 
> > > The logic to detect underrun doesn't trigger because the queued list is
> > > always non-empty, but the queued requests are expected to be missed
> > > already. So you keep seeing missed isoc.
> > > 
> > > There are a few things you can mitigate this issue:
> > > 1) Don't set IMI if the request indicates no_interrupt. This reduces the
> > >    time software needs to handle interrupts.
> > 
> > I did try this out earlier and it did not prevent the video freeze. It does
> > make sense what you are suggesting, but because it didn't work for me it made
> > me think that not all reqs are being reclaimed after a missed isoc is seen.
> > I'll revisit this area again.
> 
> I don't expect this to improve much.
> 
> > 
> > > 2) Improve the underrun detection logic.
> > 
> > I like this idea a lot but I'm not up to the task just yet. Will attempt to
> > follow your recommendations below and see where I get with this.
> > 
> > > 3) Increase the queuing frequency from the uvc to keep the request queue
> > >    full. Note that reduce/avoid setting no_interrupt will allow the
> > >    controller driver to update uvc often to keep requeuing new requests.
> > > 
> > > Best option is 3), but maybe we can do all 3.
> > >
> > 
> > I think that this is our best option too. Dan provided a patch to make
> > the interrupt skip logic configurable in the uvc driver:
> > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-usb/patch/20221018215044.765044-6-w36195@motorola.com/__;!!A4F2R9G_pg!eBu4j9m9C_XJHcuTXmYqo4CAe8bcQ0ZC3UWT3NJUZYYG6S-VJpriVwd2Q5NmAOFnN2PLgTauFDZ-fBM35ftO$  
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20221018215044.765044-6-w36195@motorola.com/__;!!A4F2R9G_pg!eBu4j9m9C_XJHcuTXmYqo4CAe8bcQ0ZC3UWT3NJUZYYG6S-VJpriVwd2Q5NmAOFnN2PLgTauFDZ-fCLOxuhL$  
> > 
> > > For 2), you can set IMI for all isoc request as it is now. On missed
> > > isoc, check for the TRB's scheduled uframe (from TRB info) and compare
> > > it to the current uframe (from DSTS) for the number of intervals in
> > > between. With the number of queued requests, you can calculate whether
> > > the gadget driver queued enough requests. If it doesn't, send End
> > > Transfer command and cancel all the queued requests. The next set of
> > > requests will be in-sync again.
> > > 
> > > BR,
> > > Thinh
> > > 
> > > PS. On a side note, I notice that there are reports of issue when using
> > > SG right? Please note that dwc3 driver only allocates 256 TRBs
> > > (including a link TRB). Each SG entry takes a TRB. If a request has many
> > > SG entries, that eats up the available TRBs. So, even though the UVC may
> > > queue many requests, not all of them are prepared immediately. If the
> > > TRB ring is full, the driver need to wait for more TRBs to free up
> > > before preparing more. From the log, I see that it's sending 48KB. Let's
> > > say the uvc splits it into PAGE_SIZE of 4KB, that would take at least 12
> > > TRB per request. (Side thought: I'm not sure why UVC needs SG in the
> > > first place with its current implementation)
> > 
> > On our platform I am seeing 2 items in the sg list being sent out from the uvc
> > driver. The 1st item in the list is a 2 byte uvc header and the 2nd item is
> > the 48KBs of data. To me this seems inefficient but sort of makes sense why it
> > was done, likely to avoid a memory copy just for the 2 byte header.  But I
> 
> That doesn't make sense to me, but I'm sure there's a real reason. Just
> curious, that's all. :)
> 
> > share your concern here, it's possible that other users wont be so lucky and
> > will wind up having a lot of page sized items in the sg list.
> > 
> > We are also hoping to make the use of sg configurable with the change:
> > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-usb/patch/20221018215044.765044-7-w36195@motorola.com/__;!!A4F2R9G_pg!eBu4j9m9C_XJHcuTXmYqo4CAe8bcQ0ZC3UWT3NJUZYYG6S-VJpriVwd2Q5NmAOFnN2PLgTauFDZ-fAiSl95Q$  
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20221018215044.765044-7-w36195@motorola.com/__;!!A4F2R9G_pg!eBu4j9m9C_XJHcuTXmYqo4CAe8bcQ0ZC3UWT3NJUZYYG6S-VJpriVwd2Q5NmAOFnN2PLgTauFDZ-fDoaNx6Q$  
> > 
> 
> Ok.
> 
> Thanks,
> Thinh

Thanks,
Jeff

