Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41CB60D538
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiJYUGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiJYUF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 16:05:59 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B008E442;
        Tue, 25 Oct 2022 13:05:32 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y80so11469751iof.3;
        Tue, 25 Oct 2022 13:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNLZ8ELUxEq7F3U8ZFTdx4pak1mGMbUkw1ZaAEnhXdY=;
        b=H9QeFnHxgR2T8g9u77O1DwVip9J1uKKUm1iGOaakveLOMVHkcwaQ+JUKVtzW7/ZOmM
         9MyFxAMtPUyNsE1jGt6NELiZF25PfK/VoTDf6mzZyvnhMRYdt2nt7MIrZqj/W0poD1Zh
         Bovp/w35aomW00Nf6rH24i8FJMh7lxvKmsMFDFseKrS3VTve/S85Ry3qzT0KhCF/fSzT
         8P+2VJ1cOnC5Kt4eBKIuwSduzVpWi/hS0PdvwL79lFQK7IvwFPYzkpd8ct/1vJVFZXF2
         dGJY/JGGIiTZ+xLHq36T9Qxwt8vrnzlsZGTQjdMuoCQucJxRKBiJu5rMFZbLhWeB5SIZ
         c6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNLZ8ELUxEq7F3U8ZFTdx4pak1mGMbUkw1ZaAEnhXdY=;
        b=0D/94zc8eVbdTXcbJAPVGjMnf0uj+6uVzhiqenfJynCNmw1g4hTvBPNLXkUNQOVVuc
         Brn/k5NFod+KCHQ3LyeWHJKSijAtPc8W60D9z2NOmz8XWEBUeHGHRt4kKl+1bnY0EjYG
         I/kT/lfseWA8qHw6Siaj5/Vt1BKQDXk5FGS6/5mJyB96EaRHVQUCGpdOVVWUK3L55Dyp
         Tq80nYMDk3TOksCMqTzTwyUxvV1j5DLtTmUttXICn1dc/yF/LA+BvftqIgJzSupPLl0W
         oH8A7D7RI2FZN92myNhzF6CVtJEnTQ6TpKLK1XnlN3AqxqJ/bAtZrL/4pHAFtQ9YBPMn
         eS7w==
X-Gm-Message-State: ACrzQf1FJccqJV6saZl0/livMz4ZxFGxQgW5NSjgbEc/n3wW/c6Qw247
        Bm+ouYJnR3tYcUnGWJ9QJhI=
X-Google-Smtp-Source: AMsMyM7Hfa8aC3dLNmmrbIAPrM8txNoMVN+0cnB2htagHjCstWHvGG6YtHfXeTtikDe2cNxpW+Xxyw==
X-Received: by 2002:a05:6638:d0d:b0:374:60f4:52b5 with SMTP id q13-20020a0566380d0d00b0037460f452b5mr299890jaj.59.1666728332047;
        Tue, 25 Oct 2022 13:05:32 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id h18-20020a056e021d9200b002f68a98e1c2sm1319465ila.50.2022.10.25.13.05.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Oct 2022 13:05:31 -0700 (PDT)
Date:   Tue, 25 Oct 2022 15:05:29 -0500
From:   Jeff Vanhoof <jdv1029@gmail.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: Re: [PATCH v2 2/2] usb: dwc3: gadget: Don't set IMI for no_interrupt
Message-ID: <20221025200527.GA11641@qjv001-XeonWs>
References: <cover.1666661013.git.Thinh.Nguyen@synopsys.com>
 <453f4dc3189eb855e31768d5caa6bfc7f4bf5074.1666661013.git.Thinh.Nguyen@synopsys.com>
 <20221025045148.GA15715@qjv001-XeonWs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025045148.GA15715@qjv001-XeonWs>
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

On Mon, Oct 24, 2022 at 11:51:50PM -0500, Jeff Vanhoof wrote:
> On Mon, Oct 24, 2022 at 06:28:04PM -0700, Thinh Nguyen wrote:
> > The gadget driver may have a certain expectation of how the request
> > completion flow should be from to its configuration. Make sure the
> > controller driver respect that. That is, don't set IMI (Interrupt on
> > Missed Isoc) when usb_request->no_interrupt is set.
> > 
> > Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> > ---
> >  Changes in v2:
> >  - None
> > 
> >  drivers/usb/dwc3/gadget.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 230b3c660054..702bdf42ad2f 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -1292,8 +1292,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
> >  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
> >  		}
> >  
> > -		/* always enable Interrupt on Missed ISOC */
> > -		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> > +		if (!req->request.no_interrupt)
> > +			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> >  		break;
> >  
> >  	case USB_ENDPOINT_XFER_BULK:
> > -- 
> > 2.28.0
> >
> 
<snip>

For scatter gather, shouldn't the IMI bit be set only for the TRB associated
to the last item in the sg list?  Do we need to do something similar to what
that was done for IOC in this area?

For ex.:
+	if ((!req->request.no_interrupt && !chain) || must_interrupt)
+		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;

BTW, Dan indicated that this seems to help resolve the crash mentioned in
[PATCH v2 1/2] of this chain.

Thanks,
Jeff

