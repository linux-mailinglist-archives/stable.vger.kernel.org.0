Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0550029DF43
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403999AbgJ2BAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 21:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgJ1WR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:28 -0400
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E052469D;
        Wed, 28 Oct 2020 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603878333;
        bh=M8m3wt8fV+3UIkqePGnLlIs932qbeqSRdOpauzBIzl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1WiwlKhsc8n/OIAyFdRPwSKenfKayenRtyuBem2TNnguMJCJq6xZjAxZz7WBpJHYX
         0Gaho7SDVhp6ubCYS9JGdPtLGlA7nTeICnzwtjulpIWKdc+i5+GzkpI2PEqKS+Esq1
         miH/Vsarv8wlP3K5uaB7iDx8qweIQkufZbA2i3LQ=
Received: by mail-ed1-f41.google.com with SMTP id v4so1813875edi.0;
        Wed, 28 Oct 2020 02:45:32 -0700 (PDT)
X-Gm-Message-State: AOAM530CCIitoXx0lRQPcvLClevVOjnY3yX1J4PvZprmVSFnigGUOXGe
        +1MtRzcCcI82AkajSVMFAQxg0kfMPu5r9+6kplg=
X-Google-Smtp-Source: ABdhPJzibAiayrfnX7e492BygNqJJBTGqPxQbqLX4ZxY4gkXNJonXNomrcKjOfLYhM5y3foaLpxExRMfn5JvGnPF1IQ=
X-Received: by 2002:aa7:d1d5:: with SMTP id g21mr6950125edp.348.1603878331132;
 Wed, 28 Oct 2020 02:45:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201028091947.93097-1-krzk@kernel.org> <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 28 Oct 2020 10:45:19 +0100
X-Gmail-Original-Message-ID: <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
Message-ID: <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
To:     "Yeh, Andy" <andy.yeh@intel.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
>
> But the sensor settings for the original submission is to output GRBG Bayer RAW.
>
> Regards, Andy

No, not to my knowledge. There are no settings for color output
because it is fixed to GBGB/RGRG. I was looking a lot into this driver
(I have few other problems with it, already few other patches posted)
and I could not find a setting for this in datasheet. If you know the
setting for the other color - can you point me to it?

Best regards,
Krzysztof

> >-----Original Message-----
> >From: Krzysztof Kozlowski <krzk@kernel.org>
> >Sent: Wednesday, October 28, 2020 5:20 PM
> >To: Sakari Ailus <sakari.ailus@linux.intel.com>; Mauro Carvalho Chehab
> ><mchehab@kernel.org>; Tomasz Figa <tfiga@chromium.org>; Jason Chen
> ><jasonx.z.chen@intel.com>; Yeh, Andy <andy.yeh@intel.com>; Alan Chiang
> ><alanx.chiang@intel.com>; linux-media@vger.kernel.org; linux-
> >kernel@vger.kernel.org
> >Cc: Krzysztof Kozlowski <krzk@kernel.org>; stable@vger.kernel.org
> >Subject: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
> >
> >The IMX258 sensor outputs pixels in GBGB/RGRG mode.  This is described
> >explicitly in datasheet and was actually mentioned in a comment inside the
> >driver.  Using other - wrong mode - leads to pinkish pictures.
> >
> >Fixes: e4802cb00bfe ("media: imx258: Add imx258 camera sensor driver")
> >Cc: <stable@vger.kernel.org>
> >Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> >---
> > drivers/media/i2c/imx258.c | 10 +++++-----
> > 1 file changed, 5 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c index
> >ef069333a969..bf75d4e597af 100644
> >--- a/drivers/media/i2c/imx258.c
> >+++ b/drivers/media/i2c/imx258.c
> >@@ -715,7 +715,7 @@ static int imx258_open(struct v4l2_subdev *sd, struct
> >v4l2_subdev_fh *fh)
> >       /* Initialize try_fmt */
> >       try_fmt->width = supported_modes[0].width;
> >       try_fmt->height = supported_modes[0].height;
> >-      try_fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
> >+      try_fmt->code = MEDIA_BUS_FMT_SGBRG10_1X10;
> >       try_fmt->field = V4L2_FIELD_NONE;
> >
> >       return 0;
> >@@ -827,7 +827,7 @@ static int imx258_enum_mbus_code(struct
> >v4l2_subdev *sd,
> >       if (code->index > 0)
> >               return -EINVAL;
> >
> >-      code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
> >+      code->code = MEDIA_BUS_FMT_SGBRG10_1X10;
> >
> >       return 0;
> > }
> >@@ -839,7 +839,7 @@ static int imx258_enum_frame_size(struct
> >v4l2_subdev *sd,
> >       if (fse->index >= ARRAY_SIZE(supported_modes))
> >               return -EINVAL;
> >
> >-      if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
> >+      if (fse->code != MEDIA_BUS_FMT_SGBRG10_1X10)
> >               return -EINVAL;
> >
> >       fse->min_width = supported_modes[fse->index].width;
> >@@ -855,7 +855,7 @@ static void imx258_update_pad_format(const struct
> >imx258_mode *mode,  {
> >       fmt->format.width = mode->width;
> >       fmt->format.height = mode->height;
> >-      fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
> >+      fmt->format.code = MEDIA_BUS_FMT_SGBRG10_1X10;
> >       fmt->format.field = V4L2_FIELD_NONE;
> > }
> >
> >@@ -902,7 +902,7 @@ static int imx258_set_pad_format(struct v4l2_subdev
> >*sd,
> >       mutex_lock(&imx258->mutex);
> >
> >       /* Only one raw bayer(GBRG) order is supported */
> >-      fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
> >+      fmt->format.code = MEDIA_BUS_FMT_SGBRG10_1X10;
> >
> >       mode = v4l2_find_nearest_size(supported_modes,
> >               ARRAY_SIZE(supported_modes), width, height,
> >--
> >2.25.1
>
