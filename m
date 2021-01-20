Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7AE2FD48F
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 16:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391061AbhATPuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 10:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390967AbhATPt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 10:49:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDDC061757
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:49:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b5so2453259pjl.0
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 07:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W/v3Q1gR6haXAZwJYzyuelWfC+raxw6fkAKMseYCivY=;
        b=TlifsGuM3b7ZVREww0uhRgA1wb889kOry5EIxYhxpaOk1ajcJQavGVxczaQF6C3wLM
         bHAZv8JrxVozohsNBS1Uk7hbpjtfdCLf4LdRiSm/JIcuQJvlOVs3dkR5HCanHxeWT4jE
         yXUSf8pDsx+sBNePzm9WvJyi3/9ruv9mu8lD6HkRkBEnPv1QRGjH2BwFrXvogVdH+PDS
         XxnTmQE16A8lnplcAhR/yS3A3IpdNmMF34n7gFH1iY73gzmhoxFyVe8J1n+Sz1Jsyxpj
         +lFkN7CqeBzI58JLVJNP53LESg2ItPuVaiLH4Xy7CV6eKa+dBk8xasCpEfdAo/Pzo4r1
         GwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W/v3Q1gR6haXAZwJYzyuelWfC+raxw6fkAKMseYCivY=;
        b=c9YPLqVQkEpWblSbIbFGrtnvzqWb9GdDKn4Xs9ux4ocx3jFsyrUjPaW9vh21PR9JtO
         cFFuMPpp44ldoDieC/FDcx/WdxRq26zKx5cpq0iN/XE1J9sFYgyMkE4QO91eFl4YddLf
         xuxeSA9kttlTlFyRIFpr/dm1WoCi9Gniq6dIrUrKhxA9J9BX6o+VlsI0cW3ZquEgWz3r
         s+xld+d5BZ/IKxmmzgrsE/QzOoedHpI/r45Bktn3z+QajLo6PHemXrbKiDdS5GY6K5Du
         p74P0EI+fY4TsVwPHrYfSPstlHBrJPuaPsker6eEKu5Onzj9k/4YWCwCo/svToSNdMMg
         Yrjg==
X-Gm-Message-State: AOAM533EkkI11mjFxBMrR0acUkBzKgB1dVEr1kBHduN5Rkr5Ga9Sfdrc
        +xLjpqeyFm6rdYN3sskGQoajCONI+dqEyVvjK1X+6Q==
X-Google-Smtp-Source: ABdhPJzmMovobGbSomzJhznA7/YaMj3HSwZCsNUkR//BrFcyoT6sKDmhT17DpKWrH74xISIMxxwpCyk0tHVfxae91Rw=
X-Received: by 2002:a17:90a:9483:: with SMTP id s3mr6293320pjo.85.1611157756495;
 Wed, 20 Jan 2021 07:49:16 -0800 (PST)
MIME-Version: 1.0
References: <20201210121438.7718-1-lma@semihalf.com> <20201217130439.141943-1-lma@semihalf.com>
 <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
In-Reply-To: <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
From:   =?UTF-8?Q?=C5=81ukasz_Majczak?= <lma@semihalf.com>
Date:   Wed, 20 Jan 2021 16:49:05 +0100
Message-ID: <CAFJ_xbrvr7jcCB57MPwzXf=oC5OYT5KUBkcqHYyOYH=a5njfSA@mail.gmail.com>
Subject: Re: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pierre,

Is there anything more to do to get the ACK for this patch?

Best regards,
Lukasz

wt., 12 sty 2021 o 12:34 =C5=81ukasz Majczak <lma@semihalf.com> napisa=C5=
=82(a):
>
> Hi,
>
> This is just a kind reminder. Is there anything more required to
> upstream this patch?
>
> Best regards,
> Lukasz
>
>
> czw., 17 gru 2020 o 14:06 Lukasz Majczak <lma@semihalf.com> napisa=C5=82(=
a):
> >
> > There is no check for the kcontrol against NULL and in some cases
> > it causes kernel to crash.
> >
> > Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format conf=
iguration according to information from NHLT")
> > Cc: <stable@vger.kernel.org> # 5.4+
> > Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> > Reviewed-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
> > ---
> >  sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >  v1 -> v2: fixed coding style
> >
> > diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/s=
kylake/skl-topology.c
> > index ae466cd592922..8f0bfda7096a9 100644
> > --- a/sound/soc/intel/skylake/skl-topology.c
> > +++ b/sound/soc/intel/skylake/skl-topology.c
> > @@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_co=
mponent *component)
> >         int i;
> >
> >         list_for_each_entry(dobj, &component->dobj_list, list) {
> > -               struct snd_kcontrol *kcontrol =3D dobj->control.kcontro=
l;
> > -               struct soc_enum *se =3D
> > -                       (struct soc_enum *)kcontrol->private_value;
> > -               char **texts =3D dobj->control.dtexts;
> > +               struct snd_kcontrol *kcontrol;
> > +               struct soc_enum *se;
> > +               char **texts;
> >                 char chan_text[4];
> >
> > +               kcontrol =3D dobj->control.kcontrol;
> > +               if (!kcontrol)
> > +                       continue;
> > +
> > +               se =3D (struct soc_enum *)kcontrol->private_value;
> > +               texts =3D dobj->control.dtexts;
> > +
> >                 if (dobj->type !=3D SND_SOC_DOBJ_ENUM ||
> >                     dobj->control.kcontrol->put !=3D
> >                     skl_tplg_multi_config_set_dmic)
> > --
> > 2.25.1
> >
