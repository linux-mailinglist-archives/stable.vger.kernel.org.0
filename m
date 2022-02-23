Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55924C05C4
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiBWAIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiBWAIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:08:00 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786611170
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:07:32 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id bn33so22135045ljb.6
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 16:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DRnUCeq7RhxofRKnHvz2Zt6Ulnd0nWu42vInzQeCpUU=;
        b=gLlGaMPrWisDrWPD9BBpwDnhS9QacKEHUfkI3grM3UNYBu7KC+g3xh347GfYI7gu39
         0zWchK3zy8xDE8BCGoUDRp/QHzUi6xeM/4Klmj+mUthnTf4k8eAUkhN0pC6SwtxdN7aW
         rPBDdgJNBk61l5CuStbPrR+IkhdOZgYvLC238m5UQVEZXs6/VPfegLJiv0VU39KOVSBG
         NMuKvWbOfZx/hm+zrjodNDRSkTeSQ4cNzFlz78BJBdrKWmLW5CkU95KtBnym9SKajc9C
         noYwRCeNWfoxTuQkhJVWt21Ez+UOeEwMTg1E3hLUm8O0RRAnCJVyLGIUjztGE36wlof0
         Cm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DRnUCeq7RhxofRKnHvz2Zt6Ulnd0nWu42vInzQeCpUU=;
        b=dgyaBTutXH9/RI8U79XR5MYuf+k8dOm6GRoBsvxlkv+tavXZCAzWAmA3+3wruciujV
         7ZNGKSRfAWJtW1//CA1Okf3l/e5XCTe+0dc7yp7RSWKh3RrxsYzZfwbCC6Nx1BhMgWf9
         ko+BI6rh3HO/8zaBDKYimeXQedL0a3yEkp1QfLzS6kx9nQ7ne8h6MHCw2Zzbrlra1Hjn
         azWMR2qUJn5uHFW820qaec/7sGTht1bFLo4nI8N2lc15MI4ho/Z+XCCmgBsAOYkEGNQW
         IlBcpQM1VYyBmIsbatIf64LjUD0026hh7/BqZ4hvfbRUvynhof9Wsq5/tSrWXvnNhqnF
         uJjw==
X-Gm-Message-State: AOAM532gpwiKUT07DP179j42Wu9DNoBLiPn/akVFO6V9fT4G0iToJV3H
        YX1zDWVAXhVhtyuYtKiPhrhldoi6+beHRY4I4uioWA==
X-Google-Smtp-Source: ABdhPJwC/LADZ4R4OBXF633UGkbE2MKA7ILxQwcGA62/vQjFqOlsUquq5EIkiFq1zbN8YRuPZfX6VwK/Jik1IT8x6Kw=
X-Received: by 2002:a05:651c:1793:b0:236:3642:b3e9 with SMTP id
 bn19-20020a05651c179300b002363642b3e9mr18881476ljb.472.1645574850804; Tue, 22
 Feb 2022 16:07:30 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com> <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
In-Reply-To: <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Tue, 22 Feb 2022 16:07:21 -0800
Message-ID: <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Feng Tang <feng.tang@intel.com>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I am about 1/2 way through testing Feng's "hacky debug patch",
let me know if I am wasting my time, and I'll abort. So far, it
works fine.

The compiler complains:

kernel/sched/idle.c: In function =E2=80=98do_idle=E2=80=99:
./include/linux/typecheck.h:12:18: warning: comparison of distinct
pointer types lacks a cast
   12 |  (void)(&__dummy =3D=3D &__dummy2); \
      |                  ^~
./include/linux/compiler.h:78:42: note: in definition of macro =E2=80=98unl=
ikely=E2=80=99
   78 | # define unlikely(x) __builtin_expect(!!(x), 0)
      |                                          ^
./include/linux/jiffies.h:106:3: note: in expansion of macro =E2=80=98typec=
heck=E2=80=99
  106 |   typecheck(unsigned long, b) && \
      |   ^~~~~~~~~
./include/linux/jiffies.h:154:35: note: in expansion of macro =E2=80=98time=
_after=E2=80=99
  154 | #define time_is_before_jiffies(a) time_after(jiffies, a)
      |                                   ^~~~~~~~~~
