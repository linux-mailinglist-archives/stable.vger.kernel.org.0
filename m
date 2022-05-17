Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1B5299A0
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 08:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiEQGgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 02:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiEQGgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 02:36:42 -0400
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C1CBE2C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 23:36:39 -0700 (PDT)
Received: from [10.162.171.246] (unknown [193.56.242.123])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp1-g21.free.fr (Postfix) with ESMTPSA id 14958B005AF;
        Tue, 17 May 2022 08:36:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652769397;
        bh=qQZN0pcMZ8iJwBK8TgjO2Eqasf9tqgr2xNfqd0FSbmM=;
        h=In-Reply-To:References:Subject:From:Date:To:CC:From;
        b=jV+6QEb6R5B0aaGaXOiXpjk7cjGKt5CjCxE9raqelCdPgcs3qSfRw1A3Vu/YFjRL5
         ycW1V+KTYX6uWktC98dvFhvx9oS38RQ1NpYuNp1IOUxEUAG8ENV3ZssiNIFmRn8F52
         d0bdKtUqP2ATlcxE6wOd/291ATMy6gCHoGQSUZtGpQ8784P43NfKka/jntBuRXk2DS
         FLZjPAxik53g2NIq57aif8Gw/8EOg4KT4PsCbFTlnJaCmDkT12I8Zq2cjfMGu4bkAZ
         1CepQP0vyOm+DUhZ4/N8dthFWs6IWaLEl7uVkhsg14YnsBSRNKlXRreR6Wwxdx2qzX
         SEjRDfdW6wQHA==
In-Reply-To: <CAAd53p7xpE6S-73Pk04SeUa738teEHu+gCacxXkvTCk7eOiS9w@mail.gmail.com>
References: <2584945.lGaqSPkdTl@geek500.localdomain> <25425832.1r3eYUQgxm@geek500.localdomain> <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com> <2592420.vuYhMxLoTh@geek500.localdomain> <CAAd53p7xpE6S-73Pk04SeUa738teEHu+gCacxXkvTCk7eOiS9w@mail.gmail.com>
X-Referenced-Uid: 151078
Thread-Topic: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
User-Agent: Android
X-Is-Generated-Message-Id: true
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
From:   Christian Casteyde <casteyde.christian@free.fr>
Date:   Tue, 17 May 2022 08:36:29 +0200
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Message-ID: <5ef8260a-ca6d-4edc-9ce6-9497dca575a3@free.fr>
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

No, the problem is there even without acpicall=2E Fyi I use it to shutdown =
the NVidia card that eats the battery otherwise=2E

I managed to get a dmes=
g output with 2=2E18rc7 I will post it this evening (basically exact same b=
ehavior as 2=2E17=2E4)=2E

CC

=E2=81=A3T=C3=A9l=C3=A9charger BlueMail pour=
 Android =E2=80=8B

Le 17 mai 2022 =C3=A0 04:03, =C3=A0 04:03, Kai-Heng Fen=
g <kai=2Eheng=2Efeng@canonical=2Ecom> a =C3=A9crit:
>On Tue, May 17, 2022 a=
t 1:23 AM Christian Casteyde
><casteyde=2Echristian@free=2Efr> wrote:
>>
>>=
 I've tried with 5=2E18-rc7, it doesn't work either=2E I guess 5=2E18 branc=
h
>have all
>> commits=2E
>>
>> full dmesg appended (not for 5=2E18, I didn=
't manage to resume up to
>the point
>> to get a console for now)=2E
>
>Int=
erestingly, I found you are using acpi_call:
>[   30=2E667348] acpi_call: l=
oading out-of-tree module taints kernel=2E
>
>Does removing the acpi_call s=
olve the issue?
>
>Kai-Heng
>
>>
>> CC
>>
>> Le lundi 16 mai 2022, 04:47:25=
 CEST Kai-Heng Feng a =C3=A9crit :
>> > [+Cc Mario]
>> >
>> > On Sun, May 1=
5, 2022 at 1:34 AM Christian Casteyde
>> >
>> > <casteyde=2Echristian@free=
=2Efr> wrote:
>> > > I've applied the commit a56f445f807b0276 on 5=2E17=2E7=
 and tested=2E
