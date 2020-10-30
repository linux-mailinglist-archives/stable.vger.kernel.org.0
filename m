Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68582A042C
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 12:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgJ3Lcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 07:32:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55441 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3Lcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 07:32:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id c9so989016wml.5;
        Fri, 30 Oct 2020 04:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWxZEGM8Mjl+TbXGKYXD/wiQJgwiBqcn/+KIIihxQnw=;
        b=shd8ctwt3nQkn9JuvMvMtRmQbtntwuuopBHehxJo2X75uQ+ttCLBqiD+ugZ3/mhR7n
         YJKlgtLpY9lWwoDCT7bF40Zu8ph4EKidxE7QLgCiIR6/MpK3J15mXAz/jv1ItjED9hD5
         vRXG26CeQ09JU1r1MwMOl8yfLjmJCFzMHJ0GtV2b1c/ThCZ9kMYU2bt6c51pUP+x9i3q
         xtpl7RL4A6A/lBC22z0NFFyj6NfkLZJD4JTnab0yuq29XlvULg95FwXs/Fd2Oyrdr/NE
         Rzi7/sVozlQS5WavnzFZrnAScO0zFFCnjtHzksXGyGAi9ajqi78fN7Bhi+fpMPZT6MS/
         Wl2g==
X-Gm-Message-State: AOAM533AKwJC7J7SS20IBxJMGxtyexnqqmkNAdRXm+x1qE3o1ndd5K5c
        B85vRQAejFRckVop+rSruLk=
X-Google-Smtp-Source: ABdhPJwwHqB3BEQIeMIf/nmbkyagY84VdjPY1peaY3lyZD4J5Jl39iRuGW00HXOneV7L2mqS8d/A2A==
X-Received: by 2002:a1c:44d4:: with SMTP id r203mr2281889wma.152.1604057528199;
        Fri, 30 Oct 2020 04:32:08 -0700 (PDT)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id f20sm4417839wmc.26.2020.10.30.04.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 04:32:06 -0700 (PDT)
Date:   Fri, 30 Oct 2020 12:32:05 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
Message-ID: <20201030113205.GB36162@kozik-lap>
References: <20201028091947.93097-1-krzk@kernel.org>
 <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
 <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
 <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com>
 <20201028100311.GF26150@paasikivi.fi.intel.com>
 <CAJKOXPcjtZidY1prH1ZCj+i-SM1mhABGbS_6_g1cH5WSGVhOAA@mail.gmail.com>
 <CAAFQd5AwvuuxekSdDnHNB7KiC7+mHFisEkCW71F3XQMWaFqamw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAFQd5AwvuuxekSdDnHNB7KiC7+mHFisEkCW71F3XQMWaFqamw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 01:08:28PM +0100, Tomasz Figa wrote:
> On Wed, Oct 28, 2020 at 11:15 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Wed, 28 Oct 2020 at 11:03, Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> > >
> > > On Wed, Oct 28, 2020 at 10:56:55AM +0100, Krzysztof Kozlowski wrote:
> > > > On Wed, 28 Oct 2020 at 10:45, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > >
> > > > > On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
> > > > > >
> > > > > > But the sensor settings for the original submission is to output GRBG Bayer RAW.
> > > > > >
> > > > > > Regards, Andy
> > > > >
> > > > > No, not to my knowledge. There are no settings for color output
> > > > > because it is fixed to GBGB/RGRG. I was looking a lot into this driver
> > > > > (I have few other problems with it, already few other patches posted)
> > > > > and I could not find a setting for this in datasheet. If you know the
> > > > > setting for the other color - can you point me to it?
> > > >
> > > > And except the datasheet which mentions the specific format, the
> > > > testing confirms it. With original color the pictures are pink/purple.
> > > > With proper color, the pictures are correct (with more green color as
> > > > expected for bayer).
> > >
> > > Quoting the driver's start_streaming function:
> > >
> > >         /* Set Orientation be 180 degree */
> > >         ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> > >                                IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
> >
> > I understand that you think it will replace the lines and columns and
> > the first line will be RG, instead of GB.... or actually BG because it
> > flips horizontal and vertical? So why does it not work?
> 
> Any chance your SoC capture interface performs this flipping on its own as well?

I messed up GStreamer as well. The color mode is correct in the driver.

> 
> >
> > BTW, this nicely points that the comment around
> > device_property_read_u32() for rotation is a little bit misleading :)
> >
> 
> Are you referring to the comment below?
> 
> /*
> * Check that the device is mounted upside down. The driver only
> * supports a single pixel order right now.
> */
> ret = device_property_read_u32(&client->dev, "rotation", &val);
> if (ret || val != 180)
>     return -EINVAL;
> 
> What's misleading about it?

It's interpretation. To me the comment does not say that device
*have to* be mounted upside down. To me, it says that from all rotations
(90, -90, 180), it supports only upside down, except of course normal
mounting (no rotation).

Best regards,
Krzysztof
