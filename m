Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960BC1D75DE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 13:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgERLGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 07:06:04 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40711 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgERLGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 07:06:04 -0400
Received: by mail-oi1-f196.google.com with SMTP id v128so8596347oia.7;
        Mon, 18 May 2020 04:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wmpjxGQuy4tiYJkt2jocarW0R5KqJW68O4d9EnN2j3I=;
        b=G55yI1py8Mr9nC3KibGyzpC56Rbsg4jJEvADlhXYQyZdwyF0KwBFrJmtatKh9Si4AF
         0cVgt8yJ/S3Of/m1aNZkqaPcYnBCTFVkIpxeUT/q2hP+u3ieTGcGmPySnAi5c3FsKOaD
         BmQJWdN8eeztomd9Vs6KbVKnr5Cj/RTxIVaFrsXTbq/YdOLLweG3PRw3ohhdcuMDKR2H
         k/1FjJ2NNb1bxSLVpCM3RMx1dSogTAGqzTanoDMHATl4U0SG6YLPhkVvwI7yUk0S8Qrd
         //306H5r92Yv/rP+9/N6ScakqdHV1uDE1PgTw/HGoxpDs6xeKkMfnlbuivqCCGRtqC59
         YsTg==
X-Gm-Message-State: AOAM530vz9dquQzhLJngEQxGCQ4D9Rt7vs2aP2WjkErptqhDJryNhZrp
        6icsRbGpK2/QqWZjBoyLTtz9ybto/8+xBV+7i/sEbA==
X-Google-Smtp-Source: ABdhPJznA+rHvhTX3YqvDWpLbINkDwCYfOSH6G0S7yviZXUhwGP7FykmSuPBMIvirGe61CZUgklItlvyABYwUvMg6rY=
X-Received: by 2002:a05:6808:486:: with SMTP id z6mr573511oid.103.1589799962685;
 Mon, 18 May 2020 04:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200518102415.k4c5qglodij5ac6h@vireshk-i7> <20200518103102.t3a3g4uxeeuwsnix@mobilestation>
 <5284478.EF2IWm2iUs@kreacher> <20200518104602.mjh2p5iltf2x4wmq@mobilestation>
 <CAJZ5v0imYcL3M80S1snJAqXQ=GsqbChij-6aWx=4L02TKVvrQg@mail.gmail.com> <20200518105649.gcv22l253lsuje7y@mobilestation>
In-Reply-To: <20200518105649.gcv22l253lsuje7y@mobilestation>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 18 May 2020 13:05:51 +0200
Message-ID: <CAJZ5v0juP6bsB9TRcned4nTQ=yFEOU5J2M7tt2bokYSYgoPPEg@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw setting
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 12:56 PM Serge Semin
<Sergey.Semin@baikalelectronics.ru> wrote:
>
> On Mon, May 18, 2020 at 12:51:15PM +0200, Rafael J. Wysocki wrote:
> > On Mon, May 18, 2020 at 12:46 PM Serge Semin
> > <Sergey.Semin@baikalelectronics.ru> wrote:
> > >
> > > On Mon, May 18, 2020 at 12:41:19PM +0200, Rafael J. Wysocki wrote:
> > > > On Monday, May 18, 2020 12:31:02 PM CEST Serge Semin wrote:
> > > > > On Mon, May 18, 2020 at 03:54:15PM +0530, Viresh Kumar wrote:
> > > > > > On 18-05-20, 12:22, Rafael J. Wysocki wrote:
> > > > > > > On Monday, May 18, 2020 12:11:09 PM CEST Viresh Kumar wrote:
> > > > > > > > On 18-05-20, 11:53, Rafael J. Wysocki wrote:
> > > > > > > > > That said if you really only want it to return 0 on success, you may as well
> > > > > > > > > add a ret = 0; statement (with a comment explaining why it is needed) after
> > > > > > > > > the last break in the loop.
> > > > > > > >
> > > > > > > > That can be done as well, but will be a bit less efficient as the loop
> > > > > > > > will execute once for each policy, and so the statement will run
> > > > > > > > multiple times. Though it isn't going to add any significant latency
> > > > > > > > in the code.
> > > > > > >
> > > > > > > Right.
> > > > > > >
> > > > > > > However, the logic in this entire function looks somewhat less than
> > > > > > > straightforward to me, because it looks like it should return an
> > > > > > > error on the first policy without a frequency table (having a frequency
> > > > > > > table depends on the driver and that is the same for all policies, so it
> > > > > > > is pointless to iterate any further in that case).
> > > > > > >
> > > > > > > Also, the error should not be -EINVAL, because that means "invalid
> > > > > > > argument" which would be the state value.
> > > > > > >
> > > > > > > So I would do something like this:
> > > > > > >
> > > > > > > ---
> > > > > > >  drivers/cpufreq/cpufreq.c |   11 ++++++-----
> > > > > > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > > > > > >
> > > > > > > Index: linux-pm/drivers/cpufreq/cpufreq.c
> > > > > > > ===================================================================
> > > > > > > --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> > > > > > > +++ linux-pm/drivers/cpufreq/cpufreq.c
> > > > > > > @@ -2535,26 +2535,27 @@ EXPORT_SYMBOL_GPL(cpufreq_update_limits)
> > > > > > >  static int cpufreq_boost_set_sw(int state)
> > > > > > >  {
> > > > > > >         struct cpufreq_policy *policy;
> > > > > > > -       int ret = -EINVAL;
> > > > > > >
> > > > > > >         for_each_active_policy(policy) {
> > > > > > > +               int ret;
> > > > > > > +
> > > > > > >                 if (!policy->freq_table)
> > > > > > > -                       continue;
> > > > > > > +                       return -ENXIO;
> > > > > > >
> > > > > > >                 ret = cpufreq_frequency_table_cpuinfo(policy,
> > > > > > >                                                       policy->freq_table);
> > > > > > >                 if (ret) {
> > > > > > >                         pr_err("%s: Policy frequency update failed\n",
> > > > > > >                                __func__);
> > > > > > > -                       break;
> > > > > > > +                       return ret;
> > > > > > >                 }
> > > > > > >
> > > > > > >                 ret = freq_qos_update_request(policy->max_freq_req, policy->max);
> > > > > > >                 if (ret < 0)
> > > > > > > -                       break;
> > > > > > > +                       return ret;
> > > > > > >         }
> > > > > > >
> > > > > > > -       return ret;
> > > > > > > +       return 0;
> > > > > > >  }
> > > > > > >
> > > > > > >  int cpufreq_boost_trigger_state(int state)
> > > > > >
> > > > > > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > > >
> > > > > Ok. Thanks for the comments. Shall I resend the patch with update Rafael
> > > > > suggests or you'll merge the Rafael's fix in yourself?
> > > >
> > > > I'll apply the fix directly, thanks!
> > >
> > > Great. Is it going to be available in the repo:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git/
> > > ?
> >
> > Yes, it is.  Please see the bleeding-edge branch in there, thanks!
>
> No credits with at least Reported-by tag? That's sad.(

OK, done now, but you are not the only reported of it, so I've added
the other reporter too.

Thanks!
