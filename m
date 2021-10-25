Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C330439BAE
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhJYQi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 12:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhJYQi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 12:38:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60093C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:36:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r4so1668228edi.5
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 09:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0YCPuNr/jE/DiYF/X/UY/xrtet4ANRF/YP7k9DAYiI=;
        b=XuzLo1XBFGN75Y+Lqed4u4Wjb/BnyUYCJrJ1xdAJfMmX5dKGr6fz2wblpKXkVecOsx
         WyNJTEiontgfCQzWRRb8MaJibefktzOiu7SMhXCCVMDcILoWhQmRUzBJTqKhB++7sJ+C
         wqdrKZwm2m8Oh2Z/lUP8o2P0VwBehaKzPUkTHLUzT4WxFkZN0pl46mObimTUd5IitDD1
         2vbOb1bcrkFOfst3QvYufpaq0UBU678f+YNln0gdGE4ySyUxP/fZ5X/3/ecMxmqPVb5L
         VdS/cFjjaDfQ1vm8yzxNcj8+jJoxKfWphhagfoJRv+9Igh4AgIN1PYR1U7HdUinSkdQS
         dFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0YCPuNr/jE/DiYF/X/UY/xrtet4ANRF/YP7k9DAYiI=;
        b=AGqGH5s0/QpgUxUDPDoP4QRqcIc/aC/R9f04fDXD+ESkeEtKLeKPmuVOJrVbzzV1Pn
         eYsRN2RTZKsWQEvJ67k0UW4k6HfTAvrV+7sSv2ShDnHj1C0aTlUJdR767oH7DlLaB1Op
         jAfy7LSKtEcMpnukyTk9mV5o8sZ/r2EwCndckNIt9ZIIIbHx5sw22u4vWVNufAykAQXJ
         GxKc2g6lPdCiOHCAcyzhjyORWsj3T8SB/Op1pR+8p88tKpQuuV3eG5AKyk2YplxKZ0Bh
         wTw/bSplWAJqsrUNmYjvWFSek/5l0HTumZTIvHEQrCi1Rg+OxUcabVo2Q+ahTkjycMKf
         2H0A==
X-Gm-Message-State: AOAM532NHiXRNVBE+xGudYgeyrJt7I6lP9QurKb9tb1j3qdZFjC3yoff
        P9QNk683jb886eKR5DEM/Rm12zgM0tH6HYeV4PwgR9wBXYc=
X-Google-Smtp-Source: ABdhPJwmDr1M/Z7+RdwCNICcyiRPYILYrX2OyTjZHaycYqvh/mKvib8yj17tsgN2q9QO5BSdCD6X7siwPvOpj6BJ+6w=
X-Received: by 2002:a17:907:971e:: with SMTP id jg30mr23471825ejc.169.1635179789634;
 Mon, 25 Oct 2021 09:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuhRwQhByNkWQ4OLP7y5vBTGoWdW4KrJSzJizVsDzWQSA@mail.gmail.com>
 <YXbCFdz4R7cikpnE@archlinux-ax161>
In-Reply-To: <YXbCFdz4R7cikpnE@archlinux-ax161>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 25 Oct 2021 22:06:18 +0530
Message-ID: <CA+G9fYuyTO9+YFPKUF9+MGUFxLtbVA7E-WmihpNojuv_ox3NeQ@mail.gmail.com>
Subject: Re: i386: tinyconfig: perf_event.h:838:21: error: invalid output size
 for constraint '=q'
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Oct 2021 at 20:11, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi Naresh,
>
> On Sun, Oct 24, 2021 at 08:05:01AM +0530, Naresh Kamboju wrote:
> > Following i386 tinyconfig  clang-13 and clang-nightly failed on
> > stable-rc queue/5.4.
> >
> > Fail (119 errors) with status message
> > 'failure while building tuxmake target(s): default': ea3681525113
> >  ("net: enetc: fix ethtool counter name for PM0_TERR")
> >  i386 (tinyconfig) with clang-nightly
> > @ https://builds.tuxbuild.com/1zvtvNS4eyYkOMiXtFgR7n1k0Yc/
> >
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=i386
> > CROSS_COMPILE=i686-linux-gnu- HOSTCC=clang CC=clang
> > In file included from /builds/linux/arch/x86/events/amd/core.c:12:
> > /builds/linux/arch/x86/events/amd/../perf_event.h:838:21: error:
> > invalid output size for constraint '=q'
> >         u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
> >
> > build link,
> > https://builds.tuxbuild.com/1zvtvNS4eyYkOMiXtFgR7n1k0Yc/
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> I am surprised this is being reported as a new issue for 5.4, as it
> should have always had this error [1]. We did not fix this until 5.9
> [2], meaning that 5.10 and beyond is fine. The series that did fix it
> was rather long so I am not sure it is suitable for stable. My
> recommendation is to disable i386 testing for 5.4 and earlier with
> clang.

We will disable i386 clang builds on LTS 5.4.
Thank you.

- Naresh