kernel/sched/idle.c:274:15: note: in expansion of macro =E2=80=98time_is_be=
fore_jiffies=E2=80=99
  274 |  if (unlikely(time_is_before_jiffies(expire))) {

Test 1: 347 Hertz work/sleep frequency on one CPU while others do
virtually no load, but at around 0.02 hertz aggregate.
Processor package power (Watts):

Kernel 5.17-rc3 + Feng patch (6 samples at 300 sec per):
Average: 3.2
Min: 3.1
Max: 3.3

Kernel 5.17-rc3 (Stock) re-stated:
> Stock: 5 samples @ 300 seconds per sample:
> average: 4.2 watts +31%
> minimum: 3.5 watts
> maximum: 4.9 watts

Kernel 5.17-rc3 with with b50db7095fe0 reverted. (Revert) re-stated:
> Revert: 5 samples @ 300 seconds per sample:
> average: 3.2 watts
> minimum: 3.1 watts
> maximum: 3.2 watts

I also ran intel_pstate_tracer.py for 5 hours 33 minutes
(20,000 seconds) on an idle system looking for long durations.
(just being thorough.) There were 12 occurrences of durations
longer than 6.1 seconds.
Max: 6.8 seconds. (O.K.)
I had expected about 3 seconds max, based on my
understanding of the patch code.

Old results restated, but corrected for a stupid mistake:

Stock:
1712 occurrences of durations longer than 6.1 seconds
Max: 303.6 seconds. (Bad)

Revert:
3 occurrences of durations longer than 6.1 seconds
Max: 6.5 seconds (O.K.)

On Tue, Feb 22, 2022 at 10:04 AM Rafael J. Wysocki <rafael@kernel.org> wrot=
e:
>
> On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
> >
> > On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada wrote:
> > > Hi Doug,
> > >
> > > I think you use CONFIG_NO_HZ_FULL.
> > > Here we are getting callback from scheduler. Can we check that if
> > > scheduler woke up on those CPUs?
> > > We can run "trace-cmd -e sched" and check in kernel shark if there is
> > > similar gaps in activity.
> >
> > Srinivas analyzed the scheduler trace data from trace-cmd, and thought =
is
> > related with the cpufreq callback is not called timeley from scheduling
> > events:
> >
> > "
> > I mean we ignore the callback when the target CPU is not a local CPU as
> > we have to do IPI to adjust MSRs.
> > This will happen many times when sched_wake will wake up a new CPU for
> > the thread (we will get a callack for the target) but once the remote
> > thread start executing "sched_switch", we will get a callback on local
> > CPU, so we will adjust frequencies (provided 10ms interval from the
> > last call).
> >
> > >From the trace file I see the scenario where it took 72sec between two
> > updates:
> > CPU 2
> > 34412.597161    busy=3D78         freq=3D3232653
> > 34484.450725    busy=3D63         freq=3D2606793
> >
> > There is periodic activity in between, related to active load balancing
> > in scheduler (since last frequency was higher these small work will
> > also run at higher frequency). But those threads are not CFS class, so
> > scheduler callback will not be called for them.
> >
> > So removing the patch removed a trigger which would have caused a
> > sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
>
> And so this behavior needs to be restored for the time being which
> means reverting the problematic commit for 5.17 if possible.
>
> It is unlikely that we'll get a proper fix before -rc7 and we still
> need to test it properly.
>
> > But calling for every class, will be too many callbacks and not sure we
> > can even call for "stop" class, which these migration threads are
> > using.
> > "
>
> Calling it for RT/deadline may not be a bad idea.
>
> schedutil takes these classes into account when computing the
> utilization now (see effective_cpu_util()), so doing callbacks only
> for CFS seems insufficient.
>
> Another way to avoid the issue at hand may be to prevent entering deep
> idle via PM QoS if the CPUs are running at high frequencies.
>
> > Following this direction, I made a hacky debug patch which should help
> > to restore the previous behavior.
> >
> > Doug, could you help to try it? thanks
> >
> > It basically tries to make sure the cpufreq-update-util be called timel=
y
> > even for a silent system with very few interrupts (even from tick).
> >
> > Thanks,
> > Feng
> >
> > From 6be5f5da66a847860b0b9924fbb09f93b2e2d6e6 Mon Sep 17 00:00:00 2001
> > From: Feng Tang <feng.tang@intel.com>
> > Date: Tue, 22 Feb 2022 22:59:00 +0800
> > Subject: [PATCH] idle/intel-pstate: hacky debug patch to make sure the
> >  cpufreq_update_util callback being called timely in silent system
> >
> > ---
> >  kernel/sched/idle.c  | 10 ++++++++++
> >  kernel/sched/sched.h | 13 +++++++++++++
> >  2 files changed, 23 insertions(+)
> >
> > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > index d17b0a5ce6ac..cc538acb3f1a 100644
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -258,15 +258,25 @@ static void cpuidle_idle_call(void)
> >   *
> >   * Called with polling cleared.
> >   */
> > +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
> >  static void do_idle(void)
> >  {
> >         int cpu =3D smp_processor_id();
> > +       u64 expire;
> >
> >         /*
> >          * Check if we need to update blocked load
> >          */
> >         nohz_run_idle_balance(cpu);
> >
> > +#ifdef CONFIG_X86_INTEL_PSTATE
>
> Why?  Doesn't this affect the other ccpufreq governors?

Yes, I have the same question.

>
> > +       expire =3D __this_cpu_read(last_util_update_time) + HZ * 3;
> > +       if (unlikely(time_is_before_jiffies(expire))) {
> > +               idle_update_util();
> > +               __this_cpu_write(last_util_update_time, get_jiffies_64(=
));
> > +       }
> > +#endif
> > +
> >         /*
> >          * If the arch has a polling bit, we maintain an invariant:
> >          *
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 0e66749486e7..2a8d87988d1f 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -2809,6 +2809,19 @@ static inline void cpufreq_update_util(struct rq=
 *rq, unsigned int flags)
> >         if (data)
> >                 data->func(data, rq_clock(rq), flags);
> >  }
> > +
> > +static inline void idle_update_util(void)
> > +{
> > +       struct update_util_data *data;
> > +       struct rq *rq =3D cpu_rq(raw_smp_processor_id());
> > +
> > +       data =3D rcu_dereference_sched(*per_cpu_ptr(&cpufreq_update_uti=
l_data,
> > +                                                 cpu_of(rq)));
> > +       if (data)
> > +               data->func(data, rq_clock(rq), 0);
> > +}
> > +
> > +
> >  #else
> >  static inline void cpufreq_update_util(struct rq *rq, unsigned int fla=
gs) {}
> >  #endif /* CONFIG_CPU_FREQ */
> > --
