Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FE027CEB8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 15:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgI2NNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 09:13:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34006 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgI2NN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 09:13:26 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1kNFRY-0004z8-RV; Tue, 29 Sep 2020 13:13:20 +0000
Subject: Re: [PATCH 4.4 50/62] XEN uses irqdesc::irq_data_common::handler_data
 to store a per interrupt XEN data pointer which contains XEN specific
 information.
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Roman Shaposhnik <roman@zededa.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
References: <20200901150920.697676718@linuxfoundation.org>
 <20200901150923.247002384@linuxfoundation.org>
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
Message-ID: <e958ff30-b7a9-9bd1-b483-542b6d117cc5@canonical.com>
Date:   Tue, 29 Sep 2020 15:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901150923.247002384@linuxfoundation.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="EaQfBhALU5eiihRQL8lwWXuWhT5C7Uww8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EaQfBhALU5eiihRQL8lwWXuWhT5C7Uww8
Content-Type: multipart/mixed; boundary="MTRHGu7wJ6vOL5Sik8bdAe5dJQbbAdFby"

--MTRHGu7wJ6vOL5Sik8bdAe5dJQbbAdFby
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01.09.20 17:10, Greg Kroah-Hartman wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>=20
> commit c330fb1ddc0a922f044989492b7fcca77ee1db46 upstream.
>=20
> handler data is meant for interrupt handlers and not for storing irq ch=
ip
> specific information as some devices require handler data to store inte=
rnal
> per interrupt information, e.g. pinctrl/GPIO chained interrupt handlers=
=2E
>=20
> This obviously creates a conflict of interests and crashes the machine
> because the XEN pointer is overwritten by the driver pointer.

I cannot say whether this applies the same for the vanilla 4.4 stable ker=
nels
but once this had been applied to our 4.4 based kernels, we observed Xen =
HVM
guests crashing on boot with:

