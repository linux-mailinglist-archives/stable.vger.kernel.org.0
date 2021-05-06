Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8995374D54
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 04:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhEFCQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 22:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhEFCQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 22:16:26 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01430C06174A
        for <stable@vger.kernel.org>; Wed,  5 May 2021 19:15:27 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso3555245otb.13
        for <stable@vger.kernel.org>; Wed, 05 May 2021 19:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AcPxGvo4DTEq0tZ93ZhbcWhj47fEylwOLceycjaHK5I=;
        b=u3imbGOM5XVGgqZjY9lrnzRjwRP+tcNA0VFdrHtoLvOarhzhRsCvCymTKzxo2IPXGq
         FaeW10mA4tW9NTObLrvNNI3XbfzfSPLB5BzokRn3BZIsD1mSDA0U6f0ocfRvc+r+jnle
         o5jvt9gb1Sn9+9PbNfwWp532WoMK/ARM7i0z8M1EGOTdoIgvC0a/vg3Tr3sWbHGuOkRr
         1C8ZSDZaSJ5gnMuAnkDUBwt3vE8vICe2jQtPeNEE+RZGhKnScfMZmi8O5mYW3oESQ1b2
         RPUuIj6gJExspXPSyuBuW6y05zqdRj0Wzvdx4FNhzEGjkrYC7vfxnJHoCZQOZJ1J+PGJ
         DWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AcPxGvo4DTEq0tZ93ZhbcWhj47fEylwOLceycjaHK5I=;
        b=pktgs8/tqCiofouSPnXujU45cdBo/gEwxXcivCRrRdc7K54QVpG2g2z6M1blEsvQEg
         pIh+wduOTPIo4TeUDrtmkuCyjoeV+v5sepC10zxR08sKPvwWWgzBlzzNOmoYFTnSYl2p
         P4Oq1ZOW2CaGkOAauaADnZgCM9+eYSNRTRDXmhoySMRZjxK/CXKEr4vz5/xTXHHl6Cb+
         OUxGWoXCuLMbHiwwvy7hMQmR9vGesBbREDZyHH+LQdH455xGPChPc3zhIEeB9a3W+L9Y
         yKYQIcuurp0UYIbrgx0mnD35uQFfnqZgcGSIYX6XG8nKQCVqbXJijUgu5Ht/ucki/asa
         PrWA==
X-Gm-Message-State: AOAM533vvZrb9js43izQCDcKziwffYQIMv/NEwgyyDVg5ssko8k3Z58D
        10hbQdYTgx1XS9ON3CvORuKldZLVSEMNIRwr2ducBw==
X-Google-Smtp-Source: ABdhPJx3oxn6WUwRIIlpeu2O6HboD8CTh3HEGo5xnyXIpmDmNndO2g0miwJ7v6pKWQKfqelX8RJ/aLXy3xFoUXQidfk=
X-Received: by 2002:a9d:6b85:: with SMTP id b5mr1413250otq.172.1620267327215;
 Wed, 05 May 2021 19:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210505112324.729798712@linuxfoundation.org> <20210505214938.GA817073@roeck-us.net>
In-Reply-To: <20210505214938.GA817073@roeck-us.net>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 5 May 2021 21:15:14 -0500
Message-ID: <CAEUSe79HYzZpUWRBz6uPyiWN6smxdUEm02_H4_YL5XyT4x9MGw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed, 5 May 2021 at 16:49, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.117 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.117-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 5.4.117-rc1
> >
> > Ondrej Mosnacek <omosnace@redhat.com>
> >     perf/core: Fix unconditional security_locked_down() call
> >
> > Miklos Szeredi <mszeredi@redhat.com>
> >     ovl: allow upperdir inside lowerdir
> >
> > Dan Carpenter <dan.carpenter@oracle.com>
> >     scsi: ufs: Unlock on a couple error paths
> >
> > Mark Pearson <markpearson@lenovo.com>
> >     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
> >
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> >
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak4458: Add MODULE_DEVICE_TABLE
>
> Twice ? Why ?

But different, right? One for 4458 and the other for 5558:

sound/soc/codecs/ak4458.c:
+MODULE_DEVICE_TABLE(of, ak4458_of_match);

sound/soc/codecs/ak5558.c:
+MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);

FWIW, our builds passed with that pair of commits.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org



> This gives me a compile error (the second time it is added at the wrong
> place).
>
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys=
-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.=
117_rc1/sound/soc/codecs/ak4458.c:722:1: error: redefinition of '__mod_of__=
ak4458_of_match_device_table'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_=
match);
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys=
-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.=
117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DE=
VICE_TABLE'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##=
__##name##_device_table               \
> chromeos-kernel-5_4-5.4.117_rc1-r2159:                     ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: <scratch space>:119:1: note: expan=
ded from here
> chromeos-kernel-5_4-5.4.117_rc1-r2159: __mod_of__ak4458_of_match_device_t=
able
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys=
-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.=
117_rc1/sound/soc/codecs/ak4458.c:711:1: note: previous definition is here
> chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_=
match);
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys=
-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.=
117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DE=
VICE_TABLE'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##=
__##name##_device_table               \
>
> Oddly enough, I only see the error when I try to merge the
> code into ChromeOS, not in my test builds. I guess that has
> to do with "-Werror".
>
> Guenter
