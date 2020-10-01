Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F727FB7C
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgJAIar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 04:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgJAIar (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 04:30:47 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B3CC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 01:30:47 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id s66so4602758otb.2
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 01:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KUP4nOmO27GvIMGKIaxkVHo/mCbaF8uYMimi3GxfNtA=;
        b=VKbY6J9OyqGf7fHFXwJC+DDxaNnvQR6cbUwJutEgb42gBiW1/vkts3EsPq6ndaGeSz
         KJ+YEf5nvaq9m4PNpbH8WCq6juZUKbGFOeZA8wr8p+JM9gZZYnRkBKuFLg0Drqic3x7N
         lpZr4CNV9wcF1uVxv9L2VlOP3hrjt7OHl/DB5HOsov2WETokRqKkNc8YVnORTDleqG92
         kwqt1+rCN57rGG/hppDIQ/eswB7Vf1liqBqaRxp9BbbzaEqBKn0KMD1MXWnqA+yfYB+s
         a9s3+FPFSKvTLAUjcOQODWxloz6AZnbSrBKTkwbFXZx7NuBUv6krmxkZvbusC66wl3gp
         1P7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KUP4nOmO27GvIMGKIaxkVHo/mCbaF8uYMimi3GxfNtA=;
        b=jlkNsRNXbM493EuTxkgYBw6UhttxvputiUqXcRN1umxn7Pm+u12MqjUHla//UgCx3P
         rwJAtvup9OhxoA+g39ZdOXyRIfOZQFlb+78UqloR54W8aUMNWD2o4ZlT6681MTjeWkkS
         +f2bTXDddALlyr8LEahUqwTtJeOhvq7jknMvOCtyPc0gDHAe7y4iSqfghwNQiVtcF5uF
         glPGWF3j1wUVArx8s9xsG3Sc7j6xHlU7jIUs2gR1bePjs8Rw6qJBwGhcYxUhdpP7Sdca
         YkrF9DRTJOchf6isqPg4iGFUxMJac9ZHbhfnI7+SV+CzDZvwGlI6r/L7+qy+jg32Icqz
         Oqog==
X-Gm-Message-State: AOAM533OZR0Cgs7j2xIASuHSOsdM0uNz4RGYHjJlUVVQcw9qUGvp+y6y
        rYdmFj+wRcTjWEjUKwGKPoitEjTIDf6Aui7fq0e2mA==
X-Google-Smtp-Source: ABdhPJxWjcNulncCIsj2aEd5Z8dCJSJH09RGEMfClX/q9mzdWF3+OyKYzP8nEhB+S/qcwD0p1ZOwpwV78O36h3tZntw=
X-Received: by 2002:a05:6830:22ce:: with SMTP id q14mr4048935otc.72.1601541046428;
 Thu, 01 Oct 2020 01:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105930.172747117@linuxfoundation.org>
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 1 Oct 2020 14:00:34 +0530
Message-ID: <CA+G9fYuBa4C-zkiywo6W1AqUGpNP1VoUg7+KkJX9Ra_LN3gKHA@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/121] 4.9.238-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 at 16:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.238-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

[my two cents]
There were few tests left from the previous report and found two interesting
things to report here.

I have noticed kernel crashes on arm64 devices Juno-r2 and hikey while running
LTP tracing test cases. But the qemu_arm64 test run is looking good.

I will do git bisect and get back to you.

