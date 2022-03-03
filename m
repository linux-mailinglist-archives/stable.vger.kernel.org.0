Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF054CC996
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 00:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiCCXBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 18:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiCCXBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 18:01:37 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A81F11BB
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 15:00:50 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id j15so11052651lfe.11
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 15:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uzDnW5yg9gD4SLCTn2ySS35TqchNbeOMrfXHixo0lLA=;
        b=VwAvsxxY90wThYNJu+ZRgGBfbrJfMp1jmdpIN8+AQLvDx6TQeRg414Ilga74/eQbYD
         N8IUZkl7pYh37hO8SVv8VJXHNcoDvEOJWJE8h5Jn8MuRurnOiFPrwUxIG+bYIuTCjYiB
         bNpf64X+gsbKrin4t2gcowRCOne1doJOlpbMXrdd7ztTsrZlr9oGebHfoQs2dB0dPOng
         ieXNvbSzs0Kw435vkl4NU4yQ/6b46PJoA+hUYnIVGstXLycblH06iBy35j8lTv9Tcf8l
         y/qtPYNm71Yq7Y2sJsx/fKWuJJ2i0NrQvI4IYC+PJtaAr4XOx8n76xpnPDY1GCtxzZs6
         +MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzDnW5yg9gD4SLCTn2ySS35TqchNbeOMrfXHixo0lLA=;
        b=qF/OOC53IA2/NkI8dbVVDt3G021aMFotoY/nNpvDsNmvZh5fFN4dioBqf4FAc+Sbyk
         Ht7XMiq8qZc8zXjRYx9ODncavTOLESikWX1Z6oQZQ13JcRWpt1IUgGhQ4uNf9WjMuBKH
         L4WUcMW9XhxvOoqPJ1v5li2GYHV7ZmtF3UrcDco01m142lbA7QjWrEkQoKELm4Yo5Oep
         ytscPhCfgBLYrdW24jxl+BOQAKOyVr6l5jq2hRDk/yWkOVLtc3LNAFTqesoDIDdCEghv
         OLNEd3umKyZEbVsl7SFvdi4sV/rk4P+WqMy1fE3lNy6pCj99dUu944+wXg+Wl7D+t+pH
         1IVg==
X-Gm-Message-State: AOAM530K1Rp8M8D5kUXswmz7I4yz1bcwEYxU1dYm4Sdws04EW1mvWiWc
        Kw4KQQITK7/pSFU1pOmRh/eCaaHoTTlIb4ll+zckkw==
X-Google-Smtp-Source: ABdhPJwTcQrY6J+nuVpEzWxPKyS1IKT+ksAYMwYQvv9eskUqkC/iDZjsaZUAF2Lul5xGqgk+3WYIo+kbBWN9WO04yGM=
X-Received: by 2002:a05:6512:260d:b0:445:c06e:8242 with SMTP id
 bt13-20020a056512260d00b00445c06e8242mr4033709lfb.157.1646348448054; Thu, 03
 Mar 2022 15:00:48 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com> <CAJZ5v0iOOmRY3uC1-ZGQ30VysMuAjGum=Lt4tkqNUjop+ikqZw@mail.gmail.com>
In-Reply-To: <CAJZ5v0iOOmRY3uC1-ZGQ30VysMuAjGum=Lt4tkqNUjop+ikqZw@mail.gmail.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Thu, 3 Mar 2022 15:00:37 -0800
Message-ID: <CAAYoRsVs_CB-dBGShksmXATRP3oGnD6uU-xQdSPjkRER+j6fTQ@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
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

