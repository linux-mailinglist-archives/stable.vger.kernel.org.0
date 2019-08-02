Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB297EF26
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404103AbfHBIZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:25:06 -0400
Received: from mx1.emlix.com ([188.40.240.192]:35918 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfHBIZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 04:25:06 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 04:25:05 EDT
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 9453D608E7;
        Fri,  2 Aug 2019 10:16:27 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Date:   Fri, 02 Aug 2019 10:16:23 +0200
Message-ID: <1730571.CeeFRff0Br@devpool35>
Organization: emlix GmbH
In-Reply-To: <20190802080942.GA27595@archlinux-threadripper>
References: <779905244.a0lJJiZRjM@devpool35> <20190802075745.GI26174@kroah.com> <20190802080942.GA27595@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5118905.V6sjJquZsO"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart5118905.V6sjJquZsO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Nathan Chancellor wrote:
> On Fri, Aug 02, 2019 at 09:57:45AM +0200, Greg KH wrote:
> > On Thu, Jun 06, 2019 at 09:11:00AM +0200, Rolf Eike Beer wrote:
> > > Nick Desaulniers wrote:
> > > > On Wed, Jun 5, 2019 at 10:27 AM Nick Desaulniers
> > > >=20
> > > > <ndesaulniers@google.com> wrote:
> > > > > On Wed, Jun 5, 2019 at 9:26 AM Greg KH <gregkh@linuxfoundation.or=
g>=20
wrote:
> > > > > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > > > > I decided to dig out a toy project which uses a DragonBoard
> > > > > > > 410c. This
> > > > > > > has
> > > > > > > been "running" with kernel 4.9, which I would keep this way f=
or
> > > > > > > unrelated
> > > > > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but
> > > > > > > it was
> > > > > > > buildable, which was good enough.
> > > > > > >=20
> > > > > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly
> > > > > > > fail:
> > > > > > >=20
> > > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in
> > > > > > > function
> > > > > > > `handle_kernel_image':
> > > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm6=
4-s
> > > > > > > tub.c:
> > > > > > > 63:
> > > > > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o):
> > > > > > > relocation
> > > > > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally c=
an
> > > > > > > not
> > > > > > > be used when making a shared object; recompile with -fPIC
> > > > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm6=
4-s
> > > > > > > tub.c:
> > > > > > > 63:
> > > > > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target
> > > > > > > 'vmlinux'
> > > > > > > failed -make[1]: *** [vmlinux] Error 1
> > > > > > >=20
> > > > > > > This is caused by commit
> > > > > > > 27b5ebf61818749b3568354c64a8ec2d9cd5ecca from
> > > > > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042b=
e),
> > > > > > > reverting
> > > > > > > this commit fixes the build.

> > Did this ever get resolved, or is it still an issue?
>=20
> This appears to have been resolved by commit 8fca3c364683 ("efi/libstub:
> Unify command line param parsing") in 4.9.181. I can build defconfig +
> CONFIG_RANDOMIZE_BASE without any issues.

I can confirm that 4.9.186 builds without issues with my original config.

Thanks for paying attention.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart5118905.V6sjJquZsO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXUPxVwAKCRCr5FH7Xu2t
/CXdBACxv6k3WGP20X7pZkaOIHLo5u8V/uU0Iq5J+12F91cswWsFojaI8ZtGp9vT
mluIljCRzuKTSHs0hw+gJVZdjK4z9vLkhdGrZl788pAgJKzqnOsBsxCWl5Gyq/lB
lyTJcLp5s7uyFCXwNi0Hzpc91wHyy4Zm1WLeFjYwqHBFqOKWiw==
=f8g+
-----END PGP SIGNATURE-----

--nextPart5118905.V6sjJquZsO--



