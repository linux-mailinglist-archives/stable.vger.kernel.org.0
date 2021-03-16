Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6105E33DCA1
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 19:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhCPSfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 14:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbhCPSeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 14:34:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ADCC061756
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 11:34:35 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so4289191wmq.1
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 11:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qx/er8fuhccr8BguU05iUFAp9XjYjtQPScA2OOEYemk=;
        b=W7nFX+hDSdd/0Gd1vIUso7G7eQ2pBaifnzTW/HFzXSIobmLXzfjj7sBaepS+Mkg+Hb
         OT+KJAc2fDar+48mhpa/WZv0NyOFbiB5H5YKGpWzRy8K2cDsLPjqhdtt7UWUglVWEglY
         aVhn/VAYwMVPreT1Y6+JncD4cpE+duPK1wIiZgiZrsbRKCwMIE1jOjacEIOr22F/POCR
         gMjd6NYaoJHFMZ0INDAfFWYEmh/XA3svo9gmma7FChxozGmF5HfmF+/Aye2l94pIPxwe
         ssH49uIMzv4J4jSsfFfXY4wGEyDdF70zxf2ffdlzzhGsBI9mM1Y24dfAjbtgAqJ2Zepw
         2SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qx/er8fuhccr8BguU05iUFAp9XjYjtQPScA2OOEYemk=;
        b=SbxyFM/zeKg+OsMKTTcZVLDoJ4bsAqjdbSifPkynqHNdjoWO0OODgtr0W+yiZ2OEbq
         2XyJFcX1orv7OAcT6uD8ZSiCLCBfUPIaHwKe0glqULDqlJyGzn2aWJQMWEoQ+5K10ekF
         Px0RRNJRJ24ASm00DSZ343zyxF/6gSAS67IcKbt9laPGrZJLfkEcScXC4iAaer7+1WNW
         vIw3vNbJBfu9qD2qEz0XBegV92ZDOArqBICbBAnaynxFofZHbbwPFneC3esZn7i6p6ZO
         i2Oo4i+zM1CvpxYGd75X5ccIVQ+vKaX6a+L/SGvWYj8xEBz4LlrY2IhGu7PyVyeDksY3
         /JSA==
X-Gm-Message-State: AOAM532OJo6IXsJbGqVTeiRMP8n0z5ibjCt48RkMSeZL35Eyu1ivx7W+
        b333mkco+l+D/UIT2xswjAZzb8SgcoSgG07qzlAzZA==
X-Google-Smtp-Source: ABdhPJylBjVfBvI+iCaqW6tcxwEnN7c+Dq/ObtuOvFB2WXu/no+yKNO/+zVI4piVVjd5YppwHKqgMTP7U6RJTLceCWM=
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr197595wma.188.1615919674161;
 Tue, 16 Mar 2021 11:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net> <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
 <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net> <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
 <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
In-Reply-To: <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
From:   Stephane Eranian <eranian@google.com>
Date:   Tue, 16 Mar 2021 11:34:22 -0700
Message-ID: <CABPqkBTdv-3ZFYy+=K3yYL1ccniC7TNHwv4TGysrxSHuR=_TOA@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 5:28 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 3/16/2021 3:22 AM, Namhyung Kim wrote:
> > Hi Peter and Kan,
> >
> > On Thu, Mar 4, 2021 at 5:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
> >>> On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
> >>>> On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
> >>
> >>>>> +++ b/arch/x86/events/intel/ds.c
> >>>>> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
> >>>>>                            continue;
> >>>>>                    }
> >>>>> -         /*
> >>>>> -          * On some CPUs the PEBS status can be zero when PEBS is
> >>>>> -          * racing with clearing of GLOBAL_STATUS.
> >>>>> -          *
> >>>>> -          * Normally we would drop that record, but in the
> >>>>> -          * case when there is only a single active PEBS event
> >>>>> -          * we can assume it's for that event.
> >>>>> -          */
> >>>>> -         if (!pebs_status && cpuc->pebs_enabled &&
> >>>>> -                 !(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
> >>>>> -                 pebs_status = cpuc->pebs_enabled;
> >>>>
> >>>> Wouldn't something like:
> >>>>
> >>>>                      pebs_status = p->status = cpus->pebs_enabled;
> >>>>
> >>>
> >>> I didn't consider it as a potential solution in this patch because I don't
> >>> think it's a proper way that SW modifies the buffer, which is supposed to be
> >>> manipulated by the HW.
> >>
> >> Right, but then HW was supposed to write sane values and it doesn't do
> >> that either ;-)
> >>
> >>> It's just a personal preference. I don't see any issue here. We may try it.
> >>
> >> So I mostly agree with you, but I think it's a shame to unsupport such
> >> chips, HSW is still a plenty useable chip today.
> >
> > I got a similar issue on ivybridge machines which caused kernel crash.
> > My case it's related to the branch stack with PEBS events but I think
> > it's the same issue.  And I can confirm that the above approach of
> > updating p->status fixed the problem.
> >
> > I've talked to Stephane about this, and he wants to make it more
> > robust when we see stale (or invalid) PEBS records.  I'll send the
> > patch soon.
> >
>
> Hi Namhyung,
>
> In case you didn't see it, I've already submitted a patch to fix the
> issue last Friday.
> https://lore.kernel.org/lkml/1615555298-140216-1-git-send-email-kan.liang@linux.intel.com/
> But if you have a more robust proposal, please feel free to submit it.
>
This fixes the problem on the older systems. The other problem we
identified related to the
PEBS sample processing code is that you can end up with uninitialized
perf_sample_data
struct passed to perf_event_overflow():

 setup_pebs_fixed_sample_data(pebs, data)
{
        if (!pebs)
                return;
        perf_sample_data_init(data);  <<< must be moved before the if (!pebs)
        ...
}

__intel_pmu_pebs_event(pebs, data)
{
        setup_sample(pebs, data)
        perf_event_overflow(data);
        ...
}

If there is any other reason to get a pebs = NULL in fix_sample_data()
or adaptive_sample_data(), then
you must call perf_sample_data_init(data) BEFORE you return otherwise
you end up in perf_event_overflow()
with uninitialized data and you may die as follows:

[<ffffffff812f283d>] ? perf_output_copy+0x4d/0xb0
[<ffffffff812e0fb1>] perf_output_sample+0x561/0xab0
[<ffffffff812e0952>] ? __perf_event_header__init_id+0x112/0x130
[<ffffffff812e1be1>] ? perf_prepare_sample+0x1b1/0x730
[<ffffffff812e21b9>] perf_event_output_forward+0x59/0x80
[<ffffffff812e0634>] ? perf_event_update_userpage+0xf4/0x110
[<ffffffff812e4468>] perf_event_overflow+0x88/0xe0
[<ffffffff810175b8>] __intel_pmu_pebs_event+0x328/0x380

This all stems from get_next_pebs_record_by_bit()  potentially
returning NULL but the NULL is not handled correctly
by the callers. This is what I'd like to see cleaned up in
__intel_pmu_pebs_event() to  avoid future problems.

I have a patch that moves the perf_sample_data_init() and I can send
it to LKML but it would also need the cleanup
for get_next_pebs_record_by_bit() to be complete.

Thanks.
