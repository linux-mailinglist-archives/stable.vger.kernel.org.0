Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59471528BE3
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiEPRYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344201AbiEPRYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:24:05 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [IPv6:2a01:e0c:1:1599::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270A9CFD
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:24:00 -0700 (PDT)
Received: from geek500.localdomain (unknown [82.65.8.64])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp5-g21.free.fr (Postfix) with ESMTPSA id D49EC5FFBE;
        Mon, 16 May 2022 19:23:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652721838;
        bh=Z/Ypw1j9RbmtyJH5sz0JZwIvXSiwAADxuJ2kvgNJtzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGXNrbTIsrtUpx+1AhG/Pw/WqdvtQeszkmVX0qZedhDgRlb54mUn0EKJf6M6ZJm+b
         2I87+MxeTFj1X3bz/t/VCYGB0Y2WYz9VQXv4ODnIDLXYPkRZWnWIgmkPUiiLk4UOJq
         2uMEC5gXzrkh508qorpwpfmVCW8G39PHkqP8c2OHKTUAVbo5ywrEZWeJW2xCHGPUf6
         yIACXPP1KsM1P6EyzcUY+2GM0SMT7Haif4ziK5pkP5ArdNpqFQC5kCUdtsgzaXb/Fr
         vbkR4BPXvaTbYQw5JtdVgVqd/R7jNClKvCiMsVrrZYTHrMBUpVowq0NvVh+aU6vo4m
         dERCKp5E6Xlnw==
From:   Christian Casteyde <casteyde.christian@free.fr>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
Date:   Mon, 16 May 2022 19:23:36 +0200
Message-ID: <2592420.vuYhMxLoTh@geek500.localdomain>
In-Reply-To: <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com>
References: <2584945.lGaqSPkdTl@geek500.localdomain> <25425832.1r3eYUQgxm@geek500.localdomain> <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4683878.OV4Wx5bFTl"
Content-Transfer-Encoding: 7Bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart4683878.OV4Wx5bFTl
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

I've tried with 5.18-rc7, it doesn't work either. I guess 5.18 branch have =
all=20
commits.

full dmesg appended (not for 5.18, I didn't manage to resume up to the poin=
t=20
to get a console for now).

CC

Le lundi 16 mai 2022, 04:47:25 CEST Kai-Heng Feng a =E9crit :
> [+Cc Mario]
>=20
> On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
>=20
> <casteyde.christian@free.fr> wrote:
> > I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
> > This does not fix the problem on my laptop.
>=20
> Maybe some commits are still missing?
>=20
> > For informatio, here is a part of the log around the suspend process:
> Is it possible to attach full dmesg?
>=20
> Kai-Heng
>=20
> > May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change
> > power state from D3cold to D0 (config space inaccessible)
> > May 14 19:21:41 geek500 kernel: PM: late suspend of devices failed
> > May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> > May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03: Transfer wh=
ile
> > suspended
> > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive routing =
for
> > PCI INT A
> > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
> > May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at drivers/i2=
c/
> > busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
> > May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded:
> > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm:
> > kworker/u32:18 Tainted: G           O      5.17.7+ #7
> > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming
> > Laptop
> > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > May 14 19:21:41 geek500 kernel: Workqueue: events_unbound
> > async_run_entry_fn May 14 19:21:41 geek500 kernel: RIP:
> > 0010:i2c_dw_xfer+0x3f6/0x440
> > May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b 67 50 =
4d
> > 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
> >=20
> >  ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc ff ff e9=
 2d
> >  9c>=20
> > 4b 00 83 f8 01 74
> > May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68 EFLAGS:
> > 00010286
> > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> > ffff888540f170e8
> > RCX: 0000000000000be5
> > May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI:
> > 0000000000000086
> > RDI: ffffffffac858df8
> > May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08:
> > ffffffffabe46d60
> > R09: 00000000ac86a0f6
> > May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11:
> > ffffffffffffffff
> > R12: ffff888540f5c070
> > May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14:
> > 00000000ffffff94
> > R15: ffff888540f17028
> > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > GS:ffff88885f640000(0000) knlGS:0000000000000000
> > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
> > 0000000045e0c000
> > CR4: 0000000000350ee0
> > May 14 19:21:41 geek500 kernel: Call Trace:
> > May 14 19:21:41 geek500 kernel:  <TASK>
> > May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
> > May 14 19:21:41 geek500 kernel:  ? newidle_balance.constprop.0+0x1f7/0x=
3b0
> > May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
> > May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
> > May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
> > May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
> > May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
> > May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
> > May 14 19:21:41 geek500 kernel:  ? acpi_subsys_resume_early+0x50/0x50
> > May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
> > May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
> > May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
> > May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
> > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > May 14 19:21:41 geek500 kernel:  </TASK>
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: failed to
> > change power setting.
> > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> > acpi_subsys_resume+0x0/0x50 returns -108
> > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM: failed
> > to
> > resume async: error -108
> > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
> > [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
> > May 14 19:21:41 geek500 kernel: [drm:amdgpu_device_ip_resume_phase2]
> > *ERROR* resume of IP block <gfx_v9_0> failed -110
> > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> > amdgpu_device_ip_resume failed (-110).
> > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> > pci_pm_resume+0x0/0x120 returns -110
> > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed to resu=
me
> > async: error -110
> > May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/cl=
k/
> > clk.c:971 clk_core_disable+0x80/0x1a0
> > May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded:
> > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming
> > Laptop
> > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> > May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
> > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 =
48
> > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4
> > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 =
05
> > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50
> > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel:
> > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> > ffff8885401b6300
> > RCX: 0000000000000027
> > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > 0000000000000001
> > RDI: ffff88885f59f460
> > May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08:
> > ffffffffabf26da8
> > R09: 00000000ffffdfff
> > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > ffffffffabe46dc0
> > R12: ffff8885401b6300
> > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > 0000000000000008
> > R15: 0000000000000000
> > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > 0000000102956000
> > CR4: 0000000000350ee0
> > May 14 19:21:41 geek500 kernel: Call Trace:
> > May 14 19:21:41 geek500 kernel:  <TASK>
> > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
> > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > May 14 19:21:41 geek500 kernel:  </TASK>
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> > May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/cl=
k/
> > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> > May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded:
> > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming
> > Laptop
> > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> > May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
> > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db =
74
> > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4
> > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 =
ea
> > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60
> > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX: 0000000000000000
> > RBX: ffff8885401b6300 RCX: 0000000000000027
> > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > 0000000000000001
> > RDI: ffff88885f59f460
> > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> > ffffffffabf26da8
> > R09: 00000000ffffdfff
> > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > ffffffffabe46dc0
> > R12: 0000000000000000
> > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > 0000000000000008
> > R15: 0000000000000000
> > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > 0000000102956000
> > CR4: 0000000000350ee0
> > May 14 19:21:41 geek500 kernel: Call Trace:
> > May 14 19:21:41 geek500 kernel:  <TASK>
> > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
> > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel: done.
> > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > May 14 19:21:41 geek500 kernel:  </TASK>
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> > May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/cl=
k/
> > clk.c:971 clk_core_disable+0x80/0x1a0
> > May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded:
> > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming
> > Laptop
> > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> > May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
> > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 =
48
> > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4
> > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 =
05
> > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50
> > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel: RAX: 0000000000000000
> > RBX: ffff8885401b6300 RCX: 0000000000000027
> > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > 0000000000000001
> > RDI: ffff88885f59f460
> > May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08:
> > ffffffffabf26da8
> > R09: 00000000ffffdfff
> > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > ffffffffabe46dc0
> > R12: ffff8885401b6300
> > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > 0000000000000008
> > R15: 0000000000000000
> > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > 0000000102956000
> > CR4: 0000000000350ee0
> > May 14 19:21:41 geek500 kernel: Call Trace:
> > May 14 19:21:41 geek500 kernel:  <TASK>
> > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
> > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > May 14 19:21:41 geek500 kernel:  </TASK>
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> > May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/cl=
k/
> > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> > May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded:
> > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
> > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming
> > Laptop
> > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> > May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
> > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db =
74
> > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4
> > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 =
ea
> > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60
> > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX: 0000000000000000
> > RBX: ffff8885401b6300 RCX: 0000000000000027
> > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > 0000000000000001
> > RDI: ffff88885f59f460
> > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> > ffffffffabf26da8
> > R09: 00000000ffffdfff
> > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > ffffffffabe46dc0
> > R12: 0000000000000000
> > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > 0000000000000008
> > R15: 0000000000000000
> > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > 0000000102956000
> > CR4: 0000000000350ee0
> > May 14 19:21:41 geek500 kernel: Call Trace:
> > May 14 19:21:41 geek500 kernel:  <TASK>
> > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
> > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > May 14 19:21:41 geek500 kernel:  </TASK>
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> > May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable =
to
> > sync register 0x4f0800. -5
> > May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
> > May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu: Power
> > consumption will be higher as BIOS has not been configured for
> > suspend-to-idle. To use suspend-to-idle change the sleep mode in BIOS
> > setup.
> > May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change
> > power state from D3cold to D0 (config space inaccessible)
> > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive routing =
for
> > PCI INT A
> > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
> > May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command 0xfc20 tx
> > timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer
> > expired on ring sdma0
> > May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download fw comma=
nd
> > failed (-110)
> > May 14 19:21:59 geek500 kernel: done.
> > May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable =
to
> > sync register 0x4f0800. -5
> > May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in /etc/dnsmasq=
=2Ed/
> > dnsmasq-resolv.conf, will retry
> > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > sdma0
> > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:02 geek500 last message buffered 2 times
> > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:05 geek500 last message buffered 2 times
> > May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired =
on
> > ring sdma0
> > May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > gfx May 14 19:22:06 geek500 last message buffered 1 times
> > ...
> > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > sdma0
> > May 14 19:22:18 geek500 kernel: [drm:amdgpu_dm_atomic_commit_tail] *ERR=
OR*
> > Waiting for fences timed out!
> > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on r=
ing
> > sdma0
> >=20
> > CC
> >=20
> > Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a =E9crit :
> > > Hi, this is your Linux kernel regression tracker. Thanks for the repo=
rt.
> > >=20
> > > On 14.05.22 16:41, Christian Casteyde wrote:
> > > > #regzbot introduced v5.17.3..v5.17.4
> > > > #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
> > >=20
> > > FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA function is
> > > suspended before ASIC reset") upstream.
> > >=20
> > > Recently a regression was reported where 887f75cfd0da was suspected as
> > > the culprit:
> > > https://gitlab.freedesktop.org/drm/amd/-/issues/2008
> > >=20
> > > And a one related to it:
> > > https://gitlab.freedesktop.org/drm/amd/-/issues/1982
> > >=20
> > > You might want to take a look if what was discussed there might be
> > > related to your problem (I'm not directly involved in any of this, I
> > > don't know the details, it's just that 887f75cfd0da looked familiar to
> > > me). If it is, a fix for these two bugs was committed to master earli=
er
> > > this week:
> > >=20
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmi
> > > t/?i d=3Da56f445f807b0276
> > >=20
> > > It will likely be backported to 5.17.y, maybe already in the over-next
> > > release. HTH.
> > >=20
> > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' h=
at)
> > >=20
> > > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > > reports and sometimes miss something important when writing mails like
> > > this. If that's the case here, don't hesitate to tell me in a public
> > > reply, it's in everyone's interest to set the public record straight.
> > >=20
> > > > Hello
> > > > Since 5.17.4 my laptop doesn't resume from suspend anymore. At resu=
me,
> > > > symptoms are variable:
> > > > - either the laptop freezes;
> > > > - either the screen keeps blank;
> > > > - either the screen is OK but mouse is frozen;
> > > > - either display lags with several logs in dmesg:
> > > > [  228.275492] [drm] Fence fallback timer expired on ring gfx
> > > > [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting f=
or
> > > > fences timed out!
> > > > [  228.779490] [drm] Fence fallback timer expired on ring gfx
> > > > [  229.283484] [drm] Fence fallback timer expired on ring sdma0
> > > > [  229.283485] [drm] Fence fallback timer expired on ring gfx
> > > > [  229.787487] [drm] Fence fallback timer expired on ring gfx
> > > > ...
> > > >=20
> > > > I've bisected the problem.
> > > >=20
> > > > Please note this laptop has a strange behaviour on suspend:
> > > > The first suspend request always fails (this point has never been
> > > > fixed
> > > > and
> > > > plagues us when trying to diagnose another regression on touchpad n=
ot
> > > > resuming in the past). The screen goes blank and I can get it OK wh=
en
> > > > pressing the power button, this seems to reset it. After that all
> > > > suspend/resume works OK.
> > > >=20
> > > > Since 5.17.4, it is not possible anymore to get the laptop working
> > > > again
> > > > after the first suspend failure.
> > > >=20
> > > > HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated + NVidia
> > > > 1650Ti
> > > > (turned off with ACPI call in order to get more battery, I'm not us=
ing
> > > > NVidia driver).


--nextPart4683878.OV4Wx5bFTl
Content-Disposition: attachment; filename="dmesg-bad.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmesg-bad.txt"

[    0.000000] Linux version 5.17.3+ (root@geek500.localdomain) (gcc (GCC) 11.2.0, GNU ld version 2.38-slack151) #2 SMP PREEMPT Sat May 14 15:26:52 CEST 2022
[    0.000000] Command line: ro root=/dev/nvme0n1p4
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 1776
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009ecffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000009ed0000-0x0000000009ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a20cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000a20d000-0x00000000a7383fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a7384000-0x00000000a74d9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a74da000-0x00000000a753ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000a7540000-0x00000000a76eefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a76ef000-0x00000000acffdfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000acffe000-0x00000000adffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ae000000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042f33ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000042f340000-0x00000004701fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xa4177018-0xa41a0857] usable ==> usable
[    0.000000] e820: update [mem 0xa4177018-0xa41a0857] usable ==> usable
[    0.000000] e820: update [mem 0xa423a018-0xa4247457] usable ==> usable
[    0.000000] e820: update [mem 0xa423a018-0xa4247457] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000009ecffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000009ed0000-0x0000000009ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] reserve setup_data: [mem 0x000000000a200000-0x000000000a20cfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000000a20d000-0x00000000a4177017] usable
[    0.000000] reserve setup_data: [mem 0x00000000a4177018-0x00000000a41a0857] usable
[    0.000000] reserve setup_data: [mem 0x00000000a41a0858-0x00000000a423a017] usable
[    0.000000] reserve setup_data: [mem 0x00000000a423a018-0x00000000a4247457] usable
[    0.000000] reserve setup_data: [mem 0x00000000a4247458-0x00000000a7383fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000a7384000-0x00000000a74d9fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000a74da000-0x00000000a753ffff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000a7540000-0x00000000a76eefff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000a76ef000-0x00000000acffdfff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000acffe000-0x00000000adffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ae000000-0x00000000afffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fd000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000042f33ffff] usable
[    0.000000] reserve setup_data: [mem 0x000000042f340000-0x00000004701fffff] reserved
[    0.000000] efi: EFI v2.70 by American Megatrends
[    0.000000] efi: ACPI=0xa753f000 ACPI 2.0=0xa753f014 TPMFinalLog=0xa76a7000 SMBIOS=0xace1b000 SMBIOS 3.0=0xace1a000 MEMATTR=0xa6019018 ESRT=0xa6621d18 RNG=0xace68f98 TPMEventLog=0xa609a018 
[    0.000000] efi: seeding entropy pool
[    0.000000] SMBIOS 3.2.0 present.
[    0.000000] DMI: HP HP Pavilion Gaming Laptop 15-ec1xxx/87B2, BIOS F.25 08/18/2021
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2994.526 MHz processor
[    0.000133] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000135] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000139] last_pfn = 0x42f340 max_arch_pfn = 0x400000000
[    0.000247] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000475] e820: update [mem 0xb0000000-0xffffffff] usable ==> reserved
[    0.000483] last_pfn = 0xae000 max_arch_pfn = 0x400000000
[    0.000493] esrt: Reserving ESRT space from 0x00000000a6621d18 to 0x00000000a6621d50.
[    0.000503] e820: update [mem 0xa6621000-0xa6621fff] usable ==> reserved
[    0.000544] Using GB pages for direct mapping
[    0.000880] Secure boot disabled
[    0.000882] ACPI: Early table checksum verification disabled
[    0.000885] ACPI: RSDP 0x00000000A753F014 000024 (v02 HPQOEM)
[    0.000887] ACPI: XSDT 0x00000000A753E728 0000EC (v01 HPQOEM SLIC-MPC 01072009 AMI  01000013)
[    0.000892] ACPI: FACP 0x00000000A7534000 000114 (v06 HPQOEM SLIC-MPC 01072009 HP   00010013)
[    0.000895] ACPI: DSDT 0x00000000A751F000 0149B8 (v02 HPQOEM 87B2     01072009 ACPI 20120913)
[    0.000897] ACPI: FACS 0x00000000A76A5000 000040
[    0.000899] ACPI: SSDT 0x00000000A7536000 007216 (v02 HPQOEM 87B2     00000002 ACPI 04000000)
[    0.000901] ACPI: IVRS 0x00000000A7535000 0001A4 (v02 HPQOEM 87B2     00000001 HP   00000000)
[    0.000903] ACPI: FIDT 0x00000000A751E000 00009C (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.000904] ACPI: MCFG 0x00000000A751D000 00003C (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.000906] ACPI: HPET 0x00000000A751C000 000038 (v01 HPQOEM 87B2     01072009 HP   00000005)
[    0.000908] ACPI: SSDT 0x00000000A751B000 000228 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000910] ACPI: VFCT 0x00000000A750D000 00D484 (v01 HPQOEM 87B2     00000001 HP   31504F47)
[    0.000912] ACPI: SSDT 0x00000000A750C000 000050 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000914] ACPI: TPM2 0x00000000A750B000 00004C (v04 HPQOEM 87B2     00000001 HP   00000000)
[    0.000915] ACPI: SSDT 0x00000000A7508000 002B80 (v01 HPQOEM 87B2     00000001 ACPI 00000001)
[    0.000917] ACPI: CRAT 0x00000000A7507000 000BA8 (v01 HPQOEM 87B2     00000001 HP   00000001)
[    0.000919] ACPI: CDIT 0x00000000A7506000 000029 (v01 HPQOEM 87B2     00000001 HP   00000001)
[    0.000921] ACPI: SSDT 0x00000000A7505000 000139 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000922] ACPI: SSDT 0x00000000A7504000 0000C2 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000924] ACPI: SSDT 0x00000000A7503000 000D37 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000926] ACPI: SSDT 0x00000000A7501000 0010AC (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000928] ACPI: SSDT 0x00000000A7500000 000D87 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000930] ACPI: SSDT 0x00000000A74FC000 0030C8 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000932] ACPI: WSMT 0x00000000A74FB000 000028 (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.000933] ACPI: APIC 0x00000000A74FA000 0000DE (v03 HPQOEM 87B2     01072009 HP   00010013)
[    0.000935] ACPI: SSDT 0x00000000A74F9000 00007D (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000937] ACPI: SSDT 0x00000000A74F8000 000517 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.000939] ACPI: FPDT 0x00000000A74F7000 000044 (v01 HPQOEM 87B2     01072009 HP   01000013)
[    0.000941] ACPI: BGRT 0x00000000A74F6000 000038 (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.000942] ACPI: Reserving FACP table memory at [mem 0xa7534000-0xa7534113]
[    0.000943] ACPI: Reserving DSDT table memory at [mem 0xa751f000-0xa75339b7]
[    0.000944] ACPI: Reserving FACS table memory at [mem 0xa76a5000-0xa76a503f]
[    0.000945] ACPI: Reserving SSDT table memory at [mem 0xa7536000-0xa753d215]
[    0.000946] ACPI: Reserving IVRS table memory at [mem 0xa7535000-0xa75351a3]
[    0.000947] ACPI: Reserving FIDT table memory at [mem 0xa751e000-0xa751e09b]
[    0.000948] ACPI: Reserving MCFG table memory at [mem 0xa751d000-0xa751d03b]
[    0.000948] ACPI: Reserving HPET table memory at [mem 0xa751c000-0xa751c037]
[    0.000949] ACPI: Reserving SSDT table memory at [mem 0xa751b000-0xa751b227]
[    0.000950] ACPI: Reserving VFCT table memory at [mem 0xa750d000-0xa751a483]
[    0.000951] ACPI: Reserving SSDT table memory at [mem 0xa750c000-0xa750c04f]
[    0.000952] ACPI: Reserving TPM2 table memory at [mem 0xa750b000-0xa750b04b]
[    0.000952] ACPI: Reserving SSDT table memory at [mem 0xa7508000-0xa750ab7f]
[    0.000953] ACPI: Reserving CRAT table memory at [mem 0xa7507000-0xa7507ba7]
[    0.000954] ACPI: Reserving CDIT table memory at [mem 0xa7506000-0xa7506028]
[    0.000955] ACPI: Reserving SSDT table memory at [mem 0xa7505000-0xa7505138]
[    0.000956] ACPI: Reserving SSDT table memory at [mem 0xa7504000-0xa75040c1]
[    0.000956] ACPI: Reserving SSDT table memory at [mem 0xa7503000-0xa7503d36]
[    0.000957] ACPI: Reserving SSDT table memory at [mem 0xa7501000-0xa75020ab]
[    0.000958] ACPI: Reserving SSDT table memory at [mem 0xa7500000-0xa7500d86]
[    0.000959] ACPI: Reserving SSDT table memory at [mem 0xa74fc000-0xa74ff0c7]
[    0.000960] ACPI: Reserving WSMT table memory at [mem 0xa74fb000-0xa74fb027]
[    0.000960] ACPI: Reserving APIC table memory at [mem 0xa74fa000-0xa74fa0dd]
[    0.000961] ACPI: Reserving SSDT table memory at [mem 0xa74f9000-0xa74f907c]
[    0.000962] ACPI: Reserving SSDT table memory at [mem 0xa74f8000-0xa74f8516]
[    0.000963] ACPI: Reserving FPDT table memory at [mem 0xa74f7000-0xa74f7043]
[    0.000964] ACPI: Reserving BGRT table memory at [mem 0xa74f6000-0xa74f6037]
[    0.000988] Zone ranges:
[    0.000989]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000990]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000991]   Normal   [mem 0x0000000100000000-0x000000042f33ffff]
[    0.000992] Movable zone start for each node
[    0.000993] Early memory node ranges
[    0.000993]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.000995]   node   0: [mem 0x0000000000100000-0x0000000009ecffff]
[    0.000995]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
[    0.000996]   node   0: [mem 0x000000000a20d000-0x00000000a7383fff]
[    0.000997]   node   0: [mem 0x00000000acffe000-0x00000000adffffff]
[    0.000998]   node   0: [mem 0x0000000100000000-0x000000042f33ffff]
[    0.001000] Initmem setup node 0 [mem 0x0000000000001000-0x000000042f33ffff]
[    0.001003] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.001019] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.001152] On node 0, zone DMA32: 304 pages in unavailable ranges
[    0.005306] On node 0, zone DMA32: 13 pages in unavailable ranges
[    0.005555] On node 0, zone DMA32: 23674 pages in unavailable ranges
[    0.028263] On node 0, zone Normal: 8192 pages in unavailable ranges
[    0.028297] On node 0, zone Normal: 3264 pages in unavailable ranges
[    0.028543] ACPI: PM-Timer IO Port: 0x808
[    0.028549] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.028559] IOAPIC[0]: apic_id 13, version 33, address 0xfec00000, GSI 0-23
[    0.028565] IOAPIC[1]: apic_id 14, version 33, address 0xfec01000, GSI 24-55
[    0.028567] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.028568] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.028571] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.028572] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.028584] e820: update [mem 0xa47b1000-0xa47c4fff] usable ==> reserved
[    0.028591] smpboot: Allowing 16 CPUs, 4 hotplug CPUs
[    0.028607] [mem 0xb0000000-0xefffffff] available for PCI devices
[    0.028610] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.033781] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:16 nr_node_ids:1
[    0.034266] percpu: Embedded 56 pages/cpu s192512 r8192 d28672 u262144
[    0.034273] pcpu-alloc: s192512 r8192 d28672 u262144 alloc=1*2097152
[    0.034274] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
[    0.034292] Built 1 zonelists, mobility grouping on.  Total pages: 3964594
[    0.034294] Kernel command line: root=/dev/nvme0n1p4 ro ro root=/dev/nvme0n1p4
[    0.035910] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.036741] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.036783] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.073376] Memory: 15650360K/16110752K available (20497K kernel code, 2883K rwdata, 7884K rodata, 1252K init, 3872K bss, 460132K reserved, 0K cma-reserved)
[    0.073383] random: get_random_u64 called from __kmem_cache_create+0x1f/0x4d0 with crng_init=0
[    0.073485] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.073536] Dynamic Preempt: full
[    0.073567] rcu: Preemptible hierarchical RCU implementation.
[    0.073568] rcu: 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=16.
[    0.073569] 	Trampoline variant of Tasks RCU enabled.
[    0.073570] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.073571] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
[    0.074585] NR_IRQS: 16640, nr_irqs: 1096, preallocated irqs: 16
[    0.074879] Console: colour dummy device 80x25
[    0.075052] printk: console [tty0] enabled
[    0.075063] ACPI: Core revision 20211217
[    0.075240] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.075258] APIC: Switch to symmetric I/O mode setup
[    0.075958] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR0, rdevid:160
[    0.075960] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR1, rdevid:160
[    0.075962] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR2, rdevid:160
[    0.075964] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR3, rdevid:160
[    0.076208] Switched APIC routing to physical flat.
[    0.076782] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.081260] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x2b2a1245bee, max_idle_ns: 440795214868 ns
[    0.081269] Calibrating delay loop (skipped), value calculated using timer frequency.. 5989.05 BogoMIPS (lpj=2994526)
[    0.081273] pid_max: default: 32768 minimum: 301
[    0.083021] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.083049] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.083208] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.083245] LVT offset 1 assigned for vector 0xf9
[    0.083305] LVT offset 2 assigned for vector 0xf4
[    0.083322] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.083324] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB 0
[    0.083328] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.083331] Spectre V2 : Mitigation: Retpolines
[    0.083332] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.083334] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.083335] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.083337] Spectre V2 : User space: Mitigation: STIBP via prctl
[    0.083339] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.085019] Freeing SMP alternatives memory: 48K
[    0.188049] smpboot: CPU0: AMD Ryzen 5 4600H with Radeon Graphics (family: 0x17, model: 0x60, stepping: 0x1)
[    0.188132] cblist_init_generic: Setting adjustable number of callback queues.
[    0.188137] cblist_init_generic: Setting shift to 4 and lim to 1.
[    0.188146] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
[    0.188151] ... version:                0
[    0.188152] ... bit width:              48
[    0.188154] ... generic registers:      6
[    0.188155] ... value mask:             0000ffffffffffff
[    0.188156] ... max period:             00007fffffffffff
[    0.188158] ... fixed-purpose events:   0
[    0.188159] ... event mask:             000000000000003f
[    0.188209] rcu: Hierarchical SRCU implementation.
[    0.188265] smp: Bringing up secondary CPUs ...
[    0.188265] x86: Booting SMP configuration:
[    0.188265] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11
[    0.201304] smp: Brought up 1 node, 12 CPUs
[    0.201310] smpboot: Max logical packages: 2
[    0.201312] smpboot: Total of 12 processors activated (71868.62 BogoMIPS)
[    0.202270] devtmpfs: initialized
[    0.202353] ACPI: PM: Registering ACPI NVS region [mem 0x0a200000-0x0a20cfff] (53248 bytes)
[    0.202353] ACPI: PM: Registering ACPI NVS region [mem 0xa7540000-0xa76eefff] (1765376 bytes)
[    0.202353] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.202353] futex hash table entries: 4096 (order: 6, 262144 bytes, linear)
[    0.202357] pinctrl core: initialized pinctrl subsystem
[    0.202441] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.202488] DMA: preallocated 2048 KiB GFP_KERNEL pool for atomic allocations
[    0.202494] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.202499] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.202532] thermal_sys: Registered thermal governor 'fair_share'
[    0.202532] thermal_sys: Registered thermal governor 'bang_bang'
[    0.202534] thermal_sys: Registered thermal governor 'step_wise'
[    0.202535] thermal_sys: Registered thermal governor 'user_space'
[    0.202543] cpuidle: using governor ladder
[    0.202547] cpuidle: using governor menu
[    0.202568] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.202568] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.202568] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.202568] PCI: Using configuration type 1 for base access
[    0.205284] cryptd: max_cpu_qlen set to 1000
[    0.205294] ACPI: Added _OSI(Module Device)
[    0.205296] ACPI: Added _OSI(Processor Device)
[    0.205298] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.205299] ACPI: Added _OSI(Processor Aggregator Device)
[    0.205301] ACPI: Added _OSI(Linux-Dell-Video)
[    0.205303] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.205304] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.212994] ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.GPP1.WLAN], AE_NOT_FOUND (20211217/dswload2-162)
[    0.213000] ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20211217/psobject-220)
[    0.213003] ACPI: Skipping parse of AML opcode: OpcodeName unavailable (0x0010)
[    0.214270] ACPI: 13 ACPI AML tables successfully acquired and loaded
[    0.215097] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.216151] ACPI: EC: EC started
[    0.216153] ACPI: EC: interrupt blocked
[    0.542377] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.542382] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle transactions
[    0.542386] ACPI: Interpreter enabled
[    0.542402] ACPI: PM: (supports S0 S3 S5)
[    0.542404] ACPI: Using IOAPIC for interrupt routing
[    0.542577] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.542896] ACPI: Enabled 5 GPEs in block 00 to 1F
[    0.544329] ACPI: PM: Power Resource [P0S0]
[    0.544354] ACPI: PM: Power Resource [P3S0]
[    0.544423] ACPI: PM: Power Resource [P0S1]
[    0.544446] ACPI: PM: Power Resource [P3S1]
[    0.545064] ACPI: PM: Power Resource [PG00]
[    0.552165] ACPI: PM: Power Resource [PRWL]
[    0.552583] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.552590] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.552595] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.552665] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.552670] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
[    0.552894] PCI host bridge to bus 0000:00
[    0.552897] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.552901] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.552904] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.552907] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.552910] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000dffff window]
[    0.552913] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfebfffff window]
[    0.552917] pci_bus 0000:00: root bus resource [mem 0xfee00000-0xffffffff window]
[    0.552921] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.552934] pci 0000:00:00.0: [1022:1630] type 00 class 0x060000
[    0.553019] pci 0000:00:00.2: [1022:1631] type 00 class 0x080600
[    0.553106] pci 0000:00:01.0: [1022:1632] type 00 class 0x060000
[    0.553169] pci 0000:00:01.1: [1022:1633] type 01 class 0x060400
[    0.553229] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.553305] pci 0000:00:01.2: [1022:1634] type 01 class 0x060400
[    0.553330] pci 0000:00:01.2: enabling Extended Tags
[    0.553369] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
[    0.553441] pci 0000:00:02.0: [1022:1632] type 00 class 0x060000
[    0.553504] pci 0000:00:02.1: [1022:1634] type 01 class 0x060400
[    0.553529] pci 0000:00:02.1: enabling Extended Tags
[    0.553568] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    0.553633] pci 0000:00:02.4: [1022:1634] type 01 class 0x060400
[    0.553658] pci 0000:00:02.4: enabling Extended Tags
[    0.553696] pci 0000:00:02.4: PME# supported from D0 D3hot D3cold
[    0.553765] pci 0000:00:08.0: [1022:1632] type 00 class 0x060000
[    0.553827] pci 0000:00:08.1: [1022:1635] type 01 class 0x060400
[    0.553851] pci 0000:00:08.1: enabling Extended Tags
[    0.553882] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    0.553949] pci 0000:00:08.2: [1022:1635] type 01 class 0x060400
[    0.553974] pci 0000:00:08.2: enabling Extended Tags
[    0.554006] pci 0000:00:08.2: PME# supported from D0 D3hot D3cold
[    0.554087] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
[    0.554200] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
[    0.554323] pci 0000:00:18.0: [1022:1448] type 00 class 0x060000
[    0.554366] pci 0000:00:18.1: [1022:1449] type 00 class 0x060000
[    0.554410] pci 0000:00:18.2: [1022:144a] type 00 class 0x060000
[    0.554454] pci 0000:00:18.3: [1022:144b] type 00 class 0x060000
[    0.554496] pci 0000:00:18.4: [1022:144c] type 00 class 0x060000
[    0.554540] pci 0000:00:18.5: [1022:144d] type 00 class 0x060000
[    0.554584] pci 0000:00:18.6: [1022:144e] type 00 class 0x060000
[    0.554627] pci 0000:00:18.7: [1022:144f] type 00 class 0x060000
[    0.554724] pci 0000:01:00.0: [10de:1f95] type 00 class 0x030000
[    0.554737] pci 0000:01:00.0: reg 0x10: [mem 0xfb000000-0xfbffffff]
[    0.554748] pci 0000:01:00.0: reg 0x14: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.554760] pci 0000:01:00.0: reg 0x1c: [mem 0xc0000000-0xc1ffffff 64bit pref]
[    0.554767] pci 0000:01:00.0: reg 0x24: [io  0xf000-0xf07f]
[    0.554775] pci 0000:01:00.0: reg 0x30: [mem 0xfc000000-0xfc07ffff pref]
[    0.554834] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.554882] pci 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x8 link at 0000:00:01.1 (capable of 126.016 Gb/s with 8.0 GT/s PCIe x16 link)
[    0.555205] pci 0000:01:00.1: [10de:10fa] type 00 class 0x040300
[    0.555219] pci 0000:01:00.1: reg 0x10: [mem 0xfc080000-0xfc083fff]
[    0.555355] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.555360] pci 0000:00:01.1:   bridge window [io  0xf000-0xffff]
[    0.555364] pci 0000:00:01.1:   bridge window [mem 0xfb000000-0xfc0fffff]
[    0.555369] pci 0000:00:01.1:   bridge window [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.555417] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.555433] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.555453] pci 0000:02:00.0: reg 0x18: [mem 0xfc904000-0xfc904fff 64bit]
[    0.555466] pci 0000:02:00.0: reg 0x20: [mem 0xfc900000-0xfc903fff 64bit]
[    0.555555] pci 0000:02:00.0: supports D1 D2
[    0.555558] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.555678] pci 0000:00:01.2: PCI bridge to [bus 02]
[    0.555683] pci 0000:00:01.2:   bridge window [io  0xe000-0xefff]
[    0.555686] pci 0000:00:01.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.555738] pci 0000:03:00.0: [10ec:c822] type 00 class 0x028000
[    0.555759] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.555784] pci 0000:03:00.0: reg 0x18: [mem 0xfc800000-0xfc80ffff 64bit]
[    0.555903] pci 0000:03:00.0: supports D1 D2
[    0.555905] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.556031] pci 0000:00:02.1: PCI bridge to [bus 03]
[    0.556036] pci 0000:00:02.1:   bridge window [io  0xd000-0xdfff]
[    0.556039] pci 0000:00:02.1:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.556084] pci 0000:04:00.0: [1c5c:1339] type 00 class 0x010802
[    0.556104] pci 0000:04:00.0: reg 0x10: [mem 0xfc700000-0xfc703fff 64bit]
[    0.556217] pci 0000:04:00.0: supports D1
[    0.556220] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.556276] pci 0000:04:00.0: 16.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x4 link at 0000:00:02.4 (capable of 31.504 Gb/s with 8.0 GT/s PCIe x4 link)
[    0.556335] pci 0000:00:02.4: PCI bridge to [bus 04]
[    0.556341] pci 0000:00:02.4:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.556387] pci 0000:05:00.0: [1002:1636] type 00 class 0x030000
[    0.556400] pci 0000:05:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.556411] pci 0000:05:00.0: reg 0x18: [mem 0xe0000000-0xe01fffff 64bit pref]
[    0.556418] pci 0000:05:00.0: reg 0x20: [io  0xc000-0xc0ff]
[    0.556425] pci 0000:05:00.0: reg 0x24: [mem 0xfc500000-0xfc57ffff]
[    0.556436] pci 0000:05:00.0: enabling Extended Tags
[    0.556484] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.556508] pci 0000:05:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:08.1 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    0.556562] pci 0000:05:00.2: [1022:15df] type 00 class 0x108000
[    0.556578] pci 0000:05:00.2: reg 0x18: [mem 0xfc400000-0xfc4fffff]
[    0.556589] pci 0000:05:00.2: reg 0x24: [mem 0xfc5c8000-0xfc5c9fff]
[    0.556599] pci 0000:05:00.2: enabling Extended Tags
[    0.556678] pci 0000:05:00.3: [1022:1639] type 00 class 0x0c0330
[    0.556691] pci 0000:05:00.3: reg 0x10: [mem 0xfc300000-0xfc3fffff 64bit]
[    0.556717] pci 0000:05:00.3: enabling Extended Tags
[    0.556749] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
[    0.556804] pci 0000:05:00.4: [1022:1639] type 00 class 0x0c0330
[    0.556817] pci 0000:05:00.4: reg 0x10: [mem 0xfc200000-0xfc2fffff 64bit]
[    0.556844] pci 0000:05:00.4: enabling Extended Tags
[    0.556876] pci 0000:05:00.4: PME# supported from D0 D3hot D3cold
[    0.556930] pci 0000:05:00.5: [1022:15e2] type 00 class 0x048000
[    0.556940] pci 0000:05:00.5: reg 0x10: [mem 0xfc580000-0xfc5bffff]
[    0.556964] pci 0000:05:00.5: enabling Extended Tags
[    0.556994] pci 0000:05:00.5: PME# supported from D0 D3hot D3cold
[    0.557048] pci 0000:05:00.6: [1022:15e3] type 00 class 0x040300
[    0.557057] pci 0000:05:00.6: reg 0x10: [mem 0xfc5c0000-0xfc5c7fff]
[    0.557081] pci 0000:05:00.6: enabling Extended Tags
[    0.557111] pci 0000:05:00.6: PME# supported from D0 D3hot D3cold
[    0.557174] pci 0000:00:08.1: PCI bridge to [bus 05]
[    0.557178] pci 0000:00:08.1:   bridge window [io  0xc000-0xcfff]
[    0.557182] pci 0000:00:08.1:   bridge window [mem 0xfc200000-0xfc5fffff]
[    0.557187] pci 0000:00:08.1:   bridge window [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.557222] pci 0000:06:00.0: [1022:7901] type 00 class 0x010601
[    0.557253] pci 0000:06:00.0: reg 0x24: [mem 0xfc601000-0xfc6017ff]
[    0.557265] pci 0000:06:00.0: enabling Extended Tags
[    0.557324] pci 0000:06:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:08.2 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    0.557371] pci 0000:06:00.1: [1022:7901] type 00 class 0x010601
[    0.557402] pci 0000:06:00.1: reg 0x24: [mem 0xfc600000-0xfc6007ff]
[    0.557412] pci 0000:06:00.1: enabling Extended Tags
[    0.557495] pci 0000:00:08.2: PCI bridge to [bus 06]
[    0.557500] pci 0000:00:08.2:   bridge window [mem 0xfc600000-0xfc6fffff]
[    0.557527] pci_bus 0000:00: on NUMA node 0
[    0.558024] ACPI: PCI: Interrupt link LNKA configured for IRQ 0
[    0.558067] ACPI: PCI: Interrupt link LNKB configured for IRQ 0
[    0.558103] ACPI: PCI: Interrupt link LNKC configured for IRQ 0
[    0.558147] ACPI: PCI: Interrupt link LNKD configured for IRQ 0
[    0.558187] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[    0.558221] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[    0.558254] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[    0.558292] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[    0.559258] ACPI: EC: interrupt unblocked
[    0.559261] ACPI: EC: event unblocked
[    0.559266] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.559268] ACPI: EC: GPE=0x3
[    0.559270] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC initialization complete
[    0.559274] ACPI: \_SB_.PCI0.SBRG.EC0_: EC: Used to handle transactions and events
[    0.559326] iommu: Default domain type: Translated 
[    0.559326] iommu: DMA domain TLB invalidation policy: lazy mode 
[    0.559326] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    0.559326] pci 0000:05:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    0.559326] pci 0000:01:00.0: vgaarb: bridge control possible
[    0.559326] pci 0000:05:00.0: vgaarb: bridge control possible
[    0.559326] pci 0000:05:00.0: vgaarb: setting as boot device
[    0.559326] vgaarb: loaded
[    0.559367] SCSI subsystem initialized
[    0.559374] libata version 3.00 loaded.
[    0.559386] ACPI: bus type USB registered
[    0.559397] usbcore: registered new interface driver usbfs
[    0.559404] usbcore: registered new interface driver hub
[    0.559412] usbcore: registered new device driver usb
[    0.561269] mc: Linux media interface: v0.10
[    0.561277] videodev: Linux video capture interface: v2.00
[    0.561321] Registered efivars operations
[    0.561338] Advanced Linux Sound Architecture Driver Initialized.
[    0.561372] Bluetooth: Core ver 2.22
[    0.561378] NET: Registered PF_BLUETOOTH protocol family
[    0.561381] Bluetooth: HCI device and connection manager initialized
[    0.561384] Bluetooth: HCI socket layer initialized
[    0.561387] Bluetooth: L2CAP socket layer initialized
[    0.561390] Bluetooth: SCO socket layer initialized
[    0.561407] PCI: Using ACPI for IRQ routing
[    0.565938] PCI: pci_cache_line_size set to 64 bytes
[    0.566026] Expanded resource Reserved due to conflict with PCI Bus 0000:00
[    0.566030] e820: reserve RAM buffer [mem 0x09ed0000-0x0bffffff]
[    0.566032] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
[    0.566033] e820: reserve RAM buffer [mem 0xa4177018-0xa7ffffff]
[    0.566035] e820: reserve RAM buffer [mem 0xa423a018-0xa7ffffff]
[    0.566036] e820: reserve RAM buffer [mem 0xa47b1000-0xa7ffffff]
[    0.566037] e820: reserve RAM buffer [mem 0xa6621000-0xa7ffffff]
[    0.566038] e820: reserve RAM buffer [mem 0xa7384000-0xa7ffffff]
[    0.566039] e820: reserve RAM buffer [mem 0xae000000-0xafffffff]
[    0.566040] e820: reserve RAM buffer [mem 0x42f340000-0x42fffffff]
[    0.566256] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.566262] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.568554] clocksource: Switched to clocksource tsc-early
[    0.575537] pnp: PnP ACPI init
[    0.575659] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.575954] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.575959] system 00:03: [io  0x040b] has been reserved
[    0.575962] system 00:03: [io  0x04d6] has been reserved
[    0.575967] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    0.575970] system 00:03: [io  0x0c14] has been reserved
[    0.575973] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    0.575976] system 00:03: [io  0x0c52] has been reserved
[    0.575979] system 00:03: [io  0x0c6c] has been reserved
[    0.575981] system 00:03: [io  0x0c6f] has been reserved
[    0.575984] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    0.575987] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    0.575990] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    0.575993] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    0.575995] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    0.575998] system 00:03: [io  0x0800-0x089f] has been reserved
[    0.576001] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    0.576004] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    0.576007] system 00:03: [io  0x0900-0x090f] has been reserved
[    0.576009] system 00:03: [io  0x0910-0x091f] has been reserved
[    0.576013] system 00:03: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.576016] system 00:03: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.576020] system 00:03: [mem 0xfedc0000-0xfedc0fff] has been reserved
[    0.576023] system 00:03: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.576026] system 00:03: [mem 0xfed80000-0xfed8ffff] could not be reserved
[    0.576029] system 00:03: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.576032] system 00:03: [mem 0xff000000-0xffffffff] has been reserved
[    0.576680] pnp: PnP ACPI: found 4 devices
[    0.582529] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.582588] NET: Registered PF_INET protocol family
[    0.582822] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.585453] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes, linear)
[    0.585489] TCP established hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.585786] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes, linear)
[    0.585993] TCP: Hash tables configured (established 131072 bind 65536)
[    0.586037] UDP hash table entries: 8192 (order: 6, 262144 bytes, linear)
[    0.586080] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes, linear)
[    0.586146] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.586379] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.586387] pci 0000:00:01.1:   bridge window [io  0xf000-0xffff]
[    0.586393] pci 0000:00:01.1:   bridge window [mem 0xfb000000-0xfc0fffff]
[    0.586397] pci 0000:00:01.1:   bridge window [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.586404] pci 0000:00:01.2: PCI bridge to [bus 02]
[    0.586407] pci 0000:00:01.2:   bridge window [io  0xe000-0xefff]
[    0.586411] pci 0000:00:01.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.586418] pci 0000:00:02.1: PCI bridge to [bus 03]
[    0.586421] pci 0000:00:02.1:   bridge window [io  0xd000-0xdfff]
[    0.586425] pci 0000:00:02.1:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.586431] pci 0000:00:02.4: PCI bridge to [bus 04]
[    0.586435] pci 0000:00:02.4:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.586443] pci 0000:00:08.1: PCI bridge to [bus 05]
[    0.586446] pci 0000:00:08.1:   bridge window [io  0xc000-0xcfff]
[    0.586450] pci 0000:00:08.1:   bridge window [mem 0xfc200000-0xfc5fffff]
[    0.586454] pci 0000:00:08.1:   bridge window [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.586460] pci 0000:00:08.2: PCI bridge to [bus 06]
[    0.586464] pci 0000:00:08.2:   bridge window [mem 0xfc600000-0xfc6fffff]
[    0.586471] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.586474] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.586477] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.586480] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.586483] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
[    0.586486] pci_bus 0000:00: resource 9 [mem 0xb0000000-0xfebfffff window]
[    0.586489] pci_bus 0000:00: resource 10 [mem 0xfee00000-0xffffffff window]
[    0.586493] pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
[    0.586496] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfc0fffff]
[    0.586499] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.586502] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.586505] pci_bus 0000:02: resource 1 [mem 0xfc900000-0xfc9fffff]
[    0.586508] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.586511] pci_bus 0000:03: resource 1 [mem 0xfc800000-0xfc8fffff]
[    0.586514] pci_bus 0000:04: resource 1 [mem 0xfc700000-0xfc7fffff]
[    0.586516] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.586519] pci_bus 0000:05: resource 1 [mem 0xfc200000-0xfc5fffff]
[    0.586522] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.586525] pci_bus 0000:06: resource 1 [mem 0xfc600000-0xfc6fffff]
[    0.586645] pci 0000:01:00.1: D0 power state depends on 0000:01:00.0
[    0.586693] pci 0000:05:00.3: extending delay after power-on from D3hot to 20 msec
[    0.586843] pci 0000:05:00.4: extending delay after power-on from D3hot to 20 msec
[    0.586907] PCI: CLS 64 bytes, default 64
[    0.586919] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    0.586955] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.586959] pci 0000:00:00.2: PCI INT A: not connected
[    0.586991] pci 0000:00:01.0: Adding to iommu group 0
[    0.587002] pci 0000:00:01.1: Adding to iommu group 1
[    0.587012] pci 0000:00:01.2: Adding to iommu group 2
[    0.587026] pci 0000:00:02.0: Adding to iommu group 3
[    0.587036] pci 0000:00:02.1: Adding to iommu group 4
[    0.587046] pci 0000:00:02.4: Adding to iommu group 5
[    0.587063] pci 0000:00:08.0: Adding to iommu group 6
[    0.587072] pci 0000:00:08.1: Adding to iommu group 6
[    0.587080] pci 0000:00:08.2: Adding to iommu group 6
[    0.587095] pci 0000:00:14.0: Adding to iommu group 7
[    0.587103] pci 0000:00:14.3: Adding to iommu group 7
[    0.587136] pci 0000:00:18.0: Adding to iommu group 8
[    0.587145] pci 0000:00:18.1: Adding to iommu group 8
[    0.587154] pci 0000:00:18.2: Adding to iommu group 8
[    0.587163] pci 0000:00:18.3: Adding to iommu group 8
[    0.587172] pci 0000:00:18.4: Adding to iommu group 8
[    0.587182] pci 0000:00:18.5: Adding to iommu group 8
[    0.587191] pci 0000:00:18.6: Adding to iommu group 8
[    0.587201] pci 0000:00:18.7: Adding to iommu group 8
[    0.587216] pci 0000:01:00.0: Adding to iommu group 9
[    0.587226] pci 0000:01:00.1: Adding to iommu group 9
[    0.587235] pci 0000:02:00.0: Adding to iommu group 10
[    0.587245] pci 0000:03:00.0: Adding to iommu group 11
[    0.587256] pci 0000:04:00.0: Adding to iommu group 12
[    0.587265] pci 0000:05:00.0: Adding to iommu group 6
[    0.587271] pci 0000:05:00.2: Adding to iommu group 6
[    0.587276] pci 0000:05:00.3: Adding to iommu group 6
[    0.587280] pci 0000:05:00.4: Adding to iommu group 6
[    0.587285] pci 0000:05:00.5: Adding to iommu group 6
[    0.587291] pci 0000:05:00.6: Adding to iommu group 6
[    0.587299] pci 0000:06:00.0: Adding to iommu group 6
[    0.587304] pci 0000:06:00.1: Adding to iommu group 6
[    0.588784] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.588791] AMD-Vi: Extended features (0x206d73ef22254ade): PPR X2APIC NX GT IA GA PC GA_vAPIC
[    0.588800] AMD-Vi: Interrupt remapping enabled
[    0.588802] AMD-Vi: Virtual APIC enabled
[    0.588804] AMD-Vi: X2APIC enabled
[    0.588893] software IO TLB: tearing down default memory pool
[    0.589921] RAPL PMU: API unit is 2^-32 Joules, 1 fixed counters, 163840 ms ovfl timer
[    0.589928] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.589932] LVT offset 0 assigned for vector 0x400
[    0.590114] perf: AMD IBS detected (0x000003ff)
[    0.590120] amd_uncore: 4  amd_df counters detected
[    0.590126] amd_uncore: 6  amd_l3 counters detected
[    0.590475] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
[    0.590668] SVM: TSC scaling supported
[    0.590670] kvm: Nested Virtualization enabled
[    0.590672] SVM: kvm: Nested Paging enabled
[    0.590681] SVM: Virtual VMLOAD VMSAVE supported
[    0.590682] SVM: Virtual GIF supported
[    0.590684] SVM: LBR virtualization supported
[    0.597633] Initialise system trusted keyrings
[    0.597682] workingset: timestamp_bits=46 max_order=22 bucket_order=0
[    0.599000] fuse: init (API version 7.36)
[    0.599071] SGI XFS with ACLs, security attributes, scrub, repair, no debug enabled
[    0.603595] NET: Registered PF_ALG protocol family
[    0.603599] Key type asymmetric registered
[    0.603602] Asymmetric key parser 'x509' registered
[    0.603612] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    0.603681] io scheduler mq-deadline registered
[    0.603686] io scheduler kyber registered
[    0.603697] io scheduler bfq registered
[    0.606156] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.659060] ACPI: AC: AC Adapter [ACAD] (off-line)
[    0.659137] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.659168] ACPI: button: Power Button [PWRB]
[    0.659214] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.659238] ACPI: button: Lid Switch [LID]
[    0.659276] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.659398] ACPI: button: Power Button [PWRF]
[    0.659487] ACPI: video: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    0.659798] acpi device:08: registered as cooling_device0
[    0.659844] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:07/LNXVIDEO:00/input/input3
[    0.660017] Monitor-Mwait will be used to enter C-1 state
[    0.660024] ACPI: \_SB_.PLTF.P000: Found 3 idle states
[    0.660035] ACPI: FW issue: working around C-state latencies out of order
[    0.660159] ACPI: \_SB_.PLTF.P001: Found 3 idle states
[    0.660168] ACPI: FW issue: working around C-state latencies out of order
[    0.660426] ACPI: \_SB_.PLTF.P002: Found 3 idle states
[    0.660435] ACPI: FW issue: working around C-state latencies out of order
[    0.660639] ACPI: \_SB_.PLTF.P003: Found 3 idle states
[    0.660648] ACPI: FW issue: working around C-state latencies out of order
[    0.660858] ACPI: \_SB_.PLTF.P004: Found 3 idle states
[    0.660867] ACPI: FW issue: working around C-state latencies out of order
[    0.661087] ACPI: \_SB_.PLTF.P005: Found 3 idle states
[    0.661097] ACPI: FW issue: working around C-state latencies out of order
[    0.661287] ACPI: \_SB_.PLTF.P006: Found 3 idle states
[    0.661296] ACPI: FW issue: working around C-state latencies out of order
[    0.661461] ACPI: \_SB_.PLTF.P007: Found 3 idle states
[    0.661470] ACPI: FW issue: working around C-state latencies out of order
[    0.661585] ACPI: \_SB_.PLTF.P008: Found 3 idle states
[    0.661593] ACPI: FW issue: working around C-state latencies out of order
[    0.661761] ACPI: \_SB_.PLTF.P009: Found 3 idle states
[    0.661770] ACPI: FW issue: working around C-state latencies out of order
[    0.661934] ACPI: \_SB_.PLTF.P00A: Found 3 idle states
[    0.661943] ACPI: FW issue: working around C-state latencies out of order
[    0.662104] ACPI: \_SB_.PLTF.P00B: Found 3 idle states
[    0.662110] ACPI: FW issue: working around C-state latencies out of order
[    0.663081] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - \_PR_.P000 (20211217/dspkginit-438)
[    0.663092] ACPI: \_TZ_.THRM: Invalid passive threshold
[    0.663810] thermal LNXTHERM:00: registered as thermal_zone0
[    0.663814] ACPI: thermal: Thermal Zone [THRM] (42 C)
[    0.664809] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.665096] Non-volatile memory driver v1.3
[    0.665117] Linux agpgart interface v0.103
[    1.183878] AMD-Vi: AMD IOMMUv2 loaded and initialized
[    1.183968] ACPI: bus type drm_connector registered
[    1.183987] [drm] amdgpu kernel modesetting enabled.
[    1.184000] amdgpu: vga_switcheroo: detected switching method \_SB_.PCI0.GP17.VGA_.ATPX handle
[    1.185323] ACPI: battery: Slot [BAT0] (battery present)
[    1.185404] ATPX version 1, functions 0x00000200
[    1.187139] amdgpu: Virtual CRAT table created for CPU
[    1.187149] amdgpu: Topology: Add CPU node
[    1.187199] amdgpu 0000:05:00.0: vgaarb: deactivate vga console
[    1.187235] amdgpu 0000:05:00.0: enabling device (0006 -> 0007)
[    1.187280] [drm] initializing kernel modesetting (RENOIR 0x1002:0x1636 0x103C:0x87B2 0xC7).
[    1.187285] amdgpu 0000:05:00.0: amdgpu: Trusted Memory Zone (TMZ) feature enabled
[    1.279127] [drm] register mmio base: 0xFC500000
[    1.279138] [drm] register mmio size: 524288
[    1.280285] [drm] add ip block number 0 <soc15_common>
[    1.280291] [drm] add ip block number 1 <gmc_v9_0>
[    1.280295] [drm] add ip block number 2 <vega10_ih>
[    1.280299] [drm] add ip block number 3 <psp>
[    1.280302] [drm] add ip block number 4 <smu>
[    1.280306] [drm] add ip block number 5 <dm>
[    1.280309] [drm] add ip block number 6 <gfx_v9_0>
[    1.280313] [drm] add ip block number 7 <sdma_v4_0>
[    1.280317] [drm] add ip block number 8 <vcn_v2_0>
[    1.280321] [drm] add ip block number 9 <jpeg_v2_0>
[    1.280339] amdgpu 0000:05:00.0: amdgpu: Fetched VBIOS from VFCT
[    1.280345] amdgpu: ATOM BIOS: 113-RENOIR-031
[    1.280360] [drm] VCN decode is enabled in VM mode
[    1.280364] [drm] VCN encode is enabled in VM mode
[    1.280369] [drm] JPEG decode is enabled in VM mode
[    1.280375] amdgpu 0000:05:00.0: amdgpu: PCIE atomic ops is not supported
[    1.280417] [drm] vm size is 262144 GB, 4 levels, block size is 9-bit, fragment size is 9-bit
[    1.280428] amdgpu 0000:05:00.0: amdgpu: VRAM: 512M 0x000000F400000000 - 0x000000F41FFFFFFF (512M used)
[    1.280437] amdgpu 0000:05:00.0: amdgpu: GART: 1024M 0x0000000000000000 - 0x000000003FFFFFFF
[    1.280444] amdgpu 0000:05:00.0: amdgpu: AGP: 267419648M 0x000000F800000000 - 0x0000FFFFFFFFFFFF
[    1.280457] [drm] Detected VRAM RAM=512M, BAR=512M
[    1.280461] [drm] RAM width 128bits DDR4
[    1.280525] [drm] amdgpu: 512M of VRAM memory ready
[    1.280530] [drm] amdgpu: 3072M of GTT memory ready.
[    1.280539] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    1.280681] [drm] PCIE GART of 1024M enabled.
[    1.280686] [drm] PTB located at 0x000000F400900000
[    1.280810] amdgpu 0000:05:00.0: amdgpu: PSP runtime database doesn't exist
[    1.280824] [drm] Loading DMUB firmware via PSP: version=0x0101001F
[    1.281998] [drm] Found VCN firmware Version ENC: 1.17 DEC: 5 VEP: 0 Revision: 2
[    1.282006] amdgpu 0000:05:00.0: amdgpu: Will use PSP to load VCN firmware
[    1.588380] clocksource: timekeeping watchdog on CPU1: Marking clocksource 'tsc-early' as unstable because the skew is too large:
[    1.588388] clocksource:                       'hpet' wd_nsec: 496765091 wd_now: e04992 wd_last: 73c14e mask: ffffffff
[    1.588393] clocksource:                       'tsc-early' cs_nsec: 1000407513 cs_now: 42892e9de cs_last: 37603734c mask: ffffffffffffffff
[    1.588398] clocksource:                       'tsc-early' is current clocksource.
[    1.588401] tsc: Marking TSC unstable due to clocksource watchdog
[    1.588488] clocksource: Switched to clocksource hpet
[    2.030736] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[    2.117377] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[    2.126721] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[    2.126728] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[    2.127954] amdgpu 0000:05:00.0: amdgpu: SMU is initialized successfully!
[    2.128717] [drm] Display Core initialized with v3.2.167!
[    2.129256] [drm] DMUB hardware initialized: version=0x0101001F
[    2.339959] [drm] kiq ring mec 2 pipe 1 q 0
[    2.343175] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[    2.343192] [drm] JPEG decode initialized successfully.
[    2.344486] kfd kfd: amdgpu: Allocated 3969056 bytes on gart
[    2.344620] amdgpu: Virtual CRAT table created for GPU
[    2.345197] amdgpu: Topology: Add dGPU node [0x1636:0x1002]
[    2.345200] kfd kfd: amdgpu: added device 1002:1636
[    2.345336] amdgpu 0000:05:00.0: amdgpu: SE 1, SH per SE 1, CU per SH 8, active_cu_number 6
[    2.345446] amdgpu 0000:05:00.0: amdgpu: ring gfx uses VM inv eng 0 on hub 0
[    2.345450] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[    2.345454] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[    2.345457] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[    2.345460] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[    2.345463] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[    2.345467] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[    2.345470] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[    2.345473] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[    2.345476] amdgpu 0000:05:00.0: amdgpu: ring kiq_2.1.0 uses VM inv eng 11 on hub 0
[    2.345480] amdgpu 0000:05:00.0: amdgpu: ring sdma0 uses VM inv eng 0 on hub 1
[    2.345483] amdgpu 0000:05:00.0: amdgpu: ring vcn_dec uses VM inv eng 1 on hub 1
[    2.345486] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 4 on hub 1
[    2.345490] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 5 on hub 1
[    2.345493] amdgpu 0000:05:00.0: amdgpu: ring jpeg_dec uses VM inv eng 6 on hub 1
[    2.347058] [drm] Initialized amdgpu 3.44.0 20150101 for 0000:05:00.0 on minor 0
[    2.351931] fbcon: amdgpudrmfb (fb0) is primary device
[    2.434442] Console: switching to colour frame buffer device 240x67
[    2.450510] amdgpu 0000:05:00.0: [drm] fb0: amdgpudrmfb frame buffer device
[    2.450662] usbcore: registered new interface driver udl
[    2.453134] brd: module loaded
[    2.454408] loop: module loaded
[    2.454669] nvme 0000:04:00.0: platform quirk: setting simple suspend
[    2.454732] nvme nvme0: pci function 0000:04:00.0
[    2.454797] ahci 0000:06:00.0: version 3.0
[    2.454951] ahci 0000:06:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    2.454994] ahci 0000:06:00.0: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part 
[    2.455204] scsi host0: ahci
[    2.455280] ata1: SATA max UDMA/133 abar m2048@0xfc601000 port 0xfc601100 irq 29
[    2.455495] ahci 0000:06:00.1: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    2.455558] ahci 0000:06:00.1: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part 
[    2.455791] scsi host1: ahci
[    2.455839] ata2: SATA max UDMA/133 abar m2048@0xfc600000 port 0xfc600100 irq 33
[    2.456010] tun: Universal TUN/TAP device driver, 1.6
[    2.456089] r8169 0000:02:00.0: enabling device (0000 -> 0003)
[    2.456170] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.459759] nvme nvme0: missing or invalid SUBNQN field.
[    2.463772] nvme nvme0: 16/0/0 default/read/poll queues
[    2.464349] r8169 0000:02:00.0 eth0: RTL8168h/8111h, 30:24:a9:7d:03:0f, XID 541, IRQ 51
[    2.464437] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[    2.464675] rtw_8822ce 0000:03:00.0: Firmware version 9.9.11, H2C version 15
[    2.464726] rtw_8822ce 0000:03:00.0: Firmware version 9.9.4, H2C version 15
[    2.464796] rtw_8822ce 0000:03:00.0: enabling device (0000 -> 0003)
[    2.466940]  nvme0n1: p1 p2 p3 p4 p5 p6 p7
[    2.484939] usbcore: registered new interface driver cdc_ether
[    2.484977] usbcore: registered new interface driver cdc_eem
[    2.485012] usbcore: registered new interface driver cdc_ncm
[    2.485204] xhci_hcd 0000:05:00.3: xHCI Host Controller
[    2.485311] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 1
[    2.485425] xhci_hcd 0000:05:00.3: hcc params 0x0268ffe5 hci version 0x110 quirks 0x0000020000000410
[    2.485729] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.17
[    2.485770] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.485805] usb usb1: Product: xHCI Host Controller
[    2.485831] usb usb1: Manufacturer: Linux 5.17.3+ xhci-hcd
[    2.485858] usb usb1: SerialNumber: 0000:05:00.3
[    2.487275] hub 1-0:1.0: USB hub found
[    2.488784] hub 1-0:1.0: 4 ports detected
[    2.490506] xhci_hcd 0000:05:00.3: xHCI Host Controller
[    2.492348] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 2
[    2.493556] xhci_hcd 0000:05:00.3: Host supports USB 3.1 Enhanced SuperSpeed
[    2.495129] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    2.496826] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.17
[    2.498010] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.499489] usb usb2: Product: xHCI Host Controller
[    2.502027] usb usb2: Manufacturer: Linux 5.17.3+ xhci-hcd
[    2.503313] usb usb2: SerialNumber: 0000:05:00.3
[    2.505113] hub 2-0:1.0: USB hub found
[    2.507669] hub 2-0:1.0: 2 ports detected
[    2.509129] xhci_hcd 0000:05:00.4: xHCI Host Controller
[    2.510553] xhci_hcd 0000:05:00.4: new USB bus registered, assigned bus number 3
[    2.512549] xhci_hcd 0000:05:00.4: hcc params 0x0268ffe5 hci version 0x110 quirks 0x0000020000000410
[    2.514850] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.17
[    2.516007] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.517540] usb usb3: Product: xHCI Host Controller
[    2.518777] usb usb3: Manufacturer: Linux 5.17.3+ xhci-hcd
[    2.520091] usb usb3: SerialNumber: 0000:05:00.4
[    2.521497] hub 3-0:1.0: USB hub found
[    2.523088] hub 3-0:1.0: 4 ports detected
[    2.524408] xhci_hcd 0000:05:00.4: xHCI Host Controller
[    2.526042] xhci_hcd 0000:05:00.4: new USB bus registered, assigned bus number 4
[    2.527128] xhci_hcd 0000:05:00.4: Host supports USB 3.1 Enhanced SuperSpeed
[    2.528632] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    2.529843] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.17
[    2.531140] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.532403] usb usb4: Product: xHCI Host Controller
[    2.533682] usb usb4: Manufacturer: Linux 5.17.3+ xhci-hcd
[    2.534952] usb usb4: SerialNumber: 0000:05:00.4
[    2.536349] hub 4-0:1.0: USB hub found
[    2.537551] hub 4-0:1.0: 2 ports detected
[    2.539002] usb: port power management may be unreliable
[    2.540151] usbcore: registered new interface driver usblp
[    2.541558] usbcore: registered new interface driver cdc_wdm
[    2.543300] usbcore: registered new interface driver uas
[    2.544335] usbcore: registered new interface driver usb-storage
[    2.545711] usbcore: registered new interface driver emi26 - firmware loader
[    2.546808] usbcore: registered new interface driver emi62 - firmware loader
[    2.548887] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.550023] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.552434] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.554120] mousedev: PS/2 mouse device common for all mice
[    2.555511] rtc_cmos 00:01: RTC can wake from S4
[    2.556899] rtc_cmos 00:01: registered as rtc0
[    2.557857] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.559192] i2c_dev: i2c /dev entries driver
[    2.560618] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    2.562309] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus port selection
[    2.564143] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    2.565974] usbcore: registered new interface driver uvcvideo
[    2.567637] usbcore: registered new interface driver btusb
[    2.568910] EFI Variables Facility v0.08 2004-May-17
[    2.578198] pstore: Registered efi as persistent store backend
[    2.579410] ccp 0000:05:00.2: enabling device (0000 -> 0002)
[    2.591220] ccp 0000:05:00.2: tee enabled
[    2.592890] ccp 0000:05:00.2: psp enabled
[    2.594443] hid: raw HID events driver (C) Jiri Kosina
[    2.595537] usbcore: registered new interface driver usbhid
[    2.597254] usbhid: USB HID core driver
[    2.598995] hp_accel: laptop model unknown, using default axes configuration
[    2.632040] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.632123] lis3lv02d: 8 bits 3DC sensor found
[    2.643565] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input5
[    2.646182] ACPI BIOS Error (bug): Attempt to CreateField of length zero (20211217/dsopcode-133)
[    2.647234] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_OPERAND_VALUE) (20211217/psparse-529)
[    2.648622] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_OPERAND_VALUE) (20211217/psparse-529)
[    2.650265] input: HP WMI hotkeys as /devices/virtual/input/input6
[    2.652009] ACPI BIOS Error (bug): Attempt to CreateField of length zero (20211217/dsopcode-133)
[    2.653101] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_OPERAND_VALUE) (20211217/psparse-529)
[    2.654575] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_OPERAND_VALUE) (20211217/psparse-529)
[    2.657913] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    2.659131] snd_hda_intel 0000:01:00.1: Disabling MSI
[    2.660600] snd_hda_intel 0000:01:00.1: Handle vga_switcheroo audio client
[    2.662598] snd_hda_intel 0000:05:00.6: enabling device (0000 -> 0002)
[    2.664050] usbcore: registered new interface driver snd-usb-audio
[    2.664342] random: fast init done
[    2.665148] NET: Registered PF_LLC protocol family
[    2.668828] Initializing XFRM netlink socket
[    2.670391] NET: Registered PF_INET6 protocol family
[    2.672578] Segment Routing with IPv6
[    2.674939] In-situ OAM (IOAM) with IPv6
[    2.676345] mip6: Mobile IPv6
[    2.677697] NET: Registered PF_PACKET protocol family
[    2.679008] NET: Registered PF_KEY protocol family
[    2.680342] Bluetooth: RFCOMM TTY layer initialized
[    2.681826] Bluetooth: RFCOMM socket layer initialized
[    2.682914] Bluetooth: RFCOMM ver 1.11
[    2.684400] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.685905] Bluetooth: BNEP filters: protocol multicast
[    2.686965] Bluetooth: BNEP socket layer initialized
[    2.688424] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.689906] Bluetooth: HIDP socket layer initialized
[    2.690466] input: ELAN0718:00 04F3:30FD Mouse as /devices/platform/AMDI0010:03/i2c-0/i2c-ELAN0718:00/0018:04F3:30FD.0001/input/input7
[    2.690978] l2tp_core: L2TP core driver, V2.0
[    2.693103] input: ELAN0718:00 04F3:30FD Touchpad as /devices/platform/AMDI0010:03/i2c-0/i2c-ELAN0718:00/0018:04F3:30FD.0001/input/input9
[    2.693495] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input10
[    2.693548] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input11
[    2.693601] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input12
[    2.693643] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input13
[    2.694196] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    2.694205] l2tp_netlink: L2TP netlink interface
[    2.695679] hid-multitouch 0018:04F3:30FD.0001: input,hidraw0: I2C HID v1.00 Mouse [ELAN0718:00 04F3:30FD] on i2c-ELAN0718:00
[    2.695847] snd_hda_codec_realtek hdaudioC2D0: autoconfig for ALC285: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    2.695851] snd_hda_codec_realtek hdaudioC2D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.695854] snd_hda_codec_realtek hdaudioC2D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    2.695857] snd_hda_codec_realtek hdaudioC2D0:    mono: mono_out=0x0
[    2.695858] snd_hda_codec_realtek hdaudioC2D0:    inputs:
[    2.695860] snd_hda_codec_realtek hdaudioC2D0:      Mic=0x19
[    2.695861] snd_hda_codec_realtek hdaudioC2D0:      Internal Mic=0x12
[    2.696938] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    2.712831] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[    2.714428] 8021q: 802.1Q VLAN Support v1.8
[    2.717183] NET: Registered PF_RDS protocol family
[    2.718644] Registered RDS/tcp transport
[    2.721411] microcode: CPU0: patch_level=0x08600106
[    2.723286] microcode: CPU1: patch_level=0x08600106
[    2.724913] microcode: CPU2: patch_level=0x08600106
[    2.726791] microcode: CPU3: patch_level=0x08600106
[    2.728463] microcode: CPU4: patch_level=0x08600106
[    2.730300] microcode: CPU5: patch_level=0x08600106
[    2.731777] microcode: CPU6: patch_level=0x08600106
[    2.732955] microcode: CPU7: patch_level=0x08600106
[    2.733289] usb 1-4: new full-speed USB device number 2 using xhci_hcd
[    2.734219] microcode: CPU8: patch_level=0x08600106
[    2.737173] microcode: CPU9: patch_level=0x08600106
[    2.738149] microcode: CPU10: patch_level=0x08600106
[    2.739752] microcode: CPU11: patch_level=0x08600106
[    2.740925] microcode: Microcode Update Driver: v2.2.
[    2.740930] IPI shorthand broadcast: enabled
[    2.743296] AVX2 version of gcm_enc/dec engaged.
[    2.744733] AES CTR mode by8 optimization enabled
[    2.746187] registered taskstats version 1
[    2.747310] Loading compiled-in X.509 certificates
[    2.748603] Key type ._fscrypt registered
[    2.749934] Key type .fscrypt registered
[    2.751291] Key type fscrypt-provisioning registered
[    2.765095] ata1: SATA link down (SStatus 0 SControl 300)
[    2.765293] usb 3-3: new high-speed USB device number 2 using xhci_hcd
[    2.884317] usb 1-4: New USB device found, idVendor=0bda, idProduct=b00c, bcdDevice= 0.00
[    2.885798] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.887132] usb 1-4: Product: Bluetooth Radio
[    2.887961] usb 1-4: Manufacturer: Realtek
[    2.888787] usb 1-4: SerialNumber: 00e04c000001
[    2.902405] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[    2.905350] Bluetooth: hci0: RTL: rom_version status=0 version=3
[    2.906240] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[    2.907104] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[    2.907971] bluetooth hci0: Direct firmware load for rtl_bt/rtl8822cu_config.bin failed with error -2
[    2.908855] Bluetooth: hci0: RTL: cfg_sz -2, total sz 35080
[    2.915705] usb 3-3: New USB device found, idVendor=30c9, idProduct=0013, bcdDevice= 0.01
[    2.917293] usb 3-3: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.918512] usb 3-3: Product: HP TrueVision HD Camera
[    2.919414] usb 3-3: Manufacturer: DJKCVA19IECCI0
[    2.920313] usb 3-3: SerialNumber: 0001
[    2.923290] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.925974] ata2.00: ATA-9: SanDisk Ultra II 960GB, X41100RL, max UDMA/133
[    2.927546] ata2.00: 1875385008 sectors, multi 1: LBA48 NCQ (depth 32), AA
[    2.930135] ata2.00: configured for UDMA/133
[    2.930827] usb 3-3: Found UVC 1.00 device HP TrueVision HD Camera (30c9:0013)
[    2.931145] scsi 1:0:0:0: Direct-Access     ATA      SanDisk Ultra II 00RL PQ: 0 ANSI: 5
[    2.934059] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.934195] sd 1:0:0:0: [sda] 1875385008 512-byte logical blocks: (960 GB/894 GiB)
[    2.936770] sd 1:0:0:0: [sda] Write Protect is off
[    2.938098] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.938343] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.940350]  sda: sda1 sda2 sda3
[    2.941714] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.944078] input: HP TrueVision HD Camera: HP Tru as /devices/pci0000:00/0000:00:08.1/0000:05:00.4/usb3/3-3/3-3:1.0/input/input14
[    3.115456] acpi_cpufreq: overriding BIOS provided _PSD data
[    3.117327] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    3.149780] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    3.151464] Unstable clock detected, switching default tracing clock to "global"
               If you want to keep using the local clock, then add:
                 "trace_clock=local"
               on the kernel command line
