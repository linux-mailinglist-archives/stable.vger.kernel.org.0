Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8663F605207
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiJSVea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 17:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJSVe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 17:34:28 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA616E2A2;
        Wed, 19 Oct 2022 14:34:19 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n73so15638723iod.13;
        Wed, 19 Oct 2022 14:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0ixdFL+xL7BEvfmxTdEvL5M29TZenmiXXuT1H71rVE=;
        b=Y14utIXE83zJMlMUwA9IwRXg6TDBrCiczbB+tp/gar5HW8Un4O0yVh7rOXMnjxfuOU
         4S610deoxFbo1d9AfEVV+qD7XV+pNQYBN2fwrMGuKcfZYyqP2s8wTWTEvkDSkTGkqIbc
         AMe3lwEyBZay2tE5XTID4Ial8NhfbpW7LXP29ijiG396TKd0m2EhCuMdCxAUDmTeKfds
         b3pq0VSG2qLjDqeVPvdEPRVXxwCWHJi2nMbC2e/w+uDMSZ2bxXxeOjJMnLek/A1v4inj
         OiDV1oQXabkRTkV1f1le36gzlrtnvBmPwa/Fr5XlmCLTYlqNSI0fVGv3/igLmqmqP9I1
         UKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j0ixdFL+xL7BEvfmxTdEvL5M29TZenmiXXuT1H71rVE=;
        b=GTVxzFr3x74tk5VLgvFYnxQTTFtCHa3Ts9bX0RuafuAUPDjMugDsBGEisLukyjPx+p
         ZHKfeuWqL0f93OCB+fj8jfiXCxHR7c9rj40u4s1I3KiK+f0V9i2MWKZMB9vTBffuAqsh
         uZEpIhY/PgXn7djG/RaqEqqpqwoBU92zTymf4k50RRaFQokosRR4iubQZLPnetkFfaw0
         M12YJtFRH7mcpZ/x7lmB6y+but/ZgqdDuRQzUTdGYo2he1kLmEobh7DGDp7tYjUoe8Yr
         sHZ3pNg/1d3qLsdBNdyLQyX34yIVcc/OH0KozAlai9KOvUQkR7+RvsU58ExPMf7oW3Du
         CCDg==
X-Gm-Message-State: ACrzQf37r3LDlsJIEXgYUrlXZNh/NlsVdI242XMdG/bySvz0Uuk0jn5a
        7vOsalOCRWpxfGNVJLma72E=
X-Google-Smtp-Source: AMsMyM5ooiWhtRAjwMtGPHbP9ym05l1ZfIbQPCPXRhr7KVf8urU7pIPKbV2jUmKAp3k5BWw6U6z5Jg==
X-Received: by 2002:a02:7409:0:b0:363:bb5c:2d7 with SMTP id o9-20020a027409000000b00363bb5c02d7mr8263018jac.260.1666215255767;
        Wed, 19 Oct 2022 14:34:15 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id v29-20020a02b09d000000b0034294118e1bsm2526656jah.126.2022.10.19.14.34.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Oct 2022 14:34:15 -0700 (PDT)
