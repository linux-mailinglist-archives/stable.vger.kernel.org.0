Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B47952B349
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 09:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiERHQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 03:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiERHPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 03:15:52 -0400
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [IPv6:2a01:e0c:1:1599::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5E6110D
        for <stable@vger.kernel.org>; Wed, 18 May 2022 00:15:49 -0700 (PDT)
Received: from [10.182.230.56] (unknown [185.228.229.216])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp6-g21.free.fr (Postfix) with ESMTPSA id 0ED0A7802C2;
        Wed, 18 May 2022 09:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1652858147;
        bh=U5m2jyKwBwYytTOFTQ3/aV9t2yK+iNmTaAVwRToPSD0=;
        h=In-Reply-To:References:Subject:From:Date:To:CC:From;
        b=CwHyHNsCXD9WcD6L8QMghw2r8O5k8E1pcWOt5FzM7C2oMUDg0q228eiOEvmTa86UT
         lhExytLwL3HBf+QD+f6TL7iZMt4FQTiGGHmD8lPtGK0NK6lF0O7kHe9xddhLgNErZt
         TyGEUWj2qFcnU1ubkcuKk0NbtX85hXh604VxR4rAoRWxN3MwAszjAJCokae0cJ9Zfb
         J0AR8U3PDKQjTjInGG4JYwpikIKiNhL6LqeeENm+gVf4cIm39zUH8UQ2rnL1PZkq3+
         BWqkA3a2tu+LlFo639VuGXH+m5VCwwA35Y9ISwiZYZIQjeylkVfkcpBsMm/WreAGh0
         2ZJy3cnWJsVwA==
In-Reply-To: <CAAd53p69LqeH7pD2S4T-D4i_+PEaejb12kx7rbapPrPCfQ9-iQ@mail.gmail.com>
References: <CAAd53p7Sw+EAjn2fH++g7dQaAHxzTqdN81f6xNVKy4hqCWgztw@mail.gmail.com> <75938817.547810377.1652809118472.JavaMail.root@zimbra40-e7.priv.proxad.net> <CAAd53p69LqeH7pD2S4T-D4i_+PEaejb12kx7rbapPrPCfQ9-iQ@mail.gmail.com>
X-Referenced-Uid: 151144
Thread-Topic: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
X-Blue-Identity: !l=258&o=43&fo=82534&pl=161&po=0&qs=PREFIX&f=HTML&n=Christian%20Casteyde&e=casteyde.christian%40free.fr&m=!%3ANTM3NzFlMTMtOWRlNi00YjEyLTk1ODktNzE2YmFlN2E2MmNl%3ASU5CT1g%3D%3AMTUxMTQ0%3AANSWERED&p=123&q=SHOW
X-Is-Generated-Message-Id: true
User-Agent: Android
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
From:   Christian Casteyde <casteyde.christian@free.fr>
Date:   Wed, 18 May 2022 09:15:38 +0200
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Message-ID: <d2a11b8c-43fe-4f37-9ac6-5fee9be24682@free.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This laptop has never managed to suspend correctly at first try=2E However =
on second try without the commit, it does work=2E 
What I do is:
- try firs=
t, the suspend fails but the screen remains blank=2E
- press the power butt=
on, that does something that resumes the screen
- try second, and this time=
s it works=2E
I will append a dmesg output with the second pass also when i=
t works=2E
FYI we also tried to find the first pass failure while chasing a=
nother previous regression but we didn't managed=2E
With the regression, I =
cannot resume from the first try at all (either the laptop remains stuck, o=
r=C2=A0 it resumes the screen but it lags with all the timeouts in dmesg)=
=2E So it 'doesnt work worse'=2E

CC

=E2=81=A3T=C3=A9l=C3=A9charger BlueMa=
il pour Android =E2=80=8B

Le 18 mai 2022 =C3=A0 04:08, =C3=A0 04:08, Kai-H=
eng Feng <kai=2Eheng=2Efeng@canonical=2Ecom> a =C3=A9crit:
>On Wed, May 18,=
 2022 at 1:38 AM <casteyde=2Echristian@free=2Efr> wrote:
>>
>> dmesg logs
>=

>Actually, the "good" is still no good:
>[   43=2E375323] PM: suspend entr=
y (deep)
>=2E=2E=2E
>[   43=2E695342] PM: late suspend of devices failed
>=
=2E=2E=2E
>[   44=2E554108] PM: suspend exit
>[   44=2E554168] PM: suspend =
entry (s2idle)
>
>So we need to find out why the suspend failed at first pl=
ace=2E
>
>Kai-Heng
>
>>
>> ----- Mail original -----
>> De: "Kai-Heng Feng"=
 <kai=2Eheng=2Efeng@canonical=2Ecom>
>> =C3=80: "Christian Casteyde" <caste=
yde=2Echristian@free=2Efr>
>> Cc: stable@vger=2Ekernel=2Eorg, "Thorsten Lee=
mhuis"
><regressions@leemhuis=2Einfo>, regressions@lists=2Elinux=2Edev, "al=
exander
>deucher" <alexander=2Edeucher@amd=2Ecom>, gregkh@linuxfoundation=
=2Eorg,
>"Mario Limonciello" <mario=2Elimonciello@amd=2Ecom>
>> Envoy=C3=A9=
: Mardi 17 Mai 2022 08:58:30
>> Objet: Re: [REGRESSION] Laptop with Ryzen 4=
600H fails to resume video
>since 5=2E17=2E4 (works 5=2E17=2E3)
>>
>> On Tu=
e, May 17, 2022 at 2:36 PM Christian Casteyde
>> <casteyde=2Echristian@free=
=2Efr> wrote:
>> >
>> > No, the problem is there even without acpicall=2E F=
yi I use it to
>shutdown the NVidia card that eats the battery otherwise=2E=

>> >
>> > I managed to get a dmesg output with 2=2E18rc7 I will post it th=
is
>evening (basically exact same behavior as 2=2E17=2E4)=2E
>>
>> Can you =
please also attach dmesg without the offending commit (i=2Ee=2E
>> when it'=
s working)?
>>
>> Kai-Heng
>>
>> >
>> > CC
>> >
>> > =E2=81=A3T=C3=A9l=C3=
=A9charger BlueMail pour Android
>> >
>> > Le 17 mai 2022 =C3=A0 04:03, =C3=
=A0 04:03, Kai-Heng Feng
><kai=2Eheng=2Efeng@canonical=2Ecom> a =C3=A9crit:=

>> > >On Tue, May 17, 2022 at 1:23 AM Christian Casteyde
>> > ><casteyde=
=2Echristian@free=2Efr> wrote:
>> > >>
>> > >> I've tried with 5=2E18-rc7, =
it doesn't work either=2E I guess 5=2E18
>branch
>> > >have all
>> > >> com=
mits=2E
>> > >>
>> > >> full dmesg appended (not for 5=2E18, I didn't manag=
e to resume up
>to
>> > >the point
>> > >> to get a console for now)=2E
>> =
> >
>> > >Interestingly, I found you are using acpi_call:
>> > >[   30=2E66=
7348] acpi_call: loading out-of-tree module taints
>kernel=2E
>> > >
>> > >=
Does removing the acpi_call solve the issue?
>> > >
>> > >Kai-Heng
>> > >
>=
> > >>
>> > >> CC
>> > >>
>> > >> Le lundi 16 mai 2022, 04:47:25 CEST Kai-H=
eng Feng a =C3=A9crit :
>> > >> > [+Cc Mario]
>> > >> >
>> > >> > On Sun, M=
ay 15, 2022 at 1:34 AM Christian Casteyde
>> > >> >
>> > >> > <casteyde=2Ec=
hristian@free=2Efr> wrote:
>> > >> > > I've applied the commit a56f445f807b=
0276 on 5=2E17=2E7 and
>tested=2E
>> > >> > > This does not fix the problem=
 on my laptop=2E
>> > >> >
>> > >> > Maybe some commits are still missing?
=
>> > >> >
>> > >> > > For informatio, here is a part of the log around the =
suspend
>> > >process:
>> > >> > Is it possible to attach full dmesg?
>> > =
>> >
>> > >> > Kai-Heng
>> > >> >
>> > >> > > May 14 19:21:41 geek500 kerne=
l: snd_hda_intel 0000:01:00=2E1:
>can't
>> > >change
>> > >> > > power stat=
e from D3cold to D0 (config space inaccessible)
>> > >> > > May 14 19:21:41=
 geek500 kernel: PM: late suspend of devices
>> > >failed
>> > >> > > May 1=
4 19:21:41 geek500 kernel: ------------[ cut here
>> > >]------------
>> > =
>> > > May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03:
>> > >Tr=
ansfer while
>> > >> > > suspended
>> > >> > > May 14 19:21:41 geek500 kern=
el: pci 0000:00:00=2E2: can't
>derive
>> > >routing for
>> > >> > > PCI INT=
 A
>> > >> > > May 14 19:21:41 geek500 kernel: pci 0000:00:00=2E2: PCI INT =
A:
>no
>> > >GSI
>> > >> > > May 14 19:21:41 geek500 kernel: WARNING: CPU: =
9 PID: 1972 at
>> > >drivers/i2c/
>> > >> > > busses/i2c-designware-master=
=2Ec:570 i2c_dw_xfer+0x3f6/0x440
>> > >> > > May 14 19:21:41 geek500 kernel=
: Modules linked in: [last
>> > >unloaded:
>> > >> > > acpi_call] May 14 19=
:21:41 geek500 kernel: CPU: 9 PID: 1972
>Comm:
>> > >> > > kworker/u32:18 T=
ainted: G           O      5=2E17=2E7+ #7
>> > >> > > May 14 19:21:41 geek5=
00 kernel: Hardware name: HP HP
>Pavilion
>> > >Gaming
>> > >> > > Laptop
>=
> > >> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> > >> > > May 14 19:21:=
41 geek500 kernel: Workqueue: events_unbound
>> > >> > > async_run_entry_fn=
 May 14 19:21:41 geek500 kernel: RIP:
>> > >> > > 0010:i2c_dw_xfer+0x3f6/0x=
440
>> > >> > > May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01
=
>4c 8b
>> > >67 50 4d
>> > >> > > 85 e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89=
 e2 48 c7 c7 00 01
>cc
>> > >> > >
>> > >> > >  ab 48 89 c6 e8 b3 4f 45 00 =
<0f> 0b 41 be 94 ff ff ff e9 cc
>fc ff
>> > >ff e9 2d
>> > >> > >  9c>
>> >=
 >> > > 4b 00 83 f8 01 74
>> > >> > > May 14 19:21:41 geek500 kernel: RSP: =
0018:ffff8dbfc31e7c68
>> > >EFLAGS:
>> > >> > > 00010286
>> > >> > > May 14=
 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX:
>> > >> > > ffff888540=
f170e8
>> > >> > > RCX: 0000000000000be5
>> > >> > > May 14 19:21:41 geek50=
0 kernel: RDX: 0000000000000000 RSI:
>> > >> > > 0000000000000086
>> > >> >=
 > RDI: ffffffffac858df8
>> > >> > > May 14 19:21:41 geek500 kernel: RBP: f=
fff888540f170e8 R08:
>> > >> > > ffffffffabe46d60
>> > >> > > R09: 00000000=
ac86a0f6
>> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff =
R11:
>> > >> > > ffffffffffffffff
>> > >> > > R12: ffff888540f5c070
>> > >>=
 > > May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14:
>> > >> > >=
 00000000ffffff94
>> > >> > > R15: ffff888540f17028
>> > >> > > May 14 19:2=
1:41 geek500 kernel: FS:  0000000000000000(0000)
>> > >> > > GS:ffff88885f6=
40000(0000) knlGS:0000000000000000
>> > >> > > May 14 19:21:41 geek500 kern=
el: CS:  0010 DS: 0000 ES: 0000
>CR0:
>> > >> > > 0000000080050033
>> > >> =
> > May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3:
>> > >> > > =
0000000045e0c000
>> > >> > > CR4: 0000000000350ee0
>> > >> > > May 14 19:21=
:41 geek500 kernel: Call Trace:
>> > >> > > May 14 19:21:41 geek500 kernel:=
  <TASK>
>> > >> > > May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4=
/0x250
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> > >newidle_balance=
=2Econstprop=2E0+0x1f7/0x3b0
>> > >> > > May 14 19:21:41 geek500 kernel:  _=
_i2c_transfer+0x16d/0x520
>> > >> > > May 14 19:21:41 geek500 kernel:  i2c_=
transfer+0x7a/0xd0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>__i2c_hid_=
command+0x106/0x2d0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>amd_gpi=
o_irq_enable+0x19/0x50
>> > >> > > May 14 19:21:41 geek500 kernel:  i2c_hid=
_set_power+0x4a/0xd0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>i2c_hid_=
core_resume+0x60/0xb0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> > >=
acpi_subsys_resume_early+0x50/0x50
>> > >> > > May 14 19:21:41 geek500 kern=
el:  dpm_run_callback+0x1d/0xd0
>> > >> > > May 14 19:21:41 geek500 kernel:=
  device_resume+0x122/0x230
>> > >> > > May 14 19:21:41 geek500 kernel:  as=
ync_resume+0x14/0x30
>> > >> > > May 14 19:21:41 geek500 kernel: 
>async_ru=
n_entry_fn+0x1b/0xa0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>process_=
one_work+0x1d3/0x3a0
>> > >> > > May 14 19:21:41 geek500 kernel:  worker_th=
read+0x48/0x3c0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>rescuer_thr=
ead+0x380/0x380
>> > >> > > May 14 19:21:41 geek500 kernel:  kthread+0xd3/0=
x100
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> > >kthread_complete_=
and_exit+0x20/0x20
>> > >> > > May 14 19:21:41 geek500 kernel:  ret_from_fo=
rk+0x22/0x30
>> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> > >> >=
 > May 14 19:21:41 geek500 kernel: ---[ end trace
>0000000000000000
>> > >]=
---
>> > >> > > May 14 19:21:41 geek500 kernel: i2c_hid_acpi
>i2c-ELAN0718:=
00:
>> > >failed to
>> > >> > > change power setting=2E
>> > >> > > May 14 =
19:21:41 geek500 kernel: PM: dpm_run_callback():
>> > >> > > acpi_subsys_re=
sume+0x0/0x50 returns -108
>> > >> > > May 14 19:21:41 geek500 kernel: i2c_=
hid_acpi
>i2c-ELAN0718:00: PM:
>> > >failed
>> > >> > > to
>> > >> > > resu=
me async: error -108
>> > >> > > May 14 19:21:41 geek500 kernel: amdgpu 000=
0:05:00=2E0:
>> > >> > > [drm:amdgpu_ring_test_helper] *ERROR* ring gfx tes=
t failed
>(-110)
>> > >> > > May 14 19:21:41 geek500 kernel:
>> > >[drm:amd=
gpu_device_ip_resume_phase2]
>> > >> > > *ERROR* resume of IP block <gfx_v9=
_0> failed -110
>> > >> > > May 14 19:21:41 geek500 kernel: amdgpu 0000:05:=
00=2E0: amdgpu:
>> > >> > > amdgpu_device_ip_resume failed (-110)=2E
>> > >=
> > > May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
>> > >> > > p=
ci_pm_resume+0x0/0x120 returns -110
>> > >> > > May 14 19:21:41 geek500 ker=
nel: amdgpu 0000:05:00=2E0: PM:
>failed
>> > >to resume
>> > >> > > async: =
error -110
>> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut he=
re
>> > >]------------
>> > >> > > May 14 19:21:41 geek500 kernel: AMDI0010=
:03 already disabled
>> > >> > > May 14 19:21:41 geek500 kernel: WARNING: C=
PU: 6 PID: 1091 at
>> > >drivers/clk/
>> > >> > > clk=2Ec:971 clk_core_disa=
ble+0x80/0x1a0
>> > >> > > May 14 19:21:41 geek500 kernel: Modules linked i=
n: [last
>> > >unloaded:
>> > >> > > acpi_call] May 14 19:21:41 geek500 ker=
nel: CPU: 6 PID: 1091
>Comm:
>> > >> > > kworker/6:3 Tainted: G W  O      5=
=2E17=2E7+ #7
>> > >> > > May 14 19:21:41 geek500 kernel: Hardware name: HP=
 HP
