Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213E14FE38B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 16:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbiDLOS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 10:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiDLOS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 10:18:27 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D4618E0F
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 07:16:07 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id f38so33332734ybi.3
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 07:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VZmM9EPcGSQlgz+kYS2izYo6zL5xWSQuZ08uT1qVjbw=;
        b=IJSMbnG8TPYuyZvj12021vlIcBAbOe7ng6irRJOaNUc93/k2eKCPai9QsY7KQy5Mg3
         ZApGDWbS3SHlz0kkH1z6nVVfaV+z1B6lQXvoEPbkfIcGIVOdTt0O6wng0uSMxLfhCkOw
         kZICjAR4I0KlUkTjCyh6mcUv0OfAsaHSqXYSHZxEfCbB/qig2Z9MQ5GZOZmnDW/Xb/0u
         3g5Cvj1CRBnxwRis4L7jXySyj2qb+ygrm56xZiOCra4YdOu+6dUIkyXjoEo7Ml5l50kE
         29s3PXk0QgYeoK8Pmwna7EW3mDTuPg8EKSza/1JWDd/KYpr6vwy/WsQQ13tQ1kgQQedD
         Ha+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VZmM9EPcGSQlgz+kYS2izYo6zL5xWSQuZ08uT1qVjbw=;
        b=JLB5f3QnuvpHcPk5lTZtw4V/5rXvGR0CuJ12cekuFhCzP/YdaEWLGxRFTTRrH/5cfE
         DEBJ/IpOK8LMO9oERR/0BgAjU9OcPb8qQmKDHKpRVOJbWUbm1xjEhqxtIHmm6DxBqDQi
         OYSNGasxGwrdFYP2uNyPu9m6Acl+ZTbrEE0A4hv8ptPlvV93aylZ2lZye7AOGLPJVxdb
         ONXTnkDYe0r7Bx9e02sbEaHa1iLa0b6KSbXz4Ub9w1RuvYJrYXK1qjrJCOXq7uqukzEg
         PdGwQeQoYojkPKH/LPnBMKIZ8mqaROU7GQujbESWB6BiVn6dcZkjcHnqoWn8gt/luoRo
         tMNw==
X-Gm-Message-State: AOAM530Gsw5aR/LQ53TBGn3gvlIlj61PMCnoBoW96IaIPfBeLMfesueU
        DevXWz4v/e6IPmQ70yNM+++SjgyMeSeCACoz235BcA==
X-Google-Smtp-Source: ABdhPJxYt++M73uak2t/RGJYsU8i57AbTRDXlPselB+fJnbzE6SUVAWFIu2yBNHFy0tcESDeE5SS1Czru8m/rsUQKO0=
X-Received: by 2002:a25:c094:0:b0:641:10e0:cfd8 with SMTP id
 c142-20020a25c094000000b0064110e0cfd8mr12836500ybf.88.1649772966219; Tue, 12
 Apr 2022 07:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062942.022903016@linuxfoundation.org>
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Apr 2022 19:45:55 +0530
Message-ID: <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marco Elver <elver@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Apr 2022 at 12:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


On linux stable-rc 5.15 x86 and i386 builds failed due to below error [1]
with config [2].

The finding is when kunit config is enabled the builds pass.
CONFIG_KUNIT=y

But with CONFIG_KUNIT not set the builds failed.

x86_64-linux-gnu-ld: mm/kfence/core.o: in function `__kfence_alloc':
core.c:(.text+0x901): undefined reference to `filter_irq_stacks'
make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

I see these three commits, I will bisect and get back to you

2f222c87ceb4 kfence: limit currently covered allocations when pool nearly full
e25487912879 kfence: move saving stack trace of allocations into
__kfence_alloc()
d99355395380 kfence: count unexpectedly skipped allocations


--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/27h6Ztu4T35pY178Xg8EyAj7gIW/
[2] https://builds.tuxbuild.com/27h6Ztu4T35pY178Xg8EyAj7gIW/config
