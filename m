Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F68603AD0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJSHk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJSHkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:40:55 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2989642D4;
        Wed, 19 Oct 2022 00:40:50 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id o13so8741972ilc.7;
        Wed, 19 Oct 2022 00:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpQeTIlmyll1M3qV70p7bUT0WCQ8wcYTPT0PV1LmbZ4=;
        b=gdmsuVeU1h8ElvcPUP+vONGSpFXCinI3xaEu2STNPKqEVdYoMYe1MiYsDgFzkMTrZv
         AZ8ICEqf38L570ie7m2+GH8MUHOQeYRC7bJ+Rc48D/weu+ogHtr929cJIgg1OouoEfxl
         JqQ844SDXlLiT3rNEOE9+7M86x7t+kgMx5rhh6cx65a1tb4xXi+6fRaHIsNPRvWYYFnx
         JuvTQZSbHmOcIwjRDiiohd56heUmiIDtZ72WMwO41sSJL3w8fxrahMQr/uI+CBz1uuca
         xqRtMC4OWk0iBvdlctWO6lE8/PdBGzmpRT1/96K4GIGxfFzgltWzXKB8lS7UXoDOaPFa
         FCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpQeTIlmyll1M3qV70p7bUT0WCQ8wcYTPT0PV1LmbZ4=;
        b=HmVNQQUHHBw0X0+J15xzMNIoAkTPAghKYaIkjMdGDIAF6S0R9d5xx+Sqsb0AaewOsW
         cDO5hJolZd5Vc5rsG/IvTnuNeXsCD1iPALO18kBIo/y/ASUQ6XmmuYe872BsgDvMCTt3
         A+YlrFs3fzQ1MRwlb5eLML4nrv2K5xc3yxk9F+FuGZ5X8IFsAIJYFVCbYPsMNw3XMTGC
         UzjTu3HV4Jur/NYp8g8eENq86onyPZ6RnMt+Nr0vhOfW4XNzTDIFLNZVWtdYhiBh1E54
         iEBtVjaGocM00/HyHQjhYtDNa/Agju3HESKMaXEToa51BCrMU0jYRzxyb/OvD8GgnKwD
         DFFw==
X-Gm-Message-State: ACrzQf32WWPP39BFmc222D32NaCyUfGYCv7N18QyvYLGQ6B3U4RTvBwj
        PL4msoXLj6mpZAGSyXE7L/5fWGx5wL1BcvKO
X-Google-Smtp-Source: AMsMyM46OyPoqaSc6D5QnTkM05N7fFuXu0DrIfKTQyZMhRgWWpPhjv0O2W1KFYt8hGahKN4fzraQUw==
X-Received: by 2002:a92:cc0b:0:b0:2f9:f3a9:c3e7 with SMTP id s11-20020a92cc0b000000b002f9f3a9c3e7mr4554939ilp.253.1666165248819;
        Wed, 19 Oct 2022 00:40:48 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id 142-20020a6b1494000000b00688faad4741sm1978942iou.24.2022.10.19.00.40.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Oct 2022 00:40:48 -0700 (PDT)
Date:   Wed, 19 Oct 2022 02:40:46 -0500
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
Message-ID: <20221019074043.GA19727@qjv001-XeonWs>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019020240.exujmo7uvae4xfdi@synopsys.com>
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

