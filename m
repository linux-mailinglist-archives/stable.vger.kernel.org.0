Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DAB1AD767
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgDQH2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgDQH2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:28:31 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B76C061A0F
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 00:28:30 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id o70so543516ybg.10
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 00:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=On7hVCbW2gcS9q0JDyZWMLbVPnO3Eh9J4fUzmD1tbQ0=;
        b=bS/dLkSQban7jd6y4myL5w5wx2c8pUnyO1DcxXiqM9WbFXTYsuslxNhFNyQf4cu1u8
         zOeFQFRMxYq7hYewFJ43mP9le1XPRfs+1kJSSWBE+Qh6PDeExkJ47KW9pJXioqUMuetA
         Pm6HPHcOGOy5LjsbF/h+9z1EHJp8Rj+9yDEw7IBRzqVq+aAy5KUGeOXVNiWvLqgYckdE
         rAUK+WvEr3wBBvVczmrkBA/G5Br5EKWcwR0c54AOUHK9yDCGSryZjlH6DJAFCd/gb/dw
         jvO16F1f6ZDdjKmZCwzB3BWPWgGIM63XdmIFnlkQyXCtFAJ3U+TjM5plx/zv1qjVkIkj
         cByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=On7hVCbW2gcS9q0JDyZWMLbVPnO3Eh9J4fUzmD1tbQ0=;
        b=T7Rxp759Hq7e9f3q/QfOi/eqk1vpkDfnTrdEHQM2Nakaw0fUsOKBDXexqcME74WHGI
         XchMYb+OHuIE3nnUGyryoCJxFUvALU/IsfGdNWM3q4KHL7qBilKixTkA+pI4XG0wQ8As
         I3ztV9w+bwDAV/8k6QJBTA9RNvvaFjWa/Nn4Lv0X+KLa2KO3oMyG7GAUOFiSXbwrus3A
         H1tubgFBCOrVUAukgugR3mxiO1u//FNIwLeKZK4e3NA/Er8A5uJ80dhqFumTWalV1xXt
         YiVKI5t3jphewtKZeJs+a6cMKw7ER5UE13y3hz2k+mebOyocnTBxyet9+QKKet8Y3U+c
         10vw==
X-Gm-Message-State: AGi0PubcgeAnUir0IG63as/fwcCVPHb8Mq14AurSgQxL/3stLfeUjijr
        xJiavX1WVtXalY8yFWu/sIKJNtCmGb9WBqRCFhtVbA==
X-Google-Smtp-Source: APiQypInZkaM/ry/YsRbuA3oLQ9PQPQY+dGDQQalzfHUmOiSvHzMxzivb0NAMQs4Ea7F2eyxlHvanDsb6h7WBEL/QGs=
X-Received: by 2002:a5b:d51:: with SMTP id f17mr3309919ybr.87.1587108509964;
 Fri, 17 Apr 2020 00:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=KemTXaXR6UBU94M3hw@mail.gmail.com>
 <CAA93ih2To3YN=L7VSa_RzVRV5OH9DTffd0zdKWB2M4CfE0Gp1Q@mail.gmail.com> <20200417071543.GA7316@leoy-ThinkPad-X240s>
In-Reply-To: <20200417071543.GA7316@leoy-ThinkPad-X240s>
From:   Masami Hiramatsu <masami.hiramatsu@linaro.org>
Date:   Fri, 17 Apr 2020 16:28:18 +0900
Message-ID: <CAA93ih2XMkRRvnqZhUoHy3v8+pEJDFGckOrG8OU4Y32SCft_wA@mail.gmail.com>
Subject: Re: WARNING: events/ipi.h:36 suspicious rcu_dereference_check() usage!
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rcu@vger.kernel.org, lkft-triage@lists.linaro.org,
        Anders Roxell <anders.roxell@linaro.org>, zanussi@kernel.org,
        svens@linux.ibm.com, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Leo,