>Pavilion
>> > >Gaming
>> > >> > > Laptop
>> > >> > > 15-ec1xxx/87B2, B=
IOS F=2E25 08/18/2021
>> > >> > > May 14 19:21:41 geek500 kernel: Workqueue=
: pm
>pm_runtime_work
>> > >> > > May 14 19:21:41 geek500 kernel: RIP:
>> >=
 >0010:clk_core_disable+0x80/0x1a0
>> > >> > > May 14 19:21:41 geek500 kern=
el: Code: 10 e8 e4 4a d1 00 0f
>1f 44
>> > >00 00 48
>> > >> > > 8b 5b 30 4=
8 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7
>c7 7d
>> > >87 c4
>> > >=
> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89
>c0 48
>> =
> >0f a3 05
>> > >> > > 4a 61 9d 01 May 14 19:21:41 geek500 kernel: RSP:
>>=
 > >0018:ffff8dbfc1c47d50
>> > >> > > EFLAGS: 00010082 May 14 19:21:41 geek=
500 kernel:
>> > >> > > May 14 19:21:41 geek500 kernel: RAX: 00000000000000=
00 RBX:
>> > >> > > ffff8885401b6300
>> > >> > > RCX: 0000000000000027
>> >=
 >> > > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>> > >> =
> > 0000000000000001
>> > >> > > RDI: ffff88885f59f460
>> > >> > > May 14 1=
9:21:41 geek500 kernel: RBP: 0000000000000283 R08:
>> > >> > > ffffffffabf2=
6da8
>> > >> > > R09: 00000000ffffdfff
>> > >> > > May 14 19:21:41 geek500 =
kernel: R10: ffffffffabe46dc0 R11:
>> > >> > > ffffffffabe46dc0
>> > >> > >=
 R12: ffff8885401b6300
