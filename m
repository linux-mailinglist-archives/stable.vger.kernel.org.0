Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A26D224ED8
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 05:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGSDYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 23:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgGSDYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 23:24:13 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70983C0619D2;
        Sat, 18 Jul 2020 20:24:13 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p205so14233348iod.8;
        Sat, 18 Jul 2020 20:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VfYXONP7f5DFev6Rfp67qeylGPLCplY2PgNHGgPbNcE=;
        b=jVrHCC4gz/+MJwlUbZoQeUtwQ8e1WN/GcsiNos5XXHTXuUzxM5wmKroA5dGcNxpI8s
         0bXt3+417kBZmD5WmUhj/bI4D+Ns6sKs5T2cojzMUpIdcJNfkqGPMnpUf2ByPZgDHp3F
         6UhILQVetV6IZMsL7PQtr69zPwmDENKIjyLKydzNGpOnXpfbMS9sQAhY9A00knoWcUzG
         xNZH8lNilA0Fy5c27eauUomHrWp4hUtsLupHIp2E7Y4GghczYClk7hw0RuY3ExBf2ndB
         fKHt4l7yQ2BJXhVZJE6+yplrriTUJHE1Pss/BZQugoplcuoi7nTUZ3si7uewAj3wWN8f
         hfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VfYXONP7f5DFev6Rfp67qeylGPLCplY2PgNHGgPbNcE=;
        b=MdX6G8RiKapm5e5Yqu/Hxf8HuoYjYayqvPcrAHBAdwMr27Nvo8SrpjnAe+lGH08r1E
         1GQXG6NCBKlbZLpK90mc9vzdloHro9XFv07VBzDCR+Dz5dJJ4sX1pzcQE8lKEo3kXN85
         gr3Fg/mwZ9ESyfcXyYirVmchv7kMuSaultyNePB9nmrLN8eyvz4jtCBNFzyipoGW+s4M
         ZcHE4a00zPg9Jed2uRA+13bN/KHtgSyi9O5dbKOj3755bvGFERy2Mb2ezgCCiUB7L0fD
         64JfxSvvoKZgmKQyX4zZ4C2nUJnuFmdfk1Tsi/ZL9HsFn2CRK2zL+XEgNQQtYQXyH25j
         grNg==
X-Gm-Message-State: AOAM530jETKrOSpvAxxxvxkS4hL5SQ3UDsxss+xBJBC9+atI6TTv9TbX
        Zfgpnuya0cfy0aphbq4DupijWjmq3kpDZHGq+7w=
X-Google-Smtp-Source: ABdhPJz3HGoQMtHrd0tbQzKTT8j3j/xqKpqIprmQYXeOvr++uyzmWAkLhpRnbcSkH/aX7JTPtJKqflXVea8hpCTqgcw=
X-Received: by 2002:a05:6638:1308:: with SMTP id r8mr9731088jad.106.1595129052520;
 Sat, 18 Jul 2020 20:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sun, 19 Jul 2020 11:24:01 +0800
Message-ID: <CAAhV-H4wdxtLCAFOJE6wgAZdg+U5mquSZjHmAL_qsDaGtENbFg@mail.gmail.com>
Subject: Re: [PATCH -stable] MIPS: Fix build for LTS kernel caused by
 backporting lpj adjustment
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Serge,

Could you please have a look at this patch?

Huacai

On Thu, Jul 16, 2020 at 5:37 PM Huacai Chen <chenhc@lemote.com> wrote:
>
> Commit ed26aacfb5f71eecb20a ("mips: Add udelay lpj numbers adjustment")
> has backported to 4.4~5.4, but the "struct cpufreq_freqs" (and also the
> cpufreq notifier machanism) of 4.4~4.19 are different from the upstream
> kernel. These differences cause build errors, and this patch can fix the
> build.
>
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Stable <stable@vger.kernel.org> # 4.4/4.9/4.14/4.19
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kernel/time.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
> index b7f7e08..b15ee12 100644
> --- a/arch/mips/kernel/time.c
> +++ b/arch/mips/kernel/time.c
> @@ -40,10 +40,8 @@ static unsigned long glb_lpj_ref_freq;
>  static int cpufreq_callback(struct notifier_block *nb,
>                             unsigned long val, void *data)
>  {
> -       struct cpufreq_freqs *freq = data;
> -       struct cpumask *cpus = freq->policy->cpus;
> -       unsigned long lpj;
>         int cpu;
> +       struct cpufreq_freqs *freq = data;
>
>         /*
>          * Skip lpj numbers adjustment if the CPU-freq transition is safe for
> @@ -64,6 +62,7 @@ static int cpufreq_callback(struct notifier_block *nb,
>                 }
>         }
>
> +       cpu = freq->cpu;
>         /*
>          * Adjust global lpj variable and per-CPU udelay_val number in
>          * accordance with the new CPU frequency.
> @@ -74,12 +73,8 @@ static int cpufreq_callback(struct notifier_block *nb,
>                                                 glb_lpj_ref_freq,
>                                                 freq->new);
>
> -               for_each_cpu(cpu, cpus) {
> -                       lpj = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
> -                                           per_cpu(pcp_lpj_ref_freq, cpu),
> -                                           freq->new);
> -                       cpu_data[cpu].udelay_val = (unsigned int)lpj;
> -               }
> +               cpu_data[cpu].udelay_val = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
> +                                          per_cpu(pcp_lpj_ref_freq, cpu), freq->new);
>         }
>
>         return NOTIFY_OK;
> --
> 2.7.0
>