[    0.927538] ACPI: bus type PCI registered
[    0.936008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.948739] PCI: Using configuration type 1 for base access
[    0.960007] PCI: Using configuration type 1 for extended access
[    0.984340] ACPI: Added _OSI(Module Device)
[    0.988010] ACPI: Added _OSI(Processor Device)
[    0.992007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.996013] ACPI: Added _OSI(Processor Aggregator Device)
[    1.002103] BUG: unable to handle kernel paging request at ffffffffff5=
f3000
[    1.004000] IP: [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
[    1.004000] PGD 1e0f067 PUD 1e11067 PMD 1e12067 PTE 0
[    1.004000] Oops: 0002 [#1] SMP
[    1.004000] Modules linked in:
[    1.004000] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 4.4.0-191-generi=
c
#221-Ubuntu
[    1.004000] Hardware name: Xen HVM domU, BIOS 4.6.5 04/18/2018
[    1.004000] task: ffff880107db0000 ti: ffff880107dac000 task.ti: ffff8=
80107dac000
[    1.004000] RIP: 0010:[<ffffffff810592ff>]  [<ffffffff810592ff>]
mp_irqdomain_activate+0x5f/0xa0
[    1.004000] RSP: 0018:ffff880107dafc48  EFLAGS: 00010086
[    1.004000] RAX: 0000000000000086 RBX: ffff8800eb852140 RCX: 000000000=
0000000
[    1.004000] RDX: ffffffffff5f3000 RSI: 0000000000000001 RDI: 000000000=
020c000
[    1.004000] RBP: ffff880107dafc50 R08: ffffffff81ebdfd0 R09: 00000000f=
fffffff
[    1.004000] R10: 0000000000000011 R11: 0000000000000009 R12: ffff88010=
880d400
[    1.004000] R13: 0000000000000001 R14: 0000000000000009 R15: ffff8800e=
b880080
[    1.004000] FS:  0000000000000000(0000) GS:ffff880108ec0000(0000)
knlGS:0000000000000000
[    1.004000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.004000] CR2: ffffffffff5f3000 CR3: 0000000001e0a000 CR4: 000000000=
00006f0
[    1.004000] Stack:
[    1.004000]  ffff88010880bc58 ffff880107dafc70 ffffffff810ea644 ffff88=
010880bc00
[    1.004000]  ffff88010880bc58 ffff880107dafca0 ffffffff810e6d88 ffffff=
ff810e1009
[    1.004000]  ffff88010880bc00 ffff88010880bca0 ffff8800eb880080 ffff88=
0107dafd38
[    1.004000] Call Trace:
[    1.004000]  [<ffffffff810ea644>] irq_domain_activate_irq+0x44/0x50
[    1.004000]  [<ffffffff810e6d88>] irq_startup+0x38/0x90
[    1.004000]  [<ffffffff810e1009>] ? vprintk_default+0x29/0x40
[    1.004000]  [<ffffffff810e55e2>] __setup_irq+0x5a2/0x650
[    1.004000]  [<ffffffff811fc064>] ? kmem_cache_alloc_trace+0x1d4/0x1f0=

[    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
[    1.004000]  [<ffffffff810e582b>] request_threaded_irq+0xfb/0x1a0
[    1.004000]  [<ffffffff814a3870>] ? acpi_osi_handler+0xb0/0xb0
[    1.004000]  [<ffffffff814bf624>] ? acpi_ev_sci_dispatch+0x64/0x64
[    1.004000]  [<ffffffff814a3f0a>] acpi_os_install_interrupt_handler+0x=
aa/0x100
[    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
[    1.004000]  [<ffffffff814bf689>] acpi_ev_install_sci_handler+0x23/0x2=
5
[    1.004000]  [<ffffffff814bcf03>] acpi_ev_install_xrupt_handlers+0x1c/=
0x6c
[    1.004000]  [<ffffffff81fb3e9d>] acpi_enable_subsystem+0x8f/0x93
[    1.004000]  [<ffffffff81fb276c>] acpi_init+0x8b/0x2c4
[    1.004000]  [<ffffffff8141ee1e>] ? kasprintf+0x4e/0x70
[    1.004000]  [<ffffffff81fb26e1>] ? acpi_sleep_proc_init+0x28/0x28
[    1.004000]  [<ffffffff810021f5>] do_one_initcall+0xb5/0x200
[    1.004000]  [<ffffffff810a6fda>] ? parse_args+0x29a/0x4a0
[    1.004000]  [<ffffffff81f69152>] kernel_init_freeable+0x177/0x218
[    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
[    1.004000]  [<ffffffff8185dcfe>] kernel_init+0xe/0xe0
[    1.004000]  [<ffffffff8186ae92>] ret_from_fork+0x42/0x80
[    1.004000]  [<ffffffff8185dcf0>] ? rest_init+0x80/0x80
[    1.004000] Code: 8d 1c d2 8d ba 0b 02 00 00 44 8d 51 11 42 8b 14 dd 7=
4 ec 10
82 c1 e7 0c 48 63 ff 81 e2 ff 0f 00 00 48 81 ea 00 10 80 00 48 29 fa <44>=
 89 12
89 72 10 42 8b 14 dd 74 ec 10 82 83 c1 10 81 e2 ff 0f
[    1.004000] RIP  [<ffffffff810592ff>] mp_irqdomain_activate+0x5f/0xa0
[    1.004000]  RSP <ffff880107dafc48>
[    1.004000] CR2: ffffffffff5f3000
[    1.004000] ---[ end trace 3201cae5b6bd7be1 ]---
[    1.592027] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x00000009
[    1.592027]

This is from a local server but same stack-trace happens on AWS instances=
 while
initializing ACPI SCI. mp_irqdomain_activate is accessing chip_data expec=
ting
ioapic data there. Oddly enough more recent kernels seem to do the same b=
ut not
crashing as HVM guest (neither seen for our 4.15 nor the 5.4).

Maybe someone could make sure the 4.4.y stable series is not also broken.=


-Stefan
>=20
> As the XEN data is not handler specific it should be stored in
> irqdesc::irq_data::chip_data instead.
>=20
> A simple sed s/irq_[sg]et_handler_data/irq_[sg]et_chip_data/ cures that=
=2E
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Roman Shaposhnik <roman@zededa.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Roman Shaposhnik <roman@zededa.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Link: https://lore.kernel.org/r/87lfi2yckt.fsf@nanos.tec.linutronix.de
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/xen/events/events_base.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -155,7 +155,7 @@ int get_evtchn_to_irq(unsigned evtchn)
>  /* Get info for IRQ */
>  struct irq_info *info_for_irq(unsigned irq)
>  {
> -	return irq_get_handler_data(irq);
> +	return irq_get_chip_data(irq);
>  }
> =20
>  /* Constructors for packed IRQ information. */
> @@ -384,7 +384,7 @@ static void xen_irq_init(unsigned irq)
>  	info->type =3D IRQT_UNBOUND;
>  	info->refcnt =3D -1;
> =20
> -	irq_set_handler_data(irq, info);
> +	irq_set_chip_data(irq, info);
> =20
>  	list_add_tail(&info->list, &xen_irq_list_head);
>  }
> @@ -433,14 +433,14 @@ static int __must_check xen_allocate_irq
> =20
>  static void xen_free_irq(unsigned irq)
>  {
> -	struct irq_info *info =3D irq_get_handler_data(irq);
> +	struct irq_info *info =3D irq_get_chip_data(irq);
> =20
>  	if (WARN_ON(!info))
>  		return;
> =20
>  	list_del(&info->list);
> =20
> -	irq_set_handler_data(irq, NULL);
> +	irq_set_chip_data(irq, NULL);
> =20
>  	WARN_ON(info->refcnt > 0);
> =20
> @@ -610,7 +610,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
>  static void __unbind_from_irq(unsigned int irq)
>  {
>  	int evtchn =3D evtchn_from_irq(irq);
> -	struct irq_info *info =3D irq_get_handler_data(irq);
> +	struct irq_info *info =3D irq_get_chip_data(irq);
> =20
>  	if (info->refcnt > 0) {
>  		info->refcnt--;
> @@ -1114,7 +1114,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
> =20
>  void unbind_from_irqhandler(unsigned int irq, void *dev_id)
>  {
> -	struct irq_info *info =3D irq_get_handler_data(irq);
> +	struct irq_info *info =3D irq_get_chip_data(irq);
> =20
>  	if (WARN_ON(!info))
>  		return;
> @@ -1148,7 +1148,7 @@ int evtchn_make_refcounted(unsigned int
>  	if (irq =3D=3D -1)
>  		return -ENOENT;
> =20
> -	info =3D irq_get_handler_data(irq);
> +	info =3D irq_get_chip_data(irq);
> =20
>  	if (!info)
>  		return -ENOENT;
> @@ -1176,7 +1176,7 @@ int evtchn_get(unsigned int evtchn)
>  	if (irq =3D=3D -1)
>  		goto done;
> =20
> -	info =3D irq_get_handler_data(irq);
> +	info =3D irq_get_chip_data(irq);
> =20
>  	if (!info)
>  		goto done;
>=20
>=20



--MTRHGu7wJ6vOL5Sik8bdAe5dJQbbAdFby--

--EaQfBhALU5eiihRQL8lwWXuWhT5C7Uww8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAl9zMukACgkQ6Gdd7svu
zqMHSA//UwqSxFlKUUMe4KMTOq08LV+HDOS63+XFPVC0o3H+KLHdxdVWghAXu/dk
oQjx5C9/zcxkAf8euYTwPYrFCmUYFQwZqtazThuLd0BC8hcxgTusgOd/R/dFs76+
Qy8nl7QW3zLzsQa0lZSLSXtZ9HB8hvzGNtMpfpWz4Uzqtmxqqv5+mLJrpS09BMhG
5YLAE54K3KhfLEKmPHA1JppVy7iCyY9sMSfgPCTx1bSn/cwIKv/pHmkHNpQQTMmQ
tmb/8lrYk1f1PLdLNFTZDOut4i7ViBMe96mVCgjJAFQOwTrrYZvuhEHmzMksBAgQ
uNjyk0eZe0Uz3q77sW7MxUVdvPcb1tWsRbkh6SBHAKnCTcQgDsBR4tUF4kg2hC+o
pd6mHYNItYNEcmuJ93xIYMxgofQHauXg9vD7rhQyfsPiRU9+ZMrWsWbF2/P5To0z
sAtYjDX4OOQ/LU5GbXVL8s3i8AnOsKTP1b99l8/hZSVSmYErU5d8OanmfR1sXa9m
FuFEEY1AqXEjuDGIcU2ZpsKiivFZLF1qQJLD6Ff0utd7Fx9uRJUdJHrqP4qjWfzW
e73GnlaakrdLAFiiS3wEFUPpefKRhkKS/IM4ATLBrvKS1x3axX6AMdGygeFVqS1p
EtPJYdCXa3jpJ/YWtFjD7HX0csACVFx4MHL42FX1jH025WuLg0I=
=L1gn
-----END PGP SIGNATURE-----

--EaQfBhALU5eiihRQL8lwWXuWhT5C7Uww8--
