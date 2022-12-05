Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35408642183
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 03:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiLECZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 21:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiLECZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 21:25:01 -0500
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC8613CDA;
        Sun,  4 Dec 2022 18:24:59 -0800 (PST)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_48A56E77-B512-4D56-9235-467A7E036342";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: Patch "kbuild: fix -Wimplicit-function-declaration in
 license_is_gpl_compatible" has been added to the 5.15-stable tree
From:   Sam James <sam@gentoo.org>
In-Reply-To: <Y401obKZjg5MoOXL@sashalap>
Date:   Mon, 5 Dec 2022 02:24:42 +0000
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Message-Id: <51F56DDE-BEAE-4B1B-A02E-DF7B9F5D64E2@gentoo.org>
References: <20221203092656.400311-1-sashal@kernel.org>
 <C4884E05-F4DB-4FED-860A-1DF38BEABF3F@gentoo.org> <Y401obKZjg5MoOXL@sashalap>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_48A56E77-B512-4D56-9235-467A7E036342
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 5 Dec 2022, at 00:04, Sasha Levin <sashal@kernel.org> wrote:
>=20
> On Sat, Dec 03, 2022 at 09:29:39AM +0000, Sam James wrote:
>>=20
>>=20
>>> On 3 Dec 2022, at 09:26, Sasha Levin <sashal@kernel.org> wrote:
>>>=20
>>> This is a note to let you know that I've just added the patch titled
>>>=20
>>>   kbuild: fix -Wimplicit-function-declaration in =
license_is_gpl_compatible
>>>=20
>>> to the 5.15-stable tree which can be found at:
>>>   =
http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.git;a=3D=
summary
>>>=20
>>> The filename of the patch is:
>>>    kbuild-fix-wimplicit-function-declaration-in-license.patch
>>> and it can be found in the queue-5.15 subdirectory.
>>>=20
>>> If you, or anyone else, feels it should not be added to the stable =
tree,
>>> please let <stable@vger.kernel.org> know about it.
>>>=20
>>>=20
>>>=20
>>> commit 3f07ef5743bd434f3689f9ceed7a24128dc6b5ae
>>> Author: Sam James <sam@gentoo.org>
>>> Date:   Wed Nov 16 18:26:34 2022 +0000
>>>=20
>>>   kbuild: fix -Wimplicit-function-declaration in =
license_is_gpl_compatible
>>>=20
>>>   [ Upstream commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 ]
>>=20
>> Hi Sasha,
>>=20
>> Please yank this commit as it's been reverted upstream, it doesn't =
work
>> for cross as-is.
>=20
> Hi Sam,
>=20
> It already made it in prior to your mail. Could you point me to the
> reverting commit? I can grab that too.

No worries -- here's the revert:
=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D1d351f1894342c378b96bb9ed89f8debb1e24e9f.

Best,
sam

--Apple-Mail=_48A56E77-B512-4D56-9235-467A7E036342
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iNUEARYKAH0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCY41Wal8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MAAKCRBzhAn1IN+R
kHnVAQD7EyoMLzi4q3dUvn0aJ3vINwLc/Qd+C8p67/6I+W2/jwEAonHOhtsSZjnc
acXAHcvGXTMTguFW/lUMos7BcclAIQY=
=VbXq
-----END PGP SIGNATURE-----

--Apple-Mail=_48A56E77-B512-4D56-9235-467A7E036342--
