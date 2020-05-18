Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8CB1D7593
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgERKv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:51:27 -0400
Received: from mail-oo1-f66.google.com ([209.85.161.66]:34032 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERKv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:51:27 -0400
Received: by mail-oo1-f66.google.com with SMTP id s139so1936141oos.1;
        Mon, 18 May 2020 03:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNMXSW+sgPzbz8sV3erf+BVgtCmbmji/K/QtFyrknmo=;
        b=s1CfJ7uhVTqb5RMP+t++4sBVZFwoxJv9g4uee/6P6MjaiyD0euuv17fCPFm1NjsYP/
         pmARXhuD0Cb4k169afAtx5woREgl1Ow0QcIz221jFyWto5mxFXRtaIefqPeoiRYiuRd4
         +XH4Um2iGVuBpcXLM+G02trzec0eNTnA3OwQ4112QE7l/+T7pm8Z3AKHpL6yGLV+rTVY
         t3pBFs9U7/5i2E4R1vzGM4b879BzcDFQ6K0vseg3q3H1dUXvrVl4SGq3Ws+AYNgOCVTW
         3ttenyx0RHvV4VrgZjSIJZTOye3HrRQdvXBg8fKzkg+psMQq8iz8ETbCezlL/BTCWhWg
         mgtg==
X-Gm-Message-State: AOAM532LKdoA/52i+Kp9GUrjqtB/Ei+JEfyE+HMPKXar2tmtPpK6EsBg
        SHjc44vMSWh+f2yvQIvNjZ7HExnIWoThNu4p9ouqGQ==
X-Google-Smtp-Source: ABdhPJwXKPHrVc2nshP6py5iOtERo4swV8insgwVVxqAdeRAgg41N/VGvu05gaipdg5BK+WXxE+QcFrnrrWttpBR3Ws=
X-Received: by 2002:a4a:e0d1:: with SMTP id e17mr12336167oot.1.1589799085973;
 Mon, 18 May 2020 03:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200518102415.k4c5qglodij5ac6h@vireshk-i7> <20200518103102.t3a3g4uxeeuwsnix@mobilestation>
 <5284478.EF2IWm2iUs@kreacher> <20200518104602.mjh2p5iltf2x4wmq@mobilestation>
In-Reply-To: <20200518104602.mjh2p5iltf2x4wmq@mobilestation>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 18 May 2020 12:51:15 +0200
Message-ID: <CAJZ5v0imYcL3M80S1snJAqXQ=GsqbChij-6aWx=4L02TKVvrQg@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw setting
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Serge Semin <fancer.lancer@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 12:46 PM Serge Semin
<Sergey.Semin@baikalelectronics.ru> wrote:
>
> On Mon, May 18, 2020 at 12:41:19PM +0200, Rafael J. Wysocki wrote:
> > On Monday, May 18, 2020 12:31:02 PM CEST Serge Semin wrote:
> > > On Mon, May 18, 2020 at 03:54:15PM +0530, Viresh Kumar wrote:
> > > > On 18-05-20, 12:22, Rafael J. Wysocki wrote:
> > > > > On Monday, May 18, 2020 12:11:09 PM CEST Viresh Kumar wrote:
> > > > > > On 18-05-20, 11:53, Rafael J. Wysocki wrote:
> > > > > > > That said if you really only want it to return 0 on success, you may as well
> > > > > > > add a ret = 0; statement (with a comment explaining why it is needed) after
> > > > > > > the last break in the loop.
> > > > > >
> > > > > > That can be done as well, but will be a bit less efficient as the loop
> > > > > > will execute once for each policy, and so the statement will run
> > > > > > multiple times. Though it isn't going to add any significant latency
> > > > > > in the code.
> > > > >
> > > > > Right.
> > > > >
> > > > > However, the logic in this entire function looks somewhat less than
> > > > > straightforward to me, because it looks like it should return an
> > > > > error on the first policy without a frequency table (having a frequency
> > > > > table depends on the driver and that is the same for all policies, so it
> > > > > is pointless to iterate any further in that case).
> > > > >
> > > > > Also, the error should not be -EINVAL, because that means "invalid
> > > > > argument" which would be the state value.
> > > > >
> > > > > So I would do something like this:
> > > > >
> > > > > ---
> > > > >  drivers/cpufreq/cpufreq.c |   11 ++++++-----
> > > > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > > >
> > > > > Index: linux-pm/drivers/cpufreq/cpufreq.c
> > > > > ===================================================================
> > > > > --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> > > > > +++ linux-pm/drivers/cpufreq/cpufreq.c
> > > > > @@ -2535,26 +2535,27 @@ EXPORT_SYMBOL_GPL(cpufreq_update_limits)
> > > > >  static int cpufreq_boost_set_sw(int state)
> > > > >  {
> > > > >         struct cpufreq_policy *policy;
> > > > > -       int ret = -EINVAL;
> > > > >
> > > > >         for_each_active_policy(policy) {
> > > > > +               int ret;
> > > > > +
> > > > >                 if (!policy->freq_table)
> > > > > -                       continue;
> > > > > +                       return -ENXIO;
> > > > >
> > > > >                 ret = cpufreq_frequency_table_cpuinfo(policy,
> > > > >                                                       policy->freq_table);
> > > > >                 if (ret) {
> > > > >                         pr_err("%s: Policy frequency update failed\n",
> > > > >                                __func__);
> > > > > -                       break;
> > > > > +                       return ret;
> > > > >                 }
> > > > >
> > > > >                 ret = freq_qos_update_request(policy->max_freq_req, policy->max);
> > > > >                 if (ret < 0)
> > > > > -                       break;
> > > > > +                       return ret;
> > > > >         }
> > > > >
> > > > > -       return ret;
> > > > > +       return 0;
> > > > >  }
> > > > >
> > > > >  int cpufreq_boost_trigger_state(int state)
> > > >
> > > > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > >
> > > Ok. Thanks for the comments. Shall I resend the patch with update Rafael
> > > suggests or you'll merge the Rafael's fix in yourself?
> >
> > I'll apply the fix directly, thanks!
>
> Great. Is it going to be available in the repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/
> ?

Yes, it is.  Please see the bleeding-edge branch in there, thanks!
