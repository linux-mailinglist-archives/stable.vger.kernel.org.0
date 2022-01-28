Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA81549FFEA
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 19:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344097AbiA1SFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 13:05:38 -0500
Received: from mout.gmx.net ([212.227.17.20]:56351 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349942AbiA1SFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 13:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643393109;
        bh=iRFt1KYMfjxrsMdt+zhDL0zzqnVvCTO/KxVzMNkb37Y=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=h0NBAwfPe525EStPtOQSPoVTQtrKjEHtGFPL4e0qFZaOo/17BBxl3TQxwJJjSI1yf
         Xyj2x6Jq/b/nffgU6moyZ2vxxZd6xdOPiV0l/P+GA0bC22xJ4uRIVkuA/g4H3RaWbx
         TvuFh86tiIMNJAv4TS8CcojkP8m5UzCXYsp+LRMI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.194.160]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MbRfl-1mgvxU1Eoz-00bpvj; Fri, 28
 Jan 2022 19:05:09 +0100
Date:   Fri, 28 Jan 2022 19:05:06 +0100
From:   Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] random: remove batched entropy locking
Message-ID: <YfQwUvyZL05MtEA4@latitude>
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="A6vXYDstX4zHSKyS"
Content-Disposition: inline
In-Reply-To: <20220128153344.34211-1-Jason@zx2c4.com>
X-Provags-ID: V03:K1:Jhr2awT3cVJ7/eSIUG9/WCfAfuc1z9OpNH/Arnzirp3sObV29Yf
 ely1xPuoPvdbBHHI174GL7Br5di++9BxlflHCDXaFxsacJiBwyD67mOCihryUbVSsKtMQMk
 THcVx0Cbn2rbI03P8WNfRK7on+01Jt24Pzlx4jAmxLVQULMzRgnxNrjWEixjSV6i7PTTfDN
 xA/t3AUWyndP5eZHvnr9w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EQeQOkdOfwc=:KvDIMuABLM1L7ZUn3XdGgp
 ac+TTLtI8nJ6z3rCugjB0li/3WNbrjGTVP8CuHFaMy1WGn0qfktLERcvrKmR7HiLYGYEjviLu
 MzK2+SnQRW2XfImwtUWmi+DUZmBl+KhbgasXUcy7PTKQ45VzpByfLYFvvXKiYsGJrq7zFWCHY
 OAUwpEOxAxYW/V9dMW3RbWam77G9WqswM/lTrxaF8AYLPZ4HIeIejaul94rZcb09g9GA+9ibB
 +IzBg3Bj9jLsrR2Nrw/hhenEiG+6r/rqkMq4CVDXLwVzGSHjYetr1OK92pFscNCgyawLuj37s
 H2So6Z6AQ6O/GLiRj3dkmGP8B+xXuEmXzp80lqLN6FCSXSHGyF+tzmsBv9stUDrm4ZW7btBU+
 YSpS/erA3+QfjyM/4SqnqUbxnrJxt6zv7dVV8AbBvhcVejSDgb23WwsSRhXEySz4JcGfn3IRk
 jYl4eBJvnLoPfc+Pq6h5UGqy5EyauToL58HukOkA3r+MlTPVbxQspxI1QhchffMTvE84y4+B0
 yaIoy9WthVf/EvyPD+CKUSHE6WTS3Beu5emq3OhJis7NdLoOe2+HSD5aqsLBgd4HOyc9dKUOX
 2NsPSpeGY7Ad+HuVfu+9lkB9X3rY2JP+bk1odn0KGNL5H1VGyAFOe/NDJCHjUUajDSnhl+Raq
 5oK7LYmSGdm1BV2SjKSeyS+WaB2HdBLEfMUtpbI8HPu2zGlpoYTyyhFUdEOwJ4O4QrEbI5rM7
 3/7O2cuoEmxEGcI37hHU/3l3WfoYzZRZUKZp5oasuQRuIeQU91rzpVE7Hs/OD0acNya8qB8zw
 3s0zeD9YcggmrlyZWCl/QkASruLrGOsbm2WSMUyaytbIddZ0dT5md8+e26mAttwPYDybT9KzP
 qXt2VuueTalKp0VMSH/nUNjt+1rvx5t6CKp7qxYWg8z5MJgA4GHoOmArv3eIPEq5yADy5HRZR
 CqvuT16nGP3MAmkNYNARC8Egd1qpg1QtjO0lR2G27qx8gmPKHoGTYHdU0GWl023cbbt/bRlyS
 FzDumjdyEoaSvSwXOum2o88WzdszpPGo8/YoE/yPz68O1bIkrfzbDwEcMm+3mdwq2d1DhN/AO
 wDiw7+hhrLej3k=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--A6vXYDstX4zHSKyS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 28, 2022 at 04:33:44PM +0100, Jason A. Donenfeld wrote:
