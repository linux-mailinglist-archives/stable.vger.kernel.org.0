Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F0A32D10
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFCJoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:44:09 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:43988 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFCJoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 05:44:09 -0400
Received: by mail-ua1-f66.google.com with SMTP id 89so4621979uar.10
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 02:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KO0I6a1R8Ow4IiQDjusN4yj+7PxTwoTlZYdw3YZciUs=;
        b=YymHVF2uaJu+SGCjnp5DIs5XPpZekYMiP4xUSlhfyTaNAgi19l7LhTgkKLGKP4UErp
         KKyov/0QXeb8wQ3rfyqeFCL7fna4/DWbkMPSr/3pyomr6scGLEmfZUzVEFLWjvXoLMfK
         XnN0e0wo4XPmfBbDmXYTI0Bc78yyKN4Wf1EBeNnleNgq/z8dljTAcwRZIJ2NJ9deWZ9o
         8E4N552VZq6lNd9L89FxwThr9/+OEk1ug7eAeakPrKbhP71/AZDHj6vOBwOePgnP6GhL
         JipCPIOnGsrmjLJMD94jnKCwe9oFMDiFslqB6HOGjn4rr8T5F7mijJiC5L85YgVxS6Xq
         SLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KO0I6a1R8Ow4IiQDjusN4yj+7PxTwoTlZYdw3YZciUs=;
        b=WHjxRGhcWITCs6/077Noo79o9GRMoOYGrH/KdgTS7NlbUOd7JF8uSQ0UAn6Di56nTe
         mdzJbIIiZSm8OnJ73XbCWgwXUssgmC6F6xtBNYnMUyRYlEMPmkMnfMhVoNlnCvKyFLkk
         CUugE+jUKabR1o7wQwXUgxbR+GWZB3nw9WOuR+0ZFSeQRfHmbRQIhZaHZkL+38yAybA+
         aZDqxlx6MlnUrgNR+HoNeR5MGkOm5cI7f4yzE5Qc2sKdNVWTVqJohRuK6YSpejQ2p+IP
         eGE+ZiEvftypEZWpBLwpIl2QgajPj7XxBOnffnvyuv7hczngnJiYD8DKQBUtj4l4K8Iv
         ZoYw==
X-Gm-Message-State: APjAAAVETZduYhDAiw0nzIps3kSxvGi4yA2Z7NecFmV7H78y+4kjXm4a
        MYHmU0PulybrP7c2pj18GMPM5Hy6f01F3Gm7fdm6ln6sFlA=
X-Google-Smtp-Source: APXvYqxZgk1ruMKZgGLyclajvEyvA7DPAjYkHbn4oHhCjmMM5sn135/9CxFM/merxbMRcYWo48pAClqv+aIUB3905NU=
X-Received: by 2002:ab0:e08:: with SMTP id g8mr11191540uak.32.1559555048463;
 Mon, 03 Jun 2019 02:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190603082725.7255-1-jian-hong@endlessm.com> <CAD8Lp468gEZ3A_o4YAcrn185=8yG=ezGptb21QSBCDQxzH07Zw@mail.gmail.com>
In-Reply-To: <CAD8Lp468gEZ3A_o4YAcrn185=8yG=ezGptb21QSBCDQxzH07Zw@mail.gmail.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Mon, 3 Jun 2019 17:43:31 +0800
Message-ID: <CAPpJ_ef=PQruyz7xyYoHxajQRzj1t044FMN8WHUFLRzAJ5L=og@mail.gmail.com>
Subject: Re: [PATCH 5.1 stable] drm/i915: Force 2*96 MHz cdclk on glk/cnl when
 audio power is enabled
To:     Daniel Drake <drake@endlessm.com>
Cc:     stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Drake <drake@endlessm.com> =E6=96=BC 2019=E5=B9=B46=E6=9C=883=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=884:47=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Jun 3, 2019 at 4:27 PM Jian-Hong Pan <jian-hong@endlessm.com> wro=
te:
> >  static void i915_audio_component_get_power(struct device *kdev)
> >  {
> > -       intel_display_power_get(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO)=
;
> > +       struct drm_i915_private *dev_priv =3D kdev_to_i915(kdev);
> > +
> > +       intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
> > +
> > +       /* Force CDCLK to 2*BCLK as long as we need audio to be powered=
. */
> > +       if (dev_priv->audio_power_refcount++ =3D=3D 0)
> > +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> > +                       glk_force_audio_cdclk(dev_priv, true);
> >  }
> >
> >  static void i915_audio_component_put_power(struct device *kdev)
> >  {
> > -       intel_display_power_put_unchecked(kdev_to_i915(kdev),
> > -                                         POWER_DOMAIN_AUDIO);
> > +       struct drm_i915_private *dev_priv =3D kdev_to_i915(kdev);
> > +       intel_wakeref_t cookie;
> > +
> > +       /* Stop forcing CDCLK to 2*BCLK if no need for audio to be powe=
red. */
> > +       if (--dev_priv->audio_power_refcount =3D=3D 0)
> > +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> > +                       glk_force_audio_cdclk(dev_priv, false);
> > +
> > +       cookie =3D intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO=
);
> > +       intel_display_power_put(dev_priv, POWER_DOMAIN_AUDIO, cookie);
> >  }
>
> The code above is the rediffed part of the patch. I think the last 2
> lines here are not quite right.
>
> Here, get means "increment reference count" and put means "decrease
> reference count".
>
> Before your patch, i915_audio_component_get_power() does
> intel_display_power_get(), and i915_audio_component_put_power() does
> intel_display_power_put_unchecked(). You can see the symmetry.
>
> After your patch, i915_audio_component_get_power() does
> intel_display_power_get() as before (good), but
> i915_audio_component_put_power() does a 2nd get and then a single put.
> So the reference count is now unbalanced.
>
> I think the last 2 lines of this function should just be left the same
> as they were before:
>        intel_display_power_put_unchecked(kdev_to_i915(kdev),
>                                          POWER_DOMAIN_AUDIO);

Hi Daniel,

Thanks for your reviewing.
I'm going to prepare new Rediff.

Jian-Hong Pan
