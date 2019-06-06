Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5260237337
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFFLoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:44:08 -0400
Received: from mx1.emlix.com ([188.40.240.192]:36596 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfFFLoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:44:08 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id B865560076;
        Thu,  6 Jun 2019 13:44:06 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-efi@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, ndesaulniers@google.com
Subject: Re: [PATCH for-4.9-stable] efi/libstub: Unify command line param parsing
Date:   Thu, 06 Jun 2019 13:44:06 +0200
Message-ID: <2196650.4E46qPc46x@devpool35>
Organization: emlix GmbH
In-Reply-To: <20190606102513.16321-1-ard.biesheuvel@linaro.org>
References: <20190606102513.16321-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart31848172.T2U0eTky2d"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart31848172.T2U0eTky2d
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Ard Biesheuvel wrote:
> Commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.
>=20
> Merge the parsing of the command line carried out in arm-stub.c with
> the handling in efi_parse_options(). Note that this also fixes the
> missing handling of CONFIG_CMDLINE_FORCE=3Dy, in which case the builtin
> command line should supersede the one passed by the firmware.
>=20
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: bhe@redhat.com
> Cc: bhsharma@redhat.com
> Cc: bp@alien8.de
> Cc: eugene@hp.com
> Cc: evgeny.kalugin@intel.com
> Cc: jhugo@codeaurora.org
> Cc: leif.lindholm@linaro.org
> Cc: linux-efi@vger.kernel.org
> Cc: mark.rutland@arm.com
> Cc: roy.franz@cavium.com
> Cc: rruigrok@codeaurora.org
> Link:
> http://lkml.kernel.org/r/20170404160910.28115-1-ard.biesheuvel@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> [ardb: fix up merge conflicts with 4.9.180]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> This fixes the GCC build issue reported by Eike.
>=20
> Note that testing of arm64 stable kernels should cover
> CONFIG_RANDOMIZE_BASE, since it has a profound impact on how the kernel
> binary gets put together.

Confirmed, this patch works for me on top of 4.9.180.
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart31848172.T2U0eTky2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXPj8hgAKCRCr5FH7Xu2t
/KqvBACxZ44yrgwXFYO5IWDP4c6Gj4rNZNK006TUmmaVB3n7KbmstKkpXivHCuvi
7hTrt+dMHZhz2uGImeVtHai19TPD0cMTYJ5IvbCBpCCKzMXLSO8iznEGlzDDRhZm
EGBsQ1AhxH0e65RKZ8cadPHdr10R193FNmW/xIVFnrYQcHKEHg==
=L3Vj
-----END PGP SIGNATURE-----

--nextPart31848172.T2U0eTky2d--



