Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C7140F6
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEEQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 12:05:39 -0400
Received: from shelob.surriel.com ([96.67.55.147]:55122 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEQFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 12:05:39 -0400
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <riel@shelob.surriel.com>)
        id 1hNJds-0005zM-Jx; Sun, 05 May 2019 12:05:32 -0400
Message-ID: <86b8d81d760ac1f6e622f1c873a5f9aad7862734.camel@surriel.com>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the
 kernel_fpu_begin/end() export
From:   Rik van Riel <riel@surriel.com>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jikos@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Date:   Sun, 05 May 2019 12:05:32 -0400
In-Reply-To: <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
         <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
         <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
         <20190504004747.GA107909@gmail.com>
         <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KJqJKfJKG1KaNhswI+ku"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-KJqJKfJKG1KaNhswI+ku
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-05-04 at 04:28 +0200, Sebastian Gottschall wrote:

> Using fpu code in kernel space in a kernel module is a derived work
> of=20
> the kernel itself?
> dont get me wrong, but this is absurd. i mean you limit the use of
> cpu=20
> instructions. the use
> of cpu instructions should be free of any licensing issue. i would
> even=20
> argument you are violating
> the license of the cpu ower given to the kernel by executing it, by=20
> restricting its use for no reason

Using FPU code in kernel space in a kernel module
does not require the use of kernel_fpu_begin/end().

The kernel module could simply disable preemption,
save the FPU registers, use the FPU, restore the
FPU registers, and reenable preemption.

However, using kernel_fpu_begin/end() does get that
module some nice optimizations that are specific to
Linux.

--=20
All Rights Reversed.

--=-KJqJKfJKG1KaNhswI+ku
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlzPCcwACgkQznnekoTE
3oP29Qf/T3Zcj5UuvogQBiLgNdSwVJSbdEDgvgAV797ZxOqO8Mst/2REoc0boFwo
ChiG+LqAspHxwlocktLxjiS0DjW4mw6qKua0+5zEfB1ZeCXt0OJJ/ecnypzE2CV7
OgWfrCHyPW8sfxtbFQx1yZKoqmWd6RwgqdP0xGly39TXG3yP4NLbGRhEL4MSEQTW
JKEfKX2d72NRpuGvoaHXHMfMEGWS9t0es8FczpCs2jS05MEnl6GiuqklE0XOPtL+
4X+aiMMBzd6DTuhVPKLoK+F9r12T1OZlgUpT3TXoZ0FOYnv2pAuscLTRgbi5t9XE
wyOjiF7ZF0vgpQfiihgNFFWthiWMvQ==
=/At1
-----END PGP SIGNATURE-----

--=-KJqJKfJKG1KaNhswI+ku--

