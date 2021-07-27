Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BACD3D6D11
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 06:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhG0EAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 00:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhG0D7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 23:59:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FE7C061764
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:59:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gs8so6431258ejc.13
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AVui1UrxB4V8dHHXolPBA5GyUaemtg+mai81JQmlO8A=;
        b=mpWQogQ6uzZiOOqbCDOlWnrj6itgtLZPyyafciiV9BuzntQtzy2+2/73XydjXtE8Lv
         PTDTiAYDTxNeLMxim1PZ0TxYw0d/SLBQg62tfMIhSnYJ1XNrZRioo430CZEWYA2PLtZU
         aYYds5u937cgqWbX0DanpWyQtBmKijcWFfHHOYcqnnAoN2mBQT7roTJCyJ+f7hd3644U
         Bn8YAEyNGZombXN7uNrwXW7Q2fkz7TpzIW04bkny+2CUfSkYFqQvTSw1sAfZA0DgqEJ9
         mAwDVmmrYSpb4vW3WXVoVsXdHN+8UMXfTfkx+T77bjkiy6swq8UHw0X70zti8H1YRNu/
         GiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AVui1UrxB4V8dHHXolPBA5GyUaemtg+mai81JQmlO8A=;
        b=DRkGGif79i1PbBUxQNGD7raxjzydKWFr4l8BS3DDrMjmECvfghlv5AyBtUiLI9XTdw
         u4XSm1FA2LrF7bW3yUe0oeseugy9tYCwBGgXJLpEbXaqbcLfyQDcDDM8m4rXIqRzRHPI
         POFWGi47vBjdGZbpUIXevRS2iY3ClEW1cO1ckwTsIOlUE4SY61w5p5znqUMGx7Z7J2mT
         e150OXIsGH95ZzFylDP32EbloH2OTn4akQ0ge0z4K6vJEkaQouZ/+Q9MQkQM8lHbX4Lb
         ZvK1ZPTMEbojj3oM48jMhq5sKiFNTOyswWO8qWKMyDg3g2FDbX8FGczkiPPhEU82DbPB
         3IOg==
X-Gm-Message-State: AOAM531OCbg0Ob3/6quex2js070qqarS8cFg92YBaD7+V4ylZL0tncX3
        XQiYLWemd5rj4hfANKNAgFGKghAo8zMmSiIdWew+lw==
X-Google-Smtp-Source: ABdhPJy56FgzVmzBETgdq0EBwyAKfKlmaKjf2Ymi89TdlTsZm3qLTjhXcxK3lEXfbMHEvaDdQq18dgJGxa1ZZ5LXJPY=
X-Received: by 2002:a17:906:4b46:: with SMTP id j6mr20191529ejv.247.1627358369266;
 Mon, 26 Jul 2021 20:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153828.144714469@linuxfoundation.org> <20210726193404.GA2686017@roeck-us.net>
In-Reply-To: <20210726193404.GA2686017@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 09:29:18 +0530
Message-ID: <CA+G9fYvRc=hugyiNZVEMxx8_Cm5J+MWTLsYdSqjehJX_nsNkNA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/82] 4.14.241-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 at 01:04, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jul 26, 2021 at 05:38:00PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.241 release. =
 There
> > are 82 patches in this series, all will be posted as a response to this=
 one.
> > If anyone has any issues with these being applied, please let me know.
> >
> > Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.  Anything
> > received after that time might be too late.
> >
>
> perf fails to build:

Results from Linaro=E2=80=99s test farm.
These build warnings / errors were noticed on arm64, arm, x86_64, and i386
while building perf on 4.14, 4.9 and 4.4.

>
> tests/topology.c: In function =E2=80=98session_write_header=E2=80=99:
> tests/topology.c:53:2: error: implicit declaration of function =E2=80=98e=
vlist__delete=E2=80=99; did you mean =E2=80=98perf_evlist__delete=E2=80=99?
> tests/topology.c:53:2: error: nested extern declaration of =E2=80=98evlis=
t__delete=E2=80=99
>
> Guenter

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/=
DISTRO=3Dlkft,MACHINE=3Dintel-corei7-64,label=3Ddocker-buster-lkft/1184/con=
sole

--
Linaro LKFT
https://lkft.linaro.org
