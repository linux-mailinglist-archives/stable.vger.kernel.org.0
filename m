Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8152B83A
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 13:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiERLCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 07:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbiERLCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 07:02:19 -0400
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440EB1666A0
        for <stable@vger.kernel.org>; Wed, 18 May 2022 04:02:13 -0700 (PDT)
Received: from zimbra40-e7.priv.proxad.net (unknown [172.20.243.190])
        by smtp1-g21.free.fr (Postfix) with ESMTP id 76812B00563;
        Wed, 18 May 2022 13:02:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652871731;
        bh=5GFVniXa81qCKBbC8UBreLvE9pBQSLAXyUB4k8cQBgc=;
        h=Date:From:To:Cc:In-Reply-To:Subject:From;
        b=m1IKTHgal+ZjKauEI5afMTmddnD1aDRu0ItontRxVweCfklHI/KD+9RHR84S3Rkom
         3IJj+nQnLwU7aMTgwK5rHXYzvccp2APLfZNTg2UNMYR2Af7JB6XBGuUatM2Gn14eoe
         99BQ63WkBD70WHzeUEFc18C5tyyznKxk5JgLyjJnULsxxaOjHTuQ2IRP++XGnT37q3
         SbWASwpp2/6LqtLAu4U858Hdstm4tKIofNbrs72CXCqkqApRhhCYVAu6Acd7k2/Ct8
         EuHobw3kjg0JLNzf1ro+RErQ6Aa26Z/DW02PRlIum1h8ahTkrZwEQ592gZkxc1VRfS
         uSuZY4cxUFJyw==
Date:   Wed, 18 May 2022 13:02:11 +0200 (CEST)
From:   casteyde.christian@free.fr
To:     Mario Limonciello <Mario.Limonciello@amd.com>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Message-ID: <1375623147.551034914.1652871731034.JavaMail.root@zimbra40-e7.priv.proxad.net>
In-Reply-To: <MN0PR12MB6101BB3D9C3D73563C3445B9E2CE9@MN0PR12MB6101.namprd12.prod.outlook.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video
 since 5.17.4 (works 5.17.3)
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_551034912_185541098.1652871731030"
X-Originating-IP: [82.65.8.64]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - FF3.0 (Linux)/7.2.0-GA2598)
X-Authenticated-User: casteyde.christian@free.fr
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

------=_Part_551034912_185541098.1652871731030
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Can you have a try with 5.18-rc7 + https://patchwork.freedesktop.org/patc=
h/486595/
This doesn't fix my problem.

Appended dmesg log with this patch.

CC

----- Mail original -----
De: "Mario Limonciello" <Mario.Limonciello@amd.com>
=C3=80: "casteyde christian" <casteyde.christian@free.fr>, "Kai-Heng Feng" =
<kai.heng.feng@canonical.com>
Cc: stable@vger.kernel.org, "Thorsten Leemhuis" <regressions@leemhuis.info>=
, regressions@lists.linux.dev, "Alexander Deucher" <Alexander.Deucher@amd.c=
om>, gregkh@linuxfoundation.org
Envoy=C3=A9: Mardi 17 Mai 2022 20:13:34
Objet: RE: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since=
 5.17.4 (works 5.17.3)

[Public]

>=20
> dmesg logs

The thing getting reset here is an APU, so the device link stuff is irrelev=
ant to help with suspend ordering as it pertains to HDA which is what that =
commit you reverted was supposed to help.
It seems that commit had some collateral damage to APU in the S3 path (whic=
h is relatively "uncommon" now).

Can you have a try with 5.18-rc7 + https://patchwork.freedesktop.org/patch/=
486595/

That was for a different issue, but I think it may have the same outcome fo=
r you in what it's helping.
If it doesn't, please another full log.

We were discussing taking out all of this ASIC reset stuff on suspend too, =
so if that doesn't help you maybe it's the impetus to do so.

