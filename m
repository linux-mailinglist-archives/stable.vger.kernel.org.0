Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83EB38C0DF
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 09:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhEUHpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 03:45:15 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:43175 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232255AbhEUHpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 03:45:14 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 21 May 2021 00:43:45 -0700
Received: from smtpclient.apple (unknown [10.200.196.160])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 5915D204C7;
        Fri, 21 May 2021 00:43:50 -0700 (PDT)
From:   Alexey Makhalov <amakhalov@vmware.com>
Message-ID: <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_B8B8270D-7D38-4ABC-96B6-1332ACFCDE75";
        protocol="application/pgp-signature"; micalg=pgp-sha256
MIME-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH] ext4: fix memory leak in ext4_fill_super
Date:   Fri, 21 May 2021 00:43:46 -0700
In-Reply-To: <YKc6fidMj95TZp2w@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <stable@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20210428221928.38960-1-amakhalov@vmware.com>
 <YKc6fidMj95TZp2w@mit.edu>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Received-SPF: None (EX13-EDG-OU-001.vmware.com: amakhalov@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_B8B8270D-7D38-4ABC-96B6-1332ACFCDE75
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Ted,

Good point! This paragraph can be just dropped as the next one
describes the issue with superblock re-read. Will send v2 shortly.

Thanks,
=E2=80=94Alexey

> On May 20, 2021, at 9:43 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> On Wed, Apr 28, 2021 at 10:19:28PM +0000, Alexey Makhalov wrote:
>> I've recently discovered that doing infinite loop of
>>  systemctl start <ext4_on_lvm>.mount, and
>>  systemctl stop <ext4_on_lvm>.mount
>> linearly increases percpu allocator memory consumption.
>> In several hours, it might lead to system instability by
>> consuming most of the memory.
>>=20
>> Bug is not reproducible when the ext4 filesystem is on
>> physical partition, but it is persistent when ext4 is on
>> logical volume.
>=20
> Why is this the case?  It sounds like we're looking a buffer for each
> mount where the block size is not 1k.  It shouldn't matter whether it
> is a physical partition or not.
>=20
> 				- Ted


--Apple-Mail=_B8B8270D-7D38-4ABC-96B6-1332ACFCDE75
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmCnZLMACgkQGW4w8Www
aSWuuQ//YDhZN9HmbzxFs42QbryuoIiEAh62NvTjUhAdhPijNJWuXc0rlyT6HdEh
i1sOOyDYEGcjJokGjOWkQ2kW+yI2uVoohyqKrCXfo9Q0r9nbXIA7O+IKOLk0nRa1
an8gAjeWi6DJJie7jTKDMySG3x7P4j28S4P06kRJmNJEZaw/zaTI1jJyp0x98ifz
m1LdgMiKJB+Z4CTnBE/B2RiAIH3CRVPBdL1DJL/LU7q/m0Y6/7LHGa8iQTvEkhdo
hoIYYzGp8w9uIr+HNRR+FrvVV5sUsusbxI0GmOTR2S6njayyExO6BRsJ29yBJ8Qn
P5/NggB6KtYGhpnK9KemoxNmAaJQ0vQTtzed0U0vdqRJscV2wk8fwYBOsZyZsvWZ
OLIDr2WTl2p9mAoU8vOgnizDlbksVOZAuhq1WtcE951dqNDQ+i9UD4KYPr8oEcFN
B8wQa9qeHltkHjU/OzarXy+qUR8yH1Apbp4TWuUdiZccFDgZGzgxHwM1agpTLX9S
9VWQ0Gsl/tR1VI2oxUV32QvFLDvih6B/AvcOZnzsgQXRp8LnKhP1v77HxSPyzw7V
bluA8b4Gv4/LT0qN9Hbjh2Uu7ULuHAUvWlPhYtX/vTEIpEJjXo3vycNl31+Xbi+X
IZwhZzOB0yK771VHIlo4M/wVSYnQcruP2XqeH8nduIzJUoU6LD8=
=RB1O
-----END PGP SIGNATURE-----

--Apple-Mail=_B8B8270D-7D38-4ABC-96B6-1332ACFCDE75--
