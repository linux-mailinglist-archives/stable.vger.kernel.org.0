Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E473D7B53
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 18:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhG0Qqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 12:46:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:54318 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhG0Qqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 12:46:44 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 12:46:44 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7FAB8229712
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 16:40:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.64.75])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5767F2006D;
        Tue, 27 Jul 2021 16:40:56 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 212698006E;
        Tue, 27 Jul 2021 16:40:56 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 767DA13C2B1;
        Tue, 27 Jul 2021 09:40:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 767DA13C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1627404020;
        bh=Oudn1qhMd6rE8cpEVp+7d+PhgE2LmDl9n/YXvVd70kQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FP3WMybFYWBLLxiM+o+O3nCG7PDiUTn5ab1RkzeLS1nhAOFE5CAwpbu6pOts7UjQK
         tFfQ4WarMXYGZkWWiHGrlAKR0sXDONIGwdZ9OrKcYlobptt/f9KyJ2klCfHxlzXGzu
         0mc90Om7Mtr4s3+e2nCK+IJTAGQi9lgf50Fx5ZhE=
Subject: Re: very long boot times in 5.13 stable.
To:     pgndev <pgnet.dev@gmail.com>
Cc:     stable@vger.kernel.org
References: <aeac0ff3-6606-3752-db6c-306a9c643f8f@candelatech.com>
 <CAHv26DhDYNYGmQa7Dt4NoAz74J89pi8+4yuEprFO0bjuN9G7gg@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <f8be86d0-28ac-3e5b-1969-9115e5e0472c@candelatech.com>
Date:   Tue, 27 Jul 2021 09:40:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHv26DhDYNYGmQa7Dt4NoAz74J89pi8+4yuEprFO0bjuN9G7gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1627404056-hPUKiKnA_XUb
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/21 9:32 AM, pgndev wrote:
> hm.  irq4 & slow boot ...
> 
> Is that a BayTrail CPU by any chance?
> 
> What mobo?

This is an axiomtek industrial/embedded system, not sure if it has a motherboard model
anyone would recognize.  Problem showed in 5.13.2+, I'm building something in
the 5.13.1 range now....  The CPU info is below:

[root@ct523c-0b29 ~]# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 158
model name	: Intel(R) Core(TM) i7-7700T CPU @ 2.90GHz
stepping	: 9
microcode	: 0xca
cpu MHz		: 2900.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 22
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm 
constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl smx est tm2 ssse3 sdbg fma cx16 
xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_single ssbd ibrs 
ibpb stibp fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat 
pln pts hwp hwp_notify hwp_act_window hwp_epp md_clear flush_l1d
bugs		: cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs taa itlb_multihit srbds
bogomips	: 5799.77
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:
....

Thanks,
Ben


