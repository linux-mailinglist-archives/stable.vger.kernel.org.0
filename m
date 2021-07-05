Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C083BB7A3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGEHTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:19:44 -0400
Received: from mx05.melco.co.jp ([192.218.140.145]:33610 "EHLO
        mx05.melco.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEHTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:19:44 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2021 03:19:43 EDT
Received: from mr05.melco.co.jp (mr05 [133.141.98.165])
        by mx05.melco.co.jp (Postfix) with ESMTP id 4GJGv12mqYzMsrJy;
        Mon,  5 Jul 2021 16:06:21 +0900 (JST)
Received: from mr05.melco.co.jp (unknown [127.0.0.1])
        by mr05.imss (Postfix) with ESMTP id 4GJGv12NFlzMryJZ;
        Mon,  5 Jul 2021 16:06:21 +0900 (JST)
Received: from mf04_second.melco.co.jp (unknown [192.168.20.184])
        by mr05.melco.co.jp (Postfix) with ESMTP id 4GJGv123WJzMvCm5;
        Mon,  5 Jul 2021 16:06:21 +0900 (JST)
Received: from mf04.melco.co.jp (unknown [133.141.98.184])
        by mf04_second.melco.co.jp (Postfix) with ESMTP id 4GJGv121PpzMqytD;
        Mon,  5 Jul 2021 16:06:21 +0900 (JST)
Received: from JPN01-TY1-obe.outbound.protection.outlook.com (unknown [104.47.93.55])
        by mf04.melco.co.jp (Postfix) with ESMTP id 4GJGv11pFwzMqysw;
        Mon,  5 Jul 2021 16:06:21 +0900 (JST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWyhxaWr+eK5vX3ZFSJO9wIszudVboWV5A4DNnB42GN/5ZtcnP3bBKqcnPGWUb4dDlpsQ3ii+fJ3TKSuhCbn+K6BvsixGlxOzNRIOUs9l5n7wtlzm4ONxM8NJekE0MHeXQfq1Nym6YOb6HN1+JUm/lhHa8s+x0TQuc0kZNFOk5YjsiaLjAbU31j60cl4kQvC6XG5SHyJXKWevLq2olkQLOrMMvtOWYczVgcJK69JBGu8FFViv3403EvMjvE34hQ2v8EihQBweGIH/7h+Ju8fdTETsiZsazGP0X537CfSRQ74jhIwvDdUYjlBz6QOLILnu5H+kxuahvgTAlCKJW2AZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY7SBiKv+QhAxPVIpOtyIxs+g9Nl0tYX7zDVV6Pkmlw=;
 b=Xnd3cUK55sbefJjo5L70DZj7lobW3FrFKlvIdAyzswtFP7kGp++RCcnsR7u+cMh79V7r6ehETVo8HTNg8PrP2jpvPTlHUXXxWUWHlSZ7+1pVTxfWvj6bX+3cm9d68dNCJgzbRvAIDPc2GkFt0D1mBuzciiOR/Cf8cbK12Bh0YJLsC8FpCzJiZpEylaI5C1Wwt+UULICRQUCpNk5oqV0xNj4ybKxxpxFLn9/CK5e49SgrHmdXsqSe5wRnYwmYGRzX3mEUnh1bk1vuJTT+AyaGX63xuIpVlZiykkiaKosNmN5I4wXC25BfMzk047ILfsTH+qpBHNToW1MRF1aSTHGx/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dc.mitsubishielectric.co.jp; dmarc=pass action=none
 header.from=dc.mitsubishielectric.co.jp; dkim=pass
 header.d=dc.mitsubishielectric.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mitsubishielectricgroup.onmicrosoft.com;
 s=selector2-mitsubishielectricgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY7SBiKv+QhAxPVIpOtyIxs+g9Nl0tYX7zDVV6Pkmlw=;
 b=GZIquf/ZuJX4SegC4vZvXUKrp3NY+3NaeR+CQH+J8QbLO4Tmn3C2iPtekxqTZ4Gq6Ax1KTOGIfFem8p39AR58NhIm3rzqPobVsR4cp8wy56Yiy+oAPKEujnxf+Q3RZI/yr3MhOBoQcIdhzmePPuPBVyzO8j6Bz8eV9F9CcoLHAA=
Received: from OSAPR01MB4531.jpnprd01.prod.outlook.com (2603:1096:604:6b::18)
 by OS0PR01MB5346.jpnprd01.prod.outlook.com (2603:1096:604:a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 07:06:20 +0000
Received: from OSAPR01MB4531.jpnprd01.prod.outlook.com
 ([fe80::4889:6c34:b25a:867f]) by OSAPR01MB4531.jpnprd01.prod.outlook.com
 ([fe80::4889:6c34:b25a:867f%7]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 07:06:20 +0000
From:   "Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp" 
        <Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp>
To:     "'namjae.jeon@samsung.com'" <namjae.jeon@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC:     "flrncrmr@gmail.com" <flrncrmr@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Topic: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Index: AQHXXlu4ZPuuUBCNZkORJfcd+Jgt4qs0Gf4w
Date:   Mon, 5 Jul 2021 07:04:24 +0000
Deferred-Delivery: Mon, 5 Jul 2021 07:06:00 +0000
Message-ID: <OSAPR01MB45311389DB35CA9CEFEDCEF6901C9@OSAPR01MB4531.jpnprd01.prod.outlook.com>
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
 <20210611004024.2925-1-namjae.jeon@samsung.com>
In-Reply-To: <20210611004024.2925-1-namjae.jeon@samsung.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-melpop: 1
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none
 header.from=dc.MitsubishiElectric.co.jp;
x-originating-ip: [203.178.75.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35b5f5be-4694-4b25-014c-08d93f836470
x-ms-traffictypediagnostic: OS0PR01MB5346:
x-microsoft-antispam-prvs: <OS0PR01MB5346EF50F227382C514EE651901C9@OS0PR01MB5346.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ygdck3ddky0lZpSkQruRYZWNbE6z6AX1qYMkL7j/m3rxPtA5oX4Y+TwZydBsxEDpcwWahB9mNMzkf5g08BCxRtqdrJexJ9ax5uIquKBzCADJngWUB7QIxApMaFZebh35u3sxX8ifY3/x8WBGHTxSwTov/K3a3V0q8fzHTuRFOSz2S9IWsVrXLbIFlAxBjli2V8a0UKbTGRPO6+ofSwHeTmaW61uPT2S9S8aMVxHFuQC9Gf2ziUESBTGgTmeqs3+Gi9TjgT5erc+qpJ64f+vlhQDhGBgbi/BwIXE86UqJMe5sIs2TnbGKeL5TZKlRttvV6JxkL0DJ7cGhe1qNOzPVj5JO5qFyiU5DAzk7xr3pCknCpcTLeBGy1TSBKkwODYXKSwypRxb7T48gY0+I3sRNMQqTQIUvGEBF3ez5bf4Ud7GmHS7Hk81l87Gtknk9IL6Xnuekw6RXZDXrbp4Khj7cQEnmBWSyO4vQ/a46Zd1a4Qm4mHuE0BfbrIprxDlh9rxfoL1f9kWnc71LB2KrzANl0HjZN4UHYRPye4DGyTWvE9Wh4cMyz8ezvYZDYY2dVOeQ05nQXYGtV740Ywg9d/5QEGQKZdcUSy1yhGOjjNl+SmB7gEcf3SNTalGsKvNgxIH/OJSPN45sNF63wbdVAnRHpJIuw407JldMjhLXmjtbYxv5Cr3iDkOADcbXBdwdNbdn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB4531.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(86362001)(316002)(9686003)(71200400001)(2906002)(26005)(55016002)(4326008)(38100700002)(5660300002)(110136005)(76116006)(6506007)(186003)(478600001)(66946007)(122000001)(52536014)(8936002)(66476007)(66556008)(8676002)(83380400001)(7696005)(54906003)(33656002)(66446008)(64756008)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z05mNFp3RWYyNFIxUUZxak1MRFFpSWdCMFdyejBla2tNZkdyaDU3Y3E1emRo?=
 =?utf-8?B?K1hkZ2d2RnN0Mlp4aTUxU1ArYVRXQ2Z1bUJxY1dBd1B6bmpwVEpONExVWWdQ?=
 =?utf-8?B?ek05WlY0TDkzdUZmWGwyN3FaT1g0QVQ5MUE0cHJkNkd2ZE9vR055YXZnN2NP?=
 =?utf-8?B?NnYxNy9ISkVnb0lPMFR1QWxTL0wxcDU0bm1MaC8rbTI4bWE4UERqK2wzaUJU?=
 =?utf-8?B?T0Rkem5XWXhXc25hd0RBbkw5V1l0Ukk5dCtNb3lyUWdXOGh1Tk5vVFhDbjYy?=
 =?utf-8?B?RmNJdnFxeVVUbUtKUGJmYUlaTU1ZYmdETTdHUGkyVVg1djF3bUZBZEE3cmNa?=
 =?utf-8?B?YTl3amdHbHE4VHBpZXBwek84aHoyS0pZWXdpNThrcG5HZzdFS3pKZ2hRUUt1?=
 =?utf-8?B?cTNPUWxNZy9YeHQ4cERoU3lPQU5CUXhSL3NNWmE1ekZKL0ZBSEk3WE9TM2t5?=
 =?utf-8?B?OTJ4L2dJQndmbUVYa0pxVnJQek1abi9mcDhLTW1YOFFWL0JRcmRDSjFsVWFG?=
 =?utf-8?B?aDQ3bFNKRTIydEZsbUJERFZXbFpNT1ZhVTRXT1lrV2dkZVBvclVleW96WXZq?=
 =?utf-8?B?MXpjRm9taGtEaG5CZnUwSHY0OGdsTTNObGZPcG1uZXBxSlBKK0t0RUNMTjJW?=
 =?utf-8?B?Vnd1SE5JbVAxRDBoNk9BYmJLdkVOeFVDb2k5dE1VeGpNSisrSWJXR0tzWEd5?=
 =?utf-8?B?NE4ycmhjY0FLTSt0eVBzMnJIaXZTRnhCSmNzNjVURXVZWGxhdE5sTmxkc1dI?=
 =?utf-8?B?NitnU0tlemtDa25jTG1DN2hnbmd6SEVnMUx4SzQvVTBodHg3bUFBL0pwZlVa?=
 =?utf-8?B?ZFh4SVJ1TXhmb2pWRm5BbWpyRFJkTWlsV3I4b1UyQ2pvL3prc29keG0vZmhx?=
 =?utf-8?B?MWFXMjh1TWdEaTlGR1ZBVDZBWEFBMDFyVWNJQ00xcFdVYS8yVHR1MjErZlc0?=
 =?utf-8?B?eXFRRTc5NFlobWY3R25ndDg0TitaNUN3NUdndU1RODljSEJLczFGNXZvVUhC?=
 =?utf-8?B?ZDJCQ3B4dEU1S2ZReUhpbVNjdXFjeW02K0RxemM2L3M5bm1Wc3N2LzZxYWhv?=
 =?utf-8?B?Y1R5Zk5ZZ01ZMXFNYmE4UFA3UjZhSnFsL3hWRHlmVm1iTkxUTFdxWXpYLzBn?=
 =?utf-8?B?dW1ySjRaNW9OS2NqRVJuZ3lzNkpkNVJ2NTZJejJORWtpVDZ1QnZ0NFA3cGZm?=
 =?utf-8?B?d1hMUi9IZ2lrOHhkaUJ1clBlM0ZqcUVzR3RFM2tiUG0vS0lHdUlpY1RRSk1q?=
 =?utf-8?B?eEl2SFVORk1abDhlSis2TXhnVnRDTG1aRGNFSDVUOTVZZjBKdXduTGFuOXJS?=
 =?utf-8?B?Q3BvR05vbHZ3c3dHczl1QUFPUStPUzdZR2Q4cGhINWRRUVNOcE9RZ09MWTFJ?=
 =?utf-8?B?dmxxVmRnWmhYTUlUdTUzeEtEOEN0RG1RR3VzT2QxbjlhOWc5anBnZFBSRk5P?=
 =?utf-8?B?cGJIZmV1L2paK1A0ZDJKN3B2eXB5S2dGdVJLOEpFMlluNkxCRDBtdkFpdksy?=
 =?utf-8?B?VnRFSnUzM1ZYQkRaMlFFM044MXl5YWJwOGhBZlA4RlA5NGdLZ25WQ0lYcXlS?=
 =?utf-8?B?Z1BGMFZjcTBrMnpIajYwK2wySE9JVnNLMUJsRUhaZHBSdHhtSmlONE9XRWFY?=
 =?utf-8?B?NXBHSHlSVXlOblV0MElGc0tNclVDVjlnaHB6MGluK2htMmZBQklKb2JVRW9M?=
 =?utf-8?B?bVVQTENwcU5JbUdSeFlpTkxyZ3lqS05RQWVPNER2SEpzRURiQkxZVzJQZzd2?=
 =?utf-8?Q?jVYyT2m/mI31VQE1cquwE+pJaMVO6WwTG+quvwO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dc.MitsubishiElectric.co.jp
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB4531.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b5f5be-4694-4b25-014c-08d93f836470
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 07:06:16.9995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c5a75b62-4bff-4c96-a720-6621ce9978e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdMtg0ocVZmEXDTMkBytEiXhX0DI7TD3hMbftGtnbIEU/oLa9GpQqlR/F8ZeQB6F+wH9Vzq514VN9j9o5znpHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5346
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBUaGUgY29tcGF0aWJpbGl0eSBpc3N1ZSBiZXR3ZWVuIGxpbnV4IGV4ZmF0IGFuZCBleGZhdCBv
ZiBzb21lIGNhbWVyYSBjb21wYW55IHdhcyByZXBvcnRlZCBmcm9tIEZsb3JpYW4uIEluIHRoZWly
IGV4ZmF0LA0KPiBpZiB0aGUgbnVtYmVyIG9mIGZpbGVzIGV4Y2VlZHMgYW55IGxpbWl0LCB0aGUg
RGF0YUxlbmd0aCBpbiBzdHJlYW0gZW50cnkgb2YgdGhlIGRpcmVjdG9yeSBpcyBubyBsb25nZXIg
dXBkYXRlZC4gU28gc29tZSBmaWxlcw0KPiBjcmVhdGVkIGZyb20gY2FtZXJhIGRvZXMgbm90IHNo
b3cgaW4gbGludXggZXhmYXQuIGJlY2F1c2UgbGludXggZXhmYXQgZG9lc24ndCBhbGxvdyB0aGF0
IGNwb3MgYmVjb21lcyBsYXJnZXIgdGhhbg0KPiBEYXRhTGVuZ3RoIG9mIHN0cmVhbSBlbnRyeS4g
VGhpcyBwYXRjaCBjaGVjayBEYXRhTGVuZ3RoIGluIHN0cmVhbSBlbnRyeSBvbmx5IGlmIHRoZSB0
eXBlIGlzIEFMTE9DX05PX0ZBVF9DSEFJTiBhbmQNCj4gYWRkIHRoZSBjaGVjayBlbnN1cmUgdGhh
dCBkZW50cnkgb2Zmc2V0IGRvZXMgbm90IGV4Y2VlZCBtYXggZGVudHJpZXMgc2l6ZSgyNTYgTUIp
IHRvIGF2b2lkIHRoZSBjaXJjdWxhciBGQVQgY2hhaW4gaXNzdWUuDQoNCkluc3RlYWQgb2YgdXNp
bmcgZnNkIHRvIGhhbmRsZSB0aGlzLCBzaG91bGRuJ3QgaXQgYmUgbGVmdCB0byBmc2NrPw0KDQpJ
biB0aGUgZXhmYXQgc3BlY2lmaWNhdGlvbiBzYXlzLCB0aGUgRGF0YUxlbmd0aCBGaWVsZCBvZiB0
aGUgZGlyZWN0b3J5LXN0cmVhbSBpcyB0aGUgZW50aXJlIHNpemUgb2YgdGhlIGFzc29jaWF0ZWQg
YWxsb2NhdGlvbi4NCklmIHRoZSBEYXRhTGVuZ3RoIEZpZWxkIGRvZXMgbm90IG1hdGNoIHRoZSBz
aXplIGluIHRoZSBGQVQtY2hhaW4sIGl0IG1lYW5zIHRoYXQgaXQgaXMgY29ycnVwdGVkLg0KDQpB
cyB5b3Uga25vdywgdGhlIEZBVC1jaGFpbiBzdHJ1Y3R1cmUgaXMgZnJhZ2lsZS4NCkF0IHJ1bnRp
bWUsIG9uZSB3YXkgdG8gZGV0ZWN0IGEgYnJva2VuIEZBVC1jaGFpbiBpcyB0byBjb21wYXJlIGl0
IHdpdGggRGF0YUxlbmd0aC4NCihEZXRhaWxlZCB2ZXJpZmljYXRpb24gaXMgdGhlIHJvbGUgb2Yg
ZnNjaykuDQpJZ25vcmluZyBEYXRhTGVuZ3RoIGR1cmluZyBkaXItc2NhbiBpcyB1bnNhZmUgYmVj
YXVzZSB3ZSBsb3NlIGEgd2F5IHRvIGRldGVjdCBhIGJyb2tlbiBGQVQtY2hhaW4uDQoNCkkgdGhp
bmsgZnNkIHNob3VsZCBjaGVjayBEYXRhTGVuZ3RoLCBhbmQgZnNjayBzaG91bGQgcmVwYWlyIERh
dGFMZW5ndGguDQoNCkFzIGZvciB0aGUgMjU2TUIgY2hlY2ssIEkgdGhpbmsgaXQgd291bGQgYmUg
YmV0dGVyIHRvIGhhdmUgaXQuDQoNCkJSDQotLS0NCktvaGFkYSBUZXRzdWhpcm8gPEtvaGFkYS5U
ZXRzdWhpcm9AZGMuTWl0c3ViaXNoaUVsZWN0cmljLmNvLmpwPg0K