>> > >> > > May 14 19:21:41 geek500 kernel: R13: fff=
f888540fc30f4 R14:
>> > >> > > 0000000000000008
>> > >> > > R15: 0000000000=
000000
>> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(00=
00)
>> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
>> > >> > =
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000
>CR0:
>> > >>=
 > > 0000000080050033
>> > >> > > May 14 19:21:41 geek500 kernel: CR2: 0000=
0000010fa990 CR3:
>> > >> > > 0000000102956000
>> > >> > > CR4: 00000000003=
50ee0
>> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
>> > >> > > M=
ay 14 19:21:41 geek500 kernel:  <TASK>
>> > >> > > May 14 19:21:41 geek500 =
kernel:  clk_disable+0x24/0x30
>> > >> > > May 14 19:21:41 geek500 kernel: =

>i2c_dw_prepare_clk+0x74/0xd0
>> > >> > > May 14 19:21:41 geek500 kernel: =

>dw_i2c_plat_suspend+0x2e/0x40
>> > >> > > May 14 19:21:41 geek500 kernel:=

>> > >acpi_subsys_runtime_suspend+0x9/0x20
>> > >> > > May 14 19:21:41 gee=
k500 kernel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 g=
eek500 kernel:  __rpm_callback+0x3f/0x150
>> > >> > > May 14 19:21:41 geek5=
00 kernel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 gee=
k500 kernel:  rpm_callback+0x54/0x60
>> > >> > > May 14 19:21:41 geek500 ke=
rnel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 geek500 =
kernel:  rpm_suspend+0x142/0x720
>> > >> > > May 14 19:21:41 geek500 kernel=
:  pm_runtime_work+0x8f/0xa0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>=
process_one_work+0x1d3/0x3a0
>> > >> > > May 14 19:21:41 geek500 kernel:  w=
orker_thread+0x48/0x3c0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>res=
cuer_thread+0x380/0x380
>> > >> > > May 14 19:21:41 geek500 kernel:  kthrea=
d+0xd3/0x100
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> > >kthread_c=
omplete_and_exit+0x20/0x20
>> > >> > > May 14 19:21:41 geek500 kernel:  ret=
_from_fork+0x22/0x30
>> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
>=
> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace
>0000000000000000=