[    3.159316] ALSA device list:
[    3.161680]   #0: Loopback 1
[    3.163002]   #1: HDA NVidia at 0xfc080000 irq 74
[    3.216606] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[    3.354924] input: HD-Audio Generic Mic as /devices/pci0000:00/0000:00:08.1/0000:05:00.6/sound/card2/input15
[    3.357088] input: HD-Audio Generic Headphone as /devices/pci0000:00/0000:00:08.1/0000:05:00.6/sound/card2/input16
[    3.360289] EXT4-fs (nvme0n1p4): mounted filesystem with ordered data mode. Quota mode: disabled.
[    3.361997] VFS: Mounted root (ext4 filesystem) readonly on device 259:4.
[    3.364135] devtmpfs: mounted
[    3.365974] Freeing unused decrypted memory: 2044K
[    3.367918] Freeing unused kernel image (initmem) memory: 1252K
[    3.376352] Write protecting the kernel read-only data: 30720k
[    3.379649] Freeing unused kernel image (text/rodata gap) memory: 2028K
[    3.381352] Freeing unused kernel image (rodata/data gap) memory: 308K
[    3.383593] Run /sbin/init as init process
[    3.384826]   with arguments:
[    3.384827]     /sbin/init
[    3.384828]   with environment:
[    3.384828]     HOME=/
[    3.384829]     TERM=linux
[    3.504934] random: udevd: uninitialized urandom read (16 bytes read)
[    3.506735] random: udevd: uninitialized urandom read (16 bytes read)
[    3.509046] random: udevd: uninitialized urandom read (16 bytes read)
[    3.529630] udevd[323]: starting eudev-3.2.11
[    4.177776] Adding 1048572k swap on /dev/nvme0n1p3.  Priority:-2 extents:1 across:1048572k SS
[    5.198145] EXT4-fs (nvme0n1p4): re-mounted. Quota mode: disabled.
[    5.261212] FAT-fs (nvme0n1p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    5.292901] EXT4-fs (sda3): mounted filesystem with ordered data mode. Quota mode: disabled.
[    6.532567] random: crng init done
[    6.532571] random: 7 urandom warning(s) missed due to ratelimiting
[   14.436159] wlan0: authenticate with 24:4b:fe:be:28:28
[   14.436176] wlan0: bad VHT capabilities, disabling VHT
[   14.819206] wlan0: send auth to 24:4b:fe:be:28:28 (try 1/3)
[   14.822544] wlan0: authenticated
[   14.824314] wlan0: associate with 24:4b:fe:be:28:28 (try 1/3)
[   14.829084] wlan0: RX AssocResp from 24:4b:fe:be:28:28 (capab=0x1411 status=0 aid=5)
[   14.829402] wlan0: associated
[   14.848563] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   15.827844] wlan0: deauthenticating from 24:4b:fe:be:28:28 by local choice (Reason: 3=DEAUTH_LEAVING)
[   22.875808] wlan0: authenticate with 24:4b:fe:be:28:28
[   22.875824] wlan0: bad VHT capabilities, disabling VHT
[   23.145717] wlan0: send auth to 24:4b:fe:be:28:28 (try 1/3)
[   23.149152] wlan0: authenticated
[   23.149288] wlan0: associate with 24:4b:fe:be:28:28 (try 1/3)
[   23.155597] wlan0: RX AssocResp from 24:4b:fe:be:28:28 (capab=0x1411 status=0 aid=5)
[   23.155861] wlan0: associated
[   23.166005] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   30.667348] acpi_call: loading out-of-tree module taints kernel.
[   30.796454] pci 0000:01:00.0: Removing from iommu group 9
[  188.055489] snd_hda_intel 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
[  188.380317] snd_hda_codec_hdmi hdaudioC1D0: Unable to sync register 0x4f0800. -5
[  188.380330] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  188.380335] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  188.380339] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  188.380343] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  197.852016] atkbd serio0: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
[  197.852029] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[  197.861034] atkbd serio0: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
[  197.861047] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[  198.427551] PM: suspend entry (deep)
[  198.446504] Filesystems sync: 0.018 seconds
[  198.446712] Freezing user space processes ... (elapsed 0.002 seconds) done.
[  198.449052] OOM killer disabled.
[  198.449053] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  198.450339] printk: Suspending console(s) (use no_console_suspend to debug)
[  198.463014] wlan0: deauthenticating from 24:4b:fe:be:28:28 by local choice (Reason: 3=DEAUTH_LEAVING)
[  198.463400] snd_hda_intel 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
[  198.466320] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  198.468114] sd 1:0:0:0: [sda] Stopping disk
[  198.557382] [drm] free PSP TMR buffer
[  198.866106] PM: late suspend of devices failed
[  198.866301] pci 0000:00:00.2: can't derive routing for PCI INT A
[  198.866306] pci 0000:00:00.2: PCI INT A: no GSI
[  198.866501] [drm] PCIE GART of 1024M enabled.
[  198.866505] [drm] PTB located at 0x000000F400900000
[  198.866522] [drm] PSP is resuming...
[  198.867597] sd 1:0:0:0: [sda] Starting disk
[  198.877203] nvme nvme0: 16/0/0 default/read/poll queues
[  198.886612] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[  199.176570] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[  199.178578] ata1: SATA link down (SStatus 0 SControl 300)
[  199.179732] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[  199.190501] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[  199.190503] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[  199.190506] amdgpu 0000:05:00.0: amdgpu: SMU is resuming...
[  199.191038] amdgpu 0000:05:00.0: amdgpu: dpm has been disabled
[  199.191992] amdgpu 0000:05:00.0: amdgpu: SMU is resumed successfully!
[  199.192786] [drm] DMUB hardware initialized: version=0x0101001F
[  199.339326] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  199.341936] ata2.00: configured for UDMA/133
[  199.735650] [drm] kiq ring mec 2 pipe 1 q 0
[  199.993027] amdgpu 0000:05:00.0: [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
[  199.993038] [drm:amdgpu_device_ip_resume_phase2] *ERROR* resume of IP block <gfx_v9_0> failed -110
[  199.993046] amdgpu 0000:05:00.0: amdgpu: amdgpu_device_ip_resume failed (-110).
[  199.993049] PM: dpm_run_callback(): pci_pm_resume+0x0/0x120 returns -110
[  199.993059] amdgpu 0000:05:00.0: PM: failed to resume async: error -110
[  199.995790] OOM killer enabled.
[  199.995792] Restarting tasks ... 
[  199.997375] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[  199.997574] done.
[  199.999376] Bluetooth: hci0: RTL: rom_version status=0 version=3
[  199.999386] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[  199.999423] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[  199.999467] amdgpu 0000:05:00.0: amdgpu: couldn't schedule ib on ring <gfx>
[  199.999473] [drm:amdgpu_job_run] *ERROR* Error scheduling IBs (-22)
[  200.000238] amdgpu 0000:05:00.0: amdgpu: couldn't schedule ib on ring <gfx>
[  200.000241] [drm:amdgpu_job_run] *ERROR* Error scheduling IBs (-22)
[  200.005766] Bluetooth: hci0: RTL: cfg_sz 6, total sz 35086
[  200.125051] PM: suspend exit
[  200.125124] PM: suspend entry (s2idle)
[  200.127453] Filesystems sync: 0.002 seconds
[  200.127641] Freezing user space processes ... 
[  200.219508] snd_hda_codec_hdmi hdaudioC1D0: Unable to sync register 0x4f0800. -5
[  200.219521] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  200.219526] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  200.219530] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  200.219534] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  200.301909] (elapsed 0.174 seconds) done.
[  200.301921] OOM killer disabled.
[  200.301922] Freezing remaining freezable tasks ... 
[  200.313625] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[  200.665006] (elapsed 0.363 seconds) done.
[  200.665018] printk: Suspending console(s) (use no_console_suspend to debug)
[  200.665098] amdgpu 0000:05:00.0: amdgpu: Power consumption will be higher as BIOS has not been configured for suspend-to-idle.
               To use suspend-to-idle change the sleep mode in BIOS setup.
