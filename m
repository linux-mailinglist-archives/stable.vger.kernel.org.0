Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C79160379B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 03:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJSBlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 21:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJSBlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 21:41:14 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1821D57EA;
        Tue, 18 Oct 2022 18:41:13 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r142so13295951iod.11;
        Tue, 18 Oct 2022 18:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKSPSLWh3lKtgottX7koWWNj7uJi/W00v9wlnG0fWII=;
        b=lUQfQJ3emy3JvBLVmqv0nHukPMyIUX+g2ZqRZk8Bl7GcsSNMZi9pqnyozGxs9Z/mPl
         GSgql8GYvXR3DAeVWyhl2+WLDLZLUbK76Imfobj7e9TQ4xeuZO3goL1WdvTO3b2kj3q+
         4ybDTb0x6mIPOB2KiscAGN3NcSjPxZF7gi+MwCoy/zgVx+kpOZgwWJdlgtHJT6iQvRIS
         z7edqCvBPrcozi9kzpwiqccZIGx+wN9qY880lY9SUpytLcUiN5KtJVlIIgeWHMi20Hcn
         jMGR/weZPPo0WrOKrus5QQMmLZ3AYc67VFtm94zwKKXvyWVtEJHC9gntLrk58MtyL8Zi
         iiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKSPSLWh3lKtgottX7koWWNj7uJi/W00v9wlnG0fWII=;
        b=4Yfm5dk4vWtFe+fvWqpSwdHBuyxDNxcwtvnigcFWmJgBLwayy+4tlJu5s9XCgX+L4f
         du8qE8Sbf9T5BbuQpSi+ioHuYWpUh5auBposXDe5IYXlEof06vtkgzaW3T+303O6ERiE
         PHNCj1AH1DtQDGjBfcYSHasLAqvj8WvQiPaLGzDoNM6mfEXoa8EZYm4T5Kppycn08JhU
         nWZcxRjIGvrok1y15BlT+JNZlUddsnUirvHHBow8nqFssty5jJVxh/QO8rWOTA2y097E
         37HRxOWeoRD5rhPawmoUUBaIFTWj+/WloBaKAXhfIteK1p1+MIfAYT6R2pdGKQgHlPLo
         t7nQ==
X-Gm-Message-State: ACrzQf1BKI7bHEkPsclBGnuXNBGlSKoY/95I7wx60LVd0ZsjLbEVXeMV
        xvE0bNHyWMX0VoBuicOwssU=
X-Google-Smtp-Source: AMsMyM4VUeUEv/h8zHv7wnlYMiwfhzRcqdRhDu7rZwQUg8wIkmj59U64CtpGUCIhiZcj15Azmj+OPw==
X-Received: by 2002:a05:6602:140d:b0:68b:1bd1:1c54 with SMTP id t13-20020a056602140d00b0068b1bd11c54mr3739825iov.9.1666143673085;
        Tue, 18 Oct 2022 18:41:13 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id j9-20020a056e02014900b002f86a153f42sm1509414ilr.65.2022.10.18.18.41.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Oct 2022 18:41:12 -0700 (PDT)
Date:   Tue, 18 Oct 2022 20:41:10 -0500
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
Message-ID: <20221019014108.GA5732@qjv001-XeonWs>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
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

