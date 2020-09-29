Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5927D0F5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgI2OVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:21:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35894 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgI2OVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 10:21:49 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1kNGVk-0001b1-3A; Tue, 29 Sep 2020 14:21:44 +0000
Subject: Re: [PATCH 4.4 50/62] XEN uses irqdesc::irq_data_common::handler_data
 to store a per interrupt XEN data pointer which contains XEN specific
 information.
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Roman Shaposhnik <roman@zededa.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200901150920.697676718@linuxfoundation.org>
 <20200901150923.247002384@linuxfoundation.org>
 <e958ff30-b7a9-9bd1-b483-542b6d117cc5@canonical.com>
 <15f140ef-cfd3-c3b7-9b8c-2a7ba3fab56a@suse.com>
From:   Stefan Bader <stefan.bader@canonical.com>
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 mQINBE5mmXEBEADoM0yd6ERIuH2sQjbCGtrt0SFCbpAuOgNy7LSDJw2vZHkZ1bLPtpojdQId
 258o/4V+qLWaWLjbQdadzodnVUsvb+LUKJhFRB1kmzVYNxiu7AtxOnNmUn9dl1oS90IACo1B
 BpaMIunnKu1pp7s3sfzWapsNMwHbYVHXyJeaPFtMqOxd1V7bNEAC9uNjqJ3IG15f5/50+N+w
 LGkd5QJmp6Hs9RgCXQMDn989+qFnJga390C9JPWYye0sLjQeZTuUgdhebP0nvciOlKwaOC8v
 K3UwEIbjt+eL18kBq4VBgrqQiMupmTP9oQNYEgk2FiW3iAQ9BXE8VGiglUOF8KIe/2okVjdO
 nl3VgOHumV+emrE8XFOB2pgVmoklYNvOjaIV7UBesO5/16jbhGVDXskpZkrP/Ip+n9XD/EJM
 ismF8UcvcL4aPwZf9J03fZT4HARXuig/GXdK7nMgCRChKwsAARjw5f8lUx5iR1wZwSa7HhHP
 rAclUzjFNK2819/Ke5kM1UuT1X9aqL+uLYQEDB3QfJmdzVv5vHON3O7GOfaxBICo4Z5OdXSQ
 SRetiJ8YeUhKpWSqP59PSsbJg+nCKvWfkl/XUu5cFO4V/+NfivTttnoFwNhi/4lrBKZDhGVm
 6Oo/VytPpGHXt29npHb8x0NsQOsfZeam9Z5ysmePwH/53Np8NQARAQABtDVTdGVmYW4gQmFk
 ZXIgKENhbm9uaWNhbCkgPHN0ZWZhbi5iYWRlckBjYW5vbmljYWwuY29tPokCVwQTAQoAQQIb
 AwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAIZARYhBNtdfMrzmU4zldpNPuhnXe7L7s6jBQJd
 7mXwBQkRwqX/AAoJEOhnXe7L7s6jwpgQALEz54XvgIhYi8qCwqkopEZXq2fYttMFMEMkW3dA
 7Y/m5fnmPs/QYsfpn7LtQcmDGBz4W9YDL/KD+1YF1W1+vzo8NQTeR02DJksaTx2riyzI+zS9
 YY/c0EvyauOWa8s9YvI9lzN+gWgOKyEK415nybXjU5FEMAF6jAjJ70T+DPeZjGBgkoDPKBRK
 O3DBgOV23rrAiMx9UXqAbcSUU4i1me6PTZaAbSeIiOPOdJfPgJP8ki3QuGF3ct23dLLlPame
 cCCgH4ZBMGb8ZQLhRfLNYao0dbDXcqQ+OSFl2pGToiC19MJj1im1Ca8Dc97JRuzkxOFKRfXA
 9rYsVy7AV//pfVy3x5tT0fJQtz4UFU4Qzhi/08U2wgl9tsJxP2LCtcoXa7D+3ehe92cQNsrQ
 Xo6XKNzvOFoXzDBzoVU9SYTv12Y97zECJG11F+QmDiogudy+ioq+R9aKgMUIugnCh45LuZuR
 yj9quASYn5vf/YywML5vSVKNQ1+0jcO/vkwja4bMU0intA0se8ujjVMV/XXJb80PtghZVVL/
 +xqnApGilIda5+QEbjdPO8XjNlFO8cIhez81+8m68ybnq5svfee/PJOEZ6jlxG5XIyb3B/ky
 gZY6kimPLeLcjxK4FVH5teiSB0IfpEMnQNLrjDzXWgmA/Bk7VNycPYOKvZnYuBNgA7wEuQIN
 BE5mmXEBEADCkRfuS1cAx02yTsk9gyAapcQnpb6EBay40Ch/IPrMF2iG4F0CX6puKubjjVbq
 L6jEKyksqPb57Vu9WAufy4Rlv3OwzaymmWk00CROCVSuEV+3bikBTnF/l+VVCvccNlpHsADM
 LncaATvSOj1iCXeikxNAk2LA3g9H8uz7lQUhjni05ixBZGDGbaxB6Odmh58q8k/iooREHyqf
 leSg1zpuBxYGKVug2daXLSvQI7w59eYO/L1YpLtu1sMzqRyYdSUyCiNcXDO/Ko221o2NfdqQ
 9KET1az8QTsBnZeTsjsk4VnYwjc9ZEYN7LATWrhz8vgI2eP80lXxXm9kx81NubnOPxna5vg9
 DhxZEjo8A+zE4c5bQuSCJ3GTnOalXsAz0Lwk1H1nFwizUqvmPI8eAqZGeZoJ409uDcNi2BrR
 +W7MjXxPM5k4M2zMiNfIvNBjclBLE/m7nrcxNLOk1z/KQiFVZQhtHXoOTUWmINZ+E3GIJT2D
 ToFxUoaEW2GdX0rjqEerbUaoo6SBX7HxmjAzseND9IatGTxgN+EhJUiIWK4UOH343erB7Hga
 98WeEzZTq7W2NvwnqOVAq2ElnPhHrD98nWIBZPOEu6xgiyvVFfXJGmRBMRBR+8hBjfX0643n
 Lq3wYOrZbNfP8dJVQZ4GxI6OLTcwYNgifqp/SIJzE1tgkwARAQABiQI8BBgBCgAmAhsMFiEE
 2118yvOZTjOV2k0+6Gdd7svuzqMFAl3uZkUFCRGHUtQACgkQ6Gdd7svuzqMZ8A/+OOxzg8PT
 7B9o/YvbBuKfnc3WK2xFpYPsiqlRk+7NnV1BXOMpCe9jrKGy1erJg0WBD7BXg7mbQj6KH58o
 MslCZCkb4N1igwD2JiJo/Lf98DFdw6hUR8Ja/DOVhjpNjfbhF5EIIzkkV8K/pIrkRPOL6uld
 i2IPowtMky2yoIJ1cQdtREEUL/WcpRoLrW6ZqITx4RxL2nnUSp0kpr3sdsYmUoGKWAfBSO/W
 TCsypW4Ymd4tWST4NVFYOW2/pkROX8saRdznaCRFnn8QeTSb2WgDmXLLjGKancYmZPNRcdr9
 OsFcWN2R3ljo6+frW58GoR1To4E7Jr2MucDK8wmvkf08NlnhqOzfaRvgdLLK5l5tv6LZOGCH
 17imKDu6cH0qf0EVCCd3Oq8SIosKzcvYJRqwc6CJGJSaz9CNUHCnDUzMZq1Pi+C4FuK2i2jz
 X+xJRAvEX6xZ0BhfuKnum7KtZmBYACeL4V27Bes6r2YGEf4ZQq9kyNVZ6r+pmcyRS495Y+8r
 Vgixzb39xyLAzwOFCBpCcsT6MsdsqIx9ir+Dx3aVpU9kxzFLXmj1JnlqCvDx4g8q1kEU9ffD
 6bmoRYuE45/feIEQGr1QueKac1rpRHhfohCTZNG2Jx1c6VwZCYvBKkOJMWpQwRtyEcShcX1j
 quuXTQgSgLXYhq37J+O42GU0Amw=