> From: Andy Lutomirski <luto@kernel.org>
>=20
> We don't need spinlocks to protect batched entropy -- all we need
> is a little bit of care. This should fix up the following splat that
> Jonathan received with a PROVE_LOCKING=3Dy/PROVE_RAW_LOCK_NESTING=3Dy
> kernel:
>=20
> [    2.500000] [ BUG: Invalid wait context ]
> [    2.500000] 5.17.0-rc1 #563 Not tainted
> [    2.500000] -----------------------------
> [    2.500000] swapper/1 is trying to lock:
> [    2.500000] c0b0e9cc (batched_entropy_u32.lock){....}-{3:3}, at: inval=
idate_batched_entropy+0x18/0x4c
> [    2.500000] other info that might help us debug this:
> [    2.500000] context-{2:2}
> [    2.500000] 3 locks held by swapper/1:
> [    2.500000]  #0: c0ae86ac (event_mutex){+.+.}-{4:4}, at: event_trace_i=
nit+0x4c/0xd8
> [    2.500000]  #1: c0ae81b8 (trace_event_sem){+.+.}-{4:4}, at: event_tra=
ce_init+0x68/0xd8
> [    2.500000]  #2: c19b05cc (&sb->s_type->i_mutex_key#2){+.+.}-{4:4}, at=
: start_creating+0x40/0xc4
> [    2.500000] stack backtrace:
> [    2.500000] CPU: 0 PID: 1 Comm: swapper Not tainted 5.17.0-rc1 #563
> [    2.500000] Hardware name: WPCM450 chip
> [    2.500000] [<c00100a8>] (unwind_backtrace) from [<c000db2c>] (show_st=
ack+0x10/0x14)
> [    2.500000] [<c000db2c>] (show_stack) from [<c0054eec>] (__lock_acquir=
e+0x3f0/0x189c)
> [    2.500000] [<c0054eec>] (__lock_acquire) from [<c0054478>] (lock_acqu=
ire+0x2b8/0x354)
> [    2.500000] [<c0054478>] (lock_acquire) from [<c0568028>] (_raw_spin_l=
ock_irqsave+0x60/0x74)
> [    2.500000] [<c0568028>] (_raw_spin_lock_irqsave) from [<c030b6f4>] (i=
nvalidate_batched_entropy+0x18/0x4c)
> [    2.500000] [<c030b6f4>] (invalidate_batched_entropy) from [<c030e7fc>=
] (crng_fast_load+0xf0/0x110)
> [    2.500000] [<c030e7fc>] (crng_fast_load) from [<c030e954>] (add_inter=
rupt_randomness+0x138/0x200)
> [    2.500000] [<c030e954>] (add_interrupt_randomness) from [<c0061b34>] =
(handle_irq_event_percpu+0x18/0x38)
> [    2.500000] [<c0061b34>] (handle_irq_event_percpu) from [<c0061b8c>] (=
handle_irq_event+0x38/0x5c)
> [    2.500000] [<c0061b8c>] (handle_irq_event) from [<c0065b28>] (handle_=
fasteoi_irq+0x9c/0x114)
> [    2.500000] [<c0065b28>] (handle_fasteoi_irq) from [<c0061178>] (handl=
e_irq_desc+0x24/0x34)
> [    2.500000] [<c0061178>] (handle_irq_desc) from [<c056214c>] (generic_=
handle_arch_irq+0x28/0x3c)
> [    2.500000] [<c056214c>] (generic_handle_arch_irq) from [<c0008eb4>] (=
__irq_svc+0x54/0x80)
> [    2.500000] Exception stack(0xc1485d48 to 0xc1485d90)
> [    2.500000] 5d40:                   9780e804 00000001 c09413d4 200000d=
3 60000053 c016af54
> [    2.500000] 5d60: 00000000 c0afa5b8 c14194e0 c19a1d48 c0789ce0 0000000=
0 c1490480 c1485d98
> [    2.500000] 5d80: c0168970 c0168984 20000053 ffffffff
> [    2.500000] [<c0008eb4>] (__irq_svc) from [<c0168984>] (read_seqbegin.=
constprop.0+0x6c/0x90)
> [    2.500000] [<c0168984>] (read_seqbegin.constprop.0) from [<c016af54>]=
 (d_lookup+0x14/0x40)
