Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815383CF5E7
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 10:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhGTHgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 03:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234509AbhGTHfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 03:35:38 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B8C0613DE;
        Tue, 20 Jul 2021 01:15:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f17so25025858wrt.6;
        Tue, 20 Jul 2021 01:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=ql1dPCLTKbbcS6/GHPVv78v3bVThvgbYbc34CpuUIL0=;
        b=ffLyLY1/JAL7wmQS2W2DoShIdUns/9l1AiXt1wEe3BUKTUc88JoACXEPl3J6IRBCFJ
         Og2uPlKAD/WnjV3cX8YUTJJ/KWxYz9FC+2OyCGY8x47xlp8s0LGQV8t/4TbcDu9uafVH
         m92x+higKKO3druYA9RBT/Jod6LHeWpLf+P2CURLTriPMA4GH0mlvDwfq/+mwp7fYECv
         5Rla3UkzZ48vDC8oyJ1Rkw6qHOkr1M+IjuOLxvTUpnsb7PymqG7S90xZh4H6gOGDUyET
         fuO+/BVv5JMcyiezAirdVpW6TF9bu3hATNDNuoe6wCfg2kQjfGTsLx1bN28ta4MOK6nB
         Tqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=ql1dPCLTKbbcS6/GHPVv78v3bVThvgbYbc34CpuUIL0=;
        b=CR8Gwi9l70vazlGiH0ICSbwJ/Iw0DuX+iGOdycuqp3loLACpa3945u9VJZmqpQIVsg
         uJPEp2ouTapFBiBhcbtPBEMR668redRRECsAykBwytGg/VWhFtj3mE28eS996xIAFXxI
         /0oI7xt8J7ZBPAe8BCcgegRDBga8tvqGebjnnQWGO7y/fOuRn0MDtps2YYdHpLEIys5G
         j6kU5z56p/9LFxxoB2P5x9TX8qMiXJHUV0wB3zTEVKVZyR5Lrcitt2wckIfs7e7GVun/
         HSNwkiCjaj5oxPxgwhTq4XFkBogjljizInPvRMZ8/uy1L9aPJDM27wX24+YS7jx9ICiM
         MDug==
X-Gm-Message-State: AOAM532YmEzCooHJHElzaA0PLQ4Fk4oCYUGTz7BFiNwNQWM/btcNezvx
        dfyDFzyW2vE10QUXosmgWCs=
X-Google-Smtp-Source: ABdhPJx9PjfIc8KKJoLAm/nwv9afljCvFz2qGCXfHFrlTSQ81Lcbriz7tucU92+5o1rHPb04wo2mvQ==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr35045256wrd.200.1626768945210;
        Tue, 20 Jul 2021 01:15:45 -0700 (PDT)
Received: from pevik (gw.ms-free.net. [95.85.240.250])
        by smtp.gmail.com with ESMTPSA id f7sm22692887wru.11.2021.07.20.01.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 01:15:44 -0700 (PDT)
Date:   Tue, 20 Jul 2021 10:15:42 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.14 305/315] arm64: dts: qcom: msm8994-angler: Fix
 gpio-reserved-ranges 85-88
Message-ID: <YPaGLgPhdYuFGGxo@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210719144942.861561397@linuxfoundation.org>
 <20210719144953.504491331@linuxfoundation.org>
 <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvqW9ZG8PFMyUobaiT2a_nAYyuJeWvRr0AuwB6eWMa+cQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, 19 Jul 2021 at 21:01, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:

> > From: Petr Vorel <petr.vorel@gmail.com>

> > [ Upstream commit f890f89d9a80fffbfa7ca791b78927e5b8aba869 ]

> > Reserve GPIO pins 85-88 as these aren't meant to be accessible from the
> > application CPUs (causes reboot). Yet another fix similar to
> > 9134586715e3, 5f8d3ab136d0, which is needed to allow angler to boot after
> > 3edfb7bd76bd ("gpiolib: Show correct direction from the beginning").

> > Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")

> > Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
> > Link: https://lore.kernel.org/r/20210415193913.1836153-1-petr.vorel@gmail.com
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts | 4 ++++
> >  1 file changed, 4 insertions(+)

> > diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > index dfa08f513dc4..e5850c4d3334 100644
> > --- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > +++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
> > @@ -38,3 +38,7 @@
> >                 };
> >         };
> >  };
> > +
> > +&tlmm {
> > +       gpio-reserved-ranges = <85 4>;
> > +};

> Following build errors noticed on arm64 architecture on on
> stable-rc linux-4.19.y
> stable-rc linux-4.14.y


> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> Error: /builds/linux/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts:42.1-6
> Label or path tlmm not found
> FATAL ERROR: Syntax error parsing input tree
> make[3]: *** [scripts/Makefile.lib:294:
> arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dtb] Error 1
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [/builds/linux/scripts/Makefile.build:544:
> arch/arm64/boot/dts/qcom] Error 2

> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Yes, this patch needs modification, because tlmm was added in v5.9 in
7c865b09b0a1 ("arm64: dts: qcom: msm8994: Modernize the DTS style").
Before it was msmgpio, thus substitute to it should fix it. I can verify it and
send correct patches, but this problem started since 3edfb7bd76bd (v4.20), thus
I'd prefer just skip linux-4.19.y and linux-4.14.y (unless 3edfb7bd76bd is
planning to be backported to it, which I don't think so).

Kind regards,
Petr


> reference build link,
> build: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/
> config: https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config


> steps to reproduce:
> ---------------------
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.

> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.

> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake

> # See https://docs.tuxmake.org/ for complete documentation.


> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1vXT4jBYUbNdKdLS1wz6gmXPVLM/config