>> > >]---
>> > >> > > May 14 19:21:41 geek500 kernel: ------------[ cut h=
ere
>> > >]------------
>> > >> > > May 14 19:21:41 geek500 kernel: AMDI001=
0:03 already
>unprepared
>> > >> > > May 14 19:21:41 geek500 kernel: WARNIN=
G: CPU: 6 PID: 1091 at
>> > >drivers/clk/
>> > >> > > clk=2Ec:829 clk_core_=
unprepare+0xb1/0x1a0
>> > >> > > May 14 19:21:41 geek500 kernel: Modules li=
nked in: [last
>> > >unloaded:
>> > >> > > acpi_call] May 14 19:21:41 geek5=
00 kernel: CPU: 6 PID: 1091
>Comm:
>> > >> > > kworker/6:3 Tainted: G W  O =
     5=2E17=2E7+ #7
>> > >> > > May 14 19:21:41 geek500 kernel: Hardware na=
me: HP HP
>Pavilion
>> > >Gaming
>> > >> > > Laptop
>> > >> > > 15-ec1xxx/8=
7B2, BIOS F=2E25 08/18/2021
>> > >> > > May 14 19:21:41 geek500 kernel: Wor=
kqueue: pm
>pm_runtime_work
>> > >> > > May 14 19:21:41 geek500 kernel: RIP=
:
>> > >0010:clk_core_unprepare+0xb1/0x1a0
>> > >> > > May 14 19:21:41 geek=
500 kernel: Code: 40 00 66 90 48 8b 5b
>30 48
>> > >85 db 74
>> > >> > > a2=
 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7
>c7 35
>> > >87 c=
4
>> > >> > > ab e8 18 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0
>4=
8 0f
>> > >a3 05 ea
>> > >> > > 62 9d 01 73 May 14 19:21:41 geek500 kernel:=
 RSP:
>> > >0018:ffff8dbfc1c47d60
>> > >> > > EFLAGS: 00010286 May 14 19:21=
:41 geek500 kernel: RAX:
>> > >0000000000000000
>> > >> > > RBX: ffff888540=
1b6300 RCX: 0000000000000027
>> > >> > > May 14 19:21:41 geek500 kernel: RD=
X: ffff88885f59f468 RSI:
>> > >> > > 0000000000000001
>> > >> > > RDI: ffff=
88885f59f460
>> > >> > > May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6=
300 R08:
>> > >> > > ffffffffabf26da8
>> > >> > > R09: 00000000ffffdfff
>> =
> >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>> > >>=
 > > ffffffffabe46dc0
