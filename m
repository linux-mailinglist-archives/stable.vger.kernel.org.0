Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325964B3D02
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiBMSyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 13:54:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237904AbiBMSyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 13:54:21 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE765583B4
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 10:54:13 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id m14so5258305lfu.4
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 10:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uyV0fZKMNLC1nnke8AH8O+k077KaRJMIe5yNZP+9XIg=;
        b=duQB88ECPfjSiqqAgQLWneeDJrziiE8aLxper/a2bH+uPpM7xX3D9nKiH5AXZ9H/WT
         pHqQ0PaMt1bO3GXnnGII3LNjjxAzQzOI0NwupfO0b0UVw1gKqLV2j59z/Q+q2xdAbUpr
         kL4jaeTWaQ2JNsC3zQBHoMr6IsSErKgnfL7CZRkgFUCcb5UioV6HA4jkB0H88KktTt1W
         2J1NAAevOG/6DA+pmJQ1vq8z3avqjxINeF8EHTDS1LmkkitVgWElCQd56iitEDaK3JV3
         q8TRHgdUjb29hOEZ5CVSKS9DPNknY6FKb1IrMQ+LKocVozar3bu9hUjIYU87VucNj6lX
         5CbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uyV0fZKMNLC1nnke8AH8O+k077KaRJMIe5yNZP+9XIg=;
        b=c3buGIXKydgNihfV9SFuHFjA4yKSTocFQWMcgJu+8N2c/+jCsE4EIbCZxXNnDUSQVk
         EL8sXcwk20mNGj4qyPyNeoTnKboqCcplv+8BF6QiDO9wkzvUtAghIcwRdOh/6ppT9n6h
         GJL1Ybfwyn9AOwbjPRemQrx6RP1exBQa5HmQmrXZNI+hBh7KrQniBSuTjwYqUu0Ketl7
         HnO/t4Bk04d46U+P31vCE6dCON8YOEwqFKdqLP2fJTxAVkVrw+vlq28EWT3nsNTAHaqM
         uKgcOzkQ/MQVQjqtaV+G9wuaTRFXFgNcr62jtCltPhy4aBdIrcxcequ1rMaRJxYhPVhB
         9Eig==
X-Gm-Message-State: AOAM531GPXHreegwt4qttShlxZ8fGLn/41Mcwr9sMsYxODNt8X7Q7FkP
        812KqXKT58jgQfjVBZ2wldsxfI6Wh0wCgka8fWhyMg==
X-Google-Smtp-Source: ABdhPJxzZ8OOVzkk/aqg1HvZOn4VA5n8ahHkOaGvBw3dhJv8iyvntOkDnbvm1uFEYNYI8LTqDqJaI+rA6/ZmJ1UdEYM=
X-Received: by 2002:a05:6512:6c9:: with SMTP id u9mr7968198lff.207.1644778452055;
 Sun, 13 Feb 2022 10:54:12 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com>
In-Reply-To: <e185b89fb97f47758a5e10239fc3eed0@intel.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Sun, 13 Feb 2022 10:54:00 -0800
Message-ID: <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Zhang, Rui" <rui.zhang@intel.com>
Cc:     "Tang, Feng" <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        dsmythies <dsmythies@telus.net>
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

Hi Rui,