2020=E5=B9=B44=E6=9C=8817=E6=97=A5(=E9=87=91) 16:15 Leo Yan <leo.yan@linaro=
.org>:
>
> On Fri, Apr 17, 2020 at 03:53:27PM +0900, Masami Hiramatsu wrote:
> > Hello,
> >
> > It seems that *arm/arm64 specific* IPI trace event has caused this issu=
e.
> > From the stacktrace, __update_max_tr() is invoked from do_idle() contex=
t.
> >

Good point! Yes, we can use trace_ipi_raise_rcuidle() to fix that.

Thank you,

> > ------
> > __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cp=
u)
> > {
> > [SNIP]
> >         /* record this tasks comm */
> >         tracing_record_cmdline(tsk);
> >         latency_fsnotify(tr);  <<------here
> > }
> > ------
> > And via latency_fsnotify(), it calls irq_work_queue().
> >
> > ------
> > void latency_fsnotify(struct trace_array *tr)
> > {
> >         if (!fsnotify_wq)
> >                 return;
> >         /*
> >          * We cannot call queue_work(&tr->fsnotify_work) from here beca=
use it's
> >          * possible that we are called from __schedule() or do_idle(), =
which
> >          * could cause a deadlock.
> >          */
> >         irq_work_queue(&tr->fsnotify_irqwork); <<------- here
> > }
> > ------
> > Please NOTE(*) that the above comment said that irq_work_queue()
> > should be SAFE from calling in do_idle(), this means it doesn't touch
> > any RCU.
> >
> > And the irq_work_queue() finally kicks IPI via arch_irq_work_raise()
> > which causes an IPI.
> >
> > --------<arm64: arch/arm64/kernel/smp.c>--------
> > #ifdef CONFIG_IRQ_WORK
> > void arch_irq_work_raise(void)
> > {
> >         if (__smp_cross_call)
> >                 smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_=
WORK);
> > }
> > #endif
> >
> > static void smp_cross_call(const struct cpumask *target, unsigned int i=
pinr)
> > {
> >         trace_ipi_raise(target, ipi_types[ipinr]);  <<----- This
> > causes a warning!
> >         __smp_cross_call(target, ipinr);
> > }
> > -------
> > And trace_* macro touch the RCU. See include/linux/tracepoint.h:231
> > ------
> > #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)=
 \
> >         extern struct tracepoint __tracepoint_##name;                  =
 \
> >         static inline void trace_##name(proto)                         =
 \
