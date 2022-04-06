Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5D4F5FCE
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiDFNQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiDFNPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:15:42 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D08C558302
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 02:52:53 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2eb57fd3f56so19969137b3.8
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 02:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/yHrnn97lLsdzLQ/tiQKfs1ZiFY5fV3TRpR81okhiyk=;
        b=IcLxWDEf7+C8DspiQndRuhI1XrlNQ2QQ/vDOajpEGHJu3NRx9sfwGDTDtS0WUu6sqZ
         wBo+d0lDWjRBzFlNTZXFyWhgilrFzdFEoegRa+TpnTQiLI6UPGPZ29VYj7LPEdhCQpfK
         tpenov1vJgo/oau07ISFuxSGQ+UTG5ZXwUjsj1XXVqy5MEytputwLCTU5CxnFzpUwdYP
         KDBxJXcw0GaepeCI1sz8aoqzwBz+wpNkCG81WKJ4l/Y+1eiupXw7+EnP/14GM5v6lnuI
         80XpGQIVj1QEVUWpHIBgOevRQbVwbcfilrR2Sk7BLLwSfnCK9FgOnK8sur+wEm6j/n4P
         5/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/yHrnn97lLsdzLQ/tiQKfs1ZiFY5fV3TRpR81okhiyk=;
        b=KuyAeAgocAv8wbMw4gdCxuraAddeUu/VPqd162W+kJd9MTtdp9r0+xdl3oQlaMXZMm
         vvEuHN3JHuwy+GJk3FqyVkWjxehXUxlK1CLyLfXKTuxBSx/nWnJLqRpDv26EF6RX8K2+
         uLzWO/yftzH5M+omj9gSXDwL0fSV53t6Dv1Y8gAVMmIt8+GN2CO6FBbqQuBmw7HbdNYX
         McaPsewRkLRTeOT1atTXr74y0cr+U73ElKdAfJJD2Sm+WLnqml8xVxcSrPXsLgo22iPh
         KVONlLBNUyBTD1eToXO7q6o0aqnOwGO723uvYccixYaPnGOwDkDxcDY29pU9s+MXDJXP
         E77Q==
X-Gm-Message-State: AOAM532uA9uzki/fAsYU8p8mWiBTWhUhYTgUabSl7xRQa/RXw6E+umzI
        OR7TNHLmRJIvltWzfZjkdnlpL0LxuS5QtfOsczcYvQ==
X-Google-Smtp-Source: ABdhPJxKvEHiCkKRBJfSRTHKYHTAYUapsFaOhZ68x2epxJghJ37F36ttuJtyOr4x6Yonqn3l7MHm9HrN2VXKDeTCpTc=
X-Received: by 2002:a0d:d0c1:0:b0:2dc:5950:c72f with SMTP id
 s184-20020a0dd0c1000000b002dc5950c72fmr6000563ywd.185.1649238748644; Wed, 06
 Apr 2022 02:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070339.801210740@linuxfoundation.org> <4273d632-9686-3809-2ef0-e87bb431f798@linuxfoundation.org>
In-Reply-To: <4273d632-9686-3809-2ef0-e87bb431f798@linuxfoundation.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 6 Apr 2022 11:52:18 +0200
Message-ID: <CADYN=9+=Z=9g2r6-14kY9OQets+K=tzVeejiqTJyDJgKctddYw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
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

On Wed, 6 Apr 2022 at 01:06, Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 4/5/22 1:17 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.33 release.
> > There are 913 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.33-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Build failed on my system. The following is the problem commit. There
> are no changes to the config between 5.15.32 and this build.
>
> Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>      ASoC: SOF: Intel: hda: Remove link assignment limitation

I saw the same build error, after applying the following patches it
builds fine again.

a792bfc1c2bc ("ASoC: SOF: Intel: hda-stream: limit PROCEN workaround")
81ed6770ba67 ("ASoC: SOF: Intel: hda: expose get_chip_info()")


Cheers,
Anders

>
>    CC [M]  sound/soc/sof/intel/hda-dai.o
> sound/soc/sof/intel/hda-dai.c: In function =E2=80=98hda_link_stream_assig=
n=E2=80=99:
> sound/soc/sof/intel/hda-dai.c:86:24: error: implicit declaration of funct=
ion =E2=80=98get_chip_info=E2=80=99; did you mean =E2=80=98get_group_info=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>     86 |                 chip =3D get_chip_info(sdev->pdata);
>        |                        ^~~~~~~~~~~~~
>        |                        get_group_info
> sound/soc/sof/intel/hda-dai.c:86:22: error: assignment to =E2=80=98const =
struct sof_intel_dsp_desc *=E2=80=99 from =E2=80=98int=E2=80=99 makes point=
er from integer without a cast [-Werror=3Dint-conversion]
>     86 |                 chip =3D get_chip_info(sdev->pdata);
>        |                      ^
> sound/soc/sof/intel/hda-dai.c:94:35: error: =E2=80=98const struct sof_int=
el_dsp_desc=E2=80=99 has no member named =E2=80=98quirks=E2=80=99
>     94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_FM=
T_QUIRK)) {
>        |                                   ^~
> sound/soc/sof/intel/hda-dai.c:94:46: error: =E2=80=98SOF_INTEL_PROCEN_FMT=
_QUIRK=E2=80=99 undeclared (first use in this function)
>     94 |                         if (!(chip->quirks & SOF_INTEL_PROCEN_FM=
T_QUIRK)) {
>        |                                              ^~~~~~~~~~~~~~~~~~~=
~~~~~~~
> sound/soc/sof/intel/hda-dai.c:94:46: note: each undeclared identifier is =
reported only once for each function it appears in
> cc1: all warnings being treated as errors
> make[4]: *** [scripts/Makefile.build:287: sound/soc/sof/intel/hda-dai.o] =
Error 1
> make[3]: *** [scripts/Makefile.build:549: sound/soc/sof/intel] Error 2
> make[2]: *** [scripts/Makefile.build:549: sound/soc/sof] Error 2
> make[1]: *** [scripts/Makefile.build:549: sound/soc] Error 2
> make: *** [Makefile:1846: sound] Error 2
>
> thanks,
> -- Shuah