>=20
> ----- Mail original -----
> De: "Kai-Heng Feng" <kai.heng.feng@canonical.com>
> =C3=80: "Christian Casteyde" <casteyde.christian@free.fr>
> Cc: stable@vger.kernel.org, "Thorsten Leemhuis"
> <regressions@leemhuis.info>, regressions@lists.linux.dev, "alexander
> deucher" <alexander.deucher@amd.com>, gregkh@linuxfoundation.org,
> "Mario Limonciello" <mario.limonciello@amd.com>
> Envoy=C3=A9: Mardi 17 Mai 2022 08:58:30
> Objet: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video
> since 5.17.4 (works 5.17.3)
>=20
> On Tue, May 17, 2022 at 2:36 PM Christian Casteyde
> <casteyde.christian@free.fr> wrote:
> >
> > No, the problem is there even without acpicall. Fyi I use it to shutdow=
n the
> NVidia card that eats the battery otherwise.
> >
> > I managed to get a dmesg output with 2.18rc7 I will post it this evenin=
g
> (basically exact same behavior as 2.17.4).
>=20
> Can you please also attach dmesg without the offending commit (i.e.
> when it's working)?
>=20
> Kai-Heng
>=20
> >
> > CC
> >
> > =E2=81=A3T=C3=A9l=C3=A9charger BlueMail pour Android
> >
> > Le 17 mai 2022 =C3=A0 04:03, =C3=A0 04:03, Kai-Heng Feng
> <kai.heng.feng@canonical.com> a =C3=A9crit:
> > >On Tue, May 17, 2022 at 1:23 AM Christian Casteyde
> > ><casteyde.christian@free.fr> wrote:
> > >>
> > >> I've tried with 5.18-rc7, it doesn't work either. I guess 5.18 branc=
h
> > >have all
> > >> commits.
> > >>
> > >> full dmesg appended (not for 5.18, I didn't manage to resume up to
> > >the point
> > >> to get a console for now).
> > >
> > >Interestingly, I found you are using acpi_call:
> > >[   30.667348] acpi_call: loading out-of-tree module taints kernel.
> > >
> > >Does removing the acpi_call solve the issue?
> > >
> > >Kai-Heng
> > >
> > >>
> > >> CC
> > >>
> > >> Le lundi 16 mai 2022, 04:47:25 CEST Kai-Heng Feng a =C3=A9crit :
> > >> > [+Cc Mario]
> > >> >
> > >> > On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
> > >> >
> > >> > <casteyde.christian@free.fr> wrote:
> > >> > > I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
> > >> > > This does not fix the problem on my laptop.
> > >> >
> > >> > Maybe some commits are still missing?
> > >> >
> > >> > > For informatio, here is a part of the log around the suspend
> > >process:
> > >> > Is it possible to attach full dmesg?
> > >> >
> > >> > Kai-Heng
> > >> >
> > >> > > May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can'=
t
> > >change
> > >> > > power state from D3cold to D0 (config space inaccessible)
> > >> > > May 14 19:21:41 geek500 kernel: PM: late suspend of devices
> > >failed
> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> > >]------------
> > >> > > May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03:
> > >Transfer while
> > >> > > suspended
> > >> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive
> > >routing for
> > >> > > PCI INT A
> > >> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
> > >GSI
> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at
> > >drivers/i2c/
> > >> > > busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
> > >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> > >unloaded:
> > >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm=
:
> > >> > > kworker/u32:18 Tainted: G           O      5.17.7+ #7
> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> > >Gaming
> > >> > > Laptop
> > >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > >> > > May 14 19:21:41 geek500 kernel: Workqueue: events_unbound
> > >> > > async_run_entry_fn May 14 19:21:41 geek500 kernel: RIP:
> > >> > > 0010:i2c_dw_xfer+0x3f6/0x440
> > >> > > May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b
> > >67 50 4d
> > >> > > 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
> > >> > >
> > >> > >  ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc f=
f
> > >ff e9 2d
> > >> > >  9c>
> > >> > > 4b 00 83 f8 01 74
> > >> > > May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68
> > >EFLAGS:
> > >> > > 00010286
> > >> > > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> > >> > > ffff888540f170e8
> > >> > > RCX: 0000000000000be5
> > >> > > May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI:
> > >> > > 0000000000000086
> > >> > > RDI: ffffffffac858df8
> > >> > > May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08:
> > >> > > ffffffffabe46d60
> > >> > > R09: 00000000ac86a0f6
> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11:
> > >> > > ffffffffffffffff
> > >> > > R12: ffff888540f5c070
> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14:
> > >> > > 00000000ffffff94
> > >> > > R15: ffff888540f17028
> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > >> > > GS:ffff88885f640000(0000) knlGS:0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> > > 0000000080050033
> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
> > >> > > 0000000045e0c000
> > >> > > CR4: 0000000000350ee0
> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> > >> > > May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >newidle_balance.constprop.0+0x1f7/0x3b0
> > >> > > May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
> > >> > > May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >acpi_subsys_resume_early+0x50/0x50
> > >> > > May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
> > >> > > May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
> > >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >kthread_complete_and_exit+0x20/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> > >]---
> > >> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00:
> > >failed to
> > >> > > change power setting.
> > >> > > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> > >> > > acpi_subsys_resume+0x0/0x50 returns -108
> > >> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM=
:
> > >failed
> > >> > > to
> > >> > > resume async: error -108
> > >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
> > >> > > [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110=
)
> > >> > > May 14 19:21:41 geek500 kernel:
> > >[drm:amdgpu_device_ip_resume_phase2]
> > >> > > *ERROR* resume of IP block <gfx_v9_0> failed -110
> > >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> > >> > > amdgpu_device_ip_resume failed (-110).
> > >> > > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> > >> > > pci_pm_resume+0x0/0x120 returns -110
> > >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed
> > >to resume
> > >> > > async: error -110
> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> > >]------------
> > >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> > >drivers/clk/
> > >> > > clk.c:971 clk_core_disable+0x80/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> > >unloaded:
> > >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm=
:
> > >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> > >Gaming
> > >> > > Laptop
> > >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm
> pm_runtime_work
> > >> > > May 14 19:21:41 geek500 kernel: RIP:
> > >0010:clk_core_disable+0x80/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
> > >00 00 48
> > >> > > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7=
d
> > >87 c4
> > >> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
> > >0f a3 05
> > >> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
> > >0018:ffff8dbfc1c47d50
> > >> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel:
> > >> > > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
> > >> > > ffff8885401b6300
> > >> > > RCX: 0000000000000027
> > >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > >> > > 0000000000000001
> > >> > > RDI: ffff88885f59f460
> > >> > > May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08:
> > >> > > ffffffffabf26da8
> > >> > > R09: 00000000ffffdfff
> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > >> > > ffffffffabe46dc0
> > >> > > R12: ffff8885401b6300
> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > >> > > 0000000000000008
> > >> > > R15: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> > > 0000000080050033
> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > >> > > 0000000102956000
> > >> > > CR4: 0000000000350ee0
> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> > >> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > >> > > May 14 19:21:41 geek500 kernel:
> > >acpi_subsys_runtime_suspend+0x9/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >kthread_complete_and_exit+0x20/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> > >]---
> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> > >]------------
> > >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> > >drivers/clk/
> > >> > > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> > >unloaded:
> > >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm=
:
> > >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> > >Gaming
> > >> > > Laptop
> > >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm
> pm_runtime_work
> > >> > > May 14 19:21:41 geek500 kernel: RIP:
> > >0010:clk_core_unprepare+0xb1/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
> > >85 db 74
> > >> > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 3=
5
> > >87 c4
> > >> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
> > >a3 05 ea
> > >> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
> > >0018:ffff8dbfc1c47d60
> > >> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
> > >0000000000000000
> > >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> > >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > >> > > 0000000000000001
> > >> > > RDI: ffff88885f59f460
> > >> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> > >> > > ffffffffabf26da8
> > >> > > R09: 00000000ffffdfff
> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > >> > > ffffffffabe46dc0
> > >> > > R12: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > >> > > 0000000000000008
> > >> > > R15: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> > > 0000000080050033
> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > >> > > 0000000102956000
> > >> > > CR4: 0000000000350ee0
> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> > >> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > >> > > May 14 19:21:41 geek500 kernel:
> > >acpi_subsys_runtime_suspend+0x9/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel: done.
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >kthread_complete_and_exit+0x20/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> > >]---
> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> > >]------------
> > >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> > >drivers/clk/
> > >> > > clk.c:971 clk_core_disable+0x80/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> > >unloaded:
> > >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm=
:
> > >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> > >Gaming
> > >> > > Laptop
> > >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm
> pm_runtime_work
> > >> > > May 14 19:21:41 geek500 kernel: RIP:
> > >0010:clk_core_disable+0x80/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
> > >00 00 48
> > >> > > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7=
d
> > >87 c4
> > >> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
> > >0f a3 05
> > >> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
> > >0018:ffff8dbfc1c47d50
> > >> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel: RAX:
> > >0000000000000000
> > >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> > >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > >> > > 0000000000000001
> > >> > > RDI: ffff88885f59f460
> > >> > > May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08:
> > >> > > ffffffffabf26da8
> > >> > > R09: 00000000ffffdfff
> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > >> > > ffffffffabe46dc0
> > >> > > R12: ffff8885401b6300
> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > >> > > 0000000000000008
> > >> > > R15: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> > > 0000000080050033
> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > >> > > 0000000102956000
> > >> > > CR4: 0000000000350ee0
> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> > >> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > >> > > May 14 19:21:41 geek500 kernel:
> > >acpi_subsys_runtime_suspend+0x9/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >kthread_complete_and_exit+0x20/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> > >]---
> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut here
> > >]------------
> > >> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
> > >drivers/clk/
> > >> > > clk.c:829 clk_core_unprepare+0xb1/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
> > >unloaded:
> > >> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm=
:
> > >> > > kworker/6:3 Tainted: G W  O      5.17.7+ #7
> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
> > >Gaming
> > >> > > Laptop
> > >> > > 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> > >> > > May 14 19:21:41 geek500 kernel: Workqueue: pm
> pm_runtime_work
> > >> > > May 14 19:21:41 geek500 kernel: RIP:
> > >0010:clk_core_unprepare+0xb1/0x1a0
> > >> > > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
> > >85 db 74
> > >> > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 3=
5
> > >87 c4
> > >> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
> > >a3 05 ea
> > >> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
> > >0018:ffff8dbfc1c47d60
> > >> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
> > >0000000000000000
> > >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
> > >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
> > >> > > 0000000000000001
> > >> > > RDI: ffff88885f59f460
> > >> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
> > >> > > ffffffffabf26da8
> > >> > > R09: 00000000ffffdfff
> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
> > >> > > ffffffffabe46dc0
> > >> > > R12: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
> > >> > > 0000000000000008
> > >> > > R15: 0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
> > >> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> > > 0000000080050033
> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
> > >> > > 0000000102956000
> > >> > > CR4: 0000000000350ee0
> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
> > >> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
> > >> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> > >> > > May 14 19:21:41 geek500 kernel:
> > >acpi_subsys_runtime_suspend+0x9/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> > >> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> > >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> > >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> > >> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> > >> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> > >> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> > >> > > May 14 19:21:41 geek500 kernel:  ?
> > >kthread_complete_and_exit+0x20/0x20
> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
> > >]---
> > >> > > May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi
> hdaudioC1D0:
> > >Unable to
> > >> > > sync register 0x4f0800. -5
> > >> > > May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
> > >> > > May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> > >Power
> > >> > > consumption will be higher as BIOS has not been configured for
> > >> > > suspend-to-idle. To use suspend-to-idle change the sleep mode in
> > >BIOS
> > >> > > setup.
> > >> > > May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can'=
t
> > >change
> > >> > > power state from D3cold to D0 (config space inaccessible)
> > >> > > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive
> > >routing for
> > >> > > PCI INT A
> > >> > > May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no
> > >GSI
> > >> > > May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command
> > >0xfc20 tx
> > >> > > timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallback
> > >timer
> > >> > > expired on ring sdma0
> > >> > > May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download f=
w
> > >command
> > >> > > failed (-110)
> > >> > > May 14 19:21:59 geek500 kernel: done.
> > >> > > May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi
> hdaudioC1D0:
> > >Unable to
> > >> > > sync register 0x4f0800. -5
> > >> > > May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in
> > >/etc/dnsmasq.d/
> > >> > > dnsmasq-resolv.conf, will retry
> > >> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > sdma0
> > >> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:02 geek500 last message buffered 2 times
> > >> > > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:05 geek500 last message buffered 2 times
> > >> > > May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
> > >expired on
> > >> > > ring sdma0
> > >> > > May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > gfx May 14 19:22:06 geek500 last message buffered 1 times
> > >> > > ...
> > >> > > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > sdma0
> > >> > > May 14 19:22:18 geek500 kernel:
> > >[drm:amdgpu_dm_atomic_commit_tail] *ERROR*
> > >> > > Waiting for fences timed out!
> > >> > > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
> > >expired on ring
> > >> > > sdma0
> > >> > >
> > >> > > CC
> > >> > >
> > >> > > Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a =C3=A9c=
rit :
> > >> > > > Hi, this is your Linux kernel regression tracker. Thanks for
> > >the report.
> > >> > > >
> > >> > > > On 14.05.22 16:41, Christian Casteyde wrote:
> > >> > > > > #regzbot introduced v5.17.3..v5.17.4
> > >> > > > > #regzbot introduced:
> 001828fb3084379f3c3e228b905223c50bc237f9
> > >> > > >
> > >> > > > FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA
> > >function is
> > >> > > > suspended before ASIC reset") upstream.
> > >> > > >
> > >> > > > Recently a regression was reported where 887f75cfd0da was
> > >suspected as
> > >> > > > the culprit:
> > >> > > >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F2008&amp;data=3D05%7C01%7Cmario.limonciello%40amd.com%
> 7C1bec068bb98a4378972f08da382c147a%7C3dd8961fe4884e608e11a82d994e
> 183d%7C0%7C0%7C637884059824032387%7CUnknown%7CTWFpbGZsb3d8ey
> JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000%7C%7C%7C&amp;sdata=3DTzxAC63GZLbPsf1oZcj9PAIvEplX84r2VPbkb6
> T47jo%3D&amp;reserved=3D0
> > >> > > >
> > >> > > > And a one related to it:
> > >> > > >
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1982&amp;data=3D05%7C01%7Cmario.limonciello%40amd.com%
> 7C1bec068bb98a4378972f08da382c147a%7C3dd8961fe4884e608e11a82d994e
> 183d%7C0%7C0%7C637884059824032387%7CUnknown%7CTWFpbGZsb3d8ey
> JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000%7C%7C%7C&amp;sdata=3DKh1u7tEddBkeJ9NO6EFCKPrykcYW5GbQ6Fr
> tAGFK72M%3D&amp;reserved=3D0
> > >> > > >
> > >> > > > You might want to take a look if what was discussed there migh=
t
> > >be
> > >> > > > related to your problem (I'm not directly involved in any of
> > >this, I
> > >> > > > don't know the details, it's just that 887f75cfd0da looked
> > >familiar to
> > >> > > > me). If it is, a fix for these two bugs was committed to maste=
r
> > >earlier
> > >> > > > this week:
> > >> > > >
> > >> > > >
> >
> >https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.
> kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git
> %2Fcommi&amp;data=3D05%7C01%7Cmario.limonciello%40amd.com%7C1bec0
> 68bb98a4378972f08da382c147a%7C3dd8961fe4884e608e11a82d994e183d%7
> C0%7C0%7C637884059824032387%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300
> 0%7C%7C%7C&amp;sdata=3DQ3hdn9Q9DYu9CFTjn6ge5VFcxIbHClwLvy8qFPbiCi
> w%3D&amp;reserved=3D0
> > >> > > > t/?i d=3Da56f445f807b0276
> > >> > > >
> > >> > > > It will likely be backported to 5.17.y, maybe already in the
> > >over-next
> > >> > > > release. HTH.
> > >> > > >
> > >> > > > Ciao, Thorsten (wearing his 'the Linux kernel's regression
> > >tracker' hat)
> > >> > > >
> > >> > > > P.S.: As the Linux kernel's regression tracker I deal with a
> > >lot of
> > >> > > > reports and sometimes miss something important when writing
> > >mails like
> > >> > > > this. If that's the case here, don't hesitate to tell me in a
> > >public
> > >> > > > reply, it's in everyone's interest to set the public record
> > >straight.
> > >> > > >
> > >> > > > > Hello
> > >> > > > > Since 5.17.4 my laptop doesn't resume from suspend anymore.
> > >At resume,
> > >> > > > > symptoms are variable:
> > >> > > > > - either the laptop freezes;
> > >> > > > > - either the screen keeps blank;
> > >> > > > > - either the screen is OK but mouse is frozen;
> > >> > > > > - either display lags with several logs in dmesg:
> > >> > > > > [  228.275492] [drm] Fence fallback timer expired on ring gf=
x
> > >> > > > > [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
> > >Waiting for
> > >> > > > > fences timed out!
> > >> > > > > [  228.779490] [drm] Fence fallback timer expired on ring gf=
x
> > >> > > > > [  229.283484] [drm] Fence fallback timer expired on ring
> > >sdma0
> > >> > > > > [  229.283485] [drm] Fence fallback timer expired on ring gf=
x
> > >> > > > > [  229.787487] [drm] Fence fallback timer expired on ring gf=
x
> > >> > > > > ...
> > >> > > > >
> > >> > > > > I've bisected the problem.
> > >> > > > >
> > >> > > > > Please note this laptop has a strange behaviour on suspend:
> > >> > > > > The first suspend request always fails (this point has never
> > >been
> > >> > > > > fixed
> > >> > > > > and
> > >> > > > > plagues us when trying to diagnose another regression on
> > >touchpad not
> > >> > > > > resuming in the past). The screen goes blank and I can get i=
t
> > >OK when
> > >> > > > > pressing the power button, this seems to reset it. After tha=
t
> > >all
> > >> > > > > suspend/resume works OK.
> > >> > > > >
> > >> > > > > Since 5.17.4, it is not possible anymore to get the laptop
> > >working
> > >> > > > > again
> > >> > > > > after the first suspend failure.
> > >> > > > >
> > >> > > > > HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated =
+
> > >NVidia
> > >> > > > > 1650Ti
> > >> > > > > (turned off with ACPI call in order to get more battery, I'm
> > >not using
> > >> > > > > NVidia driver).
> > >>
> >

------=_Part_551034912_185541098.1652871731030
Content-Type: text/plain; name=dmesg-bad_with_patch.txt
Content-Disposition: attachment; filename=dmesg-bad_with_patch.txt
Content-Transfer-Encoding: base64

WyAgICAwLjAwMDAwMF0gTGludXggdmVyc2lvbiA1LjE4LjAtcmM3IChyb290QGdlZWs1MDAubG9j
YWxkb21haW4pIChnY2MgKEdDQykgMTEuMi4wLCBHTlUgbGQgdmVyc2lvbiAyLjM4LXNsYWNrMTUx
KSAjMjUgU01QIFBSRUVNUFRfRFlOQU1JQyBXZWQgTWF5IDE4IDEyOjU0OjQ0IENFU1QgMjAyMgpb
ICAgIDAuMDAwMDAwXSBDb21tYW5kIGxpbmU6IHJvIHJvb3Q9L2Rldi9udm1lMG4xcDQKWyAgICAw
LjAwMDAwMF0geDg2L2ZwdTogU3VwcG9ydGluZyBYU0FWRSBmZWF0dXJlIDB4MDAxOiAneDg3IGZs
b2F0aW5nIHBvaW50IHJlZ2lzdGVycycKWyAgICAwLjAwMDAwMF0geDg2L2ZwdTogU3VwcG9ydGlu
ZyBYU0FWRSBmZWF0dXJlIDB4MDAyOiAnU1NFIHJlZ2lzdGVycycKWyAgICAwLjAwMDAwMF0geDg2
L2ZwdTogU3VwcG9ydGluZyBYU0FWRSBmZWF0dXJlIDB4MDA0OiAnQVZYIHJlZ2lzdGVycycKWyAg
ICAwLjAwMDAwMF0geDg2L2ZwdTogeHN0YXRlX29mZnNldFsyXTogIDU3NiwgeHN0YXRlX3NpemVz
WzJdOiAgMjU2ClsgICAgMC4wMDAwMDBdIHg4Ni9mcHU6IEVuYWJsZWQgeHN0YXRlIGZlYXR1cmVz
IDB4NywgY29udGV4dCBzaXplIGlzIDgzMiBieXRlcywgdXNpbmcgJ2NvbXBhY3RlZCcgZm9ybWF0
LgpbICAgIDAuMDAwMDAwXSBzaWduYWw6IG1heCBzaWdmcmFtZSBzaXplOiAxNzc2ClsgICAgMC4w
MDAwMDBdIEJJT1MtcHJvdmlkZWQgcGh5c2ljYWwgUkFNIG1hcDoKWyAgICAwLjAwMDAwMF0gQklP
Uy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwMDAwMDAwMC0weDAwMDAwMDAwMDAwOWZmZmZdIHVzYWJs
ZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDAwMGEwMDAwLTB4MDAw
MDAwMDAwMDBmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4
MDAwMDAwMDAwMDEwMDAwMC0weDAwMDAwMDAwMDllY2ZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAw
XSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDA5ZWQwMDAwLTB4MDAwMDAwMDAwOWZmZmZmZl0g
cmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwYTAwMDAw
MC0weDAwMDAwMDAwMGExZmZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFtt
ZW0gMHgwMDAwMDAwMDBhMjAwMDAwLTB4MDAwMDAwMDAwYTIwY2ZmZl0gQUNQSSBOVlMKWyAgICAw
LjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwYTIwZDAwMC0weDAwMDAwMDAwYTcz
ODNmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGE3
Mzg0MDAwLTB4MDAwMDAwMDBhNzRkOWZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1l
ODIwOiBbbWVtIDB4MDAwMDAwMDBhNzRkYTAwMC0weDAwMDAwMDAwYTc1M2ZmZmZdIEFDUEkgZGF0
YQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGE3NTQwMDAwLTB4MDAw
MDAwMDBhNzZlZWZmZl0gQUNQSSBOVlMKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4
MDAwMDAwMDBhNzZlZjAwMC0weDAwMDAwMDAwYWNmZmRmZmZdIHJlc2VydmVkClsgICAgMC4wMDAw
MDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwYWNmZmUwMDAtMHgwMDAwMDAwMGFkZmZmZmZm
XSB1c2FibGUKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBhZTAwMDAw
MC0weDAwMDAwMDAwYWZmZmZmZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDog
W21lbSAweDAwMDAwMDAwZjAwMDAwMDAtMHgwMDAwMDAwMGY3ZmZmZmZmXSByZXNlcnZlZApbICAg
IDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGZkMDAwMDAwLTB4MDAwMDAwMDBm
ZmZmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAw
MDEwMDAwMDAwMC0weDAwMDAwMDA0MmYzM2ZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9T
LWU4MjA6IFttZW0gMHgwMDAwMDAwNDJmMzQwMDAwLTB4MDAwMDAwMDQ3MDFmZmZmZl0gcmVzZXJ2
ZWQKWyAgICAwLjAwMDAwMF0gTlggKEV4ZWN1dGUgRGlzYWJsZSkgcHJvdGVjdGlvbjogYWN0aXZl
ClsgICAgMC4wMDAwMDBdIGU4MjA6IHVwZGF0ZSBbbWVtIDB4YTQxNzcwMTgtMHhhNDFhMDg1N10g
dXNhYmxlID09PiB1c2FibGUKWyAgICAwLjAwMDAwMF0gZTgyMDogdXBkYXRlIFttZW0gMHhhNDE3
NzAxOC0weGE0MWEwODU3XSB1c2FibGUgPT0+IHVzYWJsZQpbICAgIDAuMDAwMDAwXSBlODIwOiB1
cGRhdGUgW21lbSAweGE0MjNhMDE4LTB4YTQyNDc0NTddIHVzYWJsZSA9PT4gdXNhYmxlClsgICAg
MC4wMDAwMDBdIGU4MjA6IHVwZGF0ZSBbbWVtIDB4YTQyM2EwMTgtMHhhNDI0NzQ1N10gdXNhYmxl
ID09PiB1c2FibGUKWyAgICAwLjAwMDAwMF0gZXh0ZW5kZWQgcGh5c2ljYWwgUkFNIG1hcDoKWyAg
ICAwLjAwMDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDAwMDAwMDAwMC0w
eDAwMDAwMDAwMDAwOWZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2Rh
dGE6IFttZW0gMHgwMDAwMDAwMDAwMGEwMDAwLTB4MDAwMDAwMDAwMDBmZmZmZl0gcmVzZXJ2ZWQK
WyAgICAwLjAwMDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDAwMDEwMDAw
MC0weDAwMDAwMDAwMDllY2ZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVw
X2RhdGE6IFttZW0gMHgwMDAwMDAwMDA5ZWQwMDAwLTB4MDAwMDAwMDAwOWZmZmZmZl0gcmVzZXJ2
ZWQKWyAgICAwLjAwMDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDAwYTAw
MDAwMC0weDAwMDAwMDAwMGExZmZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNl
dHVwX2RhdGE6IFttZW0gMHgwMDAwMDAwMDBhMjAwMDAwLTB4MDAwMDAwMDAwYTIwY2ZmZl0gQUNQ
SSBOVlMKWyAgICAwLjAwMDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDAw
YTIwZDAwMC0weDAwMDAwMDAwYTQxNzcwMTddIHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZl
IHNldHVwX2RhdGE6IFttZW0gMHgwMDAwMDAwMGE0MTc3MDE4LTB4MDAwMDAwMDBhNDFhMDg1N10g
dXNhYmxlClsgICAgMC4wMDAwMDBdIHJlc2VydmUgc2V0dXBfZGF0YTogW21lbSAweDAwMDAwMDAw
YTQxYTA4NTgtMHgwMDAwMDAwMGE0MjNhMDE3XSB1c2FibGUKWyAgICAwLjAwMDAwMF0gcmVzZXJ2
ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDBhNDIzYTAxOC0weDAwMDAwMDAwYTQyNDc0NTdd
IHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2RhdGE6IFttZW0gMHgwMDAwMDAw
MGE0MjQ3NDU4LTB4MDAwMDAwMDBhNzM4M2ZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBdIHJlc2Vy
dmUgc2V0dXBfZGF0YTogW21lbSAweDAwMDAwMDAwYTczODQwMDAtMHgwMDAwMDAwMGE3NGQ5ZmZm
XSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2RhdGE6IFttZW0gMHgwMDAw
MDAwMGE3NGRhMDAwLTB4MDAwMDAwMDBhNzUzZmZmZl0gQUNQSSBkYXRhClsgICAgMC4wMDAwMDBd
IHJlc2VydmUgc2V0dXBfZGF0YTogW21lbSAweDAwMDAwMDAwYTc1NDAwMDAtMHgwMDAwMDAwMGE3
NmVlZmZmXSBBQ1BJIE5WUwpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2RhdGE6IFttZW0g
MHgwMDAwMDAwMGE3NmVmMDAwLTB4MDAwMDAwMDBhY2ZmZGZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAw
MDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDBhY2ZmZTAwMC0weDAwMDAw
MDAwYWRmZmZmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2RhdGE6IFtt
ZW0gMHgwMDAwMDAwMGFlMDAwMDAwLTB4MDAwMDAwMDBhZmZmZmZmZl0gcmVzZXJ2ZWQKWyAgICAw
LjAwMDAwMF0gcmVzZXJ2ZSBzZXR1cF9kYXRhOiBbbWVtIDB4MDAwMDAwMDBmMDAwMDAwMC0weDAw
MDAwMDAwZjdmZmZmZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIHJlc2VydmUgc2V0dXBfZGF0
YTogW21lbSAweDAwMDAwMDAwZmQwMDAwMDAtMHgwMDAwMDAwMGZmZmZmZmZmXSByZXNlcnZlZApb
ICAgIDAuMDAwMDAwXSByZXNlcnZlIHNldHVwX2RhdGE6IFttZW0gMHgwMDAwMDAwMTAwMDAwMDAw
LTB4MDAwMDAwMDQyZjMzZmZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBdIHJlc2VydmUgc2V0dXBf
ZGF0YTogW21lbSAweDAwMDAwMDA0MmYzNDAwMDAtMHgwMDAwMDAwNDcwMWZmZmZmXSByZXNlcnZl
ZApbICAgIDAuMDAwMDAwXSBlZmk6IEVGSSB2Mi43MCBieSBBbWVyaWNhbiBNZWdhdHJlbmRzClsg
ICAgMC4wMDAwMDBdIGVmaTogQUNQST0weGE3NTNmMDAwIEFDUEkgMi4wPTB4YTc1M2YwMTQgVFBN
RmluYWxMb2c9MHhhNzZhNzAwMCBTTUJJT1M9MHhhY2UxYjAwMCBTTUJJT1MgMy4wPTB4YWNlMWEw
MDAgTUVNQVRUUj0weGE2MDE5MDE4IEVTUlQ9MHhhNjYyMWQxOCBSTkc9MHhhY2U2OGY5OCBUUE1F
dmVudExvZz0weGE2MDlhMDE4IApbICAgIDAuMDAwMDAwXSBlZmk6IHNlZWRpbmcgZW50cm9weSBw
b29sClsgICAgMC4wMDAwMDBdIFNNQklPUyAzLjIuMCBwcmVzZW50LgpbICAgIDAuMDAwMDAwXSBE
TUk6IEhQIEhQIFBhdmlsaW9uIEdhbWluZyBMYXB0b3AgMTUtZWMxeHh4Lzg3QjIsIEJJT1MgRi4y
NSAwOC8xOC8yMDIxClsgICAgMC4wMDAwMDBdIHRzYzogRmFzdCBUU0MgY2FsaWJyYXRpb24gdXNp
bmcgUElUClsgICAgMC4wMDAwMDBdIHRzYzogRGV0ZWN0ZWQgMjk5NC4yNjIgTUh6IHByb2Nlc3Nv
cgpbICAgIDAuMDAwMTM0XSBlODIwOiB1cGRhdGUgW21lbSAweDAwMDAwMDAwLTB4MDAwMDBmZmZd
IHVzYWJsZSA9PT4gcmVzZXJ2ZWQKWyAgICAwLjAwMDEzNV0gZTgyMDogcmVtb3ZlIFttZW0gMHgw
MDBhMDAwMC0weDAwMGZmZmZmXSB1c2FibGUKWyAgICAwLjAwMDEzOV0gbGFzdF9wZm4gPSAweDQy
ZjM0MCBtYXhfYXJjaF9wZm4gPSAweDQwMDAwMDAwMApbICAgIDAuMDAwMjQ3XSB4ODYvUEFUOiBD
b25maWd1cmF0aW9uIFswLTddOiBXQiAgV0MgIFVDLSBVQyAgV0IgIFdQICBVQy0gV1QgIApbICAg
IDAuMDAwNDc0XSBlODIwOiB1cGRhdGUgW21lbSAweGIwMDAwMDAwLTB4ZmZmZmZmZmZdIHVzYWJs
ZSA9PT4gcmVzZXJ2ZWQKWyAgICAwLjAwMDQ4MV0gbGFzdF9wZm4gPSAweGFlMDAwIG1heF9hcmNo
X3BmbiA9IDB4NDAwMDAwMDAwClsgICAgMC4wMDA0OTFdIGVzcnQ6IFJlc2VydmluZyBFU1JUIHNw
YWNlIGZyb20gMHgwMDAwMDAwMGE2NjIxZDE4IHRvIDB4MDAwMDAwMDBhNjYyMWQ1MC4KWyAgICAw
LjAwMDUwMV0gZTgyMDogdXBkYXRlIFttZW0gMHhhNjYyMTAwMC0weGE2NjIxZmZmXSB1c2FibGUg
PT0+IHJlc2VydmVkClsgICAgMC4wMDA1NDFdIFVzaW5nIEdCIHBhZ2VzIGZvciBkaXJlY3QgbWFw
cGluZwpbICAgIDAuMDAwNzIwXSBTZWN1cmUgYm9vdCBkaXNhYmxlZApbICAgIDAuMDAwNzIzXSBB
Q1BJOiBFYXJseSB0YWJsZSBjaGVja3N1bSB2ZXJpZmljYXRpb24gZGlzYWJsZWQKWyAgICAwLjAw
MDcyNV0gQUNQSTogUlNEUCAweDAwMDAwMDAwQTc1M0YwMTQgMDAwMDI0ICh2MDIgSFBRT0VNKQpb
ICAgIDAuMDAwNzI4XSBBQ1BJOiBYU0RUIDB4MDAwMDAwMDBBNzUzRTcyOCAwMDAwRUMgKHYwMSBI
UFFPRU0gU0xJQy1NUEMgMDEwNzIwMDkgQU1JICAwMTAwMDAxMykKWyAgICAwLjAwMDczMl0gQUNQ
STogRkFDUCAweDAwMDAwMDAwQTc1MzQwMDAgMDAwMTE0ICh2MDYgSFBRT0VNIFNMSUMtTVBDIDAx
MDcyMDA5IEhQICAgMDAwMTAwMTMpClsgICAgMC4wMDA3MzVdIEFDUEk6IERTRFQgMHgwMDAwMDAw
MEE3NTFGMDAwIDAxNDlCOCAodjAyIEhQUU9FTSA4N0IyICAgICAwMTA3MjAwOSBBQ1BJIDIwMTIw
OTEzKQpbICAgIDAuMDAwNzM3XSBBQ1BJOiBGQUNTIDB4MDAwMDAwMDBBNzZBNTAwMCAwMDAwNDAK
WyAgICAwLjAwMDczOV0gQUNQSTogU1NEVCAweDAwMDAwMDAwQTc1MzYwMDAgMDA3MjE2ICh2MDIg
SFBRT0VNIDg3QjIgICAgIDAwMDAwMDAyIEFDUEkgMDQwMDAwMDApClsgICAgMC4wMDA3NDFdIEFD
UEk6IElWUlMgMHgwMDAwMDAwMEE3NTM1MDAwIDAwMDFBNCAodjAyIEhQUU9FTSA4N0IyICAgICAw
MDAwMDAwMSBIUCAgIDAwMDAwMDAwKQpbICAgIDAuMDAwNzQzXSBBQ1BJOiBGSURUIDB4MDAwMDAw
MDBBNzUxRTAwMCAwMDAwOUMgKHYwMSBIUFFPRU0gODdCMiAgICAgMDEwNzIwMDkgSFAgICAwMDAx
MDAxMykKWyAgICAwLjAwMDc0NF0gQUNQSTogTUNGRyAweDAwMDAwMDAwQTc1MUQwMDAgMDAwMDND
ICh2MDEgSFBRT0VNIDg3QjIgICAgIDAxMDcyMDA5IEhQICAgMDAwMTAwMTMpClsgICAgMC4wMDA3
NDZdIEFDUEk6IEhQRVQgMHgwMDAwMDAwMEE3NTFDMDAwIDAwMDAzOCAodjAxIEhQUU9FTSA4N0Iy
ICAgICAwMTA3MjAwOSBIUCAgIDAwMDAwMDA1KQpbICAgIDAuMDAwNzQ4XSBBQ1BJOiBTU0RUIDB4
MDAwMDAwMDBBNzUxQjAwMCAwMDAyMjggKHYwMSBIUFFPRU0gODdCMiAgICAgMDAwMDAwMDEgQUNQ
SSAyMDEyMDkxMykKWyAgICAwLjAwMDc1MF0gQUNQSTogVkZDVCAweDAwMDAwMDAwQTc1MEQwMDAg
MDBENDg0ICh2MDEgSFBRT0VNIDg3QjIgICAgIDAwMDAwMDAxIEhQICAgMzE1MDRGNDcpClsgICAg
MC4wMDA3NTJdIEFDUEk6IFNTRFQgMHgwMDAwMDAwMEE3NTBDMDAwIDAwMDA1MCAodjAxIEhQUU9F
TSA4N0IyICAgICAwMDAwMDAwMSBBQ1BJIDIwMTIwOTEzKQpbICAgIDAuMDAwNzU0XSBBQ1BJOiBU
UE0yIDB4MDAwMDAwMDBBNzUwQjAwMCAwMDAwNEMgKHYwNCBIUFFPRU0gODdCMiAgICAgMDAwMDAw
MDEgSFAgICAwMDAwMDAwMCkKWyAgICAwLjAwMDc1NV0gQUNQSTogU1NEVCAweDAwMDAwMDAwQTc1
MDgwMDAgMDAyQjgwICh2MDEgSFBRT0VNIDg3QjIgICAgIDAwMDAwMDAxIEFDUEkgMDAwMDAwMDEp
ClsgICAgMC4wMDA3NTddIEFDUEk6IENSQVQgMHgwMDAwMDAwMEE3NTA3MDAwIDAwMEJBOCAodjAx
IEhQUU9FTSA4N0IyICAgICAwMDAwMDAwMSBIUCAgIDAwMDAwMDAxKQpbICAgIDAuMDAwNzU5XSBB
Q1BJOiBDRElUIDB4MDAwMDAwMDBBNzUwNjAwMCAwMDAwMjkgKHYwMSBIUFFPRU0gODdCMiAgICAg
MDAwMDAwMDEgSFAgICAwMDAwMDAwMSkKWyAgICAwLjAwMDc2MV0gQUNQSTogU1NEVCAweDAwMDAw
MDAwQTc1MDUwMDAgMDAwMTM5ICh2MDEgSFBRT0VNIDg3QjIgICAgIDAwMDAwMDAxIEFDUEkgMjAx
MjA5MTMpClsgICAgMC4wMDA3NjNdIEFDUEk6IFNTRFQgMHgwMDAwMDAwMEE3NTA0MDAwIDAwMDBD
MiAodjAxIEhQUU9FTSA4N0IyICAgICAwMDAwMDAwMSBBQ1BJIDIwMTIwOTEzKQpbICAgIDAuMDAw
NzY0XSBBQ1BJOiBTU0RUIDB4MDAwMDAwMDBBNzUwMzAwMCAwMDBEMzcgKHYwMSBIUFFPRU0gODdC
MiAgICAgMDAwMDAwMDEgQUNQSSAyMDEyMDkxMykKWyAgICAwLjAwMDc2Nl0gQUNQSTogU1NEVCAw
eDAwMDAwMDAwQTc1MDEwMDAgMDAxMEFDICh2MDEgSFBRT0VNIDg3QjIgICAgIDAwMDAwMDAxIEFD
UEkgMjAxMjA5MTMpClsgICAgMC4wMDA3NjhdIEFDUEk6IFNTRFQgMHgwMDAwMDAwMEE3NTAwMDAw
IDAwMEQ4NyAodjAxIEhQUU9FTSA4N0IyICAgICAwMDAwMDAwMSBBQ1BJIDIwMTIwOTEzKQpbICAg
IDAuMDAwNzcwXSBBQ1BJOiBTU0RUIDB4MDAwMDAwMDBBNzRGQzAwMCAwMDMwQzggKHYwMSBIUFFP
RU0gODdCMiAgICAgMDAwMDAwMDEgQUNQSSAyMDEyMDkxMykKWyAgICAwLjAwMDc3Ml0gQUNQSTog
V1NNVCAweDAwMDAwMDAwQTc0RkIwMDAgMDAwMDI4ICh2MDEgSFBRT0VNIDg3QjIgICAgIDAxMDcy
MDA5IEhQICAgMDAwMTAwMTMpClsgICAgMC4wMDA3NzRdIEFDUEk6IEFQSUMgMHgwMDAwMDAwMEE3
NEZBMDAwIDAwMDBERSAodjAzIEhQUU9FTSA4N0IyICAgICAwMTA3MjAwOSBIUCAgIDAwMDEwMDEz
KQpbICAgIDAuMDAwNzc1XSBBQ1BJOiBTU0RUIDB4MDAwMDAwMDBBNzRGOTAwMCAwMDAwN0QgKHYw
MSBIUFFPRU0gODdCMiAgICAgMDAwMDAwMDEgQUNQSSAyMDEyMDkxMykKWyAgICAwLjAwMDc3N10g
QUNQSTogU1NEVCAweDAwMDAwMDAwQTc0RjgwMDAgMDAwNTE3ICh2MDEgSFBRT0VNIDg3QjIgICAg
IDAwMDAwMDAxIEFDUEkgMjAxMjA5MTMpClsgICAgMC4wMDA3NzldIEFDUEk6IEZQRFQgMHgwMDAw
MDAwMEE3NEY3MDAwIDAwMDA0NCAodjAxIEhQUU9FTSA4N0IyICAgICAwMTA3MjAwOSBIUCAgIDAx
MDAwMDEzKQpbICAgIDAuMDAwNzgxXSBBQ1BJOiBCR1JUIDB4MDAwMDAwMDBBNzRGNjAwMCAwMDAw
MzggKHYwMSBIUFFPRU0gODdCMiAgICAgMDEwNzIwMDkgSFAgICAwMDAxMDAxMykKWyAgICAwLjAw
MDc4Ml0gQUNQSTogUmVzZXJ2aW5nIEZBQ1AgdGFibGUgbWVtb3J5IGF0IFttZW0gMHhhNzUzNDAw
MC0weGE3NTM0MTEzXQpbICAgIDAuMDAwNzg0XSBBQ1BJOiBSZXNlcnZpbmcgRFNEVCB0YWJsZSBt
ZW1vcnkgYXQgW21lbSAweGE3NTFmMDAwLTB4YTc1MzM5YjddClsgICAgMC4wMDA3ODVdIEFDUEk6
IFJlc2VydmluZyBGQUNTIHRhYmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc2YTUwMDAtMHhhNzZhNTAz
Zl0KWyAgICAwLjAwMDc4NV0gQUNQSTogUmVzZXJ2aW5nIFNTRFQgdGFibGUgbWVtb3J5IGF0IFtt
ZW0gMHhhNzUzNjAwMC0weGE3NTNkMjE1XQpbICAgIDAuMDAwNzg2XSBBQ1BJOiBSZXNlcnZpbmcg
SVZSUyB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3NTM1MDAwLTB4YTc1MzUxYTNdClsgICAgMC4w
MDA3ODddIEFDUEk6IFJlc2VydmluZyBGSURUIHRhYmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc1MWUw
MDAtMHhhNzUxZTA5Yl0KWyAgICAwLjAwMDc4OF0gQUNQSTogUmVzZXJ2aW5nIE1DRkcgdGFibGUg
bWVtb3J5IGF0IFttZW0gMHhhNzUxZDAwMC0weGE3NTFkMDNiXQpbICAgIDAuMDAwNzg5XSBBQ1BJ
OiBSZXNlcnZpbmcgSFBFVCB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3NTFjMDAwLTB4YTc1MWMw
MzddClsgICAgMC4wMDA3ODldIEFDUEk6IFJlc2VydmluZyBTU0RUIHRhYmxlIG1lbW9yeSBhdCBb
bWVtIDB4YTc1MWIwMDAtMHhhNzUxYjIyN10KWyAgICAwLjAwMDc5MF0gQUNQSTogUmVzZXJ2aW5n
IFZGQ1QgdGFibGUgbWVtb3J5IGF0IFttZW0gMHhhNzUwZDAwMC0weGE3NTFhNDgzXQpbICAgIDAu
MDAwNzkxXSBBQ1BJOiBSZXNlcnZpbmcgU1NEVCB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3NTBj
MDAwLTB4YTc1MGMwNGZdClsgICAgMC4wMDA3OTJdIEFDUEk6IFJlc2VydmluZyBUUE0yIHRhYmxl
IG1lbW9yeSBhdCBbbWVtIDB4YTc1MGIwMDAtMHhhNzUwYjA0Yl0KWyAgICAwLjAwMDc5M10gQUNQ
STogUmVzZXJ2aW5nIFNTRFQgdGFibGUgbWVtb3J5IGF0IFttZW0gMHhhNzUwODAwMC0weGE3NTBh
YjdmXQpbICAgIDAuMDAwNzkzXSBBQ1BJOiBSZXNlcnZpbmcgQ1JBVCB0YWJsZSBtZW1vcnkgYXQg
W21lbSAweGE3NTA3MDAwLTB4YTc1MDdiYTddClsgICAgMC4wMDA3OTRdIEFDUEk6IFJlc2Vydmlu
ZyBDRElUIHRhYmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc1MDYwMDAtMHhhNzUwNjAyOF0KWyAgICAw
LjAwMDc5NV0gQUNQSTogUmVzZXJ2aW5nIFNTRFQgdGFibGUgbWVtb3J5IGF0IFttZW0gMHhhNzUw
NTAwMC0weGE3NTA1MTM4XQpbICAgIDAuMDAwNzk2XSBBQ1BJOiBSZXNlcnZpbmcgU1NEVCB0YWJs
ZSBtZW1vcnkgYXQgW21lbSAweGE3NTA0MDAwLTB4YTc1MDQwYzFdClsgICAgMC4wMDA3OTddIEFD
UEk6IFJlc2VydmluZyBTU0RUIHRhYmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc1MDMwMDAtMHhhNzUw
M2QzNl0KWyAgICAwLjAwMDc5N10gQUNQSTogUmVzZXJ2aW5nIFNTRFQgdGFibGUgbWVtb3J5IGF0
IFttZW0gMHhhNzUwMTAwMC0weGE3NTAyMGFiXQpbICAgIDAuMDAwNzk4XSBBQ1BJOiBSZXNlcnZp
bmcgU1NEVCB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3NTAwMDAwLTB4YTc1MDBkODZdClsgICAg
MC4wMDA3OTldIEFDUEk6IFJlc2VydmluZyBTU0RUIHRhYmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc0
ZmMwMDAtMHhhNzRmZjBjN10KWyAgICAwLjAwMDgwMF0gQUNQSTogUmVzZXJ2aW5nIFdTTVQgdGFi
bGUgbWVtb3J5IGF0IFttZW0gMHhhNzRmYjAwMC0weGE3NGZiMDI3XQpbICAgIDAuMDAwODAxXSBB
Q1BJOiBSZXNlcnZpbmcgQVBJQyB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3NGZhMDAwLTB4YTc0
ZmEwZGRdClsgICAgMC4wMDA4MDFdIEFDUEk6IFJlc2VydmluZyBTU0RUIHRhYmxlIG1lbW9yeSBh
dCBbbWVtIDB4YTc0ZjkwMDAtMHhhNzRmOTA3Y10KWyAgICAwLjAwMDgwMl0gQUNQSTogUmVzZXJ2
aW5nIFNTRFQgdGFibGUgbWVtb3J5IGF0IFttZW0gMHhhNzRmODAwMC0weGE3NGY4NTE2XQpbICAg
IDAuMDAwODAzXSBBQ1BJOiBSZXNlcnZpbmcgRlBEVCB0YWJsZSBtZW1vcnkgYXQgW21lbSAweGE3
NGY3MDAwLTB4YTc0ZjcwNDNdClsgICAgMC4wMDA4MDRdIEFDUEk6IFJlc2VydmluZyBCR1JUIHRh
YmxlIG1lbW9yeSBhdCBbbWVtIDB4YTc0ZjYwMDAtMHhhNzRmNjAzN10KWyAgICAwLjAwMDgyN10g
Wm9uZSByYW5nZXM6ClsgICAgMC4wMDA4MjddICAgRE1BICAgICAgW21lbSAweDAwMDAwMDAwMDAw
MDEwMDAtMHgwMDAwMDAwMDAwZmZmZmZmXQpbICAgIDAuMDAwODI5XSAgIERNQTMyICAgIFttZW0g
MHgwMDAwMDAwMDAxMDAwMDAwLTB4MDAwMDAwMDBmZmZmZmZmZl0KWyAgICAwLjAwMDgzMF0gICBO
b3JtYWwgICBbbWVtIDB4MDAwMDAwMDEwMDAwMDAwMC0weDAwMDAwMDA0MmYzM2ZmZmZdClsgICAg
MC4wMDA4MzFdIE1vdmFibGUgem9uZSBzdGFydCBmb3IgZWFjaCBub2RlClsgICAgMC4wMDA4MzJd
IEVhcmx5IG1lbW9yeSBub2RlIHJhbmdlcwpbICAgIDAuMDAwODMyXSAgIG5vZGUgICAwOiBbbWVt
IDB4MDAwMDAwMDAwMDAwMTAwMC0weDAwMDAwMDAwMDAwOWZmZmZdClsgICAgMC4wMDA4MzNdICAg
bm9kZSAgIDA6IFttZW0gMHgwMDAwMDAwMDAwMTAwMDAwLTB4MDAwMDAwMDAwOWVjZmZmZl0KWyAg
ICAwLjAwMDgzNF0gICBub2RlICAgMDogW21lbSAweDAwMDAwMDAwMGEwMDAwMDAtMHgwMDAwMDAw
MDBhMWZmZmZmXQpbICAgIDAuMDAwODM1XSAgIG5vZGUgICAwOiBbbWVtIDB4MDAwMDAwMDAwYTIw
ZDAwMC0weDAwMDAwMDAwYTczODNmZmZdClsgICAgMC4wMDA4MzZdICAgbm9kZSAgIDA6IFttZW0g
MHgwMDAwMDAwMGFjZmZlMDAwLTB4MDAwMDAwMDBhZGZmZmZmZl0KWyAgICAwLjAwMDgzN10gICBu
b2RlICAgMDogW21lbSAweDAwMDAwMDAxMDAwMDAwMDAtMHgwMDAwMDAwNDJmMzNmZmZmXQpbICAg
IDAuMDAwODM4XSBJbml0bWVtIHNldHVwIG5vZGUgMCBbbWVtIDB4MDAwMDAwMDAwMDAwMTAwMC0w
eDAwMDAwMDA0MmYzM2ZmZmZdClsgICAgMC4wMDA4NDJdIE9uIG5vZGUgMCwgem9uZSBETUE6IDEg
cGFnZXMgaW4gdW5hdmFpbGFibGUgcmFuZ2VzClsgICAgMC4wMDA4NTZdIE9uIG5vZGUgMCwgem9u
ZSBETUE6IDk2IHBhZ2VzIGluIHVuYXZhaWxhYmxlIHJhbmdlcwpbICAgIDAuMDAwOTg2XSBPbiBu
b2RlIDAsIHpvbmUgRE1BMzI6IDMwNCBwYWdlcyBpbiB1bmF2YWlsYWJsZSByYW5nZXMKWyAgICAw
LjAwNTA5OF0gT24gbm9kZSAwLCB6b25lIERNQTMyOiAxMyBwYWdlcyBpbiB1bmF2YWlsYWJsZSBy
YW5nZXMKWyAgICAwLjAwNTM0OV0gT24gbm9kZSAwLCB6b25lIERNQTMyOiAyMzY3NCBwYWdlcyBp
biB1bmF2YWlsYWJsZSByYW5nZXMKWyAgICAwLjAyNzI5NV0gT24gbm9kZSAwLCB6b25lIE5vcm1h
bDogODE5MiBwYWdlcyBpbiB1bmF2YWlsYWJsZSByYW5nZXMKWyAgICAwLjAyNzMyOF0gT24gbm9k
ZSAwLCB6b25lIE5vcm1hbDogMzI2NCBwYWdlcyBpbiB1bmF2YWlsYWJsZSByYW5nZXMKWyAgICAw
LjAyNzU5N10gQUNQSTogUE0tVGltZXIgSU8gUG9ydDogMHg4MDgKWyAgICAwLjAyNzYwM10gQUNQ
STogTEFQSUNfTk1JIChhY3BpX2lkWzB4ZmZdIGhpZ2ggZWRnZSBsaW50WzB4MV0pClsgICAgMC4w
Mjc2MTNdIElPQVBJQ1swXTogYXBpY19pZCAxMywgdmVyc2lvbiAzMywgYWRkcmVzcyAweGZlYzAw
MDAwLCBHU0kgMC0yMwpbICAgIDAuMDI3NjE5XSBJT0FQSUNbMV06IGFwaWNfaWQgMTQsIHZlcnNp
b24gMzMsIGFkZHJlc3MgMHhmZWMwMTAwMCwgR1NJIDI0LTU1ClsgICAgMC4wMjc2MjJdIEFDUEk6
IElOVF9TUkNfT1ZSIChidXMgMCBidXNfaXJxIDAgZ2xvYmFsX2lycSAyIGRmbCBkZmwpClsgICAg
MC4wMjc2MjNdIEFDUEk6IElOVF9TUkNfT1ZSIChidXMgMCBidXNfaXJxIDkgZ2xvYmFsX2lycSA5
IGxvdyBsZXZlbCkKWyAgICAwLjAyNzYyNl0gQUNQSTogVXNpbmcgQUNQSSAoTUFEVCkgZm9yIFNN
UCBjb25maWd1cmF0aW9uIGluZm9ybWF0aW9uClsgICAgMC4wMjc2MjddIEFDUEk6IEhQRVQgaWQ6
IDB4MTAyMjgyMDEgYmFzZTogMHhmZWQwMDAwMApbICAgIDAuMDI3NjM5XSBlODIwOiB1cGRhdGUg
W21lbSAweGE0N2IxMDAwLTB4YTQ3YzRmZmZdIHVzYWJsZSA9PT4gcmVzZXJ2ZWQKWyAgICAwLjAy
NzY0N10gc21wYm9vdDogQWxsb3dpbmcgMTYgQ1BVcywgNCBob3RwbHVnIENQVXMKWyAgICAwLjAy
NzY2M10gW21lbSAweGIwMDAwMDAwLTB4ZWZmZmZmZmZdIGF2YWlsYWJsZSBmb3IgUENJIGRldmlj
ZXMKWyAgICAwLjAyNzY2Nl0gY2xvY2tzb3VyY2U6IHJlZmluZWQtamlmZmllczogbWFzazogMHhm
ZmZmZmZmZiBtYXhfY3ljbGVzOiAweGZmZmZmZmZmLCBtYXhfaWRsZV9uczogMTkxMDk2OTk0MDM5
MTQxOSBucwpbICAgIDAuMDMyODI0XSBzZXR1cF9wZXJjcHU6IE5SX0NQVVM6MjU2IG5yX2NwdW1h
c2tfYml0czoyNTYgbnJfY3B1X2lkczoxNiBucl9ub2RlX2lkczoxClsgICAgMC4wMzMyOTJdIHBl
cmNwdTogRW1iZWRkZWQgNTYgcGFnZXMvY3B1IHMxOTI1MTIgcjgxOTIgZDI4NjcyIHUyNjIxNDQK
WyAgICAwLjAzMzI5OF0gcGNwdS1hbGxvYzogczE5MjUxMiByODE5MiBkMjg2NzIgdTI2MjE0NCBh
bGxvYz0xKjIwOTcxNTIKWyAgICAwLjAzMzMwMF0gcGNwdS1hbGxvYzogWzBdIDAwIDAxIDAyIDAz
IDA0IDA1IDA2IDA3IFswXSAwOCAwOSAxMCAxMSAxMiAxMyAxNCAxNSAKWyAgICAwLjAzMzMxN10g
QnVpbHQgMSB6b25lbGlzdHMsIG1vYmlsaXR5IGdyb3VwaW5nIG9uLiAgVG90YWwgcGFnZXM6IDM5
NjQ1OTQKWyAgICAwLjAzMzMxOV0gS2VybmVsIGNvbW1hbmQgbGluZTogcm9vdD0vZGV2L252bWUw
bjFwNCBybyBybyByb290PS9kZXYvbnZtZTBuMXA0ClsgICAgMC4wMzQ5NDRdIERlbnRyeSBjYWNo
ZSBoYXNoIHRhYmxlIGVudHJpZXM6IDIwOTcxNTIgKG9yZGVyOiAxMiwgMTY3NzcyMTYgYnl0ZXMs
IGxpbmVhcikKWyAgICAwLjAzNTc3MF0gSW5vZGUtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAx
MDQ4NTc2IChvcmRlcjogMTEsIDgzODg2MDggYnl0ZXMsIGxpbmVhcikKWyAgICAwLjAzNTgxMl0g
bWVtIGF1dG8taW5pdDogc3RhY2s6b2ZmLCBoZWFwIGFsbG9jOm9mZiwgaGVhcCBmcmVlOm9mZgpb
ICAgIDAuMDcyMTU4XSBNZW1vcnk6IDE1NjUwMzYwSy8xNjExMDc1MksgYXZhaWxhYmxlICgyMDQ5
N0sga2VybmVsIGNvZGUsIDI4OTdLIHJ3ZGF0YSwgODAwMEsgcm9kYXRhLCAxMjM2SyBpbml0LCAz
ODUySyBic3MsIDQ2MDEzMksgcmVzZXJ2ZWQsIDBLIGNtYS1yZXNlcnZlZCkKWyAgICAwLjA3MjE2
NV0gcmFuZG9tOiBnZXRfcmFuZG9tX3U2NCBjYWxsZWQgZnJvbSBfX2ttZW1fY2FjaGVfY3JlYXRl
KzB4MWYvMHg0ZDAgd2l0aCBjcm5nX2luaXQ9MApbICAgIDAuMDcyMjY0XSBTTFVCOiBIV2FsaWdu
PTY0LCBPcmRlcj0wLTMsIE1pbk9iamVjdHM9MCwgQ1BVcz0xNiwgTm9kZXM9MQpbICAgIDAuMDcy
MzE2XSBEeW5hbWljIFByZWVtcHQ6IGZ1bGwKWyAgICAwLjA3MjM0N10gcmN1OiBQcmVlbXB0aWJs
ZSBoaWVyYXJjaGljYWwgUkNVIGltcGxlbWVudGF0aW9uLgpbICAgIDAuMDcyMzQ3XSByY3U6IAlS
Q1UgcmVzdHJpY3RpbmcgQ1BVcyBmcm9tIE5SX0NQVVM9MjU2IHRvIG5yX2NwdV9pZHM9MTYuClsg
ICAgMC4wNzIzNDldIAlUcmFtcG9saW5lIHZhcmlhbnQgb2YgVGFza3MgUkNVIGVuYWJsZWQuClsg
ICAgMC4wNzIzNTBdIHJjdTogUkNVIGNhbGN1bGF0ZWQgdmFsdWUgb2Ygc2NoZWR1bGVyLWVubGlz
dG1lbnQgZGVsYXkgaXMgMTAwIGppZmZpZXMuClsgICAgMC4wNzIzNTFdIHJjdTogQWRqdXN0aW5n
IGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9MTYKWyAgICAwLjA3
MzQzNF0gTlJfSVJRUzogMTY2NDAsIG5yX2lycXM6IDEwOTYsIHByZWFsbG9jYXRlZCBpcnFzOiAx
NgpbICAgIDAuMDczNjYwXSBDb25zb2xlOiBjb2xvdXIgZHVtbXkgZGV2aWNlIDgweDI1ClsgICAg
MC4wNzM4MzFdIHByaW50azogY29uc29sZSBbdHR5MF0gZW5hYmxlZApbICAgIDAuMDczODQxXSBB
Q1BJOiBDb3JlIHJldmlzaW9uIDIwMjExMjE3ClsgICAgMC4wNzQwMTddIGNsb2Nrc291cmNlOiBo
cGV0OiBtYXNrOiAweGZmZmZmZmZmIG1heF9jeWNsZXM6IDB4ZmZmZmZmZmYsIG1heF9pZGxlX25z
OiAxMzM0ODQ4NzM1MDQgbnMKWyAgICAwLjA3NDAzNF0gQVBJQzogU3dpdGNoIHRvIHN5bW1ldHJp
YyBJL08gbW9kZSBzZXR1cApbICAgIDAuMDc0NzUwXSBBTUQtVmk6IGl2cnMsIGFkZCBoaWQ6QU1E
STAwMjAsIHVpZDpcX1NCLkZVUjAsIHJkZXZpZDoxNjAKWyAgICAwLjA3NDc1Ml0gQU1ELVZpOiBp
dnJzLCBhZGQgaGlkOkFNREkwMDIwLCB1aWQ6XF9TQi5GVVIxLCByZGV2aWQ6MTYwClsgICAgMC4w
NzQ3NTRdIEFNRC1WaTogaXZycywgYWRkIGhpZDpBTURJMDAyMCwgdWlkOlxfU0IuRlVSMiwgcmRl
dmlkOjE2MApbICAgIDAuMDc0NzU1XSBBTUQtVmk6IGl2cnMsIGFkZCBoaWQ6QU1ESTAwMjAsIHVp
ZDpcX1NCLkZVUjMsIHJkZXZpZDoxNjAKWyAgICAwLjA3NDk5OV0gU3dpdGNoZWQgQVBJQyByb3V0
aW5nIHRvIHBoeXNpY2FsIGZsYXQuClsgICAgMC4wNzU1NjldIC4uVElNRVI6IHZlY3Rvcj0weDMw
IGFwaWMxPTAgcGluMT0yIGFwaWMyPS0xIHBpbjI9LTEKWyAgICAwLjA4MDAzNl0gY2xvY2tzb3Vy
Y2U6IHRzYy1lYXJseTogbWFzazogMHhmZmZmZmZmZmZmZmZmZmZmIG1heF9jeWNsZXM6IDB4MmIy
OTE5MDYyMDQsIG1heF9pZGxlX25zOiA0NDA3OTUyNjkwMTggbnMKWyAgICAwLjA4MDA0N10gQ2Fs
aWJyYXRpbmcgZGVsYXkgbG9vcCAoc2tpcHBlZCksIHZhbHVlIGNhbGN1bGF0ZWQgdXNpbmcgdGlt
ZXIgZnJlcXVlbmN5Li4gNTk4OC41MiBCb2dvTUlQUyAobHBqPTI5OTQyNjIpClsgICAgMC4wODAw
NTBdIHBpZF9tYXg6IGRlZmF1bHQ6IDMyNzY4IG1pbmltdW06IDMwMQpbICAgIDAuMDgxNzkzXSBN
b3VudC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDMyNzY4IChvcmRlcjogNiwgMjYyMTQ0IGJ5
dGVzLCBsaW5lYXIpClsgICAgMC4wODE4MjFdIE1vdW50cG9pbnQtY2FjaGUgaGFzaCB0YWJsZSBl
bnRyaWVzOiAzMjc2OCAob3JkZXI6IDYsIDI2MjE0NCBieXRlcywgbGluZWFyKQpbICAgIDAuMDgx
OTg0XSB4ODYvY3B1OiBVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24gUHJldmVudGlvbiAoVU1JUCkgYWN0
aXZhdGVkClsgICAgMC4wODIwMjBdIExWVCBvZmZzZXQgMSBhc3NpZ25lZCBmb3IgdmVjdG9yIDB4
ZjkKWyAgICAwLjA4MjA4M10gTFZUIG9mZnNldCAyIGFzc2lnbmVkIGZvciB2ZWN0b3IgMHhmNApb
ICAgIDAuMDgyMTAwXSBMYXN0IGxldmVsIGlUTEIgZW50cmllczogNEtCIDEwMjQsIDJNQiAxMDI0
LCA0TUIgNTEyClsgICAgMC4wODIxMDJdIExhc3QgbGV2ZWwgZFRMQiBlbnRyaWVzOiA0S0IgMjA0
OCwgMk1CIDIwNDgsIDRNQiAxMDI0LCAxR0IgMApbICAgIDAuMDgyMTA2XSBTcGVjdHJlIFYxIDog
TWl0aWdhdGlvbjogdXNlcmNvcHkvc3dhcGdzIGJhcnJpZXJzIGFuZCBfX3VzZXIgcG9pbnRlciBz
YW5pdGl6YXRpb24KWyAgICAwLjA4MjEwOV0gU3BlY3RyZSBWMiA6IE1pdGlnYXRpb246IFJldHBv
bGluZXMKWyAgICAwLjA4MjExMF0gU3BlY3RyZSBWMiA6IFNwZWN0cmUgdjIgLyBTcGVjdHJlUlNC
IG1pdGlnYXRpb246IEZpbGxpbmcgUlNCIG9uIGNvbnRleHQgc3dpdGNoClsgICAgMC4wODIxMTJd
IFNwZWN0cmUgVjIgOiBFbmFibGluZyBSZXN0cmljdGVkIFNwZWN1bGF0aW9uIGZvciBmaXJtd2Fy
ZSBjYWxscwpbICAgIDAuMDgyMTEzXSBTcGVjdHJlIFYyIDogbWl0aWdhdGlvbjogRW5hYmxpbmcg
Y29uZGl0aW9uYWwgSW5kaXJlY3QgQnJhbmNoIFByZWRpY3Rpb24gQmFycmllcgpbICAgIDAuMDgy
MTE1XSBTcGVjdHJlIFYyIDogVXNlciBzcGFjZTogTWl0aWdhdGlvbjogU1RJQlAgdmlhIHByY3Rs
ClsgICAgMC4wODIxMTddIFNwZWN1bGF0aXZlIFN0b3JlIEJ5cGFzczogTWl0aWdhdGlvbjogU3Bl
Y3VsYXRpdmUgU3RvcmUgQnlwYXNzIGRpc2FibGVkIHZpYSBwcmN0bApbICAgIDAuMDgzNjAzXSBG
cmVlaW5nIFNNUCBhbHRlcm5hdGl2ZXMgbWVtb3J5OiA0OEsKWyAgICAwLjE4NjQ1MV0gc21wYm9v
dDogQ1BVMDogQU1EIFJ5emVuIDUgNDYwMEggd2l0aCBSYWRlb24gR3JhcGhpY3MgKGZhbWlseTog
MHgxNywgbW9kZWw6IDB4NjAsIHN0ZXBwaW5nOiAweDEpClsgICAgMC4xODY1NDFdIGNibGlzdF9p
bml0X2dlbmVyaWM6IFNldHRpbmcgYWRqdXN0YWJsZSBudW1iZXIgb2YgY2FsbGJhY2sgcXVldWVz
LgpbICAgIDAuMTg2NTQ1XSBjYmxpc3RfaW5pdF9nZW5lcmljOiBTZXR0aW5nIHNoaWZ0IHRvIDQg
YW5kIGxpbSB0byAxLgpbICAgIDAuMTg2NTU1XSBQZXJmb3JtYW5jZSBFdmVudHM6IEZhbTE3aCsg
Y29yZSBwZXJmY3RyLCBBTUQgUE1VIGRyaXZlci4KWyAgICAwLjE4NjU2MV0gLi4uIHZlcnNpb246
ICAgICAgICAgICAgICAgIDAKWyAgICAwLjE4NjU2Ml0gLi4uIGJpdCB3aWR0aDogICAgICAgICAg
ICAgIDQ4ClsgICAgMC4xODY1NjNdIC4uLiBnZW5lcmljIHJlZ2lzdGVyczogICAgICA2ClsgICAg
MC4xODY1NjVdIC4uLiB2YWx1ZSBtYXNrOiAgICAgICAgICAgICAwMDAwZmZmZmZmZmZmZmZmClsg
ICAgMC4xODY1NjZdIC4uLiBtYXggcGVyaW9kOiAgICAgICAgICAgICAwMDAwN2ZmZmZmZmZmZmZm
ClsgICAgMC4xODY1NjhdIC4uLiBmaXhlZC1wdXJwb3NlIGV2ZW50czogICAwClsgICAgMC4xODY1
NjldIC4uLiBldmVudCBtYXNrOiAgICAgICAgICAgICAwMDAwMDAwMDAwMDAwMDNmClsgICAgMC4x
ODY2MTldIHJjdTogSGllcmFyY2hpY2FsIFNSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4xODY3
NjFdIHNtcDogQnJpbmdpbmcgdXAgc2Vjb25kYXJ5IENQVXMgLi4uClsgICAgMC4xODY4MTVdIHg4
NjogQm9vdGluZyBTTVAgY29uZmlndXJhdGlvbjoKWyAgICAwLjE4NjgxN10gLi4uLiBub2RlICAj
MCwgQ1BVczogICAgICAgICMxICAjMiAgIzMgICM0ICAjNSAgIzYgICM3ICAjOCAgIzkgIzEwICMx
MQpbICAgIDAuMTk5MDc5XSBzbXA6IEJyb3VnaHQgdXAgMSBub2RlLCAxMiBDUFVzClsgICAgMC4x
OTkwODVdIHNtcGJvb3Q6IE1heCBsb2dpY2FsIHBhY2thZ2VzOiAyClsgICAgMC4xOTkwODddIHNt
cGJvb3Q6IFRvdGFsIG9mIDEyIHByb2Nlc3NvcnMgYWN0aXZhdGVkICg3MTg2Mi4yOCBCb2dvTUlQ
UykKWyAgICAwLjIwMDMxOV0gZGV2dG1wZnM6IGluaXRpYWxpemVkClsgICAgMC4yMDAzMTldIEFD
UEk6IFBNOiBSZWdpc3RlcmluZyBBQ1BJIE5WUyByZWdpb24gW21lbSAweDBhMjAwMDAwLTB4MGEy
MGNmZmZdICg1MzI0OCBieXRlcykKWyAgICAwLjIwMDMxOV0gQUNQSTogUE06IFJlZ2lzdGVyaW5n
IEFDUEkgTlZTIHJlZ2lvbiBbbWVtIDB4YTc1NDAwMDAtMHhhNzZlZWZmZl0gKDE3NjUzNzYgYnl0
ZXMpClsgICAgMC4yMDAzMTldIGNsb2Nrc291cmNlOiBqaWZmaWVzOiBtYXNrOiAweGZmZmZmZmZm
IG1heF9jeWNsZXM6IDB4ZmZmZmZmZmYsIG1heF9pZGxlX25zOiAxOTExMjYwNDQ2Mjc1MDAwIG5z
ClsgICAgMC4yMDEwNDVdIGZ1dGV4IGhhc2ggdGFibGUgZW50cmllczogNDA5NiAob3JkZXI6IDYs
IDI2MjE0NCBieXRlcywgbGluZWFyKQpbICAgIDAuMjAxMDgyXSBwaW5jdHJsIGNvcmU6IGluaXRp
YWxpemVkIHBpbmN0cmwgc3Vic3lzdGVtClsgICAgMC4yMDExNjNdIE5FVDogUmVnaXN0ZXJlZCBQ
Rl9ORVRMSU5LL1BGX1JPVVRFIHByb3RvY29sIGZhbWlseQpbICAgIDAuMjAxMjA4XSBETUE6IHBy
ZWFsbG9jYXRlZCAyMDQ4IEtpQiBHRlBfS0VSTkVMIHBvb2wgZm9yIGF0b21pYyBhbGxvY2F0aW9u
cwpbICAgIDAuMjAxMjE0XSBETUE6IHByZWFsbG9jYXRlZCAyMDQ4IEtpQiBHRlBfS0VSTkVMfEdG
UF9ETUEgcG9vbCBmb3IgYXRvbWljIGFsbG9jYXRpb25zClsgICAgMC4yMDEyMTldIERNQTogcHJl
YWxsb2NhdGVkIDIwNDggS2lCIEdGUF9LRVJORUx8R0ZQX0RNQTMyIHBvb2wgZm9yIGF0b21pYyBh
bGxvY2F0aW9ucwpbICAgIDAuMjAxMjU1XSB0aGVybWFsX3N5czogUmVnaXN0ZXJlZCB0aGVybWFs
IGdvdmVybm9yICdmYWlyX3NoYXJlJwpbICAgIDAuMjAxMjU2XSB0aGVybWFsX3N5czogUmVnaXN0
ZXJlZCB0aGVybWFsIGdvdmVybm9yICdiYW5nX2JhbmcnClsgICAgMC4yMDEyNTddIHRoZXJtYWxf
c3lzOiBSZWdpc3RlcmVkIHRoZXJtYWwgZ292ZXJub3IgJ3N0ZXBfd2lzZScKWyAgICAwLjIwMTI1
OV0gdGhlcm1hbF9zeXM6IFJlZ2lzdGVyZWQgdGhlcm1hbCBnb3Zlcm5vciAndXNlcl9zcGFjZScK
WyAgICAwLjIwMTI2N10gY3B1aWRsZTogdXNpbmcgZ292ZXJub3IgbGFkZGVyClsgICAgMC4yMDEy
NzBdIGNwdWlkbGU6IHVzaW5nIGdvdmVybm9yIG1lbnUKWyAgICAwLjIwMTI5Ml0gQUNQSSBGQURU
IGRlY2xhcmVzIHRoZSBzeXN0ZW0gZG9lc24ndCBzdXBwb3J0IFBDSWUgQVNQTSwgc28gZGlzYWJs
ZSBpdApbICAgIDAuMjAxMjkyXSBQQ0k6IE1NQ09ORklHIGZvciBkb21haW4gMDAwMCBbYnVzIDAw
LTdmXSBhdCBbbWVtIDB4ZjAwMDAwMDAtMHhmN2ZmZmZmZl0gKGJhc2UgMHhmMDAwMDAwMCkKWyAg
ICAwLjIwMTI5Ml0gUENJOiBNTUNPTkZJRyBhdCBbbWVtIDB4ZjAwMDAwMDAtMHhmN2ZmZmZmZl0g
cmVzZXJ2ZWQgaW4gRTgyMApbICAgIDAuMjAxMjkyXSBQQ0k6IFVzaW5nIGNvbmZpZ3VyYXRpb24g
dHlwZSAxIGZvciBiYXNlIGFjY2VzcwpbICAgIDAuMjAzNjczXSBjcnlwdGQ6IG1heF9jcHVfcWxl
biBzZXQgdG8gMTAwMApbICAgIDAuMjA0MDcwXSBBQ1BJOiBBZGRlZCBfT1NJKE1vZHVsZSBEZXZp
Y2UpClsgICAgMC4yMDQwNzNdIEFDUEk6IEFkZGVkIF9PU0koUHJvY2Vzc29yIERldmljZSkKWyAg
ICAwLjIwNDA3NF0gQUNQSTogQWRkZWQgX09TSSgzLjAgX1NDUCBFeHRlbnNpb25zKQpbICAgIDAu
MjA0MDc1XSBBQ1BJOiBBZGRlZCBfT1NJKFByb2Nlc3NvciBBZ2dyZWdhdG9yIERldmljZSkKWyAg
ICAwLjIwNDA3N10gQUNQSTogQWRkZWQgX09TSShMaW51eC1EZWxsLVZpZGVvKQpbICAgIDAuMjA0
MDc5XSBBQ1BJOiBBZGRlZCBfT1NJKExpbnV4LUxlbm92by1OVi1IRE1JLUF1ZGlvKQpbICAgIDAu
MjA0MDgwXSBBQ1BJOiBBZGRlZCBfT1NJKExpbnV4LUhQSS1IeWJyaWQtR3JhcGhpY3MpClsgICAg
MC4yMTE0MzddIEFDUEkgQklPUyBFcnJvciAoYnVnKTogQ291bGQgbm90IHJlc29sdmUgc3ltYm9s
IFtcX1NCLlBDSTAuR1BQMS5XTEFOXSwgQUVfTk9UX0ZPVU5EICgyMDIxMTIxNy9kc3dsb2FkMi0x
NjIpClsgICAgMC4yMTE0NDNdIEFDUEkgRXJyb3I6IEFFX05PVF9GT1VORCwgRHVyaW5nIG5hbWUg
bG9va3VwL2NhdGFsb2cgKDIwMjExMjE3L3Bzb2JqZWN0LTIyMCkKWyAgICAwLjIxMTQ0Nl0gQUNQ
STogU2tpcHBpbmcgcGFyc2Ugb2YgQU1MIG9wY29kZTogT3Bjb2RlTmFtZSB1bmF2YWlsYWJsZSAo
MHgwMDEwKQpbICAgIDAuMjEyNjQwXSBBQ1BJOiAxMyBBQ1BJIEFNTCB0YWJsZXMgc3VjY2Vzc2Z1
bGx5IGFjcXVpcmVkIGFuZCBsb2FkZWQKWyAgICAwLjIxMzQ0OV0gQUNQSTogW0Zpcm13YXJlIEJ1
Z106IEJJT1MgX09TSShMaW51eCkgcXVlcnkgaWdub3JlZApbICAgIDAuMjE0NDk0XSBBQ1BJOiBF
QzogRUMgc3RhcnRlZApbICAgIDAuMjE0NDk2XSBBQ1BJOiBFQzogaW50ZXJydXB0IGJsb2NrZWQK
WyAgICAwLjU0NDY4Ml0gQUNQSTogRUM6IEVDX0NNRC9FQ19TQz0weDY2LCBFQ19EQVRBPTB4NjIK
WyAgICAwLjU0NDY4N10gQUNQSTogXF9TQl8uUENJMC5TQlJHLkVDMF86IEJvb3QgRFNEVCBFQyB1
c2VkIHRvIGhhbmRsZSB0cmFuc2FjdGlvbnMKWyAgICAwLjU0NDY5MV0gQUNQSTogSW50ZXJwcmV0
ZXIgZW5hYmxlZApbICAgIDAuNTQ0NzA2XSBBQ1BJOiBQTTogKHN1cHBvcnRzIFMwIFMzIFM1KQpb
ICAgIDAuNTQ0NzA5XSBBQ1BJOiBVc2luZyBJT0FQSUMgZm9yIGludGVycnVwdCByb3V0aW5nClsg
ICAgMC41NDQ4ODNdIFBDSTogVXNpbmcgaG9zdCBicmlkZ2Ugd2luZG93cyBmcm9tIEFDUEk7IGlm
IG5lY2Vzc2FyeSwgdXNlICJwY2k9bm9jcnMiIGFuZCByZXBvcnQgYSBidWcKWyAgICAwLjU0NTE5
OF0gQUNQSTogRW5hYmxlZCA1IEdQRXMgaW4gYmxvY2sgMDAgdG8gMUYKWyAgICAwLjU0NjYxN10g
QUNQSTogUE06IFBvd2VyIFJlc291cmNlIFtQMFMwXQpbICAgIDAuNTQ2NjQyXSBBQ1BJOiBQTTog
UG93ZXIgUmVzb3VyY2UgW1AzUzBdClsgICAgMC41NDY3MTFdIEFDUEk6IFBNOiBQb3dlciBSZXNv
dXJjZSBbUDBTMV0KWyAgICAwLjU0NjczM10gQUNQSTogUE06IFBvd2VyIFJlc291cmNlIFtQM1Mx
XQpbICAgIDAuNTQ3MzUyXSBBQ1BJOiBQTTogUG93ZXIgUmVzb3VyY2UgW1BHMDBdClsgICAgMC41
NTQzMTNdIEFDUEk6IFBNOiBQb3dlciBSZXNvdXJjZSBbUFJXTF0KWyAgICAwLjU1NDcyNF0gQUNQ
STogUENJIFJvb3QgQnJpZGdlIFtQQ0kwXSAoZG9tYWluIDAwMDAgW2J1cyAwMC1mZl0pClsgICAg
MC41NTQ3MzJdIGFjcGkgUE5QMEEwODowMDogX09TQzogT1Mgc3VwcG9ydHMgW0V4dGVuZGVkQ29u
ZmlnIEFTUE0gQ2xvY2tQTSBTZWdtZW50cyBNU0kgSFBYLVR5cGUzXQpbICAgIDAuNTU0NzM2XSBh
Y3BpIFBOUDBBMDg6MDA6IFBDSWUgcG9ydCBzZXJ2aWNlcyBkaXNhYmxlZDsgbm90IHJlcXVlc3Rp
bmcgX09TQyBjb250cm9sClsgICAgMC41NTQ4MDhdIGFjcGkgUE5QMEEwODowMDogRkFEVCBpbmRp
Y2F0ZXMgQVNQTSBpcyB1bnN1cHBvcnRlZCwgdXNpbmcgQklPUyBjb25maWd1cmF0aW9uClsgICAg
MC41NTQ4MTJdIGFjcGkgUE5QMEEwODowMDogW0Zpcm13YXJlIEluZm9dOiBNTUNPTkZJRyBmb3Ig
ZG9tYWluIDAwMDAgW2J1cyAwMC03Zl0gb25seSBwYXJ0aWFsbHkgY292ZXJzIHRoaXMgYnJpZGdl
ClsgICAgMC41NTUwMzJdIFBDSSBob3N0IGJyaWRnZSB0byBidXMgMDAwMDowMApbICAgIDAuNTU1
MDM1XSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAgMHgwMDAwLTB4MDNh
ZiB3aW5kb3ddClsgICAgMC41NTUwMzldIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3Vy
Y2UgW2lvICAweDAzZTAtMHgwY2Y3IHdpbmRvd10KWyAgICAwLjU1NTA0NF0gcGNpX2J1cyAwMDAw
OjAwOiByb290IGJ1cyByZXNvdXJjZSBbaW8gIDB4MDNiMC0weDAzZGYgd2luZG93XQpbICAgIDAu
NTU1MDQ3XSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAgMHgwZDAwLTB4
ZmZmZiB3aW5kb3ddClsgICAgMC41NTUwNTBdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVz
b3VyY2UgW21lbSAweDAwMGEwMDAwLTB4MDAwZGZmZmYgd2luZG93XQpbICAgIDAuNTU1MDUzXSBw
Y2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFttZW0gMHhiMDAwMDAwMC0weGZlYmZm
ZmZmIHdpbmRvd10KWyAgICAwLjU1NTA1N10gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNv
dXJjZSBbbWVtIDB4ZmVlMDAwMDAtMHhmZmZmZmZmZiB3aW5kb3ddClsgICAgMC41NTUwNjFdIHBj
aV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW2J1cyAwMC1mZl0KWyAgICAwLjU1NTA3
NF0gcGNpIDAwMDA6MDA6MDAuMDogWzEwMjI6MTYzMF0gdHlwZSAwMCBjbGFzcyAweDA2MDAwMApb
ICAgIDAuNTU1MTU3XSBwY2kgMDAwMDowMDowMC4yOiBbMTAyMjoxNjMxXSB0eXBlIDAwIGNsYXNz
IDB4MDgwNjAwClsgICAgMC41NTUyNDNdIHBjaSAwMDAwOjAwOjAxLjA6IFsxMDIyOjE2MzJdIHR5
cGUgMDAgY2xhc3MgMHgwNjAwMDAKWyAgICAwLjU1NTMwNl0gcGNpIDAwMDA6MDA6MDEuMTogWzEw
MjI6MTYzM10gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDAuNTU1MzY2XSBwY2kgMDAwMDow
MDowMS4xOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuNTU1NDQw
XSBwY2kgMDAwMDowMDowMS4yOiBbMTAyMjoxNjM0XSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAwClsg
ICAgMC41NTU0NjVdIHBjaSAwMDAwOjAwOjAxLjI6IGVuYWJsaW5nIEV4dGVuZGVkIFRhZ3MKWyAg
ICAwLjU1NTUwNF0gcGNpIDAwMDA6MDA6MDEuMjogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hv
dCBEM2NvbGQKWyAgICAwLjU1NTU3NV0gcGNpIDAwMDA6MDA6MDIuMDogWzEwMjI6MTYzMl0gdHlw
ZSAwMCBjbGFzcyAweDA2MDAwMApbICAgIDAuNTU1NjM4XSBwY2kgMDAwMDowMDowMi4xOiBbMTAy
MjoxNjM0XSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAwClsgICAgMC41NTU2NjNdIHBjaSAwMDAwOjAw
OjAyLjE6IGVuYWJsaW5nIEV4dGVuZGVkIFRhZ3MKWyAgICAwLjU1NTcwMV0gcGNpIDAwMDA6MDA6
MDIuMTogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAwLjU1NTc2Nl0g
cGNpIDAwMDA6MDA6MDIuNDogWzEwMjI6MTYzNF0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAg
IDAuNTU1NzkyXSBwY2kgMDAwMDowMDowMi40OiBlbmFibGluZyBFeHRlbmRlZCBUYWdzClsgICAg
MC41NTU4MzBdIHBjaSAwMDAwOjAwOjAyLjQ6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3Qg
RDNjb2xkClsgICAgMC41NTU5MDBdIHBjaSAwMDAwOjAwOjA4LjA6IFsxMDIyOjE2MzJdIHR5cGUg
MDAgY2xhc3MgMHgwNjAwMDAKWyAgICAwLjU1NTk2MV0gcGNpIDAwMDA6MDA6MDguMTogWzEwMjI6
MTYzNV0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDAuNTU1OTg0XSBwY2kgMDAwMDowMDow
OC4xOiBlbmFibGluZyBFeHRlbmRlZCBUYWdzClsgICAgMC41NTYwMTZdIHBjaSAwMDAwOjAwOjA4
LjE6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkClsgICAgMC41NTYwODVdIHBj
aSAwMDAwOjAwOjA4LjI6IFsxMDIyOjE2MzVdIHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAgICAw
LjU1NjEwOV0gcGNpIDAwMDA6MDA6MDguMjogZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbICAgIDAu
NTU2MTQwXSBwY2kgMDAwMDowMDowOC4yOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQz
Y29sZApbICAgIDAuNTU2MjIzXSBwY2kgMDAwMDowMDoxNC4wOiBbMTAyMjo3OTBiXSB0eXBlIDAw
IGNsYXNzIDB4MGMwNTAwClsgICAgMC41NTYzMzZdIHBjaSAwMDAwOjAwOjE0LjM6IFsxMDIyOjc5
MGVdIHR5cGUgMDAgY2xhc3MgMHgwNjAxMDAKWyAgICAwLjU1NjQ1Nl0gcGNpIDAwMDA6MDA6MTgu
MDogWzEwMjI6MTQ0OF0gdHlwZSAwMCBjbGFzcyAweDA2MDAwMApbICAgIDAuNTU2NDk5XSBwY2kg
MDAwMDowMDoxOC4xOiBbMTAyMjoxNDQ5XSB0eXBlIDAwIGNsYXNzIDB4MDYwMDAwClsgICAgMC41
NTY1NDJdIHBjaSAwMDAwOjAwOjE4LjI6IFsxMDIyOjE0NGFdIHR5cGUgMDAgY2xhc3MgMHgwNjAw
MDAKWyAgICAwLjU1NjU4NV0gcGNpIDAwMDA6MDA6MTguMzogWzEwMjI6MTQ0Yl0gdHlwZSAwMCBj
bGFzcyAweDA2MDAwMApbICAgIDAuNTU2NjI4XSBwY2kgMDAwMDowMDoxOC40OiBbMTAyMjoxNDRj
XSB0eXBlIDAwIGNsYXNzIDB4MDYwMDAwClsgICAgMC41NTY2NzRdIHBjaSAwMDAwOjAwOjE4LjU6
IFsxMDIyOjE0NGRdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAKWyAgICAwLjU1NjcxN10gcGNpIDAw
MDA6MDA6MTguNjogWzEwMjI6MTQ0ZV0gdHlwZSAwMCBjbGFzcyAweDA2MDAwMApbICAgIDAuNTU2
NzYwXSBwY2kgMDAwMDowMDoxOC43OiBbMTAyMjoxNDRmXSB0eXBlIDAwIGNsYXNzIDB4MDYwMDAw
ClsgICAgMC41NTY4NTddIHBjaSAwMDAwOjAxOjAwLjA6IFsxMGRlOjFmOTVdIHR5cGUgMDAgY2xh
c3MgMHgwMzAwMDAKWyAgICAwLjU1Njg3MF0gcGNpIDAwMDA6MDE6MDAuMDogcmVnIDB4MTA6IFtt
ZW0gMHhmYjAwMDAwMC0weGZiZmZmZmZmXQpbICAgIDAuNTU2ODgxXSBwY2kgMDAwMDowMTowMC4w
OiByZWcgMHgxNDogW21lbSAweGIwMDAwMDAwLTB4YmZmZmZmZmYgNjRiaXQgcHJlZl0KWyAgICAw
LjU1Njg5M10gcGNpIDAwMDA6MDE6MDAuMDogcmVnIDB4MWM6IFttZW0gMHhjMDAwMDAwMC0weGMx
ZmZmZmZmIDY0Yml0IHByZWZdClsgICAgMC41NTY5MDBdIHBjaSAwMDAwOjAxOjAwLjA6IHJlZyAw
eDI0OiBbaW8gIDB4ZjAwMC0weGYwN2ZdClsgICAgMC41NTY5MDhdIHBjaSAwMDAwOjAxOjAwLjA6
IHJlZyAweDMwOiBbbWVtIDB4ZmMwMDAwMDAtMHhmYzA3ZmZmZiBwcmVmXQpbICAgIDAuNTU2OTY3
XSBwY2kgMDAwMDowMTowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApb
ICAgIDAuNTU3MDE0XSBwY2kgMDAwMDowMTowMC4wOiA2My4wMDggR2IvcyBhdmFpbGFibGUgUENJ
ZSBiYW5kd2lkdGgsIGxpbWl0ZWQgYnkgOC4wIEdUL3MgUENJZSB4OCBsaW5rIGF0IDAwMDA6MDA6
MDEuMSAoY2FwYWJsZSBvZiAxMjYuMDE2IEdiL3Mgd2l0aCA4LjAgR1QvcyBQQ0llIHgxNiBsaW5r
KQpbICAgIDAuNTU3MzM0XSBwY2kgMDAwMDowMTowMC4xOiBbMTBkZToxMGZhXSB0eXBlIDAwIGNs
YXNzIDB4MDQwMzAwClsgICAgMC41NTczNDddIHBjaSAwMDAwOjAxOjAwLjE6IHJlZyAweDEwOiBb
bWVtIDB4ZmMwODAwMDAtMHhmYzA4M2ZmZl0KWyAgICAwLjU1NzQ4Ml0gcGNpIDAwMDA6MDA6MDEu
MTogUENJIGJyaWRnZSB0byBbYnVzIDAxXQpbICAgIDAuNTU3NDg3XSBwY2kgMDAwMDowMDowMS4x
OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGYwMDAtMHhmZmZmXQpbICAgIDAuNTU3NDkxXSBwY2kg
MDAwMDowMDowMS4xOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZiMDAwMDAwLTB4ZmMwZmZmZmZd
ClsgICAgMC41NTc0OTZdIHBjaSAwMDAwOjAwOjAxLjE6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4
YjAwMDAwMDAtMHhjMWZmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDAuNTU3NTQyXSBwY2kgMDAwMDow
MjowMC4wOiBbMTBlYzo4MTY4XSB0eXBlIDAwIGNsYXNzIDB4MDIwMDAwClsgICAgMC41NTc1NThd
IHBjaSAwMDAwOjAyOjAwLjA6IHJlZyAweDEwOiBbaW8gIDB4ZTAwMC0weGUwZmZdClsgICAgMC41
NTc1NzhdIHBjaSAwMDAwOjAyOjAwLjA6IHJlZyAweDE4OiBbbWVtIDB4ZmM5MDQwMDAtMHhmYzkw
NGZmZiA2NGJpdF0KWyAgICAwLjU1NzU5Ml0gcGNpIDAwMDA6MDI6MDAuMDogcmVnIDB4MjA6IFtt
ZW0gMHhmYzkwMDAwMC0weGZjOTAzZmZmIDY0Yml0XQpbICAgIDAuNTU3NjgwXSBwY2kgMDAwMDow
MjowMC4wOiBzdXBwb3J0cyBEMSBEMgpbICAgIDAuNTU3NjgzXSBwY2kgMDAwMDowMjowMC4wOiBQ
TUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQxIEQyIEQzaG90IEQzY29sZApbICAgIDAuNTU3ODA1XSBw
Y2kgMDAwMDowMDowMS4yOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDJdClsgICAgMC41NTc4MDldIHBj
aSAwMDAwOjAwOjAxLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0weGVmZmZdClsgICAg
MC41NTc4MTNdIHBjaSAwMDAwOjAwOjAxLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmM5MDAw
MDAtMHhmYzlmZmZmZl0KWyAgICAwLjU1Nzg4Nl0gcGNpIDAwMDA6MDM6MDAuMDogWzEwZWM6Yzgy
Ml0gdHlwZSAwMCBjbGFzcyAweDAyODAwMApbICAgIDAuNTU3OTA3XSBwY2kgMDAwMDowMzowMC4w
OiByZWcgMHgxMDogW2lvICAweGQwMDAtMHhkMGZmXQpbICAgIDAuNTU3OTMyXSBwY2kgMDAwMDow
MzowMC4wOiByZWcgMHgxODogW21lbSAweGZjODAwMDAwLTB4ZmM4MGZmZmYgNjRiaXRdClsgICAg
MC41NTgwNDhdIHBjaSAwMDAwOjAzOjAwLjA6IHN1cHBvcnRzIEQxIEQyClsgICAgMC41NTgwNTFd
IHBjaSAwMDAwOjAzOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDEgRDIgRDNob3QgRDNj
b2xkClsgICAgMC41NTgyMDFdIHBjaSAwMDAwOjAwOjAyLjE6IFBDSSBicmlkZ2UgdG8gW2J1cyAw
M10KWyAgICAwLjU1ODIwNl0gcGNpIDAwMDA6MDA6MDIuMTogICBicmlkZ2Ugd2luZG93IFtpbyAg
MHhkMDAwLTB4ZGZmZl0KWyAgICAwLjU1ODIwOV0gcGNpIDAwMDA6MDA6MDIuMTogICBicmlkZ2Ug
d2luZG93IFttZW0gMHhmYzgwMDAwMC0weGZjOGZmZmZmXQpbICAgIDAuNTU4MjU0XSBwY2kgMDAw
MDowNDowMC4wOiBbMWM1YzoxMzM5XSB0eXBlIDAwIGNsYXNzIDB4MDEwODAyClsgICAgMC41NTgy
NzVdIHBjaSAwMDAwOjA0OjAwLjA6IHJlZyAweDEwOiBbbWVtIDB4ZmM3MDAwMDAtMHhmYzcwM2Zm
ZiA2NGJpdF0KWyAgICAwLjU1ODM4OV0gcGNpIDAwMDA6MDQ6MDAuMDogc3VwcG9ydHMgRDEKWyAg
ICAwLjU1ODM5MV0gcGNpIDAwMDA6MDQ6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEMSBE
M2hvdApbICAgIDAuNTU4NDQ2XSBwY2kgMDAwMDowNDowMC4wOiAxNi4wMDAgR2IvcyBhdmFpbGFi
bGUgUENJZSBiYW5kd2lkdGgsIGxpbWl0ZWQgYnkgNS4wIEdUL3MgUENJZSB4NCBsaW5rIGF0IDAw
MDA6MDA6MDIuNCAoY2FwYWJsZSBvZiAzMS41MDQgR2IvcyB3aXRoIDguMCBHVC9zIFBDSWUgeDQg
bGluaykKWyAgICAwLjU1ODUwNF0gcGNpIDAwMDA6MDA6MDIuNDogUENJIGJyaWRnZSB0byBbYnVz
IDA0XQpbICAgIDAuNTU4NTEwXSBwY2kgMDAwMDowMDowMi40OiAgIGJyaWRnZSB3aW5kb3cgW21l
bSAweGZjNzAwMDAwLTB4ZmM3ZmZmZmZdClsgICAgMC41NTg1NTVdIHBjaSAwMDAwOjA1OjAwLjA6
IFsxMDAyOjE2MzZdIHR5cGUgMDAgY2xhc3MgMHgwMzAwMDAKWyAgICAwLjU1ODU2OF0gcGNpIDAw
MDA6MDU6MDAuMDogcmVnIDB4MTA6IFttZW0gMHhkMDAwMDAwMC0weGRmZmZmZmZmIDY0Yml0IHBy
ZWZdClsgICAgMC41NTg1NzhdIHBjaSAwMDAwOjA1OjAwLjA6IHJlZyAweDE4OiBbbWVtIDB4ZTAw
MDAwMDAtMHhlMDFmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDAuNTU4NTg2XSBwY2kgMDAwMDowNTow
MC4wOiByZWcgMHgyMDogW2lvICAweGMwMDAtMHhjMGZmXQpbICAgIDAuNTU4NTkzXSBwY2kgMDAw
MDowNTowMC4wOiByZWcgMHgyNDogW21lbSAweGZjNTAwMDAwLTB4ZmM1N2ZmZmZdClsgICAgMC41
NTg2MDRdIHBjaSAwMDAwOjA1OjAwLjA6IGVuYWJsaW5nIEV4dGVuZGVkIFRhZ3MKWyAgICAwLjU1
ODY1Ml0gcGNpIDAwMDA6MDU6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMSBEMiBEM2hvdCBE
M2NvbGQKWyAgICAwLjU1ODY3Nl0gcGNpIDAwMDA6MDU6MDAuMDogMTI2LjAxNiBHYi9zIGF2YWls
YWJsZSBQQ0llIGJhbmR3aWR0aCwgbGltaXRlZCBieSA4LjAgR1QvcyBQQ0llIHgxNiBsaW5rIGF0
IDAwMDA6MDA6MDguMSAoY2FwYWJsZSBvZiAyNTIuMDQ4IEdiL3Mgd2l0aCAxNi4wIEdUL3MgUENJ
ZSB4MTYgbGluaykKWyAgICAwLjU1ODczMF0gcGNpIDAwMDA6MDU6MDAuMjogWzEwMjI6MTVkZl0g
dHlwZSAwMCBjbGFzcyAweDEwODAwMApbICAgIDAuNTU4NzQ2XSBwY2kgMDAwMDowNTowMC4yOiBy
ZWcgMHgxODogW21lbSAweGZjNDAwMDAwLTB4ZmM0ZmZmZmZdClsgICAgMC41NTg3NTddIHBjaSAw
MDAwOjA1OjAwLjI6IHJlZyAweDI0OiBbbWVtIDB4ZmM1YzgwMDAtMHhmYzVjOWZmZl0KWyAgICAw
LjU1ODc2Nl0gcGNpIDAwMDA6MDU6MDAuMjogZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbICAgIDAu
NTU4ODQ3XSBwY2kgMDAwMDowNTowMC4zOiBbMTAyMjoxNjM5XSB0eXBlIDAwIGNsYXNzIDB4MGMw
MzMwClsgICAgMC41NTg4NjBdIHBjaSAwMDAwOjA1OjAwLjM6IHJlZyAweDEwOiBbbWVtIDB4ZmMz
MDAwMDAtMHhmYzNmZmZmZiA2NGJpdF0KWyAgICAwLjU1ODg4Nl0gcGNpIDAwMDA6MDU6MDAuMzog
ZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbICAgIDAuNTU4OTE4XSBwY2kgMDAwMDowNTowMC4zOiBQ
TUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuNTU4OTczXSBwY2kgMDAw
MDowNTowMC40OiBbMTAyMjoxNjM5XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzMwClsgICAgMC41NTg5
ODZdIHBjaSAwMDAwOjA1OjAwLjQ6IHJlZyAweDEwOiBbbWVtIDB4ZmMyMDAwMDAtMHhmYzJmZmZm
ZiA2NGJpdF0KWyAgICAwLjU1OTAxMl0gcGNpIDAwMDA6MDU6MDAuNDogZW5hYmxpbmcgRXh0ZW5k
ZWQgVGFncwpbICAgIDAuNTU5MDQ3XSBwY2kgMDAwMDowNTowMC40OiBQTUUjIHN1cHBvcnRlZCBm
cm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuNTU5MTAxXSBwY2kgMDAwMDowNTowMC41OiBbMTAy
MjoxNWUyXSB0eXBlIDAwIGNsYXNzIDB4MDQ4MDAwClsgICAgMC41NTkxMTFdIHBjaSAwMDAwOjA1
OjAwLjU6IHJlZyAweDEwOiBbbWVtIDB4ZmM1ODAwMDAtMHhmYzViZmZmZl0KWyAgICAwLjU1OTEz
NF0gcGNpIDAwMDA6MDU6MDAuNTogZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbICAgIDAuNTU5MTY1
XSBwY2kgMDAwMDowNTowMC41OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApb
ICAgIDAuNTU5MjE1XSBwY2kgMDAwMDowNTowMC42OiBbMTAyMjoxNWUzXSB0eXBlIDAwIGNsYXNz
IDB4MDQwMzAwClsgICAgMC41NTkyMjVdIHBjaSAwMDAwOjA1OjAwLjY6IHJlZyAweDEwOiBbbWVt
IDB4ZmM1YzAwMDAtMHhmYzVjN2ZmZl0KWyAgICAwLjU1OTI0OF0gcGNpIDAwMDA6MDU6MDAuNjog
ZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbICAgIDAuNTU5Mjc4XSBwY2kgMDAwMDowNTowMC42OiBQ
TUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuNTU5MzQxXSBwY2kgMDAw
MDowMDowOC4xOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDVdClsgICAgMC41NTkzNDZdIHBjaSAwMDAw
OjAwOjA4LjE6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4YzAwMC0weGNmZmZdClsgICAgMC41NTkz
NDldIHBjaSAwMDAwOjAwOjA4LjE6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmMyMDAwMDAtMHhm
YzVmZmZmZl0KWyAgICAwLjU1OTM1NF0gcGNpIDAwMDA6MDA6MDguMTogICBicmlkZ2Ugd2luZG93
IFttZW0gMHhkMDAwMDAwMC0weGUwMWZmZmZmIDY0Yml0IHByZWZdClsgICAgMC41NTkzOTFdIHBj
aSAwMDAwOjA2OjAwLjA6IFsxMDIyOjc5MDFdIHR5cGUgMDAgY2xhc3MgMHgwMTA2MDEKWyAgICAw
LjU1OTQyMl0gcGNpIDAwMDA6MDY6MDAuMDogcmVnIDB4MjQ6IFttZW0gMHhmYzYwMTAwMC0weGZj
NjAxN2ZmXQpbICAgIDAuNTU5NDMyXSBwY2kgMDAwMDowNjowMC4wOiBlbmFibGluZyBFeHRlbmRl
ZCBUYWdzClsgICAgMC41NTk0OTFdIHBjaSAwMDAwOjA2OjAwLjA6IDEyNi4wMTYgR2IvcyBhdmFp
bGFibGUgUENJZSBiYW5kd2lkdGgsIGxpbWl0ZWQgYnkgOC4wIEdUL3MgUENJZSB4MTYgbGluayBh
dCAwMDAwOjAwOjA4LjIgKGNhcGFibGUgb2YgMjUyLjA0OCBHYi9zIHdpdGggMTYuMCBHVC9zIFBD
SWUgeDE2IGxpbmspClsgICAgMC41NTk1MzZdIHBjaSAwMDAwOjA2OjAwLjE6IFsxMDIyOjc5MDFd
IHR5cGUgMDAgY2xhc3MgMHgwMTA2MDEKWyAgICAwLjU1OTU2N10gcGNpIDAwMDA6MDY6MDAuMTog
cmVnIDB4MjQ6IFttZW0gMHhmYzYwMDAwMC0weGZjNjAwN2ZmXQpbICAgIDAuNTU5NTc3XSBwY2kg
MDAwMDowNjowMC4xOiBlbmFibGluZyBFeHRlbmRlZCBUYWdzClsgICAgMC41NTk2NjBdIHBjaSAw
MDAwOjAwOjA4LjI6IFBDSSBicmlkZ2UgdG8gW2J1cyAwNl0KWyAgICAwLjU1OTY2NV0gcGNpIDAw
MDA6MDA6MDguMjogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYzYwMDAwMC0weGZjNmZmZmZmXQpb
ICAgIDAuNTU5NjkzXSBwY2lfYnVzIDAwMDA6MDA6IG9uIE5VTUEgbm9kZSAwClsgICAgMC41NjAx
OTNdIEFDUEk6IFBDSTogSW50ZXJydXB0IGxpbmsgTE5LQSBjb25maWd1cmVkIGZvciBJUlEgMApb
ICAgIDAuNTYwMjM2XSBBQ1BJOiBQQ0k6IEludGVycnVwdCBsaW5rIExOS0IgY29uZmlndXJlZCBm
b3IgSVJRIDAKWyAgICAwLjU2MDI3MV0gQUNQSTogUENJOiBJbnRlcnJ1cHQgbGluayBMTktDIGNv
bmZpZ3VyZWQgZm9yIElSUSAwClsgICAgMC41NjAzMTVdIEFDUEk6IFBDSTogSW50ZXJydXB0IGxp
bmsgTE5LRCBjb25maWd1cmVkIGZvciBJUlEgMApbICAgIDAuNTYwMzU0XSBBQ1BJOiBQQ0k6IElu
dGVycnVwdCBsaW5rIExOS0UgY29uZmlndXJlZCBmb3IgSVJRIDAKWyAgICAwLjU2MDM4N10gQUNQ
STogUENJOiBJbnRlcnJ1cHQgbGluayBMTktGIGNvbmZpZ3VyZWQgZm9yIElSUSAwClsgICAgMC41
NjA0MjBdIEFDUEk6IFBDSTogSW50ZXJydXB0IGxpbmsgTE5LRyBjb25maWd1cmVkIGZvciBJUlEg
MApbICAgIDAuNTYwNDUzXSBBQ1BJOiBQQ0k6IEludGVycnVwdCBsaW5rIExOS0ggY29uZmlndXJl
ZCBmb3IgSVJRIDAKWyAgICAwLjU2MTQxMF0gQUNQSTogRUM6IGludGVycnVwdCB1bmJsb2NrZWQK
WyAgICAwLjU2MTQxM10gQUNQSTogRUM6IGV2ZW50IHVuYmxvY2tlZApbICAgIDAuNTYxNDE5XSBB
Q1BJOiBFQzogRUNfQ01EL0VDX1NDPTB4NjYsIEVDX0RBVEE9MHg2MgpbICAgIDAuNTYxNDIyXSBB
Q1BJOiBFQzogR1BFPTB4MwpbICAgIDAuNTYxNDI0XSBBQ1BJOiBcX1NCXy5QQ0kwLlNCUkcuRUMw
XzogQm9vdCBEU0RUIEVDIGluaXRpYWxpemF0aW9uIGNvbXBsZXRlClsgICAgMC41NjE0MjddIEFD
UEk6IFxfU0JfLlBDSTAuU0JSRy5FQzBfOiBFQzogVXNlZCB0byBoYW5kbGUgdHJhbnNhY3Rpb25z
IGFuZCBldmVudHMKWyAgICAwLjU2MTQ3OV0gaW9tbXU6IERlZmF1bHQgZG9tYWluIHR5cGU6IFRy
YW5zbGF0ZWQgClsgICAgMC41NjE0NzldIGlvbW11OiBETUEgZG9tYWluIFRMQiBpbnZhbGlkYXRp
b24gcG9saWN5OiBsYXp5IG1vZGUgClsgICAgMC41NjE0NzldIFNDU0kgc3Vic3lzdGVtIGluaXRp
YWxpemVkClsgICAgMC41NjE0NzldIGxpYmF0YSB2ZXJzaW9uIDMuMDAgbG9hZGVkLgpbICAgIDAu
NTYxNDc5XSBBQ1BJOiBidXMgdHlwZSBVU0IgcmVnaXN0ZXJlZApbICAgIDAuNTYxNDc5XSB1c2Jj
b3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHVzYmZzClsgICAgMC41NjE0Nzld
IHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgaHViClsgICAgMC41NjE0
NzldIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGRldmljZSBkcml2ZXIgdXNiClsgICAgMC41NjMy
NDhdIG1jOiBMaW51eCBtZWRpYSBpbnRlcmZhY2U6IHYwLjEwClsgICAgMC41NjMyNTZdIHZpZGVv
ZGV2OiBMaW51eCB2aWRlbyBjYXB0dXJlIGludGVyZmFjZTogdjIuMDAKWyAgICAwLjU2MzMwMF0g
UmVnaXN0ZXJlZCBlZml2YXJzIG9wZXJhdGlvbnMKWyAgICAwLjU2MzMxNl0gQWR2YW5jZWQgTGlu
dXggU291bmQgQXJjaGl0ZWN0dXJlIERyaXZlciBJbml0aWFsaXplZC4KWyAgICAwLjU2MzMxNl0g
Qmx1ZXRvb3RoOiBDb3JlIHZlciAyLjIyClsgICAgMC41NjMzMTZdIE5FVDogUmVnaXN0ZXJlZCBQ
Rl9CTFVFVE9PVEggcHJvdG9jb2wgZmFtaWx5ClsgICAgMC41NjMzMTZdIEJsdWV0b290aDogSENJ
IGRldmljZSBhbmQgY29ubmVjdGlvbiBtYW5hZ2VyIGluaXRpYWxpemVkClsgICAgMC41NjMzMTZd
IEJsdWV0b290aDogSENJIHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDAuNTYzMzE2XSBC
bHVldG9vdGg6IEwyQ0FQIHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDAuNTYzMzE2XSBC
bHVldG9vdGg6IFNDTyBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6ZWQKWyAgICAwLjU2MzMxNl0gUENJ
OiBVc2luZyBBQ1BJIGZvciBJUlEgcm91dGluZwpbICAgIDAuNTY3ODY5XSBQQ0k6IHBjaV9jYWNo
ZV9saW5lX3NpemUgc2V0IHRvIDY0IGJ5dGVzClsgICAgMC41NjgwMDZdIEV4cGFuZGVkIHJlc291
cmNlIFJlc2VydmVkIGR1ZSB0byBjb25mbGljdCB3aXRoIFBDSSBCdXMgMDAwMDowMApbICAgIDAu
NTY4MDA5XSBlODIwOiByZXNlcnZlIFJBTSBidWZmZXIgW21lbSAweDA5ZWQwMDAwLTB4MGJmZmZm
ZmZdClsgICAgMC41NjgwMTJdIGU4MjA6IHJlc2VydmUgUkFNIGJ1ZmZlciBbbWVtIDB4MGEyMDAw
MDAtMHgwYmZmZmZmZl0KWyAgICAwLjU2ODAxM10gZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFtt
ZW0gMHhhNDE3NzAxOC0weGE3ZmZmZmZmXQpbICAgIDAuNTY4MDE0XSBlODIwOiByZXNlcnZlIFJB
TSBidWZmZXIgW21lbSAweGE0MjNhMDE4LTB4YTdmZmZmZmZdClsgICAgMC41NjgwMTZdIGU4MjA6
IHJlc2VydmUgUkFNIGJ1ZmZlciBbbWVtIDB4YTQ3YjEwMDAtMHhhN2ZmZmZmZl0KWyAgICAwLjU2
ODAxN10gZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFttZW0gMHhhNjYyMTAwMC0weGE3ZmZmZmZm
XQpbICAgIDAuNTY4MDE4XSBlODIwOiByZXNlcnZlIFJBTSBidWZmZXIgW21lbSAweGE3Mzg0MDAw
LTB4YTdmZmZmZmZdClsgICAgMC41NjgwMTldIGU4MjA6IHJlc2VydmUgUkFNIGJ1ZmZlciBbbWVt
IDB4YWUwMDAwMDAtMHhhZmZmZmZmZl0KWyAgICAwLjU2ODAyMF0gZTgyMDogcmVzZXJ2ZSBSQU0g
YnVmZmVyIFttZW0gMHg0MmYzNDAwMDAtMHg0MmZmZmZmZmZdClsgICAgMC41NjgwNTZdIHBjaSAw
MDAwOjAxOjAwLjA6IHZnYWFyYjogc2V0dGluZyBhcyBib290IFZHQSBkZXZpY2UKWyAgICAwLjU2
ODA1Nl0gcGNpIDAwMDA6MDE6MDAuMDogdmdhYXJiOiBicmlkZ2UgY29udHJvbCBwb3NzaWJsZQpb
ICAgIDAuNTY4MDU3XSBwY2kgMDAwMDowMTowMC4wOiB2Z2FhcmI6IFZHQSBkZXZpY2UgYWRkZWQ6
IGRlY29kZXM9aW8rbWVtLG93bnM9bm9uZSxsb2Nrcz1ub25lClsgICAgMC41NjgwNjNdIHBjaSAw
MDAwOjA1OjAwLjA6IHZnYWFyYjogc2V0dGluZyBhcyBib290IFZHQSBkZXZpY2UgKG92ZXJyaWRp
bmcgcHJldmlvdXMpClsgICAgMC41NjgwNjddIHBjaSAwMDAwOjA1OjAwLjA6IHZnYWFyYjogYnJp
ZGdlIGNvbnRyb2wgcG9zc2libGUKWyAgICAwLjU2ODA2OV0gcGNpIDAwMDA6MDU6MDAuMDogdmdh
YXJiOiBWR0EgZGV2aWNlIGFkZGVkOiBkZWNvZGVzPWlvK21lbSxvd25zPW5vbmUsbG9ja3M9bm9u
ZQpbICAgIDAuNTY4MDczXSB2Z2FhcmI6IGxvYWRlZApbICAgIDAuNTY4Mjg2XSBocGV0MDogYXQg
TU1JTyAweGZlZDAwMDAwLCBJUlFzIDIsIDgsIDAKWyAgICAwLjU2ODI5Ml0gaHBldDA6IDMgY29t
cGFyYXRvcnMsIDMyLWJpdCAxNC4zMTgxODAgTUh6IGNvdW50ZXIKWyAgICAwLjU3MDEwNV0gY2xv
Y2tzb3VyY2U6IFN3aXRjaGVkIHRvIGNsb2Nrc291cmNlIHRzYy1lYXJseQpbICAgIDAuNTc3Mjg3
XSBwbnA6IFBuUCBBQ1BJIGluaXQKWyAgICAwLjU3NzQwOF0gc3lzdGVtIDAwOjAwOiBbbWVtIDB4
ZjAwMDAwMDAtMHhmN2ZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3NzY5OF0gc3lz
dGVtIDAwOjAzOiBbaW8gIDB4MDRkMC0weDA0ZDFdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC41
Nzc3MDJdIHN5c3RlbSAwMDowMzogW2lvICAweDA0MGJdIGhhcyBiZWVuIHJlc2VydmVkClsgICAg
MC41Nzc3MDVdIHN5c3RlbSAwMDowMzogW2lvICAweDA0ZDZdIGhhcyBiZWVuIHJlc2VydmVkClsg
ICAgMC41Nzc3MDhdIHN5c3RlbSAwMDowMzogW2lvICAweDBjMDAtMHgwYzAxXSBoYXMgYmVlbiBy
ZXNlcnZlZApbICAgIDAuNTc3NzExXSBzeXN0ZW0gMDA6MDM6IFtpbyAgMHgwYzE0XSBoYXMgYmVl
biByZXNlcnZlZApbICAgIDAuNTc3NzEzXSBzeXN0ZW0gMDA6MDM6IFtpbyAgMHgwYzUwLTB4MGM1
MV0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3NzcxNl0gc3lzdGVtIDAwOjAzOiBbaW8gIDB4
MGM1Ml0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3NzcxOV0gc3lzdGVtIDAwOjAzOiBbaW8g
IDB4MGM2Y10gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3NzcyMl0gc3lzdGVtIDAwOjAzOiBb
aW8gIDB4MGM2Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3NzcyNF0gc3lzdGVtIDAwOjAz
OiBbaW8gIDB4MGNkMC0weDBjZDFdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC41Nzc3MjddIHN5
c3RlbSAwMDowMzogW2lvICAweDBjZDItMHgwY2QzXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAu
NTc3NzMwXSBzeXN0ZW0gMDA6MDM6IFtpbyAgMHgwY2Q0LTB4MGNkNV0gaGFzIGJlZW4gcmVzZXJ2
ZWQKWyAgICAwLjU3NzczM10gc3lzdGVtIDAwOjAzOiBbaW8gIDB4MGNkNi0weDBjZDddIGhhcyBi
ZWVuIHJlc2VydmVkClsgICAgMC41Nzc3MzZdIHN5c3RlbSAwMDowMzogW2lvICAweDBjZDgtMHgw
Y2RmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuNTc3NzM5XSBzeXN0ZW0gMDA6MDM6IFtpbyAg
MHgwODAwLTB4MDg5Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3Nzc0MV0gc3lzdGVtIDAw
OjAzOiBbaW8gIDB4MGIwMC0weDBiMGZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC41Nzc3NDRd
IHN5c3RlbSAwMDowMzogW2lvICAweDBiMjAtMHgwYjNmXSBoYXMgYmVlbiByZXNlcnZlZApbICAg
IDAuNTc3NzQ3XSBzeXN0ZW0gMDA6MDM6IFtpbyAgMHgwOTAwLTB4MDkwZl0gaGFzIGJlZW4gcmVz
ZXJ2ZWQKWyAgICAwLjU3Nzc1MF0gc3lzdGVtIDAwOjAzOiBbaW8gIDB4MDkxMC0weDA5MWZdIGhh
cyBiZWVuIHJlc2VydmVkClsgICAgMC41Nzc3NTNdIHN5c3RlbSAwMDowMzogW21lbSAweGZlYzAw
MDAwLTB4ZmVjMDBmZmZdIGNvdWxkIG5vdCBiZSByZXNlcnZlZApbICAgIDAuNTc3NzU3XSBzeXN0
ZW0gMDA6MDM6IFttZW0gMHhmZWMwMTAwMC0weGZlYzAxZmZmXSBjb3VsZCBub3QgYmUgcmVzZXJ2
ZWQKWyAgICAwLjU3Nzc2MF0gc3lzdGVtIDAwOjAzOiBbbWVtIDB4ZmVkYzAwMDAtMHhmZWRjMGZm
Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3Nzc2M10gc3lzdGVtIDAwOjAzOiBbbWVtIDB4
ZmVlMDAwMDAtMHhmZWUwMGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjU3Nzc2Nl0gc3lz
dGVtIDAwOjAzOiBbbWVtIDB4ZmVkODAwMDAtMHhmZWQ4ZmZmZl0gY291bGQgbm90IGJlIHJlc2Vy
dmVkClsgICAgMC41Nzc3NjldIHN5c3RlbSAwMDowMzogW21lbSAweGZlYzEwMDAwLTB4ZmVjMTBm
ZmZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC41Nzc3NzNdIHN5c3RlbSAwMDowMzogW21lbSAw
eGZmMDAwMDAwLTB4ZmZmZmZmZmZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC41Nzg0MThdIHBu
cDogUG5QIEFDUEk6IGZvdW5kIDQgZGV2aWNlcwpbICAgIDAuNTg0Mjg4XSBjbG9ja3NvdXJjZTog
YWNwaV9wbTogbWFzazogMHhmZmZmZmYgbWF4X2N5Y2xlczogMHhmZmZmZmYsIG1heF9pZGxlX25z
OiAyMDg1NzAxMDI0IG5zClsgICAgMC41ODQzNDldIE5FVDogUmVnaXN0ZXJlZCBQRl9JTkVUIHBy
b3RvY29sIGZhbWlseQpbICAgIDAuNTg0NTc4XSBJUCBpZGVudHMgaGFzaCB0YWJsZSBlbnRyaWVz
OiAyNjIxNDQgKG9yZGVyOiA5LCAyMDk3MTUyIGJ5dGVzLCBsaW5lYXIpClsgICAgMC41ODcyMDJd
IHRjcF9saXN0ZW5fcG9ydGFkZHJfaGFzaCBoYXNoIHRhYmxlIGVudHJpZXM6IDgxOTIgKG9yZGVy
OiA1LCAxMzEwNzIgYnl0ZXMsIGxpbmVhcikKWyAgICAwLjU4NzIyOF0gVENQIGVzdGFibGlzaGVk
IGhhc2ggdGFibGUgZW50cmllczogMTMxMDcyIChvcmRlcjogOCwgMTA0ODU3NiBieXRlcywgbGlu
ZWFyKQpbICAgIDAuNTg3NDAwXSBUQ1AgYmluZCBoYXNoIHRhYmxlIGVudHJpZXM6IDY1NTM2IChv
cmRlcjogOCwgMTA0ODU3NiBieXRlcywgbGluZWFyKQpbICAgIDAuNTg3NTI3XSBUQ1A6IEhhc2gg
dGFibGVzIGNvbmZpZ3VyZWQgKGVzdGFibGlzaGVkIDEzMTA3MiBiaW5kIDY1NTM2KQpbICAgIDAu
NTg3NTYyXSBVRFAgaGFzaCB0YWJsZSBlbnRyaWVzOiA4MTkyIChvcmRlcjogNiwgMjYyMTQ0IGJ5
dGVzLCBsaW5lYXIpClsgICAgMC41ODc1OTldIFVEUC1MaXRlIGhhc2ggdGFibGUgZW50cmllczog
ODE5MiAob3JkZXI6IDYsIDI2MjE0NCBieXRlcywgbGluZWFyKQpbICAgIDAuNTg3NjY1XSBORVQ6
IFJlZ2lzdGVyZWQgUEZfVU5JWC9QRl9MT0NBTCBwcm90b2NvbCBmYW1pbHkKWyAgICAwLjU4Nzkw
Nl0gcGNpIDAwMDA6MDA6MDEuMTogUENJIGJyaWRnZSB0byBbYnVzIDAxXQpbICAgIDAuNTg3OTEy
XSBwY2kgMDAwMDowMDowMS4xOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGYwMDAtMHhmZmZmXQpb
ICAgIDAuNTg3OTE4XSBwY2kgMDAwMDowMDowMS4xOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZi
MDAwMDAwLTB4ZmMwZmZmZmZdClsgICAgMC41ODc5MjNdIHBjaSAwMDAwOjAwOjAxLjE6ICAgYnJp
ZGdlIHdpbmRvdyBbbWVtIDB4YjAwMDAwMDAtMHhjMWZmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDAu
NTg3OTI5XSBwY2kgMDAwMDowMDowMS4yOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDJdClsgICAgMC41
ODc5MzJdIHBjaSAwMDAwOjAwOjAxLjI6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0weGVm
ZmZdClsgICAgMC41ODc5MzZdIHBjaSAwMDAwOjAwOjAxLjI6ICAgYnJpZGdlIHdpbmRvdyBbbWVt
IDB4ZmM5MDAwMDAtMHhmYzlmZmZmZl0KWyAgICAwLjU4Nzk0M10gcGNpIDAwMDA6MDA6MDIuMTog
UENJIGJyaWRnZSB0byBbYnVzIDAzXQpbICAgIDAuNTg3OTQ2XSBwY2kgMDAwMDowMDowMi4xOiAg
IGJyaWRnZSB3aW5kb3cgW2lvICAweGQwMDAtMHhkZmZmXQpbICAgIDAuNTg3OTUwXSBwY2kgMDAw
MDowMDowMi4xOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGZjODAwMDAwLTB4ZmM4ZmZmZmZdClsg
ICAgMC41ODc5NTZdIHBjaSAwMDAwOjAwOjAyLjQ6IFBDSSBicmlkZ2UgdG8gW2J1cyAwNF0KWyAg
ICAwLjU4Nzk2MF0gcGNpIDAwMDA6MDA6MDIuNDogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmYzcw
MDAwMC0weGZjN2ZmZmZmXQpbICAgIDAuNTg3OTY4XSBwY2kgMDAwMDowMDowOC4xOiBQQ0kgYnJp
ZGdlIHRvIFtidXMgMDVdClsgICAgMC41ODc5NzFdIHBjaSAwMDAwOjAwOjA4LjE6ICAgYnJpZGdl
IHdpbmRvdyBbaW8gIDB4YzAwMC0weGNmZmZdClsgICAgMC41ODc5NzVdIHBjaSAwMDAwOjAwOjA4
LjE6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZmMyMDAwMDAtMHhmYzVmZmZmZl0KWyAgICAwLjU4
Nzk3OV0gcGNpIDAwMDA6MDA6MDguMTogICBicmlkZ2Ugd2luZG93IFttZW0gMHhkMDAwMDAwMC0w
eGUwMWZmZmZmIDY0Yml0IHByZWZdClsgICAgMC41ODc5ODVdIHBjaSAwMDAwOjAwOjA4LjI6IFBD
SSBicmlkZ2UgdG8gW2J1cyAwNl0KWyAgICAwLjU4Nzk4OV0gcGNpIDAwMDA6MDA6MDguMjogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhmYzYwMDAwMC0weGZjNmZmZmZmXQpbICAgIDAuNTg3OTk2XSBw
Y2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDQgW2lvICAweDAwMDAtMHgwM2FmIHdpbmRvd10KWyAg
ICAwLjU4Nzk5OV0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA1IFtpbyAgMHgwM2UwLTB4MGNm
NyB3aW5kb3ddClsgICAgMC41ODgwMDNdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNiBbaW8g
IDB4MDNiMC0weDAzZGYgd2luZG93XQpbICAgIDAuNTg4MDA2XSBwY2lfYnVzIDAwMDA6MDA6IHJl
c291cmNlIDcgW2lvICAweDBkMDAtMHhmZmZmIHdpbmRvd10KWyAgICAwLjU4ODAwOF0gcGNpX2J1
cyAwMDAwOjAwOiByZXNvdXJjZSA4IFttZW0gMHgwMDBhMDAwMC0weDAwMGRmZmZmIHdpbmRvd10K
WyAgICAwLjU4ODAxMl0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA5IFttZW0gMHhiMDAwMDAw
MC0weGZlYmZmZmZmIHdpbmRvd10KWyAgICAwLjU4ODAxNV0gcGNpX2J1cyAwMDAwOjAwOiByZXNv
dXJjZSAxMCBbbWVtIDB4ZmVlMDAwMDAtMHhmZmZmZmZmZiB3aW5kb3ddClsgICAgMC41ODgwMThd
IHBjaV9idXMgMDAwMDowMTogcmVzb3VyY2UgMCBbaW8gIDB4ZjAwMC0weGZmZmZdClsgICAgMC41
ODgwMjFdIHBjaV9idXMgMDAwMDowMTogcmVzb3VyY2UgMSBbbWVtIDB4ZmIwMDAwMDAtMHhmYzBm
ZmZmZl0KWyAgICAwLjU4ODAyM10gcGNpX2J1cyAwMDAwOjAxOiByZXNvdXJjZSAyIFttZW0gMHhi
MDAwMDAwMC0weGMxZmZmZmZmIDY0Yml0IHByZWZdClsgICAgMC41ODgwMjddIHBjaV9idXMgMDAw
MDowMjogcmVzb3VyY2UgMCBbaW8gIDB4ZTAwMC0weGVmZmZdClsgICAgMC41ODgwMzBdIHBjaV9i
dXMgMDAwMDowMjogcmVzb3VyY2UgMSBbbWVtIDB4ZmM5MDAwMDAtMHhmYzlmZmZmZl0KWyAgICAw
LjU4ODAzM10gcGNpX2J1cyAwMDAwOjAzOiByZXNvdXJjZSAwIFtpbyAgMHhkMDAwLTB4ZGZmZl0K
WyAgICAwLjU4ODAzNl0gcGNpX2J1cyAwMDAwOjAzOiByZXNvdXJjZSAxIFttZW0gMHhmYzgwMDAw
MC0weGZjOGZmZmZmXQpbICAgIDAuNTg4MDM5XSBwY2lfYnVzIDAwMDA6MDQ6IHJlc291cmNlIDEg
W21lbSAweGZjNzAwMDAwLTB4ZmM3ZmZmZmZdClsgICAgMC41ODgwNDJdIHBjaV9idXMgMDAwMDow
NTogcmVzb3VyY2UgMCBbaW8gIDB4YzAwMC0weGNmZmZdClsgICAgMC41ODgwNDRdIHBjaV9idXMg
MDAwMDowNTogcmVzb3VyY2UgMSBbbWVtIDB4ZmMyMDAwMDAtMHhmYzVmZmZmZl0KWyAgICAwLjU4
ODA0N10gcGNpX2J1cyAwMDAwOjA1OiByZXNvdXJjZSAyIFttZW0gMHhkMDAwMDAwMC0weGUwMWZm
ZmZmIDY0Yml0IHByZWZdClsgICAgMC41ODgwNTFdIHBjaV9idXMgMDAwMDowNjogcmVzb3VyY2Ug
MSBbbWVtIDB4ZmM2MDAwMDAtMHhmYzZmZmZmZl0KWyAgICAwLjU4ODE2N10gcGNpIDAwMDA6MDE6
MDAuMTogRDAgcG93ZXIgc3RhdGUgZGVwZW5kcyBvbiAwMDAwOjAxOjAwLjAKWyAgICAwLjU4ODIz
NV0gcGNpIDAwMDA6MDU6MDAuMzogZXh0ZW5kaW5nIGRlbGF5IGFmdGVyIHBvd2VyLW9uIGZyb20g
RDNob3QgdG8gMjAgbXNlYwpbICAgIDAuNTg4Mzc4XSBwY2kgMDAwMDowNTowMC40OiBleHRlbmRp
bmcgZGVsYXkgYWZ0ZXIgcG93ZXItb24gZnJvbSBEM2hvdCB0byAyMCBtc2VjClsgICAgMC41ODg0
NDNdIFBDSTogQ0xTIDY0IGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC41ODg0NTVdIHBjaSAwMDAw
OjAwOjAwLjI6IEFNRC1WaTogSU9NTVUgcGVyZm9ybWFuY2UgY291bnRlcnMgc3VwcG9ydGVkClsg
ICAgMC41ODg0OTNdIHBjaSAwMDAwOjAwOjAwLjI6IGNhbid0IGRlcml2ZSByb3V0aW5nIGZvciBQ
Q0kgSU5UIEEKWyAgICAwLjU4ODQ5N10gcGNpIDAwMDA6MDA6MDAuMjogUENJIElOVCBBOiBub3Qg
Y29ubmVjdGVkClsgICAgMC41ODg1MjFdIHBjaSAwMDAwOjAwOjAxLjA6IEFkZGluZyB0byBpb21t
dSBncm91cCAwClsgICAgMC41ODg1MzFdIHBjaSAwMDAwOjAwOjAxLjE6IEFkZGluZyB0byBpb21t
dSBncm91cCAxClsgICAgMC41ODg1NDFdIHBjaSAwMDAwOjAwOjAxLjI6IEFkZGluZyB0byBpb21t
dSBncm91cCAyClsgICAgMC41ODg1NTVdIHBjaSAwMDAwOjAwOjAyLjA6IEFkZGluZyB0byBpb21t
dSBncm91cCAzClsgICAgMC41ODg1NjZdIHBjaSAwMDAwOjAwOjAyLjE6IEFkZGluZyB0byBpb21t
dSBncm91cCA0ClsgICAgMC41ODg1NzZdIHBjaSAwMDAwOjAwOjAyLjQ6IEFkZGluZyB0byBpb21t
dSBncm91cCA1ClsgICAgMC41ODg1OTNdIHBjaSAwMDAwOjAwOjA4LjA6IEFkZGluZyB0byBpb21t
dSBncm91cCA2ClsgICAgMC41ODg2MDFdIHBjaSAwMDAwOjAwOjA4LjE6IEFkZGluZyB0byBpb21t
dSBncm91cCA2ClsgICAgMC41ODg2MTBdIHBjaSAwMDAwOjAwOjA4LjI6IEFkZGluZyB0byBpb21t
dSBncm91cCA2ClsgICAgMC41ODg2MjVdIHBjaSAwMDAwOjAwOjE0LjA6IEFkZGluZyB0byBpb21t
dSBncm91cCA3ClsgICAgMC41ODg2MzRdIHBjaSAwMDAwOjAwOjE0LjM6IEFkZGluZyB0byBpb21t
dSBncm91cCA3ClsgICAgMC41ODg2NjZdIHBjaSAwMDAwOjAwOjE4LjA6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg2NzVdIHBjaSAwMDAwOjAwOjE4LjE6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg2ODNdIHBjaSAwMDAwOjAwOjE4LjI6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3MDBdIHBjaSAwMDAwOjAwOjE4LjM6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3MTJdIHBjaSAwMDAwOjAwOjE4LjQ6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3MjFdIHBjaSAwMDAwOjAwOjE4LjU6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3MzBdIHBjaSAwMDAwOjAwOjE4LjY6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3MzldIHBjaSAwMDAwOjAwOjE4Ljc6IEFkZGluZyB0byBpb21t
dSBncm91cCA4ClsgICAgMC41ODg3NTRdIHBjaSAwMDAwOjAxOjAwLjA6IEFkZGluZyB0byBpb21t
dSBncm91cCA5ClsgICAgMC41ODg3NjRdIHBjaSAwMDAwOjAxOjAwLjE6IEFkZGluZyB0byBpb21t
dSBncm91cCA5ClsgICAgMC41ODg3NzRdIHBjaSAwMDAwOjAyOjAwLjA6IEFkZGluZyB0byBpb21t
dSBncm91cCAxMApbICAgIDAuNTg4Nzg0XSBwY2kgMDAwMDowMzowMC4wOiBBZGRpbmcgdG8gaW9t
bXUgZ3JvdXAgMTEKWyAgICAwLjU4ODc5NV0gcGNpIDAwMDA6MDQ6MDAuMDogQWRkaW5nIHRvIGlv
bW11IGdyb3VwIDEyClsgICAgMC41ODg4MDRdIHBjaSAwMDAwOjA1OjAwLjA6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MDldIHBjaSAwMDAwOjA1OjAwLjI6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MTRdIHBjaSAwMDAwOjA1OjAwLjM6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MTldIHBjaSAwMDAwOjA1OjAwLjQ6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MjVdIHBjaSAwMDAwOjA1OjAwLjU6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MzBdIHBjaSAwMDAwOjA1OjAwLjY6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4MzVdIHBjaSAwMDAwOjA2OjAwLjA6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41ODg4NDBdIHBjaSAwMDAwOjA2OjAwLjE6IEFkZGluZyB0byBp
b21tdSBncm91cCA2ClsgICAgMC41OTAzMzRdIHBjaSAwMDAwOjAwOjAwLjI6IEFNRC1WaTogRm91
bmQgSU9NTVUgY2FwIDB4NDAKWyAgICAwLjU5MDM0MF0gQU1ELVZpOiBFeHRlbmRlZCBmZWF0dXJl
cyAoMHgyMDZkNzNlZjIyMjU0YWRlKTogUFBSIFgyQVBJQyBOWCBHVCBJQSBHQSBQQyBHQV92QVBJ
QwpbICAgIDAuNTkwMzQ5XSBBTUQtVmk6IEludGVycnVwdCByZW1hcHBpbmcgZW5hYmxlZApbICAg
IDAuNTkwMzUxXSBBTUQtVmk6IFZpcnR1YWwgQVBJQyBlbmFibGVkClsgICAgMC41OTAzNTJdIEFN
RC1WaTogWDJBUElDIGVuYWJsZWQKWyAgICAwLjU5MDQ2NF0gc29mdHdhcmUgSU8gVExCOiB0ZWFy
aW5nIGRvd24gZGVmYXVsdCBtZW1vcnkgcG9vbApbICAgIDAuNTkxNDY0XSBSQVBMIFBNVTogQVBJ
IHVuaXQgaXMgMl4tMzIgSm91bGVzLCAxIGZpeGVkIGNvdW50ZXJzLCAxNjM4NDAgbXMgb3ZmbCB0
aW1lcgpbICAgIDAuNTkxNDcwXSBSQVBMIFBNVTogaHcgdW5pdCBvZiBkb21haW4gcGFja2FnZSAy
Xi0xNiBKb3VsZXMKWyAgICAwLjU5MTQ3NV0gTFZUIG9mZnNldCAwIGFzc2lnbmVkIGZvciB2ZWN0
b3IgMHg0MDAKWyAgICAwLjU5MTY1NF0gcGVyZjogQU1EIElCUyBkZXRlY3RlZCAoMHgwMDAwMDNm
ZikKWyAgICAwLjU5MTY2MF0gYW1kX3VuY29yZTogNCAgYW1kX2RmIGNvdW50ZXJzIGRldGVjdGVk
ClsgICAgMC41OTE2NjZdIGFtZF91bmNvcmU6IDYgIGFtZF9sMyBjb3VudGVycyBkZXRlY3RlZApb
ICAgIDAuNTkyMDIyXSBwZXJmL2FtZF9pb21tdTogRGV0ZWN0ZWQgQU1EIElPTU1VICMwICgyIGJh
bmtzLCA0IGNvdW50ZXJzL2JhbmspLgpbICAgIDAuNTkyMjExXSBTVk06IFRTQyBzY2FsaW5nIHN1
cHBvcnRlZApbICAgIDAuNTkyMjE0XSBrdm06IE5lc3RlZCBWaXJ0dWFsaXphdGlvbiBlbmFibGVk
ClsgICAgMC41OTIyMTZdIFNWTToga3ZtOiBOZXN0ZWQgUGFnaW5nIGVuYWJsZWQKWyAgICAwLjU5
MjIyNV0gU1ZNOiBWaXJ0dWFsIFZNTE9BRCBWTVNBVkUgc3VwcG9ydGVkClsgICAgMC41OTIyMjdd
IFNWTTogVmlydHVhbCBHSUYgc3VwcG9ydGVkClsgICAgMC41OTIyMjhdIFNWTTogTEJSIHZpcnR1
YWxpemF0aW9uIHN1cHBvcnRlZApbICAgIDAuNTk4ODk5XSBJbml0aWFsaXNlIHN5c3RlbSB0cnVz
dGVkIGtleXJpbmdzClsgICAgMC41OTg5NDldIHdvcmtpbmdzZXQ6IHRpbWVzdGFtcF9iaXRzPTQ2
IG1heF9vcmRlcj0yMiBidWNrZXRfb3JkZXI9MApbICAgIDAuNjAwMjY2XSBmdXNlOiBpbml0IChB
UEkgdmVyc2lvbiA3LjM2KQpbICAgIDAuNjAwMzQ4XSBTR0kgWEZTIHdpdGggQUNMcywgc2VjdXJp
dHkgYXR0cmlidXRlcywgc2NydWIsIHJlcGFpciwgbm8gZGVidWcgZW5hYmxlZApbICAgIDAuNjA0
OTI3XSBORVQ6IFJlZ2lzdGVyZWQgUEZfQUxHIHByb3RvY29sIGZhbWlseQpbICAgIDAuNjA0OTMx
XSBLZXkgdHlwZSBhc3ltbWV0cmljIHJlZ2lzdGVyZWQKWyAgICAwLjYwNDkzM10gQXN5bW1ldHJp
YyBrZXkgcGFyc2VyICd4NTA5JyByZWdpc3RlcmVkClsgICAgMC42MDQ5NDNdIEJsb2NrIGxheWVy
IFNDU0kgZ2VuZXJpYyAoYnNnKSBkcml2ZXIgdmVyc2lvbiAwLjQgbG9hZGVkIChtYWpvciAyNDYp
ClsgICAgMC42MDQ5OTddIGlvIHNjaGVkdWxlciBtcS1kZWFkbGluZSByZWdpc3RlcmVkClsgICAg
MC42MDUwMDBdIGlvIHNjaGVkdWxlciBreWJlciByZWdpc3RlcmVkClsgICAgMC42MDUwMDddIGlv
IHNjaGVkdWxlciBiZnEgcmVnaXN0ZXJlZApbICAgIDAuNjA4Mjg5XSBzaHBjaHA6IFN0YW5kYXJk
IEhvdCBQbHVnIFBDSSBDb250cm9sbGVyIERyaXZlciB2ZXJzaW9uOiAwLjQKWyAgICAwLjY2MDM2
M10gQUNQSTogQUM6IEFDIEFkYXB0ZXIgW0FDQURdIChvZmYtbGluZSkKWyAgICAwLjY2MDQ0M10g
aW5wdXQ6IFBvd2VyIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhTWUJVUzowMC9Q
TlAwQzBDOjAwL2lucHV0L2lucHV0MApbICAgIDAuNjYwNDczXSBBQ1BJOiBidXR0b246IFBvd2Vy
IEJ1dHRvbiBbUFdSQl0KWyAgICAwLjY2MDUxOF0gaW5wdXQ6IExpZCBTd2l0Y2ggYXMgL2Rldmlj
ZXMvTE5YU1lTVE06MDAvTE5YU1lCVVM6MDAvUE5QMEMwRDowMC9pbnB1dC9pbnB1dDEKWyAgICAw
LjY2MDU0Ml0gQUNQSTogYnV0dG9uOiBMaWQgU3dpdGNoIFtMSURdClsgICAgMC42NjA1ODBdIGlu
cHV0OiBQb3dlciBCdXR0b24gYXMgL2RldmljZXMvTE5YU1lTVE06MDAvTE5YUFdSQk46MDAvaW5w
dXQvaW5wdXQyClsgICAgMC42NjA2MjhdIEFDUEk6IGJ1dHRvbjogUG93ZXIgQnV0dG9uIFtQV1JG
XQpbICAgIDAuNjYwNzE2XSBBQ1BJOiB2aWRlbzogVmlkZW8gRGV2aWNlIFtWR0FdIChtdWx0aS1o
ZWFkOiB5ZXMgIHJvbTogbm8gIHBvc3Q6IG5vKQpbICAgIDAuNjYxMDE4XSBhY3BpIGRldmljZTow
ODogcmVnaXN0ZXJlZCBhcyBjb29saW5nX2RldmljZTAKWyAgICAwLjY2MTA2M10gaW5wdXQ6IFZp
ZGVvIEJ1cyBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhTWUJVUzowMC9QTlAwQTA4OjAwL2Rl
dmljZTowNy9MTlhWSURFTzowMC9pbnB1dC9pbnB1dDMKWyAgICAwLjY2MTIyOF0gTW9uaXRvci1N
d2FpdCB3aWxsIGJlIHVzZWQgdG8gZW50ZXIgQy0xIHN0YXRlClsgICAgMC42NjEyMzZdIEFDUEk6
IFxfU0JfLlBMVEYuUDAwMDogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYxMjQ2XSBBQ1BJ
OiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVy
ClsgICAgMC42NjE0MzRdIEFDUEk6IFxfU0JfLlBMVEYuUDAwMTogRm91bmQgMyBpZGxlIHN0YXRl
cwpbICAgIDAuNjYxNDQ2XSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBs
YXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjE2MzFdIEFDUEk6IFxfU0JfLlBMVEYuUDAw
MjogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYxNjQxXSBBQ1BJOiBGVyBpc3N1ZTogd29y
a2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjE4NjFd
IEFDUEk6IFxfU0JfLlBMVEYuUDAwMzogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYxODcw
XSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9m
IG9yZGVyClsgICAgMC42NjIxMDVdIEFDUEk6IFxfU0JfLlBMVEYuUDAwNDogRm91bmQgMyBpZGxl
IHN0YXRlcwpbICAgIDAuNjYyMTIxXSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1z
dGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjIzNjJdIEFDUEk6IFxfU0JfLlBM
VEYuUDAwNTogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYyMzcyXSBBQ1BJOiBGVyBpc3N1
ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42
NjI1NzNdIEFDUEk6IFxfU0JfLlBMVEYuUDAwNjogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAu
NjYyNTgzXSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMg
b3V0IG9mIG9yZGVyClsgICAgMC42NjI3MjFdIEFDUEk6IFxfU0JfLlBMVEYuUDAwNzogRm91bmQg
MyBpZGxlIHN0YXRlcwpbICAgIDAuNjYyNzMwXSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91
bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjI5MTJdIEFDUEk6IFxf
U0JfLlBMVEYuUDAwODogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYyOTIyXSBBQ1BJOiBG
VyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsg
ICAgMC42NjMwNzVdIEFDUEk6IFxfU0JfLlBMVEYuUDAwOTogRm91bmQgMyBpZGxlIHN0YXRlcwpb
ICAgIDAuNjYzMDg0XSBBQ1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRl
bmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjMyNDldIEFDUEk6IFxfU0JfLlBMVEYuUDAwQTog
Rm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYzMjU4XSBBQ1BJOiBGVyBpc3N1ZTogd29ya2lu
ZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9yZGVyClsgICAgMC42NjM0MDBdIEFD
UEk6IFxfU0JfLlBMVEYuUDAwQjogRm91bmQgMyBpZGxlIHN0YXRlcwpbICAgIDAuNjYzNDA3XSBB
Q1BJOiBGVyBpc3N1ZTogd29ya2luZyBhcm91bmQgQy1zdGF0ZSBsYXRlbmNpZXMgb3V0IG9mIG9y
ZGVyClsgICAgMC42NjQzNDldIEFDUEkgRXJyb3I6IEFFX05PVF9GT1VORCwgV2hpbGUgcmVzb2x2
aW5nIGEgbmFtZWQgcmVmZXJlbmNlIHBhY2thZ2UgZWxlbWVudCAtIFxfUFJfLlAwMDAgKDIwMjEx
MjE3L2RzcGtnaW5pdC00MzgpClsgICAgMC42NjQzNjBdIEFDUEk6IFxfVFpfLlRIUk06IEludmFs
aWQgcGFzc2l2ZSB0aHJlc2hvbGQKWyAgICAwLjY2NTA4NV0gdGhlcm1hbCBMTlhUSEVSTTowMDog
cmVnaXN0ZXJlZCBhcyB0aGVybWFsX3pvbmUwClsgICAgMC42NjUwODldIEFDUEk6IHRoZXJtYWw6
IFRoZXJtYWwgWm9uZSBbVEhSTV0gKDQ0IEMpClsgICAgMC42NjYwNzRdIFNlcmlhbDogODI1MC8x
NjU1MCBkcml2ZXIsIDQgcG9ydHMsIElSUSBzaGFyaW5nIGVuYWJsZWQKWyAgICAwLjY2NjM3Ml0g
Tm9uLXZvbGF0aWxlIG1lbW9yeSBkcml2ZXIgdjEuMwpbICAgIDAuNjY2MzgwXSBMaW51eCBhZ3Bn
YXJ0IGludGVyZmFjZSB2MC4xMDMKWyAgICAwLjY4MTU1Ml0gQUNQSTogYmF0dGVyeTogU2xvdCBb
QkFUMF0gKGJhdHRlcnkgcHJlc2VudCkKWyAgICAwLjY4MTk4OF0gQU1ELVZpOiBBTUQgSU9NTVV2
MiBsb2FkZWQgYW5kIGluaXRpYWxpemVkClsgICAgMC42ODIwNjddIEFDUEk6IGJ1cyB0eXBlIGRy
bV9jb25uZWN0b3IgcmVnaXN0ZXJlZApbICAgIDAuNjgyMTAxXSBbZHJtXSBhbWRncHUga2VybmVs
IG1vZGVzZXR0aW5nIGVuYWJsZWQuClsgICAgMC42ODIxMTddIGFtZGdwdTogdmdhX3N3aXRjaGVy
b286IGRldGVjdGVkIHN3aXRjaGluZyBtZXRob2QgXF9TQl8uUENJMC5HUDE3LlZHQV8uQVRQWCBo
YW5kbGUKWyAgICAwLjY4MjU1OF0gQVRQWCB2ZXJzaW9uIDEsIGZ1bmN0aW9ucyAweDAwMDAwMjAw
ClsgICAgMC42ODQ2MTZdIGFtZGdwdTogVmlydHVhbCBDUkFUIHRhYmxlIGNyZWF0ZWQgZm9yIENQ
VQpbICAgIDAuNjg0NjI5XSBhbWRncHU6IFRvcG9sb2d5OiBBZGQgQ1BVIG5vZGUKWyAgICAwLjY4
NDY3NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogdmdhYXJiOiBkZWFjdGl2YXRlIHZnYSBjb25zb2xl
ClsgICAgMC42ODQ3MTRdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDAw
NiAtPiAwMDA3KQpbICAgIDAuNjg0NzU4XSBbZHJtXSBpbml0aWFsaXppbmcga2VybmVsIG1vZGVz
ZXR0aW5nIChSRU5PSVIgMHgxMDAyOjB4MTYzNiAweDEwM0M6MHg4N0IyIDB4QzcpLgpbICAgIDAu
Njg0NzYzXSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IFRydXN0ZWQgTWVtb3J5IFpvbmUg
KFRNWikgZmVhdHVyZSBlbmFibGVkClsgICAgMC43ODI3ODBdIFtkcm1dIHJlZ2lzdGVyIG1taW8g
YmFzZTogMHhGQzUwMDAwMApbICAgIDAuNzgyNzkxXSBbZHJtXSByZWdpc3RlciBtbWlvIHNpemU6
IDUyNDI4OApbICAgIDAuNzg0Mzc0XSBbZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDAgPHNvYzE1
X2NvbW1vbj4KWyAgICAwLjc4NDM4Ml0gW2RybV0gYWRkIGlwIGJsb2NrIG51bWJlciAxIDxnbWNf
djlfMD4KWyAgICAwLjc4NDM4N10gW2RybV0gYWRkIGlwIGJsb2NrIG51bWJlciAyIDx2ZWdhMTBf
aWg+ClsgICAgMC43ODQzOTFdIFtkcm1dIGFkZCBpcCBibG9jayBudW1iZXIgMyA8cHNwPgpbICAg
IDAuNzg0Mzk0XSBbZHJtXSBhZGQgaXAgYmxvY2sgbnVtYmVyIDQgPHNtdT4KWyAgICAwLjc4NDM5
OF0gW2RybV0gYWRkIGlwIGJsb2NrIG51bWJlciA1IDxkbT4KWyAgICAwLjc4NDQwMl0gW2RybV0g
YWRkIGlwIGJsb2NrIG51bWJlciA2IDxnZnhfdjlfMD4KWyAgICAwLjc4NDQwNl0gW2RybV0gYWRk
IGlwIGJsb2NrIG51bWJlciA3IDxzZG1hX3Y0XzA+ClsgICAgMC43ODQ0MTBdIFtkcm1dIGFkZCBp
cCBibG9jayBudW1iZXIgOCA8dmNuX3YyXzA+ClsgICAgMC43ODQ0MTRdIFtkcm1dIGFkZCBpcCBi
bG9jayBudW1iZXIgOSA8anBlZ192Ml8wPgpbICAgIDAuNzg0NDI4XSBhbWRncHUgMDAwMDowNTow
MC4wOiBhbWRncHU6IEZldGNoZWQgVkJJT1MgZnJvbSBWRkNUClsgICAgMC43ODQ0MzVdIGFtZGdw
dTogQVRPTSBCSU9TOiAxMTMtUkVOT0lSLTAzMQpbICAgIDAuNzg0NDUwXSBbZHJtXSBWQ04gZGVj
b2RlIGlzIGVuYWJsZWQgaW4gVk0gbW9kZQpbICAgIDAuNzg0NDU0XSBbZHJtXSBWQ04gZW5jb2Rl
IGlzIGVuYWJsZWQgaW4gVk0gbW9kZQpbICAgIDAuNzg0NDU3XSBbZHJtXSBKUEVHIGRlY29kZSBp
cyBlbmFibGVkIGluIFZNIG1vZGUKWyAgICAwLjc4NDQ2Ml0gYW1kZ3B1IDAwMDA6MDU6MDAuMDog
YW1kZ3B1OiBQQ0lFIGF0b21pYyBvcHMgaXMgbm90IHN1cHBvcnRlZApbICAgIDAuNzg0NDc3XSBh
bWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IE1PREUyIHJlc2V0ClsgICAgMC43ODQ1NDBdIFtk
cm1dIHZtIHNpemUgaXMgMjYyMTQ0IEdCLCA0IGxldmVscywgYmxvY2sgc2l6ZSBpcyA5LWJpdCwg
ZnJhZ21lbnQgc2l6ZSBpcyA5LWJpdApbICAgIDAuNzg0NTUxXSBhbWRncHUgMDAwMDowNTowMC4w
OiBhbWRncHU6IFZSQU06IDUxMk0gMHgwMDAwMDBGNDAwMDAwMDAwIC0gMHgwMDAwMDBGNDFGRkZG
RkZGICg1MTJNIHVzZWQpClsgICAgMC43ODQ1NjBdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdw
dTogR0FSVDogMTAyNE0gMHgwMDAwMDAwMDAwMDAwMDAwIC0gMHgwMDAwMDAwMDNGRkZGRkZGClsg
ICAgMC43ODQ1NjddIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogQUdQOiAyNjc0MTk2NDhN
IDB4MDAwMDAwRjgwMDAwMDAwMCAtIDB4MDAwMEZGRkZGRkZGRkZGRgpbICAgIDAuNzg0NTgwXSBb
ZHJtXSBEZXRlY3RlZCBWUkFNIFJBTT01MTJNLCBCQVI9NTEyTQpbICAgIDAuNzg0NTg0XSBbZHJt
XSBSQU0gd2lkdGggMTI4Yml0cyBERFI0ClsgICAgMC43ODQ2NTJdIFtkcm1dIGFtZGdwdTogNTEy
TSBvZiBWUkFNIG1lbW9yeSByZWFkeQpbICAgIDAuNzg0NjU2XSBbZHJtXSBhbWRncHU6IDMwNzJN
IG9mIEdUVCBtZW1vcnkgcmVhZHkuClsgICAgMC43ODQ2NzBdIFtkcm1dIEdBUlQ6IG51bSBjcHUg
cGFnZXMgMjYyMTQ0LCBudW0gZ3B1IHBhZ2VzIDI2MjE0NApbICAgIDAuNzg0ODEwXSBbZHJtXSBQ
Q0lFIEdBUlQgb2YgMTAyNE0gZW5hYmxlZC4KWyAgICAwLjc4NDgxNF0gW2RybV0gUFRCIGxvY2F0
ZWQgYXQgMHgwMDAwMDBGNDAwOTAwMDAwClsgICAgMC43ODQ5MzVdIGFtZGdwdSAwMDAwOjA1OjAw
LjA6IGFtZGdwdTogUFNQIHJ1bnRpbWUgZGF0YWJhc2UgZG9lc24ndCBleGlzdApbICAgIDAuNzg0
OTQ3XSBbZHJtXSBMb2FkaW5nIERNVUIgZmlybXdhcmUgdmlhIFBTUDogdmVyc2lvbj0weDAxMDEw
MDFGClsgICAgMC43ODU2MjZdIFtkcm1dIEZvdW5kIFZDTiBmaXJtd2FyZSBWZXJzaW9uIEVOQzog
MS4xNyBERUM6IDUgVkVQOiAwIFJldmlzaW9uOiAyClsgICAgMC43ODU2MzNdIGFtZGdwdSAwMDAw
OjA1OjAwLjA6IGFtZGdwdTogV2lsbCB1c2UgUFNQIHRvIGxvYWQgVkNOIGZpcm13YXJlClsgICAg
MS41MzIwNjBdIFtkcm1dIHJlc2VydmUgMHg0MDAwMDAgZnJvbSAweGY0MWY4MDAwMDAgZm9yIFBT
UCBUTVIKWyAgICAxLjYxODc3NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBSQVM6IG9w
dGlvbmFsIHJhcyB0YSB1Y29kZSBpcyBub3QgYXZhaWxhYmxlClsgICAgMS42MjgwNDhdIGFtZGdw
dSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogUkFQOiBvcHRpb25hbCByYXAgdGEgdWNvZGUgaXMgbm90
IGF2YWlsYWJsZQpbICAgIDEuNjI4MDU1XSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IFNF
Q1VSRURJU1BMQVk6IHNlY3VyZWRpc3BsYXkgdGEgdWNvZGUgaXMgbm90IGF2YWlsYWJsZQpbICAg
IDEuNjI4MzE5XSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IFNNVSBpcyBpbml0aWFsaXpl
ZCBzdWNjZXNzZnVsbHkhClsgICAgMS42Mjg1MjVdIFtkcm1dIERpc3BsYXkgQ29yZSBpbml0aWFs
aXplZCB3aXRoIHYzLjIuMTc3IQpbICAgIDEuNjI5MDcxXSBbZHJtXSBETVVCIGhhcmR3YXJlIGlu
aXRpYWxpemVkOiB2ZXJzaW9uPTB4MDEwMTAwMUYKWyAgICAxLjY0MjA3N10gdHNjOiBSZWZpbmVk
IFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJhdGlvbjogMzAxNi43MzYgTUh6ClsgICAgMS42NDIwOTZd
IGNsb2Nrc291cmNlOiB0c2M6IG1hc2s6IDB4ZmZmZmZmZmZmZmZmZmZmZiBtYXhfY3ljbGVzOiAw
eDJiN2MwNzkwZTJjLCBtYXhfaWRsZV9uczogNDQwNzk1MzMwNDk1IG5zClsgICAgMS42NDIzNDdd
IGNsb2Nrc291cmNlOiBTd2l0Y2hlZCB0byBjbG9ja3NvdXJjZSB0c2MKWyAgICAxLjgzNDg4NF0g
W2RybV0ga2lxIHJpbmcgbWVjIDIgcGlwZSAxIHEgMApbICAgIDEuODM3Mjg4XSBbZHJtXSBWQ04g
ZGVjb2RlIGFuZCBlbmNvZGUgaW5pdGlhbGl6ZWQgc3VjY2Vzc2Z1bGx5KHVuZGVyIERQRyBNb2Rl
KS4KWyAgICAxLjgzNzMwOV0gW2RybV0gSlBFRyBkZWNvZGUgaW5pdGlhbGl6ZWQgc3VjY2Vzc2Z1
bGx5LgpbICAgIDEuODM4OTgwXSBrZmQga2ZkOiBhbWRncHU6IEFsbG9jYXRlZCAzOTY5MDU2IGJ5
dGVzIG9uIGdhcnQKWyAgICAxLjgzOTEwNV0gYW1kZ3B1OiBWaXJ0dWFsIENSQVQgdGFibGUgY3Jl
YXRlZCBmb3IgR1BVClsgICAgMS44MzkxNTVdIGFtZGdwdTogVG9wb2xvZ3k6IEFkZCBkR1BVIG5v
ZGUgWzB4MTYzNjoweDEwMDJdClsgICAgMS44MzkxNTldIGtmZCBrZmQ6IGFtZGdwdTogYWRkZWQg
ZGV2aWNlIDEwMDI6MTYzNgpbICAgIDEuODM5MTY4XSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRn
cHU6IFNFIDEsIFNIIHBlciBTRSAxLCBDVSBwZXIgU0ggOCwgYWN0aXZlX2N1X251bWJlciA2Clsg
ICAgMS44MzkyNjddIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBnZnggdXNlcyBW
TSBpbnYgZW5nIDAgb24gaHViIDAKWyAgICAxLjgzOTI3MV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDog
YW1kZ3B1OiByaW5nIGNvbXBfMS4wLjAgdXNlcyBWTSBpbnYgZW5nIDEgb24gaHViIDAKWyAgICAx
LjgzOTI3NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4xLjAgdXNl
cyBWTSBpbnYgZW5nIDQgb24gaHViIDAKWyAgICAxLjgzOTI3OF0gYW1kZ3B1IDAwMDA6MDU6MDAu
MDogYW1kZ3B1OiByaW5nIGNvbXBfMS4yLjAgdXNlcyBWTSBpbnYgZW5nIDUgb24gaHViIDAKWyAg
ICAxLjgzOTI4MV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4zLjAg
dXNlcyBWTSBpbnYgZW5nIDYgb24gaHViIDAKWyAgICAxLjgzOTI4NF0gYW1kZ3B1IDAwMDA6MDU6
MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4wLjEgdXNlcyBWTSBpbnYgZW5nIDcgb24gaHViIDAK
WyAgICAxLjgzOTI4OF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4x
LjEgdXNlcyBWTSBpbnYgZW5nIDggb24gaHViIDAKWyAgICAxLjgzOTI5MV0gYW1kZ3B1IDAwMDA6
MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4yLjEgdXNlcyBWTSBpbnYgZW5nIDkgb24gaHVi
IDAKWyAgICAxLjgzOTI5NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBf
MS4zLjEgdXNlcyBWTSBpbnYgZW5nIDEwIG9uIGh1YiAwClsgICAgMS44MzkyOTddIGFtZGdwdSAw
MDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBraXFfMi4xLjAgdXNlcyBWTSBpbnYgZW5nIDExIG9u
IGh1YiAwClsgICAgMS44MzkzMDFdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBz
ZG1hMCB1c2VzIFZNIGludiBlbmcgMCBvbiBodWIgMQpbICAgIDEuODM5MzA0XSBhbWRncHUgMDAw
MDowNTowMC4wOiBhbWRncHU6IHJpbmcgdmNuX2RlYyB1c2VzIFZNIGludiBlbmcgMSBvbiBodWIg
MQpbICAgIDEuODM5MzA3XSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IHJpbmcgdmNuX2Vu
YzAgdXNlcyBWTSBpbnYgZW5nIDQgb24gaHViIDEKWyAgICAxLjgzOTMxMV0gYW1kZ3B1IDAwMDA6
MDU6MDAuMDogYW1kZ3B1OiByaW5nIHZjbl9lbmMxIHVzZXMgVk0gaW52IGVuZyA1IG9uIGh1YiAx
ClsgICAgMS44MzkzMTRdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBqcGVnX2Rl
YyB1c2VzIFZNIGludiBlbmcgNiBvbiBodWIgMQpbICAgIDEuODQwMjY3XSBbZHJtXSBJbml0aWFs
aXplZCBhbWRncHUgMy40Ni4wIDIwMTUwMTAxIGZvciAwMDAwOjA1OjAwLjAgb24gbWlub3IgMApb
ICAgIDEuODQ0Nzg2XSBmYmNvbjogYW1kZ3B1ZHJtZmIgKGZiMCkgaXMgcHJpbWFyeSBkZXZpY2UK
WyAgICAxLjg0NDg1M10gW2RybV0gRFNDIHByZWNvbXB1dGUgaXMgbm90IG5lZWRlZC4KWyAgICAx
LjkxOTI0OF0gQ29uc29sZTogc3dpdGNoaW5nIHRvIGNvbG91ciBmcmFtZSBidWZmZXIgZGV2aWNl
IDI0MHg2NwpbICAgIDEuOTM2MDA0XSBhbWRncHUgMDAwMDowNTowMC4wOiBbZHJtXSBmYjA6IGFt
ZGdwdWRybWZiIGZyYW1lIGJ1ZmZlciBkZXZpY2UKWyAgICAxLjkzNjE0NF0gdXNiY29yZTogcmVn
aXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1ZGwKWyAgICAxLjkzODQ0Ml0gYnJkOiBtb2R1
bGUgbG9hZGVkClsgICAgMS45Mzk2NjRdIGxvb3A6IG1vZHVsZSBsb2FkZWQKWyAgICAxLjk0MDE5
N10gbnZtZSAwMDAwOjA0OjAwLjA6IHBsYXRmb3JtIHF1aXJrOiBzZXR0aW5nIHNpbXBsZSBzdXNw
ZW5kClsgICAgMS45NDAyNDVdIG52bWUgbnZtZTA6IHBjaSBmdW5jdGlvbiAwMDAwOjA0OjAwLjAK
WyAgICAxLjk0MDMwNV0gYWhjaSAwMDAwOjA2OjAwLjA6IHZlcnNpb24gMy4wClsgICAgMS45NDA1
ODBdIGFoY2kgMDAwMDowNjowMC4wOiBBSENJIDAwMDEuMDMwMSAzMiBzbG90cyAxIHBvcnRzIDYg
R2JwcyAweDEgaW1wbCBTQVRBIG1vZGUKWyAgICAxLjk0MDYwOF0gYWhjaSAwMDAwOjA2OjAwLjA6
IGZsYWdzOiA2NGJpdCBuY3Egc250ZiBpbGNrIHBtIGxlZCBjbG8gb25seSBwbXAgZmJzIHBpbyBz
bHVtIHBhcnQgClsgICAgMS45NDA3OTRdIHNjc2kgaG9zdDA6IGFoY2kKWyAgICAxLjk0MDg1NF0g
YXRhMTogU0FUQSBtYXggVURNQS8xMzMgYWJhciBtMjA0OEAweGZjNjAxMDAwIHBvcnQgMHhmYzYw
MTEwMCBpcnEgMzEKWyAgICAxLjk0MDk2OF0gYWhjaSAwMDAwOjA2OjAwLjE6IEFIQ0kgMDAwMS4w
MzAxIDMyIHNsb3RzIDEgcG9ydHMgNiBHYnBzIDB4MSBpbXBsIFNBVEEgbW9kZQpbICAgIDEuOTQx
MDAwXSBhaGNpIDAwMDA6MDY6MDAuMTogZmxhZ3M6IDY0Yml0IG5jcSBzbnRmIGlsY2sgcG0gbGVk
IGNsbyBvbmx5IHBtcCBmYnMgcGlvIHNsdW0gcGFydCAKWyAgICAxLjk0MTE1NF0gc2NzaSBob3N0
MTogYWhjaQpbICAgIDEuOTQxMTk4XSBhdGEyOiBTQVRBIG1heCBVRE1BLzEzMyBhYmFyIG0yMDQ4
QDB4ZmM2MDAwMDAgcG9ydCAweGZjNjAwMTAwIGlycSAzMwpbICAgIDEuOTQxMzQyXSB0dW46IFVu
aXZlcnNhbCBUVU4vVEFQIGRldmljZSBkcml2ZXIsIDEuNgpbICAgIDEuOTQxNDA0XSByODE2OSAw
MDAwOjAyOjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDAwMCAtPiAwMDAzKQpbICAgIDEuOTQxNDcx
XSByODE2OSAwMDAwOjAyOjAwLjA6IGNhbid0IGRpc2FibGUgQVNQTTsgT1MgZG9lc24ndCBoYXZl
IEFTUE0gY29udHJvbApbICAgIDEuOTQ1MDI1XSBudm1lIG52bWUwOiBtaXNzaW5nIG9yIGludmFs
aWQgU1VCTlFOIGZpZWxkLgpbICAgIDEuOTQ4NzkyXSByODE2OSAwMDAwOjAyOjAwLjAgZXRoMDog
UlRMODE2OGgvODExMWgsIDMwOjI0OmE5OjdkOjAzOjBmLCBYSUQgNTQxLCBJUlEgNTEKWyAgICAx
Ljk0ODgzNV0gcjgxNjkgMDAwMDowMjowMC4wIGV0aDA6IGp1bWJvIGZlYXR1cmVzIFtmcmFtZXM6
IDkxOTQgYnl0ZXMsIHR4IGNoZWNrc3VtbWluZzoga29dClsgICAgMS45NDg5ODldIHJ0d184ODIy
Y2UgMDAwMDowMzowMC4wOiBGaXJtd2FyZSB2ZXJzaW9uIDkuOS4xMSwgSDJDIHZlcnNpb24gMTUK
WyAgICAxLjk0OTAxMF0gcnR3Xzg4MjJjZSAwMDAwOjAzOjAwLjA6IEZpcm13YXJlIHZlcnNpb24g
OS45LjQsIEgyQyB2ZXJzaW9uIDE1ClsgICAgMS45NDkwNzBdIHJ0d184ODIyY2UgMDAwMDowMzow
MC4wOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4gMDAwMykKWyAgICAxLjk0OTA5OV0gbnZtZSBu
dm1lMDogMTYvMC8wIGRlZmF1bHQvcmVhZC9wb2xsIHF1ZXVlcwpbICAgIDEuOTUyMjQxXSAgbnZt
ZTBuMTogcDEgcDIgcDMgcDQgcDUgcDYgcDcKWyAgICAxLjk3NTk1MF0gdXNiY29yZTogcmVnaXN0
ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBjZGNfZXRoZXIKWyAgICAxLjk3NTk4NF0gdXNiY29y
ZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBjZGNfZWVtClsgICAgMS45NzYwMDdd
IHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgY2RjX25jbQpbICAgIDEu
OTc2MjE0XSB4aGNpX2hjZCAwMDAwOjA1OjAwLjM6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICAg
MS45NzYzMjZdIHhoY2lfaGNkIDAwMDA6MDU6MDAuMzogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwg
YXNzaWduZWQgYnVzIG51bWJlciAxClsgICAgMS45NzY0MzVdIHhoY2lfaGNkIDAwMDA6MDU6MDAu
MzogaGNjIHBhcmFtcyAweDAyNjhmZmU1IGhjaSB2ZXJzaW9uIDB4MTEwIHF1aXJrcyAweDAwMDAw
MjAwMDAwMDA0MTAKWyAgICAxLjk3NjcyNl0gdXNiIHVzYjE6IE5ldyBVU0IgZGV2aWNlIGZvdW5k
LCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMiwgYmNkRGV2aWNlPSA1LjE4ClsgICAgMS45
NzY3NTNdIHVzYiB1c2IxOiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVjdD0y
LCBTZXJpYWxOdW1iZXI9MQpbICAgIDEuOTc2Nzc0XSB1c2IgdXNiMTogUHJvZHVjdDogeEhDSSBI
b3N0IENvbnRyb2xsZXIKWyAgICAxLjk3Njc5MF0gdXNiIHVzYjE6IE1hbnVmYWN0dXJlcjogTGlu
dXggNS4xOC4wLXJjNyB4aGNpLWhjZApbICAgIDEuOTc3NTM2XSB1c2IgdXNiMTogU2VyaWFsTnVt
YmVyOiAwMDAwOjA1OjAwLjMKWyAgICAxLjk3ODk0N10gaHViIDEtMDoxLjA6IFVTQiBodWIgZm91
bmQKWyAgICAxLjk4MDY4MV0gaHViIDEtMDoxLjA6IDQgcG9ydHMgZGV0ZWN0ZWQKWyAgICAxLjk4
MTczOV0geGhjaV9oY2QgMDAwMDowNTowMC4zOiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDEu
OTgyODQwXSB4aGNpX2hjZCAwMDAwOjA1OjAwLjM6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFz
c2lnbmVkIGJ1cyBudW1iZXIgMgpbICAgIDEuOTgzOTQ3XSB4aGNpX2hjZCAwMDAwOjA1OjAwLjM6
IEhvc3Qgc3VwcG9ydHMgVVNCIDMuMSBFbmhhbmNlZCBTdXBlclNwZWVkClsgICAgMS45ODU1OThd
IHVzYiB1c2IyOiBXZSBkb24ndCBrbm93IHRoZSBhbGdvcml0aG1zIGZvciBMUE0gZm9yIHRoaXMg
aG9zdCwgZGlzYWJsaW5nIExQTS4KWyAgICAxLjk4NjQzOF0gdXNiIHVzYjI6IE5ldyBVU0IgZGV2
aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMywgYmNkRGV2aWNlPSA1LjE4
ClsgICAgMS45ODc2ODRdIHVzYiB1c2IyOiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9Mywg
UHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MQpbICAgIDEuOTg4ODcxXSB1c2IgdXNiMjogUHJvZHVj
dDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgICAxLjk5MDEwOF0gdXNiIHVzYjI6IE1hbnVmYWN0
dXJlcjogTGludXggNS4xOC4wLXJjNyB4aGNpLWhjZApbICAgIDEuOTkxMDU1XSB1c2IgdXNiMjog
U2VyaWFsTnVtYmVyOiAwMDAwOjA1OjAwLjMKWyAgICAxLjk5MjIwNV0gaHViIDItMDoxLjA6IFVT
QiBodWIgZm91bmQKWyAgICAxLjk5MzA5OV0gaHViIDItMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQK
WyAgICAxLjk5NDg1NV0geGhjaV9oY2QgMDAwMDowNTowMC40OiB4SENJIEhvc3QgQ29udHJvbGxl
cgpbICAgIDEuOTk2NTY2XSB4aGNpX2hjZCAwMDAwOjA1OjAwLjQ6IG5ldyBVU0IgYnVzIHJlZ2lz
dGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMwpbICAgIDEuOTk3ODg5XSB4aGNpX2hjZCAwMDAw
OjA1OjAwLjQ6IGhjYyBwYXJhbXMgMHgwMjY4ZmZlNSBoY2kgdmVyc2lvbiAweDExMCBxdWlya3Mg
MHgwMDAwMDIwMDAwMDAwNDEwClsgICAgMS45OTk0MDBdIHVzYiB1c2IzOiBOZXcgVVNCIGRldmlj
ZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDIsIGJjZERldmljZT0gNS4xOApb
ICAgIDIuMDAwMDk3XSB1c2IgdXNiMzogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFBy
b2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgICAyLjAwMTE0MF0gdXNiIHVzYjM6IFByb2R1Y3Q6
IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICAgMi4wMDE5NjldIHVzYiB1c2IzOiBNYW51ZmFjdHVy
ZXI6IExpbnV4IDUuMTguMC1yYzcgeGhjaS1oY2QKWyAgICAyLjAwMjk4NV0gdXNiIHVzYjM6IFNl
cmlhbE51bWJlcjogMDAwMDowNTowMC40ClsgICAgMi4wMDM5OThdIGh1YiAzLTA6MS4wOiBVU0Ig
aHViIGZvdW5kClsgICAgMi4wMDUwMDldIGh1YiAzLTA6MS4wOiA0IHBvcnRzIGRldGVjdGVkClsg
ICAgMi4wMDYwODhdIHhoY2lfaGNkIDAwMDA6MDU6MDAuNDogeEhDSSBIb3N0IENvbnRyb2xsZXIK
WyAgICAyLjAwNzIwN10geGhjaV9oY2QgMDAwMDowNTowMC40OiBuZXcgVVNCIGJ1cyByZWdpc3Rl
cmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDQKWyAgICAyLjAwODA4NF0geGhjaV9oY2QgMDAwMDow
NTowMC40OiBIb3N0IHN1cHBvcnRzIFVTQiAzLjEgRW5oYW5jZWQgU3VwZXJTcGVlZApbICAgIDIu
MDA5MDgxXSB1c2IgdXNiNDogV2UgZG9uJ3Qga25vdyB0aGUgYWxnb3JpdGhtcyBmb3IgTFBNIGZv
ciB0aGlzIGhvc3QsIGRpc2FibGluZyBMUE0uClsgICAgMi4wMTAyNjldIHVzYiB1c2I0OiBOZXcg
VVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDMsIGJjZERldmlj
ZT0gNS4xOApbICAgIDIuMDExMDgzXSB1c2IgdXNiNDogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczog
TWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgICAyLjAxMjAyNF0gdXNiIHVzYjQ6
IFByb2R1Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICAgMi4wMTI3OThdIHVzYiB1c2I0OiBN
YW51ZmFjdHVyZXI6IExpbnV4IDUuMTguMC1yYzcgeGhjaS1oY2QKWyAgICAyLjAxMzg3MF0gdXNi
IHVzYjQ6IFNlcmlhbE51bWJlcjogMDAwMDowNTowMC40ClsgICAgMi4wMTQ4MzddIGh1YiA0LTA6
MS4wOiBVU0IgaHViIGZvdW5kClsgICAgMi4wMTU4NTJdIGh1YiA0LTA6MS4wOiAyIHBvcnRzIGRl
dGVjdGVkClsgICAgMi4wMTY2OTBdIHVzYjogcG9ydCBwb3dlciBtYW5hZ2VtZW50IG1heSBiZSB1
bnJlbGlhYmxlClsgICAgMi4wMTc4MjRdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFj
ZSBkcml2ZXIgdXNibHAKWyAgICAyLjAxODYwNl0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50
ZXJmYWNlIGRyaXZlciBjZGNfd2RtClsgICAgMi4wMTk4MTBdIHVzYmNvcmU6IHJlZ2lzdGVyZWQg
bmV3IGludGVyZmFjZSBkcml2ZXIgdWFzClsgICAgMi4wMjA1NTNdIHVzYmNvcmU6IHJlZ2lzdGVy
ZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiLXN0b3JhZ2UKWyAgICAyLjAyMTYzN10gdXNiY29y
ZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBlbWkyNiAtIGZpcm13YXJlIGxvYWRl
cgpbICAgIDIuMDIyNDk0XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVy
IGVtaTYyIC0gZmlybXdhcmUgbG9hZGVyClsgICAgMi4wMjM1MjldIGk4MDQyOiBQTlA6IFBTLzIg
Q29udHJvbGxlciBbUE5QMDMwMzpQUzJLXSBhdCAweDYwLDB4NjQgaXJxIDEKWyAgICAyLjAyNDM0
N10gaTgwNDI6IFBOUDogUFMvMiBhcHBlYXJzIHRvIGhhdmUgQVVYIHBvcnQgZGlzYWJsZWQsIGlm
IHRoaXMgaXMgaW5jb3JyZWN0IHBsZWFzZSBib290IHdpdGggaTgwNDIubm9wbnAKWyAgICAyLjAy
NjU5NF0gc2VyaW86IGk4MDQyIEtCRCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEgMQpbICAgIDIuMDI3
ODU1XSBtb3VzZWRldjogUFMvMiBtb3VzZSBkZXZpY2UgY29tbW9uIGZvciBhbGwgbWljZQpbICAg
IDIuMDI5MTY5XSBydGNfY21vcyAwMDowMTogUlRDIGNhbiB3YWtlIGZyb20gUzQKWyAgICAyLjAz
MDM3M10gcnRjX2Ntb3MgMDA6MDE6IHJlZ2lzdGVyZWQgYXMgcnRjMApbICAgIDIuMDMxMjk3XSBy
dGNfY21vcyAwMDowMTogYWxhcm1zIHVwIHRvIG9uZSBtb250aCwgeTNrLCAxMTQgYnl0ZXMgbnZy
YW0sIGhwZXQgaXJxcwpbICAgIDIuMDMyNTc2XSBpMmNfZGV2OiBpMmMgL2RldiBlbnRyaWVzIGRy
aXZlcgpbICAgIDIuMDMzNTA5XSBwaWl4NF9zbWJ1cyAwMDAwOjAwOjE0LjA6IFNNQnVzIEhvc3Qg
Q29udHJvbGxlciBhdCAweGIwMCwgcmV2aXNpb24gMApbICAgIDIuMDM0NDU4XSBwaWl4NF9zbWJ1
cyAwMDAwOjAwOjE0LjA6IFVzaW5nIHJlZ2lzdGVyIDB4MDIgZm9yIFNNQnVzIHBvcnQgc2VsZWN0
aW9uClsgICAgMi4wMzU1OTZdIHBpaXg0X3NtYnVzIDAwMDA6MDA6MTQuMDogQXV4aWxpYXJ5IFNN
QnVzIEhvc3QgQ29udHJvbGxlciBhdCAweGIyMApbICAgIDIuMDM2NjU3XSB1c2Jjb3JlOiByZWdp
c3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVyIHV2Y3ZpZGVvClsgICAgMi4wMzc0MTBdIHVzYmNv
cmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgYnR1c2IKWyAgICAyLjAzODU0Nl0g
RUZJIFZhcmlhYmxlcyBGYWNpbGl0eSB2MC4wOCAyMDA0LU1heS0xNwpbICAgIDIuMDQ0NjA4XSBw
c3RvcmU6IFJlZ2lzdGVyZWQgZWZpIGFzIHBlcnNpc3RlbnQgc3RvcmUgYmFja2VuZApbICAgIDIu
MDQ1ODE1XSBjY3AgMDAwMDowNTowMC4yOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4gMDAwMikK
WyAgICAyLjA1NzIxN10gY2NwIDAwMDA6MDU6MDAuMjogdGVlIGVuYWJsZWQKWyAgICAyLjA1ODE3
OV0gY2NwIDAwMDA6MDU6MDAuMjogcHNwIGVuYWJsZWQKWyAgICAyLjA1OTUyNF0gaGlkOiByYXcg
SElEIGV2ZW50cyBkcml2ZXIgKEMpIEppcmkgS29zaW5hClsgICAgMi4wNjAzMzRdIHVzYmNvcmU6
IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlkClsgICAgMi4wNjEzODhdIHVz
YmhpZDogVVNCIEhJRCBjb3JlIGRyaXZlcgpbICAgIDIuMDYyMzk1XSBocF9hY2NlbDogbGFwdG9w
IG1vZGVsIHVua25vd24sIHVzaW5nIGRlZmF1bHQgYXhlcyBjb25maWd1cmF0aW9uClsgICAgMi4w
ODQ1NDNdIGxpczNsdjAyZDogOCBiaXRzIDNEQyBzZW5zb3IgZm91bmQKWyAgICAyLjEwODI1NF0g
aW5wdXQ6IEFUIFRyYW5zbGF0ZWQgU2V0IDIga2V5Ym9hcmQgYXMgL2RldmljZXMvcGxhdGZvcm0v
aTgwNDIvc2VyaW8wL2lucHV0L2lucHV0NApbICAgIDIuMTE1MTAzXSBpbnB1dDogU1QgTElTM0xW
MDJETCBBY2NlbGVyb21ldGVyIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2xpczNsdjAyZC9pbnB1dC9p
bnB1dDUKWyAgICAyLjExNjYxMF0gQUNQSSBCSU9TIEVycm9yIChidWcpOiBBRV9BTUxfQlVGRkVS
X0xJTUlULCBGaWVsZCBbRDAwOF0gYXQgYml0IG9mZnNldC9sZW5ndGggMTI4LzggZXhjZWVkcyBz
aXplIG9mIHRhcmdldCBCdWZmZXIgKDEyOCBiaXRzKSAoMjAyMTEyMTcvZHNvcGNvZGUtMTk4KQpb
ICAgIDIuMTE3NjU2XSBBQ1BJIEVycm9yOiBBYm9ydGluZyBtZXRob2QgXEhXTUMgZHVlIHRvIHBy
ZXZpb3VzIGVycm9yIChBRV9BTUxfQlVGRkVSX0xJTUlUKSAoMjAyMTEyMTcvcHNwYXJzZS01Mjkp
ClsgICAgMi4xMTg1MzhdIEFDUEkgRXJyb3I6IEFib3J0aW5nIG1ldGhvZCBcX1NCLldNSUQuV01B
QSBkdWUgdG8gcHJldmlvdXMgZXJyb3IgKEFFX0FNTF9CVUZGRVJfTElNSVQpICgyMDIxMTIxNy9w
c3BhcnNlLTUyOSkKWyAgICAyLjExOTM3NF0gQUNQSSBCSU9TIEVycm9yIChidWcpOiBBRV9BTUxf
QlVGRkVSX0xJTUlULCBGaWVsZCBbRDAwOF0gYXQgYml0IG9mZnNldC9sZW5ndGggMTI4LzggZXhj
ZWVkcyBzaXplIG9mIHRhcmdldCBCdWZmZXIgKDEyOCBiaXRzKSAoMjAyMTEyMTcvZHNvcGNvZGUt
MTk4KQpbICAgIDIuMTE5ODcyXSBBQ1BJIEVycm9yOiBBYm9ydGluZyBtZXRob2QgXEhXTUMgZHVl
IHRvIHByZXZpb3VzIGVycm9yIChBRV9BTUxfQlVGRkVSX0xJTUlUKSAoMjAyMTEyMTcvcHNwYXJz
ZS01MjkpClsgICAgMi4xMjAzNzldIEFDUEkgRXJyb3I6IEFib3J0aW5nIG1ldGhvZCBcX1NCLldN
SUQuV01BQSBkdWUgdG8gcHJldmlvdXMgZXJyb3IgKEFFX0FNTF9CVUZGRVJfTElNSVQpICgyMDIx
MTIxNy9wc3BhcnNlLTUyOSkKWyAgICAyLjEyMDkyMV0gaW5wdXQ6IEhQIFdNSSBob3RrZXlzIGFz
IC9kZXZpY2VzL3ZpcnR1YWwvaW5wdXQvaW5wdXQ2ClsgICAgMi4xMjE3NjFdIEFDUEkgQklPUyBF
cnJvciAoYnVnKTogQUVfQU1MX0JVRkZFUl9MSU1JVCwgRmllbGQgW0QwMDhdIGF0IGJpdCBvZmZz
ZXQvbGVuZ3RoIDEyOC84IGV4Y2VlZHMgc2l6ZSBvZiB0YXJnZXQgQnVmZmVyICgxMjggYml0cykg
KDIwMjExMjE3L2Rzb3Bjb2RlLTE5OCkKWyAgICAyLjEyMzEzMV0gQUNQSSBFcnJvcjogQWJvcnRp
bmcgbWV0aG9kIFxIV01DIGR1ZSB0byBwcmV2aW91cyBlcnJvciAoQUVfQU1MX0JVRkZFUl9MSU1J
VCkgKDIwMjExMjE3L3BzcGFyc2UtNTI5KQpbICAgIDIuMTI0MTg4XSBBQ1BJIEVycm9yOiBBYm9y
dGluZyBtZXRob2QgXF9TQi5XTUlELldNQUEgZHVlIHRvIHByZXZpb3VzIGVycm9yIChBRV9BTUxf
QlVGRkVSX0xJTUlUKSAoMjAyMTEyMTcvcHNwYXJzZS01MjkpClsgICAgMi4xMjU0ODldIEFDUEkg
QklPUyBFcnJvciAoYnVnKTogQUVfQU1MX0JVRkZFUl9MSU1JVCwgRmllbGQgW0QwMDhdIGF0IGJp
dCBvZmZzZXQvbGVuZ3RoIDEyOC84IGV4Y2VlZHMgc2l6ZSBvZiB0YXJnZXQgQnVmZmVyICgxMjgg
Yml0cykgKDIwMjExMjE3L2Rzb3Bjb2RlLTE5OCkKWyAgICAyLjEyNjM2Ml0gQUNQSSBFcnJvcjog
QWJvcnRpbmcgbWV0aG9kIFxIV01DIGR1ZSB0byBwcmV2aW91cyBlcnJvciAoQUVfQU1MX0JVRkZF
Ul9MSU1JVCkgKDIwMjExMjE3L3BzcGFyc2UtNTI5KQpbICAgIDIuMTI3NDk5XSBBQ1BJIEVycm9y
OiBBYm9ydGluZyBtZXRob2QgXF9TQi5XTUlELldNQUEgZHVlIHRvIHByZXZpb3VzIGVycm9yIChB
RV9BTUxfQlVGRkVSX0xJTUlUKSAoMjAyMTEyMTcvcHNwYXJzZS01MjkpClsgICAgMi4xMjgxMTRd
IHJhbmRvbTogZmFzdCBpbml0IGRvbmUKWyAgICAyLjEyODYwNl0gQUNQSSBCSU9TIEVycm9yIChi
dWcpOiBBRV9BTUxfQlVGRkVSX0xJTUlULCBGaWVsZCBbRDAwOV0gYXQgYml0IG9mZnNldC9sZW5n
dGggMTM2LzggZXhjZWVkcyBzaXplIG9mIHRhcmdldCBCdWZmZXIgKDEzNiBiaXRzKSAoMjAyMTEy
MTcvZHNvcGNvZGUtMTk4KQpbICAgIDIuMTMwODU3XSBBQ1BJIEVycm9yOiBBYm9ydGluZyBtZXRo
b2QgXEhXTUMgZHVlIHRvIHByZXZpb3VzIGVycm9yIChBRV9BTUxfQlVGRkVSX0xJTUlUKSAoMjAy
MTEyMTcvcHNwYXJzZS01MjkpClsgICAgMi4xMzE4OTBdIEFDUEkgRXJyb3I6IEFib3J0aW5nIG1l
dGhvZCBcX1NCLldNSUQuV01BQSBkdWUgdG8gcHJldmlvdXMgZXJyb3IgKEFFX0FNTF9CVUZGRVJf
TElNSVQpICgyMDIxMTIxNy9wc3BhcnNlLTUyOSkKWyAgICAyLjEzMjg3Nl0gQUNQSSBCSU9TIEVy
cm9yIChidWcpOiBBRV9BTUxfQlVGRkVSX0xJTUlULCBGaWVsZCBbRDAwOV0gYXQgYml0IG9mZnNl
dC9sZW5ndGggMTM2LzggZXhjZWVkcyBzaXplIG9mIHRhcmdldCBCdWZmZXIgKDEzNiBiaXRzKSAo
MjAyMTEyMTcvZHNvcGNvZGUtMTk4KQpbICAgIDIuMTMzOTA1XSBBQ1BJIEVycm9yOiBBYm9ydGlu
ZyBtZXRob2QgXEhXTUMgZHVlIHRvIHByZXZpb3VzIGVycm9yIChBRV9BTUxfQlVGRkVSX0xJTUlU
KSAoMjAyMTEyMTcvcHNwYXJzZS01MjkpClsgICAgMi4xMzQ5NjBdIEFDUEkgRXJyb3I6IEFib3J0
aW5nIG1ldGhvZCBcX1NCLldNSUQuV01BQSBkdWUgdG8gcHJldmlvdXMgZXJyb3IgKEFFX0FNTF9C
VUZGRVJfTElNSVQpICgyMDIxMTIxNy9wc3BhcnNlLTUyOSkKWyAgICAyLjEzNjA2Nl0gQUNQSSBC
SU9TIEVycm9yIChidWcpOiBBRV9BTUxfQlVGRkVSX0xJTUlULCBGaWVsZCBbRDAwOF0gYXQgYml0
IG9mZnNldC9sZW5ndGggMTI4LzggZXhjZWVkcyBzaXplIG9mIHRhcmdldCBCdWZmZXIgKDEyOCBi
aXRzKSAoMjAyMTEyMTcvZHNvcGNvZGUtMTk4KQpbICAgIDIuMTM3MTM3XSBBQ1BJIEVycm9yOiBB
Ym9ydGluZyBtZXRob2QgXEhXTUMgZHVlIHRvIHByZXZpb3VzIGVycm9yIChBRV9BTUxfQlVGRkVS
X0xJTUlUKSAoMjAyMTEyMTcvcHNwYXJzZS01MjkpClsgICAgMi4xMzgyMzJdIEFDUEkgRXJyb3I6
IEFib3J0aW5nIG1ldGhvZCBcX1NCLldNSUQuV01BQSBkdWUgdG8gcHJldmlvdXMgZXJyb3IgKEFF
X0FNTF9CVUZGRVJfTElNSVQpICgyMDIxMTIxNy9wc3BhcnNlLTUyOSkKWyAgICAyLjE0MDI1M10g
c25kX2hkYV9pbnRlbCAwMDAwOjAxOjAwLjE6IGVuYWJsaW5nIGRldmljZSAoMDAwMCAtPiAwMDAy
KQpbICAgIDIuMTQxMzQ0XSBzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogRGlzYWJsaW5nIE1T
SQpbICAgIDIuMTQyNzI5XSBzbmRfaGRhX2ludGVsIDAwMDA6MDE6MDAuMTogSGFuZGxlIHZnYV9z
d2l0Y2hlcm9vIGF1ZGlvIGNsaWVudApbICAgIDIuMTQzNTM4XSBzbmRfaGRhX2ludGVsIDAwMDA6
MDU6MDAuNjogZW5hYmxpbmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpClsgICAgMi4xNDQzNDBdIHVz
YmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgc25kLXVzYi1hdWRpbwpbICAg
IDIuMTQ1MDg2XSBORVQ6IFJlZ2lzdGVyZWQgUEZfTExDIHByb3RvY29sIGZhbWlseQpbICAgIDIu
MTQ2Nzg5XSBJbml0aWFsaXppbmcgWEZSTSBuZXRsaW5rIHNvY2tldApbICAgIDIuMTQ4MjI0XSBO
RVQ6IFJlZ2lzdGVyZWQgUEZfSU5FVDYgcHJvdG9jb2wgZmFtaWx5ClsgICAgMi4xNDk5MDddIFNl
Z21lbnQgUm91dGluZyB3aXRoIElQdjYKWyAgICAyLjE1MDgwOV0gSW4tc2l0dSBPQU0gKElPQU0p
IHdpdGggSVB2NgpbICAgIDIuMTUxMzg1XSBpbnB1dDogRUxBTjA3MTg6MDAgMDRGMzozMEZEIE1v
dXNlIGFzIC9kZXZpY2VzL3BsYXRmb3JtL0FNREkwMDEwOjAzL2kyYy0wL2kyYy1FTEFOMDcxODow
MC8wMDE4OjA0RjM6MzBGRC4wMDAxL2lucHV0L2lucHV0NwpbICAgIDIuMTUzMDkxXSBtaXA2OiBN
b2JpbGUgSVB2NgpbICAgIDIuMTU0NTM5XSBORVQ6IFJlZ2lzdGVyZWQgUEZfUEFDS0VUIHByb3Rv
Y29sIGZhbWlseQpbICAgIDIuMTU0NTQ4XSBpbnB1dDogRUxBTjA3MTg6MDAgMDRGMzozMEZEIFRv
dWNocGFkIGFzIC9kZXZpY2VzL3BsYXRmb3JtL0FNREkwMDEwOjAzL2kyYy0wL2kyYy1FTEFOMDcx
ODowMC8wMDE4OjA0RjM6MzBGRC4wMDAxL2lucHV0L2lucHV0OQpbICAgIDIuMTU1NTMyXSBORVQ6
IFJlZ2lzdGVyZWQgUEZfS0VZIHByb3RvY29sIGZhbWlseQpbICAgIDIuMTU2ODg3XSBoaWQtbXVs
dGl0b3VjaCAwMDE4OjA0RjM6MzBGRC4wMDAxOiBpbnB1dCxoaWRyYXcwOiBJMkMgSElEIHYxLjAw
IE1vdXNlIFtFTEFOMDcxODowMCAwNEYzOjMwRkRdIG9uIGkyYy1FTEFOMDcxODowMApbICAgIDIu
MTU3OTE1XSBCbHVldG9vdGg6IFJGQ09NTSBUVFkgbGF5ZXIgaW5pdGlhbGl6ZWQKWyAgICAyLjE2
MDU3NV0gQmx1ZXRvb3RoOiBSRkNPTU0gc29ja2V0IGxheWVyIGluaXRpYWxpemVkClsgICAgMi4x
NjE5NzZdIEJsdWV0b290aDogUkZDT01NIHZlciAxLjExClsgICAgMi4xNjMyODBdIEJsdWV0b290
aDogQk5FUCAoRXRoZXJuZXQgRW11bGF0aW9uKSB2ZXIgMS4zClsgICAgMi4xNjQxNTVdIEJsdWV0
b290aDogQk5FUCBmaWx0ZXJzOiBwcm90b2NvbCBtdWx0aWNhc3QKWyAgICAyLjE2NTQzM10gQmx1
ZXRvb3RoOiBCTkVQIHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDIuMTY2ODA2XSBCbHVl
dG9vdGg6IEhJRFAgKEh1bWFuIEludGVyZmFjZSBFbXVsYXRpb24pIHZlciAxLjIKWyAgICAyLjE2
Nzg1OF0gQmx1ZXRvb3RoOiBISURQIHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDIuMTY5
MTAzXSBsMnRwX2NvcmU6IEwyVFAgY29yZSBkcml2ZXIsIFYyLjAKWyAgICAyLjE3MDIwMl0gbDJ0
cF9pcDogTDJUUCBJUCBlbmNhcHN1bGF0aW9uIHN1cHBvcnQgKEwyVFB2MykKWyAgICAyLjE3MTA4
Ml0gaW5wdXQ6IEhEQSBOVmlkaWEgSERNSS9EUCxwY209MyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAw
LzAwMDA6MDA6MDEuMS8wMDAwOjAxOjAwLjEvc291bmQvY2FyZDEvaW5wdXQxMApbICAgIDIuMTcy
NzYyXSBsMnRwX25ldGxpbms6IEwyVFAgbmV0bGluayBpbnRlcmZhY2UKWyAgICAyLjE3Mzg3N10g
aW5wdXQ6IEhEQSBOVmlkaWEgSERNSS9EUCxwY209NyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAw
MDA6MDA6MDEuMS8wMDAwOjAxOjAwLjEvc291bmQvY2FyZDEvaW5wdXQxMQpbICAgIDIuMTc0ODA5
XSBpbnB1dDogSERBIE5WaWRpYSBIRE1JL0RQLHBjbT04IGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAv
MDAwMDowMDowMS4xLzAwMDA6MDE6MDAuMS9zb3VuZC9jYXJkMS9pbnB1dDEyClsgICAgMi4xNzQ4
MTRdIGwydHBfZXRoOiBMMlRQIGV0aGVybmV0IHBzZXVkb3dpcmUgc3VwcG9ydCAoTDJUUHYzKQpb
ICAgIDIuMTc1NzAxXSBpbnB1dDogSERBIE5WaWRpYSBIRE1JL0RQLHBjbT05IGFzIC9kZXZpY2Vz
L3BjaTAwMDA6MDAvMDAwMDowMDowMS4xLzAwMDA6MDE6MDAuMS9zb3VuZC9jYXJkMS9pbnB1dDEz
ClsgICAgMi4xNzY5NDVdIGwydHBfaXA2OiBMMlRQIElQIGVuY2Fwc3VsYXRpb24gc3VwcG9ydCBm
b3IgSVB2NiAoTDJUUHYzKQpbICAgIDIuMTc4ODg0XSA4MDIxcTogODAyLjFRIFZMQU4gU3VwcG9y
dCB2MS44ClsgICAgMi4xODAxMTVdIE5FVDogUmVnaXN0ZXJlZCBQRl9SRFMgcHJvdG9jb2wgZmFt
aWx5ClsgICAgMi4xODAyMDRdIHNuZF9oZGFfY29kZWNfcmVhbHRlayBoZGF1ZGlvQzJEMDogYXV0
b2NvbmZpZyBmb3IgQUxDMjg1OiBsaW5lX291dHM9MSAoMHgxNC8weDAvMHgwLzB4MC8weDApIHR5
cGU6c3BlYWtlcgpbICAgIDIuMTgxMDk0XSBSZWdpc3RlcmVkIFJEUy90Y3AgdHJhbnNwb3J0Clsg
ICAgMi4xODE4NDFdIHNuZF9oZGFfY29kZWNfcmVhbHRlayBoZGF1ZGlvQzJEMDogICAgc3BlYWtl
cl9vdXRzPTAgKDB4MC8weDAvMHgwLzB4MC8weDApClsgICAgMi4xODM0NjNdIHNuZF9oZGFfY29k
ZWNfcmVhbHRlayBoZGF1ZGlvQzJEMDogICAgaHBfb3V0cz0xICgweDIxLzB4MC8weDAvMHgwLzB4
MCkKWyAgICAyLjE4NDI2Nl0gc25kX2hkYV9jb2RlY19yZWFsdGVrIGhkYXVkaW9DMkQwOiAgICBt
b25vOiBtb25vX291dD0weDAKWyAgICAyLjE4NTAyMV0gc25kX2hkYV9jb2RlY19yZWFsdGVrIGhk
YXVkaW9DMkQwOiAgICBpbnB1dHM6ClsgICAgMi4xODU3NTFdIHNuZF9oZGFfY29kZWNfcmVhbHRl
ayBoZGF1ZGlvQzJEMDogICAgICBNaWM9MHgxOQpbICAgIDIuMTg2NDYxXSBzbmRfaGRhX2NvZGVj
X3JlYWx0ZWsgaGRhdWRpb0MyRDA6ICAgICAgSW50ZXJuYWwgTWljPTB4MTIKWyAgICAyLjE4NzU2
OV0gbWljcm9jb2RlOiBDUFUwOiBwYXRjaF9sZXZlbD0weDA4NjAwMTA2ClsgICAgMi4xODkxMDNd
IG1pY3JvY29kZTogQ1BVMTogcGF0Y2hfbGV2ZWw9MHgwODYwMDEwNgpbICAgIDIuMTkwNzk2XSBt
aWNyb2NvZGU6IENQVTI6IHBhdGNoX2xldmVsPTB4MDg2MDAxMDYKWyAgICAyLjE5MjE2OF0gbWlj
cm9jb2RlOiBDUFUzOiBwYXRjaF9sZXZlbD0weDA4NjAwMTA2ClsgICAgMi4xOTM3MjNdIG1pY3Jv
Y29kZTogQ1BVNDogcGF0Y2hfbGV2ZWw9MHgwODYwMDEwNgpbICAgIDIuMTk1MDI3XSBtaWNyb2Nv
ZGU6IENQVTU6IHBhdGNoX2xldmVsPTB4MDg2MDAxMDYKWyAgICAyLjE5NjQwMF0gbWljcm9jb2Rl
OiBDUFU2OiBwYXRjaF9sZXZlbD0weDA4NjAwMTA2ClsgICAgMi4xOTc2NTVdIG1pY3JvY29kZTog
Q1BVNzogcGF0Y2hfbGV2ZWw9MHgwODYwMDEwNgpbICAgIDIuMTk5MDgwXSBtaWNyb2NvZGU6IENQ
VTg6IHBhdGNoX2xldmVsPTB4MDg2MDAxMDYKWyAgICAyLjIwMDMyM10gbWljcm9jb2RlOiBDUFU5
OiBwYXRjaF9sZXZlbD0weDA4NjAwMTA2ClsgICAgMi4yMDE0MjJdIG1pY3JvY29kZTogQ1BVMTA6
IHBhdGNoX2xldmVsPTB4MDg2MDAxMDYKWyAgICAyLjIwMjMzM10gbWljcm9jb2RlOiBDUFUxMTog
cGF0Y2hfbGV2ZWw9MHgwODYwMDEwNgpbICAgIDIuMjAzNTQ3XSBtaWNyb2NvZGU6IE1pY3JvY29k
ZSBVcGRhdGUgRHJpdmVyOiB2Mi4yLgpbICAgIDIuMjAzNTUzXSBJUEkgc2hvcnRoYW5kIGJyb2Fk
Y2FzdDogZW5hYmxlZApbICAgIDIuMjA1NDY3XSBBVlgyIHZlcnNpb24gb2YgZ2NtX2VuYy9kZWMg
ZW5nYWdlZC4KWyAgICAyLjIwNjYxNl0gQUVTIENUUiBtb2RlIGJ5OCBvcHRpbWl6YXRpb24gZW5h
YmxlZApbICAgIDIuMjA3ODkwXSBzY2hlZF9jbG9jazogTWFya2luZyBzdGFibGUgKDIyMDY0NTk4
MjMsIDE0MjExODIpLT4oMjIyMzY3NjcxMiwgLTE1Nzk1NzA3KQpbICAgIDIuMjA5MTgzXSByZWdp
c3RlcmVkIHRhc2tzdGF0cyB2ZXJzaW9uIDEKWyAgICAyLjIxMDA4NF0gTG9hZGluZyBjb21waWxl
ZC1pbiBYLjUwOSBjZXJ0aWZpY2F0ZXMKWyAgICAyLjIxMDk0NF0gS2V5IHR5cGUgLl9mc2NyeXB0
IHJlZ2lzdGVyZWQKWyAgICAyLjIxMTc0NV0gS2V5IHR5cGUgLmZzY3J5cHQgcmVnaXN0ZXJlZApb
ICAgIDIuMjEyNjA2XSBLZXkgdHlwZSBmc2NyeXB0LXByb3Zpc2lvbmluZyByZWdpc3RlcmVkClsg
ICAgMi4yMjAwNTJdIHVzYiAxLTQ6IG5ldyBmdWxsLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDIg
dXNpbmcgeGhjaV9oY2QKWyAgICAyLjI0NTA1NF0gdXNiIDMtMzogbmV3IGhpZ2gtc3BlZWQgVVNC
IGRldmljZSBudW1iZXIgMiB1c2luZyB4aGNpX2hjZApbICAgIDIuMjQ3NTI2XSBhdGExOiBTQVRB
IGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCkKWyAgICAyLjM2ODExNl0gdXNiIDEt
NDogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTBiZGEsIGlkUHJvZHVjdD1iMDBjLCBi
Y2REZXZpY2U9IDAuMDAKWyAgICAyLjM2OTAxN10gdXNiIDEtNDogTmV3IFVTQiBkZXZpY2Ugc3Ry
aW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTMKWyAgICAyLjM2OTgzM10gdXNi
IDEtNDogUHJvZHVjdDogQmx1ZXRvb3RoIFJhZGlvClsgICAgMi4zNzA2MjJdIHVzYiAxLTQ6IE1h
bnVmYWN0dXJlcjogUmVhbHRlawpbICAgIDIuMzcxMTg2XSB1c2IgMS00OiBTZXJpYWxOdW1iZXI6
IDAwZTA0YzAwMDAwMQpbICAgIDIuMzg0MDc4XSBCbHVldG9vdGg6IGhjaTA6IFJUTDogZXhhbWlu
aW5nIGhjaV92ZXI9MGEgaGNpX3Jldj0wMDBjIGxtcF92ZXI9MGEgbG1wX3N1YnZlcj04ODIyClsg
ICAgMi4zODYwMDhdIEJsdWV0b290aDogaGNpMDogUlRMOiByb21fdmVyc2lvbiBzdGF0dXM9MCB2
ZXJzaW9uPTMKWyAgICAyLjM4NjU2OF0gQmx1ZXRvb3RoOiBoY2kwOiBSVEw6IGxvYWRpbmcgcnRs
X2J0L3J0bDg4MjJjdV9mdy5iaW4KWyAgICAyLjM4NzAxOF0gQmx1ZXRvb3RoOiBoY2kwOiBSVEw6
IGxvYWRpbmcgcnRsX2J0L3J0bDg4MjJjdV9jb25maWcuYmluClsgICAgMi4zODc0NTBdIGJsdWV0
b290aCBoY2kwOiBEaXJlY3QgZmlybXdhcmUgbG9hZCBmb3IgcnRsX2J0L3J0bDg4MjJjdV9jb25m
aWcuYmluIGZhaWxlZCB3aXRoIGVycm9yIC0yClsgICAgMi4zODc4NzBdIEJsdWV0b290aDogaGNp
MDogUlRMOiBjZmdfc3ogLTIsIHRvdGFsIHN6IDM1MDgwClsgICAgMi4zOTMzNjldIHVzYiAzLTM6
IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0zMGM5LCBpZFByb2R1Y3Q9MDAxMywgYmNk
RGV2aWNlPSAwLjAxClsgICAgMi4zOTQyMTJdIHVzYiAzLTM6IE5ldyBVU0IgZGV2aWNlIHN0cmlu
Z3M6IE1mcj0zLCBQcm9kdWN0PTEsIFNlcmlhbE51bWJlcj0yClsgICAgMi4zOTQ5NjBdIHVzYiAz
LTM6IFByb2R1Y3Q6IEhQIFRydWVWaXNpb24gSEQgQ2FtZXJhClsgICAgMi4zOTU3MDddIHVzYiAz
LTM6IE1hbnVmYWN0dXJlcjogREpLQ1ZBMTlJRUNDSTAKWyAgICAyLjM5NjE1N10gdXNiIDMtMzog
U2VyaWFsTnVtYmVyOiAwMDAxClsgICAgMi40MDQzMDNdIHVzYiAzLTM6IEZvdW5kIFVWQyAxLjAw
IGRldmljZSBIUCBUcnVlVmlzaW9uIEhEIENhbWVyYSAoMzBjOTowMDEzKQpbICAgIDIuNDEwMDYz
XSBhdGEyOiBTQVRBIGxpbmsgdXAgNi4wIEdicHMgKFNTdGF0dXMgMTMzIFNDb250cm9sIDMwMCkK
WyAgICAyLjQxMjEyMF0gYXRhMi4wMDogQVRBLTk6IFNhbkRpc2sgVWx0cmEgSUkgOTYwR0IsIFg0
MTEwMFJMLCBtYXggVURNQS8xMzMKWyAgICAyLjQxMzAyNV0gYXRhMi4wMDogMTg3NTM4NTAwOCBz
ZWN0b3JzLCBtdWx0aSAxOiBMQkE0OCBOQ1EgKGRlcHRoIDMyKSwgQUEKWyAgICAyLjQxMzU4OF0g
aW5wdXQ6IEhQIFRydWVWaXNpb24gSEQgQ2FtZXJhOiBIUCBUcnUgYXMgL2RldmljZXMvcGNpMDAw
MDowMC8wMDAwOjAwOjA4LjEvMDAwMDowNTowMC40L3VzYjMvMy0zLzMtMzoxLjAvaW5wdXQvaW5w
dXQxNApbICAgIDIuNDE1MTY1XSBhdGEyLjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMwpbICAg
IDIuNDE2MDA1XSBzY3NpIDE6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIFNhbkRp
c2sgVWx0cmEgSUkgMDBSTCBQUTogMCBBTlNJOiA1ClsgICAgMi40MTY5NDVdIHNkIDE6MDowOjA6
IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzAgdHlwZSAwClsgICAgMi40MTcwNjhdIHNkIDE6MDow
OjA6IFtzZGFdIDE4NzUzODUwMDggNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICg5NjAgR0IvODk0
IEdpQikKWyAgICAyLjQxODY1OF0gc2QgMTowOjA6MDogW3NkYV0gV3JpdGUgUHJvdGVjdCBpcyBv
ZmYKWyAgICAyLjQxOTI4NF0gc2QgMTowOjA6MDogW3NkYV0gTW9kZSBTZW5zZTogMDAgM2EgMDAg
MDAKWyAgICAyLjQxOTMwM10gc2QgMTowOjA6MDogW3NkYV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQs
IHJlYWQgY2FjaGU6IGVuYWJsZWQsIGRvZXNuJ3Qgc3VwcG9ydCBEUE8gb3IgRlVBClsgICAgMi40
MjA2MDldICBzZGE6IHNkYTEgc2RhMiBzZGEzClsgICAgMi40MjE3MzNdIHNkIDE6MDowOjA6IFtz
ZGFdIEF0dGFjaGVkIFNDU0kgZGlzawpbICAgIDIuNTY5ODgwXSBhY3BpX2NwdWZyZXE6IG92ZXJy
aWRpbmcgQklPUyBwcm92aWRlZCBfUFNEIGRhdGEKWyAgICAyLjU3MTYxMF0gY2ZnODAyMTE6IExv
YWRpbmcgY29tcGlsZWQtaW4gWC41MDkgY2VydGlmaWNhdGVzIGZvciByZWd1bGF0b3J5IGRhdGFi
YXNlClsgICAgMi41ODYwNTJdIGNsb2Nrc291cmNlOiB0aW1la2VlcGluZyB3YXRjaGRvZyBvbiBD
UFU0OiBNYXJraW5nIGNsb2Nrc291cmNlICd0c2MnIGFzIHVuc3RhYmxlIGJlY2F1c2UgdGhlIHNr
ZXcgaXMgdG9vIGxhcmdlOgpbICAgIDIuNTg2OTE4XSBjbG9ja3NvdXJjZTogICAgICAgICAgICAg
ICAgICAgICAgICdocGV0JyB3ZF9uc2VjOiA1MDc3NjYzNTAgd2Rfbm93OiAyMjgxYzRjIHdkX2xh
c3Q6IDFiOTJjYmEgbWFzazogZmZmZmZmZmYKWyAgICAyLjU4NzcwM10gY2xvY2tzb3VyY2U6ICAg
ICAgICAgICAgICAgICAgICAgICAndHNjJyBjc19uc2VjOiA1MDQwMDI0MTYgY3Nfbm93OiA0ZGIy
ZDIxMmMgY3NfbGFzdDogNDgwOGQwNTcwIG1hc2s6IGZmZmZmZmZmZmZmZmZmZmYKWyAgICAyLjU4
ODE3N10gY2xvY2tzb3VyY2U6ICAgICAgICAgICAgICAgICAgICAgICAndHNjJyBpcyBjdXJyZW50
IGNsb2Nrc291cmNlLgpbICAgIDIuNTg4NjQxXSB0c2M6IE1hcmtpbmcgVFNDIHVuc3RhYmxlIGR1
ZSB0byBjbG9ja3NvdXJjZSB3YXRjaGRvZwpbICAgIDIuNTg5Njg2XSBUU0MgZm91bmQgdW5zdGFi
bGUgYWZ0ZXIgYm9vdCwgbW9zdCBsaWtlbHkgZHVlIHRvIGJyb2tlbiBCSU9TLiBVc2UgJ3RzYz11
bnN0YWJsZScuClsgICAgMi41OTAyNzZdIHNjaGVkX2Nsb2NrOiBNYXJraW5nIHVuc3RhYmxlICgy
NTg4MjY0Mzg2LCAxNDIxMTgyKTwtKDI2MDU0ODEzMzEsIC0xNTc5NTcwNykKWyAgICAyLjU5MDkw
Ml0gY2xvY2tzb3VyY2U6IENoZWNraW5nIGNsb2Nrc291cmNlIHRzYyBzeW5jaHJvbml6YXRpb24g
ZnJvbSBDUFUgNiB0byBDUFVzIDAtMSwzLDcsOS4KWyAgICAyLjU5MjI0OV0gY2xvY2tzb3VyY2U6
IFN3aXRjaGVkIHRvIGNsb2Nrc291cmNlIGhwZXQKWyAgICAyLjYwMzU3NF0gY2ZnODAyMTE6IExv
YWRlZCBYLjUwOSBjZXJ0ICdzZm9yc2hlZTogMDBiMjhkZGY0N2FlZjljZWE3JwpbICAgIDIuNjA0
NjM1XSBVbnN0YWJsZSBjbG9jayBkZXRlY3RlZCwgc3dpdGNoaW5nIGRlZmF1bHQgdHJhY2luZyBj
bG9jayB0byAiZ2xvYmFsIgogICAgICAgICAgICAgICBJZiB5b3Ugd2FudCB0byBrZWVwIHVzaW5n
IHRoZSBsb2NhbCBjbG9jaywgdGhlbiBhZGQ6CiAgICAgICAgICAgICAgICAgInRyYWNlX2Nsb2Nr
PWxvY2FsIgogICAgICAgICAgICAgICBvbiB0aGUga2VybmVsIGNvbW1hbmQgbGluZQpbICAgIDIu
NjA5MDkyXSBBTFNBIGRldmljZSBsaXN0OgpbICAgIDIuNjEwMTg0XSAgICMwOiBMb29wYmFjayAx
ClsgICAgMi42MTExMTFdICAgIzE6IEhEQSBOVmlkaWEgYXQgMHhmYzA4MDAwMCBpcnEgNzQKWyAg
ICAyLjY5NjcyNV0gQmx1ZXRvb3RoOiBoY2kwOiBSVEw6IGZ3IHZlcnNpb24gMHgxOWI3NmQ3ZApb
ICAgIDIuODUwNTM4XSBpbnB1dDogSEQtQXVkaW8gR2VuZXJpYyBNaWMgYXMgL2RldmljZXMvcGNp
MDAwMDowMC8wMDAwOjAwOjA4LjEvMDAwMDowNTowMC42L3NvdW5kL2NhcmQyL2lucHV0MTUKWyAg
ICAyLjg1MjE3M10gaW5wdXQ6IEhELUF1ZGlvIEdlbmVyaWMgSGVhZHBob25lIGFzIC9kZXZpY2Vz
L3BjaTAwMDA6MDAvMDAwMDowMDowOC4xLzAwMDA6MDU6MDAuNi9zb3VuZC9jYXJkMi9pbnB1dDE2
ClsgICAgMi44NTYyNTZdIEVYVDQtZnMgKG52bWUwbjFwNCk6IG1vdW50ZWQgZmlsZXN5c3RlbSB3
aXRoIG9yZGVyZWQgZGF0YSBtb2RlLiBRdW90YSBtb2RlOiBkaXNhYmxlZC4KWyAgICAyLjg1NzM4
M10gVkZTOiBNb3VudGVkIHJvb3QgKGV4dDQgZmlsZXN5c3RlbSkgcmVhZG9ubHkgb24gZGV2aWNl
IDI1OTo0LgpbICAgIDIuODU4ODg3XSBkZXZ0bXBmczogbW91bnRlZApbICAgIDIuODYxMjcwXSBG
cmVlaW5nIHVudXNlZCBkZWNyeXB0ZWQgbWVtb3J5OiAyMDQ0SwpbICAgIDIuODYzNzI2XSBGcmVl
aW5nIHVudXNlZCBrZXJuZWwgaW1hZ2UgKGluaXRtZW0pIG1lbW9yeTogMTIzNksKWyAgICAyLjg2
NTA4MV0gV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAzMDcyMGsK
WyAgICAyLjg2ODUyN10gRnJlZWluZyB1bnVzZWQga2VybmVsIGltYWdlICh0ZXh0L3JvZGF0YSBn
YXApIG1lbW9yeTogMjAyOEsKWyAgICAyLjg2OTY2M10gRnJlZWluZyB1bnVzZWQga2VybmVsIGlt
YWdlIChyb2RhdGEvZGF0YSBnYXApIG1lbW9yeTogMTkySwpbICAgIDIuODcxNzE0XSBSdW4gL3Ni
aW4vaW5pdCBhcyBpbml0IHByb2Nlc3MKWyAgICAyLjg3MzI1OF0gICB3aXRoIGFyZ3VtZW50czoK
WyAgICAyLjg3MzI2MF0gICAgIC9zYmluL2luaXQKWyAgICAyLjg3MzI2MV0gICB3aXRoIGVudmly
b25tZW50OgpbICAgIDIuODczMjYxXSAgICAgSE9NRT0vClsgICAgMi44NzMyNjJdICAgICBURVJN
PWxpbnV4ClsgICAgMy40MTAwNTldIHJhbmRvbTogY3JuZyBpbml0IGRvbmUKWyAgICAzLjQzNTc2
Nl0gdWRldmRbMzI5XTogc3RhcnRpbmcgZXVkZXYtMy4yLjExClsgICAgNC4wNzkzODFdIEFkZGlu
ZyAxMDQ4NTcyayBzd2FwIG9uIC9kZXYvbnZtZTBuMXAzLiAgUHJpb3JpdHk6LTIgZXh0ZW50czox
IGFjcm9zczoxMDQ4NTcyayBTUwpbICAgIDQuNTYzMjcwXSBFWFQ0LWZzIChudm1lMG4xcDQpOiBy
ZS1tb3VudGVkLiBRdW90YSBtb2RlOiBkaXNhYmxlZC4KWyAgICA0LjYxODkwOF0gRkFULWZzIChu
dm1lMG4xcDEpOiBWb2x1bWUgd2FzIG5vdCBwcm9wZXJseSB1bm1vdW50ZWQuIFNvbWUgZGF0YSBt
YXkgYmUgY29ycnVwdC4gUGxlYXNlIHJ1biBmc2NrLgpbICAgIDQuNjM4OTUxXSBFWFQ0LWZzIChz
ZGEzKTogbW91bnRlZCBmaWxlc3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIFF1b3RhIG1v
ZGU6IGRpc2FibGVkLgpbICAgMTMuNzU3MTc4XSB3bGFuMDogYXV0aGVudGljYXRlIHdpdGggMjQ6
NGI6ZmU6YmU6Mjg6MjgKWyAgIDEzLjc1NzE5N10gd2xhbjA6IGJhZCBWSFQgY2FwYWJpbGl0aWVz
LCBkaXNhYmxpbmcgVkhUClsgICAxNC4xNDA5ODVdIHdsYW4wOiBzZW5kIGF1dGggdG8gMjQ6NGI6
ZmU6YmU6Mjg6MjggKHRyeSAxLzMpClsgICAxNC4xNDQzODVdIHdsYW4wOiBhdXRoZW50aWNhdGVk
ClsgICAxNC4xNDYwOTZdIHdsYW4wOiBhc3NvY2lhdGUgd2l0aCAyNDo0YjpmZTpiZToyODoyOCAo
dHJ5IDEvMykKWyAgIDE0LjE1MDkwMF0gd2xhbjA6IFJYIEFzc29jUmVzcCBmcm9tIDI0OjRiOmZl
OmJlOjI4OjI4IChjYXBhYj0weDE0MTEgc3RhdHVzPTAgYWlkPTUpClsgICAxNC4xNTExNzZdIHds
YW4wOiBhc3NvY2lhdGVkClsgICAxNC4xNzA2NzNdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFO
R0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5ClsgICAxNS4xNDk3MTZdIHdsYW4wOiBkZWF1
dGhlbnRpY2F0aW5nIGZyb20gMjQ6NGI6ZmU6YmU6Mjg6MjggYnkgbG9jYWwgY2hvaWNlIChSZWFz
b246IDM9REVBVVRIX0xFQVZJTkcpClsgICAyMi4xNzM2NzBdIHdsYW4wOiBhdXRoZW50aWNhdGUg
d2l0aCAyNDo0YjpmZTpiZToyODoyOApbICAgMjIuMTczNjg2XSB3bGFuMDogYmFkIFZIVCBjYXBh
YmlsaXRpZXMsIGRpc2FibGluZyBWSFQKWyAgIDIyLjQ0MzQ5NV0gd2xhbjA6IHNlbmQgYXV0aCB0
byAyNDo0YjpmZTpiZToyODoyOCAodHJ5IDEvMykKWyAgIDIyLjQ0Njg2N10gd2xhbjA6IGF1dGhl
bnRpY2F0ZWQKWyAgIDIyLjQ0ODA4OV0gd2xhbjA6IGFzc29jaWF0ZSB3aXRoIDI0OjRiOmZlOmJl
OjI4OjI4ICh0cnkgMS8zKQpbICAgMjIuNDUzMzkxXSB3bGFuMDogUlggQXNzb2NSZXNwIGZyb20g
MjQ6NGI6ZmU6YmU6Mjg6MjggKGNhcGFiPTB4MTQxMSBzdGF0dXM9MCBhaWQ9NSkKWyAgIDIyLjQ1
MzY4N10gd2xhbjA6IGFzc29jaWF0ZWQKWyAgIDIyLjQ2MzQxMV0gSVB2NjogQUREUkNPTkYoTkVU
REVWX0NIQU5HRSk6IHdsYW4wOiBsaW5rIGJlY29tZXMgcmVhZHkKWyAgIDMwLjE1OTE2N10gYW1k
Z3B1IDAwMDA6MDU6MDAuMDogdmdhYXJiOiBjaGFuZ2VkIFZHQSBkZWNvZGVzOiBvbGRkZWNvZGVz
PWlvK21lbSxkZWNvZGVzPW5vbmU6b3ducz1ub25lClsgICA0OS44NzUxNjBdIGF0a2JkIHNlcmlv
MDogVW5rbm93biBrZXkgcHJlc3NlZCAodHJhbnNsYXRlZCBzZXQgMiwgY29kZSAweGQ4IG9uIGlz
YTAwNjAvc2VyaW8wKS4KWyAgIDQ5Ljg3NTE3Ml0gYXRrYmQgc2VyaW8wOiBVc2UgJ3NldGtleWNv
ZGVzIGUwNTggPGtleWNvZGU+JyB0byBtYWtlIGl0IGtub3duLgpbICAgNDkuODgzMTgxXSBhdGti
ZCBzZXJpbzA6IFVua25vd24ga2V5IHJlbGVhc2VkICh0cmFuc2xhdGVkIHNldCAyLCBjb2RlIDB4
ZDggb24gaXNhMDA2MC9zZXJpbzApLgpbICAgNDkuODgzMTg5XSBhdGtiZCBzZXJpbzA6IFVzZSAn
c2V0a2V5Y29kZXMgZTA1OCA8a2V5Y29kZT4nIHRvIG1ha2UgaXQga25vd24uClsgICA1MC40NTA2
NzNdIFBNOiBzdXNwZW5kIGVudHJ5IChkZWVwKQpbICAgNTAuNDcwMzE2XSBGaWxlc3lzdGVtcyBz
eW5jOiAwLjAxOSBzZWNvbmRzClsgICA1MC40NzA1NzJdIEZyZWV6aW5nIHVzZXIgc3BhY2UgcHJv
Y2Vzc2VzIC4uLiAoZWxhcHNlZCAwLjAwMiBzZWNvbmRzKSBkb25lLgpbICAgNTAuNDcyODQxXSBP
T00ga2lsbGVyIGRpc2FibGVkLgpbICAgNTAuNDcyODQyXSBGcmVlemluZyByZW1haW5pbmcgZnJl
ZXphYmxlIHRhc2tzIC4uLiAoZWxhcHNlZCAwLjAwMSBzZWNvbmRzKSBkb25lLgpbICAgNTAuNDc0
MDk5XSBwcmludGs6IFN1c3BlbmRpbmcgY29uc29sZShzKSAodXNlIG5vX2NvbnNvbGVfc3VzcGVu
ZCB0byBkZWJ1ZykKWyAgIDUwLjQ4NzA5Nl0gc2QgMTowOjA6MDogW3NkYV0gU3luY2hyb25pemlu
ZyBTQ1NJIGNhY2hlClsgICA1MC40ODg3NjFdIHNkIDE6MDowOjA6IFtzZGFdIFN0b3BwaW5nIGRp
c2sKWyAgIDUwLjUwNzQ4Ml0gd2xhbjA6IGRlYXV0aGVudGljYXRpbmcgZnJvbSAyNDo0YjpmZTpi
ZToyODoyOCBieSBsb2NhbCBjaG9pY2UgKFJlYXNvbjogMz1ERUFVVEhfTEVBVklORykKWyAgIDUw
LjYwOTg0MF0gW2RybV0gZnJlZSBQU1AgVE1SIGJ1ZmZlcgpbICAgNTAuNzY1MDA4XSBQTTogbGF0
ZSBzdXNwZW5kIG9mIGRldmljZXMgZmFpbGVkClsgICA1MC43NjU0NzNdIFtkcm1dIFBDSUUgR0FS
VCBvZiAxMDI0TSBlbmFibGVkLgpbICAgNTAuNzY1NDc5XSBbZHJtXSBQVEIgbG9jYXRlZCBhdCAw
eDAwMDAwMEY0MDA5MDAwMDAKWyAgIDUwLjc2NTQ5MV0gcGNpIDAwMDA6MDA6MDAuMjogY2FuJ3Qg
ZGVyaXZlIHJvdXRpbmcgZm9yIFBDSSBJTlQgQQpbICAgNTAuNzY1NDk3XSBwY2kgMDAwMDowMDow
MC4yOiBQQ0kgSU5UIEE6IG5vIEdTSQpbICAgNTAuNzY1NDk2XSBbZHJtXSBQU1AgaXMgcmVzdW1p
bmcuLi4KWyAgIDUwLjc2NzY0OV0gc2QgMTowOjA6MDogW3NkYV0gU3RhcnRpbmcgZGlzawpbICAg
NTAuNzc3NzU4XSBudm1lIG52bWUwOiAxNi8wLzAgZGVmYXVsdC9yZWFkL3BvbGwgcXVldWVzClsg
ICA1MC43ODU1MzhdIFtkcm1dIHJlc2VydmUgMHg0MDAwMDAgZnJvbSAweGY0MWY4MDAwMDAgZm9y
IFBTUCBUTVIKWyAgIDUxLjA3MTUxNF0gdXNiIDEtNDogcmVzZXQgZnVsbC1zcGVlZCBVU0IgZGV2
aWNlIG51bWJlciAyIHVzaW5nIHhoY2lfaGNkClsgICA1MS4wNzQ0MzZdIGF0YTE6IFNBVEEgbGlu
ayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAwKQpbICAgNTEuMDc4OTQ2XSBhbWRncHUgMDAw
MDowNTowMC4wOiBhbWRncHU6IFJBUzogb3B0aW9uYWwgcmFzIHRhIHVjb2RlIGlzIG5vdCBhdmFp
bGFibGUKWyAgIDUxLjA4OTYxOV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiBSQVA6IG9w
dGlvbmFsIHJhcCB0YSB1Y29kZSBpcyBub3QgYXZhaWxhYmxlClsgICA1MS4wODk2MjFdIGFtZGdw
dSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogU0VDVVJFRElTUExBWTogc2VjdXJlZGlzcGxheSB0YSB1
Y29kZSBpcyBub3QgYXZhaWxhYmxlClsgICA1MS4wODk2MjVdIGFtZGdwdSAwMDAwOjA1OjAwLjA6
IGFtZGdwdTogU01VIGlzIHJlc3VtaW5nLi4uClsgICA1MS4wOTAyMzRdIGFtZGdwdSAwMDAwOjA1
OjAwLjA6IGFtZGdwdTogZHBtIGhhcyBiZWVuIGRpc2FibGVkClsgICA1MS4wOTExNDhdIGFtZGdw
dSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogU01VIGlzIHJlc3VtZWQgc3VjY2Vzc2Z1bGx5IQpbICAg
NTEuMDkxOTI2XSBbZHJtXSBETVVCIGhhcmR3YXJlIGluaXRpYWxpemVkOiB2ZXJzaW9uPTB4MDEw
MTAwMUYKWyAgIDUxLjIyNjA3NV0gYXRhMjogU0FUQSBsaW5rIHVwIDYuMCBHYnBzIChTU3RhdHVz
IDEzMyBTQ29udHJvbCAzMDApClsgICA1MS4yMjg2MTVdIGF0YTIuMDA6IGNvbmZpZ3VyZWQgZm9y
IFVETUEvMTMzClsgICA1MS41NTMyOTFdIFtkcm1dIGtpcSByaW5nIG1lYyAyIHBpcGUgMSBxIDAK
WyAgIDUxLjgxMDU4NF0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogW2RybTphbWRncHVfcmluZ190ZXN0
X2hlbHBlcl0gKkVSUk9SKiByaW5nIGdmeCB0ZXN0IGZhaWxlZCAoLTExMCkKWyAgIDUxLjgxMDU5
NV0gW2RybTphbWRncHVfZGV2aWNlX2lwX3Jlc3VtZV9waGFzZTJdICpFUlJPUiogcmVzdW1lIG9m
IElQIGJsb2NrIDxnZnhfdjlfMD4gZmFpbGVkIC0xMTAKWyAgIDUxLjgxMDYwMV0gYW1kZ3B1IDAw
MDA6MDU6MDAuMDogYW1kZ3B1OiBhbWRncHVfZGV2aWNlX2lwX3Jlc3VtZSBmYWlsZWQgKC0xMTAp
LgpbICAgNTEuODEwNjAzXSBhbWRncHUgMDAwMDowNTowMC4wOiBQTTogZHBtX3J1bl9jYWxsYmFj
aygpOiBwY2lfcG1fcmVzdW1lKzB4MC8weDEyMCByZXR1cm5zIC0xMTAKWyAgIDUxLjgxMDYxM10g
YW1kZ3B1IDAwMDA6MDU6MDAuMDogUE06IGZhaWxlZCB0byByZXN1bWUgYXN5bmM6IGVycm9yIC0x
MTAKWyAgIDUxLjgxMjEwMV0gT09NIGtpbGxlciBlbmFibGVkLgpbICAgNTEuODEyMTAzXSBSZXN0
YXJ0aW5nIHRhc2tzIC4uLiAKWyAgIDUxLjgxMzM5N10gQmx1ZXRvb3RoOiBoY2kwOiBSVEw6IGV4
YW1pbmluZyBoY2lfdmVyPTBhIGhjaV9yZXY9MDAwYyBsbXBfdmVyPTBhIGxtcF9zdWJ2ZXI9ODgy
MgpbICAgNTEuODEzNDYxXSBkb25lLgpbICAgNTEuODE1NDAxXSBCbHVldG9vdGg6IGhjaTA6IFJU
TDogcm9tX3ZlcnNpb24gc3RhdHVzPTAgdmVyc2lvbj0zClsgICA1MS44MTU0MTBdIEJsdWV0b290
aDogaGNpMDogUlRMOiBsb2FkaW5nIHJ0bF9idC9ydGw4ODIyY3VfZncuYmluClsgICA1MS44MTU0
MzRdIEJsdWV0b290aDogaGNpMDogUlRMOiBsb2FkaW5nIHJ0bF9idC9ydGw4ODIyY3VfY29uZmln
LmJpbgpbICAgNTEuODE2NzUxXSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IGNvdWxkbid0
IHNjaGVkdWxlIGliIG9uIHJpbmcgPGdmeD4KWyAgIDUxLjgxNjc1OV0gW2RybTphbWRncHVfam9i
X3J1bl0gKkVSUk9SKiBFcnJvciBzY2hlZHVsaW5nIElCcyAoLTIyKQpbICAgNTEuODE3Mjg0XSBh
bWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IGNvdWxkbid0IHNjaGVkdWxlIGliIG9uIHJpbmcg
PGdmeD4KWyAgIDUxLjgxNzI4N10gW2RybTphbWRncHVfam9iX3J1bl0gKkVSUk9SKiBFcnJvciBz
Y2hlZHVsaW5nIElCcyAoLTIyKQpbICAgNTEuODIxNzc1XSBCbHVldG9vdGg6IGhjaTA6IFJUTDog
Y2ZnX3N6IDYsIHRvdGFsIHN6IDM1MDg2ClsgICA1MS45NDExODhdIFBNOiBzdXNwZW5kIGV4aXQK
WyAgIDUxLjk0MTI4N10gUE06IHN1c3BlbmQgZW50cnkgKHMyaWRsZSkKWyAgIDUxLjk0NDM5OF0g
RmlsZXN5c3RlbXMgc3luYzogMC4wMDMgc2Vjb25kcwpbICAgNTEuOTQ0NTg1XSBGcmVlemluZyB1
c2VyIHNwYWNlIHByb2Nlc3NlcyAuLi4gKGVsYXBzZWQgMC4xNzUgc2Vjb25kcykgZG9uZS4KWyAg
IDUyLjEyMDU4Ml0gT09NIGtpbGxlciBkaXNhYmxlZC4KWyAgIDUyLjEyMDU4NF0gRnJlZXppbmcg
cmVtYWluaW5nIGZyZWV6YWJsZSB0YXNrcyAuLi4gClsgICA1Mi4xMjk2MjNdIEJsdWV0b290aDog
aGNpMDogUlRMOiBmdyB2ZXJzaW9uIDB4MTliNzZkN2QKWyAgIDUyLjQ3NDIwMF0gKGVsYXBzZWQg
MC4zNTMgc2Vjb25kcykgZG9uZS4KWyAgIDUyLjQ3NDIxMl0gcHJpbnRrOiBTdXNwZW5kaW5nIGNv
bnNvbGUocykgKHVzZSBub19jb25zb2xlX3N1c3BlbmQgdG8gZGVidWcpClsgICA1Mi40NzQyNzld
IGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogUG93ZXIgY29uc3VtcHRpb24gd2lsbCBiZSBo
aWdoZXIgYXMgQklPUyBoYXMgbm90IGJlZW4gY29uZmlndXJlZCBmb3Igc3VzcGVuZC10by1pZGxl
LgogICAgICAgICAgICAgICBUbyB1c2Ugc3VzcGVuZC10by1pZGxlIGNoYW5nZSB0aGUgc2xlZXAg
bW9kZSBpbiBCSU9TIHNldHVwLgpbICAgNTIuNDgwMTAzXSBzZCAxOjA6MDowOiBbc2RhXSBTeW5j
aHJvbml6aW5nIFNDU0kgY2FjaGUKWyAgIDUyLjQ4NzY3MF0gc2QgMTowOjA6MDogW3NkYV0gU3Rv
cHBpbmcgZGlzawpbICAgNTIuNjExNjE3XSBbZHJtXSBmcmVlIFBTUCBUTVIgYnVmZmVyClsgICA1
Mi42NDM4MDldIEFDUEk6IEVDOiBpbnRlcnJ1cHQgYmxvY2tlZApbICAgNTIuNjY3NDgzXSBBQ1BJ
OiBFQzogaW50ZXJydXB0IHVuYmxvY2tlZApbICAgNTIuNjkyNDg1XSBwY2kgMDAwMDowMDowMC4y
OiBjYW4ndCBkZXJpdmUgcm91dGluZyBmb3IgUENJIElOVCBBClsgICA1Mi42OTI0OTJdIHBjaSAw
MDAwOjAwOjAwLjI6IFBDSSBJTlQgQTogbm8gR1NJClsgICA1Mi42OTI1MDldIFtkcm1dIFBDSUUg
R0FSVCBvZiAxMDI0TSBlbmFibGVkLgpbICAgNTIuNjkyNTk1XSBbZHJtXSBQVEIgbG9jYXRlZCBh
dCAweDAwMDAwMEY0MDA5MDAwMDAKWyAgIDUyLjY5MjYxMl0gW2RybV0gUFNQIGlzIHJlc3VtaW5n
Li4uClsgICA1Mi42OTMwOTNdIHNkIDE6MDowOjA6IFtzZGFdIFN0YXJ0aW5nIGRpc2sKWyAgIDUy
LjcwOTE2N10gbnZtZSBudm1lMDogMTYvMC8wIGRlZmF1bHQvcmVhZC9wb2xsIHF1ZXVlcwpbICAg
NTIuNzEyNjUyXSBbZHJtXSByZXNlcnZlIDB4NDAwMDAwIGZyb20gMHhmNDFmODAwMDAwIGZvciBQ
U1AgVE1SClsgICA1Mi45OTg3MTJdIHVzYiAxLTQ6IHJlc2V0IGZ1bGwtc3BlZWQgVVNCIGRldmlj
ZSBudW1iZXIgMiB1c2luZyB4aGNpX2hjZApbICAgNTMuMDAwMzkxXSBhdGExOiBTQVRBIGxpbmsg
ZG93biAoU1N0YXR1cyAwIFNDb250cm9sIDMwMCkKWyAgIDUzLjAwNTUwN10gYW1kZ3B1IDAwMDA6
MDU6MDAuMDogYW1kZ3B1OiBSQVM6IG9wdGlvbmFsIHJhcyB0YSB1Y29kZSBpcyBub3QgYXZhaWxh
YmxlClsgICA1My4wMTYyODNdIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogUkFQOiBvcHRp
b25hbCByYXAgdGEgdWNvZGUgaXMgbm90IGF2YWlsYWJsZQpbICAgNTMuMDE2Mjg1XSBhbWRncHUg
MDAwMDowNTowMC4wOiBhbWRncHU6IFNFQ1VSRURJU1BMQVk6IHNlY3VyZWRpc3BsYXkgdGEgdWNv
ZGUgaXMgbm90IGF2YWlsYWJsZQpbICAgNTMuMDE2Mjg5XSBhbWRncHUgMDAwMDowNTowMC4wOiBh
bWRncHU6IFNNVSBpcyByZXN1bWluZy4uLgpbICAgNTMuMDE2NDI0XSBhbWRncHUgMDAwMDowNTow
MC4wOiBhbWRncHU6IGRwbSBoYXMgYmVlbiBkaXNhYmxlZApbICAgNTMuMDE3NDU5XSBhbWRncHUg
MDAwMDowNTowMC4wOiBhbWRncHU6IFNNVSBpcyByZXN1bWVkIHN1Y2Nlc3NmdWxseSEKWyAgIDUz
LjAxODI2MV0gW2RybV0gRE1VQiBoYXJkd2FyZSBpbml0aWFsaXplZDogdmVyc2lvbj0weDAxMDEw
MDFGClsgICA1My4xNTQxMDJdIGF0YTI6IFNBVEEgbGluayB1cCA2LjAgR2JwcyAoU1N0YXR1cyAx
MzMgU0NvbnRyb2wgMzAwKQpbICAgNTMuMTU2NzE0XSBhdGEyLjAwOiBjb25maWd1cmVkIGZvciBV
RE1BLzEzMwpbICAgNTMuNTQ0ODY2XSBbZHJtXSBraXEgcmluZyBtZWMgMiBwaXBlIDEgcSAwClsg
ICA1My41NTgzMTJdIFtkcm1dIFZDTiBkZWNvZGUgYW5kIGVuY29kZSBpbml0aWFsaXplZCBzdWNj
ZXNzZnVsbHkodW5kZXIgRFBHIE1vZGUpLgpbICAgNTMuNTU4MzkyXSBbZHJtXSBKUEVHIGRlY29k
ZSBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHkuClsgICA1My41NTgzOThdIGFtZGdwdSAwMDAwOjA1
OjAwLjA6IGFtZGdwdTogcmluZyBnZnggdXNlcyBWTSBpbnYgZW5nIDAgb24gaHViIDAKWyAgIDUz
LjU1ODQwM10gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4wLjAgdXNl
cyBWTSBpbnYgZW5nIDEgb24gaHViIDAKWyAgIDUzLjU1ODQwNV0gYW1kZ3B1IDAwMDA6MDU6MDAu
MDogYW1kZ3B1OiByaW5nIGNvbXBfMS4xLjAgdXNlcyBWTSBpbnYgZW5nIDQgb24gaHViIDAKWyAg
IDUzLjU1ODQwN10gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4yLjAg
dXNlcyBWTSBpbnYgZW5nIDUgb24gaHViIDAKWyAgIDUzLjU1ODQwOV0gYW1kZ3B1IDAwMDA6MDU6
MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4zLjAgdXNlcyBWTSBpbnYgZW5nIDYgb24gaHViIDAK
WyAgIDUzLjU1ODQxMV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4w
LjEgdXNlcyBWTSBpbnYgZW5nIDcgb24gaHViIDAKWyAgIDUzLjU1ODQxM10gYW1kZ3B1IDAwMDA6
MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4xLjEgdXNlcyBWTSBpbnYgZW5nIDggb24gaHVi
IDAKWyAgIDUzLjU1ODQxNV0gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBf
MS4yLjEgdXNlcyBWTSBpbnYgZW5nIDkgb24gaHViIDAKWyAgIDUzLjU1ODQxN10gYW1kZ3B1IDAw
MDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIGNvbXBfMS4zLjEgdXNlcyBWTSBpbnYgZW5nIDEwIG9u
IGh1YiAwClsgICA1My41NTg0MTldIGFtZGdwdSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBr
aXFfMi4xLjAgdXNlcyBWTSBpbnYgZW5nIDExIG9uIGh1YiAwClsgICA1My41NTg0MjFdIGFtZGdw
dSAwMDAwOjA1OjAwLjA6IGFtZGdwdTogcmluZyBzZG1hMCB1c2VzIFZNIGludiBlbmcgMCBvbiBo
dWIgMQpbICAgNTMuNTU4NDIzXSBhbWRncHUgMDAwMDowNTowMC4wOiBhbWRncHU6IHJpbmcgdmNu
X2RlYyB1c2VzIFZNIGludiBlbmcgMSBvbiBodWIgMQpbICAgNTMuNTU4NDI1XSBhbWRncHUgMDAw
MDowNTowMC4wOiBhbWRncHU6IHJpbmcgdmNuX2VuYzAgdXNlcyBWTSBpbnYgZW5nIDQgb24gaHVi
IDEKWyAgIDUzLjU1ODQyN10gYW1kZ3B1IDAwMDA6MDU6MDAuMDogYW1kZ3B1OiByaW5nIHZjbl9l
bmMxIHVzZXMgVk0gaW52IGVuZyA1IG9uIGh1YiAxClsgICA1My41NTg0MjldIGFtZGdwdSAwMDAw
OjA1OjAwLjA6IGFtZGdwdTogcmluZyBqcGVnX2RlYyB1c2VzIFZNIGludiBlbmcgNiBvbiBodWIg
MQpbICAgNTQuNTcwNTcwXSBhbWRncHUgMDAwMDowNTowMC4wOiBbZHJtOmFtZGdwdV9pYl9yaW5n
X3Rlc3RzXSAqRVJST1IqIElCIHRlc3QgZmFpbGVkIG9uIGdmeCAoLTExMCkuClsgICA1NC41NzA1
ODhdIFtkcm06cHJvY2Vzc19vbmVfd29ya10gKkVSUk9SKiBpYiByaW5nIHRlc3QgZmFpbGVkICgt
MTEwKS4KWyAgIDU0LjU3MTk4OV0gT09NIGtpbGxlciBlbmFibGVkLgpbICAgNTQuNTcxOTkzXSBS
ZXN0YXJ0aW5nIHRhc2tzIC4uLiBkb25lLgpbICAgNTQuNTczNjI3XSBCbHVldG9vdGg6IGhjaTA6
IFJUTDogZXhhbWluaW5nIGhjaV92ZXI9MGEgaGNpX3Jldj0wMDBjIGxtcF92ZXI9MGEgbG1wX3N1
YnZlcj04ODIyClsgICA1NC41NzU2MTVdIEJsdWV0b290aDogaGNpMDogUlRMOiByb21fdmVyc2lv
biBzdGF0dXM9MCB2ZXJzaW9uPTMKWyAgIDU0LjU3NTYyNF0gQmx1ZXRvb3RoOiBoY2kwOiBSVEw6
IGxvYWRpbmcgcnRsX2J0L3J0bDg4MjJjdV9mdy5iaW4KWyAgIDU0LjU3NTY1NV0gQmx1ZXRvb3Ro
OiBoY2kwOiBSVEw6IGxvYWRpbmcgcnRsX2J0L3J0bDg4MjJjdV9jb25maWcuYmluClsgICA1NC41
NzU2OTJdIEJsdWV0b290aDogaGNpMDogUlRMOiBjZmdfc3ogNiwgdG90YWwgc3ogMzUwODYKWyAg
IDU0LjcwMjU0N10gUE06IHN1c3BlbmQgZXhpdApbICAgNTQuODgzNzIxXSBCbHVldG9vdGg6IGhj
aTA6IFJUTDogZncgdmVyc2lvbiAweDE5Yjc2ZDdkClsgICA1NS43MjIwOTRdIFtkcm1dIEZlbmNl
IGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNTYuMjI2MDkzXSBbZHJt
XSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDU2LjczMDA5
Ml0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA1
Ny4yMzQwNjJdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1h
MApbICAgNTcuNzM4MDc4XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJp
bmcgc2RtYTAKWyAgIDU4LjI0MjA4NV0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJl
ZCBvbiByaW5nIHNkbWEwClsgICA1OC43NDYwODVdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVy
IGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNTkuMjUwMDc2XSBbZHJtXSBGZW5jZSBmYWxsYmFj
ayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDU5Ljc1NDA3NF0gW2RybV0gRmVuY2Ug
ZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA2MC4yNTgwNzddIFtkcm1d
IEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNjAuNzYyMDc1
XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDYx
LjI2NjIxNl0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEw
ClsgICA2MS43NzAwNzRdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmlu
ZyBzZG1hMApbICAgNjIuMjc0MDc2XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVk
IG9uIHJpbmcgc2RtYTAKWyAgIDYyLjc3ODA3NV0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIg
ZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA2My4yODIwNzNdIFtkcm1dIEZlbmNlIGZhbGxiYWNr
IHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNjUuODgyMDcwXSBbZHJtXSBGZW5jZSBm
YWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDY2LjM4NjA2Nl0gW2RybV0g
RmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA2Ni44OTAwNzBd
IFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNjcu
Mzk0MDY5XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAK
WyAgIDY3Ljg5ODA3N10gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5n
IHNkbWEwClsgICA2OC40MDIwNzFdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQg
b24gcmluZyBzZG1hMApbICAgNjguOTA2MDY2XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBl
eHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDY5LjQxMDA3MV0gW2RybV0gRmVuY2UgZmFsbGJhY2sg
dGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA2OS45MTQwNjVdIFtkcm1dIEZlbmNlIGZh
bGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgNzUuOTIyMDcxXSBbZHJtXSBG
ZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDc2LjQyNjA4N10g
W2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA3Ni45
MzAwNzBdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApb
ICAgNzcuNDM0MDg3XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcg
c2RtYTAKWyAgIDc3LjkzODA2OV0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBv
biByaW5nIHNkbWEwClsgICA3OC40NDIwODRdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4
cGlyZWQgb24gcmluZyBzZG1hMApbICAgNzguOTQ2MDY2XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0
aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDc5LjQ1MDA2N10gW2RybV0gRmVuY2UgZmFs
bGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA3OS45NTQwNjZdIFtkcm1dIEZl
bmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgODAuNDU4MDg2XSBb
ZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDgwLjk2
MjA4NV0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsg
ICA4MS40NjYwODZdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBz
ZG1hMApbICAgODEuOTcwMDYyXSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9u
IHJpbmcgc2RtYTAKWyAgIDg1Ljk0NjA4Ml0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhw
aXJlZCBvbiByaW5nIHNkbWEwClsgICA4Ni40NTAxNzhdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRp
bWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgODYuOTU0MDc4XSBbZHJtXSBGZW5jZSBmYWxs
YmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDg3LjQ1ODA4N10gW2RybV0gRmVu
Y2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA4Ny45NjIwNzldIFtk
cm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgODguNDY2
MDg2XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAg
IDg4Ljk3MDA4MF0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNk
bWEwClsgICA4OS40NzQwODVdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24g
cmluZyBzZG1hMApbICAgODkuOTc4MDgxXSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBp
cmVkIG9uIHJpbmcgc2RtYTAKWyAgIDkwLjQ4MjA4NV0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGlt
ZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgICA5MC45ODYwODNdIFtkcm1dIEZlbmNlIGZhbGxi
YWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgOTEuNDkwMDg1XSBbZHJtXSBGZW5j
ZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDkzLjI2OTMxMF0gd2xh
bjA6IGF1dGhlbnRpY2F0ZSB3aXRoIDI0OjRiOmZlOmJlOjI4OjI4ClsgICA5My4yNjkzMjJdIHds
YW4wOiBiYWQgVkhUIGNhcGFiaWxpdGllcywgZGlzYWJsaW5nIFZIVApbICAgOTMuNTQ2MTgyXSB3
bGFuMDogc2VuZCBhdXRoIHRvIDI0OjRiOmZlOmJlOjI4OjI4ICh0cnkgMS8zKQpbICAgOTMuNTQ5
NTM4XSB3bGFuMDogYXV0aGVudGljYXRlZApbICAgOTMuNTUwMDc0XSB3bGFuMDogYXNzb2NpYXRl
IHdpdGggMjQ6NGI6ZmU6YmU6Mjg6MjggKHRyeSAxLzMpClsgICA5My41NTYwOTZdIHdsYW4wOiBS
WCBBc3NvY1Jlc3AgZnJvbSAyNDo0YjpmZTpiZToyODoyOCAoY2FwYWI9MHgxNDExIHN0YXR1cz0w
IGFpZD01KQpbICAgOTMuNTU2MzA2XSB3bGFuMDogYXNzb2NpYXRlZApbICAgOTUuOTg2MDg3XSBb
ZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDk2LjQ5
MDA4NF0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsg
ICA5Ni45OTQwODldIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBz
ZG1hMApbICAgOTcuNDk4MjM1XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9u
IHJpbmcgc2RtYTAKWyAgIDk4LjAwMjIyM10gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhw
aXJlZCBvbiByaW5nIHNkbWEwClsgICA5OC41MDYwNjhdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRp
bWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAgOTkuMDEwMDcxXSBbZHJtXSBGZW5jZSBmYWxs
YmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgIDk5LjUxNDA5MV0gW2RybV0gRmVu
Y2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgIDEwMC4wMTgyNjRdIFtk
cm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAxMDAuNTIy
MjQ3XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAg
MTAxLjAyNjA2OF0gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNk
bWEwClsgIDEwMS41MzAyNDVdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24g
cmluZyBzZG1hMApbICAxMDIuMDM0MjQ5XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBp
cmVkIG9uIHJpbmcgc2RtYTAKWyAgMTAyLjUzODI0M10gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGlt
ZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgIDEwMy4wNDIyNDNdIFtkcm1dIEZlbmNlIGZhbGxi
YWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAxMDMuNTQ2MjQ2XSBbZHJtXSBGZW5j
ZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgMTA0LjA1MDI0OV0gW2Ry
bV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgIDEwNC41NTQw
OTldIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAx
MDUuMDU4MjQ5XSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2Rt
YTAKWyAgMTA1LjU2MjA4N10gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiBy
aW5nIHNkbWEwClsgIDEwNi4wNjYyNDRdIFtkcm1dIEZlbmNlIGZhbGxiYWNrIHRpbWVyIGV4cGly
ZWQgb24gcmluZyBzZG1hMApbICAxMDYuNTcwMjQyXSBbZHJtXSBGZW5jZSBmYWxsYmFjayB0aW1l
ciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgMTA3LjA3NDA5MF0gW2RybV0gRmVuY2UgZmFsbGJh
Y2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwClsgIDEwNy41NzgwODVdIFtkcm1dIEZlbmNl
IGZhbGxiYWNrIHRpbWVyIGV4cGlyZWQgb24gcmluZyBzZG1hMApbICAxMDguMDgyMjQ3XSBbZHJt
XSBGZW5jZSBmYWxsYmFjayB0aW1lciBleHBpcmVkIG9uIHJpbmcgc2RtYTAKWyAgMTA4LjU4NjI0
M10gW2RybV0gRmVuY2UgZmFsbGJhY2sgdGltZXIgZXhwaXJlZCBvbiByaW5nIHNkbWEwCg==
------=_Part_551034912_185541098.1652871731030--