>> > > This does not fix the problem on my laptop=2E
>> >
>>=
 > Maybe some commits are still missing?
>> >
>> > > For informatio, here i=
s a part of the log around the suspend
>process:
>> > Is it possible to att=
ach full dmesg?
>> >
>> > Kai-Heng
>> >
>> > > May 14 19:21:41 geek500 kern=
el: snd_hda_intel 0000:01:00=2E1: can't
>change
>> > > power state from D3c=
old to D0 (config space inaccessible)
>> > > May 14 19:21:41 geek500 kernel=
: PM: late suspend of devices
>failed
>> > > May 14 19:21:41 geek500 kernel=
: ------------[ cut here
>]------------
>> > > May 14 19:21:41 geek500 kern=
el: i2c_designware AMDI0010:03:
>Transfer while
>> > > suspended
>> > > May=
 14 19:21:41 geek500 kernel: pci 0000:00:00=2E2: can't derive
>routing for
=
>> > > PCI INT A
>> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00=2E2:=
 PCI INT A: no
>GSI
>> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 =
PID: 1972 at
>drivers/i2c/
>> > > busses/i2c-designware-master=2Ec:570 i2c_=
dw_xfer+0x3f6/0x440
>> > > May 14 19:21:41 geek500 kernel: Modules linked i=
n: [last
>unloaded:
>> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: =
9 PID: 1972 Comm:
>> > > kworker/u32:18 Tainted: G           O      5=2E17=
=2E7+ #7
>> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavili=
on
>Gaming
>> > > Laptop
>> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> >=
 > May 14 19:21:41 geek500 kernel: Workqueue: events_unbound
>> > > async_r=
un_entry_fn May 14 19:21:41 geek500 kernel: RIP:
>> > > 0010:i2c_dw_xfer+0x=
3f6/0x440
>> > > May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01=
 4c 8b
>67 50 4d
>> > > 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 =
c7 00 01 cc
>> > >
>> > >  ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff f=
f ff e9 cc fc ff
>ff e9 2d
>> > >  9c>
>> > > 4b 00 83 f8 01 74
>> > > May =
14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68
>EFLAGS:
>> > > 0001=
0286
>> > > May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
>> >=
 > ffff888540f170e8
>> > > RCX: 0000000000000be5
>> > > May 14 19:21:41 gee=
k500 kernel: RDX: 0000000000000000 RSI:
>> > > 0000000000000086
>> > > RDI:=
 ffffffffac858df8
>> > > May 14 19:21:41 geek500 kernel: RBP: ffff888540f17=
0e8 R08:
>> > > ffffffffabe46d60
>> > > R09: 00000000ac86a0f6
>> > > May 14=
 19:21:41 geek500 kernel: R10: ffffffffffffffff R11:
>> > > fffffffffffffff=
f
>> > > R12: ffff888540f5c070
>> > > May 14 19:21:41 geek500 kernel: R13: =
ffff8dbfc31e7d70 R14:
>> > > 00000000ffffff94
>> > > R15: ffff888540f17028
=
>> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> > > G=
S:ffff88885f640000(0000) knlGS:0000000000000000
>> > > May 14 19:21:41 geek=
500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> > > 0000000080050033
>> > >=
 May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
>> > > 00000000=
45e0c000
>> > > CR4: 0000000000350ee0
>> > > May 14 19:21:41 geek500 kernel=
: Call Trace:
>> > > May 14 19:21:41 geek500 kernel:  <TASK>
>> > > May 14 =
19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
>> > > May 14 19:21:4=
1 geek500 kernel:  ?
>newidle_balance=2Econstprop=2E0+0x1f7/0x3b0
>> > > Ma=
y 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
>> > > May 14 19:=
21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
>> > > May 14 19:21:41 geek50=
0 kernel:  __i2c_hid_command+0x106/0x2d0
>> > > May 14 19:21:41 geek500 ker=
nel:  ? amd_gpio_irq_enable+0x19/0x50
>> > > May 14 19:21:41 geek500 kernel=
:  i2c_hid_set_power+0x4a/0xd0
>> > > May 14 19:21:41 geek500 kernel:  i2c_=
hid_core_resume+0x60/0xb0
>> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_s=
ubsys_resume_early+0x50/0x50
>> > > May 14 19:21:41 geek500 kernel:  dpm_ru=
n_callback+0x1d/0xd0
>> > > May 14 19:21:41 geek500 kernel:  device_resume+=
0x122/0x230
>> > > May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
=
>> > > May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
>> > >=
 May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> > > May 1=
4 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> > > May 14 19:21:41=
 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> > > May 14 19:21:41 geek5=
00 kernel:  kthread+0xd3/0x100
>> > > May 14 19:21:41 geek500 kernel:  ?
>k=
thread_complete_and_exit+0x20/0x20
>> > > May 14 19:21:41 geek500 kernel:  =
ret_from_fork+0x22/0x30
>> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> =
> > May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000
>]---
>=
> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00:
>failed=
 to