Date:   Wed, 19 Oct 2022 16:34:12 -0500
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
Message-ID: <20221019213410.GA17789@qjv001-XeonWs>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
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
On Wed, Oct 19, 2022 at 07:08:27PM +0000, Thinh Nguyen wrote:
> On Wed, Oct 19, 2022, Jeff Vanhoof wrote:
> > Hi Thinh,
> > 
> > On Wed, Oct 19, 2022 at 02:02:53AM +0000, Thinh Nguyen wrote:
> > > On Tue, Oct 18, 2022, Jeff Vanhoof wrote:
> > > > Hi Thinh,
> > > > 
> > > > On Tue, Oct 18, 2022 at 10:35:30PM +0000, Thinh Nguyen wrote:
> > > > > On Tue, Oct 18, 2022, Jeffrey Vanhoof wrote:
> > > > > > Hi Thinh,
> > > > > > 
> > > > > > On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:
> > > > > > > Hi Dan,
> > > > > > > 
> > > > > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > > > > > Hi Thinh,
> > > > > > > > 
> > > > > > > > On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
> > > > > > > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > > > > > > > From: Jeff Vanhoof <qjv001@motorola.com>
> > > > > > > > > > 
> > > > > > > > > > arm-smmu related crashes seen after a Missed ISOC interrupt when
> > > > > > > > > > no_interrupt=1 is used. This can happen if the hardware is still using
> > > > > > > > > > the data associated with a TRB after the usb_request's ->complete call
> > > > > > > > > > has been made.  Instead of immediately releasing a request when a Missed
> > > > > > > > > > ISOC interrupt has occurred, this change will add logic to cancel the
> > > > > > > > > > request instead where it will eventually be released when the
> > > > > > > > > > END_TRANSFER command has completed. This logic is similar to some of the
> > > > > > > > > > cleanup done in dwc3_gadget_ep_dequeue.
> > > > > > > > > 
> > > > > > > > > This doesn't sound right. How did you determine that the hardware is
> > > > > > > > > still using the data associated with the TRB? Did you check the TRB's
> > > > > > > > > HWO bit?
> > > > > > > > 
> > > > > > > > The problem we're seeing was mentioned in the summary of this patch
> > > > > > > > series, issue #1. Basically, with the following patch
> > > > > > > > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G_pg!aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU2HXET9O226AEN$  
> > > > > > > > integrated a smmu panic is occurring on our Android device with the 5.15
> > > > > > > > kernel which is:
> > > > > > > > 
> > > > > > > >     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled arm-smmu context fault from a600000.dwc3!
> > > > > > > > 
> > > > > > > > The uvc gadget driver appears to be the first (and only) gadget that
> > > > > > > > uses the no_interrupt=1 logic, so this seems to be a new condition for
> > > > > > > > the dwc3 driver. In our configuration, we have up to 64 requests and the
> > > > > > > > no_interrupt=1 for up to 15 requests. The list size of dep->started_list
> > > > > > > > would get up to that amount when looping through to cleanup the
> > > > > > > > completed requests. From testing and debugging the smmu panic occurs
> > > > > > > > when a -EXDEV status shows up and right after
> > > > > > > > dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion
> > > > > > > > we had was the requests were getting returned to the gadget too early.
> > > > > > > 
> > > > > > > As I mentioned, if the status is updated to missed isoc, that means that
> > > > > > > the controller returned ownership of the TRB to the driver. At least for
> > > > > > > the particular request with -EXDEV, its TRBs are completed. I'm not
> > > > > > > clear on your conclusion.
> > > > > > > 
> > > > > > > Do we know where did the crash occur? Is it from dwc3 driver or from uvc
> > > > > > > driver, and at what line? It'd great if we can see the driver log.
> > > > > > >
> > > > > > 
> > > > > > To interject, what should happen in dwc3_gadget_ep_reclaim_completed_trb if the
> > > > > > IOC bit is not set (but the IMI bit is) and -EXDEV status is passed into it?
> > > > > 
> > > > > Hm... we may have overlooked this case for no_interrupt scenario. If IMI
> > > > > is set, then there will be an interrupt when there's missed isoc
> > > > > regardless of whether no_interrupt is set by the gadget driver.
> > > > > 
> > > > > > If the function returns 0, another attempt to reclaim may occur. If this
> > > > > > happens and the next request did have the HWO bit set, the function would
> > > > > > return 1 but dwc3_gadget_ep_cleanup_completed_request would still call
> > > > > > dwc3_gadget_giveback.
> > > > > > 
> > > > > > As a test (without this patch), I added a check to see if HWO bit was set in
> > > > > > dwc3_gadget_ep_cleanup_completed_requests(). If the usecase was ISOC and the
> > > > > > HWO bit was set I avoided calling dwc3_gadget_ep_cleanup_completed_request().
> > > > > > This seemed to also avoid the iommu related crash being seen.
> > > > > > 
> > > > > > Is there an issue in this area that needs to be corrected instead? Not having
> > > > > > interrupts set for each request may be causing some new issues to be uncovered.
> > > > > > 
> > > > > > As far as the crash seen without this patch, no good stacktrace is given. Line
> > > > > > provided for crash varied a bit, but tended to appear towards the end of
> > > > > > dwc3_stop_active_transfer() or dwc3_gadget_endpoint_trbs_complete().
> > > > > > 
> > > > > > Since dwc3_gadget_endpoint_trbs_complete() can be called from multiple
> > > > > > locations, I duplicated the function to help identify which path it was likely
> > > > > > being called from. At the time of the crashes seen,
> > > > > > dwc3_gadget_endpoint_transfer_in_progress() appeared to be the caller.
> > > > > > 
> > > > > > dwc3_gadget_endpoint_transfer_in_progress()
> > > > > > ->dwc3_gadget_endpoint_trbs_complete() (crashed towards end of here)
> > > > > > ->dwc3_stop_active_transfer() (sometimes crashed towards end of here)
> > > > > > 
> > > > > > I hope this clarifies things a bit.
> > > > > >  
> > > > > 
> > > > > Can we try this? Let me know if it resolves your issue.
> > > > > 
> > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > index 61fba2b7389b..8352f4b5dd9f 100644
> > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > @@ -3657,6 +3657,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > > > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > > > >  		return 1;
> > > > >  
> > > > > +	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
> > > > > +	    (event->status & DEPEVT_STATUS_MISSED_ISOC) && !chain)
> > > > > +		return 1;
> > > > > +
> > > > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > > > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > > > >  		return 1;
> > > > >
> > > > 
> > > > With this change it doesn't seem to crash but unfortunately the output
> > > > completely hangs after the first missed isoc. At the moment I do not understand
> > > > why this might happen. 
> > > > 
> > > 
> > > Can you capture the driver tracepoints with the change above?
> > >
> > 
> > Due to the size of the log, have sent it to directly to you.
> 
> Just got it. Thanks.
> 
> > 
> > From what I can gather from the log, with the current changes it seems that
> > after a missed isoc event few requests are staying longer than expected in the
> > started_list (not getting reclaimed) and this is preventing the transmission
> > from stopping/starting again, and opening the door for continuous stream of
> > missed isoc events that cause what appears to the user as a frozen video.
> > 
> > So one thought, if IOC bit is not set every frame, but IMI bit is, when a
> > missed isoc related interrupt occurs it seems likely that more than one trb
> > request will need to be reclaimed, but the current set of changes is not
> > handling this.
> > 
> > In the good transfer case this issue seems to be taken care of since the IOC
> > bit is not set every frame and the reclaimation will loop through every item in
> > the started_list and only stop if there are no additional trbs or if one has
> 
> It should stop at the request that associated with the interrupt event,
> whether it's because of IMI or IOC.

