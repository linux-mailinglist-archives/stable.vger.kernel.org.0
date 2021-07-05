Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACECE3BB7EF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhGEHi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:38:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33348 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhGEHi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:38:26 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210705073548epoutp043426cfc4e50b4a75fd16cb3f57980557~O1NoXNEkw2716527165epoutp04Q
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 07:35:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210705073548epoutp043426cfc4e50b4a75fd16cb3f57980557~O1NoXNEkw2716527165epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625470548;
        bh=hQJBm6ojB/Vzv0nm/brX3rSemYL+JBpJ+gImaVxgmCg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=GGa/SQUmqqaH38/KYs8HzcPCwxLkuUk6HdjDjPH1j+7OmYdV4KnF3GpYD1M9IrI1G
         KnCAkuHlp4IrHo4UjP8SciskJHh8IJOiBBTGsLBFR3k6afctLuaoD3ssSbBl8E5tGh
         lxKE2VQ/k0hfhD2+0lYYNbEHNuHJq8IHqXBETxkY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210705073548epcas1p45298f3db1c624805fd9fd4b78af61833~O1NoCXj8g1028510285epcas1p42;
        Mon,  5 Jul 2021 07:35:48 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.160]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GJHXz2pYqz4x9Pp; Mon,  5 Jul
        2021 07:35:47 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.B2.09551.356B2E06; Mon,  5 Jul 2021 16:35:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210705073546epcas1p31117b33407359cb3ecb40c7070d27687~O1Nmyl3-52398823988epcas1p3v;
        Mon,  5 Jul 2021 07:35:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210705073546epsmtrp197160defa898a8bf6eb15728d93168c5~O1NmxPFyO3247032470epsmtrp1f;
        Mon,  5 Jul 2021 07:35:46 +0000 (GMT)
X-AuditID: b6c32a36-2b3ff7000000254f-2b-60e2b65372f0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.0C.08289.256B2E06; Mon,  5 Jul 2021 16:35:46 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210705073546epsmtip16c3b785c8a2b4973a4f7e9970935c728~O1NmohETf1023210232epsmtip1G;
        Mon,  5 Jul 2021 07:35:46 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     <Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp>
Cc:     <flrncrmr@gmail.com>, <stable@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
In-Reply-To: <OSAPR01MB45311389DB35CA9CEFEDCEF6901C9@OSAPR01MB4531.jpnprd01.prod.outlook.com>
Subject: RE: [PATCH] exfat: handle wrong stream entry size in
 exfat_readdir()
Date:   Mon, 5 Jul 2021 16:35:46 +0900
Message-ID: <004201d77170$5e9d6c50$1bd844f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHtYa6HDZ3zKB0Tzc4hP4i9K19tVAGye6HqAnn5ClWq5rSZ0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmvm7wtkcJBte6hSx61y5gs3hzciqL
        xZ69J1ksFmx8xOjA4tF8bCWbx85Zd9k9Pm+SC2COyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
        NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFV
        Si1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIybh2cSNTwWGBiobNj1kaGD/wdjFyckgI
        mEi0rp3I1sXIxSEksINR4tOl3YwQzidGiUOtG5ggnM+MEq9/n2aDaek7NYkZxBYS2MUocfB8
        PUTRC0aJLVM72EESbAK6Ev/+7Adq4OAQETCSeHqyECTMLBAqMbthK1gvp0CsxMVlq1lAbGEB
        f4kjr88zgtgsAioSs5f/BIvzClhKHLn/hh3CFpQ4OfMJC8QcbYllC18zQ9yjIPHz6TJWEFtE
        wEmit2k6G0SNiMTszjZmkNskBL6ySyy5tpIVosFF4uKd4ywQtrDEq+Nb2CFsKYmX/W1QdrnE
        iZO/mCDsGokN8/axg/wiIWAs0fOiBMRkFtCUWL9LH6JCUWLn77mMEGv5JN597WGFqOaV6GgT
        gihRlei7dBhqoLREV/sH9gmMSrOQPDYLyWOzkDwwC2HZAkaWVYxiqQXFuempxYYFRshRvYkR
        nA61zHYwTnr7Qe8QIxMH4yFGCQ5mJRFekSmPEoR4UxIrq1KL8uOLSnNSiw8xmgKDeiKzlGhy
        PjAh55XEG5oaGRsbW5iYmZuZGiuJ8+5kO5QgJJCeWJKanZpakFoE08fEwSnVwNS95tLXVu31
        7wpyH7zf9mwyd5XJE6cKOWlTfvU36WmmpzsiNTWLZfx/PrkgqMYj/e6vV9fdzPDAxVwzEkX2
        TjvMNd1uBfviykZuB/vIiVJz7S4y/7gdMPO+2q5J8paOl7gdb8z4r5D16Ov1nhvpty67WO9N
        /dH4pPpJ4Yc/d/bfzKyeZ8IQ5KbJdkYmZoH361KntdkWW1hcFXeHdszturB0wa4H/DXxj3b3
        dc739nB2fjt/wr+fm+5rub/o3lwd0D7xtoD4+p5vj6xV/t2cZph9IXvK0UunpYLq7vCfD75S
        mPdE1DVkOkf0aW8Jw2eSm241/2s3a3yYEJMUeFNA8KbL7EMSv2JVVlkFGfIsna7EUpyRaKjF
        XFScCABueMylEAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSnG7QtkcJBus+mlj0rl3AZvHm5FQW
        iz17T7JYLNj4iNGBxaP52Eo2j52z7rJ7fN4kF8AcxWWTkpqTWZZapG+XwJUx//FCloLt/BWL
        Z9xma2BcxdPFyMkhIWAi0XdqEnMXIxeHkMAORonGGTOZIBLSEsdOnAFKcADZwhKHDxdD1Dxj
        lGiY3sgGUsMmoCvx789+NpAaEQEjiacnC0HCzALhEreOPmOCqL/HKLFl2UNmkASnQKzExWWr
        WUBsYQFfiUcnvzGC2CwCKhKzl/8Ei/MKWEocuf+GHcIWlDg58wkLxFBtiac3n8LZyxa+Zoa4
        U0Hi59NlrCC2iICTRG/TdDaIGhGJ2Z1tzBMYhWchGTULyahZSEbNQtKygJFlFaNkakFxbnpu
        sWGBUV5quV5xYm5xaV66XnJ+7iZGcGxoae1g3LPqg94hRiYOxkOMEhzMSiK8IlMeJQjxpiRW
        VqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAFMwrvOjeAfP3fis+
        2vlvedXiKBx86NmrRVk3Fk3y2jz5fLzyBa6vJVpBzr8frNLMvPE47oDpZiXW8x2XZzX3bX57
        k/ew/POT2VGN5XLHj3rfmlO8yLFGdeNG2wblie99WZbfTco8sWXTis97Lu1LXMt0aOe2BRG2
        M+9+rNt8ehHzzYoEL53nJ5XM/wZ4TSpTZ7WKVTjzLfzp53MWVxNnaORZtl67xWq0KJ/fn+f5
        G9bK+PvzPqZMdn3d/MF5Xea5k3wNZ6NNvkuKFmlPnft+XnCHs8qlc/HNB1KuPQzeXCW788J2
        9sqwtIeXpiimH3aT2bBi7+LDMZcFYzS8z0TH27MEm8xN/160YlX0w8IvnVpKLMUZiYZazEXF
        iQDH92ui/AIAAA==
