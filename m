Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FDB570598
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGKOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiGKOar (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:30:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43497371A9
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 07:30:46 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e5so5069154iof.2
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 07:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VQpD+jvjG9U1/54uR4QOHF3dQss3LPJr/b6qsqI3Q8=;
        b=fj1eaBIGx0XNU0FpQmt+/JHyS0gzZDaZ3rUHwh7kXQf2qdwZ1i8tbvwOT0jYnyx8eT
         RWGfdxKl5/GRKHZnl48MRZ6ByRgvYSrvWqFo3baT00cYvS4N9II9ZzPARvbYCj0Sc01T
         mcQXzb585hQcTpUe9bXevBtCJ/WzMQFKsGOAt3FNqCrmP0EPFSQL9Qjv6aJHtC2zpyiC
         k51QWOpL5UM3MBQVSL3/WwgHg05zJDQKS+vCXN4nl8GFbF4elrSAsYhxxQBx+yB1a3x3
         A4HN6Efy+dCvZx6m3gzwct+NOqDbRa9b/nrr40+D3LV/Itkl84PJ//Ro6HFyL0gE0nUc
         q9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VQpD+jvjG9U1/54uR4QOHF3dQss3LPJr/b6qsqI3Q8=;
        b=siqsVQbtg9IVR5IZ/9xFe4pvQJZX2SGf23rvYAzet+DhvcbW+r2FkCOipJdtzmLTUk
         rCumIGuyMbptxKDGUVeZuqAyPlKXgha5HvQ9eopA4c7yiTHcLvGgzwxkrxDh7koEDA1N
         7mum8J26ToOIq/75P1ukWfrHdOZcsC0TqYXNAKKrB+6m4uxxm4BiHdCFs5okTIQCYZpo
         eHcmwFfRrPLfYUNEE4qWM+3wZICa8KbGmsldP/zDyfg41WmaddWP4M4jdY2PwMgqtTTV
         1yjSNvIS55otQ28dnr3SkdV7CeFYA+Nqvw+ZrI86JDEnZKttp7y6kQmN4ETZ6DAOh4gM
         JkBw==
X-Gm-Message-State: AJIora9AKNqNN00zs2I6Q3hpI1cuANJFEQP+CC4FjgkfgL5TAOwXQFYP
        nk5h4OmqCKYM7q7tFLQ1e+8kmuxVIpT0pJzlQz1CNyZcTSODRg==
X-Google-Smtp-Source: AGRyM1vb3rHEOPCMjvKX1cFN0GPl3eoD/vijRu7IyEyggbgDdS/YnigDU++XsfK9ii5mBMFn0j20lgRdJo/LAK7x6M4=
X-Received: by 2002:a05:6638:468e:b0:33e:be92:ec40 with SMTP id
 bq14-20020a056638468e00b0033ebe92ec40mr10537090jab.74.1657549845563; Mon, 11
 Jul 2022 07:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090604.055883544@linuxfoundation.org> <7c552ad4-81e9-2abe-3114-dd55c924844c@nvidia.com>
In-Reply-To: <7c552ad4-81e9-2abe-3114-dd55c924844c@nvidia.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Jul 2022 20:00:33 +0530
Message-ID: <CA+G9fYvUMLv8Sszs+TrgHsXrGOyJvdUiG_Ze4HAc_4rUp1cWOA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/230] 5.15.54-rc1 review
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 at 18:14, Jon Hunter <jonathanh@nvidia.com> wrote:
>
> Hi Greg,
>
> On 11/07/2022 10:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.54 release.
> > There are 230 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
>
> ...
>
> > Mark Rutland <mark.rutland@arm.com>
> >      irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
>
>
> The above change is missing a semi-colon and so is causing the following
> build error ...
>
> drivers/irqchip/irq-gic-v3.c: In function 'gic_handle_nmi':
> drivers/irqchip/irq-gic-v3.c:666:2: error: expected ';' before 'err'
>    err = handle_domain_nmi(gic_data.domain, irqnr, regs);
>    ^~~
>
> > Hou Tao <houtao1@huawei.com>
> >      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
>
> And the above commit is generating the following build error ...
>
> arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> arch/arm64/net/bpf_jit_comp.c:791:7: error: implicit declaration of
> function 'bpf_pseudo_func' [-Werror=implicit-function-declaration]
>     if (bpf_pseudo_func(insn))
>         ^~~~~~~~~~~~~~~
>
> These are seen with ARM64 builds.

I have also noticed these failures on arm64 and arm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

- Naresh

>
> Cheers
> Jon
>
> --
> nvpublic
