Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6227640698
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiLBMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiLBMSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:18:11 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265B298E99;
        Fri,  2 Dec 2022 04:18:10 -0800 (PST)
Received: by mail-qt1-f179.google.com with SMTP id fp23so4497041qtb.0;
        Fri, 02 Dec 2022 04:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuwvGudsv0NtoGLtvfgyPP/TQW5AhHw0IVTCNeOwnBw=;
        b=y1JDIN/SGP/KzFubFKbi1SxGOaz1uNbOIGQwXK8/uF+u1p8RWBVN5Zm/3CHgBVPrMD
         SjSyFS5yeYmJ4L2DPowQEve3lQr/8zZl+UD4Rv3AzCvFfaRC6CLAu188dF1GxGgBBTMd
         Ctpo4cxsw794WBIBQtoHgoPsOg9EMVnhPhe2/O5NI1XxfzPeBk8ncNkB6RxugCeAk3IQ
         G4ScVXVdSLL4SSqtKy7rAGBEY4kY0jUMkVp/Z3fn6F+QKlkoICezvta2ZHU68CvK9JAs
         09d5t7MgBdrFVuc9hVC6mqr1/tTHsR51XqyV/q2XUojhvUbY4PZQhu8AVJe4GUeYzDmp
         c6lQ==
X-Gm-Message-State: ANoB5pmKp91nyICUUjBr+RoEbNOWQR8RMe/mxIubZV35zARbwblweNZ+
        eEh/rsdzvaxApPscOPhS+Pnod4XcvnMzLCfe70A=
X-Google-Smtp-Source: AA0mqf47UpzJNAwavczJqxL1OfduIXAIqgAfLoludYj2DCWEzTTWY3GlrV+IR/EQxF8HCLz7qvm435/BStLvSXZoyCM=
X-Received: by 2002:a05:620a:51ca:b0:6ec:fa04:d97c with SMTP id
 cx10-20020a05620a51ca00b006ecfa04d97cmr45648191qkb.764.1669983489227; Fri, 02
 Dec 2022 04:18:09 -0800 (PST)
MIME-Version: 1.0
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org> <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
In-Reply-To: <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Dec 2022 13:17:56 +0100
Message-ID: <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine mtk_cpufreq_voltage_tracking()"
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
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

On Fri, Dec 2, 2022 at 6:26 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> This reverts commit 6a17b3876bc8303612d7ad59ecf7cbc0db418bcd.
>
> This commit caused regression on Banana Pi R64 (MT7622), revert until
> the problem is identified and fixed properly.
>
> Link: https://lore.kernel.org/all/930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org/
> Cc: v5.19+ <stable@vger.kernel.org> # v5.19+
> Reported-by: Nick <vincent@systemli.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Do you want me to push this revert for -rc8?

