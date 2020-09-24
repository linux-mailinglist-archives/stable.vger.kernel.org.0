Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C566D276B2C
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 09:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIXHuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 03:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgIXHuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 03:50:14 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450D223787;
        Thu, 24 Sep 2020 07:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600933813;
        bh=EDjYMV8KmqhHDfc18vRcIBfCGu1ru7i/0ipQ5QtZxBU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JjYVF89NuT3d6EptD2DTH36vkfyAmIko2Rbmge1k4vYhYcqhDREfE0pcGDZaEVRbK
         FWZ7hhYyRjZzOEAjmdYvNaS1QHyseEgwMOSN1lNHw3bdXB6CggwLpjTz7K1d6ISewj
         KYY4Jox51lnvC5XBcTZRdl66iReHHGSoClp3IB80=
From:   Felipe Balbi <balbi@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Kevin Cernekee <cernekee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of
 undeclared usb_debug_root
In-Reply-To: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
References: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
Date:   Thu, 24 Sep 2020 10:50:05 +0300
Message-ID: <871rirehqq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Chunfeng Yun <chunfeng.yun@mediatek.com> writes:

> Fix up the build error caused by undeclared usb_debug_root
>
> Cc: stable <stable@vger.kernel.org>
> Fixes: a66ada4f241c("usb: gadget: bcm63xx_udc: create debugfs directory u=
nder usb root")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

$ patch -p1 --dry-run p.patch
/usr/bin/patch: **** Only garbage was found in the patch input.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9sT60RHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQYl0RAAhvT4mybhJjUYpcnZfXCSsQy+6QZmgHHx
sSI1DBFkX2dbY2mgLsMBMzPRR41WYVZwwupSin6wex79hPmtAafeNyc9ISF2+tWd
gcN9ejg8RuxAoxoGQ19SRVuOvTIK/YzlJho3kCrpUtIoI6n19fdGRLzoaZQ1ziJ5
giZGxhN2jfqZTCcHE3XHPgsaKqQrmvxeksCQkOiCjXg/EvvdFLatvdyAeh8hjdWG
i7HyLRTe/sVzde9TqBJs9pvLNpYrStyDIGD2w+kYMhJCWip29DZMV00rYtpUGMUd
Bgcybsq3GaVOTsMcQQDZdlzdBlE7FSZfzN5JMzCmQLMG/pMgciZyXEKGZ1fwXPCf
ANcZgEFV6HLhJBFHeemuDbOI3qg4YgNx0LVicKfCUW7TXYbpmwqeffnhtu2FjsBF
jb1AmZa16aq/tSMd5/v3r6Xz4m4swMTwvKV3sE0KwfjGKkQF7K7qPU9qEyvoJxio
kZix6Nnm4oWEsrPpn1g3ywhiPDJrR/8cAeSTUs3Y6lVg7P6efTeKztTFOWXpLML9
9Ml+1+dOYcNrG6nMrFQCstV1U3xTevtFqseJEe8hwhX975PaxW/jJrMlE/mxIdB9
7oOzudMXHW23zRegM5NuailZuqYBjuwBAVGaBCJdGP2++GgqkAjwY/dm9JaI67n4
4qo4oVh4EXw=
=Qy5Y
-----END PGP SIGNATURE-----
--=-=-=--
