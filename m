Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE5115730
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 19:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfLFSdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 13:33:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFSdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 13:33:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6IT5ZH032279;
        Fri, 6 Dec 2019 18:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=sAEdw5Q/wvkCrDPbNNSx1a8zJTAVHvqJibGlwhRhhnw=;
 b=d2oi0D+1ml5n6QkteGnMp9C6oEEOrKiU0BNBzQ12PqYgNt/d67CCtCXjsHPh/ZXjQOfS
 bZjvEsuNAXaNpoABFXrIFWfJPspTBlLItOQLJB/uXYeG3tGEPGIC/WDTPtOFfrZpcl1w
 hkhWbB2QN2h6hNgTjXhk1B6F/CmKCGv6ash9DXsVl8sBSZoynJ1c46VSkAaukacb2BFR
 wTYayp/77ReSsTQWC96bFjnQBi8E/TxdGbpYJLp+YZQD+IMKVkpbZKszwnZPeijdSr3u
 KUtisYg6F8u8pRiNg1t57W2O9GbWseJdKljmqacFIEuIFDr18g9Xg2cT3QECRNBz2Dqs Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wkh2rwn5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 18:33:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6ITlwr097481;
        Fri, 6 Dec 2019 18:31:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wqm0sya7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 18:31:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6IUxn5026531;
        Fri, 6 Dec 2019 18:30:59 GMT
Received: from dhcp-10-154-131-158.vpn.oracle.com (/10.154.131.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 10:30:59 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH] drm/mgag200: Flag all G200 SE A machines as broken wrt
 <startadd>
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20191206100426.anifpqwckuutxxt4@sirius.home.kraxel.org>
Date:   Fri, 6 Dec 2019 12:30:56 -0600
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>, daniel.vetter@ffwll.ch,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?Q?Jos=C3=A9_Roberto_de_Souza?= <jose.souza@intel.com>,
        airlied@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Allison Randal <allison@lohutok.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3275C55D-3031-4EBC-9A76-FC0CC0B9CA02@oracle.com>
References: <20191206081901.9938-1-tzimmermann@suse.de>
 <20191206100426.anifpqwckuutxxt4@sirius.home.kraxel.org>
To:     Gerd Hoffmann <kraxel@redhat.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060150
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 6, 2019, at 4:04 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>=20
>> Several MGA G200 SE machines don't respect the value of the startadd
>> register field. After more feedback on affected machines, neither PCI
>> subvendor ID nor the internal ID seem to hint towards the bug. All
>> affected machines have a PCI ID of 0x0522 (i.e., G200 SE A). It was
>> decided to flag all G200 SE A machines as broken.
>=20
>> -	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_VENDOR_ID_SUN, 0x4852, 0, 0,
>> +	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>> 		G200_SE_A | MGAG200_FLAG_HW_BUG_NO_STARTADD},
>> -	{ PCI_VENDOR_ID_MATROX, 0x522, PCI_ANY_ID, PCI_ANY_ID, 0, 0, =
G200_SE_A },
>=20
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>



Tested-by: John Donnelly <John.p.donnelly@oracle.com>



This series of commits appear to resolve the display issue  in 5.4.-rc8 =
as reported in :

https://gitlab.freedesktop.org/drm/misc/issues/7


52ca22daadbb 2019-12-06 | drm/mgag200: Flag all G200 SE A machines as =
broken wrt <startadd>
e0f1a41a45b3 2019-12-06 | drm/mgag200: Add workaround for HW that does =
not support 'startadd'
11a219a38f2d 2019-12-06 | drm/mgag200: Store flags from PCI driver data =
in device structure
a23512ace008 2019-12-06 | drm/mgag200: Extract device type from flags

There is one commit I did  not apply :

[PATCH v2] drm/mgag200: Add module parameter to pin all buffers at =
offset 0

I don=E2=80=99t see a need for that now since we using the PCI-ID of =
0x522 for the fix. =20



>=20
> cheers,
>  Gerd
>=20
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lists.freedesktop.o=
rg_mailman_listinfo_dri-2Ddevel&d=3DDwIGaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7=
qIrMUB65eapI_JnE&r=3Dt2fPg9D87F7D8jm0_3CG9yoiIKdRg4qc_thBw4bzMhc&m=3DcFYmB=
62lgH3WoOWZuvgMKjsgMXQUscmrypDlQhYpF_E&s=3D21ZEZohFZBQsEr5bo3sS4pMpCf2ca5K=
XFJq5X3XUzQw&e=3D