In this case I was concerned that if multipled queued reqs did not have IOC bit
set, but there was a missed isoc on one of the last reqs, whether or not we would
reclaim all of the requests up to the missed isoc related req. I'm not sure if
my concern is valid or not.

> 
> > its HWO bit set. Although I am a bit surprised that we are not yet seeing iommu
> > related panics here too since the trb is being reclaimed and given back even
> > the HWO bit still set, but maybe I am misunderstanding something. In my earlier
> > testing, if a missed isoc event was received and we attempted to
> > reclaim/giveback a trb with its HWO bit set, a iommu related panic would be
> > seen.
> 
> If the controller processed the TRB, it would clear the HWO bit after
> completion. There are cases which the HWO bit is still set for some
> TRBs, but the request is completed (e.g. short transfers causing the
> controller to stop processing further). That those cases, the driver
> would clear the HWO bit manually.
> 
> > 
> > Can you propose an additional change to handle freeing up the extra trbs in the
> > missed isoc case? I think that somehow the HWO bit should be checked before
> > entering dwc3_gadget_ep_cleanup_completed_request in order to avoid the trb
> > being given back too soon.
> 
> We should not check for TRBs of requests beyond the request associated
> with the interrupt event.
> 
> > 
> > Your thoughts?
> > 
> 
> The capture shows underrun, and it causes missed isoc.
> 
> Let's take a look at the first missed isoc request (req ffffff88f834db00)
> 
>            <...>-22551   [002] d..2 13985.789684: dwc3_ep_queue: ep2in: req ffffff88f834db00 length 0/49152 zsi ==> -115
>            <...>-22551   [002] dn.2 13985.789728: dwc3_prepare_trb: ep2in: trb ffffffc016071970 (E152:D149) buf 00000000ea800000 size 1x 49152 ctrl 00000461 (Hlcs:Sc:isoc-first)
> 
> Each request uses a one TRB. From above, you can see that there are only
> 3 intervals prepared (E152 - D149 = 3).
> 
> The timestamp of the last request completion is 13985.788919.
> The timestamp which the queued request is 13985.789728.
> We can roughly estimate the diff is at least 809us.
> 
> 3 intervals (3x125us) is less than 809us. So missed isoc is expected:
> 
>     irq/399-dwc3-15269   [002] d..1 13985.790754: dwc3_event: event (f9acc08a): ep2in: Transfer In Progress [63916] (sIM)
>     irq/399-dwc3-15269   [002] d..1 13985.790758: dwc3_complete_trb: ep2in: trb ffffffc016071970 (E154:D152) buf 00000000ea800000 size 1x 49152 ctrl 3e6a0460 (hlcs:Sc:isoc-first)
>     irq/399-dwc3-15269   [002] d..1 13985.790808: dwc3_gadget_giveback: ep2in: req ffffff88f834db00 length 0/49152 zsi ==> -18
> 
> 
> After this point, the uvc driver keeps playing catch up to stay in sync
> with the host. It tries, but it couldn't catch up. Also, occasionally
> something seems to be blocking dwc3, creating time gaps. Maybe because
> of a spin_lock held somewhere?
>