> [    2.500000] [<c016af54>] (d_lookup) from [<c015cecc>] (lookup_dcache+0=
x18/0x50)
> [    2.500000] [<c015cecc>] (lookup_dcache) from [<c015d868>] (lookup_one=
_len+0x90/0xe0)
> [    2.500000] [<c015d868>] (lookup_one_len) from [<c01e33e4>] (start_cre=
ating+0x68/0xc4)
> [    2.500000] [<c01e33e4>] (start_creating) from [<c01e398c>] (tracefs_c=
reate_file+0x30/0x11c)
> [    2.500000] [<c01e398c>] (tracefs_create_file) from [<c00c42f8>] (trac=
e_create_file+0x14/0x38)
> [    2.500000] [<c00c42f8>] (trace_create_file) from [<c00cc854>] (event_=
create_dir+0x310/0x420)
> [    2.500000] [<c00cc854>] (event_create_dir) from [<c00cc9d8>] (__trace=
_early_add_event_dirs+0x28/0x50)
> [    2.500000] [<c00cc9d8>] (__trace_early_add_event_dirs) from [<c07c8d6=
4>] (event_trace_init+0x70/0xd8)
> [    2.500000] [<c07c8d64>] (event_trace_init) from [<c07c8560>] (tracer_=
init_tracefs+0x14/0x284)
> [    2.500000] [<c07c8560>] (tracer_init_tracefs) from [<c000a330>] (do_o=
ne_initcall+0xdc/0x288)
> [    2.500000] [<c000a330>] (do_one_initcall) from [<c07bd1e8>] (kernel_i=
nit_freeable+0x1c4/0x20c)
> [    2.500000] [<c07bd1e8>] (kernel_init_freeable) from [<c05629c0>] (ker=
nel_init+0x10/0x110)
> [    2.500000] [<c05629c0>] (kernel_init) from [<c00084f8>] (ret_from_for=
k+0x14/0x3c)
> [    2.500000] Exception stack(0xc1485fb0 to 0xc1485ff8)
> [    2.500000] 5fa0:                                     00000000 0000000=
0 00000000 00000000
> [    2.500000] 5fc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
> [    2.500000] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>=20
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> [Jason: I extracted this from a larger in-progress series of Andy's that
>  also unifies the two batches into one and does other performance
>  things. Since that's still under development, but because we need this
>  part to fix the CONFIG_PROVE_RAW_LOCK_NESTING issue, I've extracted it
>  out and applied it to the current setup. This will also make it easier
>  to backport to old kernels that also need the fix. I've also amended
>  Andy's original commit message.]
> Reported-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Link: https://lore.kernel.org/lkml/YfMa0QgsjCVdRAvJ@latitude/
> Fixes: b7d5dc21072c ("random: add a spinlock_t to struct batched_entropy")
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Andy - could you take a look at this and let me know if it's still
> correct after I've ported it out of your series and into a standalone
> thing here? I'd prefer to hold off on moving forward on this until I
> receive our green light. I'm also still a bit uncertain about your NB:
> comment regarding the acceptable race. If you could elaborate on that
> argument, it might save me a few cycles with my thinking cap on.
>=20
>  drivers/char/random.c | 57 ++++++++++++++++++++++++-------------------
>  1 file changed, 32 insertions(+), 25 deletions(-)

FWIW, this does fix the splat on my machine.

Tested-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>



Thanks everyone,
Jonathan

--A6vXYDstX4zHSKyS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmH0MDEACgkQCDBEmo7z
X9tbKQ/8CxYH4spoiEoNY8v6/3PnyLR2TJQ2rfaUAXnij/S4JsaFH5oXZ/58nqug
N5i0jEdqju0gaKNyZ9uUk+4uGt94CeYyYj3idkYl6GxVgTGvtv+ori/q78+LOU8y
IoNKaQE+nJj7/j2oecbkYgazoIAPNCnyy33y4nVUKgU4hO4sUT1M2uDNegU8lk51
RfTGIOb8Dyk/311wuDe030bJv0N+p68Pwk/m2nUv9dgbE17r2iyG+FCm2Ej/Tw3t
gTQuYm1qgv52BAMCBkARC19Vp4GJApJ9oDW/Y5/eG8Y+fIJYe8QZwbL5sGDx8IQz
JjWzmwj36K9CFGZTH8LhxFHSr/YUn4vqP/wI6N9MR90L6hOPXcYqA1K9oawKlP1V
seNd2BMxqBG9x5x7PCDQc/xBbhwjDqS4jdK9s5qHRxLuLo99XESlrxY0iJKxKTxT
yt+/0BrPwSGexf/EBQDXMy8cmADdsp4yfLYVlQfQVdKrOfKxFPFaB2mMtOnC9DO/
rPsp7CE4GpnJSGnV5gqz0KZnhtSzWRAKzPsT+DW9vBgp7z9HFf+XDKeAeYFLtnRf
UWxArDDxjGqxaw/Nq064iovXog/TbIR/jTLI1mEiLBJMah+xfaDa4zSsNmtHzEdq
jQCT/Ivf0a8QrGf8HIxCm+gxeugCyNQo7RteDkUyXA6X3M57Fb0=
=ESBe
-----END PGP SIGNATURE-----

--A6vXYDstX4zHSKyS--
