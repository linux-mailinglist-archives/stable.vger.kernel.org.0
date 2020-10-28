Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB3529E281
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgJ2CRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 22:17:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39380 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgJ1VfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:35:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id y12so615481wrp.6
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 14:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6y4QOceXe8zRQKZs06ORTkquPOtHQn77ARvbGZP9r1M=;
        b=gFRUCQCFuTR8+JtdmcXcAlK5X7E61XmvvyAGA/K18mnTt93AI2o+wSqfYUI4n8Y0lU
         +48KACrQVO3Qw2aB5MwS/gPxeoLzJZw2XI2pEtuKlzoaB/ELqONtZsDRg2xOHXNYJiB6
         ur5YGrTWS0kXoutcPvKSjtwakbK/45cyXDu+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6y4QOceXe8zRQKZs06ORTkquPOtHQn77ARvbGZP9r1M=;
        b=iWzKCpk0By3rKZ1L26kixWK0LGnKjwgO2Q1371bEZ6W7aMfwB042ygPkNYFGFvPTet
         ob9NvxRSxdhr/fyyK5J2cwej0xNdXRyM9d1T+Rj/MEp0KfV/pzlxoc2xmuvQ+Rk+XtCr
         ye89IA8mPnp2aeEh+koyu+v1OTIjHoCHbKhkVYAL+07+Wm3Uc6f2fsO096pDuRtlTc4z
         bjrHnhJLJNcB+pUbdO6NifeioyfM1LuFJ6xJrWvnuzpspQHt5lUnk9uX4x42ifpyniA4
         LjViR/6Wu8Vb39JF0jj050xvO22ZoJFP8o3te90V5Ur3tVIpSKnnBXefKp+4pL5CM3UM
         Xtdg==
X-Gm-Message-State: AOAM531voVWIla7u+lsxwNjwZvWQ8tCO8b6/m2Pu+WDzsvdG+dhW2m0C
        sCbLnO3tiP0bnPS2anqzGx4cTLvDL5nN5Q==
X-Google-Smtp-Source: ABdhPJwVow+W7Cs1dVg5itA4nHI/7GCqMNB6ky+XEBiyaFeBtCDK082l59S/zmg9q3jjmNTnff4k9A==
X-Received: by 2002:a50:e79d:: with SMTP id b29mr7381849edn.57.1603886921776;
        Wed, 28 Oct 2020 05:08:41 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id m1sm2955418ejj.117.2020.10.28.05.08.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 05:08:40 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id i1so5450062wro.1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 05:08:40 -0700 (PDT)
X-Received: by 2002:adf:ab05:: with SMTP id q5mr8280571wrc.32.1603886919796;
 Wed, 28 Oct 2020 05:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201028091947.93097-1-krzk@kernel.org> <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
 <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
 <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com>
 <20201028100311.GF26150@paasikivi.fi.intel.com> <CAJKOXPcjtZidY1prH1ZCj+i-SM1mhABGbS_6_g1cH5WSGVhOAA@mail.gmail.com>
In-Reply-To: <CAJKOXPcjtZidY1prH1ZCj+i-SM1mhABGbS_6_g1cH5WSGVhOAA@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 28 Oct 2020 13:08:28 +0100
X-Gmail-Original-Message-ID: <CAAFQd5AwvuuxekSdDnHNB7KiC7+mHFisEkCW71F3XQMWaFqamw@mail.gmail.com>
Message-ID: <CAAFQd5AwvuuxekSdDnHNB7KiC7+mHFisEkCW71F3XQMWaFqamw@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 11:15 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Wed, 28 Oct 2020 at 11:03, Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 10:56:55AM +0100, Krzysztof Kozlowski wrote:
> > > On Wed, 28 Oct 2020 at 10:45, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > >
> > > > On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
> > > > >
> > > > > But the sensor settings for the original submission is to output GRBG Bayer RAW.
> > > > >
> > > > > Regards, Andy
> > > >
> > > > No, not to my knowledge. There are no settings for color output
> > > > because it is fixed to GBGB/RGRG. I was looking a lot into this driver
> > > > (I have few other problems with it, already few other patches posted)
> > > > and I could not find a setting for this in datasheet. If you know the
> > > > setting for the other color - can you point me to it?
> > >
> > > And except the datasheet which mentions the specific format, the
> > > testing confirms it. With original color the pictures are pink/purple.
> > > With proper color, the pictures are correct (with more green color as
> > > expected for bayer).
> >
> > Quoting the driver's start_streaming function:
> >
> >         /* Set Orientation be 180 degree */
> >         ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> >                                IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
>
> I understand that you think it will replace the lines and columns and
> the first line will be RG, instead of GB.... or actually BG because it
> flips horizontal and vertical? So why does it not work?

Any chance your SoC capture interface performs this flipping on its own as well?

>
> BTW, this nicely points that the comment around
> device_property_read_u32() for rotation is a little bit misleading :)
>

Are you referring to the comment below?

/*
* Check that the device is mounted upside down. The driver only
* supports a single pixel order right now.
*/
ret = device_property_read_u32(&client->dev, "rotation", &val);
if (ret || val != 180)
    return -EINVAL;

What's misleading about it?

> >         if (ret) {
> >                 dev_err(&client->dev, "%s failed to set orientation\n",
> >                         __func__);
> >                 return ret;
> >         }
> >
> > Could it be you're taking pictures of pink objects? ;-)
>
> I can send a few sample pictures taken with GStreamer (RAW8, not
> original RAW10)...
>
> Best regards,
> Krzysztof