> >         {                                                              =
 \
> >                 if (static_key_false(&__tracepoint_##name.key))        =
 \
> >                         __DO_TRACE(&__tracepoint_##name,               =
 \
> >                                 TP_PROTO(data_proto),                  =
 \
> >                                 TP_ARGS(data_args),                    =
 \
> >                                 TP_CONDITION(cond), 0);                =
 \
> >                 if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {            =
 \
> >                         rcu_read_lock_sched_notrace();                 =
 \
> >                         rcu_dereference_sched(__tracepoint_##name.funcs=
);\
> >                         rcu_read_unlock_sched_notrace();               =
 \
> >                 }                                                      =
 \
> >         }
> > ------
> >
> > BTW, this ipi_raise trace event is only used in arm/arm64.
> >
> > $ git grep trace_ipi_raise
> > arch/arm/kernel/smp.c:  trace_ipi_raise_rcuidle(target, ipi_types[ipinr=
]);
> > arch/arm64/kernel/smp.c:        trace_ipi_raise(target, ipi_types[ipinr=
]);
> > include/trace/events/ipi.h: * __tracepoint_string, ideally the same as
> > used with trace_ipi_raise
> > include/trace/events/ipi.h: * __tracepoint_string, ideally the same as
> > used with trace_ipi_raise for
> >
> > Thus, this only occurs on arm64 platform, but not on x86.
> >
> > To fix this, maybe we need to remove this event or mark this is under
> > rcu watched (but is it really watched?)
>
> Good analysis, Masami :)
>
> Seems to me, Arm64 should study Arm platform to change using
> trace_ipi_raise_rcuidle() to work around the restriction so can allow the
> event to work in idle context?
>
> Thanks,
> Leo
>
> > 2020=E5=B9=B44=E6=9C=888=E6=97=A5(=E6=B0=B4) 18:31 Naresh Kamboju <nare=
sh.kamboju@linaro.org>:
> >
> > >
> > > On arm64 qemu_arm64, juno-r2 and dragonboard-410c while running kself=
test ftrace
> > > on stable rc 5.5.1-rc1 to till today 5.5.16-rc2 and 5.6  found this
> > > kernel warning.
> > >
> > > [  386.349099] kselftest: Running tests in ftrace
> > > [  393.984018]
> > > [  393.984290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [  393.984781] WARNING: suspicious RCU usage
> > > [  393.988690] 5.6.3-rc2 #1 Not tainted
> > > [  393.992679] -----------------------------
> > > [  393.996327] /usr/src/kernel/include/trace/events/ipi.h:36
> > > suspicious rcu_dereference_check() usage!
> > > [  394.000241]
> > > [  394.000241] other info that might help us debug this:
> > > [  394.000241]
> > > [  394.009094]
> > > [  394.009094] RCU used illegally from idle CPU!
> > > [  394.009094] rcu_scheduler_active =3D 2, debug_locks =3D 1
> > > [  394.017084] RCU used illegally from extended quiescent state!
> > > [  394.028187] 1 lock held by swapper/3/0:
> > > [  394.033826]  #0: ffff80001237b6a8 (max_trace_lock){....}, at:
> > > check_critical_timing+0x7c/0x1a8
> > > [  394.037480]
> > > [  394.037480] stack backtrace:
> > > [  394.046158] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.3-rc2 #1
> > > [  394.050584] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SB=
C (DT)
> > > [  394.056663] Call trace:
> > > [  394.063515]  dump_backtrace+0x0/0x1e0
> > > [  394.065686]  show_stack+0x24/0x30
> > > [  394.069505]  dump_stack+0xe8/0x150
> > > [  394.072805]  lockdep_rcu_suspicious+0xcc/0x110
> > > [  394.076106]  arch_irq_work_raise+0x208/0x210
> > > [  394.080533]  __irq_work_queue_local+0x5c/0x80
> > > [  394.084959]  irq_work_queue+0x38/0x78
> > > [  394.089212]  __update_max_tr+0x150/0x218
> > > [  394.092858]  update_max_tr_single.part.82+0x98/0x100
> > > [  394.096851]  update_max_tr_single+0x1c/0x28
> > > [  394.101798]  check_critical_timing+0x198/0x1a8
> > > [  394.105705]  stop_critical_timings+0x128/0x148
> > > [  394.110221]  cpuidle_enter_state+0x74/0x4f8
> > > [  394.114645]  cpuidle_enter+0x3c/0x50
> > > [  394.118726]  call_cpuidle+0x44/0x80
> > > [  394.122542]  do_idle+0x22c/0x2d0
> > > [  394.125755]  cpu_startup_entry+0x28/0x48
> > > [  394.129229]  secondary_start_kernel+0x1b4/0x210
> > >
> > >
> > > metadata:
> > >   git branch: linux-5.5.y and linux-5.6.y
> > >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
> > >   kernel-config:
> > > http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/lin=
ux-stable-rc-5.5/65/config
> > >
> > > Full test log,
> > > 5.6 test logs,
> > > https://lkft.validation.linaro.org/scheduler/job/1350627#L12612
> > > https://lkft.validation.linaro.org/scheduler/job/1350731#L9509
> > >
> > > 5.5 test logs,
> > > https://lkft.validation.linaro.org/scheduler/job/1322704#L9777
> > > https://lkft.validation.linaro.org/scheduler/job/1153369#L9745
> > > https://lkft.validation.linaro.org/scheduler/job/1351155#L8982
> > > https://lkft.validation.linaro.org/scheduler/job/1351065#L12349
> > >
> > > --
> > > Linaro LKFT
> > > https://lkft.linaro.org
> >
> >
> >
> > --
> > Masami Hiramatsu



--=20
Masami Hiramatsu
