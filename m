Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D643E151A99
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 13:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBDMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 07:37:30 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50154 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgBDMh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 07:37:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 940701C0141; Tue,  4 Feb 2020 13:37:27 +0100 (CET)
Date:   Tue, 4 Feb 2020 13:37:27 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/70] 4.19.102-stable review
Message-ID: <20200204123726.GA6903@duo.ucw.cz>
References: <20200203161912.158976871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.102 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.10=
2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

I see different lists in git and on the lists. Extra on list:

20434 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 4.19 01/70] vfs: fix do_last=
() regression
20435 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 4.19 02/70] x86/resctrl: Fix=
 use-after-free when deleting resource
20436 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 4.19 03/70] x86/resctrl: Fix=
 use-after-free due to inaccurate refco

Extra in git:

 | b220e4852d0a d55966c4279b o | btrfs: do not zero f_bavail if we have ava=
ilab
le space
 | e3dce09f7f99 c3314a74f86d   | perf report: Fix no libunwind compiled war=
ning
 break s390 issue
 | 39dc8d352a93 dfe9aa23cab7 o | mm/migrate.c: also overwrite error when it=
 is bigger than zero


Automatic testing did not find any errors in 4.19.102-rc2:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/114=
683672

(Hmm. I see some problems in 4.4.213-rc2, let me investigate.)

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXjllhgAKCRAw5/Bqldv6
8rDEAKCE5E8u2e2wI8oB3RH6emfJLi4cVgCfeKvvpn6ILcKEI2AKOAf+jNuOeHg=
=mthO
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
