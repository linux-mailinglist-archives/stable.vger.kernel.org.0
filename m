Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F2C4C9C56
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 05:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiCBEHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 23:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiCBEHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 23:07:18 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55158A9E07
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 20:06:35 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id b9so638873lfv.7
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 20:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwP/17SAMqDWK9rS3MpChCd9GusweTp8HOOLgfont+E=;
        b=KOLiNeDMHfWMVHhvak2rzCyDMZa9OirnYBlpX3lE12Q1dZDewa9wMKZcvGqIF4X2Wg
         zmy0A9A6XGZmQBZ6gE9WjNb9qGD8UJ5U/gF6Z19bSv4E8LFSLRC4YXJT3zf7Rd311Djp
         3gPyW8mo8RA8UurpMkrV5Q7DI9kMkDOBXzK5AGfkthd/bVWpwOh946XXnhlNrGNLiwOi
         Ap9CPLs4sPmFmyRfAbLAY04F+S9h2gRK+cG/7Mn4IoKPwYCcOtoJoAC8M7DJzHiMKiGT
         AO3n9RWXzsW2cKqdX/j6dznlnbwpNFXDDNXJohEfOg0UQTVnB3eIQ5e7YGYy8QkrQdel
         A25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwP/17SAMqDWK9rS3MpChCd9GusweTp8HOOLgfont+E=;
        b=whdxsvLZE5ZBDvujAAtHIKzvf5Vy0HHEHKNSI1+xQ05EF9IvDPiWefB1F+QmZtAH+s
         S0tYFHQ5/Ct/T5ca7+aVG5q0NCqOho4V0iHqpZMnYe+CFAFpcqfDbpN3XWnYk9j9utq/
         cyMhAR3MyuhF6qYIpeawGCzD6qOpDK56P/ejmLwet780EHC/BkHSaPyPNSvCfbuWiric
         12P14ugwLh2ITuxeyKRteDqOKLqjxqrmhXqOqCRjlzni/BqckbTi7eQz2HWfCY+iagw6
         +/D3+4Jujw1HPRkbC38M2/z+sMcL31ndqrcIpxMZT7NHYYArzuNBIW7JZg4EgRFQ3ryQ
         aODg==
X-Gm-Message-State: AOAM531wto59WUEAYnH7RyrcBGIr8RY5SSq1exQFFuqv2QASr5ATAI1f
        QVBLOMGf0m6Dx0WUEGZMNh1bbIpki9nG8BGMvLdEYg==
X-Google-Smtp-Source: ABdhPJxIhO5kUNzSwaTRh+eXLnX6KV8v/DAakMxV/KVN30eBs3fqzyAmURlOETVek1Sut/7HsytwAATILxvnL+4n9Jg=
X-Received: by 2002:a05:6512:23a2:b0:43e:da99:71c1 with SMTP id
 c34-20020a05651223a200b0043eda9971c1mr17458318lfv.515.1646193993625; Tue, 01
 Mar 2022 20:06:33 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com> <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
In-Reply-To: <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Tue, 1 Mar 2022 20:06:24 -0800
Message-ID: <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
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

On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Tue, Mar 1, 2022 at 6:18 PM Doug Smythies <dsmythies@telus.net> wrote:
> > On Tue, Mar 1, 2022 at 3:58 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
> > > > On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> > ...
> > > > >
> > > > > However, it was a bit racy, so maybe it's good that it was not complete.
> > > > >
> > > > > Below is a new version.
> > > >
> > > > Thanks for the new version. I just gave it a try,  and the occasional
> > > > long delay of cpufreq auto-adjusting I have seen can not be reproduced
> > > > after applying it.
> > >
> > > OK, thanks!
> > >
> > > I'll wait for feedback from Dough, though.
> >
> > Hi Rafael,
> >
> > Thank you for your version 2 patch.
> > I screwed up an overnight test and will have to re-do it.
> > However, I do have some results.
>
> Thanks for testing it!
>
> > From reading the patch code, one worry was the
> > potential to drive down the desired/required CPU
> > frequency for the main periodic workflow, causing
> > overruns, or inability of the task to complete its
> > work before the next period.
>
> It is not clear to me why you worried about that just from reading the
> patch?  Can you explain, please?

It is already covered below. And a couple of further tests
directly contradict my thinking.

