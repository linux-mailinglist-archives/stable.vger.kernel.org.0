Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C7A6020F6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 04:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJRCMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 22:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiJRCL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 22:11:58 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8202FC1A;
        Mon, 17 Oct 2022 19:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666059058; i=@motorola.com;
        bh=bWbseZyMT0mhAWISp8QtRlBOko+IcIZBICOcJ2QjeiY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=D/wvQqvUDRg6Na1AFTVXKS/r7ZxyUpMH1gJfqCaZQacc7GUl4akwh7RAOVMlxWiCW
         N+pGxml+Ow2rRPesHATJMvkHIn/7lnpeiklTzfiitT1fWZxYlTlJ9T/lS+ikJ6F/YC
         rBq6OSJ++HvD/74LacIGn3BmRH7m45mqqTB0aY2CYUF4SKmXVArIfczN2GVNWO4nMA
         z1fn3AJ1HC3WtdEIuX7BqiLOahNOxjiLbc6H7IzGebrw5rNPFUMsvqTwbfLszYVJN1
         e4aGq5iVWftHkiiuSnnVGUYXLolLfAbrh5FkphI72b3JB6n89hOQSiqhg0nIZcJCS7
         pm5ZMgOTVlmvw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleJIrShJLcpLzFFi42KZsKfBWdeQ2y/
  Z4McqdotjbU/YLZ4caGe06F22h82iefF6NovOiUvYLRa2LWGxuLxrDpvFomWtzBZb2q4wWfz4
  08dssWDjI0aLVQsOsDvweMzumMnqsWlVJ5vH/rlr2D0W901m9ej/a+CxZf9nRo/Pm+QC2KNYM
  /OS8isSWDNuLDrAVvBAsmLj912MDYxrRLsYuTiEBKYxSczaNZ0dwlnMJLH0yzrGLkZODhYBVY
  mNp+8xgdhsAmoSC16vYgaxRQR0JA6cOM8E0sAscIxF4t/2aWwgCWGBFIkD0xeA2bwCyhL9Dxr
  YIKbOYJTY/+oLM0RCUOLkzCcsIDazgJbEjX8vgSZxANnSEsv/cYCEOQWsJS5cmMM0gZF3FpKO
  WUg6ZiF0LGBkXsVoWpxaVJZapGupl1SUmZ5RkpuYmaOXWKWbqFdarJuaWFyia6SXWF6sl1pcr
  FdcmZuck6KXl1qyiREYGSlFLsk7GC8s+6N3iFGSg0lJlLdjhm+yEF9SfkplRmJxRnxRaU5q8S
  FGGQ4OJQne/Rx+yUKCRanpqRVpmTnAKIVJS3DwKInw5nACpXmLCxJzizPTIVKnGHU5zu/cv5d
  ZiCUvPy9VSpw3kguoSACkKKM0D24ELGFcYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTM+xpk
  FU9mXgncpldARzABHZGx3wvkiJJEhJRUA9NZo3wVpqlbVyW72t/ePvv7N453Wz5+aQ8/vaI3S
  nmLibplYOabH11c11c5tvQyFDb9eyL1c0tJ5Ate16y+LZbvbCbVzZz//8bmQ4rtXM8KawzYIn
  719xdM97tu5Xwv27u8pP9+VJEEd1DuA9mOZWfs9W6d7T+0zfL1ksP3pY2+/LMq0VWOLy9Nf77
  h2D+r53+/TupWs9onVPC6v8A8se6fmp3c1V27Xkpk9U/j0o349WO9e8vzyrtBv9epH8wVexo/
  k994wqsfz0u1DrJ7zvY3PiiZ1HByzv3GibrZu2ZP15devIJP8vWp+x3yiaIJB+tOHWENeD9De
  7nfr73ijguselaWvVhmaGodvs45VFaJpTgj0VCLuag4EQCbiHtTkwMAAA==
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-14.tower-715.messagelabs.com!1666059056!10330!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29552 invoked from network); 18 Oct 2022 02:10:57 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-14.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 02:10:57 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mry5D4LYyzfBZq;
        Tue, 18 Oct 2022 02:10:56 +0000 (UTC)
Received: from p1g3 (unknown [10.45.7.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4Mry5C6hL3zf6Wg;
        Tue, 18 Oct 2022 02:10:55 +0000 (UTC)
Date:   Mon, 17 Oct 2022 21:10:49 -0500
From:   Dan Vacura <w36195@motorola.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Message-ID: <Y04K/HoUigF5FYBA@p1g3>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
 <20221017213031.tqb575hdzli7jlbh@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017213031.tqb575hdzli7jlbh@synopsys.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thinh,

On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
> On Mon, Oct 17, 2022, Dan Vacura wrote:
> > From: Jeff Vanhoof <qjv001@motorola.com>
> > 
> > arm-smmu related crashes seen after a Missed ISOC interrupt when
> > no_interrupt=1 is used. This can happen if the hardware is still using
> > the data associated with a TRB after the usb_request's ->complete call
> > has been made.  Instead of immediately releasing a request when a Missed
> > ISOC interrupt has occurred, this change will add logic to cancel the
> > request instead where it will eventually be released when the
> > END_TRANSFER command has completed. This logic is similar to some of the
> > cleanup done in dwc3_gadget_ep_dequeue.
> 
> This doesn't sound right. How did you determine that the hardware is
> still using the data associated with the TRB? Did you check the TRB's
> HWO bit?

The problem we're seeing was mentioned in the summary of this patch
series, issue #1. Basically, with the following patch
https://patchwork.kernel.org/project/linux-usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/
integrated a smmu panic is occurring on our Android device with the 5.15
kernel which is:

    <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled arm-smmu context fault from a600000.dwc3!

The uvc gadget driver appears to be the first (and only) gadget that
uses the no_interrupt=1 logic, so this seems to be a new condition for
the dwc3 driver. In our configuration, we have up to 64 requests and the
no_interrupt=1 for up to 15 requests. The list size of dep->started_list
would get up to that amount when looping through to cleanup the
completed requests. From testing and debugging the smmu panic occurs
when a -EXDEV status shows up and right after
dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion
we had was the requests were getting returned to the gadget too early.

> 
> The dwc3 driver would only give back the requests if the TRBs of the
> associated requests are completed or when the device is disconnected.
> If the TRB indicated missed isoc, that means that the TRB is completed
> and its status was updated.

Interesting, the device is not disconnected as we don't get the
-ESHUTDOWN status back and with this patch in place things continue
after a -EXDEV status is received.

> 
> There's a special case which dwc3 may give back requests early is the
> case of the device disconnecting. The requests should be returned with
> -ESHUTDOWN, and the gadget driver shouldn't be re-using the requests on
> de-initialization anyway.
> 
> We should not issue End Transfer command just because of missed isoc. We
> may want issue End Transfer if the gadget driver is too slow and unable
> to feed requests in time (causing underrun and missed isoc) to resync
> with the host, but we already handle that.

Hmm, isn't that what happens when we get into this
condition in dwc3_gadget_endpoint_trbs_complete():

	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
		list_empty(&dep->started_list) &&
		(list_empty(&dep->pending_list) || status == -EXDEV))
		dwc3_stop_active_transfer(dep, true, true);

> 
> I'm still not clear what's the problem you're seeing. Do you have the
> crash log? Tracepoints?
> 
> BR,
> Thinh

Appreciate the support!

Dan
