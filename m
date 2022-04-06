Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE244F5F54
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiDFNHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiDFNGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:06:30 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8E5DE2AF
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 02:40:43 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id f23so3032210ybj.7
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 02:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kYMTnVbKZb14hTPQbaLRIxPgj7UusTT0smTXojvT54o=;
        b=H2heIrruY2WXCA/JBhDLFuyEyB5W29rhEE9oasb272qSCTotofpqCps+Scq0e4bMEP
         rgxQUChZSnFNhksIND8MJq0KLteGG+5nrTpEafuYKQJg+k/RviLceA47vA/9kPKy92xz
         fflBWWfh/ylypIV2F2ZRicDKfbjM5gEjwkuReNiLEPkUzHgXv51xtwCpuDWS7i8ff3um
         wcS8xyypVPVCDp0AV4JzWWvehCzJTwXpOFGXIlDHHJwxvUG41ogibesLUfwsrQ8FvFzf
         fL2TOl+XGNpfd3/QnG4sMbh8yx7c4bv4Ew46ZqI6cjM8rPV426F/dnlvgyG44+ehMCFR
         fM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kYMTnVbKZb14hTPQbaLRIxPgj7UusTT0smTXojvT54o=;
        b=4RHbsqacvvdEv87WaFXLqykN1PFO7fLGKlnO79Nh0N+qqyA8Wbe4lp8BT2Xr4sPw2s
         +Ed31q3ncvVYWVxXQTbPt9102tAqsxdRx90rIRi5qV1c4KdOTcgDhEQPpFW5iy0sBlhN
         3WoQ1Un5Fk/OkW1kgbtKHzykQc8ZNUkoMsKWZYiGD1gK3XqvWurwjQh0XEX1skDiXaeF
         IjFoGoKF5SR4GRJ+j8HgcE04cC4/8WN+WuWLzrFAxTRTOLISwFHMAzbLxZ9m1nIcrRLn
         Ds69c53W1xMsTwXR5idlqOfRNUkofy2utB/EY9jHWDLDCxrd0bPlsCyzm9qgt0+nVtvx
         ecZw==
X-Gm-Message-State: AOAM533xE2GVQYCnFA2htkokL7dmVxHtVJFS9QF8DdjjOn7FvqLGb+RC
        18Sk4+NuJ393L4mdG2zW8SuOYsYQWCXEC1PdTB4Yqg==
X-Google-Smtp-Source: ABdhPJy8rfzJ/R3bJ36z4knt9034VlzfxKLGhEmCeGO21EoalFxtZqpYUAvNRh7lfsjSV1vvT6eTKi7fItQ03MoXGXQ=
X-Received: by 2002:a05:6902:1028:b0:639:7ca3:84db with SMTP id
 x8-20020a056902102800b006397ca384dbmr5986894ybt.357.1649237877980; Wed, 06
 Apr 2022 02:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070354.155796697@linuxfoundation.org> <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
 <CADYN=9+pshm3PGa0+JY=yR3bTQySUxdTUVtNraKXOS_ZDTXWsw@mail.gmail.com>
In-Reply-To: <CADYN=9+pshm3PGa0+JY=yR3bTQySUxdTUVtNraKXOS_ZDTXWsw@mail.gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 6 Apr 2022 11:37:47 +0200
Message-ID: <CADYN=9JcNwpPmJ0Y4zTTOAAm-2BuBEqjUfpHBt8ND-tc+mO4Fg@mail.gmail.com>
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        ranjani.sridharan@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Apr 2022 at 11:30, Anders Roxell <anders.roxell@linaro.org> wrote=
:
>
> On Wed, 6 Apr 2022 at 01:03, Shuah Khan <skhan@linuxfoundation.org> wrote=
:
> >
> > On 4/5/22 1:15 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.16.19 release.
> > > There are 1017 patches in this series, all will be posted as a respon=
se
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.16.19-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.16.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> >
> > Build failed on my system. The following is the problem commit. There
> > are no changes to the config between 5.16.18 and this build.
> >
> > Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> >      ASoC: SOF: Intel: hda: Remove link assignment limitation
>
> I saw the same build error, after applying the following patches it
> builds fine again.

I'm sorry managed to grab the wrong commit, This is the two commits:
a792bfc1c2bc ("ASoC: SOF: Intel: hda-stream: limit PROCEN workaround")
81ed6770ba67 ("ASoC: SOF: Intel: hda: expose get_chip_info()")


>
> Cheers,
> Anders
>
> >
> >    CC [M]  sound/soc/sof/intel/hda-dai.o
> > sound/soc/sof/intel/hda-dai.c: In function =E2=80=98hda_link_stream_ass=
ign=E2=80=99:
> > sound/soc/sof/intel/hda-dai.c:86:24: error: implicit declaration of fun=
ction =E2=80=98get_chip_info=E2=80=99; did you mean =E2=80=98get_group_info=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >     86 |                 chip =3D get_chip_info(sdev->pdata);
> >        |                        ^~~~~~~~~~~~~
> >        |                        get_group_info
> > sound/soc/sof/intel/hda-dai.c:86:22: error: assignment to =E2=80=98cons=
t struct sof_intel_dsp_desc *=E2=80=99 from =E2=80=98int=E2=80=99 makes poi=
nter from integer without a cast [-Werror=3Dint-conversion]
> >     86 |                 chip =3D get_chip_info(sdev->pdata);
> >        |                      ^
> > sound/soc/sof/intel/hda-dai.c:94:35: error: =E2=80=98const struct sof_i=
ntel_dsp_desc=E2=80=99 has no member named =E2=80=98quirks=E2=80=99
> >     94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_=
FMT_QUIRK)) {
> >        |                                   ^~
> > sound/soc/sof/intel/hda-dai.c:94:46: error: =E2=80=98SOF_INTEL_PROCEN_F=
MT_QUIRK=E2=80=99 undeclared (first use in this function)
> >     94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_=
FMT_QUIRK)) {
> >        |                                              ^~~~~~~~~~~~~~~~~=
~~~~~~~~~
> > sound/soc/sof/intel/hda-dai.c:94:46: note: each undeclared identifier i=
s reported only once for each function it appears in
> > cc1: all warnings being treated as errors
> > make[4]: *** [scripts/Makefile.build:287: sound/soc/sof/intel/hda-dai.o=
] Error 1
> > make[3]: *** [scripts/Makefile.build:549: sound/soc/sof/intel] Error 2
> > make[2]: *** [scripts/Makefile.build:549: sound/soc/sof] Error 2
> > make[1]: *** [scripts/Makefile.build:549: sound/soc] Error 2
> > make: *** [Makefile:1846: sound] Error 2
> >
> > thanks,
> > -- Shuah
>
> --
> Linaro LKFT
> https://lkft.linaro.org
