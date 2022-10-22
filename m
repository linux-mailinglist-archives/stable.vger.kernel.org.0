Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59073608D6D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJVNft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 09:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJVNfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 09:35:48 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9F9B0B28;
        Sat, 22 Oct 2022 06:35:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h203so4467181iof.1;
        Sat, 22 Oct 2022 06:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLFJLqlhGPX1tCC+C1NWXqzTL8afrRkDZh5VaUzSxpI=;
        b=KXqRlbioEBoTo29NGQ75QoQRir4Z3F61DvWf5DzwnsTgBPhXFZ6cJG6cFuqeRSkTZE
         4RzlqxvaXfB+nLdb0DoLJPsqhAp6jT+YVB+NlbmMdRz8E08uIDBTfsGEfLLhssyvdbGm
         87WJWNFz1O6BHrmNQhHr3ig0rTsI+QAdIyFImaWk4wLF9uzhRuZEo4HuloKTNpPDkv1O
         g3PSv2/dOFOxYHpCHftebRB7y3fgzD86fDvJtNbYEjp1nba8D1lNJDEd/Swtbc2DnSBT
         Y+9xW2z/g3LG24xwE1+P8C68kJ7SZ50XEYTq8E2cEJe/HhvNziHcJOo4QiZnwXqpax2z
         iFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLFJLqlhGPX1tCC+C1NWXqzTL8afrRkDZh5VaUzSxpI=;
        b=XDnIItE3bcqnfRlE64cRF7/eUhEON69hieywd21FBK0KtGMFr8ESpR3/x2nghPkSM3
         0KEhhocvRX6gNbyESH0eNvhOACw3gvtiZOgk++DJRxeq5QhTryqd8/h9m0SyUJv0bMPY
         qWx03tdXvuYt/ANNL682Yj7pyl/T61PInYPJ9cTpbx0MOhmmNMWtNt61NJg/666bXxJ3
         iez/Qps2apRItGedTZ+ixfrc7AcrOP7UT7Md3MeHMMrdtFzjvLmUHYD5T74igKW54bmj
         de4LC8r+sGi6/q+MJtSBbVkWvd0KcY6fmYgmfc4NlrIQFbq+/OjAViF8uGMzpQgSYufM
         NU/g==
X-Gm-Message-State: ACrzQf2pNiLbrWoScVdpTqBwyTA2DErFJunRjyhus++B2AYZEcljSMra
        dOATaHkgj13hmm/n/HftboQ=
X-Google-Smtp-Source: AMsMyM4obJwtc8x2liWuHgZ0A3FTLPLGffRFQwNkxV6RQNcbuXkeJoHP3RVt+CBh2Pt2CAOtTEvX+A==
X-Received: by 2002:a05:6638:32a2:b0:364:de6:cdbe with SMTP id f34-20020a05663832a200b003640de6cdbemr15731069jav.73.1666445746092;
        Sat, 22 Oct 2022 06:35:46 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id y20-20020a056638229400b00363dee286edsm5386977jas.60.2022.10.22.06.35.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Oct 2022 06:35:45 -0700 (PDT)
Date:   Sat, 22 Oct 2022 08:35:43 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dan Vacura <w36195@motorola.com>, linux-usb@vger.kernel.org,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Message-ID: <20221022133541.GA26431@qjv001-XeonWs>
References: <20221018215044.765044-1-w36195@motorola.com>
 <20221018215044.765044-3-w36195@motorola.com>
 <Y1PUjO99fcgaN0tc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1PUjO99fcgaN0tc@kroah.com>
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

Hi Greg,

On Sat, Oct 22, 2022 at 01:31:24PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Oct 18, 2022 at 04:50:38PM -0500, Dan Vacura wrote:
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
> > 
> > Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Jeff Vanhoof <qjv001@motorola.com>
> > Co-developed-by: Dan Vacura <w36195@motorola.com>
> > Signed-off-by: Dan Vacura <w36195@motorola.com>
> > ---
> > V1 -> V3:
> > - no change, new patch in series
> > V3 -> V4:
> > - no change
> 
> I need an ack from the dwc3 maintainer before I can take this one.
> 
> thanks,
> 
> greg k-h

Thinh has rejected this version of the patch. He has provided an alternative
implementation which has been testing well for us so far. Either Thinh or Dan
will formalize this patch within the next few days.
The latest proposed changes are:

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


Thanks,
Jeff