>> > >> > > R12: 0000000000000000
>> > >> > > May 14 =
19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>> > >> > > 00000000000=
00008
>> > >> > > R15: 0000000000000000
>> > >> > > May 14 19:21:41 geek500=
 kernel: FS:  0000000000000000(0000)
>> > >> > > GS:ffff88885f580000(0000) =
knlGS:0000000000000000
>> > >> > > May 14 19:21:41 geek500 kernel: CS:  001=
0 DS: 0000 ES: 0000
>CR0:
>> > >> > > 0000000080050033
>> > >> > > May 14 1=
9:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>> > >> > > 000000010295=
6000
>> > >> > > CR4: 0000000000350ee0
>> > >> > > May 14 19:21:41 geek500 =
kernel: Call Trace:
>> > >> > > May 14 19:21:41 geek500 kernel:  <TASK>
>> =
> >> > > May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>> > >> >=
 > May 14 19:21:41 geek500 kernel: 
>i2c_dw_prepare_clk+0x7c/0xd0
>> > >> >=
 > May 14 19:21:41 geek500 kernel: 
>dw_i2c_plat_suspend+0x2e/0x40
>> > >> =
> > May 14 19:21:41 geek500 kernel:
>> > >acpi_subsys_runtime_suspend+0x9/0=
x20
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_dev_suspend+0x160/=
0x160
>> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x15=
0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_dev_suspend+0x160/0x=
160
>> > >> > > May 14 19:21:41 geek500 kernel: done=2E
>> > >> > > May 14 =
19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> > >> > > May 14 19:21:4=
1 geek500 kernel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21=
:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> > >> > > May 14 19:21:41 ge=
ek500 kernel:  pm_runtime_work+0x8f/0xa0
>> > >> > > May 14 19:21:41 geek50=
0 kernel: 
>process_one_work+0x1d3/0x3a0
>> > >> > > May 14 19:21:41 geek50=
0 kernel:  worker_thread+0x48/0x3c0
>> > >> > > May 14 19:21:41 geek500 ker=
nel:  ?
>rescuer_thread+0x380/0x380
>> > >> > > May 14 19:21:41 geek500 ker=
nel:  kthread+0xd3/0x100
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> =
> >kthread_complete_and_exit+0x20/0x20
>> > >> > > May 14 19:21:41 geek500 =
kernel:  ret_from_fork+0x22/0x30
>> > >> > > May 14 19:21:41 geek500 kernel=
:  </TASK>
>> > >> > > May 14 19:21:41 geek500 kernel: ---[ end trace
>0000=
000000000000
>> > >]---
>> > >> > > May 14 19:21:41 geek500 kernel: -------=
-----[ cut here
>> > >]------------
>> > >> > > May 14 19:21:41 geek500 ker=
nel: AMDI0010:03 already disabled
>> > >> > > May 14 19:21:41 geek500 kerne=
l: WARNING: CPU: 6 PID: 1091 at
>> > >drivers/clk/
>> > >> > > clk=2Ec:971 =
clk_core_disable+0x80/0x1a0
>> > >> > > May 14 19:21:41 geek500 kernel: Mod=
ules linked in: [last
>> > >unloaded:
>> > >> > > acpi_call] May 14 19:21:4=
1 geek500 kernel: CPU: 6 PID: 1091
>Comm:
>> > >> > > kworker/6:3 Tainted: =
G W  O      5=2E17=2E7+ #7
>> > >> > > May 14 19:21:41 geek500 kernel: Hard=
ware name: HP HP
>Pavilion
>> > >Gaming
>> > >> > > Laptop
>> > >> > > 15-e=
c1xxx/87B2, BIOS F=2E25 08/18/2021
>> > >> > > May 14 19:21:41 geek500 kern=
el: Workqueue: pm
>pm_runtime_work
>> > >> > > May 14 19:21:41 geek500 kern=
el: RIP:
>> > >0010:clk_core_disable+0x80/0x1a0
>> > >> > > May 14 19:21:41=
 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f
>1f 44
>> > >00 00 48
>> > >> >=
 > 8b 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7
>c7 7d
>> > =
>87 c4
>> > >> > > ab e8 79 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 =
89
>c0 48
>> > >0f a3 05
>> > >> > > 4a 61 9d 01 May 14 19:21:41 geek500 ke=
rnel: RSP:
>> > >0018:ffff8dbfc1c47d50
>> > >> > > EFLAGS: 00010082 May 14 =
19:21:41 geek500 kernel: RAX:
>> > >0000000000000000
>> > >> > > RBX: ffff8=
885401b6300 RCX: 0000000000000027
>> > >> > > May 14 19:21:41 geek500 kerne=
l: RDX: ffff88885f59f468 RSI:
>> > >> > > 0000000000000001
>> > >> > > RDI:=
 ffff88885f59f460
>> > >> > > May 14 19:21:41 geek500 kernel: RBP: 00000000=
00000287 R08:
>> > >> > > ffffffffabf26da8
>> > >> > > R09: 00000000ffffdff=
f
>> > >> > > May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11:
>>=
 > >> > > ffffffffabe46dc0
>> > >> > > R12: ffff8885401b6300
>> > >> > > Ma=
y 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14:
>> > >> > > 000000=
0000000008
>> > >> > > R15: 0000000000000000
>> > >> > > May 14 19:21:41 ge=
ek500 kernel: FS:  0000000000000000(0000)
>> > >> > > GS:ffff88885f580000(0=
000) knlGS:0000000000000000
>> > >> > > May 14 19:21:41 geek500 kernel: CS:=
  0010 DS: 0000 ES: 0000
>CR0:
>> > >> > > 0000000080050033
>> > >> > > May=
 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3:
>> > >> > > 0000000=
102956000
>> > >> > > CR4: 0000000000350ee0
>> > >> > > May 14 19:21:41 gee=
k500 kernel: Call Trace:
>> > >> > > May 14 19:21:41 geek500 kernel:  <TASK=
>
>> > >> > > May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
>> > >=
> > > May 14 19:21:41 geek500 kernel: 
>i2c_dw_prepare_clk+0x88/0xd0
>> > >=
> > > May 14 19:21:41 geek500 kernel: 
>dw_i2c_plat_suspend+0x2e/0x40
>> > =
>> > > May 14 19:21:41 geek500 kernel:
>> > >acpi_subsys_runtime_suspend+0x=
9/0x20
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_dev_suspend+0x1=
60/0x160
>> > >> > > May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0=
x150
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_dev_suspend+0x160=
/0x160
>> > >> > > May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
=
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>acpi_dev_suspend+0x160/0x16=
0
>> > >> > > May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> >=
 >> > > May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> > >> =
> > May 14 19:21:41 geek500 kernel: 
>process_one_work+0x1d3/0x3a0
>> > >> =
> > May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> > >> > > M=
ay 14 19:21:41 geek500 kernel:  ?
>rescuer_thread+0x380/0x380
>> > >> > > M=
ay 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> > >> > > May 14 19:21=
:41 geek500 kernel:  ?
>> > >kthread_complete_and_exit+0x20/0x20
>> > >> > =
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> > >> > > May =
14 19:21:41 geek500 kernel:  </TASK>
>> > >> > > May 14 19:21:41 geek500 ke=
rnel: ---[ end trace
>0000000000000000
>> > >]---
>> > >> > > May 14 19:21:=
41 geek500 kernel: ------------[ cut here
>> > >]------------
>> > >> > > M=
ay 14 19:21:41 geek500 kernel: AMDI0010:03 already
>unprepared
>> > >> > > =
May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at
>> > >drivers/=
clk/
>> > >> > > clk=2Ec:829 clk_core_unprepare+0xb1/0x1a0
>> > >> > > May =
14 19:21:41 geek500 kernel: Modules linked in: [last
>> > >unloaded:
>> > >=
> > > acpi_call] May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091
>Comm:
>>=
 > >> > > kworker/6:3 Tainted: G W  O      5=2E17=2E7+ #7
>> > >> > > May 1=
4 19:21:41 geek500 kernel: Hardware name: HP HP
>Pavilion
>> > >Gaming
>> >=
 >> > > Laptop
>> > >> > > 15-ec1xxx/87B2, BIOS F=2E25 08/18/2021
>> > >> >=
 > May 14 19:21:41 geek500 kernel: Workqueue: pm
>pm_runtime_work
>> > >> >=
 > May 14 19:21:41 geek500 kernel: RIP:
>> > >0010:clk_core_unprepare+0xb1/=
0x1a0
>> > >> > > May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5=
b
>30 48
>> > >85 db 74
>> > >> > > a2 8b 83 80 00 00 00 85 c0 0f 85 79 ff =
ff ff 48 8b 33 48 c7
>c7 35
>> > >87 c4
>> > >> > > ab e8 18 7c 9a 00 <0f> =
0b 5b c3 65 8b 05 fc a2 92 55 89 c0
>48 0f
>> > >a3 05 ea
>> > >> > > 62 9d=
 01 73 May 14 19:21:41 geek500 kernel: RSP:
>> > >0018:ffff8dbfc1c47d60
>> =
> >> > > EFLAGS: 00010286 May 14 19:21:41 geek500 kernel: RAX:
>> > >000000=
0000000000
>> > >> > > RBX: ffff8885401b6300 RCX: 0000000000000027
>> > >> =
> > May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI:
>> > >> > > =
0000000000000001
>> > >> > > RDI: ffff88885f59f460
>> > >> > > May 14 19:21=
:41 geek500 kernel: RBP: ffff8885401b6300 R08:
>> > >> > > ffffffffabf26da8=

>> > >> > > R09: 00000000ffffdfff
>> > >> > > May 14 19:21:41 geek500 kern=
el: R10: ffffffffabe46dc0 R11:
>> > >> > > ffffffffabe46dc0
>> > >> > > R12=
: 0000000000000000
>> > >> > > May 14 19:21:41 geek500 kernel: R13: ffff888=
540fc30f4 R14:
>> > >> > > 0000000000000008
>> > >> > > R15: 00000000000000=
00
>> > >> > > May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
=
>> > >> > > GS:ffff88885f580000(0000) knlGS:0000000000000000
>> > >> > > Ma=
y 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000
>CR0:
>> > >> > >=
 0000000080050033
>> > >> > > May 14 19:21:41 geek500 kernel: CR2: 00000000=
010fa990 CR3:
>> > >> > > 0000000102956000
>> > >> > > CR4: 0000000000350ee=
0
>> > >> > > May 14 19:21:41 geek500 kernel: Call Trace:
>> > >> > > May 1=
4 19:21:41 geek500 kernel:  <TASK>
>> > >> > > May 14 19:21:41 geek500 kern=
el:  clk_unprepare+0x1f/0x30
>> > >> > > May 14 19:21:41 geek500 kernel: 
>=
i2c_dw_prepare_clk+0x90/0xd0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>=
dw_i2c_plat_suspend+0x2e/0x40
>> > >> > > May 14 19:21:41 geek500 kernel:
>=
> > >acpi_subsys_runtime_suspend+0x9/0x20
>> > >> > > May 14 19:21:41 geek5=
00 kernel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 gee=
k500 kernel:  __rpm_callback+0x3f/0x150
>> > >> > > May 14 19:21:41 geek500=
 kernel:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 geek5=
