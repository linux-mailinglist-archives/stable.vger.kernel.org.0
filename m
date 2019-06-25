Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1551527B3
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfFYJNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:13:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36162 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728937AbfFYJNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:13:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so8519266plt.3
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2AT6hK7fIJAne16UB4qCunU6zdSy1nhtGi9SlPUaYDk=;
        b=uaNio/m9XOrTQ3XntP4YvXXdhnWRYb5drF+55EGgEpcqi6GKBB2Zf0/fmzAJrEMLpN
         F0fkMc57ehXAI3G1MkTBidtlw/ara9RSMnIg17ikLPk2CpVA2WOIgpj83t8sL9GXi/pB
         KZN7Ak72SdHr4wXXdfHN83Moxz2xWs+nxPLg7JPV7wRrkN6OjUGjkHUTgE92S8vAMVcv
         tfxApxYa+KbH1n4BMDX2vn29N27cNlOAR/xVoFF9itfU7MM4tp7ADufbwtV+xeYnpZPT
         TqWpm3ceilcf2XPg4k/TuBrCQnPr5A6/D/nSGSEI0RYioxYiWHpFjvNQ72Ot2cCUaD3Z
         MdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2AT6hK7fIJAne16UB4qCunU6zdSy1nhtGi9SlPUaYDk=;
        b=HQSc75FtdYmmgkIdzp1cpxJ3WgYNk5xeLxMjEc9bG4HSooI/nxU/E/7XVVFKwXN/jv
         rA+xgDwUfWv6hP/ILuxhrzKR5sDGjT8RcOi2XGFUlXgQtP1/uZvhGNrN76hL8Mv5+qMk
         jQzL3EM1zL9DWtsV94v37RZ5Bg2jYcEpHFO18yo1Kr4BTBDYvYF5bWJkphv6aznDfbNy
         z0ZOFrI6P7H13Osg6j7WfGYSTw0/uWV6bv5twyLwla3+V12ap2QTiwO2Gu9u8KEzji3x
         BL6PnaYpLPoLNJFD5qJcMjL8Lpg+F17npek9/R+FhWzEcZxdl1Qyae8dqXM+gjM47lSu
         e8XQ==
X-Gm-Message-State: APjAAAUoC9howJn9HyGH1S1ifP33sWkU7IkLtLp6+gZCXrA3IHpZ7bTe
        grchzOfPbZOivxb0qs5QfNoT+hQR1PrILw==
X-Google-Smtp-Source: APXvYqyzbfa+POEYwKx1q8tT2LWJafQVi1Lh/sRNvxWWNp4umKJ4ejB2iRgg7IURfdg7/uhbTYCAaA==
X-Received: by 2002:a17:902:4481:: with SMTP id l1mr156282458pld.121.1561453989216;
        Tue, 25 Jun 2019 02:13:09 -0700 (PDT)
Received: from Slackware ([103.231.90.173])
        by smtp.gmail.com with ESMTPSA id u10sm11736001pfh.54.2019.06.25.02.13.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 02:13:08 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:42:59 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     stable@vger.kernel.org
Subject: [gregkh@linuxfoundation.org: Re: Failed to checksum on tarball
 latest kernel 5.1.15]
Message-ID: <20190625091259.GC3789@Slackware>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Please look in. This is happening at least two different distros I tried...=
here is another one :

bhaskar@Slackware_14:12:28_Tue Jun 25:~> Adm_scripts/secure_kernel_tarball =
5.1.15
Using TMPDIR=3D/home/bhaskar/Downloads/linux-tarball-verify.36SHqG.untrusted
Making sure we have all the necessary keys
pub   rsa4096 2013-01-24 [SC]
      B8868C80BA62A1FFFAF5FDA9632D3A06589DA6B1
      uid           [ unknown] Kernel.org checksum autosigner <autosigner@k=
ernel.org>

      pub   rsa4096 2011-09-23 [SC]
            647F28654894E3BD457199BE38DBBDC86092693E
            uid           [ unknown] Greg Kroah-Hartman <gregkh@linuxfounda=
tion.org>
            uid           [ unknown] Greg Kroah-Hartman (Linux kernel stabl=
e release signing key) <greg@kroah.com>
            uid           [ unknown] Greg Kroah-Hartman <gregkh@kernel.org>
            sub   rsa4096 2011-09-23 [E]

            pub   rsa2048 2011-09-20 [SC]
                  ABAF11C65A2970B130ABE3C479BE3E4300411886
                  uid           [ unknown] Linus Torvalds <torvalds@kernel.=
org>
                  uid           [ unknown] Linus Torvalds <torvalds@linux-f=
