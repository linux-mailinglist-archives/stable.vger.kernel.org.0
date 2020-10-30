Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C42A0422
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 12:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3L34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 07:29:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41818 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJ3L34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 07:29:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id s9so6052469wro.8;
        Fri, 30 Oct 2020 04:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LhExkFKP0pOFWSZ28CiIxBi5YE3jihKe7GINR2GtFFc=;
        b=OOtCEEjMBa76vAm6p2bm4jw6EOqqgGmsaa8WNq7POFZW3qdYMXnW5S9XAsdwixVpdS
         b43+EGYhdxEpZM9c8II9kpjoIpPPxTepCY3bhDOXcxyCSmuyqwUrAu8rWTm/z0sVFRAk
         Iv4UeshiVcby53yJD76VaAKKJLOwruD+x0p2iPH5ElERaGk+pzpPvWreeVxVl06BhvJS
         JtRea0eWy7slc9pnjO1yBRYC4hq/bI4vAGHptUbddmFJI7IbebM0eD9uhdw6nwcuVDz7
         810wBUBif451xXxhl04jWLMHJDB04NJAUZ+vEbFTWB1mHfDJAUpyOfXICRrGthWewFPf
         J5xg==
X-Gm-Message-State: AOAM532uBBlg2JkpX2i+CaXMozeDtrdark5ecZC5xItqTrVg+wZPFj0l
        CIxpG04WY2U0sqgkpFGbLLs=
X-Google-Smtp-Source: ABdhPJyErWzEU5RBjEU1E36KUDPMtyEIj6QpRknkOU3p7AqVYIWHHoy4TqP0nRLVQrpt/1pkLydx5g==
X-Received: by 2002:adf:deca:: with SMTP id i10mr2608162wrn.96.1604057392866;
        Fri, 30 Oct 2020 04:29:52 -0700 (PDT)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id 1sm11230659wre.61.2020.10.30.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 04:29:51 -0700 (PDT)
Date:   Fri, 30 Oct 2020 12:29:50 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "Yeh, Andy" <andy.yeh@intel.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
Message-ID: <20201030112950.GA36162@kozik-lap>
References: <20201028091947.93097-1-krzk@kernel.org>
 <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
 <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
 <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com>
 <20201028100311.GF26150@paasikivi.fi.intel.com>
 <MWHPR11MB0046CCA70D68CE1F3BA4FA4287170@MWHPR11MB0046.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MWHPR11MB0046CCA70D68CE1F3BA4FA4287170@MWHPR11MB0046.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:14:52AM +0000, Yeh, Andy wrote:
> >-----Original Message-----
> >From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >Sent: Wednesday, October 28, 2020 6:03 PM
> >To: Krzysztof Kozlowski <krzk@kernel.org>
> >Cc: Yeh, Andy <andy.yeh@intel.com>; Mauro Carvalho Chehab
> ><mchehab@kernel.org>; Tomasz Figa <tfiga@chromium.org>; Jason Chen
> ><jasonx.z.chen@intel.com>; Alan Chiang <alanx.chiang@intel.com>; linux-
> >media@vger.kernel.org; linux-kernel@vger.kernel.org;
> >stable@vger.kernel.org
> >Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
> >
> >On Wed, Oct 28, 2020 at 10:56:55AM +0100, Krzysztof Kozlowski wrote:
> >> On Wed, 28 Oct 2020 at 10:45, Krzysztof Kozlowski <krzk@kernel.org>
> >wrote:
> >> >
> >> > On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
> >> > >
> >> > > But the sensor settings for the original submission is to output GRBG
> >Bayer RAW.
> >> > >
> >> > > Regards, Andy
> >> >
> >> > No, not to my knowledge. There are no settings for color output
> >> > because it is fixed to GBGB/RGRG. I was looking a lot into this
> >> > driver (I have few other problems with it, already few other patches
> >> > posted) and I could not find a setting for this in datasheet. If you
> >> > know the setting for the other color - can you point me to it?
> >>
> >> And except the datasheet which mentions the specific format, the
> >> testing confirms it. With original color the pictures are pink/purple.
> >> With proper color, the pictures are correct (with more green color as
> >> expected for bayer).
> >
> >Quoting the driver's start_streaming function:
> >
> >        /* Set Orientation be 180 degree */
> >        ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> >                               IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
> >        if (ret) {
> >                dev_err(&client->dev, "%s failed to set orientation\n",
> >                        __func__);
> >                return ret;
> >        }
> >
> >Could it be you're taking pictures of pink objects? ;-)
> >
> >--
> >Sakari Ailus
> 
> Sakari is right. IIRC since the default sensor settings outputs in GBRG, and after mirro/flip (it is the original application when submit the driver) the bayer order will be GRBG.

Yes, you are all right. It seems I was using wrong color mode for
Gstreamer, or I messed up something more.

Thanks for help everyone!

The patch can be dropped.

Best regards,
Krzysztof

