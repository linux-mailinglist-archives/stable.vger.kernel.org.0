Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1651357D0
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 12:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgAILW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 06:22:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:42638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbgAILW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 06:22:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1545D6A4C0;
        Thu,  9 Jan 2020 11:22:48 +0000 (UTC)
Date:   Thu, 9 Jan 2020 12:22:45 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: [LTP]  =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel 5.4.9-rc1-3abd3b2.cki (stable)
Message-ID: <20200109112245.GA3723@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <cki.7B6FDEE6C3.9EE0H2AAP8@redhat.com>
 <20200109083752.GA17247@dell5510>
 <1271182490.1176308.1578567258902.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271182490.1176308.1578567258902.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

> No tests failed, but there was a soft lockup:
>   https://artifacts.cki-project.org/pipelines/371074/logs/ppc64le_host_1_LTP_dmesg.log

I'm blind, thanks!
I guess this can be caused by slow VM due overloaded host (not a real bug).

Kind regards,
Petr

> [ 7394.536000] LTP: starting dio30 (diotest6 -b 65536 -n 100 -i 100 -o 1024000)
> [ 7829.754543] watchdog: BUG: soft lockup - CPU#5 stuck for 24s! [systemd-journal:510]
> [ 7861.138569] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [ 7871.111478] Modules linked in: dummy minix binfmt_misc nfsv3 nfs_acl nfs lockd grace fscache
> [ 7871.112283] rcu: 	5-...0: (912 ticks this GP) idle=0f6/1/0x4000000000000002 softirq=333774/333774 fqs=2924 
> [ 7871.112284]  sctp rds brd vfat fat btrfs xor zstd_compress raid6_pq zstd_decompress loop tun ip6table_nat ip6_tables xt_conntrack iptable_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth bridge stp llc overlay fuse rfkill sunrpc vmx_crypto virtio_net net_failover failover virtio_balloon crct10dif_vpmsum ip_tables xfs libcrc32c crc32c_vpmsum virtio_console virtio_blk [last unloaded: can]
> [ 7871.139880] 	(detected by 4, t=7002 jiffies, g=449229, q=525)
> [ 7871.140056] CPU: 5 PID: 510 Comm: systemd-journal Not tainted 5.4.9-rc1-3abd3b2.cki #1
> [ 7882.038415] Sending NMI from CPU 4 to CPUs 5:
> [ 7882.038608] NIP:  c00000000000b01c LR: c00000000001bbd4 CTR: c000000000828840
> [ 7882.039018] REGS: c0000003eeddb7c0 TRAP: 0901   Not tainted  (5.4.9-rc1-3abd3b2.cki)
> [ 7882.039155] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 4800444f  XER: 00000000
> [ 7882.039354] CFAR: c0000000000e9564 IRQMASK: 0 
>                GPR00: c000000000d78070 c0000003eeddba50 c00000000180fe00 0000000000000900 
>                GPR04: 0000000000000000 0000000000000000 5b20373830302e38 c00000003fff8a00 
>                GPR08: 0000000800000000 c0000003f9eb27d8 c0000003f9eb27e0 c0000003fb01ea00 
>                GPR12: c000000000828840 c00000003fff8a00 
> [ 7882.040042] NIP [c00000000000b01c] replay_interrupt_return+0x0/0x4
> [ 7882.040177] LR [c00000000001bbd4] arch_local_irq_restore.part.0+0x54/0x70
> [ 7882.040303] Call Trace:
> [ 7882.040439] [c0000003eeddba50] [c0000003eeddba90] 0xc0000003eeddba90 (unreliable)
> [ 7882.040675] [c0000003eeddba70] [c000000000d78070] _raw_spin_unlock_irqrestore+0x50/0xb0
> [ 7882.040974] [c0000003eeddba90] [c00000000082b58c] hvc_write+0xfc/0x240
> [ 7882.041143] [c0000003eeddbaf0] [c000000000801e50] n_tty_write+0x190/0x660
> [ 7882.041316] [c0000003eeddbbc0] [c0000000007fc67c] tty_write+0x19c/0x320
> [ 7887.785437] CPU 5 didn't respond to backtrace IPI, inspecting paca.
> [ 7888.292647] [c0000003eeddbc80] [c00000000045885c] do_iter_write+0x1ac/0x280
> [ 7888.292755] irq_soft_mask: 0x01 in_mce: 0 in_nmi: 0 current: 510 (systemd-journal)
> [ 7888.292924] [c0000003eeddbcd0] [c000000000458a20] vfs_writev+0xc0/0x170
> [ 7888.321765] Back trace of paca->saved_r1 (0xc0000003eeddb160) (possibly stale):
> [ 7888.321897] [c0000003eeddbdc0] [c000000000458b60] do_writev+0x90/0x1a0
> [ 7888.366983] Call Trace:
> [ 7888.367103] [c0000003eeddbe20] [c00000000000b9d0] system_call+0x5c/0x68
> [ 7888.367143] [c0000003eeddb160] [0000000000000001] 0x1 (unreliable)
> [ 7888.367236] Instruction dump:
> [ 7888.367409] rcu: rcu_sched kthread starved for 2724 jiffies! g449229 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=4
> [ 7888.367449] 7d200026 618c8000 2c030900 4182e2e8 2c030500 4182dc40 2c030f00 4182f2b8 
> [ 7888.396459] rcu: RCU grace-period kthread stack dump:
> [ 7888.396599] 2c030a00 4182ffc8 60000000 60000000 <4e800020> 7c781b78 48000349 48000361 
> [ 7888.396724] rcu_sched       I    0    10      2 0x00000808
> [ 7888.396943] Call Trace:
> [ 7888.397012] [c0000003fb5ff880] [c0000003feb96b00] 0xc0000003feb96b00 (unreliable)
> [ 7888.397174] [c0000003fb5ffa60] [c000000000021f4c] __switch_to+0x33c/0x500
> [ 7888.397289] [c0000003fb5ffac0] [c000000000d704f8] __schedule+0x2c8/0x8f0
> [ 7888.397410] [c0000003fb5ffb90] [c000000000d70b78] schedule+0x58/0x130
> [ 7888.397520] [c0000003fb5ffbc0] [c000000000d76744] schedule_timeout+0x1a4/0x3c0
> [ 7888.397676] [c0000003fb5ffca0] [c0000000001de608] rcu_gp_kthread+0x9b8/0xd80
> [ 7888.397871] [c0000003fb5ffdb0] [c00000000016f504] kthread+0x1a4/0x1b0
> [ 7888.398040] [c0000003fb5ffe20] [c00000000000bdbc] ret_from_kernel_thread+0x5c/0x80