oundation.org>
                  sub   rsa2048 2011-09-20 [E]

                  Downloading the checksums file for linux-5.1.15
                  Verifying the checksums file
                  gpgv: Signature made Sat 22 Jun 2019 03:01:21 PM IST
                  gpgv:                using RSA key 632D3A06589DA6B1
                  gpgv: Good signature from "Kernel.org checksum autosigner=
 <autosigner@kernel.org>"

                  Downloading the signature file for linux-5.1.15
                  Downloading the XZ tarball for linux-5.1.15
                    % Total    % Received % Xferd  Average Speed   Time    =
Time     Time  Current
                                                     Dload  Upload   Total =
  Spent    Left  Speed
                                                     100  101M  100  101M  =
  0     0   270k      0  0:06:23  0:06:23 --:--:--  328k
                                                     Verifying checksum on =
linux-5.1.15.tar.xz
                                                     /usr/bin/sha256sum: /h=
ome/bhaskar/Downloads/linux-tarball-verify.36SHqG.untrusted/sha256sums.txt:=
 no properly formatted SHA256 checksum lines found
                                                     FAILED to verify the d=
ownloaded tarball checksum


----- Forwarded message from Greg KH <gregkh@linuxfoundation.org> -----

Date: Tue, 25 Jun 2019 14:59:38 +0800
=46rom: Greg KH <gregkh@linuxfoundation.org>
To: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: Re: Failed to checksum on tarball latest kernel 5.1.15
User-Agent: Mutt/1.12.1 (2019-06-15)

On Tue, Jun 25, 2019 at 09:46:53AM +0530, Bhaskar Chowdhury wrote:
> I got this :
>
> Check the latest stable kernel version from kernel.org
>
> 5.1.15 Get the kernel from kernel.org and this for the *stable* kernel
>
>
> Using TMPDIR=3D/home/bhaskar/latest_kernel_build_Gentoo_2019-06-25/linux-=
tarball-verify.XwbUNj.untrusted
> Making sure we have all the necessary keys
> gpg: WARNING: unsafe ownership on homedir '/home/bhaskar/.gnupg'
> pub   rsa4096 2013-01-24 [SC]
>      B8868C80BA62A1FFFAF5FDA9632D3A06589DA6B1
> uid           [ unknown] Kernel.org checksum autosigner <autosigner@kerne=
l.org>
>
> pub   rsa4096 2011-09-23 [SC]
>      647F28654894E3BD457199BE38DBBDC86092693E
> uid           [ unknown] Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> uid           [ unknown] Greg Kroah-Hartman (Linux kernel stable release =
signing key) <greg@kroah.com>
> uid           [ unknown] Greg Kroah-Hartman <gregkh@kernel.org>
> sub   rsa4096 2011-09-23 [E]
>
> pub   rsa2048 2011-09-20 [SC]
>      ABAF11C65A2970B130ABE3C479BE3E4300411886
> uid           [ unknown] Linus Torvalds <torvalds@kernel.org>
> uid           [ unknown] Linus Torvalds <torvalds@linux-foundation.org>
> sub   rsa2048 2011-09-20 [E]
>
> Downloading the checksums file for linux-5.1.15
> Verifying the checksums file
> gpgv: Signature made Sat Jun 22 15:01:21 2019 IST
> gpgv:                using RSA key 632D3A06589DA6B1
> gpgv: Good signature from "Kernel.org checksum autosigner <autosigner@ker=
nel.org>"
>
> Downloading the signature file for linux-5.1.15
> Downloading the XZ tarball for linux-5.1.15
>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Cu=
rrent
>                                 Dload  Upload   Total   Spent    Left  Sp=
eed
> 100  101M  100  101M    0     0  8237k      0  0:00:12  0:00:12 --:--:-- =
8342k
> Verifying checksum on linux-5.1.15.tar.xz
> /usr/bin/sha256sum: /home/bhaskar/latest_kernel_build_Gentoo_2019-06-25/l=
inux-tarball-verify.XwbUNj.untrusted/sha256sums.txt: no properly formatted =
SHA256 checksum lines found
> FAILED to verify the downloaded tarball checksum
>
>

Looks like a distro problem, right?

----- End forwarded message -----

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0R5ZsACgkQsjqdtxFL
KRWuWggAoEOLynwQjd5Gia+hTy5vu3nqk0MCZqGd+VCkbPxjVmIMY2ic21aVx5SG
S/xYyKeOOGl2+RZZ1S10yhusPURGm8l/VPloZSx1112bz6CeMoz8kJdDT8c2eFls
NfsE+A2R//rR3/IYiAF+UTZ01JEijSYoqEUg1otxXmZd5c3caqYxfQctfiCsBn9H
Yr+zF/tXF05cwuyHd9rzJAmn1P/XSes+FLO3n8f3JBQDmGY95ASed70hPqQ8RwBx
pWaSD73qeJFXsmF4o//3PLQ+buZdzs4hjNEpBqqMvU6dIMVRg9kDtWd3lqZqAQdq
FuCZtidcFUBbFhKhobahyWNEKGahOg==
=J8oN
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