>> > > change power setting=2E
>> > > May 14 19:21:41 geek500 kernel: P=
M: dpm_run_callback():
>> > > acpi_subsys_resume+0x0/0x50 returns -108
>> >=
 > May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM:
>faile=
d
>> > > to
>> > > resume async: error -108
>> > > May 14 19:21:41 geek500 =
kernel: amdgpu 0000:05:00=2E0:
>> > > [drm:amdgpu_ring_test_helper] *ERROR*=
 ring gfx test failed (-110)
>> > > May 14 19:21:41 geek500 kernel:
>[drm:a=
mdgpu_device_ip_resume_phase2]
>> > > *ERROR* resume of IP block <gfx_v9_0>=
 failed -110
>> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00=2E0: =
amdgpu:
>> > > amdgpu_device_ip_resume failed (-110)=2E
>> > > May 14 19:21=
:41 geek500 kernel: PM: dpm_run_callback():
>> > > pci_pm_resume+0x0/0x120 =
returns -110
>> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00=2E0: =
PM: failed
>to resume
>> > > async: error -110
>> > > May 14 19:21:41 geek5=
00 kernel: ------------[ cut here
>]------------
>> > > May 14 19:21:41 gee=
k500 kernel: AMDI0010:03 already disabled
>> > > May 14 19:21:41 geek500 ke=
rnel: WARNING: CPU: 6 PID: 1091 at
>drivers/clk/
>> > > clk=2Ec:971 clk_cor=
e_disable+0x80/0x1a0
>> > > May 14 19:21:41 geek500 kernel: Modules linked =
in: [last
>unloaded:
>> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU:=
 6 PID: 1091 Comm:
>> > > kworker/6:3 Tainted: G W  O      5=2E17=2E7+ #7
>=
> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>Gaming=

>> > > Laptop
>> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> > > May 14 =
19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> > > May 14 19:21:=
41 geek500 kernel: RIP:
>0010:clk_core_disable+0x80/0x1a0
>> > > May 14 19:=
21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
>00 00 48
>> > > 8b =
5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d
>87 c4
>> > =
> ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48
>0f a3 0=
5
>> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
>0018:ffff8dbfc1c=
47d50
>> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kernel:
>> > > May 14=
 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
>> > > ffff8885401b630=
0
>> > > RCX: 0000000000000027
>> > > May 14 19:21:41 geek500 kernel: RDX: =
ffff88885f59f468 RSI:
>> > > 0000000000000001
>> > > RDI: ffff88885f59f460
=
>> > > May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08:
>> > > ff=
ffffffabf26da8
>> > > R09: 00000000ffffdfff
>> > > May 14 19:21:41 geek500 =
kernel: R10: ffffffffabe46dc0 R11:
>> > > ffffffffabe46dc0
>> > > R12: ffff=
8885401b6300
>> > > May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R=
14:
>> > > 0000000000000008
>> > > R15: 0000000000000000
>> > > May 14 19:2=
1:41 geek500 kernel: FS:  0000000000000000(0000)
>> > > GS:ffff88885f580000=
(0000) knlGS:0000000000000000
>> > > May 14 19:21:41 geek500 kernel: CS:  0=
010 DS: 0000 ES: 0000 CR0:
>> > > 0000000080050033
>> > > May 14 19:21:41 g=
eek500 kernel: CR2: 00000000010fa990 CR3:
>> > > 0000000102956000
>> > > CR=
4: 0000000000350ee0
>> > > May 14 19:21:41 geek500 kernel: Call Trace:
>> >=
 > May 14 19:21:41 geek500 kernel:  <TASK>
>> > > May 14 19:21:41 geek500 k=
ernel:  clk_disable+0x24/0x30
>> > > May 14 19:21:41 geek500 kernel:  i2c_d=
w_prepare_clk+0x74/0xd0
>> > > May 14 19:21:41 geek500 kernel:  dw_i2c_plat=
_suspend+0x2e/0x40
>> > > May 14 19:21:41 geek500 kernel: 
>acpi_subsys_run=
time_suspend+0x9/0x20
>> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_su=
spend+0x160/0x160
>> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x=
3f/0x150
>> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0=
x160
>> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> > > =
May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> > > May =
14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> > > May 14 19:21:41=
 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> > > May 14 19:21:41 geek500 =
kernel:  process_one_work+0x1d3/0x3a0
>> > > May 14 19:21:41 geek500 kernel=
:  worker_thread+0x48/0x3c0
>> > > May 14 19:21:41 geek500 kernel:  ? rescu=
er_thread+0x380/0x380
>> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/=
0x100
>> > > May 14 19:21:41 geek500 kernel:  ?
>kthread_complete_and_exit+=
0x20/0x20
>> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>=
> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> > > May 14 19:21:41 geek5=
00 kernel: ---[ end trace 0000000000000000
>]---
>> > > May 14 19:21:41 gee=
k500 kernel: ------------[ cut here
>]------------
>> > > May 14 19:21:41 g=
eek500 kernel: AMDI0010:03 already unprepared
>> > > May 14 19:21:41 geek50=
0 kernel: WARNING: CPU: 6 PID: 1091 at
>drivers/clk/
>> > > clk=2Ec:829 clk=
_core_unprepare+0xb1/0x1a0
>> > > May 14 19:21:41 geek500 kernel: Modules l=
inked in: [last
>unloaded:
>> > > acpi_call] May 14 19:21:41 geek500 kernel=
: CPU: 6 PID: 1091 Comm:
>> > > kworker/6:3 Tainted: G W  O      5=2E17=2E7=
+ #7
>> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion
>=
Gaming
>> > > Laptop
>> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> > > M=
ay 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> > > May 14 =
19:21:41 geek500 kernel: RIP:
>0010:clk_core_unprepare+0xb1/0x1a0
>> > > Ma=
y 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48
>85 db 74
>>=
 > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
>87 =
c4
>> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
=
>a3 05 ea
>> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel: RSP:
>0018:fff=
f8dbfc1c47d60
>> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
=
>0000000000000000
>> > > RBX: ffff8885401b6300 RCX: 0000000000000027
>> > >=
 May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>> > > 00000000=
00000001
>> > > RDI: ffff88885f59f460
>> > > May 14 19:21:41 geek500 kernel=
: RBP: ffff8885401b6300 R08:
>> > > ffffffffabf26da8
>> > > R09: 00000000ff=
ffdfff
>> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>=
 > > ffffffffabe46dc0
>> > > R12: 0000000000000000
>> > > May 14 19:21:41 g=
eek500 kernel: R13: ffff888540fc30f4 R14:
>> > > 0000000000000008
>> > > R1=
5: 0000000000000000
>> > > May 14 19:21:41 geek500 kernel: FS:  00000000000=
00000(0000)
>> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
>> > > =
May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> > > 000=
0000080050033
>> > > May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 =
CR3:
>> > > 0000000102956000
>> > > CR4: 0000000000350ee0
>> > > May 14 19:=
21:41 geek500 kernel: Call Trace:
>> > > May 14 19:21:41 geek500 kernel:  <=
TASK>
>> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>> > =
> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
>> > > May =
14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> > > May 14 19=
:21:41 geek500 kernel: 
>acpi_subsys_runtime_suspend+0x9/0x20
>> > > May 14=
 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> > > May 14 19:=
21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> > > May 14 19:21:41 gee=
k500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> > > May 14 19:21:41 geek500=
 kernel: done=2E
>> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/=
0x60
>> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160=

>> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> > > May=
 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> > > May 14 19:21=
:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> > > May 14 19:21:41 ge=
ek500 kernel:  worker_thread+0x48/0x3c0
>> > > May 14 19:21:41 geek500 kern=
el:  ? rescuer_thread+0x380/0x380
>> > > May 14 19:21:41 geek500 kernel:  k=
thread+0xd3/0x100
>> > > May 14 19:21:41 geek500 kernel:  ?
>kthread_comple=
te_and_exit+0x20/0x20
>> > > May 14 19:21:41 geek500 kernel:  ret_from_fork=
+0x22/0x30
>> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> > > May 14 19=
:21:41 geek500 kernel: ---[ end trace 0000000000000000
>]---
>> > > May 14 =
19:21:41 geek500 kernel: ------------[ cut here
>]------------
>> > > May 1=
4 19:21:41 geek500 kernel: AMDI0010:03 already disabled
>> > > May 14 19:21=
:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>drivers/clk/
>> > > clk=
=2Ec:971 clk_core_disable+0x80/0x1a0
>> > > May 14 19:21:41 geek500 kernel:=
 Modules linked in: [last
>unloaded:
>> > > acpi_call] May 14 19:21:41 geek=
500 kernel: CPU: 6 PID: 1091 Comm:
>> > > kworker/6:3 Tainted: G W  O      =
5=2E17=2E7+ #7
>> > > May 14 19:21:41 geek500 kernel: Hardware name: HP HP =
Pavilion
>Gaming
>> > > Laptop
>> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/202=
1
>> > > May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> >=
 > May 14 19:21:41 geek500 kernel: RIP:
>0010:clk_core_disable+0x80/0x1a0
>=
> > > May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44
>00 =
00 48
>> > > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7=
 7d
>87 c4
>> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 8=
9 c0 48
>0f a3 05
>> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
>=
0018:ffff8dbfc1c47d50
>> > > EFLAGS: 00010082 May 14 19:21:41 geek500 kerne=
l: RAX:
>0000000000000000
>> > > RBX: ffff8885401b6300 RCX: 000000000000002=
7
>> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>> > > =
0000000000000001
>> > > RDI: ffff88885f59f460
>> > > May 14 19:21:41 geek50=
0 kernel: RBP: 0000000000000287 R08:
>> > > ffffffffabf26da8
>> > > R09: 00=
000000ffffdfff
>> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0=
 R11:
>> > > ffffffffabe46dc0
>> > > R12: ffff8885401b6300
>> > > May 14 19=
:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>> > > 0000000000000008
>=
> > > R15: 0000000000000000
>> > > May 14 19:21:41 geek500 kernel: FS:  000=
0000000000000(0000)
>> > > GS:ffff88885f580000(0000) knlGS:0000000000000000=

>> > > May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>=
 > > 0000000080050033
>> > > May 14 19:21:41 geek500 kernel: CR2: 000000000=
10fa990 CR3:
>> > > 0000000102956000
>> > > CR4: 0000000000350ee0
>> > > Ma=
y 14 19:21:41 geek500 kernel: Call Trace:
>> > > May 14 19:21:41 geek500 ke=
rnel:  <TASK>
>> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30=

>> > > May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
>> > =
> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> > > May=
 14 19:21:41 geek500 kernel: 
>acpi_subsys_runtime_suspend+0x9/0x20
>> > > =
May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> > > May =
14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> > > May 14 19:21:=
41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> > > May 14 19:21:41 g=
eek500 kernel:  rpm_callback+0x54/0x60
>> > > May 14 19:21:41 geek500 kerne=
l:  ? acpi_dev_suspend+0x160/0x160
>> > > May 14 19:21:41 geek500 kernel:  =
rpm_suspend+0x142/0x720
>> > > May 14 19:21:41 geek500 kernel:  pm_runtime_=
work+0x8f/0xa0
>> > > May 14 19:21:41 geek500 kernel:  process_one_work+0x1=
d3/0x3a0
>> > > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>=
> > > May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> > > =
May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> > > May 14 19:21:41 =
geek500 kernel:  ?
>kthread_complete_and_exit+0x20/0x20
>> > > May 14 19:21=
:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> > > May 14 19:21:41 geek500=
 kernel:  </TASK>
>> > > May 14 19:21:41 geek500 kernel: ---[ end trace 000=
0000000000000
>]---
>> > > May 14 19:21:41 geek500 kernel: ------------[ cu=
t here
>]------------
>> > > May 14 19:21:41 geek500 kernel: AMDI0010:03 al=
ready unprepared
>> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID=
: 1091 at
>drivers/clk/
>> > > clk=2Ec:829 clk_core_unprepare+0xb1/0x1a0
>>=
 > > May 14 19:21:41 geek500 kernel: Modules linked in: [last
>unloaded:
>>=
 > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm:
>> >=
 > kworker/6:3 Tainted: G W  O      5=2E17=2E7+ #7
>> > > May 14 19:21:41 g=
eek500 kernel: Hardware name: HP HP Pavilion
>Gaming
>> > > Laptop
>> > > 1=
5-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> > > May 14 19:21:41 geek500 kernel=
: Workqueue: pm pm_runtime_work
>> > > May 14 19:21:41 geek500 kernel: RIP:=

>0010:clk_core_unprepare+0xb1/0x1a0
>> > > May 14 19:21:41 geek500 kernel:=
 Code: 40 00 66 90 48 8b 5b 30 48
>85 db 74
>> > > a2 8b 83 80 00 00 00 85 =
c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35
>87 c4
>> > > ab e8 18 7c 9a 00 <=
0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f
>a3 05 ea
>> > > 62 9d 01 73 =
May 14 19:21:41 geek500 kernel: RSP:
>0018:ffff8dbfc1c47d60
>> > > EFLAGS: =
00010286 May 14 19:21:41 geek500 kernel: RAX:
>0000000000000000
>> > > RBX:=
 ffff8885401b6300 RCX: 0000000000000027
>> > > May 14 19:21:41 geek500 kern=
el: RDX: ffff88885f59f468 RSI:
>> > > 0000000000000001
>> > > RDI: ffff8888=
5f59f460
>> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08:
=
>> > > ffffffffabf26da8
>> > > R09: 00000000ffffdfff
>> > > May 14 19:21:41=
 geek500 kernel: R10: ffffffffabe46dc0 R11:
>> > > ffffffffabe46dc0
>> > > =
R12: 0000000000000000
>> > > May 14 19:21:41 geek500 kernel: R13: ffff88854=
0fc30f4 R14:
>> > > 0000000000000008
>> > > R15: 0000000000000000
>> > > Ma=
y 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> > > GS:ffff888=
85f580000(0000) knlGS:0000000000000000
>> > > May 14 19:21:41 geek500 kerne=
l: CS:  0010 DS: 0000 ES: 0000 CR0:
>> > > 0000000080050033
>> > > May 14 1=
9:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>> > > 0000000102956000
=
>> > > CR4: 0000000000350ee0
>> > > May 14 19:21:41 geek500 kernel: Call Tr=
ace:
>> > > May 14 19:21:41 geek500 kernel:  <TASK>
>> > > May 14 19:21:41 =
geek500 kernel:  clk_unprepare+0x1f/0x30
>> > > May 14 19:21:41 geek500 ker=
nel:  i2c_dw_prepare_clk+0x90/0xd0
>> > > May 14 19:21:41 geek500 kernel:  =
dw_i2c_plat_suspend+0x2e/0x40
>> > > May 14 19:21:41 geek500 kernel: 
>acpi=
_subsys_runtime_suspend+0x9/0x20
>> > > May 14 19:21:41 geek500 kernel:  ? =
acpi_dev_suspend+0x160/0x160
>> > > May 14 19:21:41 geek500 kernel:  __rpm_=
callback+0x3f/0x150
>> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_susp=
end+0x160/0x160
>> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0=
x60
>> > > May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
=
>> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> > > May =
14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> > > May 14 19:21:=
41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> > > May 14 19:21:41 gee=
k500 kernel:  worker_thread+0x48/0x3c0
>> > > May 14 19:21:41 geek500 kerne=
l:  ? rescuer_thread+0x380/0x380
>> > > May 14 19:21:41 geek500 kernel:  kt=
hread+0xd3/0x100
>> > > May 14 19:21:41 geek500 kernel:  ?
>kthread_complet=
e_and_exit+0x20/0x20
>> > > May 14 19:21:41 geek500 kernel:  ret_from_fork+=
0x22/0x30
>> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> > > May 14 19:=
21:41 geek500 kernel: ---[ end trace 0000000000000000
>]---
>> > > May 14 1=
9:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0:
>Unable to
>> > > s=
ync register 0x4f0800=2E -5
>> > > May 14 19:21:59 geek500 kernel: (elapsed=
 0=2E175 seconds) done=2E
>> > > May 14 19:21:59 geek500 kernel: amdgpu 000=
0:05:00=2E0: amdgpu:
>Power
>> > > consumption will be higher as BIOS has n=
ot been configured for
>> > > suspend-to-idle=2E To use suspend-to-idle cha=
nge the sleep mode in
>BIOS
>> > > setup=2E
>> > > May 14 19:21:59 geek500 =
kernel: snd_hda_intel 0000:01:00=2E1: can't
>change
>> > > power state from=
 D3cold to D0 (config space inaccessible)
>> > > May 14 19:21:59 geek500 ke=
rnel: pci 0000:00:00=2E2: can't derive
>routing for
>> > > PCI INT A
>> > >=
 May 14 19:21:59 geek500 kernel: pci 0000:00:00=2E2: PCI INT A: no
>GSI
>> =
> > May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer
>expired on =
ring
>> > > gfx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command
>0=
xfc20 tx
>> > > timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallbac=
k
>timer
>> > > expired on ring sdma0
>> > > May 14 19:21:59 geek500 kernel=
: Bluetooth: hci0: RTL: download fw
>command
>> > > failed (-110)
>> > > Ma=
y 14 19:21:59 geek500 kernel: done=2E
>> > > May 14 19:22:00 geek500 kernel=
: snd_hda_codec_hdmi hdaudioC1D0:
>Unable to
>> > > sync register 0x4f0800=
=2E -5
>> > > May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in
>/=
etc/dnsmasq=2Ed/
>> > > dnsmasq-resolv=2Econf, will retry
>> > > May 14 19:=
22:01 geek500 kernel: [drm] Fence fallback timer
>expired on ring
>> > > sd=
ma0
>> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
>expi=
red on ring
>> > > gfx May 14 19:22:01 geek500 kernel: [drm] Fence fallback=
 timer
>expired on
>> > > ring sdma0
>> > > May 14 19:22:02 geek500 last me=
ssage buffered 2 times
>> > > May 14 19:22:03 geek500 kernel: [drm] Fence f=
allback timer
>expired on ring
>> > > gfx May 14 19:22:03 geek500 kernel: [=
drm] Fence fallback timer
>expired on
>> > > ring sdma0
>> > > May 14 19:22=
:03 geek500 kernel: [drm] Fence fallback timer
>expired on ring
>> > > gfx =
May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer
>expired on
>> >=
 > ring sdma0
>> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback t=
imer
>expired on ring
>> > > gfx May 14 19:22:04 geek500 kernel: [drm] Fenc=
e fallback timer
>expired on
>> > > ring sdma0
>> > > May 14 19:22:04 geek5=
00 kernel: [drm] Fence fallback timer
>expired on ring
>> > > gfx May 14 19=
:22:04 geek500 kernel: [drm] Fence fallback timer
>expired on
>> > > ring s=
dma0
>> > > May 14 19:22:05 geek500 last message buffered 2 times
>> > > Ma=
y 14 19:22:05 geek500 kernel: [drm] Fence fallback timer
>expired on ring
>=
> > > gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer
>expir=
ed on
>> > > ring sdma0
>> > > May 14 19:22:06 geek500 kernel: [drm] Fence =
fallback timer
>expired on ring
>> > > gfx May 14 19:22:06 geek500 last mes=
sage buffered 1 times
>> > > =2E=2E=2E
>> > > May 14 19:22:18 geek500 kerne=
l: [drm] Fence fallback timer
>expired on ring
>> > > sdma0
>> > > May 14 1=
9:22:18 geek500 kernel:
>[drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>> > > =
Waiting for fences timed out!
>> > > May 14 19:22:18 geek500 kernel: [drm] =
Fence fallback timer
>expired on ring
>> > > sdma0
>> > >
>> > > CC
>> > >
=
>> > > Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a =C3=A9crit =
:
>> > > > Hi, this is your Linux kernel regression tracker=2E Thanks for
>=
the report=2E
>> > > >
>> > > > On 14=2E05=2E22 16:41, Christian Casteyde w=
rote:
>> > > > > #regzbot introduced v5=2E17=2E3=2E=2Ev5=2E17=2E4
>> > > > =
> #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
>> > > >
>>=
 > > > FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA
>function =
is
>> > > > suspended before ASIC reset") upstream=2E
>> > > >
>> > > > Rec=
ently a regression was reported where 887f75cfd0da was
>suspected as
>> > >=
 > the culprit:
>> > > > https://gitlab=2Efreedesktop=2Eorg/drm/amd/-/issue=
s/2008
>> > > >
>> > > > And a one related to it:
>> > > > https://gitlab=
=2Efreedesktop=2Eorg/drm/amd/-/issues/1982
>> > > >
>> > > > You might want=
 to take a look if what was discussed there might
>be
>> > > > related to y=
our problem (I'm not directly involved in any of
>this, I
>> > > > don't kn=
ow the details, it's just that 887f75cfd0da looked
>familiar to
>> > > > me=
)=2E If it is, a fix for these two bugs was committed to master
>earlier
>>=
 > > > this week:
>> > > >
>> > > >
>https://git=2Ekernel=2Eorg/pub/scm/lin=
ux/kernel/git/torvalds/linux=2Egit/commi
>> > > > t/?i d=3Da56f445f807b0276=

>> > > >
>> > > > It will likely be backported to 5=2E17=2Ey, maybe alread=
y in the
>over-next
>> > > > release=2E HTH=2E
>> > > >
>> > > > Ciao, Thor=
sten (wearing his 'the Linux kernel's regression
>tracker' hat)
>> > > >
>>=
 > > > P=2ES=2E: As the Linux kernel's regression tracker I deal with a
>lo=
t of
>> > > > reports and sometimes miss something important when writing
>=
mails like
>> > > > this=2E If that's the case here, don't hesitate to tell=
 me in a
>public
>> > > > reply, it's in everyone's interest to set the pub=
lic record
>straight=2E
>> > > >
>> > > > > Hello
>> > > > > Since 5=2E17=
=2E4 my laptop doesn't resume from suspend anymore=2E
>At resume,
>> > > > =
> symptoms are variable:
>> > > > > - either the laptop freezes;
>> > > > >=
 - either the screen keeps blank;
>> > > > > - either the screen is OK but =
mouse is frozen;
>> > > > > - either display lags with several logs in dmes=
g:
>> > > > > [  228=2E275492] [drm] Fence fallback timer expired on ring g=
fx
>> > > > > [  228=2E395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>=
Waiting for
>> > > > > fences timed out!
>> > > > > [  228=2E779490] [drm] =
Fence fallback timer expired on ring gfx
>> > > > > [  229=2E283484] [drm] =
Fence fallback timer expired on ring
>sdma0
>> > > > > [  229=2E283485] [dr=
m] Fence fallback timer expired on ring gfx
>> > > > > [  229=2E787487] [dr=
m] Fence fallback timer expired on ring gfx
>> > > > > =2E=2E=2E
>> > > > >=

>> > > > > I've bisected the problem=2E
>> > > > >
>> > > > > Please note =
this laptop has a strange behaviour on suspend:
>> > > > > The first suspen=
d request always fails (this point has never
>been
>> > > > > fixed
>> > > =
> > and
>> > > > > plagues us when trying to diagnose another regression on=

>touchpad not
>> > > > > resuming in the past)=2E The screen goes blank an=
d I can get it
>OK when
>> > > > > pressing the power button, this seems to=
 reset it=2E After that
>all
>> > > > > suspend/resume works OK=2E
>> > > >=
 >
>> > > > > Since 5=2E17=2E4, it is not possible anymore to get the lapto=
p
>working
>> > > > > again
>> > > > > after the first suspend failure=2E
>=
> > > > >
>> > > > > HW : HP Pavilion / Ryzen 4600H with AMD graphics integ=
rated +
>NVidia
>> > > > > 1650Ti
>> > > > > (turned off with ACPI call in =
order to get more battery, I'm
>not using
>> > > > > NVidia driver)=2E
>>

