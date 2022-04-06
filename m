Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617514F5EA9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiDFNDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiDFNDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:03:09 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C755CFBF0
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 02:31:28 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id d138so2959598ybc.13
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 02:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OVhcFKo8wEkExU/JC2CRzZWztSpDv1NCOKxUnp7443Y=;
        b=EkJZYz1J8Z/oE3qqME1XB+QbpG8B8S74ho9tvQX1t9lAVsg8UD/hlNSpmXDdSRvIOw
         Y4uVlWPzTiVhujbvzK1L9VS52kyPUdm7kwxH1BAPROFZE503CGp3GHnoLGZ6CmvVTpM8
         jJkYAPhunpASUxiqoY8cOZRcNxAfnXThvDHv0RWUH95VZNM/IBDBFnHiK+gQfSrCkOLv
         1swYT3Cy7NV1OsV4CoGtsQQLAe8on7KupZqKk+DFx9fw5h2IlgK51dBoia3UxPoP0ebS
         beC49EuS+ZE1CzDBhojRT/kkhiOTlR1SxS2Ew+YNaZw7WrKEn+dLFejBOlPtRZ5kM6k7
         XymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OVhcFKo8wEkExU/JC2CRzZWztSpDv1NCOKxUnp7443Y=;
        b=HRz5OV+zuJK1Cis/e+2tf7S3xv2wapBF9+YIidQm9JdGzgGJSX9ZVx51bZ/rU/4XDi
         6vJrcTawjOa03gyH1SIAUCBzV812I1/cr3FplNwCckKEKucBEXY4t/3FhxvLTeIP4Okb
         xCi/maCkaI5SbLmVvAFC6kWfTil+dhXd1L5qyIXT7P0dhkNjCgPAo0K9uobjtqAt/+F5
         CLEsXwYUO5TZuBr+XvJKbAyiye2npFML/qFyjwVshvlZWc1nFnW0uozHEr/xkgc2VvmV
         RxLKESM+ZfBkddESqKjPZxnnvcvjj8V/41NEiJva6VVatmWAihpEP7vlwHdEVqyQKkro
         v7LQ==
X-Gm-Message-State: AOAM533rzUg5JdTJbdxCW78ojL/YrmSW7eTvIf7HeBZLjTPwXL1OBUQl
        +I5KpEppngP8g4uTmE8p0cQedtEeMstObt6wgbekkw==
X-Google-Smtp-Source: ABdhPJzHP4KTzpT8pwgNRTsJvsXivMME9ci/UzSnGw6ceYMSaXlcvDfVKlwXaUlpwscmIUUQ0Et86Btyzj6l7QzdRRQ=
X-Received: by 2002:a25:7102:0:b0:63d:91db:c29d with SMTP id
 m2-20020a257102000000b0063d91dbc29dmr5502786ybc.405.1649237427488; Wed, 06
 Apr 2022 02:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070354.155796697@linuxfoundation.org> <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
In-Reply-To: <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 6 Apr 2022 11:30:16 +0200
Message-ID: <CADYN=9+pshm3PGa0+JY=yR3bTQySUxdTUVtNraKXOS_ZDTXWsw@mail.gmail.com>
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

On Wed, 6 Apr 2022 at 01:03, Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 4/5/22 1:15 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.19 release.
> > There are 1017 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.19-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Build failed on my system. The following is the problem commit. There
> are no changes to the config between 5.16.18 and this build.
>
> Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>      ASoC: SOF: Intel: hda: Remove link assignment limitation

I saw the same build error, after applying the following patches it
builds fine again.
198fa4bcf6a1 ("ASoC: SOF: intel: add snd_sof_dsp_check_sdw_irq ops")
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

--=20
Linaro LKFT
https://lkft.linaro.org