On Wed, Mar 2, 2022 at 11:01 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Wed, Mar 2, 2022 at 5:06 AM Doug Smythies <dsmythies@telus.net> wrote:
> > On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > On Tue, Mar 1, 2022 at 6:18 PM Doug Smythies <dsmythies@telus.net> wrote:
> > > > On Tue, Mar 1, 2022 at 3:58 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > > On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
> > > > > > On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> > > > ...
> > > > > > >
> > > > > > > However, it was a bit racy, so maybe it's good that it was not complete.
> > > > > > >
> > > > > > > Below is a new version.
> > > > > >
> > > > > > Thanks for the new version. I just gave it a try,  and the occasional
> > > > > > long delay of cpufreq auto-adjusting I have seen can not be reproduced
> > > > > > after applying it.
> > > > >
> > > > > OK, thanks!
> > > > >
> > > > > I'll wait for feedback from Dough, though.
> > > >
> > > > Hi Rafael,
> > > >
> > > > Thank you for your version 2 patch.
> > > > I screwed up an overnight test and will have to re-do it.
> > > > However, I do have some results.
> > >
> > > Thanks for testing it!
> > >
> > > > From reading the patch code, one worry was the
> > > > potential to drive down the desired/required CPU
> > > > frequency for the main periodic workflow, causing
> > > > overruns, or inability of the task to complete its
> > > > work before the next period.
> > >
> > > It is not clear to me why you worried about that just from reading the
> > > patch?  Can you explain, please?
> >
> > It is already covered below. And a couple of further tests
> > directly contradict my thinking.
> >
> > > > I have always had overrun
> > > > information, but it has never been relevant before.
> > > >
> > > > The other worry was if the threshold of
> > > > turbo/not turbo frequency is enough.
> > >
> > > Agreed.
> >
> > Just as an easy example and test I did this on
> > top of this patch ("rjw-3"):
> >
> > doug@s19:~/kernel/linux$ git diff
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index f878a4545eee..5cbdd7e479e8 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -1980,7 +1980,7 @@ static void intel_pstate_update_perf_ctl(struct
> > cpudata *cpu)
> >          * P-states to prevent them from getting back to the high frequency
> >          * right away after getting out of deep idle.
> >          */
> > -       cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
> > +       cpuidle_update_retain_tick(pstate > (cpu->pstate.max_pstate >> 1));
>
> OK, but cpu->pstate.max_pstate / 2 may be almost
> cpu->pstate.min_pstate which would be better to use here IMO.

For my processor, i5-10600K, it works out to 2.05 GHz.
4.1 GHz / 2, whereas min pstate would be 0.8 GHz

> Or something like (cpu->pstate.max_pstate + cpu->pstate.min_pstate) /
> 2.  Can you try this one in particular?

Which I agree would be a much better general case to use.
For my processor that would be 2.45 GHz.
(4.1 + 0.8) / 2.

My code was just for testing, and I intended to go further than
we might want to for the final solution.

I'm holding off on trying your suggestion, for now.

> >         wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
> >  }
> >
> > > > I do not know how to test any final solution
> > > > thoroughly, as so far I have simply found a
> > > > good enough problematic example.
> > > > We have so many years of experience with
> > > > the convenient multi second NMI forcing
> > > > lingering high pstate clean up. I'd keep it
> > > > deciding within it if the TSC stuff needs to be
> > > > executed or not.
> > > >
> > > > Anyway...
> > > >
> > > > Base Kernel 5.17-rc3.
> > > > "stock" : unmodified.
> > > > "revert" : with commit b50db7095fe reverted
> > > > "rjw-2" : with this version2 patch added.
> > > >
> > > > Test 1 (as before. There is no test 2, yet.):
> > > > 347 Hertz work/sleep frequency on one CPU while others do
> > > > virtually no load but enough to increase the requested pstate,
> > > > but at around 0.02 hertz aggregate.
> > > >
> > > > It is important to note the main load is approximately
> > > > 38.6% @ 2.422 GHz, or 100% at 0.935 GHz.
> > > > and almost exclusively uses idle state 2 (of
> > > > 4 total idle states)
> > > >
> > > > /sys/devices/system/cpu/cpu7/cpuidle/state0/name:POLL
> > > > /sys/devices/system/cpu/cpu7/cpuidle/state1/name:C1_ACPI
> > > > /sys/devices/system/cpu/cpu7/cpuidle/state2/name:C2_ACPI
> > > > /sys/devices/system/cpu/cpu7/cpuidle/state3/name:C3_ACPI
> > > >
> > > > Turbostat was used. ~10 samples at 300 seconds per.
> > > > Processor package power (Watts):
> > > >
> > > > Workflow was run for 1 hour each time or 1249201 loops.
> > > >
> > > > revert:
> > > > ave: 3.00
> > > > min: 2.89
> > > > max: 3.08
> > >
> > > I'm not sure what the above three numbers are.
> >
> > Processor package power, Watts.
>
> OK
>
> > > > ave freq: 2.422 GHz.
> > > > overruns: 1.
> > > > max overrun time: 113 uSec.
> > > >
> > > > stock:
> > > > ave: 3.63 (+21%)
> > > > min: 3.28
> > > > max: 3.99
> > > > ave freq: 2.791 GHz.
> > > > overruns: 2.
> > > > max overrun time: 677 uSec.
> > > >
> > > > rjw-2:
> > > > ave: 3.14 (+5%)
> > > > min: 2.97
> > > > max: 3.28
> > > > ave freq: 2.635 GHz
> > >
> > > I guess the numbers above could be reduced still by using a P-state
> > > below the max non-turbo one as a limit.
> >
> > Yes, and for a test I did "rjw-3".
> >
> > > > overruns: 1042.
> > > > max overrun time: 9,769 uSec.
> > >
> > > This would probably get worse then, though.
> >
> > Yes, that was my expectation, but not what happened.
> >
> > rjw-3:
> > ave: 3.09 watts
> > min: 3.01 watts
> > max: 31.7 watts
>
> Did you mean 3.17 here?  It would be hard to get the average of 3.09
> if the max was over 30 W.

