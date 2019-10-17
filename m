Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20140DB57C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395172AbfJQSFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:05:45 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:35421 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389832AbfJQSFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:05:45 -0400
Received: by mail-il1-f195.google.com with SMTP id j9so2971729ilr.2;
        Thu, 17 Oct 2019 11:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9e6esXdSKEchwo9t/UhDN2I/NCXL7m7+/GS8N3ZNVaw=;
        b=pywovx149iqExuPpCztzKPaZyHlSqopn1Yu6ZuQhPKw6kzhNWw/tEKI1Iq6tkYxn+E
         Ny6vInaz8h3aq0ByQ/eTn0kIYSFU5ZEXl4hA4Ybg0DjBQWH1bI2/hChDrUBJWjpzUN0P
         sCa9Df10e9ysv5XE80CEQzMRwRhJMmPnyWT4L41CNnw+jTvnjeC2aj6HzHcKr1sZnrFe
         E4aubbc8D+4XxvgYEhHczLMlytY1NqNcCCDsL80CjMQr/jYvlbB2b+OXQtbN7Bnxzr6T
         eeqyBo8JtAPnFZbWCtgrVCMkWKdoZ+vntrZJS6RF9jHrkSWtEp01+WdVBybwnhctoN0y
         Fr4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9e6esXdSKEchwo9t/UhDN2I/NCXL7m7+/GS8N3ZNVaw=;
        b=jDcmOgJb2XejoRimVOU9VKF1JH2Jf4Jsy4KVXOIt3o6ln1b4gRCH3eqbRXfYhwE57R
         SAZsJx97wj7bQzTGM/CDaj/1GXPsFq8gxfqckpwdLYgitvkI3M7iNK9mE1pat+njqkt5
         IFZhPxgLxo5biskx76NcX9SH8kmmobac0v6zq7v3EPLNbhOmwjZn9gejmHaMVBTocZNi
         f3/EGPaBYNYDY9nT0wKbNU1VT2BDAMBcYbunyCcAcg+b9on4AQQtL0kiUpFfAGnYITtA
         rPbwYPEGL+KzcKzlARXBCTJuD5awEPct1QT++hT24xbBnIMjRx61itJN4r0utca7NSEL
         dTQA==
X-Gm-Message-State: APjAAAU+sdwZu12u7lJn2jCApkSMfIkla1w5SWQ6WKHTz+6yWRq56J+F
        ZLoInkz7T8sVeONIaJpwtqzXWWJnaBbe7euUQgQ=
X-Google-Smtp-Source: APXvYqwhwDIMPJoLzHwPVEvU2F9RoxMzXULGAdvGmW2ojPx7JzrM7mkHKQqk4RD2cXkAHW+OVeWRX0R7l1G1AxI4u5U=
X-Received: by 2002:a92:6a04:: with SMTP id f4mr5306698ilc.205.1571335543030;
 Thu, 17 Oct 2019 11:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191002122542.8449-1-tomi.valkeinen@ti.com> <CAHCN7xLjGkLHMWejEk-3vJ-OwzjB+BXtnPWoonh4mAVxbkzMWQ@mail.gmail.com>
In-Reply-To: <CAHCN7xLjGkLHMWejEk-3vJ-OwzjB+BXtnPWoonh4mAVxbkzMWQ@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 17 Oct 2019 13:05:31 -0500
Message-ID: <CAHCN7xKN7CePgajQLH61dBaoLWZ4VMxo39_xJOWHyvM3x_0i=A@mail.gmail.com>
Subject: Re: [PATCH] drm/omap: fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 13, 2019 at 10:56 AM Adam Ford <aford173@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 7:25 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >
> > The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> > (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> > correct, and using divider of 32 breaks DSS with a flood or underflows
> > and sync losts. Dividers up to 31 seem to work fine.
> >
> > There is another patch to the DT files to limit the divider correctly,
> > but as the DSS driver also needs to know the maximum divider to be able
> > to iteratively find good rates, we also need to do the fix in the DSS
> > driver.
> >
>
> Tomi,
>
> Is there any way you can do a patch for the FB version for the older
> 4.9 and 4.14 kernels?  I think they are still defaulting to the omapfb
> instead of DRM, so the underflow issue still appears by default and
> the patch only impacts the DRM version of the driver.  If not, do you
> have any objections if I submit a patch to stable for those two LTS
> branches?

Gentle nudge on this question.  I can do the work, but I just
permission so don't overstep.

adam
>
> thanks,
>
> adam
> > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: Adam Ford <aford173@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/omapdrm/dss/dss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
> > index e226324adb69..4bdd63b57100 100644
> > --- a/drivers/gpu/drm/omapdrm/dss/dss.c
> > +++ b/drivers/gpu/drm/omapdrm/dss/dss.c
> > @@ -1083,7 +1083,7 @@ static const struct dss_features omap34xx_dss_feats = {
> >
> >  static const struct dss_features omap3630_dss_feats = {
> >         .model                  =       DSS_MODEL_OMAP3,
> > -       .fck_div_max            =       32,
> > +       .fck_div_max            =       31,
> >         .fck_freq_max           =       173000000,
> >         .dss_fck_multiplier     =       1,
> >         .parent_clk_name        =       "dpll4_ck",
> > --
> > Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> > Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> >
