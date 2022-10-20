Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1236069E6
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 22:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJTUxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 16:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJTUxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 16:53:15 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4CB21F97E;
        Thu, 20 Oct 2022 13:53:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id q196so645516iod.8;
        Thu, 20 Oct 2022 13:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRXB8z1wA0QYGeZ71IIj5sPC7n+lzP9BStTEcmN0Y6I=;
        b=dT6fUrbtU/cwXDCGhloC9Wc8fgDHAXwGtizMyhGBISi5a5p4RL5E43UXmHKEu50RRC
         siv9w+OEPnHz3nzTeiWdjZSxSDbTtwerrsz+HxdokVmSToWIPr9Lncb3u0poVz//2Ofg
         xOKwvUuWhfNZGu7ByWL1lpwwojBPkTHnclKL137KoZ0cupkL/rE0+mVsdR4eV6CNJFWO
         GNNOMMchB5mn+x//tLNJK9cdMl4G/GPVsZ44PGbTCvnJYXmCAXUS3iLW922JFRLrwa7T
         uhpOE4hPc0r88uql6xiay0Tz4KeCGHmf+dJ7UlYCGIZ2a88Mca6Ze3Vq2Jzg3oPEsur3
         5r0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eRXB8z1wA0QYGeZ71IIj5sPC7n+lzP9BStTEcmN0Y6I=;
        b=jvhQMCLeo61xSB/LiJpOtuZybc8i1H60E6t6RtIkMZIJL1y+qjfQ9OPPNRfWmsuKCf
         Lxj8miLJEJXx1vSmLcW4efairlIXmFazGIlECYfshEIHrD2tNfOKjIVh+pHamhhb2NT7
         drAHeEA76013y5JtZGoq83+E2I2V7N4uhLUGksueKMfM6SLXAiZlys5uCs7AnUec0YdD
         K3BcOdGNBntbKwMk2SUbyTqE39hhAsGMvaQ0ZjIkpHRw/IknYEOaV8pXwwRHH/2sYHRo
         JDCmi44fljD0cDGAlH3Dyhvrra4Qclz9V88HM93t2tWm8IPTps4k2H4VE+brvysmAPoQ
         /KBQ==
X-Gm-Message-State: ACrzQf2kXHFMd1vg9a9X6OK7Uq8vIuP3I9GOVYKt/Emjl/nWWJCz4770
        pxS+aUtU+U+lLm2RnCOdnIjnl6Js0k+ydSAm
X-Google-Smtp-Source: AMsMyM4fYpJLq83Xs6AM6+hJFRwiP0pC3bRijtZSGdRJCQyTCuqQW1UeY80460TTg5M5amU/ebn/tg==
X-Received: by 2002:a05:6602:2d08:b0:6bc:15d8:3445 with SMTP id c8-20020a0566022d0800b006bc15d83445mr10268455iow.96.1666299193185;
        Thu, 20 Oct 2022 13:53:13 -0700 (PDT)
Received: from qjv001-XeonWs (c-67-167-199-249.hsd1.il.comcast.net. [67.167.199.249])
        by smtp.gmail.com with ESMTPSA id n35-20020a056602342300b006bbf0466587sm3693514ioz.49.2022.10.20.13.53.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Oct 2022 13:53:12 -0700 (PDT)
Date:   Thu, 20 Oct 2022 15:53:10 -0500
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
Message-ID: <20221020205308.GA6319@qjv001-XeonWs>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
 <20221019230555.gwovdtmnopwacirt@synopsys.com>
 <20221020164732.GA25496@qjv001-XeonWs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020164732.GA25496@qjv001-XeonWs>
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

> On Wed, Oct 19, 2022 at 11:06:08PM +0000, Thinh Nguyen wrote:
> > Hi,
> >

<snip>

> > > 
> > > > The logic to detect underrun doesn't trigger because the queued list is
> > > > always non-empty, but the queued requests are expected to be missed
> > > > already. So you keep seeing missed isoc.
> > > > 
> > > > There are a few things you can mitigate this issue:
> > > > 1) Don't set IMI if the request indicates no_interrupt. This reduces the
> > > >    time software needs to handle interrupts.
> > > 
> > > 
> > > > 2) Improve the underrun detection logic.
> > > 
> > > 
> > > > 3) Increase the queuing frequency from the uvc to keep the request queue
> > > >    full. Note that reduce/avoid setting no_interrupt will allow the
> > > >    controller driver to update uvc often to keep requeuing new requests.
> > > > 
> > > > Best option is 3), but maybe we can do all 3.
> > > >
> > >

I forgot about your option 2. Will start looking into it.

Thanks,
Jeff

