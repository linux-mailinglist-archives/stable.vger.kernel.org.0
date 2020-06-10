Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5384F1F4E90
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 09:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726153AbgFJHJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 03:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFJHJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 03:09:10 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1C5C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 00:09:10 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 202so822601lfe.5
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 00:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wOuibnMF24QyZa6EMc8F6Zs8geF3FqVtbkLtc4c2WI=;
        b=xRPkLGf15DaCD4C6SI45XreaTNtQ6+f6iJw7sgZX0Viu8iG1rMlIrlVXaVvA1nMkKl
         +dNOncjNPlSiPlUFILNklqXdDrRZPmZ6hRXZbySZgQbyKinCxFki4Nv5t7mH3XC5SRWS
         83qWCOCHvxd5BIH/aw0JApkam/U1s4t5LXAlYD7TTQa9PlEwr009540mEEB+VnJGadfN
         8rmo7Bl5L0KYzH5ifoRn1DADXYpIcgjmE9Iex+OQa5x/Yxp18hsbDjVZLv2lBR1LWm3V
         Aarxy4MWvGzneq1xWWOVfxXugajo1EF6uBSby7hkyEOCIb3s/8BBIfl3L6KZjzUSHBoE
         jgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wOuibnMF24QyZa6EMc8F6Zs8geF3FqVtbkLtc4c2WI=;
        b=bvX925g359rb6obNZMpmgn3CC6P398LiajDVd/D44R1F23E8QFT2GqSF3r+Ve162+/
         ye2uvuMd1BSNWtK0pS4oa1FovW5mxZ4ksqPIEB2cTnqvvrtzIDuRtuh6wGe7BjCTGSCl
         WbfeyzOxX7nGJiwByHtF90NVStLiEz7hUtvOv/Yg/zuy0ssxvtAgjMYQQG+ScstFC25k
         X+2cvQyzvkM7z6fea/KWFyx6lxfM8Apm0psozQEXSmYaV2W+hJJ9+pr2Cv/mAhouJ8CU
         4hx/f+5HDoP2479GxJYz+TPZ/SwrjnExULXT6HQbAmeEqcA51q7YIAWxiZkTURbo+W45
         4spg==
X-Gm-Message-State: AOAM533RhWSnZzWhCeTrD52dtczBqvRl7Fz6Rz+ovYTZmnBaxEVPX8/b
        B4w/5Gay839H6YecDK5UxnZ7r1uWMVMqv+dGxUKOnQ==
X-Google-Smtp-Source: ABdhPJwG07hC0ChWjiSgvO7BBTq6+TQS9+YyU8i/XPRL3G4hgkMFkAiJQx7Ks/V0q2W5QXkEIyGtnIuCWwWPDQaui2w=
X-Received: by 2002:a05:6512:533:: with SMTP id o19mr920694lfc.6.1591772948413;
 Wed, 10 Jun 2020 00:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvvDjA5t+zi0Zyn2F6D=7aE-Gu-m13o47LXYYfCD3SvrA@mail.gmail.com>
 <20200514064039.GY29153@dhcp22.suse.cz> <f3a2db67-f7b7-1bb7-340f-24806a999192@oracle.com>
In-Reply-To: <f3a2db67-f7b7-1bb7-340f-24806a999192@oracle.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Jun 2020 12:38:56 +0530
Message-ID: <CA+G9fYvyLj1Mp=+4R+ah250fCmhboWhVd=Phg8PsYGJ98LWR3Q@mail.gmail.com>
Subject: Re: stable-rc 5.4: libhugetlbfs fallocate_stress.sh: Unable to handle
 kernel paging request at virtual address ffff00006772f000
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkft-triage@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 May 2020 at 22:01, Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 5/13/20 11:40 PM, Michal Hocko wrote:
> > On Wed 13-05-20 23:11:40, Naresh Kamboju wrote:
> >> While running libhugetlbfs fallocate_stress.sh on stable-rc 5.4 branch kernel
> >> on arm64 hikey device. The following kernel Internal error: Oops:
> >> crash dump noticed.
> >
> > Is the same problem reproducible on vanilla 5.4 without any stable
> > patches?
> >
>
> Or, an earlier version of 5.4-stable?  Nothing in the changelog for 5.4.41
> looks related to this issue.  There was an arm specific hugetlb change
> "arm64: hugetlb: avoid potential NULL dereference", but that is pretty
> straight forward.
>
> I'm guessing this may not reproduce easily.  To help reproduce, you could
> change the
> #define FALLOCATE_ITERATIONS 100000
> in .../libhugetlbfs/tests/fallocate_stress.c to a larger number to force
> the stress test to run longer.