Message-ID: <ecd4a4a2-7cc7-3052-6041-af914d6b1b34@canonical.com>
Date:   Tue, 29 Sep 2020 16:21:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <15f140ef-cfd3-c3b7-9b8c-2a7ba3fab56a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="wSoU5vJd7tgjC885CVaFG2ryzJ4paUtsJ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wSoU5vJd7tgjC885CVaFG2ryzJ4paUtsJ
Content-Type: multipart/mixed; boundary="xUe7e2U6nLHfYA7Ze6EVIn7Fi9arSSgF6"

--xUe7e2U6nLHfYA7Ze6EVIn7Fi9arSSgF6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29.09.20 16:05, J=C3=BCrgen Gro=C3=9F wrote:
> On 29.09.20 15:13, Stefan Bader wrote:
>> On 01.09.20 17:10, Greg Kroah-Hartman wrote:
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>
>>> commit c330fb1ddc0a922f044989492b7fcca77ee1db46 upstream.
>>>
>>> handler data is meant for interrupt handlers and not for storing irq =
chip
>>> specific information as some devices require handler data to store in=
ternal
>>> per interrupt information, e.g. pinctrl/GPIO chained interrupt handle=
rs.
>>>
>>> This obviously creates a conflict of interests and crashes the machin=
e
>>> because the XEN pointer is overwritten by the driver pointer.
>>
>> I cannot say whether this applies the same for the vanilla 4.4 stable =
kernels
>> but once this had been applied to our 4.4 based kernels, we observed X=
en HVM
>> guests crashing on boot with:
>>
>> [=C2=A0=C2=A0=C2=A0 0.927538] ACPI: bus type PCI registered
>> [=C2=A0=C2=A0=C2=A0 0.936008] acpiphp: ACPI Hot Plug PCI Controller Dr=
iver version: 0.5
>> [=C2=A0=C2=A0=C2=A0 0.948739] PCI: Using configuration type 1 for base=
 access
