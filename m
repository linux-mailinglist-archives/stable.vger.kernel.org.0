Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA53249E269
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 13:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbiA0McH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 07:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiA0McG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 07:32:06 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A700C061748
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:32:06 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id h14so8095028ybe.12
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=COpeNcGqK7rU8NWuuX70BzF9hjX60zHAg4InNi+lH9o=;
        b=pzVVpfcEntY+G5U9MHsg/CfJ2W1YSulSnlwD/sW0y8/+3ywkp9EZyR8pIz90nObFmH
         7ZlaJDdpb2iEkJBy2D6IKJvXEWUB9tOLoOSiCTImJE/7gAyFp0hJ3/cGO51n9K6wItUr
         MhQCoU6wLir8SOFlg0DmA6N0hoo/Cf5SWf1ATjExapkFMFghpuWZq9kcEmGEkgk39E6w
         d/PlRjsdYKvxsC4EvoOwaH2lttPKhFgp9551zW5lJPYLQMo7eiciaa7tvHXwMaNo99Eq
         daIWT5y50m46ZZ/LRGFT0yW3vpdySL76ga+ae3TYG2d5OMDDvRawpl/OBv78slda4IOB
         6+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=COpeNcGqK7rU8NWuuX70BzF9hjX60zHAg4InNi+lH9o=;
        b=SIC+0gHGW1ucpOU7KaA3VIspansJM1xFGvcv4/Iy6PinmW6HT8R+LNRo8wSARBisQZ
         PtY0ZWUYrc0RumsuMjlZ8Y7vsKoSQn/W7FEkkQq4xkYnnOdudiN87kviq8Rzkg4HaW21
         83XCLbDNka2XeVx/eZmtrywB656ph5E47cSFzeiHMes5Zk9D7/eCc257YxkTXCQ56GPV
         mpGXwv83gbVw5M7J5MNHlgbfGz3sGemL2QFO52fUbIivJTTLa03T2bLsrEfL20ijg8SC
         b1W5hT/Ozf+S/n6dsgLABodNUJG1pHD1e8ux5VmijHo8lGniWRCGH0ZzxgqOy3vfum6q
         S1Eg==
X-Gm-Message-State: AOAM531IfBdDA9+51/XqLt35q5Fb3sncfN1HIkyZTEgSkjGpeRS3YRX+
        iy6YFbCH34FYNLmsYpj9Rpi0W3c9SSRV5wEqB5jPcA==
X-Google-Smtp-Source: ABdhPJyzgIN/zJvjgm1gJJmqv/GrBPj+qbTmCJp+I7H1bg2/dqnsBjz5C7f1mfTByUR+0q77ysw6xdh5wWLkDBY3QlE=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr5574523ybo.108.1643286725423;
 Thu, 27 Jan 2022 04:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20220124184100.867127425@linuxfoundation.org> <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
 <ef6a4bcf-832b-3a5d-9643-827239293772@linaro.org> <CA+G9fYtTU_7DVaxwbLWnKBfqwbW51ebEoP=+vah7f6cWYSrKkQ@mail.gmail.com>
 <alpine.LRH.2.23.451.2201261532050.15350@MyRouter>
In-Reply-To: <alpine.LRH.2.23.451.2201261532050.15350@MyRouter>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 27 Jan 2022 18:01:53 +0530
Message-ID: <CA+G9fYt35cFuTWEP5-+Dq5K9ZzMQTd0OG679vQs+0+92EhHvmg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        Russell King <russell.king@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Jan 2022 at 21:05, Alan Maguire <alan.maguire@oracle.com> wrote:
>
> > Regressions detected on arm, arm64, i386, x86 on 5.15 and 5.10
> >
> > > >
> > > > This is one from arm64:
> > > >    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
> > > >    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
> > > >       17 |         if (in_bpf_jit(regs))
> > > >          |             ^~~~~~~~~~
> > > >    cc1: some warnings being treated as errors
> > > >    make[3]: *** [/builds/linux/scripts/Makefile.build:277: arch/arm64/mm/extable.o] Error 1
> > >
> > > Bisection here pointed to "arm64/bpf: Remove 128MB limit for BPF JIT programs". Reverting made the build succeed.
> >
> > arm64/bpf: Remove 128MB limit for BPF JIT programs
> > commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
>
> Thanks for the report!
>
> This one needs slightly different handling on 5.15. Russell had a 5.15
> patch for this (where BPF exception handling was still handled separately)
> and I've included it below. I verified it applies cleanly to the
> linux-5.15.y branch and builds.  I'd suggest either skipping backport of
> this fix to stable completely, or just applying the below to 5.15 and
> skipping further backports.

Build test pass with this patch on stable/linux-5.15.y.
I have not run any tests.

- Naresh