[  200.671298] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  200.678851] sd 1:0:0:0: [sda] Stopping disk
[  200.777285] [drm] free PSP TMR buffer
[  201.198406] ACPI: EC: interrupt blocked
[  201.198606] amdgpu 0000:05:00.0: amdgpu: MODE2 reset
[  201.221818] ACPI: EC: interrupt unblocked
[  201.223450] snd_hda_intel 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
[  201.246631] pci 0000:00:00.2: can't derive routing for PCI INT A
[  201.246638] pci 0000:00:00.2: PCI INT A: no GSI
[  201.246685] [drm] PCIE GART of 1024M enabled.
[  201.246689] [drm] PTB located at 0x000000F400900000
[  201.246705] [drm] PSP is resuming...
[  201.248365] sd 1:0:0:0: [sda] Starting disk
[  201.264364] nvme nvme0: 16/0/0 default/read/poll queues
[  201.266746] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[  201.551853] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[  201.554640] ata1: SATA link down (SStatus 0 SControl 300)
[  201.559839] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[  201.570509] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[  201.570511] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[  201.570514] amdgpu 0000:05:00.0: amdgpu: SMU is resuming...
[  201.570887] amdgpu 0000:05:00.0: amdgpu: dpm has been disabled
[  201.571914] amdgpu 0000:05:00.0: amdgpu: SMU is resumed successfully!
[  201.572704] [drm] DMUB hardware initialized: version=0x0101001F
[  201.707298] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  201.709919] ata2.00: configured for UDMA/133
[  202.130916] [drm] kiq ring mec 2 pipe 1 q 0
[  202.146992] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[  202.147075] [drm] JPEG decode initialized successfully.
[  202.147081] amdgpu 0000:05:00.0: amdgpu: ring gfx uses VM inv eng 0 on hub 0
[  202.147086] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[  202.147089] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[  202.147090] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[  202.147092] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[  202.147094] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[  202.147096] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[  202.147098] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[  202.147099] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[  202.147102] amdgpu 0000:05:00.0: amdgpu: ring kiq_2.1.0 uses VM inv eng 11 on hub 0
[  202.147104] amdgpu 0000:05:00.0: amdgpu: ring sdma0 uses VM inv eng 0 on hub 1
[  202.147106] amdgpu 0000:05:00.0: amdgpu: ring vcn_dec uses VM inv eng 1 on hub 1
[  202.147108] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 4 on hub 1
[  202.147109] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 5 on hub 1
[  202.147111] amdgpu 0000:05:00.0: amdgpu: ring jpeg_dec uses VM inv eng 6 on hub 1
[  202.651455] [drm] Fence fallback timer expired on ring gfx
[  203.155461] [drm] Fence fallback timer expired on ring sdma0
[  203.158726] OOM killer enabled.
[  203.158728] Restarting tasks ... done.
[  203.159774] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[  203.161769] Bluetooth: hci0: RTL: rom_version status=0 version=3
[  203.161775] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[  203.161785] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[  203.161797] Bluetooth: hci0: RTL: cfg_sz 6, total sz 35086
[  203.288158] PM: suspend exit
[  203.381490] snd_hda_codec_hdmi hdaudioC1D0: Unable to sync register 0x4f0800. -5
[  203.381501] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  203.381505] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  203.381508] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  203.381511] snd_hda_codec_hdmi hdaudioC1D0: HDMI: invalid ELD buf size -1
[  203.489992] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[  204.579634] [drm] Fence fallback timer expired on ring sdma0
[  205.083300] [drm] Fence fallback timer expired on ring sdma0
[  205.587598] [drm] Fence fallback timer expired on ring sdma0
[  206.091531] [drm] Fence fallback timer expired on ring sdma0
[  206.595506] [drm] Fence fallback timer expired on ring gfx
[  206.595509] [drm] Fence fallback timer expired on ring sdma0
[  207.099493] [drm] Fence fallback timer expired on ring sdma0
[  207.099494] [drm] Fence fallback timer expired on ring gfx
[  207.603499] [drm] Fence fallback timer expired on ring gfx
[  207.603498] [drm] Fence fallback timer expired on ring sdma0
[  208.107492] [drm] Fence fallback timer expired on ring gfx
[  208.107490] [drm] Fence fallback timer expired on ring sdma0
[  208.611499] [drm] Fence fallback timer expired on ring sdma0
[  209.115504] [drm] Fence fallback timer expired on ring sdma0
[  209.451494] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for fences timed out!
[  209.619488] [drm] Fence fallback timer expired on ring sdma0
[  209.619491] [drm] Fence fallback timer expired on ring gfx
[  210.123465] [drm] Fence fallback timer expired on ring sdma0
[  210.123484] [drm] Fence fallback timer expired on ring gfx
[  210.627487] [drm] Fence fallback timer expired on ring gfx
[  211.131497] [drm] Fence fallback timer expired on ring sdma0
[  211.635496] [drm] Fence fallback timer expired on ring sdma0
[  212.139500] [drm] Fence fallback timer expired on ring sdma0
[  212.643473] [drm] Fence fallback timer expired on ring gfx
[  212.643475] [drm] Fence fallback timer expired on ring sdma0
[  213.147462] [drm] Fence fallback timer expired on ring gfx
[  213.147472] [drm] Fence fallback timer expired on ring sdma0
[  213.651495] [drm] Fence fallback timer expired on ring gfx
[  214.155480] [drm] Fence fallback timer expired on ring sdma0
[  214.155481] [drm] Fence fallback timer expired on ring gfx
[  214.659497] [drm] Fence fallback timer expired on ring sdma0
[  215.163296] [drm] Fence fallback timer expired on ring sdma0
[  215.163319] [drm] Fence fallback timer expired on ring gfx
[  215.667500] [drm] Fence fallback timer expired on ring gfx
[  215.667502] [drm] Fence fallback timer expired on ring sdma0
[  216.171485] [drm] Fence fallback timer expired on ring gfx
[  216.171488] [drm] Fence fallback timer expired on ring sdma0
[  216.675324] [drm] Fence fallback timer expired on ring sdma0
[  217.179480] [drm] Fence fallback timer expired on ring gfx
[  217.179482] [drm] Fence fallback timer expired on ring sdma0
[  217.683465] [drm] Fence fallback timer expired on ring gfx
[  217.683465] [drm] Fence fallback timer expired on ring sdma0
[  218.187501] [drm] Fence fallback timer expired on ring sdma0
[  218.691494] [drm] Fence fallback timer expired on ring gfx
[  219.179609] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for fences timed out!
[  219.195413] [drm] Fence fallback timer expired on ring gfx
[  219.699587] [drm] Fence fallback timer expired on ring gfx
[  219.699589] [drm] Fence fallback timer expired on ring sdma0
[  220.203653] [drm] Fence fallback timer expired on ring gfx
[  220.707532] [drm] Fence fallback timer expired on ring gfx
[  220.811494] [drm] Fence fallback timer expired on ring sdma0
[  221.211505] [drm] Fence fallback timer expired on ring gfx
[  221.315495] [drm] Fence fallback timer expired on ring sdma0
[  221.715506] [drm] Fence fallback timer expired on ring gfx
[  221.819651] [drm] Fence fallback timer expired on ring sdma0
[  222.219501] [drm] Fence fallback timer expired on ring gfx
[  222.323647] [drm] Fence fallback timer expired on ring sdma0
[  222.723503] [drm] Fence fallback timer expired on ring gfx
[  223.235502] [drm] Fence fallback timer expired on ring gfx
[  223.739491] [drm] Fence fallback timer expired on ring sdma0
[  224.243502] [drm] Fence fallback timer expired on ring sdma0
[  224.747484] [drm] Fence fallback timer expired on ring gfx
[  224.747489] [drm] Fence fallback timer expired on ring sdma0
[  225.251492] [drm] Fence fallback timer expired on ring gfx
[  225.251491] [drm] Fence fallback timer expired on ring sdma0
[  225.755489] [drm] Fence fallback timer expired on ring sdma0
[  225.755491] [drm] Fence fallback timer expired on ring gfx
[  226.259295] [drm] Fence fallback timer expired on ring gfx
[  226.259304] [drm] Fence fallback timer expired on ring sdma0
[  226.763486] [drm] Fence fallback timer expired on ring sdma0
[  226.763485] [drm] Fence fallback timer expired on ring gfx
[  227.267499] [drm] Fence fallback timer expired on ring sdma0
[  227.771486] [drm] Fence fallback timer expired on ring gfx
[  228.275492] [drm] Fence fallback timer expired on ring gfx
[  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for fences timed out!
[  228.779490] [drm] Fence fallback timer expired on ring gfx
[  229.283484] [drm] Fence fallback timer expired on ring sdma0
[  229.283485] [drm] Fence fallback timer expired on ring gfx
[  229.787487] [drm] Fence fallback timer expired on ring gfx
[  230.291496] [drm] Fence fallback timer expired on ring gfx
[  230.795487] [drm] Fence fallback timer expired on ring gfx
[  231.299482] [drm] Fence fallback timer expired on ring gfx
[  231.803475] [drm] Fence fallback timer expired on ring gfx
[  232.307491] [drm] Fence fallback timer expired on ring gfx
[  232.811491] [drm] Fence fallback timer expired on ring gfx
[  233.315490] [drm] Fence fallback timer expired on ring gfx
[  233.819666] [drm] Fence fallback timer expired on ring gfx
[  234.323314] [drm] Fence fallback timer expired on ring gfx
[  241.956331] wlan0: authenticate with 24:4b:fe:be:28:28
[  241.956342] wlan0: bad VHT capabilities, disabling VHT
[  242.223403] wlan0: send auth to 24:4b:fe:be:28:28 (try 1/3)
[  242.226744] wlan0: authenticated
[  242.227292] wlan0: associate with 24:4b:fe:be:28:28 (try 1/3)
[  242.233255] wlan0: RX AssocResp from 24:4b:fe:be:28:28 (capab=0x1411 status=0 aid=5)
[  242.233490] wlan0: associated

--nextPart4683878.OV4Wx5bFTl--