> ---
>  drivers/cpufreq/mediatek-cpufreq.c | 147 +++++++++++++++++++----------
>  1 file changed, 96 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
> index 7f2680bc9a0f..4466d0c91a6a 100644
> --- a/drivers/cpufreq/mediatek-cpufreq.c
> +++ b/drivers/cpufreq/mediatek-cpufreq.c
> @@ -8,7 +8,6 @@
>  #include <linux/cpu.h>
>  #include <linux/cpufreq.h>
>  #include <linux/cpumask.h>
> -#include <linux/minmax.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> @@ -16,6 +15,8 @@
>  #include <linux/pm_opp.h>
>  #include <linux/regulator/consumer.h>
>
> +#define VOLT_TOL               (10000)
> +
>  struct mtk_cpufreq_platform_data {
>         int min_volt_shift;
>         int max_volt_shift;
> @@ -55,7 +56,6 @@ struct mtk_cpu_dvfs_info {
>         unsigned int opp_cpu;
>         unsigned long current_freq;
>         const struct mtk_cpufreq_platform_data *soc_data;
> -       int vtrack_max;
>         bool ccifreq_bound;
>  };
>
> @@ -82,7 +82,6 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>         struct regulator *proc_reg = info->proc_reg;
>         struct regulator *sram_reg = info->sram_reg;
>         int pre_vproc, pre_vsram, new_vsram, vsram, vproc, ret;
> -       int retry = info->vtrack_max;
>
>         pre_vproc = regulator_get_voltage(proc_reg);
>         if (pre_vproc < 0) {
> @@ -90,44 +89,91 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>                         "invalid Vproc value: %d\n", pre_vproc);
>                 return pre_vproc;
>         }
> +       /* Vsram should not exceed the maximum allowed voltage of SoC. */
> +       new_vsram = min(new_vproc + soc_data->min_volt_shift,
> +                       soc_data->sram_max_volt);
> +
> +       if (pre_vproc < new_vproc) {
> +               /*
> +                * When scaling up voltages, Vsram and Vproc scale up step
> +                * by step. At each step, set Vsram to (Vproc + 200mV) first,
> +                * then set Vproc to (Vsram - 100mV).
> +                * Keep doing it until Vsram and Vproc hit target voltages.
> +                */
> +               do {
> +                       pre_vsram = regulator_get_voltage(sram_reg);
> +                       if (pre_vsram < 0) {
> +                               dev_err(info->cpu_dev,
> +                                       "invalid Vsram value: %d\n", pre_vsram);
> +                               return pre_vsram;
> +                       }
> +                       pre_vproc = regulator_get_voltage(proc_reg);
> +                       if (pre_vproc < 0) {
> +                               dev_err(info->cpu_dev,
> +                                       "invalid Vproc value: %d\n", pre_vproc);
> +                               return pre_vproc;
> +                       }
>
> -       pre_vsram = regulator_get_voltage(sram_reg);
> -       if (pre_vsram < 0) {
> -               dev_err(info->cpu_dev, "invalid Vsram value: %d\n", pre_vsram);
> -               return pre_vsram;
> -       }
> +                       vsram = min(new_vsram,
> +                                   pre_vproc + soc_data->min_volt_shift);
>
> -       new_vsram = clamp(new_vproc + soc_data->min_volt_shift,
> -                         soc_data->sram_min_volt, soc_data->sram_max_volt);
> +                       if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> +                               vsram = soc_data->sram_max_volt;
>
> -       do {
> -               if (pre_vproc <= new_vproc) {
> -                       vsram = clamp(pre_vproc + soc_data->max_volt_shift,
> -                                     soc_data->sram_min_volt, new_vsram);
> -                       ret = regulator_set_voltage(sram_reg, vsram,
> -                                                   soc_data->sram_max_volt);
> +                               /*
> +                                * If the target Vsram hits the maximum voltage,
> +                                * try to set the exact voltage value first.
> +                                */
> +                               ret = regulator_set_voltage(sram_reg, vsram,
> +                                                           vsram);
> +                               if (ret)
> +                                       ret = regulator_set_voltage(sram_reg,
> +                                                       vsram - VOLT_TOL,
> +                                                       vsram);
>
> -                       if (ret)
> -                               return ret;
> -
> -                       if (vsram == soc_data->sram_max_volt ||
> -                           new_vsram == soc_data->sram_min_volt)
>                                 vproc = new_vproc;
> -                       else
> +                       } else {
> +                               ret = regulator_set_voltage(sram_reg, vsram,
> +                                                           vsram + VOLT_TOL);
> +
>                                 vproc = vsram - soc_data->min_volt_shift;
> +                       }
> +                       if (ret)
> +                               return ret;
>
>                         ret = regulator_set_voltage(proc_reg, vproc,
> -                                                   soc_data->proc_max_volt);
> +                                                   vproc + VOLT_TOL);
>                         if (ret) {
>                                 regulator_set_voltage(sram_reg, pre_vsram,
> -                                                     soc_data->sram_max_volt);
> +                                                     pre_vsram);
>                                 return ret;
>                         }
> -               } else if (pre_vproc > new_vproc) {
> +               } while (vproc < new_vproc || vsram < new_vsram);
> +       } else if (pre_vproc > new_vproc) {
> +               /*
> +                * When scaling down voltages, Vsram and Vproc scale down step
> +                * by step. At each step, set Vproc to (Vsram - 200mV) first,
> +                * then set Vproc to (Vproc + 100mV).
> +                * Keep doing it until Vsram and Vproc hit target voltages.
> +                */
> +               do {
> +                       pre_vproc = regulator_get_voltage(proc_reg);
> +                       if (pre_vproc < 0) {
> +                               dev_err(info->cpu_dev,
> +                                       "invalid Vproc value: %d\n", pre_vproc);
> +                               return pre_vproc;
> +                       }
> +                       pre_vsram = regulator_get_voltage(sram_reg);
> +                       if (pre_vsram < 0) {
> +                               dev_err(info->cpu_dev,
> +                                       "invalid Vsram value: %d\n", pre_vsram);
> +                               return pre_vsram;
> +                       }
> +
>                         vproc = max(new_vproc,
>                                     pre_vsram - soc_data->max_volt_shift);
>                         ret = regulator_set_voltage(proc_reg, vproc,
> -                                                   soc_data->proc_max_volt);
> +                                                   vproc + VOLT_TOL);
>                         if (ret)
>                                 return ret;
>
> @@ -137,24 +183,32 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>                                 vsram = max(new_vsram,
>                                             vproc + soc_data->min_volt_shift);
>
> -                       ret = regulator_set_voltage(sram_reg, vsram,
> -                                                   soc_data->sram_max_volt);
> +                       if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> +                               vsram = soc_data->sram_max_volt;
> +
> +                               /*
> +                                * If the target Vsram hits the maximum voltage,
> +                                * try to set the exact voltage value first.
> +                                */
> +                               ret = regulator_set_voltage(sram_reg, vsram,
> +                                                           vsram);
> +                               if (ret)
> +                                       ret = regulator_set_voltage(sram_reg,
> +                                                       vsram - VOLT_TOL,
> +                                                       vsram);
> +                       } else {
> +                               ret = regulator_set_voltage(sram_reg, vsram,
> +                                                           vsram + VOLT_TOL);
> +                       }
> +
>                         if (ret) {
>                                 regulator_set_voltage(proc_reg, pre_vproc,
> -                                                     soc_data->proc_max_volt);
> +                                                     pre_vproc);
>                                 return ret;
>                         }
> -               }
> -
> -               pre_vproc = vproc;
> -               pre_vsram = vsram;
> -
> -               if (--retry < 0) {
> -                       dev_err(info->cpu_dev,
> -                               "over loop count, failed to set voltage\n");
> -                       return -EINVAL;
> -               }
> -       } while (vproc != new_vproc || vsram != new_vsram);
> +               } while (vproc > new_vproc + VOLT_TOL ||
> +                        vsram > new_vsram + VOLT_TOL);
> +       }
>
>         return 0;
>  }
> @@ -250,8 +304,8 @@ static int mtk_cpufreq_set_target(struct cpufreq_policy *policy,
>          * If the new voltage or the intermediate voltage is higher than the
>          * current voltage, scale up voltage first.
>          */
> -       target_vproc = max(inter_vproc, vproc);
> -       if (pre_vproc <= target_vproc) {
> +       target_vproc = (inter_vproc > vproc) ? inter_vproc : vproc;
> +       if (pre_vproc < target_vproc) {
>                 ret = mtk_cpufreq_set_voltage(info, target_vproc);
>                 if (ret) {
>                         dev_err(cpu_dev,
> @@ -513,15 +567,6 @@ static int mtk_cpu_dvfs_info_init(struct mtk_cpu_dvfs_info *info, int cpu)
>          */
>         info->need_voltage_tracking = (info->sram_reg != NULL);
>
> -       /*
> -        * We assume min voltage is 0 and tracking target voltage using
> -        * min_volt_shift for each iteration.
> -        * The vtrack_max is 3 times of expeted iteration count.
> -        */
> -       info->vtrack_max = 3 * DIV_ROUND_UP(max(info->soc_data->sram_max_volt,
> -                                               info->soc_data->proc_max_volt),
> -                                           info->soc_data->min_volt_shift);
> -
>         return 0;
>
>  out_disable_inter_clock:
> --
> 2.31.1.272.g89b43f80a514
>