Sorry i did not get a chance to run as per your suggestion.
But this issue is reproducible on stable-rc 5.4.46-rc1 on arm64 hikey device

./runltp -p -q -f hugetlb
<>
ksm05.c:78: PASS: still alive.
ksm05.c:78: PASS: still alive.
ksm05.c:78: PASS: still alive.
ksm05.c:78: PASS: still alive.
[  383.751513] oom01 invoked oom-killer:
gfp_mask=0x100cca(GFP_HIGHUSER_MOVABLE), order=0, oom_score_adj=0
[  384.715831]   EC = 0x25: DABT (current EL), IL = 32 bits
[  384.725478] CPU: 0 PID: 10948 Comm: oom01 Not tainted
5.4.46-rc1-00035-g12a5ce113626 #1
[  384.730887]   SET = 0, FnV = 0
[  384.739060] Hardware name: HiKey Development Board (DT)
[  384.739066] Call trace:
[  384.739081]  dump_backtrace+0x0/0x140
[  384.739090]  show_stack+0x14/0x20
[  384.742209]   EA = 0, S1PTW = 0
[  384.746701] dwmmc_k3 f723d000.dwmmc0: Unexpected interrupt latency
[  384.747550]  dump_stack+0xb4/0xf8
[  384.747559]  dump_header+0x44/0x1ec
[  384.747565]  oom_kill_process+0x1d4/0x1d8
[  384.747572]  out_of_memory+0x170/0x4e0
[  384.750070] Data abort info:
[  384.753813]  __alloc_pages_slowpath+0x954/0x9f8
[  384.753819]  __alloc_pages_nodemask+0x21c/0x280
[  384.753826]  alloc_pages_vma+0x88/0x210
[  384.753836]  __handle_mm_fault+0x638/0x1080
[  384.757236]   ISV = 0, ISS = 0x00000047
[  384.760428]  handle_mm_fault+0xdc/0x1a8
[  384.760436]  do_page_fault+0x130/0x460
[  384.760442]  do_translation_fault+0x5c/0x78
[  384.760450]  do_mem_abort+0x3c/0x98
[  384.766776]   CM = 0, WnR = 1
[  384.770154]  el0_da+0x1c/0x20
[  384.773735] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000013c5000
[  384.777949] Mem-Info:
[  384.781679] [ffff0000641ff000] pgd=0000000077ff7003,
pud=0000000077e0d003, pmd=0000000077cec003, pte=0000000000000000
[  384.781694] Internal error: Oops: 96000047 [#1] PREEMPT SMP
[  384.781698] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart snd_soc_audio_graph_card btbcm snd_soc_simple_card_utils
crct10dif_ce wlcore_sdio adv7511 bluetooth kirin_drm cec dw_drm_dsi
rfkill drm_kms_helper drm fuse
[  384.784854] active_anon:472313 inactive_anon:2168 isolated_anon:0
[  384.784854]  active_file:63 inactive_file:0 isolated_file:0
[  384.784854]  unevictable:0 dirty:0 writeback:0 unstable:0
[  384.784854]  slab_reclaimable:2625 slab_unreclaimable:7426
[  384.784854]  mapped:202 shmem:2175 pagetables:1188 bounce:0
[  384.784854]  free:5469 free_pcp:1684 free_cma:14
[  384.789304] CPU: 5 PID: 10945 Comm: oom01 Not tainted
5.4.46-rc1-00035-g12a5ce113626 #1
[  384.789309] Hardware name: HiKey Development Board (DT)
[  384.789315] pstate: 80000005 (Nzcv daif -PAN -UAO)
[  384.789328] pc : clear_page+0x10/0x24
[  384.789339] lr : __cpu_clear_user_page+0xc/0x18
[  384.794000] Node 0 active_anon:1889252kB inactive_anon:8672kB
active_file:412kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB mapped:800kB dirty:0kB writeback:0kB shmem:8700kB
shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 1478656kB
writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[  384.797884] sp : ffff8000190ebc10
[  384.797888] x29: ffff8000190ebc10 x28: ffff000066cf2a00
[  384.797895] x27: 0000000000000002 x26: fffffe00019f2400
[  384.797901] x25: ffff00006e51df00 x24: 0000000000001000
[  384.802205] Node 0 DMA32 free:21876kB min:22528kB low:28160kB
high:33792kB active_anon:1889252kB inactive_anon:8672kB
active_file:0kB inactive_file:484kB unevictable:0kB writepending:0kB
present:2061364kB managed:1995396kB mlocked:0kB kernel_stack:2800kB
pagetables:4752kB bounce:0kB free_pcp:6864kB local_pcp:1320kB
free_cma:56kB
[  384.806099] x23: 0000000000000000 x22: fffffe0001700000
[  384.806106] x21: 0000000000000000 x20: 0000fffef3800000
[  384.806112] x19: ffff000066cf2a00 x18: 0000000000000000
[  384.806117] x17: 0000000000000000 x16: 0000000000000000
[  384.810066] lowmem_reserve[]: 0 0 0
[  384.813873] x15: 0000000000000000 x14: 0000000000000000
[  384.813879] x13: 0000000000000000 x12: 0000000000000000
[  384.813885] x11: 0000000000000000 x10: 0000000000000000
[  384.813891] x9 : ffff800066671000 x8 : 0000000000000200
[  384.818192] Node 0 DMA32: 899*4kB (UME) 471*8kB (UMEC) 205*16kB
(UEC) 153*32kB (UMEC) 61*64kB (UME) 15*128kB (UE) 2*256kB (ME) 0*512kB
0*1024kB 0*2048kB 0*4096kB = 21876kB
[  384.821730] x7 : ffff800066671000 x6 : 0000000000000000
[  384.821737] x5 : 0000000000000000 x4 : 0000020000200000
[  384.821743] x3 : 0000000000007fc0 x2 : 0000000000000004
[  384.821748] x1 : 0000000000000040 x0 : ffff0000641ff000
[  384.821754] Call trace:
[  384.821762]  clear_page+0x10/0x24
[  384.821771]  clear_subpage+0x54/0x90
[  384.821780]  clear_huge_page+0x6c/0x208
[  384.824842] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=1048576kB
[  384.827843]  do_huge_pmd_anonymous_page+0x1a4/0x7a0
[  384.827851]  __handle_mm_fault+0x83c/0x1080
[  384.827857]  handle_mm_fault+0xdc/0x1a8
[  384.827863]  do_page_fault+0x130/0x460
[  384.827872]  do_translation_fault+0x5c/0x78
[  384.834786] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=32768kB
[  384.837038]  do_mem_abort+0x3c/0x98
[  384.837044]  el0_da+0x1c/0x20
[  384.837056] Code: d53b00e1 12000c21 d2800082 9ac12041 (d50b7420)
[  384.847921] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[  384.853582] ---[ end trace 298eea3ec03b10c2 ]---
[  384.853619] note: oom01[10945] exited with preempt_count 1
[  384.874237] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=64kB
[  385.070710] dwmmc_k3 f723d000.dwmmc0: Unexpected interrupt latency
[  385.551002] 2384 total pagecache pages
[  385.563572] 0 pages in swap cache
[  385.575536] Swap cache stats: add 0, delete 0, find 0/0
[  385.589403] Free swap  = 0kB
[  385.600885] Total swap = 0kB
[  385.612403] 515341 pages RAM
[  385.623860] 0 pages HighMem/MovableOnly
[  385.636339] 16492 pages reserved
[  385.648140] 32768 pages cma reserved
[  385.660271] 0 pages hwpoisoned
[  385.671865] Tasks state (memory values in pages):
[  385.685192] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes
swapents oom_score_adj name
[  385.702711] [    377]     0   377     3387      315    61440
0             0 systemd-journal
[  385.720672] [    413]     0   413     3520      310    49152
0         -1000 systemd-udevd
[  385.738467] [    435]   993   435     1526       79    53248
0             0 systemd-network
[  385.756400] [    459]   992   459     1665       99    49152
0             0 systemd-resolve
[  385.774283] [    463]     0   463      553       21    40960
0             0 tee-supplicant
[  385.792002] [    464]     0   464     1479      111    45056
0             0 systemd-logind
[  385.809585] [    472]   995   472     1197      105    45056
0             0 avahi-daemon
[  385.826656] [    473]   995   473     1166       66    45056
0             0 avahi-daemon
[  385.843371] [    474]     0   474      771       19    40960
0             0 syslogd
[  385.859600] [    475]     0   475      771       18    45056
0             0 klogd
[  385.875602] [    476]     0   476     1382       62    49152
0             0 bluetoothd
[  385.892028] [    479]   996   479     1151      187    45056
0          -900 dbus-daemon
[  385.908563] [    481]     0   481    78394      563   106496
0             0 NetworkManager
[  385.925332] [    482]     0   482      698      133    40960
0             0 crond
[  385.941236] [    527] 65534   527      629       44    40960
0             0 dnsmasq
[  385.957226] [    529]     0   529      578       32    40960
0             0 agetty
[  385.973067] [    530]     0   530     1173      107    49152
0             0 login
[  385.988832] [    531]     0   531      578       32    40960
0             0 agetty
[  386.004670] [    536]     0   536     2385      148    49152
0             0 wpa_supplicant
[  386.020865] [    537]   998   537   115916     1319   131072
0             0 polkitd
[  386.036060] [    563]     0   563    24661      430    69632
0             0 dhclient
[  386.051325] [    602]     0   602     1899      214    57344
0             0 systemd
[  386.066521] [    603]     0   603     2569      477    61440
0             0 (sd-pam)
[  386.081811] [    607]     0   607      910      102    40960
0             0 sh
[  386.096558] [    611]     0   611     1039       81    45056
0             0 su
[  386.110911] [    612]     0   612      910       97    40960
0             0 sh
[  386.124866] [    615]     0   615      756       55    40960
0             0 lava-test-runne
[  386.139888] [   1327]     0  1327      756       50    40960
0             0 lava-test-shell
[  386.154903] [   1328]     0  1328      756       52    36864
0             0 sh
[  386.168797] [   1330]     0  1330      822      133    40960
0             0 ltp.sh
[  386.183055] [   1348]     0  1348      822      133    40960
0             0 ltp.sh
[  386.197278] [   1349]     0  1349      822      133    40960
0             0 ltp.sh
[  386.211413] [   1350]     0  1350      822      133    40960
0             0 ltp.sh
[  386.225573] [   1351]     0  1351      921      230    45056
0             0 runltp
[  386.239776] [   1352]     0  1352      452       15    40960
0             0 tee
[  386.253702] [   1426]     0  1426      451       28    40960
0             0 ltp-pan
[  386.267740] [  10933]     0 10933      494       18    32768
0             0 oom01
[  386.281352] [  10934]     0 10934      527       31    36864
0             0 oom01
[  386.294984] [  10944]     0 10944  5519894   467709  3833856
0             0 oom01
[  386.308646] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=oom01,pid=10944,uid=0
[  386.326954] Out of memory: Killed process 10944 (oom01)
total-vm:22079576kB, anon-rss:1870836kB, file-rss:0kB, shmem-rss:0kB,
UID:0 pgtables:3744kB oom_score_adj:0
ksm05.c:78: PASS: still alive.
ksm05.c:78: PASS: still alive.



> --
> Mike Kravetz
