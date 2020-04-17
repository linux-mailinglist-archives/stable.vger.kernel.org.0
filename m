Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0856A1AD67C
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 08:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDQGxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 02:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728083AbgDQGxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 02:53:39 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48072C061A10
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 23:53:39 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a9so512453ybc.8
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 23:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yxn0m71LOQ+yfqIoKnaxQru/WU+91bOpFnDXhCTjaGY=;
        b=OtXjWj0ztDLuiReEQ27WKPoBs2lsPAa9IF/+OZD7Iyl/nWfWbpiwJ434B1vBDRmH+D
         +6oD7sa1GH4ArE8FxGxF6zbNagFaVn3L5fR4gSss0wZsjUCE90kuDe78JTUFCc3G4E3C
         2nhTCZQSx8Y791TPEZVQAlUNZyIuYRC+7n/scGUo+RI6qiNfdhdoXFHc3RXYNHtw02qD
         jLFxyuqc3Q+96Yniy2doYOsKskRCsgWZq3lj6CjVQoZ47oV7sGJi6xAe6Qc06cmXBpYm
         d8170t75hYb8OOrTvY5B89s413DQ1a3cZA24lqaHf2E3nT6rH3brIzPC92CySeOxeh36
         daoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yxn0m71LOQ+yfqIoKnaxQru/WU+91bOpFnDXhCTjaGY=;
        b=glHD4vwJoELt/g8d2lYmkfZzwpcfpeYJEQcjr/kEeDA+sSLpeKRlOQZnpmEAnfba/s
         MRe7h+ynvsw3jC+XtWQwszQRXjeeC3Efv0K+7HAQjEy93eTj83xq6xWeYKN9JkIElgWK
         dYvzkTAOvSErgK2FlmvJzwCcVNxritFEbc3SozhJn4YHVMRaQDn+ROV9WLi0nhf+Iwl7
         ukjuGCJDm683run7Zj99VvKzROOMeMYB5ipEFWPa5+nXKdzASpTwBgg2DWFZr49cO7i6
         fOXkN2YRei+n9/A3NVUOMfsY3xICdM5stsePc64WPRHmlJjZuBNwaL01TDUbSIuM8l+I
         hAHw==
X-Gm-Message-State: AGi0PuYkBLycCvvo7u+bx3tjxmFTMfHgr6T57Z32CB4lmVZlG9ISMWMp
        Thbx11lEOxYGCgnDzIsGgUMTCzALiTrtbyWV7TCQXg==
X-Google-Smtp-Source: APiQypJhD2GihUBl8eAMpn/dweoXChUqbWXvNvgzEZ0Bo54Gt61TIkG3TcQ0qGerVwZMLd5XLzfaqLuncNzYkwjwcgc=
X-Received: by 2002:a5b:d51:: with SMTP id f17mr3148187ybr.87.1587106418318;
 Thu, 16 Apr 2020 23:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=KemTXaXR6UBU94M3hw@mail.gmail.com>
In-Reply-To: <CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=KemTXaXR6UBU94M3hw@mail.gmail.com>
From:   Masami Hiramatsu <masami.hiramatsu@linaro.org>
Date:   Fri, 17 Apr 2020 15:53:27 +0900
Message-ID: <CAA93ih2To3YN=L7VSa_RzVRV5OH9DTffd0zdKWB2M4CfE0Gp1Q@mail.gmail.com>
Subject: Re: WARNING: events/ipi.h:36 suspicious rcu_dereference_check() usage!
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rcu@vger.kernel.org, lkft-triage@lists.linaro.org,
        Leo Yan <leo.yan@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>, zanussi@kernel.org,
        svens@linux.ibm.com, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

It seems that *arm/arm64 specific* IPI trace event has caused this issue.
From the stacktrace, __update_max_tr() is invoked from do_idle() context.

------
__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
{
[SNIP]
        /* record this tasks comm */
        tracing_record_cmdline(tsk);
        latency_fsnotify(tr);  <<------here
}
------
And via latency_fsnotify(), it calls irq_work_queue().

------
void latency_fsnotify(struct trace_array *tr)
{
        if (!fsnotify_wq)
                return;
        /*
         * We cannot call queue_work(&tr->fsnotify_work) from here because =
it's
         * possible that we are called from __schedule() or do_idle(), whic=
h
         * could cause a deadlock.
         */
        irq_work_queue(&tr->fsnotify_irqwork); <<------- here
}
------
Please NOTE(*) that the above comment said that irq_work_queue()
should be SAFE from calling in do_idle(), this means it doesn't touch
any RCU.

And the irq_work_queue() finally kicks IPI via arch_irq_work_raise()
which causes an IPI.

--------<arm64: arch/arm64/kernel/smp.c>--------
#ifdef CONFIG_IRQ_WORK
void arch_irq_work_raise(void)
{
        if (__smp_cross_call)
                smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK=
);
}
#endif

