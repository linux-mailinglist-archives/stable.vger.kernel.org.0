Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E139276C6D
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 10:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIXIw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 04:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgIXIw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 04:52:28 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE4DB23772;
        Thu, 24 Sep 2020 08:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600937548;
        bh=mBjA4D2VMWYFlYuqa+60PBE7U14syE/8c8cGg3SgmXs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SxL9ACiq5PWoi3i88bsR51Ga/IdTnc94g9DcEYSkr1gEBTfBdLm7LAmc5cNCulYIO
         tZ+0MfVmxVI7KcNnUPyYCb/4r3/gGjSxASP6myLfD+4BNkfWdAFbOkFAx2jpOiP6Vz
         O85mdxkrO/zUo6e3m48OZR3EJTRJWP+2mjaxSSSM=
From:   Felipe Balbi <balbi@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Kevin Cernekee <cernekee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of
 undeclared usb_debug_root
In-Reply-To: <1600936119.21970.4.camel@mhfsdcap03>
References: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
 <871rirehqq.fsf@kernel.org> <1600936119.21970.4.camel@mhfsdcap03>
Date:   Thu, 24 Sep 2020 11:52:18 +0300
Message-ID: <87y2kzd0al.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Chunfeng Yun <chunfeng.yun@mediatek.com> writes:
> On Thu, 2020-09-24 at 10:50 +0300, Felipe Balbi wrote:
>> Chunfeng Yun <chunfeng.yun@mediatek.com> writes:
>>=20
>> > Fix up the build error caused by undeclared usb_debug_root
>> >
>> > Cc: stable <stable@vger.kernel.org>
>> > Fixes: a66ada4f241c("usb: gadget: bcm63xx_udc: create debugfs director=
y under usb root")
>> > Reported-by: kernel test robot <lkp@intel.com>
>> > Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
>>=20
>> $ patch -p1 --dry-run p.patch
>> /usr/bin/patch: **** Only garbage was found in the patch input.
>>=20
> Please try to apply v2, https://patchwork.kernel.org/patch/11772911/
> I indeed add a line code

that worked, but the problem I have is that your patches always come
base64 encoded. Make sure they come as plain text in the future :-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9sXkIRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQa0zQ/8Cj7wlmX4BmMvMJ5ZRB4QinYugLxxudcX
pe06n6i8BViYdJASEMxb0TFXAvX4ApxghdeyzPM6lr/xH87fsIH2vvrQs8HIwGH3
DirmtLbSORa6sVjysCGFW9YjtqcvENYoFwcV0QePH05ExS9nB8jsX/qZQ+W1Ga6k
edhk2a464Fbb8UkGyuXJubHZqbiYf2qXNfkXZUcA0ZSRa/k1tW9oDATyXqPL/RMZ
TYFCsAx37J+xYatVfwt55sItpUjvXEHNfPUSBqQYBivFg530tqBK+sAYPHqdOFqa
DsU/qjBwkdGRAXEdl1C3Qf7vWz9R7sXNZ1wQcY6FTx9O87KAlaadkA843QD7uasf
vZSMsivR8clEXLLZCPMWGbrj9f74lRU8XGKKDvih5c+ySKc+4nQRrBadzf4Z2Iem
Zo7CnIZG6X+aAtk5Jm6WBF4uwAXZbrCW/k0cVLHld2n9DGZW/qlZu7FZIFZrkg3i
DNK92DJIwQKBt2T1d5ljdjHD2ISYiopvWfMa0t9/MzZgrDabSzc0zn5Ensl6XMfd
Eqe03LVQ/GnZ8HdHVLte64qo7B+lROsAkCxQq1ZTXILxoV8ARTCVBb/Yu53tVBt6
5MmjHZJt6MvMLCCwzDXfOnKvz+5f0E4Yqq1TCmViQUrZTU24EUm1hK3AR+lAzt3U
HKB56BVkXzk=
=2QfB
-----END PGP SIGNATURE-----
--=-=-=--
