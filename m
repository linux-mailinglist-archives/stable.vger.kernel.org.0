Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70416640EB0
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 20:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiLBTqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 14:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbiLBTqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 14:46:39 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2887F3FAA;
        Fri,  2 Dec 2022 11:46:37 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id h16so6664388qtu.2;
        Fri, 02 Dec 2022 11:46:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yt0wmF0a++96BW0ABApkcWlkwutyseNN3f24uUrtD88=;
        b=fUNhtvhbhZpOxGGObFOKxDH9/OSGXCY8SFz6TFDwLDJqNVgbftepZK2ehevrB93UiV
         EMreZ9nUTSFt20A4Cx3DbRCwf5A8lRbT2N+XA4wMTQN5eEDfMQbvWju+aoBGGSWK7AHI
         M34mzwGk9OJpFH6cW2AuHhg++14M27Mt/35BsAlFw6XXhHuGYQBjhrNfW+x4lI1OaCHD
         3BduIERoiOYtceE/YELKZqALOl69ezU13FVhVNrS+Gno/6ApKG3Sl0hXcxvig/sB0fii
         rjj8EVcrZfFwgpmFScFhU3dZgqRjX305N8A1DOT4LMfys0IA+wLEPZtm+tPqTg8sjaro
         fYJg==
X-Gm-Message-State: ANoB5pnyEfN6G8074QJ/xhHxcbLlycCSW+2P0gQoHbKcEpViRBydU4Re
        7g6JPoM0rNip2HOYtgC1wOmuwbQ2GTGwTV7lcQk=
X-Google-Smtp-Source: AA0mqf4L9vUfM78+IFKlNHBPG8BCS2R5OW8RJjOWCGHjKW8XiUyhbPac1wNubiIE4PGn51wrEpQkhpc1KhBRPuupgm8=
X-Received: by 2002:ac8:4818:0:b0:3a6:a0d7:e1f7 with SMTP id
 g24-20020ac84818000000b003a6a0d7e1f7mr1779513qtq.153.1670010396808; Fri, 02
 Dec 2022 11:46:36 -0800 (PST)
MIME-Version: 1.0
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org>
 <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
 <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
In-Reply-To: <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Dec 2022 20:46:25 +0100
Message-ID: <CAJZ5v0hc8CsvqLKxi5iRq7iR0bkt25dRnLBd23mx-zdi2Sjgsw@mail.gmail.com>
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine mtk_cpufreq_voltage_tracking()"
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        regressions@leemhuis.info, daniel@makrotopia.org,
        thomas.huehn@hs-nordhausen.de, "v5 . 19+" <stable@vger.kernel.org>,
        Nick <vincent@systemli.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 2, 2022 at 1:17 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Fri, Dec 2, 2022 at 6:26 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >
> > This reverts commit 6a17b3876bc8303612d7ad59ecf7cbc0db418bcd.
> >
> > This commit caused regression on Banana Pi R64 (MT7622), revert until
> > the problem is identified and fixed properly.
> >
> > Link: https://lore.kernel.org/all/930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org/
> > Cc: v5.19+ <stable@vger.kernel.org> # v5.19+
> > Reported-by: Nick <vincent@systemli.org>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Do you want me to push this revert for -rc8?

After all, I've decided to queue it up for 6.2, thanks!