> 
> On Tue, Jul 27, 2021, 12:17 PM Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>> wrote:
> 
>     Hello,
> 
>     My system was stable with 5.13.0, though there was a KASAN warning.
>     So, I upgrade to 5.13.5, and now it takes a very long time to fully boot to
>     login prompt, and I see this splat in the logs.
> 
>     I'm working on bisecting, but if someone has a clue, please let me know.
> 
>     [ 2187.021338] irq 4: nobody cared (try booting with the "irqpoll" option)
>     [ 2187.026825] CPU: 7 PID: 48 Comm: ksoftirqd/7 Not tainted 5.13.5+ #26
>     [ 2187.026830] Hardware name: Default string Default string/SKYBAY, BIOS 5.12 02/19/2019
>     [ 2187.026832] Call Trace:
>     [ 2187.026834]  <IRQ>
>     [ 2187.026836]  dump_stack+0x9b/0xce
>     [ 2187.026844]  __report_bad_irq+0x3d/0xd7
>     [ 2187.026848]  note_interrupt.cold.9+0xa/0x8b
>     [ 2187.026851]  ? add_interrupt_randomness+0x15a/0x2a0
>     [ 2187.026857]  handle_irq_event_percpu+0xd6/0xe0
>     [ 2187.026862]  ? __handle_irq_event_percpu+0x250/0x250
>     [ 2187.026865]  ? _raw_spin_lock+0x7c/0xd0
>     [ 2187.026872]  ? _raw_read_lock+0x30/0x30
>     [ 2187.026876]  handle_irq_event+0x4f/0x80
>     [ 2187.026879]  handle_fasteoi_irq+0xf7/0x210
>     [ 2187.026885]  __common_interrupt+0x3e/0xb0
>     [ 2187.026890]  common_interrupt+0x77/0xa0
>     [ 2187.026893]  </IRQ>
>     [ 2187.026895]  asm_common_interrupt+0x1e/0x40
>     [ 2187.026898] RIP: 0010:unwind_next_frame+0x727/0xa70
>     [ 2187.026902] Code: 80 3d 49 6d 88 02 00 0f 85 b6 fc ff ff e9 7a 1e 1b 01 48 8b 44 24 60 4c 89 ea 48 89 df 4c 8d 7b 34 48 8d 70 f8 48 89 44 24 28 <e8> 94
>     f8 ff
>     ff 84 c0 0f 84 8c fc ff ff 4c 8b 6c 24 60 48 8b 3c 24
>     [ 2187.026906] RSP: 0018:ffff888108d5f680 EFLAGS: 00000246
>     [ 2187.026909] RAX: ffff888108d5fba0 RBX: ffff888108d5f798 RCX: ffffffff810ba1f9
>     [ 2187.026912] RDX: ffff888108d5f7e0 RSI: ffff888108d5fb98 RDI: ffff888108d5f798
>     [ 2187.026915] RBP: 1ffff110211abed8 R08: fffffbfff07eb294 R09: fffffbfff07eb294
>     [ 2187.026917] R10: ffffffff83f5949d R11: fffffbfff07eb293 R12: 0000000000000001
>     [ 2187.026919] R13: ffff888108d5f7e0 R14: ffffffff83f5949c R15: ffff888108d5f7cc
>     [ 2187.026922]  ? unwind_next_frame+0x529/0xa70
>     [ 2187.026926]  ? packet_rcv+0x73/0x8e0
>     [ 2187.026931]  ? packet_rcv+0x72/0x8e0
>     [ 2187.026934]  ? deref_stack_reg+0x40/0x40
>     [ 2187.026937]  ? unwind_next_frame+0x334/0xa70
>     [ 2187.026940]  ? ret_from_fork+0x1f/0x30
>     [ 2187.026945]  ? get_stack_info_noinstr+0x12/0xe0
>     [ 2187.026948]  ? packet_rcv+0x73/0x8e0
>     [ 2187.026951]  ? create_prof_cpu_mask+0x20/0x20
>     [ 2187.026955]  arch_stack_walk+0x80/0xe0
>     [ 2187.026959]  ? packet_rcv+0x73/0x8e0
>     [ 2187.026963]  ? packet_rcv+0x73/0x8e0
>     [ 2187.026966]  stack_trace_save+0x85/0xb0
>     [ 2187.026969]  ? stack_trace_consume_entry+0x80/0x80
>     [ 2187.026973]  kasan_save_stack+0x19/0x40
>     [ 2187.026977]  ? kasan_save_stack+0x19/0x40
>     [ 2187.026981]  ? kasan_set_track+0x1c/0x30
>     [ 2187.026984]  ? kasan_set_free_info+0x20/0x30
>     [ 2187.026988]  ? __kasan_slab_free+0xec/0x130
>     [ 2187.026991]  ? kmem_cache_free+0x78/0x290
>     [ 2187.026994]  ? packet_rcv+0x73/0x8e0
>     [ 2187.026998]  ? kasan_save_stack+0x2f/0x40
>     [ 2187.027001]  ? kasan_save_stack+0x19/0x40
>     [ 2187.027004]  ? __kasan_slab_alloc+0x68/0x80
>     [ 2187.027007]  ? kmem_cache_alloc+0xc5/0x1f0
>     [ 2187.027010]  ? skb_clone+0x80/0x160
>     [ 2187.027015]  ? dev_queue_xmit_nit+0x19d/0x410
>     [ 2187.027020]  ? dev_hard_start_xmit+0x7f/0x330
>     [ 2187.027024]  ? sch_direct_xmit+0x116/0x580
>     [ 2187.027030]  ? __qdisc_run+0x23b/0x920
>     [ 2187.027033]  ? net_tx_action+0x1a3/0x420
>     [ 2187.027036]  ? __do_softirq+0xf0/0x3b8
>     [ 2187.027040]  ? run_ksoftirqd+0x21/0x30
>     [ 2187.027046]  ? smpboot_thread_fn+0x1b6/0x340
>     [ 2187.027051]  ? kthread+0x1d4/0x210
>     [ 2187.027055]  ? ret_from_fork+0x1f/0x30
>     [ 2187.027059]  ? _raw_spin_unlock+0x9/0x20
>     [ 2187.027063]  ? get_partial_node.isra.86.part.87+0xe0/0x280
>     [ 2187.027067]  ? common_interrupt+0x1b/0xa0
>     [ 2187.027070]  ? common_interrupt+0x1b/0xa0
>     [ 2187.027072]  ? dma_map_page_attrs+0x16f/0x350
>     [ 2187.027077]  ? common_interrupt+0x1b/0xa0
>     [ 2187.027080]  ? asm_common_interrupt+0x1e/0x40
>     [ 2187.027083]  ? bpf_skb_load_helper_16+0x6e/0xf0
>     [ 2187.027087]  ? bpf_skb_load_helper_8_no_cache+0x120/0x120
>     [ 2187.027090]  kasan_set_track+0x1c/0x30
>     [ 2187.027094]  kasan_set_free_info+0x20/0x30
>     [ 2187.027097]  __kasan_slab_free+0xec/0x130
>     [ 2187.027101]  ? packet_rcv+0x73/0x8e0
>     [ 2187.027104]  kmem_cache_free+0x78/0x290
>     [ 2187.027108]  packet_rcv+0x73/0x8e0
>     [ 2187.027111]  ? __skb_clone+0x271/0x2b0
>     [ 2187.027115]  ? packet_create+0x3d0/0x3d0
>     [ 2187.027118]  dev_queue_xmit_nit+0x401/0x410
>     [ 2187.027122]  dev_hard_start_xmit+0x7f/0x330
>     [ 2187.027126]  sch_direct_xmit+0x116/0x580
>     [ 2187.027130]  ? dev_reset_queue.constprop.44+0xa0/0xa0
>     [ 2187.027135]  ? fq_codel_dump_stats+0x310/0x310 [sch_fq_codel]
>     [ 2187.027141]  ? _raw_spin_unlock_irq+0x13/0x30
>     [ 2187.027144]  __qdisc_run+0x23b/0x920
>     [ 2187.027148]  net_tx_action+0x1a3/0x420
>     [ 2187.027152]  __do_softirq+0xf0/0x3b8
>     [ 2187.027156]  ? takeover_tasklets+0x2e0/0x2e0
>     [ 2187.027160]  run_ksoftirqd+0x21/0x30
>     [ 2187.027163]  smpboot_thread_fn+0x1b6/0x340
>     [ 2187.027167]  ? smpboot_register_percpu_thread+0x180/0x180
>     [ 2187.027171]  ? schedule+0xaa/0x140
>     [ 2187.027174]  ? __kthread_parkme+0x94/0xb0
>     [ 2187.027178]  ? smpboot_register_percpu_thread+0x180/0x180
>     [ 2187.027181]  kthread+0x1d4/0x210
>     [ 2187.027185]  ? set_kthread_struct+0x70/0x70
>     [ 2187.027188]  ret_from_fork+0x1f/0x30
>     [ 2187.027193] handlers:
>     [ 2187.028203] [<00000000ef8c02a2>] serial8250_interrupt
>     [ 2187.032072] Disabling IRQ #4
> 
>     Thanks,
>     Ben
> 
>     -- 
>     Ben Greear <greearb@candelatech.com <mailto:greearb@candelatech.com>>
>     Candela Technologies Inc http://www.candelatech.com
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