X-CMS-MailID: 20210705073546epcas1p31117b33407359cb3ecb40c7070d27687
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210611004956epcas1p262dc7907165782173692d7cf9e571dfe
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
        <20210611004024.2925-1-namjae.jeon@samsung.com>
        <OSAPR01MB45311389DB35CA9CEFEDCEF6901C9@OSAPR01MB4531.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > The compatibility issue between linux exfat and exfat of some camera
> > company was reported from Florian. In their exfat, if the number of
> > files exceeds any limit, the DataLength in stream entry of the
> > directory is no longer updated. So some files created from camera does
> > not show in linux exfat. because linux exfat doesn't allow that cpos be=
comes larger than DataLength
> of stream entry. This patch check DataLength in stream entry only if the =
type is ALLOC_NO_FAT_CHAIN
> and add the check ensure that dentry offset does not exceed max dentries =
size(256 MB) to avoid the
> circular FAT chain issue.
>=20
> Instead of using fsd to handle this, shouldn't it be left to fsck?
Yes, That's what I thought at first. And fsck.exfat in exfatprogs can detec=
t it like this.

=24 fsck.exfat /dev/sdb1
exfatprogs version : 1.1.1
ERROR: /DCIM/344_FUJI: more clusters are allocated. truncate to 524288 byte=
s. Truncate (y/N)? n

>=20
> In the exfat specification says, the DataLength Field of the directory-st=
ream is the entire size of
> the associated allocation.
> If the DataLength Field does not match the size in the FAT-chain, it mean=
s that it is corrupted.
Yes. I have checked it.
>=20
> As you know, the FAT-chain structure is fragile.
> At runtime, one way to detect a broken FAT-chain is to compare it with Da=
taLength.
> (Detailed verification is the role of fsck).
> Ignoring DataLength during dir-scan is unsafe because we lose a way to de=
tect a broken FAT-chain.
>=20
> I think fsd should check DataLength, and fsck should repair DataLength.
But Windows fsck doesn=E2=80=99t=20detect=20it=20and=20it=20shows=20the=20a=
ll=20files=20normally=20without=20any=20missing=20ones.=0D=0AIt=20means=20W=
indows=20exfat=20doesn't=20also=20check=20it=20in=20case=20type=20is=20ALLO=
C_FAT_CHAIN.=0D=0A=0D=0A>=20=0D=0A>=20As=20for=20the=20256MB=20check,=20I=
=20think=20it=20would=20be=20better=20to=20have=20it.=0D=0A>=20=0D=0A>=20BR=
=0D=0A>=20---=0D=0A>=20Kohada=20Tetsuhiro=20<Kohada.Tetsuhiro=40dc.Mitsubis=
hiElectric.co.jp>=0D=0A=0D=0A
