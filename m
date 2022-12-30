Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACCC659B7F
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiL3Stn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 13:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3Stm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 13:49:42 -0500
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8331AA3F;
        Fri, 30 Dec 2022 10:49:41 -0800 (PST)
Received: by mail-il1-f182.google.com with SMTP id u8so11708151ilq.13;
        Fri, 30 Dec 2022 10:49:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ef17OwmZTYJ+YKPmsBEYVOvL1BpHTwev+vCE7IeH1/8=;
        b=2RMs0AjdivBaa6yW0YFPQCsYzIjfZJ7aLiD2yCqu9AAwx19IEYqJY+LEXJbzKYiT0a
         CxA1VEsafVcvAxy+haOGgCoXBB3u1ZDwpjz/j0Hk5mxLgCpOwT0hanpo8DiCoCcT5HD6
         wQEfnYTWvybT4ETauZhJRJ1y4l4Msiz0s8UWvp2Atb/fOrxzlTTo75G1ylFq7cZBTZrM
         jia6hvqagNoUy4HKrHs8PLbuXI/HbkB0aNDYqczSFyGrHJVxjiHAUO/nT/E6yiwNWKGp
         irHyIXHnBKzKSLb8LwXOajf1DppMDUGQRusXqHpc2es8I0laNn8D1lT6laNiGamrr6bT
         Ztng==
X-Gm-Message-State: AFqh2koroewXxoL7P35jSgiNckI/Fm8KIkBEMUz+EYw+H23bjuLixCh+
        KMjhHTQA+pzLmwlwOUhn3U22ecwhv2n0Bi+67ll1hNKa
X-Google-Smtp-Source: AMrXdXsm39sNpY0bcz9H3tqkuNraq0MylJ74jqW4eniQQaGWZuw9igXIVkaYkBK6Shh9uvfQNqUEOnYED7htgwVYcK8=
X-Received: by 2002:a92:ab05:0:b0:30b:b015:376c with SMTP id
 v5-20020a92ab05000000b0030bb015376cmr2711454ilh.201.1672426181203; Fri, 30
 Dec 2022 10:49:41 -0800 (PST)
MIME-Version: 1.0
References: <20221228001005.2690278-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20221228001005.2690278-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 30 Dec 2022 19:49:29 +0100
Message-ID: <CAJZ5v0hy9X=4ZKCSY7W6LfqaFMqcc6GNzx8CdDkmjuUODcBC_Q@mail.gmail.com>
Subject: Re: [PATCH] thermal/drivers/int340x: Add missing attribute for data
 rate base
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 1:10 AM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> commit 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM
> driver")'
> added rfi_restriction_data_rate_base string, mmio details and
> documentation, but missed adding attribute to sysfs.
>
> Add missing sysfs attribute.
>
> Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
> Cc: stable@vger.kernel.org # v5.11+
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> ---
>  .../thermal/intel/int340x_thermal/processor_thermal_rfim.c    | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> index 8c42e7662033..92ed1213fe37 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> @@ -172,6 +172,7 @@ static const struct attribute_group fivr_attribute_group = {
>  RFIM_SHOW(rfi_restriction_run_busy, 1)
>  RFIM_SHOW(rfi_restriction_err_code, 1)
>  RFIM_SHOW(rfi_restriction_data_rate, 1)
> +RFIM_SHOW(rfi_restriction_data_rate_base, 1)
>  RFIM_SHOW(ddr_data_rate_point_0, 1)
>  RFIM_SHOW(ddr_data_rate_point_1, 1)
>  RFIM_SHOW(ddr_data_rate_point_2, 1)
> @@ -181,11 +182,13 @@ RFIM_SHOW(rfi_disable, 1)
>  RFIM_STORE(rfi_restriction_run_busy, 1)
>  RFIM_STORE(rfi_restriction_err_code, 1)
>  RFIM_STORE(rfi_restriction_data_rate, 1)
> +RFIM_STORE(rfi_restriction_data_rate_base, 1)
>  RFIM_STORE(rfi_disable, 1)
>
>  static DEVICE_ATTR_RW(rfi_restriction_run_busy);
>  static DEVICE_ATTR_RW(rfi_restriction_err_code);
>  static DEVICE_ATTR_RW(rfi_restriction_data_rate);
> +static DEVICE_ATTR_RW(rfi_restriction_data_rate_base);
>  static DEVICE_ATTR_RO(ddr_data_rate_point_0);
>  static DEVICE_ATTR_RO(ddr_data_rate_point_1);
>  static DEVICE_ATTR_RO(ddr_data_rate_point_2);
> @@ -248,6 +251,7 @@ static struct attribute *dvfs_attrs[] = {
>         &dev_attr_rfi_restriction_run_busy.attr,
>         &dev_attr_rfi_restriction_err_code.attr,
>         &dev_attr_rfi_restriction_data_rate.attr,
> +       &dev_attr_rfi_restriction_data_rate_base.attr,
>         &dev_attr_ddr_data_rate_point_0.attr,
>         &dev_attr_ddr_data_rate_point_1.attr,
>         &dev_attr_ddr_data_rate_point_2.attr,
> --

Applied as 6.2-rc material, thanks!
