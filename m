Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC65D5A6711
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiH3PNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 11:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiH3PNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 11:13:51 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E172A1286ED
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:13:48 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-33dc345ad78so281036327b3.3
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 08:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kM7acMdF6cP2XTczmIMdWw7ObA3zlg2C7wd0Gy3ndzQ=;
        b=GIsSh+bZLr80q71/H8qwkw7/2hINkD/uQ9lb1HXVTVJkN1+eT5+AX7aptuFqbAca08
         IX9qTUrv8JHLTbKT+tv+k2PMXlkYfXREIybobhvc/GKJslGHwwkCdpp4osFGEUMPKFKF
         JwUI9HSLUSTN4taKM6Rr2Xvthgjg1dVnX1RPbzQwMof66+HVEqOIxQxFt/E9obtVegqa
         4LNShzBGBQUpuT5k+mnPUQVsixR8szr1QoHaYns6c0jm+LeOqcAB8DkNGPe4/s5O2Y0U
         z+5uhF6q3AXsDjwy5Vv9obntXMtC80MQtoS6hUk4WO71ZoUA5QFz3I8x5HcbwLRYHvIn
         l42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kM7acMdF6cP2XTczmIMdWw7ObA3zlg2C7wd0Gy3ndzQ=;
        b=pCjaxkb0KHoqTuU4YqEi7bb0vY67V6zZdn/hCobz8sLYkNCC0LXQDd3+Itswaor348
         cDqeuACAronRq1TV+IEy/XUR9yxSPwiPYWEsToQotgK64g5hpKpQUN4yHqykk8ajI5IT
         0BJ6E3Rw/up09JLb3hEHW5bCrNQFpplRW98KG9e8fdCWdH5wL1OH9dKWZJ7o7VxlWhI3
         cCUOdhR/VIz14Cw8vZj2tFqKYCrvrEqMOKyj0bymtSj4tNF+jZ57hP48ssMGmkxZlUok
         oD+WS7bp0zDHZuhh2GsnyJIsiBk82V2n4PxLa9sqrDAZ3GHwVPGXr90Hbp3wO9yVlyzD
         pHhA==
X-Gm-Message-State: ACgBeo04kovNOHl1yGN1d2ZHbKgCnl0dGi0R+BL6kbgBYLt1Q7giazBf
        srcK7W9XXx3DQvaZ0LtS45339tlKS8OR9K4zoA65BQnNYMdMVg==
X-Google-Smtp-Source: AA6agR739EwW3P8VNQr8Clgz06k8vyk3t2VpBa86aQlw3qcdNgrc+rgbhmNPx6cuf68/p//Ow9sn0KAMWZQ/jArVMgA=
X-Received: by 2002:a25:2411:0:b0:695:9254:20fa with SMTP id
 k17-20020a252411000000b00695925420famr12228728ybk.639.1661872427649; Tue, 30
 Aug 2022 08:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220830150804.3425929-1-lucaswei@google.com>
In-Reply-To: <20220830150804.3425929-1-lucaswei@google.com>
From:   Lucas Wei <lucaswei@google.com>
Date:   Tue, 30 Aug 2022 23:13:31 +0800
Message-ID: <CAPTxkvS5etzB6jexmjPCsma4W=Lb2qveKher7GmCpgULugtv9Q@mail.gmail.com>
Subject: Re: [PATCH] arm64: errata: Add Cortex-A510 to the repeat tlbi list
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Robin Peng <robinpeng@google.com>,
        Will Deacon <willdeacon@google.com>,
        Aaron Ding <aaronding@google.com>,
        Daniel Mentz <danielmentz@google.com>,
        James Morse <james.morse@arm.com>
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

Hi Greg,

I send this mail through git send-email from kernel
guide(https://www.kernel.org/doc/html/v4.10/process/email-clients.html).
Would you help to confirm this could be applied on linux-5.15.y? Great thanks.

 - Lucas


On Tue, Aug 30, 2022 at 11:08 PM Lucas Wei <lucaswei@google.com> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> Cortex-A510 is affected by an erratum where in rare circumstances the
> CPUs may not handle a race between a break-before-make sequence on one
> CPU, and another CPU accessing the same page. This could allow a store
> to a page that has been unmapped.
>
> Work around this by adding the affected CPUs to the list that needs
> TLB sequences to be done twice.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Link: https://lore.kernel.org/r/20220704155732.21216-1-james.morse@arm.com
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  Documentation/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                     | 17 +++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c         |  8 +++++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
> index 0b4235b1f8c4..33b04db8408f 100644
> --- a/Documentation/arm64/silicon-errata.rst
> +++ b/Documentation/arm64/silicon-errata.rst
> @@ -106,6 +106,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A510     | #2077057        | ARM64_ERRATUM_2077057       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a5d1b561ed53..001eaba5a6b4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -838,6 +838,23 @@ config ARM64_ERRATUM_2224489
>
>           If unsure, say Y.
>
> +config ARM64_ERRATUM_2441009
> +       bool "Cortex-A510: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
> +       default y
> +       select ARM64_WORKAROUND_REPEAT_TLBI
> +       help
> +         This option adds a workaround for ARM Cortex-A510 erratum #2441009.
> +
> +         Under very rare circumstances, affected Cortex-A510 CPUs
> +         may not handle a race between a break-before-make sequence on one
> +         CPU, and another CPU accessing the same page. This could allow a
> +         store to a page that has been unmapped.
> +
> +         Work around this by adding the affected CPUs to the list that needs
> +         TLB sequences to be done twice.
> +
> +         If unsure, say Y.
> +
>  config ARM64_ERRATUM_2064142
>         bool "Cortex-A510: 2064142: workaround TRBE register writes while disabled"
>         depends on CORESIGHT_TRBE
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 6b92989f4cc2..aa9609e6ca67 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -211,6 +211,12 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
>                 /* Kryo4xx Gold (rcpe to rfpe) => (r0p0 to r3p0) */
>                 ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
>         },
> +#endif
> +#ifdef CONFIG_ARM64_ERRATUM_2441009
> +       {
> +               /* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */
> +               ERRATA_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
> +       },
>  #endif
>         {},
>  };
> @@ -488,7 +494,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  #endif
>  #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
>         {
> -               .desc = "Qualcomm erratum 1009, or ARM erratum 1286807",
> +               .desc = "Qualcomm erratum 1009, or ARM erratum 1286807, 2441009",
>                 .capability = ARM64_WORKAROUND_REPEAT_TLBI,
>                 .type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>                 .matches = cpucap_multi_entry_cap_matches,
> --
>
>


-- 

Lucas Wei
Embedded Software Engineer
lucaswei@google.com
0287260408
