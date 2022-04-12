Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613004FE44D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiDLPFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiDLPFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:05:13 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C08853B72
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:02:54 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ebebe631ccso119792267b3.4
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIbAv5l0ZDXFk0gGIWaCaLe3jbR9/lI410ENmUvMqQM=;
        b=kqj7qkJtL52OMGGmJXvu1R3jZsA6PdEDUae03GdOxaXFOJEtGO+7NTCEKbsuU5Q34R
         rzPMBK9/ZwZD9yftgLkTROTmNn+/sBaar5THDESNfmrFMQJMz0X9ngst5zUE4YvJVYi6
         NZ8VXVcQDFoYY//Jj/YXjqSxeROU0d7ullSZU4vrad54yHL2pzsX2GPeLVK/tdDbGkn0
         fTqrCVLQM1S95I4QeK4JAQIwE1br/bo46rTBbyJmtrSIc3u5rpL/XZyX0wkiVwCGPL/T
         lB0IWS6+TrtCKhBwlBvI2KNcHMu4SAEJCt4gZ9jbTHDl4SMFnm5BV/L5jrWXcxuSp7Ec
         tzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIbAv5l0ZDXFk0gGIWaCaLe3jbR9/lI410ENmUvMqQM=;
        b=DmvKqVQY6AKiSTWXm1aKn2l6zfCITo0VTicUfC+4e3T968kHUTVRlo2pAWJ5mFKEW+
         OTSMiTv7VoiRpdot/CyM7ZDshSy3fyGuRYdPW8J6G/2fgCiXZSziBwXNTV+URUFzqtNZ
         gncez9W4/Q8/UjHOHbUCAxIK6zvZ5UTU/OMTl72Wq/DSRPeEVs+aOHU7mD0MfZ5h4U9y
         Aq1+uJKjWpV6FBdMjU5h76KfO72wfShHd/HdRpKowbqD735NBkaKJtPq6rnJ2IPBhW8v
         kH87jBQE0D2IO2aR707aAEMBGlTl8nj1CzmyO2wVKJw0YvTBUDgWSHi+kKas417L1lIM
         uqLQ==
X-Gm-Message-State: AOAM531dNeFyFb//19NV3KC/XrQOTuw7kZZshXO9o5w6TNMhMfpnUPcM
        BHgJXCPiDpglGsv/516NjlnQj0IHLCzkis/uLKa29A==
X-Google-Smtp-Source: ABdhPJzhfSOvSjw+lOkAS14qwaHBIyYhHdoZcI0eRgLT+Oq6elsNJ0n3LPb6oFnFFgQ75oSoy4zjNkaN2iTGbdlHfkI=
X-Received: by 2002:a81:4e58:0:b0:2eb:5da0:e706 with SMTP id
 c85-20020a814e58000000b002eb5da0e706mr30458489ywb.412.1649775773341; Tue, 12
 Apr 2022 08:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062942.022903016@linuxfoundation.org> <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
In-Reply-To: <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 12 Apr 2022 17:02:17 +0200
Message-ID: <CANpmjNP4-jG=kW8FoQpmt4X64en5G=Gd-3zaBebPL7xDFFOHmA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Apr 2022 at 16:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 12 Apr 2022 at 12:11, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.34 release.
> > There are 277 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> On linux stable-rc 5.15 x86 and i386 builds failed due to below error [1]
> with config [2].
>
> The finding is when kunit config is enabled the builds pass.
> CONFIG_KUNIT=y
>
> But with CONFIG_KUNIT not set the builds failed.
>
> x86_64-linux-gnu-ld: mm/kfence/core.o: in function `__kfence_alloc':
> core.c:(.text+0x901): undefined reference to `filter_irq_stacks'
> make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> I see these three commits, I will bisect and get back to you
>
> 2f222c87ceb4 kfence: limit currently covered allocations when pool nearly full
> e25487912879 kfence: move saving stack trace of allocations into
> __kfence_alloc()
> d99355395380 kfence: count unexpectedly skipped allocations

My guess is that this commit is missing:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f39f21b3ddc7fc0f87eb6dc75ddc81b5bbfb7672

Thanks,
-- Marco