On Tue, Oct 18, 2022 at 10:35:30PM +0000, Thinh Nguyen wrote:
> On Tue, Oct 18, 2022, Jeffrey Vanhoof wrote:
> > Hi Thinh,
> > 
> > On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:
> > > Hi Dan,
> > > 
> > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > Hi Thinh,
> > > > 
> > > > On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:
> > > > > On Mon, Oct 17, 2022, Dan Vacura wrote:
> > > > > > From: Jeff Vanhoof <qjv001@motorola.com>
> > > > > > 
> > > > > > arm-smmu related crashes seen after a Missed ISOC interrupt when
> > > > > > no_interrupt=1 is used. This can happen if the hardware is still using
> > > > > > the data associated with a TRB after the usb_request's ->complete call
> > > > > > has been made.  Instead of immediately releasing a request when a Missed
> > > > > > ISOC interrupt has occurred, this change will add logic to cancel the
> > > > > > request instead where it will eventually be released when the
> > > > > > END_TRANSFER command has completed. This logic is similar to some of the
> > > > > > cleanup done in dwc3_gadget_ep_dequeue.
> > > > > 
> > > > > This doesn't sound right. How did you determine that the hardware is
> > > > > still using the data associated with the TRB? Did you check the TRB's
> > > > > HWO bit?
> > > > 
> > > > The problem we're seeing was mentioned in the summary of this patch
> > > > series, issue #1. Basically, with the following patch
> > > > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G_pg!aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU2HXET9O226AEN$  
> > > > integrated a smmu panic is occurring on our Android device with the 5.15
> > > > kernel which is:
> > > > 
> > > >     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled arm-smmu context fault from a600000.dwc3!
> > > > 
> > > > The uvc gadget driver appears to be the first (and only) gadget that
> > > > uses the no_interrupt=1 logic, so this seems to be a new condition for
> > > > the dwc3 driver. In our configuration, we have up to 64 requests and the
> > > > no_interrupt=1 for up to 15 requests. The list size of dep->started_list
> > > > would get up to that amount when looping through to cleanup the
> > > > completed requests. From testing and debugging the smmu panic occurs
> > > > when a -EXDEV status shows up and right after
> > > > dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion
> > > > we had was the requests were getting returned to the gadget too early.
> > > 
> > > As I mentioned, if the status is updated to missed isoc, that means that
> > > the controller returned ownership of the TRB to the driver. At least for
> > > the particular request with -EXDEV, its TRBs are completed. I'm not
> > > clear on your conclusion.
> > > 
> > > Do we know where did the crash occur? Is it from dwc3 driver or from uvc
> > > driver, and at what line? It'd great if we can see the driver log.
> > >
> > 
> > To interject, what should happen in dwc3_gadget_ep_reclaim_completed_trb if the
> > IOC bit is not set (but the IMI bit is) and -EXDEV status is passed into it?
> 
> Hm... we may have overlooked this case for no_interrupt scenario. If IMI
> is set, then there will be an interrupt when there's missed isoc
> regardless of whether no_interrupt is set by the gadget driver.
> 
> > If the function returns 0, another attempt to reclaim may occur. If this
> > happens and the next request did have the HWO bit set, the function would
> > return 1 but dwc3_gadget_ep_cleanup_completed_request would still call
> > dwc3_gadget_giveback.
> > 
> > As a test (without this patch), I added a check to see if HWO bit was set in
> > dwc3_gadget_ep_cleanup_completed_requests(). If the usecase was ISOC and the
> > HWO bit was set I avoided calling dwc3_gadget_ep_cleanup_completed_request().
> > This seemed to also avoid the iommu related crash being seen.
> > 
> > Is there an issue in this area that needs to be corrected instead? Not having
> > interrupts set for each request may be causing some new issues to be uncovered.
> > 
> > As far as the crash seen without this patch, no good stacktrace is given. Line
> > provided for crash varied a bit, but tended to appear towards the end of
> > dwc3_stop_active_transfer() or dwc3_gadget_endpoint_trbs_complete().
> > 
> > Since dwc3_gadget_endpoint_trbs_complete() can be called from multiple
> > locations, I duplicated the function to help identify which path it was likely
> > being called from. At the time of the crashes seen,
> > dwc3_gadget_endpoint_transfer_in_progress() appeared to be the caller.
> > 
> > dwc3_gadget_endpoint_transfer_in_progress()
> > ->dwc3_gadget_endpoint_trbs_complete() (crashed towards end of here)
> > ->dwc3_stop_active_transfer() (sometimes crashed towards end of here)
> > 
> > I hope this clarifies things a bit.
> >  
> 
> Can we try this? Let me know if it resolves your issue.
> 
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

With this change it doesn't seem to crash but unfortunately the output
completely hangs after the first missed isoc. At the moment I do not understand
why this might happen. 

> Thanks,
> Thinh

Note that I haven't quite learned correctly how to reply correct to the mailing
list.  I appologize for messing up the thread a bit.

Regards,
Jeff

