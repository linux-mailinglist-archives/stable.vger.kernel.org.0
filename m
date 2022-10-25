Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A460D37E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJYSWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiJYSWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 14:22:14 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AF4DD89D;
        Tue, 25 Oct 2022 11:22:13 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id s17so8682233qkj.12;
        Tue, 25 Oct 2022 11:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03UT5t/fYdE/VyZRSDmwX+UU/pnZJIK2pz1Plq4mrr8=;
        b=DfjpEeCvsb8iuHcfRdVkLxWOtuOmW3CJJm3VgzBwYEFxJztyrl6E4qFfcFwru9i0Ae
         2Sd/4JpyoVFQCJkybtX0Ikqka6DoeSW1bBc93QBBzS9vpZbu3HMUKehH5Yt9E93iAx3/
         ZK9P7IR6e6yaFQlb4gRn3LNRh21W+gnXiTxzQU2bWaO60Jhbny8q5YoMsVbUnEDc9B7e
         OzpDbL8up2tGXTRNYZNSOG89Hl2m9f99ZXy0ydZcdvgFQJefahZagm37VhfNDaTFSEU/
         YetrypkKBhmzqWrU4zPKuAAyXgqmRRZb48h2Bz+yV8cTyTSFikKBVcuBc0jKtT9Np7JJ
         qQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=03UT5t/fYdE/VyZRSDmwX+UU/pnZJIK2pz1Plq4mrr8=;
        b=BSs1Q50ROQAZH/lrFB/bDM/kzbKinqC6O7CN8CH4l6sxcuoCFnOnkSZF/eNci1BDcQ
         +I4OgRzgsO93+tykbthxMvwIvhL+smq6V3XuPjBU/H6phvP2X54sbsHOUk8MDlvBSkY2
         e8STavKnjRlR7NIY73hV9vipO4w9V+G6Da/aQC/0pxtyKAML9tVvBwN7jzhuxeNupUoc
         zLdT7LdT4/jBWrGmDZmaPyRKV+906HmdLBKxG0+BWck8k65JTfy5iuFPl17eWnGeA4F0
         N9ptKQfkkQ+oNQAAze6emhpaPKo31OojKE18+gWyHJsmRWwr+Sv/OskmYKdJcA1dybU8
         jxHQ==
X-Gm-Message-State: ACrzQf35NBVU7LLW+mSC3+io9azZ7NTe0TcZvKO3c3tY4YEqfXhi2Y+B
        kqiQZORF38AS4No9UYS4euZeWkFNkfhLAtZX
X-Google-Smtp-Source: AMsMyM5QXd/yteCqTbbzG5kZdrzc5KazvGAOucqMxF04knCksB8KSuLkmVApVVBy/kj/VSim5V89GA==
X-Received: by 2002:ae9:e115:0:b0:6ee:bcbb:396 with SMTP id g21-20020ae9e115000000b006eebcbb0396mr27870289qkm.668.1666722132160;
        Tue, 25 Oct 2022 11:22:12 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id m8-20020a05620a290800b006ce40fbb8f6sm2584820qkp.21.2022.10.25.11.22.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Oct 2022 11:22:11 -0700 (PDT)
Date:   Tue, 25 Oct 2022 13:22:09 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Stop processing more requests
 on IMI
Message-ID: <20221025182207.GA8539@qjv001-XeonWs>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <699a342b618611be834b06d9d64abae7d01486cd.1666661013.git.Thinh.Nguyen@synopsys.com>
 <20221025044545.GA12741@qjv001-XeonWs>
 <20221025164235.GA5795@qjv001-XeonWs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025164235.GA5795@qjv001-XeonWs>
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

On Tue, Oct 25, 2022 at 11:42:37AM -0500, Jeff Vanhoof wrote:
> Hi Thinh,
> 
> On Mon, Oct 24, 2022 at 11:45:48PM -0500, Jeff Vanhoof wrote:
> > On Mon, Oct 24, 2022 at 06:27:57PM -0700, Thinh Nguyen wrote:
> > > When servicing a transfer completion event, the dwc3 driver will reclaim
> > > TRBs of started requests up to the request associated with the interrupt
> > > event. Currently we don't check for interrupt due to missed isoc, and
> > > the driver may attempt to reclaim TRBs beyond the associated event. This
> > > causes invalid memory access when the hardware still owns the TRB. If
> > > there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
> > > to stop servicing further.
> > > 
> > > Note that only the last TRB of chained TRBs has its status updated with
> > > missed isoc.
> > > 
> > > Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
> > > Reported-by: Dan Vacura <w36195@motorola.com>
> > > Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> > > ---
> > >  Changes in v2:
> > >  - No need to check for CHN=0 since only the last TRB has its status
> > >    updated to missed isoc
> > > 
> > >  drivers/usb/dwc3/gadget.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index dd8ecbe61bec..230b3c660054 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -3248,6 +3248,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> > >  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
> > >  		return 1;
> > >  
> > > +	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
> > > +	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
> > > +		return 1;
> > > +
> > >  	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > >  	    (trb->ctrl & DWC3_TRB_CTRL_LST))
> > >  		return 1;
> > > -- 
> > > 2.28.0
> > >
> > 
> > Testing shows that the changes appear to work to prevent the arm-smmu panic I
> > was seeing after missed isoc errors. Also, changes to reclaim trbs only up to
> > the associated interrupt event make sense.
> > 
> > Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
> > Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
> > 
> > Regards,
> > Jeff
> > 
> 
> I just followed up with Dan and he mentioned that he was still seeing the arm-smmu panic on his baseline. I will work with him this afternoon to better understand what may be going on there. Let's hold off on merging these changes in until we figure out what is going on. He and I are testing off of different baselines (5.10 vs 5.15), different USB speeds (USB 3 vs 2), and are using different hardware, so I don't know yet why we are seeing a difference here.
> 
> Regards,
> Jeff
> 

Between the changes for PATCH v2 1/2 & PATCH v2 2/2, are there any extra
precautions required for when scatter gather is in use? Should the IMI bit be
set only for the last item in the sg list? I suspect something in this area but
I have no proof yet. Your thoughts?

Thanks,
Jeff