>> [=C2=A0=C2=A0=C2=A0 0.960007] PCI: Using configuration type 1 for exte=
nded access
>> [=C2=A0=C2=A0=C2=A0 0.984340] ACPI: Added _OSI(Module Device)
>> [=C2=A0=C2=A0=C2=A0 0.988010] ACPI: Added _OSI(Processor Device)
>> [=C2=A0=C2=A0=C2=A0 0.992007] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [=C2=A0=C2=A0=C2=A0 0.996013] ACPI: Added _OSI(Processor Aggregator De=
vice)
>> [=C2=A0=C2=A0=C2=A0 1.002103] BUG: unable to handle kernel paging requ=
est at ffffffffff5f3000
>> [=C2=A0=C2=A0=C2=A0 1.004000] IP: [<ffffffff810592ff>] mp_irqdomain_ac=
tivate+0x5f/0xa0
>> [=C2=A0=C2=A0=C2=A0 1.004000] PGD 1e0f067 PUD 1e11067 PMD 1e12067 PTE =
0
>> [=C2=A0=C2=A0=C2=A0 1.004000] Oops: 0002 [#1] SMP
>> [=C2=A0=C2=A0=C2=A0 1.004000] Modules linked in:
>> [=C2=A0=C2=A0=C2=A0 1.004000] CPU: 3 PID: 1 Comm: swapper/0 Not tainte=
d 4.4.0-191-generic
>> #221-Ubuntu
>> [=C2=A0=C2=A0=C2=A0 1.004000] Hardware name: Xen HVM domU, BIOS 4.6.5 =
04/18/2018
>> [=C2=A0=C2=A0=C2=A0 1.004000] task: ffff880107db0000 ti: ffff880107dac=
000 task.ti:
>> ffff880107dac000
>> [=C2=A0=C2=A0=C2=A0 1.004000] RIP: 0010:[<ffffffff810592ff>]=C2=A0 [<f=
fffffff810592ff>]
>> mp_irqdomain_activate+0x5f/0xa0
>> [=C2=A0=C2=A0=C2=A0 1.004000] RSP: 0018:ffff880107dafc48=C2=A0 EFLAGS:=
 00010086
>> [=C2=A0=C2=A0=C2=A0 1.004000] RAX: 0000000000000086 RBX: ffff8800eb852=
140 RCX: 0000000000000000
>> [=C2=A0=C2=A0=C2=A0 1.004000] RDX: ffffffffff5f3000 RSI: 0000000000000=
001 RDI: 000000000020c000
>> [=C2=A0=C2=A0=C2=A0 1.004000] RBP: ffff880107dafc50 R08: ffffffff81ebd=
fd0 R09: 00000000ffffffff
>> [=C2=A0=C2=A0=C2=A0 1.004000] R10: 0000000000000011 R11: 0000000000000=
009 R12: ffff88010880d400
>> [=C2=A0=C2=A0=C2=A0 1.004000] R13: 0000000000000001 R14: 0000000000000=
009 R15: ffff8800eb880080
>> [=C2=A0=C2=A0=C2=A0 1.004000] FS:=C2=A0 0000000000000000(0000) GS:ffff=
880108ec0000(0000)
>> knlGS:0000000000000000
>> [=C2=A0=C2=A0=C2=A0 1.004000] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00=
00000080050033
>> [=C2=A0=C2=A0=C2=A0 1.004000] CR2: ffffffffff5f3000 CR3: 0000000001e0a=
000 CR4: 00000000000006f0
>> [=C2=A0=C2=A0=C2=A0 1.004000] Stack:
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 ffff88010880bc58 ffff880107dafc70 =
ffffffff810ea644
>> ffff88010880bc00
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 ffff88010880bc58 ffff880107dafca0 =
ffffffff810e6d88
>> ffffffff810e1009
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 ffff88010880bc00 ffff88010880bca0 =
ffff8800eb880080
>> ffff880107dafd38
>> [=C2=A0=C2=A0=C2=A0 1.004000] Call Trace:
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810ea644>] irq_domain_ac=
tivate_irq+0x44/0x50
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810e6d88>] irq_startup+0=
x38/0x90
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810e1009>] ? vprintk_def=
ault+0x29/0x40
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810e55e2>] __setup_irq+0=
x5a2/0x650
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff811fc064>] ? kmem_cache_=
alloc_trace+0x1d4/0x1f0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814a3870>] ? acpi_osi_ha=
ndler+0xb0/0xb0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810e582b>] request_threa=
ded_irq+0xfb/0x1a0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814a3870>] ? acpi_osi_ha=
ndler+0xb0/0xb0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814bf624>] ? acpi_ev_sci=
_dispatch+0x64/0x64
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814a3f0a>] acpi_os_insta=
ll_interrupt_handler+0xaa/0x100
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff81fb26e1>] ? acpi_sleep_=
proc_init+0x28/0x28
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814bf689>] acpi_ev_insta=
ll_sci_handler+0x23/0x25
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff814bcf03>] acpi_ev_insta=
ll_xrupt_handlers+0x1c/0x6c
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff81fb3e9d>] acpi_enable_s=
ubsystem+0x8f/0x93
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff81fb276c>] acpi_init+0x8=
b/0x2c4
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff8141ee1e>] ? kasprintf+0=
x4e/0x70
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff81fb26e1>] ? acpi_sleep_=
proc_init+0x28/0x28
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810021f5>] do_one_initca=
ll+0xb5/0x200
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff810a6fda>] ? parse_args+=
0x29a/0x4a0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff81f69152>] kernel_init_f=
reeable+0x177/0x218
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff8185dcf0>] ? rest_init+0=
x80/0x80
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff8185dcfe>] kernel_init+0=
xe/0xe0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff8186ae92>] ret_from_fork=
+0x42/0x80
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 [<ffffffff8185dcf0>] ? rest_init+0=
x80/0x80
>> [=C2=A0=C2=A0=C2=A0 1.004000] Code: 8d 1c d2 8d ba 0b 02 00 00 44 8d 5=
1 11 42 8b 14 dd 74 ec 10
>> 82 c1 e7 0c 48 63 ff 81 e2 ff 0f 00 00 48 81 ea 00 10 80 00 48 29 fa <=
44> 89 12
>> 89 72 10 42 8b 14 dd 74 ec 10 82 83 c1 10 81 e2 ff 0f
>> [=C2=A0=C2=A0=C2=A0 1.004000] RIP=C2=A0 [<ffffffff810592ff>] mp_irqdom=
ain_activate+0x5f/0xa0
>> [=C2=A0=C2=A0=C2=A0 1.004000]=C2=A0 RSP <ffff880107dafc48>
>> [=C2=A0=C2=A0=C2=A0 1.004000] CR2: ffffffffff5f3000
>> [=C2=A0=C2=A0=C2=A0 1.004000] ---[ end trace 3201cae5b6bd7be1 ]---
>> [=C2=A0=C2=A0=C2=A0 1.592027] Kernel panic - not syncing: Attempted to=
 kill init!
