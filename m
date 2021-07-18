Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCAF3CCB37
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 23:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhGRWCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 18:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGRWCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Jul 2021 18:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73E6B6117A;
        Sun, 18 Jul 2021 21:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626645554;
        bh=e6Hpu47T1umSsxYAlx4k9ArmF1V+nxDiU5v2OGPduAU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=gu69XXiJCkZ7M14X6S+u9QmFT++ODnW2k3MFal90DnQJ2fdFiBJ9Ou8IgplrYdUJn
         V+TuJsEZHZ1KN1P5prVWINqDeJ/Fr8210G7TutyfcWwxej1XSpsydDjLiI2xCsSTPn
         CYaG5i26Fh8mIW4fTGx7p78uniVbMvd90plU6irlP+szbU1CAKMiHtNB4JaNSHGInv
         zjdtcOqS4ovLXyRF/rClqfovNIPZ22vO9mdjaaxUNaZZCtMwq8tcL17cd2pRu5X9+E
         yHSvwAq2Oh7xknGICNCf/M8N18qcx19YC/A2Dv2oy0ShKha0ZZh6qIkFKwGQHFiaAI
         pafpB2Pk+E5tA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 452455C2BE4; Sun, 18 Jul 2021 14:59:14 -0700 (PDT)
Date:   Sun, 18 Jul 2021 14:59:14 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6698965.kvI7vG0SvZ@natalenko.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 18, 2021 at 11:03:51PM +0200, Oleksandr Natalenko wrote:
> + stable@vger.kernel.org
> 
> On neděle 18. července 2021 23:01:24 CEST Oleksandr Natalenko wrote:
> > Hello.
> > 
> > On sobota 17. července 2021 22:22:08 CEST Chris Clayton wrote:
> > > I checked the output from dmesg yesterday and found the following warning:
> > > 
> > > [Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
> > > [Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at
> > > kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0 [Fri Jul
> > > 16

I am not seeing a warning at line 359 of either v5.13.2 or v5.12.7.

> > > 09:15:29 2021] Modules linked in: uas hidp rfcomm bnep xt_MASQUERADE
> > > iptable_nat nf_nat xt_LOG nf_log_syslog xt_limit xt_multiport xt_conntrack
> > > iptable_filter btusb btintel wmi_bmof uvcvideo videobuf2_vmalloc
> > > videobuf2_memops videobuf2_v4l2 videobuf2_common coretemp hwmon
> > > snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_codec_realtek
> > > snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg
> > > snd_hda_codec snd_hwdep snd_hda_core i2c_i801 i2c_smbus iwlmvm mac80211
> > > iwlwifi i915 mei_me mei cfg80211 intel_lpss_pci intel_lpss wmi
> > > nf_conntrack_ftp xt_helper nf_conntrack nf_defrag_ipv4 tun
> > > [Fri Jul 16 09:15:29 2021] CPU: 11 PID: 2701 Comm: lpqd Not tainted 5.13.2
> > > #1 [Fri Jul 16 09:15:29 2021] Hardware name: Notebook
> > > 
> > >   NP50DE_DB                       /NP50DE_DB , BIOS 1.07.04 02/17/2020
> > > 
> > > [Fri Jul 16 09:15:29 2021] RIP: 0010:rcu_note_context_switch+0x37/0x3d0
> > > [Fri Jul 16 09:15:29 2021] Code: 02 00 e8 ec a0 6c 00 89 c0 65 4c 8b 2c 25
> > > 00 6d 01 00 48 03 1c c5 80 56 e1 b6 40 84 ed 75 0d 41 8b 95 04 03 00 00 85
> > > d2 7e 02 <0f> 0b 65 48 8b 04 25 00 6d 01 00 8b 80 04 03 00 00 85 c0 7e 0a
> > > 41 [Fri Jul 16 09:15:29 2021] RSP: 0000:ffffb5d483837c70 EFLAGS: 00010002
> > > [Fri Jul 16 09:15:29 2021] RAX: 000000000000000b RBX: ffff9b77806e1d80
> > > RCX:
> > > 0000000000000100 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000001 RSI:
> > > ffffffffb6d82ead RDI: ffffffffb6da5e4e [Fri Jul 16 09:15:29 2021] RBP:
> > > 0000000000000000 R08: 0000000000000001 R09: 0000000000000000 [Fri Jul 16
> > > 09:15:29 2021] R10: 000000067bce4fff R11: 0000000000000000 R12:
> > > ffff9b77806e1100 [Fri Jul 16 09:15:29 2021] R13: ffff9b734a833a00 R14:
> > > ffff9b734a833a00 R15: 0000000000000000 [Fri Jul 16 09:15:29 2021] FS:
> > > 00007fccbfc5fe40(0000) GS:ffff9b77806c0000(0000) knlGS:0000000000000000
> > > [Fri Jul 16 09:15:29 2021] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > 0000000080050033 [Fri Jul 16 09:15:29 2021] CR2: 00007fccc2db7290 CR3:
> > > 00000003fb0b8002 CR4: 00000000007706e0 [Fri Jul 16 09:15:29 2021] PKRU:
> > > 55555554
> > > [Fri Jul 16 09:15:29 2021] Call Trace:
> > > [Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
> > > [Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
> > > [Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
> > > [Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
> > > [Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
> > > [Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
> > > [Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
> > > [Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
> > > [Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170
> > > [Fri Jul 16 09:15:29 2021]  ? find_vma+0x5b/0x70
> > > [Fri Jul 16 09:15:29 2021]  exc_page_fault+0x1ab/0x610
> > > [Fri Jul 16 09:15:29 2021]  ? fpregs_assert_state_consistent+0x19/0x40
> > > [Fri Jul 16 09:15:29 2021]  ? asm_exc_page_fault+0x8/0x30
> > > [Fri Jul 16 09:15:29 2021]  asm_exc_page_fault+0x1e/0x30
> > > [Fri Jul 16 09:15:29 2021] RIP: 0033:0x7fccc2d3c520
> > > [Fri Jul 16 09:15:29 2021] Code: 68 4c 00 00 00 e9 20 fb ff ff ff 25 7a ad
> > > 07 00 68 4d 00 00 00 e9 10 fb ff ff ff 25 72 ad 07 00 68 4e 00 00 00 e9 00
> > > fb ff ff <ff> 25 6a ad 07 00 68 4f 00 00 00 e9 f0 fa ff ff ff 25 62 ad 07
> > > 00 [Fri Jul 16 09:15:29 2021] RSP: 002b:00007ffebd529048 EFLAGS: 00010293
> > > [Fri Jul 16 09:15:29 2021] RAX: 0000000000000001 RBX: 00007fccc46e2890
> > > RCX:
> > > 0000000000000010 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000010 RSI:
> > > 0000000000000000 RDI: 00007fccc46e2890 [Fri Jul 16 09:15:29 2021] RBP:
> > > 000056264f1dd4a0 R08: 000056264f21aba0 R09: 000056264f1f58a0 [Fri Jul 16
> > > 09:15:29 2021] R10: 0000000000000007 R11: 0000000000000246 R12:
> > > 000056264f21ac00 [Fri Jul 16 09:15:29 2021] R13: 000056264f1e0a30 R14:
> > > 00007ffebd529080 R15: 00000000000dd87b [Fri Jul 16 09:15:29 2021] ---[ end
> > > trace c8b06e067d8b0fc2 ]---
> > > 
> > > At the time the warning was issued I was creating a (weekly) backup of my
> > > linux system (home-brewed based on the guidance from Linux From Scratch).
> > > My backup routine is completed by copying the archive files (created with
> > > dar) and a directory that contains about 7000 source and binary rpm files
> > > to an external USB drive. I didn't spot the warning until later in the
> > > day,
> > > so I'm not sure exactly where I was in my backup process.
> > > 
> > > I haven't seen this warning before. Consequently, I don;t know how easy
> > > (or
> > > otherwise) it is to reproduce.
> > > 
> > > Let me know if I can provide any additional diagnostics, but please cc me
> > > as I'm not subscribed.
> > 
> > Confirming the same for me with v5.13.2, and cross-referencing another
> > report [1] against v5.12.17.
> > 
> > Also Cc'ing relevant people on this.
> > 
> > Thanks.
> > 
> > [1]
> > https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=_Eh_1k
> > EHLHA@mail.gmail.com/

But this one does show this warning in v5.12.17:

	WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);

This is in rcu_note_context_switch(), and could be caused by something
like a schedule() within an RCU read-side critical section.  This would
of course be RCU-usage bugs, given that you are not permitted to block
within an RCU read-side critical section.

I suggest checking the functions in the stack trace to see where the
rcu_read_lock() is hiding.  CONFIG_PROVE_LOCKING might also be helpful.

							Thanx, Paul