Could the time gaps be created by the interrupt frequency changes? They
completely change up the timing of when the transfers are kicked in dwc3 and
when uvc_video_complete/uvcg_video_pump is called.

> The logic to detect underrun doesn't trigger because the queued list is
> always non-empty, but the queued requests are expected to be missed
> already. So you keep seeing missed isoc.
> 
> There are a few things you can mitigate this issue:
> 1) Don't set IMI if the request indicates no_interrupt. This reduces the
>    time software needs to handle interrupts.

I did try this out earlier and it did not prevent the video freeze. It does
make sense what you are suggesting, but because it didn't work for me it made
me think that not all reqs are being reclaimed after a missed isoc is seen.
I'll revisit this area again.

> 2) Improve the underrun detection logic.

I like this idea a lot but I'm not up to the task just yet. Will attempt to
follow your recommendations below and see where I get with this.

> 3) Increase the queuing frequency from the uvc to keep the request queue
>    full. Note that reduce/avoid setting no_interrupt will allow the
>    controller driver to update uvc often to keep requeuing new requests.
> 
> Best option is 3), but maybe we can do all 3.
>

I think that this is our best option too. Dan provided a patch to make
the interrupt skip logic configurable in the uvc driver:
https://patchwork.kernel.org/project/linux-usb/patch/20221018215044.765044-6-w36195@motorola.com/
https://lore.kernel.org/linux-usb/20221018215044.765044-6-w36195@motorola.com/

> For 2), you can set IMI for all isoc request as it is now. On missed
> isoc, check for the TRB's scheduled uframe (from TRB info) and compare
> it to the current uframe (from DSTS) for the number of intervals in
> between. With the number of queued requests, you can calculate whether
> the gadget driver queued enough requests. If it doesn't, send End
> Transfer command and cancel all the queued requests. The next set of
> requests will be in-sync again.
> 
> BR,
> Thinh
> 
> PS. On a side note, I notice that there are reports of issue when using
> SG right? Please note that dwc3 driver only allocates 256 TRBs
> (including a link TRB). Each SG entry takes a TRB. If a request has many
> SG entries, that eats up the available TRBs. So, even though the UVC may
> queue many requests, not all of them are prepared immediately. If the
> TRB ring is full, the driver need to wait for more TRBs to free up
> before preparing more. From the log, I see that it's sending 48KB. Let's
> say the uvc splits it into PAGE_SIZE of 4KB, that would take at least 12
> TRB per request. (Side thought: I'm not sure why UVC needs SG in the
> first place with its current implementation)

On our platform I am seeing 2 items in the sg list being sent out from the uvc
driver. The 1st item in the list is a 2 byte uvc header and the 2nd item is
the 48KBs of data. To me this seems inefficient but sort of makes sense why it
was done, likely to avoid a memory copy just for the 2 byte header.  But I
share your concern here, it's possible that other users wont be so lucky and
will wind up having a lot of page sized items in the sg list.

We are also hoping to make the use of sg configurable with the change:
https://patchwork.kernel.org/project/linux-usb/patch/20221018215044.765044-7-w36195@motorola.com/
https://lore.kernel.org/linux-usb/20221018215044.765044-7-w36195@motorola.com/

Thanks,
Jeff