> > ---
> >  drivers/cpufreq/mediatek-cpufreq.c | 147 +++++++++++++++++++----------
> >  1 file changed, 96 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
> > index 7f2680bc9a0f..4466d0c91a6a 100644
> > --- a/drivers/cpufreq/mediatek-cpufreq.c
> > +++ b/drivers/cpufreq/mediatek-cpufreq.c
> > @@ -8,7 +8,6 @@
> >  #include <linux/cpu.h>
> >  #include <linux/cpufreq.h>
> >  #include <linux/cpumask.h>
> > -#include <linux/minmax.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_platform.h>
> > @@ -16,6 +15,8 @@
> >  #include <linux/pm_opp.h>
> >  #include <linux/regulator/consumer.h>
> >
> > +#define VOLT_TOL               (10000)
> > +
> >  struct mtk_cpufreq_platform_data {
> >         int min_volt_shift;
> >         int max_volt_shift;
> > @@ -55,7 +56,6 @@ struct mtk_cpu_dvfs_info {
> >         unsigned int opp_cpu;
> >         unsigned long current_freq;
> >         const struct mtk_cpufreq_platform_data *soc_data;
> > -       int vtrack_max;
> >         bool ccifreq_bound;
> >  };
> >
> > @@ -82,7 +82,6 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
> >         struct regulator *proc_reg = info->proc_reg;
> >         struct regulator *sram_reg = info->sram_reg;
> >         int pre_vproc, pre_vsram, new_vsram, vsram, vproc, ret;
> > -       int retry = info->vtrack_max;
> >
> >         pre_vproc = regulator_get_voltage(proc_reg);
> >         if (pre_vproc < 0) {
> > @@ -90,44 +89,91 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
> >                         "invalid Vproc value: %d\n", pre_vproc);
> >                 return pre_vproc;
> >         }
> > +       /* Vsram should not exceed the maximum allowed voltage of SoC. */
> > +       new_vsram = min(new_vproc + soc_data->min_volt_shift,
> > +                       soc_data->sram_max_volt);
> > +
> > +       if (pre_vproc < new_vproc) {
> > +               /*
> > +                * When scaling up voltages, Vsram and Vproc scale up step
> > +                * by step. At each step, set Vsram to (Vproc + 200mV) first,
> > +                * then set Vproc to (Vsram - 100mV).
> > +                * Keep doing it until Vsram and Vproc hit target voltages.
> > +                */
> > +               do {
> > +                       pre_vsram = regulator_get_voltage(sram_reg);
> > +                       if (pre_vsram < 0) {
> > +                               dev_err(info->cpu_dev,
> > +                                       "invalid Vsram value: %d\n", pre_vsram);
> > +                               return pre_vsram;
> > +                       }
> > +                       pre_vproc = regulator_get_voltage(proc_reg);
> > +                       if (pre_vproc < 0) {
> > +                               dev_err(info->cpu_dev,
> > +                                       "invalid Vproc value: %d\n", pre_vproc);
> > +                               return pre_vproc;
> > +                       }
> >
> > -       pre_vsram = regulator_get_voltage(sram_reg);
> > -       if (pre_vsram < 0) {
> > -               dev_err(info->cpu_dev, "invalid Vsram value: %d\n", pre_vsram);
> > -               return pre_vsram;
> > -       }
> > +                       vsram = min(new_vsram,
> > +                                   pre_vproc + soc_data->min_volt_shift);
> >
> > -       new_vsram = clamp(new_vproc + soc_data->min_volt_shift,
> > -                         soc_data->sram_min_volt, soc_data->sram_max_volt);
> > +                       if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> > +                               vsram = soc_data->sram_max_volt;
> >
> > -       do {
> > -               if (pre_vproc <= new_vproc) {
> > -                       vsram = clamp(pre_vproc + soc_data->max_volt_shift,
> > -                                     soc_data->sram_min_volt, new_vsram);
> > -                       ret = regulator_set_voltage(sram_reg, vsram,
> > -                                                   soc_data->sram_max_volt);
> > +                               /*
> > +                                * If the target Vsram hits the maximum voltage,
> > +                                * try to set the exact voltage value first.
> > +                                */
> > +                               ret = regulator_set_voltage(sram_reg, vsram,
> > +                                                           vsram);
> > +                               if (ret)
> > +                                       ret = regulator_set_voltage(sram_reg,
> > +                                                       vsram - VOLT_TOL,
> > +                                                       vsram);
> >
> > -                       if (ret)
> > -                               return ret;
> > -
> > -                       if (vsram == soc_data->sram_max_volt ||
> > -                           new_vsram == soc_data->sram_min_volt)
> >                                 vproc = new_vproc;
> > -                       else
> > +                       } else {
> > +                               ret = regulator_set_voltage(sram_reg, vsram,
> > +                                                           vsram + VOLT_TOL);
> > +
> >                                 vproc = vsram - soc_data->min_volt_shift;
> > +                       }
> > +                       if (ret)
> > +                               return ret;
> >
> >                         ret = regulator_set_voltage(proc_reg, vproc,
> > -                                                   soc_data->proc_max_volt);
> > +                                                   vproc + VOLT_TOL);
> >                         if (ret) {
> >                                 regulator_set_voltage(sram_reg, pre_vsram,
> > -                                                     soc_data->sram_max_volt);
> > +                                                     pre_vsram);
> >                                 return ret;
> >                         }
> > -               } else if (pre_vproc > new_vproc) {
> > +               } while (vproc < new_vproc || vsram < new_vsram);
> > +       } else if (pre_vproc > new_vproc) {
> > +               /*
> > +                * When scaling down voltages, Vsram and Vproc scale down step
> > +                * by step. At each step, set Vproc to (Vsram - 200mV) first,
> > +                * then set Vproc to (Vproc + 100mV).
> > +                * Keep doing it until Vsram and Vproc hit target voltages.
> > +                */
> > +               do {
> > +                       pre_vproc = regulator_get_voltage(proc_reg);
> > +                       if (pre_vproc < 0) {
> > +                               dev_err(info->cpu_dev,
> > +                                       "invalid Vproc value: %d\n", pre_vproc);
> > +                               return pre_vproc;
> > +                       }
> > +                       pre_vsram = regulator_get_voltage(sram_reg);
> > +                       if (pre_vsram < 0) {
> > +                               dev_err(info->cpu_dev,
> > +                                       "invalid Vsram value: %d\n", pre_vsram);
> > +                               return pre_vsram;
> > +                       }
> > +
> >                         vproc = max(new_vproc,
> >                                     pre_vsram - soc_data->max_volt_shift);
> >                         ret = regulator_set_voltage(proc_reg, vproc,
> > -                                                   soc_data->proc_max_volt);
> > +                                                   vproc + VOLT_TOL);
> >                         if (ret)
> >                                 return ret;
> >
> > @@ -137,24 +183,32 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
> >                                 vsram = max(new_vsram,
> >                                             vproc + soc_data->min_volt_shift);
> >
> > -                       ret = regulator_set_voltage(sram_reg, vsram,
> > -                                                   soc_data->sram_max_volt);
> > +                       if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> > +                               vsram = soc_data->sram_max_volt;
> > +
> > +                               /*
> > +                                * If the target Vsram hits the maximum voltage,
> > +                                * try to set the exact voltage value first.
> > +                                */
> > +                               ret = regulator_set_voltage(sram_reg, vsram,
> > +                                                           vsram);
> > +                               if (ret)
> > +                                       ret = regulator_set_voltage(sram_reg,
> > +                                                       vsram - VOLT_TOL,
> > +                                                       vsram);
> > +                       } else {
> > +                               ret = regulator_set_voltage(sram_reg, vsram,
> > +                                                           vsram + VOLT_TOL);
> > +                       }
> > +
> >                         if (ret) {
> >                                 regulator_set_voltage(proc_reg, pre_vproc,
> > -                                                     soc_data->proc_max_volt);
> > +                                                     pre_vproc);
> >                                 return ret;
> >                         }
> > -               }
> > -
> > -               pre_vproc = vproc;
> > -               pre_vsram = vsram;
> > -
> > -               if (--retry < 0) {
> > -                       dev_err(info->cpu_dev,
> > -                               "over loop count, failed to set voltage\n");
> > -                       return -EINVAL;
> > -               }
> > -       } while (vproc != new_vproc || vsram != new_vsram);
> > +               } while (vproc > new_vproc + VOLT_TOL ||
> > +                        vsram > new_vsram + VOLT_TOL);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -250,8 +304,8 @@ static int mtk_cpufreq_set_target(struct cpufreq_policy *policy,
> >          * If the new voltage or the intermediate voltage is higher than the
> >          * current voltage, scale up voltage first.
> >          */
> > -       target_vproc = max(inter_vproc, vproc);
> > -       if (pre_vproc <= target_vproc) {
> > +       target_vproc = (inter_vproc > vproc) ? inter_vproc : vproc;
> > +       if (pre_vproc < target_vproc) {
> >                 ret = mtk_cpufreq_set_voltage(info, target_vproc);
> >                 if (ret) {
> >                         dev_err(cpu_dev,
> > @@ -513,15 +567,6 @@ static int mtk_cpu_dvfs_info_init(struct mtk_cpu_dvfs_info *info, int cpu)
> >          */
> >         info->need_voltage_tracking = (info->sram_reg != NULL);
> >
> > -       /*
> > -        * We assume min voltage is 0 and tracking target voltage using
> > -        * min_volt_shift for each iteration.
> > -        * The vtrack_max is 3 times of expeted iteration count.
> > -        */
> > -       info->vtrack_max = 3 * DIV_ROUND_UP(max(info->soc_data->sram_max_volt,
> > -                                               info->soc_data->proc_max_volt),
> > -                                           info->soc_data->min_volt_shift);
> > -
> >         return 0;
> >
> >  out_disable_inter_clock:
> > --
