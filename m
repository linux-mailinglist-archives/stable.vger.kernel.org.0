Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4889812D70C
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 09:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfLaIVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 03:21:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43858 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfLaIVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 03:21:07 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9B55F1C2605; Tue, 31 Dec 2019 09:21:05 +0100 (CET)
Date:   Tue, 31 Dec 2019 09:21:04 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Borislav Petkov <bp@suse.de>, bhe@redhat.com,
        d.hatayama@fujitsu.com, dhowells@redhat.com, dyoung@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?iso-8859-1?Q?J=FCrgen?= Gross <jgross@suse.com>,
        kexec@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, vgoyal@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 159/219] x86/crash: Add a forward declaration of
 struct kimage
Message-ID: <20191231082104.GA18654@amd>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162532.764428471@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20191229162532.764428471@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-29 18:19:21, Greg Kroah-Hartman wrote:
> From: Lianbo Jiang <lijiang@redhat.com>
>=20
> [ Upstream commit 112eee5d06007dae561f14458bde7f2a4879ef4e ]
>=20
> Add a forward declaration of struct kimage to the crash.h header because
> future changes will invoke a crash-specific function from the realmode
> init path and the compiler will complain otherwise like this:
>=20
>   In file included from arch/x86/realmode/init.c:11:
>   ./arch/x86/include/asm/crash.h:5:32: warning: =E2=80=98struct kimage=E2=
=80=99 declared inside\

This is not needed in 4.19-stable, as
6f599d84231fd27e42f4ca2a786a6641e8cddf00 is not being backported
there. (But is simple enough not to do harm).

Best regards,
									Pavel

> @@ -2,6 +2,8 @@
>  #ifndef _ASM_X86_CRASH_H
>  #define _ASM_X86_CRASH_H
> =20
> +struct kimage;
> +
>  int crash_load_segments(struct kimage *image);
>  int crash_copy_backup_region(struct kimage *image);
>  int crash_setup_memmap_entries(struct kimage *image,

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4LBPAACgkQMOfwapXb+vI1YwCgkt7BeSAXQG8Y9wgvq32qdefL
FEMAnAnUXf/SFS6l9L7ov4sP9dCPQc4D
=WrFA
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
