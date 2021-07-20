Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C083CF610
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGTHkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 03:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhGTHkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 03:40:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172AC061574;
        Tue, 20 Jul 2021 01:21:23 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id w13so11781850wmc.3;
        Tue, 20 Jul 2021 01:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZAsyPhZqQX8RRaN5B0ciGO+a5ss+JdZZiLvJhNkb/QQ=;
        b=IbmG7+XlduHNAwAM3UrNJqoEiC9dQVgRIWGD3TyqdBdYlGr0b4Z4a2vUipx55GInlk
         LYZlKgtP7567YMklU7BouX57FoQbY4Gxh3kvjeIBDMSS6vaZ3bV6sWeixEY24wXBPAHj
         Zi/cF2TEtGH5xWgXkZ9BMt1MbgO+u3i7bdJbpauFrUyeiAX2YyDbrG7qipLV+pkfqdal
         90m8070c5dmlX6MjwEQ7xg+bj5PAIaUFuJXkD5ChGYdVy5SmS/o2gTyZFd0EDQmAPK27
         TGCR+HBVpdAZH6BmQTPbfdRMMQyBmiF1Beia/GgBJ5GmFRf4u19MeCgyC5yuhwnbOFmQ
         imgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZAsyPhZqQX8RRaN5B0ciGO+a5ss+JdZZiLvJhNkb/QQ=;
        b=iava5wUrE9iQOQqdXWujLRhP4WakbCD+hiC0H6usqUIcHvI7TResq7ct9dtYECTRdS
         /v2WRQUFPpOlEmkLK4unyZLYoXmXthsxxJlk3gzE7kzjW8zO3Wx4mmQSJEMF6NhvauM2
         si/R8qF3gITffObBc871kAJ/32w9xHlGoQpL/FutA0dq+i6MjzBLq/fMakDi3muH5XD5
         N1AeRP2YTXeobHvBIZvy2ZxMq7CHJQ65ZbrIa+pZ3yBG8vDlaSOkDsDqcnrMK8Azazxi
         thRhprOOmG11k8PrkgBuXQqfBGQuGXQOS28pFuAtBGTO2JVcL4VHnCqA6y4nBF4VejsJ
         lb5w==
X-Gm-Message-State: AOAM531QGlmqVIo27Ra7iZIsB5PLLs+bG59VWolSxLSAp2y7Vv1WQSK9
        6VJlq5A3ne6sDLQx9EsLJ1I=
X-Google-Smtp-Source: ABdhPJzxSp6xvnS1GP/Eq75d/A1Qv49ISuhtWPQxiqYaZm8FXsP/83Ji76iaYoK4sgVpFR/k5Rn5zw==
X-Received: by 2002:a05:600c:2105:: with SMTP id u5mr30052149wml.18.1626769282132;
        Tue, 20 Jul 2021 01:21:22 -0700 (PDT)
Received: from pevik (gw.ms-free.net. [95.85.240.250])
        by smtp.gmail.com with ESMTPSA id o28sm24451329wra.71.2021.07.20.01.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 01:21:21 -0700 (PDT)
Date:   Tue, 20 Jul 2021 10:21:19 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.14 305/315] arm64: dts: qcom: msm8994-angler: Fix
 gpio-reserved-ranges 85-88
Message-ID: <YPaHf9Ff820srjkG@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210719144942.861561397@linuxfoundation.org>
 <20210719144953.504491331@linuxfoundation.org>
 <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
 <YPXHioXEfwU6NzTf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPXHioXEfwU6NzTf@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, Jul 19, 2021 at 09:17:17PM +0530, Naresh Kamboju wrote:
> > On Mon, 19 Jul 2021 at 21:01, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:

> > > From: Petr Vorel <petr.vorel@gmail.com>

> > > [ Upstream commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 ]

> > > Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
> > > application CPUs (causes reboot). Yet another fix similar to
> > > 9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
> > > 3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").

> > > Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")

> > > Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> > > Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> > > Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
> > >  1 file changed, 4 insertions(+)

> > > diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > > index dfa08f513dc4..e5850c4d3334 100644
> > > --- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > > +++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > > @@ -38,3 +38,7 @@
> > >                 };
> > >         };
> > >  };
> > > +
> > > +&tlmm {
> > > +       gpio-reserved-ranges = <85 4>;
> > > +};

> > Following build errors noticed on arm64 architecture on on
> > stable-rc linux-4.19.y
> > stable-rc linux-4.14.y


> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> > CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> > 'HOSTCC=sccache gcc'
> > Error: /builds/linux/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts:42.1-6
> > Label or path tlmm not found
> > FATAL ERROR: Syntax error parsing input tree
> > make[3]: *** [scripts/Makefile.lib:294:
> > arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dtb] Error 1
> > make[3]: Target '__build' not remade because of errors.
> > make[2]: *** [/builds/linux/scripts/Makefile.build:544:
> > arch/arm64/boot/dts/qcom] Error 2

> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> > reference build link,
> > build: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/
> > config: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config


> > steps to reproduce:
> > ---------------------
> > # TuxMake is a command line tool and Python library that provides
> > # portable and repeatable Linux kernel builds across a variety of
> > # architectures, toolchains, kernel configurations, and make targets.

> > # TuxMake supports the concept of runtimes.
> > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > # that you install podman or docker on your system.

> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake

> > # See https://docs.tuxmake.org/ for complete documentation.


> > tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> > --kconfig defconfig --kconfig-add
> > https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config


> Now dropped from everywhere, thanks.
It should be working since v5.9, thus applicable to linux-5.10.y (longterm) and the two
newer stable branches. As I described it before, I'd drop it from linux-4.19.y
and linux-4.14.y (unless 3edfb7bd76bd from 4.20 is planning to be backported to
it, which I don't think so).

The only branch which needs to adapt this patch is linux-5.4.y (use msmgpio).
I can send a patch for it during this week.

Kind regards,
Petr

> greg k-h