Yes, 3.17 watts was what I meant to write. Sorry for any confusion.

> > ave freq: 2.42 GHz.
> > overruns: 12. (I did not expect this.)
> > Max overruns time: 621 uSec.
> >
> > Note 1: IRQ's increased by 74%. i.e. it was going in
> > and out of idle a lot more.
>
> That's because the scheduler tick is allowed to run a lot more often
> in the given workload with the changed test above.

Agreed.

> > Note 2: We know that processor package power
> > is highly temperature dependent. I forgot to let my
> > coolant cool adequately after the kernel compile,
> > and so had to throw out the first 4 power samples
> > (20 minutes).
> >
> > I retested both rjw-2 and rjw-3, but shorter tests
> > and got 0 overruns in both cases.
> >
> > > ATM I'm not quite sure why this happens, but you seem to have some
> > > insight into it, so it would help if you shared it.
> >
> > My insight seems questionable.
> >
> > My thinking was that one can not decide if the pstate needs to go
> > down or not based on such a localized look. The risk being that the
> > higher periodic load might suffer overruns. Since my first test did exactly
> > that, I violated my own "repeat all tests 3 times before reporting rule".
> > Now, I am not sure what is going on.
> > I will need more time to acquire traces and dig into it.
>
> It looks like the workload's behavior depends on updating the CPU
> performance scaling governor sufficiently often.
>
> Previously, that happened through the watchdog workflow that is gone
> now.  The rjw-2/3 patch is attempting to make up for that by letting
> the tick run more often.
>
> Admittedly, it is somewhat unclear to me why there are not so many
> overruns in the "stock" kernel test.  Perhaps that's because the CPUs
> generally run fast enough in that case, so the P-state governor need
> not be updated so often for the CPU frequency to stay high and that's
> what determines the performance (and in turn that decides whether or
> not there are overruns and how often they occur).  The other side of
> the coin is that the updates don't occur often enough for the power
> draw to be reasonable, though.

Agreed.

I am observing higher CPU frequencies than expected, and can not
determine why in all cases. It is going to take several days before
I can either reply with more detail or disprove what I think I am observing.

> Presumably, when the P-state governor gets updated more often (via the
> scheduler tick), but not often enough, it effectively causes the
> frequency (and consequently the performance) to drop over relatively
> long time intervals (and hence the increased occurrence of overruns).
> If it gets updated even more often (like in rjw-3), though, it causes
> the CPU frequency to follow the utilization more precisely and so the
> CPUs don't run "too fast" or "too slowly" for too long.

Agreed.

> > I also did a 1 hour intel_pstate_tracer test, with rjw-2, on an idle system
> > and saw several long durations. This was expected as this patch set
> > wouldn't change durations by more than a few jiffies.
> > 755 long durations (>6.1 seconds), and 327.7 seconds longest.