> > I have always had overrun
> > information, but it has never been relevant before.
> >
> > The other worry was if the threshold of
> > turbo/not turbo frequency is enough.
>
> Agreed.

Just as an easy example and test I did this on
top of this patch ("rjw-3"):

doug@s19:~/kernel/linux$ git diff
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f878a4545eee..5cbdd7e479e8 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1980,7 +1980,7 @@ static void intel_pstate_update_perf_ctl(struct
cpudata *cpu)
         * P-states to prevent them from getting back to the high frequency
         * right away after getting out of deep idle.
         */
-       cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
+       cpuidle_update_retain_tick(pstate > (cpu->pstate.max_pstate >> 1));
        wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
 }

> > I do not know how to test any final solution
> > thoroughly, as so far I have simply found a
> > good enough problematic example.
> > We have so many years of experience with
> > the convenient multi second NMI forcing
> > lingering high pstate clean up. I'd keep it
> > deciding within it if the TSC stuff needs to be
> > executed or not.
> >
> > Anyway...
> >
> > Base Kernel 5.17-rc3.
> > "stock" : unmodified.
> > "revert" : with commit b50db7095fe reverted
> > "rjw-2" : with this version2 patch added.
> >
> > Test 1 (as before. There is no test 2, yet.):
> > 347 Hertz work/sleep frequency on one CPU while others do
> > virtually no load but enough to increase the requested pstate,
> > but at around 0.02 hertz aggregate.
> >
> > It is important to note the main load is approximately
> > 38.6% @ 2.422 GHz, or 100% at 0.935 GHz.
> > and almost exclusively uses idle state 2 (of
> > 4 total idle states)
> >
> > /sys/devices/system/cpu/cpu7/cpuidle/state0/name:POLL
> > /sys/devices/system/cpu/cpu7/cpuidle/state1/name:C1_ACPI
> > /sys/devices/system/cpu/cpu7/cpuidle/state2/name:C2_ACPI
> > /sys/devices/system/cpu/cpu7/cpuidle/state3/name:C3_ACPI
> >
> > Turbostat was used. ~10 samples at 300 seconds per.
> > Processor package power (Watts):
> >
> > Workflow was run for 1 hour each time or 1249201 loops.
> >
> > revert:
> > ave: 3.00
> > min: 2.89
> > max: 3.08
>
> I'm not sure what the above three numbers are.

Processor package power, Watts.
>
> > ave freq: 2.422 GHz.
> > overruns: 1.
> > max overrun time: 113 uSec.
> >
> > stock:
> > ave: 3.63 (+21%)
> > min: 3.28
> > max: 3.99
> > ave freq: 2.791 GHz.
> > overruns: 2.
> > max overrun time: 677 uSec.
> >
> > rjw-2:
> > ave: 3.14 (+5%)
> > min: 2.97
> > max: 3.28
> > ave freq: 2.635 GHz
>
> I guess the numbers above could be reduced still by using a P-state
> below the max non-turbo one as a limit.

Yes, and for a test I did "rjw-3".

> > overruns: 1042.
> > max overrun time: 9,769 uSec.
>
> This would probably get worse then, though.

Yes, that was my expectation, but not what happened.

rjw-3:
ave: 3.09 watts
min: 3.01 watts
max: 31.7 watts
ave freq: 2.42 GHz.
overruns: 12. (I did not expect this.)
Max overruns time: 621 uSec.

Note 1: IRQ's increased by 74%. i.e. it was going in
and out of idle a lot more.

Note 2: We know that processor package power
is highly temperature dependent. I forgot to let my
coolant cool adequately after the kernel compile,
and so had to throw out the first 4 power samples
(20 minutes).

I retested both rjw-2 and rjw-3, but shorter tests
and got 0 overruns in both cases.

> ATM I'm not quite sure why this happens, but you seem to have some
> insight into it, so it would help if you shared it.

My insight seems questionable.

My thinking was that one can not decide if the pstate needs to go
down or not based on such a localized look. The risk being that the
higher periodic load might suffer overruns. Since my first test did exactly
that, I violated my own "repeat all tests 3 times before reporting rule".
Now, I am not sure what is going on.
I will need more time to acquire traces and dig into it.

I also did a 1 hour intel_pstate_tracer test, with rjw-2, on an idle system
and saw several long durations. This was expected as this patch set
wouldn't change durations by more than a few jiffies.
755 long durations (>6.1 seconds), and 327.7 seconds longest.

... Doug