00 kernel:  rpm_callback+0x54/0x60
>> > >> > > May 14 19:21:41 geek500 kern=
el:  ?
>acpi_dev_suspend+0x160/0x160
>> > >> > > May 14 19:21:41 geek500 ke=
rnel:  rpm_suspend+0x142/0x720
>> > >> > > May 14 19:21:41 geek500 kernel: =
 pm_runtime_work+0x8f/0xa0
>> > >> > > May 14 19:21:41 geek500 kernel: 
>pr=
ocess_one_work+0x1d3/0x3a0
>> > >> > > May 14 19:21:41 geek500 kernel:  wor=
ker_thread+0x48/0x3c0
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>rescu=
er_thread+0x380/0x380
>> > >> > > May 14 19:21:41 geek500 kernel:  kthread+=
0xd3/0x100
>> > >> > > May 14 19:21:41 geek500 kernel:  ?
>> > >kthread_com=
plete_and_exit+0x20/0x20
>> > >> > > May 14 19:21:41 geek500 kernel:  ret_f=
rom_fork+0x22/0x30
>> > >> > > May 14 19:21:41 geek500 kernel:  </TASK>
>> =
> >> > > May 14 19:21:41 geek500 kernel: ---[ end trace
>0000000000000000
>=
> > >]---
>> > >> > > May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi
>h=
daudioC1D0:
>> > >Unable to
>> > >> > > sync register 0x4f0800=2E -5
>> > >=
> > > May 14 19:21:59 geek500 kernel: (elapsed 0=2E175 seconds)
>done=2E
>>=
 > >> > > May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00=2E0: amdgpu:
>>=
 > >Power
>> > >> > > consumption will be higher as BIOS has not been confi=
gured
>for
>> > >> > > suspend-to-idle=2E To use suspend-to-idle change the=
 sleep
>mode in
>> > >BIOS
>> > >> > > setup=2E
>> > >> > > May 14 19:21:59=
 geek500 kernel: snd_hda_intel 0000:01:00=2E1:
>can't
>> > >change
>> > >> =
> > power state from D3cold to D0 (config space inaccessible)
>> > >> > > M=
ay 14 19:21:59 geek500 kernel: pci 0000:00:00=2E2: can't
>derive
>> > >rout=
ing for
>> > >> > > PCI INT A
>> > >> > > May 14 19:21:59 geek500 kernel: p=
ci 0000:00:00=2E2: PCI INT A:
>no
>> > >GSI
>> > >> > > May 14 19:21:59 gee=
k500 kernel: [drm] Fence fallback timer
>> > >expired on ring
>> > >> > > g=
fx May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command
>> > >0xfc20 tx=

>> > >> > > timeout May 14 19:21:59 geek500 kernel: [drm] Fence fallback
>=
> > >timer
>> > >> > > expired on ring sdma0
>> > >> > > May 14 19:21:59 ge=
ek500 kernel: Bluetooth: hci0: RTL:
>download fw
>> > >command
>> > >> > > =
failed (-110)
>> > >> > > May 14 19:21:59 geek500 kernel: done=2E
>> > >> >=
 > May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi
>hdaudioC1D0:
>> > >U=
nable to
>> > >> > > sync register 0x4f0800=2E -5
>> > >> > > May 14 19:22:=
00 geek500 dnsmasq[2079]: no servers found in
>> > >/etc/dnsmasq=2Ed/
>> > =
>> > > dnsmasq-resolv=2Econf, will retry
>> > >> > > May 14 19:22:01 geek50=
0 kernel: [drm] Fence fallback timer
>> > >expired on ring
>> > >> > > sdma=
0
>> > >> > > May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer
>>=
 > >expired on ring
>> > >> > > gfx May 14 19:22:01 geek500 kernel: [drm] F=
ence fallback
>timer
>> > >expired on
>> > >> > > ring sdma0
>> > >> > > Ma=
y 14 19:22:02 geek500 last message buffered 2 times
>> > >> > > May 14 19:2=
2:03 geek500 kernel: [drm] Fence fallback timer
>> > >expired on ring
>> > =
>> > > gfx May 14 19:22:03 geek500 kernel: [drm] Fence fallback
>timer
>> >=
 >expired on
>> > >> > > ring sdma0
>> > >> > > May 14 19:22:03 geek500 ker=
nel: [drm] Fence fallback timer
>> > >expired on ring
>> > >> > > gfx May 1=
4 19:22:03 geek500 kernel: [drm] Fence fallback
>timer
>> > >expired on
>> =
> >> > > ring sdma0
>> > >> > > May 14 19:22:04 geek500 kernel: [drm] Fence=
 fallback timer
>> > >expired on ring
>> > >> > > gfx May 14 19:22:04 geek5=
00 kernel: [drm] Fence fallback
>timer
>> > >expired on
>> > >> > > ring sd=
ma0
>> > >> > > May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer
=
>> > >expired on ring
>> > >> > > gfx May 14 19:22:04 geek500 kernel: [drm]=
 Fence fallback
>timer
>> > >expired on
>> > >> > > ring sdma0
>> > >> > > =
May 14 19:22:05 geek500 last message buffered 2 times
>> > >> > > May 14 19=
:22:05 geek500 kernel: [drm] Fence fallback timer
>> > >expired on ring
>> =
> >> > > gfx May 14 19:22:06 geek500 kernel: [drm] Fence fallback
>timer
>>=
 > >expired on
>> > >> > > ring sdma0
>> > >> > > May 14 19:22:06 geek500 k=
ernel: [drm] Fence fallback timer
>> > >expired on ring
>> > >> > > gfx May=
 14 19:22:06 geek500 last message buffered 1 times
>> > >> > > =2E=2E=2E
>>=
 > >> > > May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer
>> > >=
expired on ring
>> > >> > > sdma0
>> > >> > > May 14 19:22:18 geek500 kerne=
l:
>> > >[drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>> > >> > > Waiting for=
 fences timed out!
>> > >> > > May 14 19:22:18 geek500 kernel: [drm] Fence =
fallback timer
>> > >expired on ring
>> > >> > > sdma0
>> > >> > >
>> > >> =
> > CC
>> > >> > >
>> > >> > > Le samedi 14 mai 2022, 17:12:33 CEST Thorste=
n Leemhuis a
>=C3=A9crit :
>> > >> > > > Hi, this is your Linux kernel regr=
ession tracker=2E Thanks
>for
>> > >the report=2E
>> > >> > > >
>> > >> > >=
 > On 14=2E05=2E22 16:41, Christian Casteyde wrote:
>> > >> > > > > #regzbo=
t introduced v5=2E17=2E3=2E=2Ev5=2E17=2E4
>> > >> > > > > #regzbot introduc=
ed:
>001828fb3084379f3c3e228b905223c50bc237f9
>> > >> > > >
>> > >> > > > F=
WIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA
>> > >function is
=
>> > >> > > > suspended before ASIC reset") upstream=2E
>> > >> > > >
>> > =
>> > > > Recently a regression was reported where 887f75cfd0da was
>> > >su=
spected as
>> > >> > > > the culprit:
>> > >> > > > https://gitlab=2Efreede=
sktop=2Eorg/drm/amd/-/issues/2008
>> > >> > > >
>> > >> > > > And a one rel=
ated to it:
>> > >> > > > https://gitlab=2Efreedesktop=2Eorg/drm/amd/-/issu=
es/1982
>> > >> > > >
>> > >> > > > You might want to take a look if what w=
as discussed there
>might
>> > >be
>> > >> > > > related to your problem (I=
'm not directly involved in any
>of
>> > >this, I
>> > >> > > > don't know =
the details, it's just that 887f75cfd0da looked
>> > >familiar to
>> > >> >=
 > > me)=2E If it is, a fix for these two bugs was committed to
>master
>> =
> >earlier
>> > >> > > > this week:
>> > >> > > >
>> > >> > > >
>> >
>>http=
s://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/torvalds/linux=2Egit/commi
=
>> > >> > > > t/?i d=3Da56f445f807b0276
>> > >> > > >
>> > >> > > > It will=
 likely be backported to 5=2E17=2Ey, maybe already in
>the
>> > >over-next
=
>> > >> > > > release=2E HTH=2E
>> > >> > > >
>> > >> > > > Ciao, Thorsten =
(wearing his 'the Linux kernel's regression
>> > >tracker' hat)
>> > >> > >=
 >
>> > >> > > > P=2ES=2E: As the Linux kernel's regression tracker I deal =
with
>a
>> > >lot of
>> > >> > > > reports and sometimes miss something imp=
ortant when
>writing
>> > >mails like
>> > >> > > > this=2E If that's the c=
ase here, don't hesitate to tell me
>in a
>> > >public
>> > >> > > > reply,=
 it's in everyone's interest to set the public
>record
>> > >straight=2E
>>=
 > >> > > >
>> > >> > > > > Hello
>> > >> > > > > Since 5=2E17=2E4 my lapto=
p doesn't resume from suspend
>anymore=2E
>> > >At resume,
>> > >> > > > > =
symptoms are variable:
>> > >> > > > > - either the laptop freezes;
>> > >>=
 > > > > - either the screen keeps blank;
>> > >> > > > > - either the scre=
en is OK but mouse is frozen;
>> > >> > > > > - either display lags with se=
veral logs in dmesg:
>> > >> > > > > [  228=2E275492] [drm] Fence fallback =
timer expired on
>ring gfx
>> > >> > > > > [  228=2E395466] [drm:amdgpu_dm_=
atomic_commit_tail]
>*ERROR*
>> > >Waiting for
>> > >> > > > > fences timed=
 out!
>> > >> > > > > [  228=2E779490] [drm] Fence fallback timer expired o=
n
>ring gfx
>> > >> > > > > [  229=2E283484] [drm] Fence fallback timer exp=
ired on
>ring
>> > >sdma0
>> > >> > > > > [  229=2E283485] [drm] Fence fall=
back timer expired on
>ring gfx
>> > >> > > > > [  229=2E787487] [drm] Fenc=
e fallback timer expired on
>ring gfx
>> > >> > > > > =2E=2E=2E
>> > >> > >=
 > >
>> > >> > > > > I've bisected the problem=2E
>> > >> > > > >
>> > >> >=
 > > > Please note this laptop has a strange behaviour on
>suspend:
>> > >>=
 > > > > The first suspend request always fails (this point has
>never
>> >=
 >been
>> > >> > > > > fixed
>> > >> > > > > and
>> > >> > > > > plagues us=
 when trying to diagnose another regression on
>> > >touchpad not
>> > >> >=
 > > > resuming in the past)=2E The screen goes blank and I can
>get it
>> =
> >OK when
>> > >> > > > > pressing the power button, this seems to reset i=
t=2E After
>that
>> > >all
>> > >> > > > > suspend/resume works OK=2E
>> > =
>> > > > >
>> > >> > > > > Since 5=2E17=2E4, it is not possible anymore to =
get the
>laptop
>> > >working
>> > >> > > > > again
>> > >> > > > > after t=
he first suspend failure=2E
>> > >> > > > >
>> > >> > > > > HW : HP Pavilio=
n / Ryzen 4600H with AMD graphics
>integrated +
>> > >NVidia
>> > >> > > > =
> 1650Ti
>> > >> > > > > (turned off with ACPI call in order to get more ba=
ttery,
>I'm
>> > >not using
>> > >> > > > > NVidia driver)=2E
>> > >>
>> >

