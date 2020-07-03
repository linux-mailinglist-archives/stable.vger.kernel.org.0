Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA76214191
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 00:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGCWcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 18:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgGCWcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 18:32:01 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C6C061794;
        Fri,  3 Jul 2020 15:32:00 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 49z8pR188xzQl8k;
        Sat,  4 Jul 2020 00:31:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id rvw_BKUfTw5q; Sat,  4 Jul 2020 00:31:55 +0200 (CEST)
Subject: Re: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
To:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200702225334.32414-1-hauke@hauke-m.de>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <b9aa9a88-2e87-5317-f828-fc27d9f2221e@hauke-m.de>
Date:   Sat, 4 Jul 2020 00:31:41 +0200
MIME-Version: 1.0
In-Reply-To: <20200702225334.32414-1-hauke@hauke-m.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ZH27rMtRo0Y59QdW5LrpFb5H9kKdQWAwq"
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -7.85 / 15.00 / 15.00
X-Rspamd-Queue-Id: EF30B1761
X-Rspamd-UID: b7bf6a
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZH27rMtRo0Y59QdW5LrpFb5H9kKdQWAwq
Content-Type: multipart/mixed; boundary="EVS2QutQWpmEOjn7FO7Cyc47f0mTO4D98"

--EVS2QutQWpmEOjn7FO7Cyc47f0mTO4D98
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/3/20 12:53 AM, Hauke Mehrtens wrote:
> This resolves the hazard between the mtc0 in the change_c0_status() and=

> the mfc0 in configure_exception_vector(). Without resolving this hazard=

> configure_exception_vector() could read an old value and would restore
> this old value again. This would revert the changes change_c0_status()
> did. I checked this by printing out the read_c0_status() at the end of
> per_cpu_trap_init() and the ST0_MX is not set without this patch.
>=20
> The hazard is documented in the MIPS Architecture Reference Manual Vol.=

> III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), rev=

> 6.03 table 8.1 which includes:
>=20
>    Producer | Consumer | Hazard
>   ----------|----------|----------------------------
>    mtc0     | mfc0     | any coprocessor 0 register
>=20
> I saw this hazard on an Atheros AR9344 rev 2 SoC with a MIPS 74Kc CPU.
> There the change_c0_status() function would activate the DSPen by
> setting ST0_MX in the c0_status register. This was reverted and then th=
e
> system got a DSP exception when the DSP registers were saved in
> save_dsp() in the first process switch. The crash looks like this:
>=20
> [    0.089999] Mount-cache hash table entries: 1024 (order: 0, 4096 byt=
es, linear)
> [    0.097796] Mountpoint-cache hash table entries: 1024 (order: 0, 409=
6 bytes, linear)
> [    0.107070] Kernel panic - not syncing: Unexpected DSP exception
> [    0.113470] Rebooting in 1 seconds..
>=20
> We saw this problem in OpenWrt only on the MIPS 74Kc based Atheros SoCs=
,
> not on the 24Kc based SoCs. We only saw it with kernel 5.4 not with
> kernel 4.19, in addition we had to use GCC 8.4 or 9.X, with GCC 8.3 it
> did not happen.
>=20
> In the kernel I bisected this problem to commit 9012d011660e ("compiler=
:
> allow all arches to enable CONFIG_OPTIMIZE_INLINING"), but when this wa=
s
> reverted it also happened after commit 172dcd935c34b ("MIPS: Always
> allocate exception vector for MIPSr2+").
>=20
> Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")=

> does similar changes to a different file. I am not sure if there are
> more places affected by this problem.
>=20
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/mips/kernel/traps.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index 7c32c956156a..1234ea21dd8f 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -2169,6 +2169,7 @@ static void configure_status(void)
> =20
>  	change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST=
0_SX|ST0_UX,
>  			 status_set);
> +	back_to_back_c0_hazard();
>  }
> =20
>  unsigned int hwrena;
>=20

The MIPS InterAptiv system software user manual suggests to put this
back_to_back_c0_hazard() close to the consumer. Should I move it there?

Should I also add a back_to_back_c0_hazard() close to the other places
which could be affected by similar problems even when I do not see them
at runtime?

Hauke


--EVS2QutQWpmEOjn7FO7Cyc47f0mTO4D98--

--ZH27rMtRo0Y59QdW5LrpFb5H9kKdQWAwq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl7/sc0ACgkQ8bdnhZyy
68ea5wgAqRK+RSUK9kIEAz+uHBmFL1n+3QVQTUaTUJA/EQsp1lvsZZqyfoXw5ypd
gIiypIesR6ISUgusYipgk5sOretJZH/adf9Ejs13dTEkIwzct2PmfJRNUktSMebK
7Kuok0yJy21CP10EvTANyUwHUxhMFnYva2ciz+vYDof0gnNBDql/lzq8A2RhQsd1
tcN7dW+IoCYfEw76iVOelp6y8CHjw12kcJNX0yjgldve1hYSAf+tG82wtM3j+vMw
ww5YxnyPpfKn+CbJJhadv3Jc0iOqSQnjvzzwg8lcIXUrlWCBtSeCSRD1MXNxJEJu
X9cRZ8UUpHI9Jzwn+KYrh6VmKuGMWw==
=Zs/o
-----END PGP SIGNATURE-----

--ZH27rMtRo0Y59QdW5LrpFb5H9kKdQWAwq--