>> exitcode=3D0x00000009
>> [=C2=A0=C2=A0=C2=A0 1.592027]
>>
>> This is from a local server but same stack-trace happens on AWS instan=
ces while
>> initializing ACPI SCI. mp_irqdomain_activate is accessing chip_data ex=
pecting
>> ioapic data there. Oddly enough more recent kernels seem to do the sam=
e but not
>> crashing as HVM guest (neither seen for our 4.15 nor the 5.4).
>=20
> Hmm, could it be that calling irq_set_chip_data() for a legacy irq is
> a rather bad idea?
>=20
> Could you please try the attached patch (might need some backport, but
> should be rather easy)?

Will give it a try once I got some time to squeeze it in. Might take till=

tomorow or the day after...

-Stefan

>=20
>=20
> Juergen



--xUe7e2U6nLHfYA7Ze6EVIn7Fi9arSSgF6--

--wSoU5vJd7tgjC885CVaFG2ryzJ4paUtsJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAl9zQvcACgkQ6Gdd7svu
zqPD+RAAiFruDXwEtLemnmS2sggz6uzxNVIBvsU3Vzm6XBuVIoKH1bZ3l+zBAqHx
gi/23KQQB7qChMfDEWfaqdZs6foKuV036VQIf3WWJXsN8kTCj7tmdTtErnWvzxz9
/zGiz6NH96q81V/I4k8FMpLUGhJ8OcS0cpevyS2KM2BKEUnYM2sh5dN7BYVfhkg1
ucWMbMhX6C1S15XCS0SWQ27v0stLuy2e8J0MReyNQNI09nGc8nnllZE8Nxww14K5
CFgZiyweRATPOIkTwptTGZJDjlAFKg5vFjsaNx5aMXe2jANgKDxFt+9WCQbpJyIi
XCBjgBwNPjz0t1SMG8zEg515NfLabyGRYicJN6U1EEW5W/KqhaSMWjq8/C0/Iids
CcMCQANOwLcQQy4vGy5trmXwXzBZuqQ5raq/tMGN2oFSkqg8TOqYHxUZ5w6Ambj9
jyoZudsUg1ZzVtlm3+hXiNjP4h9EB6hQJWmgRmj8udQcO5csRKJP8bzJksu8k7x+
v3BGIs2lo25V6geySIXxabjvGTAb1UnZwFKP0FZ3K1KcBMQOLYF+GKqfgFqS6uvw
LbjwJEQlo46O8HXGct8Zs4uKSuoC+MsrWdtZ8uaUHlMNzY7+NYzUs1HIDLiX5TmK
z+Zi5K+PzZeSN/tpNJx96wLvMlzzr4TPr0W4GJWDmU+wM9JfEPA=
=0YAa
-----END PGP SIGNATURE-----

--wSoU5vJd7tgjC885CVaFG2ryzJ4paUtsJ--
