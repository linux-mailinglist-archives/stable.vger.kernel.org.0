Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65145577B
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbhKRJAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243644AbhKRJAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:00:43 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EBBC061570;
        Thu, 18 Nov 2021 00:57:42 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mndEj-00017M-2J; Thu, 18 Nov 2021 09:57:41 +0100
Message-ID: <99d07599-3d72-d389-cfc2-f463230037a5@leemhuis.info>
Date:   Thu, 18 Nov 2021 09:57:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [OOPS] Linux 5.14.19 crashes and burns!
Content-Language: en-BS
To:     Chris Rankin <rankincj@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <CAK2bqV+NuRYNU0dHni9Cmfvi5CZ7Ycp6rGrNRDLzrdU9xkSXaw@mail.gmail.com>
From:   Thorsten Leemhuis <linux@leemhuis.info>
In-Reply-To: <CAK2bqV+NuRYNU0dHni9Cmfvi5CZ7Ycp6rGrNRDLzrdU9xkSXaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1637225863;8a5bfbce;
X-HE-SMSGID: 1mndEj-00017M-2J
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lo! CCing stable and regressions list. FWIW, I have a Fedora 34 VM that
stopped booting with 5.14.19 as well. More inline:

On 18.11.21 01:55, Chris Rankin wrote:
>
> I have tried to boot a vanilla 5.14.19 kernel, but it crashes when
> "switching root" away from the initramfs. ("Unable to handle page
> fault...)
> 
> Google's "copy text from image" feature has managed to scrape this
> information from my phone camera:
> 
> 1tch Noo
> BUG: unable to handle page fault for address: ffffc980006cfeDS
> #PF: supervisor read access in kernel mode #PF: error_code (8x8888) -
> not-present page
> PGD 100000067 P4D 100000067 PUD 18885e867 PMD 104486867 PTE 8
> Oops: 0888 [#1] PREEMPT SMP PTI
> CPU: 6 PID: 1 Comm: systemd Tainted: G Hardware name: Gigabyte
> Technology Co., Ltd. EX58-UD3R/EX58-UD3R, BIOS FB 05/04/2009
> 5.14.19 #1
> RIP: 0010: __unwind_start+8xb5/8x15f
> Code: 48 8d 8d 88 88 88 88 48 89 e2 48 89 e8 48 89 4d 48 48 89 55 38
> 48 RSP: 0018:ffffc90088823bf0 EFLAGS: 00010006
> RAX: ffffc900006efde8 RBX: 0000000000000000 RCX: 08 RDX:
> ffffc900006efe18 RSI : ffff88818a9f6c80 RDI: ffffc
> RBP: ffffc90808823c18 R08: 00000000000001de R89: R10: ffff888107d20000
> R11: ffff888183b4ba88 R12: ffffc900006ef dell
> R13: ffff88810a9f73bc R14: ffff888103c58480 R15: FS: 00007f528fd19b40
> (0800) GS:ffff888343488808 (0888) knl6S:
> CS: 0818 DS: 0000 ES: 0000 CRO: 0888000088858833
> CR2: ffffc900006efe88 CR3: 088080818186a888 CR4: 8888
> Call Trace:
> <TASK>
> get_wchan+8x42/8x8f
> get_wchan+8x45/8x59
> do_task_stat+0x3ab/0x38
> proc_single_show+8x1e/8x68
> seq_read_iter+0x151/8x342 seq_read+8xf1/8x117
> uf's_read+Bxa3/8x183
> ksys_read+8x71/8xb9 do_syscal1_64+8x6d/8x88
> entry_SYSCALL_64_after_huframe+8x11/8xne
> RIP: 8033:8x7f529884f832
> Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 2e Bc 80 68 65 £9 01 00 0f 16 44 000
> RSP: 082b:00087ffed3b91f18 EFLAGS: 88888246 ORIG RAX:
> RAX: ffffffffffffffda RBX: 8888559462036658 RCX: 000071529084/83
> RDX: 0000000000000100 RSI: 8088559462c90b78 RDI:
> RBP: 000071529894a300 BAR:
> te fa
> 
> And also this:
> 
> do_syscall_64+0x6d/0x80
> entry_SYSCALL_64_after_huframe+0x44/0xae
> RIP: 8033:0x7f529884f832
> Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea Ze Bc 80 e8 b5 f9 01 00 0f 1f
> 44 00 00 f3 Bf 1e fa 64 8b 84 25 18 88 RSP: 082b:00087ffed3b91f 18
> EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000559462c36650 RCX: 000071529084f832 RDX:
> 0000000000000400 RSI: 0000559462c90b70 RDI: 0000000000000006
> RBP: 000071529094a3a0 R08: 0000000000000006 RO9: 0000000000000001 R18:
> 0000000000001000 R11: 0000000000000246 R12: 00007f528fd198f0
> R13: 0000000000000168 R14: 00007f52909497a0 R15: 00000000000001468
> </TASK>
> Modules linked in: ext4 crc32c_generic crc16 mbcache jbd2 sr_mod
> sd_mod cdrom hid_microsoft usbhid amdgpu uh ci drm_kms_helper ehci_hcd
> cf bf illrect syscopyarea cfbimgblt sysfillrect sysimgblt xhci pci
> xhci_hcd fb_sys_ mod usb_common drm_panel_orientation_quirks
> ipmi_devintf ipmi_msghandler msr sha256_ssse3 sha256_generic ipu CRZ:
> ffffc900006efe08
> --- end trace 9771b79967a8dd89 ]--- RIP: 8010:_unwind_start+8xb5/0x15f
> Code: 48 8d 8d 00 00 00 00 48 89 e2 48 89 e8 48 89 4d 48 48 89 55 38
> 48 89 45 40 eb 29 48 8b 86 98 Ba 80 00 RSP: 0818:ffffc90000023bf0
> EFLAGS: 00010006 RAX: ffffc900006efde0 RBX: 0000000000000000 RCX:
> 0000000000000000
> RDX: ffffc900006efe18 RSI: ffff88810a9f6c00 RDI: ffffc90000023c78 RBP:
> ffffc98800023c18 R08: 00000000000001de R09: 00000000005b20c6
> R10: ffff888107120000 R11: ffff888103b4ba80 R12: ffffc900006ef de
> R13: ffff88818a9f73bc R14: ffff888103c50480 R15: 0000000000000000 FS:
> 00007f528fd19b40(8000) GS:ffff888343180000 (0800)
> knlGS:0000000000000000 CS: 0810 DS: 0000 ES: 0000 CRO:
> 0000000080050033
> CR2: ffffc908806efe88 CR3: 000000010186a000 CR4: 00000000000006e0
> note: systemd [1] exited with preempt_count 1
> Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009 Kernel Offset: disabled
> --- [ end Kernel panic not syncing: Attempted to kill initf
> exitcode=0x00000009 1--- -
> 
> I cannot capture the exact oops via any other means, although I can
> send the original camera pictures that I captured the text from, on
> request.

By default I didn't get to see any messages, the VM just hangs when
switching to root. Did anyone else already report or even track this
down already? Guess otherwise I need to take a closer look and maybe
start bisecting...

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, the Linux kernel regression tracking bot:

#regzbot ^introduced v5.14.18..v5.14.19
#regzbot title 5.14.19 crashes when switching from initramfs to root

Ciao, Thorsten (as Linux kernel regression tracker and someone that is
affected by this...)

P.S.: If you want to know more about regzbot, check out its
web-interface, the getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

But note, regzbot is doing its first field-testing now and thus still
has some bugs. Adding this regression will help be to find them, hence
feel free to ignore this mail or any errors you spot in the web-ui.