On Wed, Oct 19, 2022 at 02:02:53AM +0000, Thinh Nguyen wrote:
> On Tue, Oct 18, 2022, Jeff Vanhoof wrote:
> > Hi Thinh,
> > 
> > On Tue, Oct 18, 2022 at 10:35:30PM +0000, Thinh Nguyen wrote:
> > > On Tue, Oct 18, 2022, Jeffrey Vanhoof wrote:
> > > > Hi Thinh,
> > > > 
> > > > On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:
> > > > > Hi Dan,
> > > > > 
> > > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > > > Hi Thinh,
> > > > > > 
> > > > > > On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
> > > > > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > > > > > From: Jeff Vanhoof <qjv001@motorola.com>
> > > > > > > > 
> > > > > > > > arm-smmu related crashes seen after a Missed ISOC interrupt when
> > > > > > > > no_interrupt=1 is used. This can happen if the hardware is still using
> > > > > > > > the data associated with a TRB after the usb_request's ->complete call
> > > > > > > > has been made.  Instead of immediately releasing a request when a Missed
> > > > > > > > ISOC interrupt has occurred, this change will add logic to cancel the
> > > > > > > > request instead where it will eventually be released when the
> > > > > > > > END_TRANSFER command has completed. This logic is similar to some of the
> > > > > > > > cleanup done in dwc3_gadget_ep_dequeue.
> > > > > > > 
> > > > > > > This doesn't sound right. How did you determine that the hardware is
> > > > > > > still using the data associated with the TRB? Did you check the TRB's
> > > > > > > HWO bit?
> > > > > > 
> > > > > > The problem we're seeing was mentioned in the summary of this patch
> > > > > > series, issue #1. Basically, with the following patch
> > > > > > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G_pg!aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU2HXET9O226AEN$  
> > > > > > integrated a smmu panic is occurring on our Android device with the 5.15
> > > > > > kernel which is:
> > > > > > 
> > > > > >     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled arm-smmu context fault from a600000.dwc3!
> > > > > > 
> > > > > > The uvc gadget driver appears to be the first (and only) gadget that
> > > > > > uses the no_interrupt=1 logic, so this seems to be a new condition for
> > > > > > the dwc3 driver. In our configuration, we have up to 64 requests and the
> > > > > > no_interrupt=1 for up to 15 requests. The list size of dep->started_list
> > > > > > would get up to that amount when looping through to cleanup the
> > > > > > completed requests. From testing and debugging the smmu panic occurs
> > > > > > when a -EXDEV status shows up and right after
> > > > > > dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion
> > > > > > we had was the requests were getting returned to the gadget too early.
> > > > > 
> > > > > As I mentioned, if the status is updated to missed isoc, that means that
> > > > > the controller returned ownership of the TRB to the driver. At least for
> > > > > the particular request with -EXDEV, its TRBs are completed. I'm not
> > > > > clear on your conclusion.
> > > > > 
> > > > > Do we know where did the crash occur? Is it from dwc3 driver or from uvc
> > > > > driver, and at what line? It'd great if we can see the driver log.
> > > > >
> > > > 
> > > > To interject, what should happen in dwc3_gadget_ep_reclaim_completed_trb if the
> > > > IOC bit is not set (but the IMI bit is) and -EXDEV status is passed into it?
> > > 
> > > Hm... we may have overlooked this case for no_interrupt scenario. If IMI
> > > is set, then there will be an interrupt when there's missed isoc
> > > regardless of whether no_interrupt is set by the gadget driver.
> > > 
> > > > If the function returns 0, another attempt to reclaim may occur. If this
> > > > happens and the next request did have the HWO bit set, the function would
> > > > return 1 but dwc3_gadget_ep_cleanup_completed_request would still call
> > > > dwc3_gadget_giveback.
> > > > 
> > > > As a test (without this patch), I added a check to see if HWO bit was set in
> > > > dwc3_gadget_ep_cleanup_completed_requests(). If the usecase was ISOC and the
> > > > HWO bit was set I avoided calling dwc3_gadget_ep_cleanup_completed_request().
> > > > This seemed to also avoid the iommu related crash being seen.
> > > > 
> > > > Is there an issue in this area that needs to be corrected instead? Not having
> > > > interrupts set for each request may be causing some new issues to be uncovered.
> > > > 
> > > > As far as the crash seen without this patch, no good stacktrace is given. Line
> > > > provided for crash varied a bit, but tended to appear towards the end of
> > > > dwc3_stop_active_transfer() or dwc3_gadget_endpoint_trbs_complete().
> > > > 
> > > > Since dwc3_gadget_endpoint_trbs_complete() can be called from multiple
> > > > locations, I duplicated the function to help identify which path it was likely
> > > > being called from. At the time of the crashes seen,
> > > > dwc3_gadget_endpoint_transfer_in_progress() appeared to be the caller.
> > > > 
> > > > dwc3_gadget_endpoint_transfer_in_progress()
> > > > ->dwc3_gadget_endpoint_trbs_complete() (crashed towards end of here)
> > > > ->dwc3_stop_active_transfer() (sometimes crashed towards end of here)
> > > > 
> > > > I hope this clarifies things a bit.
> > > >  
> > > 
> > > Can we try this? Let me know if it resolves your issue.
> > > 
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index 61fba2b7389b..8352f4b5dd9f 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -3657,6 +3657,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > >  		return 1;
> > >  
> > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > +	    (event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain)
> > > +		return 1;
> > > +
> > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > >  		return 1;
> > >
> > 
> > With this change it doesn't seem to crash but unfortunately the output
> > completely hangs after the first missed isoc. At the moment I do not understand
> > why this might happen. 
> > 
> 
> Can you capture the driver tracepoints with the change above?
>

Due to the size of the log, have sent it to directly to you.

From what I can gather from the log, with the current changes it seems that
after a missed isoc event few requests are staying longer than expected in the
started_list (not getting reclaimed) and this is preventing the transmission
from stopping/starting again, and opening the door for continuous stream of
missed isoc events that cause what appears to the user as a frozen video.

So one thought, if IOC bit is not set every frame, but IMI bit is, when a
missed isoc related interrupt occurs it seems likely that more than one trb
request will need to be reclaimed, but the current set of changes is not
handling this.

In the good transfer case this issue seems to be taken care of since the IOC
bit is not set every frame and the reclaimation will loop through every item in
the started_list and only stop if there are no additional trbs or if one has
its HWO bit set. Although I am a bit surprised that we are not yet seeing iommu
related panics here too since the trb is being reclaimed and given back even
the HWO bit still set, but maybe I am misunderstanding something. In my earlier
testing, if a missed isoc event was received and we attempted to
reclaim/giveback a trb with its HWO bit set, a iommu related panic would be
seen.

Can you propose an additional change to handle freeing up the extra trbs in the
missed isoc case? I think that somehow the HWO bit should be checked before
entering dwc3_gadget_ep_cleanup_completed_request in order to avoid the trb
being given back too soon.

Your thoughts?

> > 
> > Note that I haven't quite learned correctly how to reply correct to the mailing
> > list.  I appologize for messing up the thread a bit.
> > 
> 
> Seems fine to me. As long as I can read and understand, I've no issue. :)
> 
> Thanks,
> Thinh

Thanks,
Jeff

