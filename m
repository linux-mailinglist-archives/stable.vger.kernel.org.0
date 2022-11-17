Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC562CF73
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiKQAWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 19:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiKQAWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 19:22:10 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35F048756;
        Wed, 16 Nov 2022 16:22:08 -0800 (PST)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_E77615D2-BFB2-4C9F-ACA8-67DC4C1B26F3";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] kbuild: Fix -Wimplicit-function-declaration in
 license_is_gpl_compatible
From:   Sam James <sam@gentoo.org>
In-Reply-To: <20221116182634.2823136-1-sam@gentoo.org>
Date:   Thu, 17 Nov 2022 00:21:51 +0000
Cc:     Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        stable@vger.kernel.org
Message-Id: <4F6C0B05-1DF3-46F8-AC5C-240FC4B3271A@gentoo.org>
References: <20221116182634.2823136-1-sam@gentoo.org>
To:     linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_E77615D2-BFB2-4C9F-ACA8-67DC4C1B26F3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 16 Nov 2022, at 18:26, Sam James <sam@gentoo.org> wrote:
>=20
> Add missing <string.h> include for strcmp.
>=20
> Clang 16 makes -Wimplicit-function-declaration an error by default. =
Unfortunately,
> out of tree modules may use this in configure scripts, which means =
failure
> might cause silent miscompilation or misconfiguration.
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
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: trivial@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Sam James <sam@gentoo.org>
> ---
> include/linux/license.h | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/include/linux/license.h b/include/linux/license.h
> index 7cce390f120b..1c0f28904ed0 100644
> --- a/include/linux/license.h
> +++ b/include/linux/license.h
> @@ -2,6 +2,8 @@
> #ifndef __LICENSE_H
> #define __LICENSE_H
>=20
> +#include <string.h>
> +

Andrew's added this to his tree with the following fixup (duh!):
```
-#include <string.h>
+#include <linux/string.h>
```

Best,
sam

--Apple-Mail=_E77615D2-BFB2-4C9F-ACA8-67DC4C1B26F3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iNUEARYKAH0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCY3V+oF8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MAAKCRBzhAn1IN+R
kNZxAP4yD2RBpOfon2qmVUaxGglz12fKFK3WYwIwYK69MAAgGwD8D/BbPh0BdIpM
Kb4Vmoab1VTQ+OLnjNnDkYBNeeJhbQU=
=BBCx
-----END PGP SIGNATURE-----

--Apple-Mail=_E77615D2-BFB2-4C9F-ACA8-67DC4C1B26F3--