static void smp_cross_call(const struct cpumask *target, unsigned int ipinr=
)
{
        trace_ipi_raise(target, ipi_types[ipinr]);  <<----- This
causes a warning!
        __smp_cross_call(target, ipinr);
}
-------
And trace_* macro touch the RCU. See include/linux/tracepoint.h:231
------
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
        extern struct tracepoint __tracepoint_##name;                   \
        static inline void trace_##name(proto)                          \
        {                                                               \
                if (static_key_false(&__tracepoint_##name.key))         \
                        __DO_TRACE(&__tracepoint_##name,                \
                                TP_PROTO(data_proto),                   \
                                TP_ARGS(data_args),                     \
                                TP_CONDITION(cond), 0);                 \
                if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {             \
                        rcu_read_lock_sched_notrace();                  \
                        rcu_dereference_sched(__tracepoint_##name.funcs);\
                        rcu_read_unlock_sched_notrace();                \
                }                                                       \
        }
------

BTW, this ipi_raise trace event is only used in arm/arm64.

$ git grep trace_ipi_raise
arch/arm/kernel/smp.c:  trace_ipi_raise_rcuidle(target, ipi_types[ipinr]);
arch/arm64/kernel/smp.c:        trace_ipi_raise(target, ipi_types[ipinr]);
include/trace/events/ipi.h: * __tracepoint_string, ideally the same as
used with trace_ipi_raise
include/trace/events/ipi.h: * __tracepoint_string, ideally the same as
used with trace_ipi_raise for

Thus, this only occurs on arm64 platform, but not on x86.

To fix this, maybe we need to remove this event or mark this is under
rcu watched (but is it really watched?)

Thank you,

2020=E5=B9=B44=E6=9C=888=E6=97=A5(=E6=B0=B4) 18:31 Naresh Kamboju <naresh.k=
amboju@linaro.org>:

>
> On arm64 qemu_arm64, juno-r2 and dragonboard-410c while running kselftest=
 ftrace
> on stable rc 5.5.1-rc1 to till today 5.5.16-rc2 and 5.6  found this
> kernel warning.
>
> [  386.349099] kselftest: Running tests in ftrace
> [  393.984018]
> [  393.984290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  393.984781] WARNING: suspicious RCU usage
> [  393.988690] 5.6.3-rc2 #1 Not tainted
> [  393.992679] -----------------------------
> [  393.996327] /usr/src/kernel/include/trace/events/ipi.h:36
> suspicious rcu_dereference_check() usage!
> [  394.000241]
> [  394.000241] other info that might help us debug this:
> [  394.000241]
> [  394.009094]
> [  394.009094] RCU used illegally from idle CPU!
> [  394.009094] rcu_scheduler_active =3D 2, debug_locks =3D 1
> [  394.017084] RCU used illegally from extended quiescent state!
> [  394.028187] 1 lock held by swapper/3/0:
> [  394.033826]  #0: ffff80001237b6a8 (max_trace_lock){....}, at:
> check_critical_timing+0x7c/0x1a8
> [  394.037480]
> [  394.037480] stack backtrace:
> [  394.046158] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.3-rc2 #1
> [  394.050584] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (D=
T)
> [  394.056663] Call trace:
> [  394.063515]  dump_backtrace+0x0/0x1e0
> [  394.065686]  show_stack+0x24/0x30
> [  394.069505]  dump_stack+0xe8/0x150
> [  394.072805]  lockdep_rcu_suspicious+0xcc/0x110
> [  394.076106]  arch_irq_work_raise+0x208/0x210
> [  394.080533]  __irq_work_queue_local+0x5c/0x80
> [  394.084959]  irq_work_queue+0x38/0x78
> [  394.089212]  __update_max_tr+0x150/0x218
> [  394.092858]  update_max_tr_single.part.82+0x98/0x100
> [  394.096851]  update_max_tr_single+0x1c/0x28
> [  394.101798]  check_critical_timing+0x198/0x1a8
> [  394.105705]  stop_critical_timings+0x128/0x148
> [  394.110221]  cpuidle_enter_state+0x74/0x4f8
> [  394.114645]  cpuidle_enter+0x3c/0x50
> [  394.118726]  call_cpuidle+0x44/0x80
> [  394.122542]  do_idle+0x22c/0x2d0
> [  394.125755]  cpu_startup_entry+0x28/0x48
> [  394.129229]  secondary_start_kernel+0x1b4/0x210
>
>
> metadata:
>   git branch: linux-5.5.y and linux-5.6.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-s=
table-rc-5.5/65/config
>
> Full test log,
> 5.6 test logs,
> https://lkft.validation.linaro.org/scheduler/job/1350627#L12612
> https://lkft.validation.linaro.org/scheduler/job/1350731#L9509
>
> 5.5 test logs,
> https://lkft.validation.linaro.org/scheduler/job/1322704#L9777
> https://lkft.validation.linaro.org/scheduler/job/1153369#L9745
> https://lkft.validation.linaro.org/scheduler/job/1351155#L8982
> https://lkft.validation.linaro.org/scheduler/job/1351065#L12349
>
> --
> Linaro LKFT
> https://lkft.linaro.org



--
Masami Hiramatsu