On Wed, Feb 9, 2022 at 11:45 PM Zhang, Rui <rui.zhang@intel.com> wrote:
> On 2022.02.09 14:23 Doug wrote:
> > On Tue, Feb 8, 2022 at 1:15 AM Feng Tang <feng.tang@intel.com> wrote:
> > > On Mon, Feb 07, 2022 at 11:13:00PM -0800, Doug Smythies wrote:
> > > > > >
> > > > > > Since kernel 5.16-rc4 and commit:
> > > > > > b50db7095fe002fa3e16605546cba66bf1b68a3e
> > > > > > " x86/tsc: Disable clocksource watchdog for TSC on qualified platorms"
> > > > > >
> > > > > > There are now occasions where times between calls to the driver
> > > > > > can be over 100's of seconds and can result in the CPU frequency
> > > > > > being left unnecessarily high for extended periods.
> > > > > >
> > > > > > From the number of clock cycles executed between these long
> > > > > > durations one can tell that the CPU has been running code, but
> > > > > > the driver never got called.
> > > > > >
> > > > > > Attached are some graphs from some trace data acquired using
> > > > > > intel_pstate_tracer.py where one can observe an idle system
> > > > > > between about 42 and well over 200 seconds elapsed time, yet
> > > > > > CPU10 never gets called, which would have resulted in reducing
> > > > > > it's pstate request, until an elapsed time of 167.616 seconds,
> > > > > > 126 seconds since the last call. The CPU frequency never does go to
> > minimum.
> > > > > >
> > > > > > For reference, a similar CPU frequency graph is also attached,
> > > > > > with the commit reverted. The CPU frequency drops to minimum,
> > > > > > over about 10 or 15 seconds.,
> > > > >
> > > > > commit b50db7095fe0 essentially disables the clocksource watchdog,
> > > > > which literally doesn't have much to do with cpufreq code.
> > > > >
> > > > > One thing I can think of is, without the patch, there is a
> > > > > periodic clocksource timer running every 500 ms, and it loops to
> > > > > run on all CPUs in turn. For your HW, it has 12 CPUs (from the
> > > > > graph), so each CPU will get a timer (HW timer interrupt backed)
> > > > > every 6 seconds. Could this affect the cpufreq governor's work
> > > > > flow (I just quickly read some cpufreq code, and seem there is
> > > > > irq_work/workqueue involved).
> > > >
> > > > 6 Seconds is the longest duration I have ever seen on this processor
> > > > before commit b50db7095fe0.
> > > >
> > > > I said "the times between calls to the driver have never exceeded 10
> > > > seconds" originally, but that involved other processors.
> > > >
> > > > I also did longer, 9000 second tests:
> > > >
> > > > For a reverted kernel the driver was called 131,743, and 0 times the
> > > > duration was longer than 6.1 seconds.
> > > >
> > > > For a non-reverted kernel the driver was called 110,241 times, and
> > > > 1397 times the duration was longer than 6.1 seconds, and the maximum
> > > > duration was 303.6 seconds
> > >
> > > Thanks for the data, which shows it is related to the removal of
> > > clocksource watchdog timers. And under this specific configurations,
> > > the cpufreq work flow has some dependence on that watchdog timers.
> > >
> > > Also could you share you kernel config, boot message and some system
> > > settings like for tickless mode, so that other people can try to
> > > reproduce? thanks
> >
> > I steal the kernel configuration file from the Ubuntu mainline PPA [1], what
> > they call "lowlatency", or 1000Hz tick. I make these changes before compile:
> >
> > scripts/config --disable DEBUG_INFO
> > scripts/config --disable SYSTEM_TRUSTED_KEYS scripts/config --disable
> > SYSTEM_REVOCATION_KEYS
> >
> > I also send you the config and dmesg files in an off-list email.
> >
> > This is an idle, and very low periodic loads, system type test.
> > My test computer has no GUI and very few services running.
> > Notice that I have not used the word "regression" yet in this thread, because
> > I don't know for certain that it is. In the end, we don't care about CPU
> > frequency, we care about wasting energy.
> > It is definitely a change, and I am able to measure small increases in energy
> > use, but this is all at the low end of the power curve.

Please keep the above statement in mind. The differences were rather minor,
Since Rui asks for data below, I have tried to find better examples.

> What do you use to measure the energy use? And what difference do you observe?

I use both turbostat and a processor power monitoring tool of my own.
Don't get me wrong, I love turbostat, but it has become somewhat heavy
(lots of code per interval) over recent years. My own utility has minimal
code per interval, only uses pre-allocated memory with no disk or terminal
interaction during the sampling phase, resulting in minimal system perturbation
due to itself.

> > So far I have not found a significant example of increased power use, but I
> > also have not looked very hard.

I looked a little harder for this reply, searching all single CPU
loads for a few
work/sleep frequencies (73, 113, 211, 347, 401 hertz) fixed work packet
per work interval.

> > During any test, many monitoring tools might shorten durations.
> > For example if I run turbostat, say:
> >
> > sudo turbostat --Summary --quiet --show
> > Busy%,Bzy_MHz,IRQ,PkgWatt,PkgTmp,RAMWatt,GFXWatt,CorWatt --
> > interval
> > 2.5
> >
> > Well, yes then the maximum duration would be 2.5 seconds, because
> > turbostat wakes up each CPU to inquire about things causing a call to the CPU
> > scaling driver. (I tested this, for about
> > 900 seconds.)
> >
> > For my power tests I use a sample interval of >= 300 seconds.
>
> So you use something like "turbostat sleep 900" for power test,

Typically I use 300 seconds for turbostat for this work.
It was only the other day, that I saw a duration of 302 seconds, so
yes I should try even longer, but it is becoming a tradeoff between
experiments taking many many hours and time available.

> and the RAPL Energy counters show the power difference?

Yes.

> Can you paste the turbostat output both w/ and w/o the watchdog?

Workflow:

Task 1: Purpose: main periodic load.

411 hertz work sleep frequency and about 26.6% load at 4.8 Ghz,
max_turbo (it would limit out at 100% duty cycle at about pstate 13)

Note: this is a higher load than I was using when I started this
email thread.

Task 2: Purpose: To assist in promoting manifestation of the
issue of potential concern with commit b50db7095fe0.

A short burst of work (about 30 milliseconds @ max turbo,
longer at lower frequencies), then sleep for 45 seconds.
Say, almost 0 load at 0.022 hertz.
Greater than or equal to 30 milliseconds at full load, ensures
that the intel_pstate driver will be called at least 2 or 3 times,
raising the requested pstate for that CPU.

Task 3: Purpose: Acquire power data with minimum system
perturbation due to this very monitoring task.

Both turbostat and my own power monitor were used, never
at the same time (unless just to prove they reported the same
power). This turbostat command:

turbostat --Summary --quiet --show
Busy%,Bzy_MHz,IRQ,PkgWatt,PkgTmp,RAMWatt,GFXWatt,CorWatt --interval
300

and my program also sampled at 300 second per sample,
typically 5 samples, and after 1/2 hour since boot.

Kernels:
stock: 5.17-rc3 as is.
revert: 5.17-rc3 with b50db7095fe0 reverted.

Test 1: no-hwp/active/powersave:

Doug's cpu_power_mon:

Stock: 5 samples @ 300 seconds per sample:
average: 4.7 watts +9%
minimum: 4.3 watts
maximum: 4.9 watts

Revert: 5 samples @ 300 seconds per sample:
average: 4.3 watts
minimum: 4.2 watts
maximum: 4.5 watts

Test 2: no-hwp/passive/schedutil:

In the beginning active/powersave was used
because it is the easiest (at least for me) to
understand and interpret the intel_pstate_tracer.py
results. Long durations are common in passive mode,
because something higher up can decide not to call the driver
because nothing changed. Very valuable lost information
in my opinion.

I didn't figure it out for awhile, but schedutil is bi-stable
with this workflow, depending on if it approaches steady
state from a higher or lower previous load (i.e. hysteresis).
With either kernel it might run for hours and hours at an
average of 6.1 watts or 4.9 watts. This difference dominates,
so trying to reveal if there is any contribution from the commit
of this thread is useless.

Test 3: Similar workflow as test1, but 347 Hertz and
a little less work per work period.

Task 2 was changed to use more CPUs to try
to potentially amplify manifestation of the effect.

 Doug's cpu_power_mon:

Stock: 5 samples @ 300 seconds per sample:
average: 4.2 watts +31%
minimum: 3.5 watts
maximum: 4.9 watts

Revert: 5 samples @ 300 seconds per sample:
average: 3.2 watts
minimum: 3.1 watts
maximum: 3.2 watts

Re-do test 1, but with the improved task 2:

Turbostat:

Stock:

doug@s19:~$ sudo
/home/doug/kernel/linux/tools/power/x86/turbostat/turbostat --Summary
--quiet --show Busy%,Bzy_MHz,IRQ,PkgWatt,PkgTmp,RAMWatt,GFXWatt,CorWatt
--interval 300
Busy%   Bzy_MHz IRQ     PkgTmp  PkgWatt CorWatt GFXWatt RAMWatt
4.09    3335    282024  36      5.79    5.11    0.00    0.89
4.11    3449    283286  34      6.06    5.40    0.00    0.89
4.11    3504    284532  35      6.35    5.70    0.00    0.89
4.11    3493    283908  35      6.26    5.60    0.00    0.89
4.11    3499    284243  34      6.27    5.62    0.00    0.89

Revert:

doug@s19:~/freq-scalers/long_dur$ sudo
/home/doug/kernel/linux/tools/power/x86/turbostat/turbostat --Summary
--quiet --show Busy%,Bzy_MHz,IRQ,PkgWatt,PkgTmp,RAMWatt,GFXWatt,CorWatt
--interval 300
Busy%   Bzy_MHz IRQ     PkgTmp  PkgWatt CorWatt GFXWatt RAMWatt
4.12    3018    283114  34      4.57    3.91    0.00    0.89
4.12    3023    283482  34      4.59    3.94    0.00    0.89
4.12    3017    282609  34      4.71    4.05    0.00    0.89
4.12    3013    282898  34      4.64    3.99    0.00    0.89
4.12    3013    282956  36      4.56    3.90    0.00    0.89
4.12    3026    282807  34      4.61    3.95    0.00    0.89
4.12    3026    282738  35      4.50    3.84    0.00    0.89

Or average of 6.2 watts versus 4.6 watts, +35%.

Several other tests had undetectable power differences
between kernels, but I did not go back and re-test with
the improved task 2.

>
> Thanks,
> rui
>
> > For duration only tests, turbostat is not run at the same time.
> >
> > My grub line:
> >
> > GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 consoleblank=314
> > intel_pstate=active intel_pstate=no_hwp msr.allow_writes=on
> > cpuidle.governor=teo"
> >
> > A typical pstate tracer command (with the script copied to the directory
> > where I run this stuff:):
> >
> > sudo ./intel_pstate_tracer.py --interval 600 --name vnew02 --memory
> > 800000
> >
> > >
> > > > > Can you try one test that keep all the current setting and change
> > > > > the irq affinity of disk/network-card to 0xfff to let interrupts
> > > > > from them be distributed to all CPUs?
> > > >
> > > > I am willing to do the test, but I do not know how to change the irq
> > > > affinity.
> > >
> > > I might say that too soon. I used to "echo fff > /proc/irq/xxx/smp_affinity"
> > > (xx is the irq number of a device) to let interrupts be distributed to
> > > all CPUs long time ago, but it doesn't work on my 2 desktops at hand.
> > > Seems it only support one-cpu irq affinity in recent kernel.
> > >
> > > You can still try that command, though it may not work.
> >
> > I did not try this yet.
> >
> > [1] https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17-rc3/