Crash log on hikey:
--------------------------
Unable to handle kernel paging request at virtual address ffff000009346fd0
Internal error: Oops: 96000047 [#1] PREEMPT SMP
PC is at __buffer_unlock_commit+0x2c/0xf0
LR is at trace_function+0x74/0x88

Crash log on Juno-r2 kasan enable kernel build test:
----------------------------------------------------------------------
Internal error: Oops - SP/PC alignment exception: 8a000000 [#1] PREEMPT SMP
hrtimer: interrupt took 11888340 ns
Unable to handle kernel paging request at virtual address ffff200009c7c3b0
BUG: KASAN: null-ptr-deref on address 0000000000000006

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

arm64 Hikey hi6220 device:
---------------------------------------
ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
ftrace_buffer_size_kb.sh: line 33: echo: write error: Cannot allocate memory
[   64.136324] Unable to handle kernel paging request at virtual
address ffff000009346fd0
[   64.136650] Unable to handle kernel paging request at virtual
address ffff000009346fd0
[   64.136659] pgd = ffff00000958b000
[   64.136681] [ffff000009346fd0] *pgd=0000000077ffe003,
*pud=0000000077ffd003, *pmd=0000000077ffa003, *pte=0000000000000000
[   64.136690] Internal error: Oops: 96000047 [#1] PREEMPT SMP
[   64.136739] Modules linked in: wl18xx wlcore mac80211 cfg80211
rfkill adv7511 kirin_drm dw_drm_dsi drm_kms_helper wlcore_sdio drm
fuse
[   64.136750] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.9.238-rc1 #1
[   64.136755] Hardware name: HiKey Development Board (DT)
[   64.136763] task: ffff800075588000 task.stack: ffff800075590000
[   64.136780] PC is at __buffer_unlock_commit+0x2c/0xf0
[   64.136788] LR is at trace_function+0x74/0x88
[   64.136795] pc : [<ffff000008198bdc>] lr : [<ffff000008199acc>]
pstate: 000003c5
[   64.136801] sp : ffff800075593c10
[   64.136816] x29: ffff800075593c10 x28: 0000000000000001
[   64.136831] x27: ffff0000094a6008 x26: ffff8000748faa00
[   64.136844] x25: 0000000eeec37b9c x24: 0000000000000001
[   64.136858] x23: ffff000009387748 x22: ffff800005f06200
[   64.136872] x21: ffff00000809ec94 x20: ffff80005b4d8010
[   64.136887] x19: ffff000009346f98 x18: 0000000000000000
[   64.136901] x17: 0000000000000000 x16: 0000000000000000
[   64.136914] x15: 0000000000000000 x14: 0000000000000000
[   64.136928] x13: 0000000000000000 x12: 0000000034d5d91d
[   64.136942] x11: 0000000000000000 x10: 0000000000001000
[   64.136955] x9 : 0000000000003ff0 x8 : 0000000000003fff
[   64.136969] x7 : 0000000000000000 x6 : 0000000000000002
[   64.136984] x5 : ffff800075593c10 x4 : 0000000000000001
[   64.136999] x3 : 0000000000000000 x2 : ffff000009346fd0
[   64.137013] x1 : ffff80005b4d8010 x0 : ffff800005f06200
[   64.137019]
[   64.137026] Process swapper/7 (pid: 0, stack limit = 0xffff800075590020)
[   64.137033] Stack: (0xffff800075593c10 to 0xffff800075594000)
[   64.137041] 3c00:
ffff800075593c50 ffff000008199acc
[   64.137049] 3c20: ffff80005b4d8010 ffff000008096158
ffff00000809ec94 ffff000008096158
[   64.137056] 3c40: ffff800075593c50 ffff000008199a90
ffff800075593c80 ffff0000081a0c28
[   64.137065] 3c60: 0000000000000000 ffff00000809ec94
0000000000000800 ffff000008096158
[   64.137073] 3c80: ffff800075593ca0 ffff00000818e0b8
ffff0000093ad1b0 ffff00000818e094
[   64.137081] 3ca0: ffff800075593d20 ffff000008092d48
0000000000000007 ffff000008943b98
[   64.137089] 3cc0: 0000000000000001 00000000000001c0
ffff0000094a6008 ffff000008943924
[   64.137098] 3ce0: 0000000000010000 ffff000008b4baa0
ffff000008b4baa0 00000000000001c0
[   64.137106] 3d00: 0000000000000001 ffff000008943b98
ffff800075593d20 ffff000008943904
[   64.137114] 3d20: ffff800075593d30 ffff00000809ec98
ffff800075593d40 ffff000008096158
[   64.137123] 3d40: ffff800075593d60 ffff0000080962a0
0000000000000000 ffff000008096248
[   64.137131] 3d60: ffff800075593e50 ffff000008092da0
0000000000000001 ffff0000094a6080
[   64.137139] 3d80: ffff0000094a6068 ffff8000748faa00
0000000000000000 0000000000000000
[   64.137147] 3da0: 0000000000000000 0000000000000000
0000000000300000 00000032b5503510
[   64.137154] 3dc0: ffff000008082000 0000000000001000
0000000000000008 0000000034d5d91d
[   64.137162] 3de0: ffff800075593d60 ffff800075593e58
ffff800075593d60 ffff000008096248
[   64.137170] 3e00: 0000000000000001 ffff000008943b98
0000000000000001 00000000000001c0
[   64.137178] 3e20: ffff0000094a6008 0000000000000001
0000000eeec37b9c ffff8000748faa00
[   64.137186] 3e40: ffff0000094a6008 0000000000000001
ffff800075593e70 ffff000008092da0
[   64.137193] 3e60: 0000000000000001 ffff000008096318
ffff800075593e90 ffff000008092da0
[   64.137201] 3e80: 0000000000000001 ffff800075593d80
ffff800075593eb0 ffff000008092da0
[   64.137209] 3ea0: 0000000000000001 ffff0000094a6080
ffff800075593f00 ffff000008092da0
[   64.137218] 3ec0: ffff8000748faa00 ffff0000094a6008
0000000000000001 ffff800075590000
[   64.137226] 3ee0: ffff0000094cde82 ffff000009387634
ffff000009387628 ffff8000748faa00
[   64.137234] 3f00: ffff800075593f30 ffff000008092da0
ffff8000748faa00 ffff0000094a6008
[   64.137242] 3f20: 0000000000000001 ffff000008117404
ffff800075593f60 ffff000008092da0
[   64.137250] 3f40: ffff000009349198 ffff000009387588
0000000000000007 0000000000000bf2
[   64.137258] 3f60: ffff800075593fd0 ffff00000808f7c8
0000000000000007 0000000000000000
[   64.137266] 3f80: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
[   64.137273] 3fa0: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
[   64.137281] 3fc0: ffff800075590000 ffff800075590000
0000000000000000 0000000000b211b8
[   64.137289] 3fe0: 0000000000000000 0000000000000000
0000000000000000 0000000000000000
[   64.137296] Call trace:
[   64.137304] Exception stack(0xffff800075593a40 to 0xffff800075593b70)
[   64.137312] 3a40: ffff000009346f98 0000ffffffffffff
ffff800075593c10 ffff000008198bdc
[   64.137320] 3a60: ffff800075593aa0 ffff0000081a19dc
ffff000000000000 ffff0000081884bc
[   64.137329] 3a80: ffff800075593b00 ffff800075593b00
ffff800075593ac0 ffff00000808c64c
[   64.137338] 3aa0: 0000000eeed7626a 00000000000003c0
ffff0000081a1cfc ffff800075593be0
[   64.137346] 3ac0: ffff800075593b00 ffff0000081a19dc
ffff800000000000 ffff000008187c2c
[   64.137354] 3ae0: ffff800005f06200 ffff80005b4d8010
ffff000009346fd0 0000000000000000
[   64.137362] 3b00: 0000000000000001 ffff800075593c10
0000000000000002 0000000000000000
[   64.137370] 3b20: 0000000000003fff 0000000000003ff0
0000000000001000 0000000000000000
[   64.137378] 3b40: 0000000034d5d91d 0000000000000000
0000000000000000 0000000000000000
[   64.137385] 3b60: 0000000000000000 0000000000000000
[   64.137396] [<ffff000008198bdc>] __buffer_unlock_commit+0x2c/0xf0
[   64.137404] [<ffff000008199acc>] trace_function+0x74/0x88
[   64.137414] [<ffff0000081a0c28>] function_trace_call+0x118/0x158
[   64.137424] [<ffff00000818e0b8>] ftrace_ops_no_ops+0xd8/0x1a0
[   64.137435] [<ffff000008092d48>] ftrace_graph_call+0x0/0x18
[   64.137446] [<ffff00000809ec98>] post_ttbr_update_workaround+0x10/0x28
[   64.137456] [<ffff000008096158>] __cpu_suspend_exit+0xa8/0x148
[   64.137465] [<ffff0000080962a0>] cpu_suspend+0xa8/0xb0
[   64.137476] [<ffff000008944168>] psci_cpu_suspend_enter+0x80/0xb0
[   64.137485] [<ffff000008096338>] arm_cpuidle_suspend+0x38/0x48
[   64.137495] [<ffff00000890ee80>] arm_enter_idle_state+0x40/0x70
[   64.137507] [<ffff00000890cd74>] cpuidle_enter_state+0x84/0x378
[   64.137516] [<ffff00000890d0dc>] cpuidle_enter+0x34/0x48
[   64.137526] [<ffff000008117420>] call_cpuidle+0x40/0x70
[   64.137534] [<ffff000008117724>] cpu_startup_entry+0x154/0x208
[   64.137543] [<ffff00000808f7c8>] secondary_start_kernel+0x170/0x1c0
[   64.137551] [<0000000000b211b8>] 0xb211b8
[   64.137561] Code: 9100e262 910003e5 aa0103f4 d538d083 (38236844)
[   64.137573] ---[ end trace b6d20fb3932a280d ]---
[   64.137582] Kernel panic - not syncing: Attempted to kill the idle task!
[   64.137589] SMP: stopping secondary CPUs
[   64.944008] Unable to handle kernel paging request at virtual
address ffff0000093443b0
[   64.957696] Unable to handle kernel paging request at virtual
address ffff0000093443b0
[   64.970929] SMP: faO fse.: d9sa]bKereldOff etUsdi,7bled
[   64.970939] Memory Limit: none
[   64.979315] Unable to handle kernel paging r[ u st4.t 19rt] l adde
ss hfnd00 k09ne43pa
ng request at virtual address ffff0000093443b0
[   64.991406] Unable to handle kernel paging request at virtual
address ffff00000934 3b04


arm64 Juno-r2 kasan kernel crash:
------------------------------------------------
[  157.715867] Internal error: Oops - SP/PC alignment exception:
8a000000 [#1] PREEMPT SMP
[  160.230790] Unable to handle kernel paging request at virtual
address ffff200009c7c3b0
[  160.237121] hrtimer: interrupt took 11888340 ns
[  160.243256] Unable to handle kernel paging request at virtual
address ffff200009c7c3b0
[  160.251189] Unable to handle kernel paging request at virtual
address ffff200009c7c3b0
<>
[  161.528456] Unable to handle kernel paging request at virtual
address ffff200009c7c3b0
[  161.536004] ==================================================================
[  161.536032] BUG: KASAN: null-ptr-deref on address 0000000000000006
[  161.536058] Read of size 8 by task swapper/0/0
[  161.536094] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.9.238-rc1 #1
[  161.536119] Hardware name: ARM Juno development board (r2) (DT)
[  161.536146] Call trace:
[  161.536192] [<ffff20000808d960>] dump_backtrace+0x0/0x2e8
[  161.536232] [<ffff20000808dc6c>] show_stack+0x24/0x30
[  161.536271] [<ffff200008650a0c>] dump_stack+0xcc/0x108
[  161.536311] [<ffff2000082fdbcc>] kasan_report.part.0+0x264/0x4a8
[  161.536347] [<ffff2000082fe31c>] kasan_report+0x5c/0x70
[  161.536382] [<ffff2000082fc6dc>] __asan_load8+0x44/0x98
[  161.536425] [<ffff20000812ff10>] resched_curr+0x38/0xa0
[  161.536465] [<ffff200008130ffc>] check_preempt_curr+0x124/0x138
[  161.536505] [<ffff200008131044>] ttwu_do_wakeup+0x34/0x1e8
[  161.536545] [<ffff200008131288>] ttwu_do_activate+0x90/0xd8
[  161.536581] [<ffff200008133fd8>] try_to_wake_up+0x2e0/0x560
[  161.536616] [<ffff20000813438c>] default_wake_function+0x3c/0x50
[  161.536656] [<ffff2000083460a8>] pollwake+0xf0/0x120
[  161.536693] [<ffff200008156a74>] __wake_up_common+0x94/0xe0
[  161.536730] [<ffff200008157034>] __wake_up_sync_key+0x54/0x70
[  161.536768] [<ffff200008e07054>] sock_def_readable+0x64/0xc8
[  161.536804] [<ffff200008e06460>] __sock_queue_rcv_skb+0x228/0x3c8
[  161.536844] [<ffff200008ed2408>] __udp_queue_rcv_skb+0x90/0x388
[  161.536883] [<ffff200008ed5dfc>] udp_queue_rcv_skb+0x534/0x8a0
[  161.536922] [<ffff200008ed61ec>] udp_unicast_rcv_skb.isra.0+0x84/0x128
[  161.536959] [<ffff200008ed66b4>] __udp4_lib_rcv+0x424/0xfe0
[  161.536995] [<ffff200008ed77c8>] udp_rcv+0x30/0x40
[  161.537036] [<ffff200008e85168>] ip_local_deliver_finish+0x158/0x370
[  161.537074] [<ffff200008e85b78>] ip_local_deliver+0xc8/0x188
[  161.537111] [<ffff200008e85540>] ip_rcv_finish+0x1c0/0x530
[  161.537147] [<ffff200008e85fb0>] ip_rcv+0x378/0x5d8
[  161.537188] [<ffff200008e2bd7c>] __netif_receive_skb_core+0xa9c/0xdf8
[  161.537228] [<ffff200008e2f890>] __netif_receive_skb+0x28/0xf0
[  161.537268] [<ffff200008e2f9d4>] netif_receive_skb_internal+0x7c/0x150
[  161.537307] [<ffff200008e2fac8>] netif_receive_skb+0x20/0x148
[  161.537347] [<ffff200008b4e460>] smsc911x_poll+0x160/0x360
[  161.537386] [<ffff200008e32c6c>] net_rx_action+0x1fc/0x5f0
[  161.537423] [<ffff200008081f08>] __do_softirq+0x238/0x61c
[  161.537462] [<ffff2000080f61c8>] irq_exit+0x120/0x160
[  161.537500] [<ffff20000816b0ec>] __handle_domain_irq+0x8c/0xf0
[  161.537536] [<ffff200008081aec>] gic_handle_irq+0x54/0xa8
[  161.537570] Exception stack(0xffff200009cc3c20 to 0xffff200009cc3d50)
[  161.537607] 3c20: dfff200000000000 ffff200009cc0018
1fffe40001398003 0000000000000000
[  161.537643] 3c40: ffff0400013987b8 dfff200000000000
00000000f1f1f1f1 1fffe40001398792
[  161.537678] 3c60: ffff040001398784 0000000000000000
0000000000001000 0000000000000000
[  161.537711] 3c80: 0000000034d5d91d 0000000000000000
0000000000000000 0000000000000000
[  161.537744] 3ca0: 0000000000000000 0000000000000000
0000000000000000 0000000000000001
[  161.537780] 3cc0: 1fffe400013987b8 ffff200009cc0000
0000000000000800 ffff2000081a35f4
[  161.537817] 3ce0: ffff200008ff1ff4 ffff200009cc0018
ffff200009cd3c80 ffff200009cc0000
[  161.537853] 3d00: ffff200009cc0000 ffff200009cc3d50
ffff2000082012f4 ffff200009cc3d50
[  161.537890] 3d20: ffff2000082fc628 0000000020000145
ffff200008221630 ffff200008201388
[  161.537919] 3d40: ffffffffffffffff 1fffe400013987b8
[  161.537951] [<ffff2000080838b0>] el1_irq+0xb0/0x128
[  161.537986] [<ffff2000082fc628>] __asan_store4+0x28/0x98
[  161.538024] [<ffff2000082012f4>] ftrace_ops_no_ops+0xf4/0x308
[  161.538063] [<ffff200008098c88>] ftrace_graph_call+0x0/0x18
[  161.538106] [<ffff2000081a35f8>] tick_check_broadcast_expired+0x18/0x70
[  161.538145] [<ffff200008ff1ff4>] cpu_idle_poll+0x74/0x308
[  161.538183] [<ffff200008158474>] cpu_startup_entry+0xec/0x250
[  161.538223] [<ffff200008fe98e8>] rest_init+0xa4/0xb4
[  161.538267] [<ffff200009b00df8>] start_kernel+0x418/0x440
[  161.538306] [<ffff200009b001e0>] __primary_switched+0x64/0x68
[  161.538328] ==================================================================
[  161.538377] Unable to handle kernel NULL pointer dereference at
virtual address 00000006
[  161.538402] pgd = ffff8008f2bd5000
[  161.538448] [0000000000000006] *pgd=0000000000000000


full test log links
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.237-122-g054f04eb3d5d/testrun/3251156/suite/linux-log-parser/test/check-kernel-oops-1803893/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.237-122-g054f04eb3d5d/testrun/3257654/suite/linux-log-parser/test/check-kernel-bug-1804111/log

- Naresh
