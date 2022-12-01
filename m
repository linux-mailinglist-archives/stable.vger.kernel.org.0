Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A46D63E915
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 05:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLAExN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 23:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLAExN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 23:53:13 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AEF48424;
        Wed, 30 Nov 2022 20:53:10 -0800 (PST)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_4DC5171B-6010-4548-BCBC-CC61F618502E";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: Patch "kbuild: fix -Wimplicit-function-declaration in
 license_is_gpl_compatible" has been added to the 6.0-stable tree
From:   Sam James <sam@gentoo.org>
In-Reply-To: <166974128121866@kroah.com>
Date:   Thu, 1 Dec 2022 04:52:50 +0000
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable-commits@vger.kernel.org
Message-Id: <73A357E7-91A4-4E78-963C-806C49B2F8BB@gentoo.org>
References: <166974128121866@kroah.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_4DC5171B-6010-4548-BCBC-CC61F618502E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 29 Nov 2022, at 17:01, gregkh@linuxfoundation.org wrote:
>=20
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>    kbuild: fix -Wimplicit-function-declaration in =
license_is_gpl_compatible
>=20
> to the 6.0-stable tree which can be found at:
>    =
http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.git;a=3D=
summary
>=20
> The filename of the patch is:
>     =
kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.pat=
ch
> and it can be found in the queue-6.0 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable =
tree,
> please let <stable@vger.kernel.org> know about it.
>=20
> =46rom 50c697215a8cc22f0e58c88f06f2716c05a26e85 Mon Sep 17 00:00:00 =
2001
> From: Sam James <sam@gentoo.org>
> Date: Wed, 16 Nov 2022 18:26:34 +0000
> Subject: kbuild: fix -Wimplicit-function-declaration in =
license_is_gpl_compatible
>=20
> From: Sam James <sam@gentoo.org>
>=20
> commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 upstream.

Hi Greg,

Please yank this commit from all the stable queues -- it needs
Some further baking, and a revert is queued in Andrew's tree.

Thanks,
sam

>=20
> Add missing <linux/string.h> include for strcmp.
>=20
> Clang 16 makes -Wimplicit-function-declaration an error by default.
> Unfortunately, out of tree modules may use this in configure scripts,
> which means failure might cause silent miscompilation or =
misconfiguration.
>=20
> For more information, see LWN.net [0] or LLVM's Discourse [1], =
gentoo-dev@ [2],
> or the (new) c-std-porting mailing list [3].
>=20
> [0] https://lwn.net/Articles/913505/
> [1] =
https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror=
-implicit-function-declaration/65213
> [2] =
https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e=
6e240
> [3] hosted at lists.linux.dev.
>=20
> [akpm@linux-foundation.org: remember "linux/"]
> Link: =
https://lkml.kernel.org/r/20221116182634.2823136-1-sam@gentoo.org
> Signed-off-by: Sam James <sam@gentoo.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> include/linux/license.h |    2 ++


--Apple-Mail=_4DC5171B-6010-4548-BCBC-CC61F618502E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iNUEARYKAH0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCY4gzIl8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MAAKCRBzhAn1IN+R
kGSfAQCvWGMKNMDd+Uk5BXqaUOOfykr23fXBHd508ymgZOqGjAEA0zp7LamEh0rs
Z/Uuxyl7oLReV3gz7gE0/8juZkwWywY=
=X/+x
-----END PGP SIGNATURE-----

--Apple-Mail=_4DC5171B-6010-4548-BCBC-CC61F618502E--
