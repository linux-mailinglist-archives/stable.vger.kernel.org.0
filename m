Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776DD4C341C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiBXR4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiBXR4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:56:01 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A07122EDD4;
        Thu, 24 Feb 2022 09:55:31 -0800 (PST)
Received: from [192.168.88.87] (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id 33CE17E2A3;
        Thu, 24 Feb 2022 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645725330;
        bh=+2Q6n+V6W/QUVCHbDod/DeNRGOAzOYkhGRDuNMN61q8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=E2QaRcCoLpYGEIpIgbTK5si7acu0t2GqY9on2BVh4VkWEgEjsTTCGRbVhwkbgksU1
         LMseucHYNleBmMC5GzJxgN0r6kfe3jg2uPG3a7U5XvTF/uZ7ti9mYPvv/NvcGuwE7I
         a2zymkNXLWb/Hdv/SwP0fRSHZS+MQM9uC4Rv5bERUh+f7tHacBcPoc+kOHaOcUUZfH
         F6MK9xxFPqghdUwgeJG8KNeuUySS7Sz73r3WOoVidWcjJoj/h8sB4MhtxRgRuy5y+F
         59zoFSaW+cTPkvzSIBmr7KDD6hSEtU5KWX9kObm/6uEGZD6ePBnTM7XTzJvJq4az8k
         EQ0b4g/PuejxQ==
Message-ID: <0fe07c68-9a8b-a7fd-31e1-6026589b7101@gnuweeb.org>
Date:   Fri, 25 Feb 2022 00:55:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
 <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Autocrypt: addr=ammarfaizi2@gnuweeb.org; keydata=
 xsBNBGECqsMBCADy9cU6jMSaJECZXmbOE1Sox1zeJXEy51BRQNOEKbsR0dnRNUCl2tUR1rxd
 M+8V9TQUInBxERJcOdbUKibS8PQRy1g8LKJO/yrrMN8SFqnxYyX8M3WDz1PWuJ7DZE4gECtj
 RPuYN978y9w7Hi6micjraQeXbNp1S7MxEk5AxtlokO6u6Mrdm1WRNDytagkY61PP+5lJwiQS
 XOqiSLyT/ydEbG/hdBiOTOEN4J8MxE+p2xwhHjSTvU4ehq1b6b6N62pIA0r6NMRtdqp0c+Qv
 3SVkTV8TVHcck60ZKaNtKQTsCObqUHKRurU1qmF6i2Zs+nfL/e+EtT0NVOVEipRZrkGXABEB
 AAHNJUFtbWFyIEZhaXppIDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz7CwJQEEwEKAD4WIQTo
 k3JtyOTA3juiAQc2T7o0/xcKSwUCYQKqwwIbAwUJBaOagAULCQgHAgYVCgkICwIEFgIDAQIe
 AQIXgAAKCRA2T7o0/xcKS0CHCAC2x/Vq6OodDFs0rCon2VBZFvnIyXIaOsJWNnIrlkNKVHWL
 QC+ALmiSwFN1822v8JP+8Fyf+HHIKVTsAPkovCnrIbliM8ZA+YTUmcLMPL+Aa05+XyZjR14l
 6Oyu9BhN7MW/XKXQnw96OE8AHpbX+Pgd4A7RtA2FGlaoBzrGlEe1B8nDBcS9ldJ0J95VKX6j
 LCJeU51msq1Q+ZyZstJ7SFsY9XKcMW7cS/aHzsayBRKtansSTkyJWCTinHn17rzkSRVcmdNY
 uga3YOBOfRIEq9LzrewE9gV40VNctY+sciMc/Z8uK5TfGIlYDTtuLmlvmw+EWjEKzwS6O0uQ
 K9YtIvl7zsBNBGECqsMBCADrprHwlhdUQBY1kzzeCozyx1AWGpyFNiFGjsRC3+UK4dhO9h6u
 Gz3OY5o0G7AV6nOniZCQofgm78NL5wdvIjL/ko5l7LNFQkU4SBjcGjn+Wc4UAWd2EpFPo/Dc
 3kTFzSlowp2+/kETA+FK7UDdwJTH/n05XwvGTZ9/pmVwP0e6iDnyJ5yIwbv28wTdIm4L3/uB
 xMp1UeHwztLk4Dcw+FX5ye/JfK3dbx0Gx8cfhAeFlVEz9z6LvtAn94BNYVd4CxE9Vh2BFFzq
 07bDQGhAN0Rim1K8uEahuKyyg2MuoDI8lvzONLbaiEw9/OgT1z+h4qyzjulXAHzxqkcjz4Of
 SqzfABEBAAHCwHwEGAEKACYWIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYQKqwwIbDAUJBaOa
 gAAKCRA2T7o0/xcKS2+RB/43pagncTq0/ywbQhjHrXtOuYDPcrbKusD1jiURWXEMgM48nV/H
 dQYTHd8mabMT0xa4NOUlDA2If2t9HvzLoNDPefP4+z41DJL6ZZNCQhLUJBh5/zhSedRF6JHW
 PiO/nWkfdUUhBTabadgUYI80djY63rG3LKmjuh3/AZ4Vb9qBVpJX0tjZSbXa47yzL7tiQ539
 u7eqoTXOy4oc5XC2koICy4DMNAEVaL2uEfY9MPHJKcsmrcwtu4w1gg8JehM/bwtphPG5J+H7
 mFZqTLyTMNfOmAKErQlwCfFzyh0uFggluVBlOLImyrKOh6+0bUZGZ0CaTE10OMTS6HgE1W10 EZJc
In-Reply-To: <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------CuQm3gWr4NdjenubnF94I8n1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------CuQm3gWr4NdjenubnF94I8n1
Content-Type: multipart/mixed; boundary="------------2pyGFgLJ0aG21VdybWcUAplV";
 protected-headers="v1"
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
 Mark Brown <broonie@kernel.org>
Cc: Daniel Baluta <daniel.baluta@nxp.com>, Jaroslav Kysela <perex@perex.cz>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Keyon Jie <yang.jie@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Rander Wang <rander.wang@intel.com>,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
 sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
 linux-kernel@vger.kernel.org
Message-ID: <0fe07c68-9a8b-a7fd-31e1-6026589b7101@gnuweeb.org>
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
 <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
In-Reply-To: <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>

--------------2pyGFgLJ0aG21VdybWcUAplV
Content-Type: multipart/mixed; boundary="------------RdGviOtezZjzD9VmFBpYPWIl"

--------------RdGviOtezZjzD9VmFBpYPWIl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMi8yNC8yMiAxMTo1MyBQTSwgUMOpdGVyIFVqZmFsdXNpIHdyb3RlOg0KPiBPbiAyNC8w
Mi8yMDIyIDE2OjUxLCBBbW1hciBGYWl6aSB3cm90ZToNCj4+IEZyb206IEFtbWFyIEZhaXpp
IDxhbW1hcmZhaXppMkBnbnV3ZWViLm9yZz4NCj4+DQo+PiBEbyBub3QgY2FsbCBzbmRfZG1h
X2ZyZWVfcGFnZXMoKSB3aGVuIHNuZF9kbWFfYWxsb2NfcGFnZXMoKSByZXR1cm5zDQo+PiAt
RU5PTUVNIGJlY2F1c2UgaXQgbGVhZHMgdG8gYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YnVnLg0KPiANCj4gUmV2aWV3ZWQtYnk6IFBldGVyIFVqZmFsdXNpIDxwZXRlci51amZhbHVz
aUBsaW51eC5pbnRlbC5jb20+DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldywgSSB3aWxsIGFw
cGVuZCB0aGlzIHRhZyBpbiB0aGUgdjIuDQoNCj4+IFRoZSBkbWVzZyBzYXlzOg0KPj4NCj4+
ICAgIDw2PlsxMDk0ODIuNDk3ODM1XVtUMTM4NTM3XSB1c2IgMS0yOiBNYW51ZmFjdHVyZXI6
IFNJR01BQ0hJUA0KPj4gICAgPDY+WzEwOTQ4Mi41MDI1MDZdW1QxMzg1MzddIGlucHV0OiBT
SUdNQUNISVAgVVNCIEtleWJvYXJkIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDox
NC4wL3VzYjEvMS0yLzEtMjoxLjAvMDAwMzoxQzRGOjAwMDIuMDAwRC9pbnB1dC9pbnB1dDM0
DQo+PiAgICA8Nj5bMTA5NDgyLjU1ODk3Nl1bVDEzODUzN10gaGlkLWdlbmVyaWMgMDAwMzox
QzRGOjAwMDIuMDAwRDogaW5wdXQsaGlkcmF3MTogVVNCIEhJRCB2MS4xMCBLZXlib2FyZCBb
U0lHTUFDSElQIFVTQiBLZXlib2FyZF0gb24gdXNiLTAwMDA6MDA6MTQuMC0yL2lucHV0MA0K
Pj4gICAgPDY+WzEwOTQ4Mi41NjE2NTNdW1QxMzg1MzddIGlucHV0OiBTSUdNQUNISVAgVVNC
IEtleWJvYXJkIENvbnN1bWVyIENvbnRyb2wgYXMgL2RldmljZXMvcGNpMDAwMDowMC8wMDAw
OjAwOjE0LjAvdXNiMS8xLTIvMS0yOjEuMS8wMDAzOjFDNEY6MDAwMi4wMDBFL2lucHV0L2lu
cHV0MzUNCj4+ICAgIDw2PlsxMDk0ODIuNjE1NDkwXVtUMTM4NTM3XSBpbnB1dDogU0lHTUFD
SElQIFVTQiBLZXlib2FyZCBTeXN0ZW0gQ29udHJvbCBhcyAvZGV2aWNlcy9wY2kwMDAwOjAw
LzAwMDA6MDA6MTQuMC91c2IxLzEtMi8xLTI6MS4xLzAwMDM6MUM0RjowMDAyLjAwMEUvaW5w
dXQvaW5wdXQzNg0KPj4gICAgPDY+WzEwOTQ4Mi42MTU2NDNdW1QxMzg1MzddIGhpZC1nZW5l
cmljIDAwMDM6MUM0RjowMDAyLjAwMEU6IGlucHV0LGhpZHJhdzI6IFVTQiBISUQgdjEuMTAg
RGV2aWNlIFtTSUdNQUNISVAgVVNCIEtleWJvYXJkXSBvbiB1c2ItMDAwMDowMDoxNC4wLTIv
aW5wdXQxDQo+PiAgICA8ND5bMTEwMTAyLjMzNTQ2MF1bVDE0MDk4NV0gcnR3Xzg4MjJjZSAw
MDAwOjAxOjAwLjA6IHRpbWVkIG91dCB0byBmbHVzaCBxdWV1ZSAxDQo+PiAgICA8Mz5bMTE4
NTc1LjczMDkyOF1bIFQxMzg3XSBzb2YtYXVkaW8tcGNpLWludGVsLXRnbCAwMDAwOjAwOjFm
LjM6IGVycm9yOiBtZW1vcnkgYWxsb2MgZmFpbGVkOiAtMTINCj4gDQo+IFdvdywgSSB3b25k
ZXIgd2hhdCBpcyBnb2luZyBvbiB0aGF0IGFsbG9jYXRpb24gZmFpbHMuLi4NCg0KQ2FuJ3Qg
cmVhbGx5IHRlbGwgdGhlIHJlYXNvbiBiZWhpbmQgdGhlIC1FTk9NRU0uDQoNCkl0J3MgaGFy
ZCB0byByZXByb2R1Y2UsIHJhbmRvbWx5IGhhcHBlbnMuIEkgaGF2ZSBoaXQgdGhpcyBidWcN
CmF0IGxlYXN0IDQgdGltZXMgb24gbXkgbGFwdG9wIHdpdGggMTYgR0Igb2YgUkFNLiBBbGwg
aGFwcGVuZWQNCnJhbmRvbWx5Lg0KDQpJIHRyaWVkIHRvIHRvcnR1cmUgdGhlIG1lbW9yeSB3
aXRoIG1tYXAoKSArIG1sb2NrKCkgKyBtZW1zZXQoKQ0KKyBzbGVlcCgpLCB0aGVuIHBsYXlp
bmcgc29tZSBhdWRpbyB3aGlsZSBhbG1vc3QgcnVubmluZyBvdXQgb2YNCm1lbW9yeSwgYnV0
IHN0aWxsIGNhbid0IHJlcHJvZHVjZSB0aGUgc2FtZSAtRU5PTUVNLg0KDQotLSANCkFtbWFy
IEZhaXppDQo=
--------------RdGviOtezZjzD9VmFBpYPWIl
Content-Type: application/pgp-keys; name="OpenPGP_0x364FBA34FF170A4B.asc"
Content-Disposition: attachment; filename="OpenPGP_0x364FBA34FF170A4B.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBGECqsMBCADy9cU6jMSaJECZXmbOE1Sox1zeJXEy51BRQNOEKbsR0dnRNUCl
2tUR1rxdM+8V9TQUInBxERJcOdbUKibS8PQRy1g8LKJO/yrrMN8SFqnxYyX8M3WD
z1PWuJ7DZE4gECtjRPuYN978y9w7Hi6micjraQeXbNp1S7MxEk5AxtlokO6u6Mrd
m1WRNDytagkY61PP+5lJwiQSXOqiSLyT/ydEbG/hdBiOTOEN4J8MxE+p2xwhHjST
vU4ehq1b6b6N62pIA0r6NMRtdqp0c+Qv3SVkTV8TVHcck60ZKaNtKQTsCObqUHKR
urU1qmF6i2Zs+nfL/e+EtT0NVOVEipRZrkGXABEBAAHNJUFtbWFyIEZhaXppIDxh
bW1hcmZhaXppMkBnbnV3ZWViLm9yZz7CwJQEEwEKAD4WIQTok3JtyOTA3juiAQc2
T7o0/xcKSwUCYQKqwwIbAwUJBaOagAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAK
CRA2T7o0/xcKS0CHCAC2x/Vq6OodDFs0rCon2VBZFvnIyXIaOsJWNnIrlkNKVHWL
QC+ALmiSwFN1822v8JP+8Fyf+HHIKVTsAPkovCnrIbliM8ZA+YTUmcLMPL+Aa05+
XyZjR14l6Oyu9BhN7MW/XKXQnw96OE8AHpbX+Pgd4A7RtA2FGlaoBzrGlEe1B8nD
BcS9ldJ0J95VKX6jLCJeU51msq1Q+ZyZstJ7SFsY9XKcMW7cS/aHzsayBRKtansS
TkyJWCTinHn17rzkSRVcmdNYuga3YOBOfRIEq9LzrewE9gV40VNctY+sciMc/Z8u
K5TfGIlYDTtuLmlvmw+EWjEKzwS6O0uQK9YtIvl7zsBNBGECqsMBCADrprHwlhdU
QBY1kzzeCozyx1AWGpyFNiFGjsRC3+UK4dhO9h6uGz3OY5o0G7AV6nOniZCQofgm
78NL5wdvIjL/ko5l7LNFQkU4SBjcGjn+Wc4UAWd2EpFPo/Dc3kTFzSlowp2+/kET
A+FK7UDdwJTH/n05XwvGTZ9/pmVwP0e6iDnyJ5yIwbv28wTdIm4L3/uBxMp1UeHw
ztLk4Dcw+FX5ye/JfK3dbx0Gx8cfhAeFlVEz9z6LvtAn94BNYVd4CxE9Vh2BFFzq
07bDQGhAN0Rim1K8uEahuKyyg2MuoDI8lvzONLbaiEw9/OgT1z+h4qyzjulXAHzx
qkcjz4OfSqzfABEBAAHCwHwEGAEKACYWIQTok3JtyOTA3juiAQc2T7o0/xcKSwUC
YQKqwwIbDAUJBaOagAAKCRA2T7o0/xcKS2+RB/43pagncTq0/ywbQhjHrXtOuYDP
crbKusD1jiURWXEMgM48nV/HdQYTHd8mabMT0xa4NOUlDA2If2t9HvzLoNDPefP4
+z41DJL6ZZNCQhLUJBh5/zhSedRF6JHWPiO/nWkfdUUhBTabadgUYI80djY63rG3
LKmjuh3/AZ4Vb9qBVpJX0tjZSbXa47yzL7tiQ539u7eqoTXOy4oc5XC2koICy4DM
NAEVaL2uEfY9MPHJKcsmrcwtu4w1gg8JehM/bwtphPG5J+H7mFZqTLyTMNfOmAKE
rQlwCfFzyh0uFggluVBlOLImyrKOh6+0bUZGZ0CaTE10OMTS6HgE1W10EZJc
=3D33gS
-----END PGP PUBLIC KEY BLOCK-----

--------------RdGviOtezZjzD9VmFBpYPWIl--

--------------2pyGFgLJ0aG21VdybWcUAplV--

--------------CuQm3gWr4NdjenubnF94I8n1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEE6JNybcjkwN47ogEHNk+6NP8XCksFAmIXxogFAwAAAAAACgkQNk+6NP8XCktD
yAf/T4uljUSGIWMgE+oacZNuKGJquNE//ZbRd0cH3gIzQP8mOMKDtWhssMv/+zXH6dXaQM2lznLc
yP7Fx9OhyTOxgYGMgdduGNM3qvpOhM+mNmiZpjfrmN/0hesAiFx5BIkeUz/HLPuTDvwJBK8IJjR+
cT8RNgzjx1zYNy9sLOTZVzng171QvxqsuyGp151Zj6sBamfXqvpbBLp6HzMLb8m3b8i23hXZUMK0
FQoU5cE3spGhxuMQIOVhwq5HkDNcsZOiN21D0hOjd4TJJ03vjSQIlzRhaGw8Ux4J0r7EU2Nh3bOi
FVxYblnYmZmYznZfb6q7l7eGm9R7nMGwUdkCpkQIHw==
=JfAe
-----END PGP SIGNATURE-----

--------------CuQm3gWr4NdjenubnF94I8n1--
