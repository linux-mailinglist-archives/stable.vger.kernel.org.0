Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1245A673
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhKWPYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 10:24:09 -0500
Received: from esa.hc188666.iphmx.com ([68.232.145.191]:46342 "EHLO
        esa.hc188666.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhKWPYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 10:24:09 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 10:24:09 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=conduent.com; i=@conduent.com; q=dns/txt; s=sept2021;
  t=1637680861; x=1669216861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AJgvszs+Z558AROchdGR5NGEJ2pBiMVJ8PZUeJeRukI=;
  b=FtzBmpL5BpflvL8MIxzQx7sJqszBPSciQ2w67N+j++IoYEuGLMZhS725
   nCPckeVBv/uJ6tWGJW6r6a2CK94lze4edMl5b9brdL6ozK4y3VJrML44E
   +Yp89sMv2SWqenXIH4AlcK+TZBYmTAmyMgJPlynVc5sMR+xw5XUN5szUc
   Xij3N+rYWwoyw7ob/izdO7/n2qYsqV0KYBmf5gfxMOTplTISerqCy2PV8
   3i3q7roi0h3ign6c2weX3Evv5uj+tvZLQ51+MWWvUL2o8RGLoueHTD0aX
   ZzvNdlLkwgk2Uz6HMSwyUkpAWqnThqMa/+9kZ+KZF0I9lF/7w0/yDduN3
   A==;
X-IronPort-AV: E=Sophos;i="5.87,258,1631595600"; 
   d="scan'208";a="208608565"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hc188666.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 09:13:48 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NswOLZV0nly1bIOhAp2MRBhI2Qg90SP3TFKHf/GreyvbVwJT+2zOnotzYNw/ClmsEjp0RNwLM1cK5JxV+dF9QEf2h3lhrasRanJ1uNmZcf4zA2nQf2orAmGuHYKqaTQPh72KgcJ2je1+NZj2K8ptTdyMTBGRLBdAuhYjjIWt01XbvAZ5cuIBqq5oJ62NweHbu+IPUsZ7pKdPiSuQf2yh81Sc6hIhR8z4sfL+NHPZASthxQI2ij+kBqGKUXVdh/9xm89cKGFr/Ltx7kSkiFZqyXKZVryIgPjGSzKC/r2d3MuivRQAKsdSHcKjEsKqISz52wqBC4v/qsvJMui8pMYg9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJgvszs+Z558AROchdGR5NGEJ2pBiMVJ8PZUeJeRukI=;
 b=BgGiJ9kCeK0x9g9gcu1RurgXrhj7HP05FbJN1EFCC0+VWC8PyNQH1mP1vsNbq5IWnNCWEUSe+Jkacq2cGYYiWc7usfdQrG4l0qnmRwTQ20MhSVxWPsIa9CphRb4shkC8R9tttcVM+HWUbMuvtYe2QZz7kCz7yhqBMUL6LIwg/CKDXXNjYaRoKFTjjkTNpSgNWkkfLHiL/d2LcPRce/0+bJtdhvIuH2juWFKh47jtYn52jlHIV4CekfvbKillCKuZ0OdksTN8SKiFLHzxujkpUakWyGPE7MNOQ6jgxDVBrlk7eprnXcOzOWqf+wHfDknCz2qV9F1cKFUadYxyvwLf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=conduent.com; dmarc=pass action=none header.from=conduent.com;
 dkim=pass header.d=conduent.com; arc=none
Received: from BN8PR20MB2674.namprd20.prod.outlook.com (2603:10b6:408:8e::17)
 by BN7PR20MB3569.namprd20.prod.outlook.com (2603:10b6:406:b3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 15:13:47 +0000
Received: from BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325]) by BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325%2]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 15:13:46 +0000
From:   "Fernandes, Francois" <Francois.Fernandes@conduent.com>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
CC:     "webmaster@kernel.org" <webmaster@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [External] - Re: EOL Kernels versions
Thread-Topic: [External] - Re: EOL Kernels versions
Thread-Index: AdfgUJIys2sQaThVQNmvMpZAGmTDrAAJvjmAAAEv8jA=
Date:   Tue, 23 Nov 2021 15:13:46 +0000
Message-ID: <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
In-Reply-To: <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=conduent.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4d67ea0-1a09-4d33-4883-08d9ae93d8bc
x-ms-traffictypediagnostic: BN7PR20MB3569:
x-microsoft-antispam-prvs: <BN7PR20MB35694BF13F3A6B430DD9B311F8609@BN7PR20MB3569.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Ube7RuU6fPahZnvsMWLagA7RvP6/k7LkcPgabT14NS35r5/zGniCh/YCSv6C8m1ohN/Ewens8hx6BBRG6RpeeKKI6Bmba4VpNbbabaEKxynrpfEglfuBYWUHPELj7qYso9FjOUEC0xBOQadCS3pFhjxKZlga8NMYzU1zjM6sEtVOGJ7Lxpw57XWttv1nvCSqXZwcJ4DQQfEq/2Z9PqpPb2z+uCyzyLsNWcaHW9NbhY3an+Ai+20X8GCkIbuZQ5um31f/o+lvmuL/FmwsezZ15jRxOZtEj1qL0MIfk19s/jnSfKhYbeZ06nDJ5lnVLETtieAEfoH+3LgMGzBSJDca3uBwUJmh/A64uDQa5DujcUKtIbvHjIbuTpCdbHKv6Lz3bK0PNI94rgud7L+YcYitsC8+fWPBgWewi0nGOKNZ7e3WE8jFfb5DvjsfBnhnv3Pg5tsZJecY5efcL5bsZg350/ZUm+VoEHnP6+0HCHmga1ekDIn2YU2/9TgT+tkqhhbOJCGOp951Uux98D0cmACl0ODygHFiLwzbqvwD/EAJt4ywofRV9X2nGR3QKii52luWj7uEpehIHDzLfiq53uLZTx8P39gEt3o5oWxt0Shy5Uk09iaQTqUlPDW/cw9xNnKeZvLKzI4ev8VqqnqvJtvGNJ1eTKYgUZT9ETxL7l2oJ3TmYFgn2xWEOyLd6SXurlTEt4Jh09BzFYHEorqvEUpV3XTWntQQ63+/xzjAycCV9mqpdmbGcoKHdfQzFwY4hiV2RDAD5OeHtneC+hqviYgMijjOL9R2QPTS5O45zFvr7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR20MB2674.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(66556008)(52536014)(64756008)(66476007)(66446008)(82960400001)(26005)(4326008)(38100700002)(186003)(9686003)(33656002)(5660300002)(122000001)(55016003)(66574015)(38070700005)(2906002)(6916009)(966005)(8676002)(7696005)(54906003)(83380400001)(508600001)(76116006)(6506007)(86362001)(316002)(8936002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkN3R0h5YW1lVGdRYXByU09UNDI4Q2djT3lpQ0FjSXcxcG5xazMvQlcybXQw?=
 =?utf-8?B?NkNzRWZmc2pGMEE4QWw5bzdIaUozZEUyNzVsV2RHdEx5UTA2NEJqWW9pNU1m?=
 =?utf-8?B?Q0MyRXJ3aS9YeUdWRHNLdEV3YVBpVU1FdnB1OTd6MkV4R0diZG5kYzhJb0I3?=
 =?utf-8?B?ZTl5RkREQWVsVEl4dnJVUzJJTStkWGh5RVNvM2NhRXpYdWNKQzI1bFk5UHBN?=
 =?utf-8?B?QUxsUGwvNWNISTdCUmk5S2tISm5pYXNGbG5VU1pNSCtNTENDOGExdXIya2Ni?=
 =?utf-8?B?WExUTHM4YUUxY3lOdmtpS3ZKdExLeVhOTlh2eEwxbDB4K1Q5MUVNT2d2NGZy?=
 =?utf-8?B?YWFBVndvVDlqTHRlbjJLMnRDamM2S01RWmJhcDVKSTRCQ0s5bWszR2R6UE8y?=
 =?utf-8?B?aU95NDJ3NFhjdGNVbUJ0bWd3YU1tN2daM2tYUWlvMndlbmt3a0NKOG1kRGN0?=
 =?utf-8?B?WUg2SXp0aThwdkdVbVZ6UEtEeXJhYWhtM0RBUzI1UXR2OGlXRXFaamVrazVT?=
 =?utf-8?B?aFlGM0xURnppbXZGejBXc21LdDVGTVVvVUJSMFRrRkVZVkpWNnh6VXRhOHY1?=
 =?utf-8?B?WDhLL3hvWE9YWVk3V25DNXpIZXhkdUNNYVBnOU5GTUJiVWE0by9aZEdzRnpQ?=
 =?utf-8?B?WGVNRnc5ZnE2RmZ3dFdDN3Znd2JrcTdTMktsaU9pSUdIaEEwZitVMkVqZ05z?=
 =?utf-8?B?NGJzeExjNmQwZ1dxdGdKZGtnSFVWZWEwYlJnNE5JWFRsV2p5Zllsb1NyLzNK?=
 =?utf-8?B?VytZQnlzeDlRaDZSQm42VWc4THRDZlVkeTZ1dThWTDVBQm9ndVBpZnQvdVgz?=
 =?utf-8?B?WmhZL1FKOVdBejUzb21yUnBSeWdYdmR4aW1pUStNMHNuSmZjb1M2RFc1VEVM?=
 =?utf-8?B?azlOdnk0M2E0Wmt4L0pQL01iV0R5WmJlVjRwaXhYdDNhVWw1dDY5eHlUY3c4?=
 =?utf-8?B?UVZiMzNUTG1ua2p5cFJ5UXArVHc0b2ZPMTJHb1EvUnlUVkRzbTFsdzRUWkJZ?=
 =?utf-8?B?QjVUbHdNWVZNV3AwVSt4c3dWenBtZWFHOTcyYnhGQ0xRS2gzMzlCTnJxQnFG?=
 =?utf-8?B?WDQrWEFITkJBcWl0ajQ3bnpFWjdmbi9ldW1JMXlzSXZsZW5LTGF6MThXSnFo?=
 =?utf-8?B?ZlpkN09EQXlYeU9ONzZ3RkJaMGFZS1hQQjEyM3I2WUU0T2JCYzArQTkxOFd1?=
 =?utf-8?B?S3orSmpkb28wc0QvMXQrVXlYSDhuZm5XR2RzNW9oKzMzU3htajJUNkpIanlI?=
 =?utf-8?B?a1VOdC81RlE4eDVDQ0t4V0Evd3NKNlJOMDA2V3lienYyWFlWR25QQ0dQZXpu?=
 =?utf-8?B?V3B1QWNPMldGN2Z5cDBRZFJPaHIzMlo1Y2tHQ2tUN3I4OVRBYS9DbmtpQ2F5?=
 =?utf-8?B?MkJjY2VKbStkNHdrK1R1TWV5VWtZQUliWHIvNG9aUTdkbi9pZG1ZZ3Fab09t?=
 =?utf-8?B?NlEzTUFaSXlKOXgzVG9PeGtFa3liMTRwTXlUSldhTW9iQjd0TDRuWkY2cFBi?=
 =?utf-8?B?YWxjcG41VlNhRWZ0WCtudDRrVVIxb2JUZmNFU1NXT21PVlVVMHV2THlhM0dD?=
 =?utf-8?B?T3ZQdm5YNmNDVkJBb1g5dlovaGhaak4xVk9ldG9wcUJxMDAzV3pyemZwaEZp?=
 =?utf-8?B?dzRyQXREL2d2ZHRmMEN1RWdma3JPN2dVMUM1WWxPWEg3ZEEreU5ZRlgxMW1X?=
 =?utf-8?B?WThPTmVDelEyeXM1OG5uU1ExVjhLVkEwNXFoaVljL2NUbndPaytHT1ZXN2J5?=
 =?utf-8?B?MHZocGhTM3k0YzJHOWcrdEZGWi91TS9XMUg5TDZtQy91TktQVCtuTU02OElp?=
 =?utf-8?B?bEV4dTRBK0FiMGhUS1ZyRTZ1QXJZdnh6anNpUVRrWWFqUHAxS1oyY21GZXJT?=
 =?utf-8?B?UmlUUzJJWDU3SjEwM1YzbGl3VFIwVnJ5NHNpdzdOa05FUlNnRjZ5T21HbVdj?=
 =?utf-8?B?aEF1ZjVqTXZzWnVQSWdYREdYekJONjJvSUlPc0xOM0JMRzVDZEswbTdSNFJU?=
 =?utf-8?B?MlJDUEhDcXRQRmsrS2tUSGRTNEJQSitpVGkvV3c0c1g1TmlUZzhoTW1rdGE5?=
 =?utf-8?B?UUxaMGRWL1JlSEF3Q2kwV1B4dXV1YVB6cjRneS94azNVRDFKVDE5SlVlQWF6?=
 =?utf-8?B?L1hkbFVHeERPemNHRkptUmdESlNRcDlDei84Q1Mxa290Z0RxNEg5bUVEOVR5?=
 =?utf-8?B?dkUxRE40VXl5cFNVRzQyZnIva2JSeFFOVTZMNTNYdkUvTit1TnVwTkRCVlcv?=
 =?utf-8?B?eldhd2xzbVlQS3J1TStmYVpEcEFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: conduent.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR20MB2674.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d67ea0-1a09-4d33-4883-08d9ae93d8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 15:13:46.7770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1aed4588-b8ce-43a8-a775-989538fd30d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BoYvjUxjn7oaST/Mendr0PzZACN1SqHXD24YIv91LltUcExIlo1x7YTqrrQxyHn0nPqphajUecTKLcMMad8cJy4scLnmFfecVa3Kzf2334s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR20MB3569
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgS29uc3RhbnRpbiwNCg0KVGhhbmtzIGEgbG90IGZvciB5b3VyIHF1aWNrIGFuc3dlci4NCg0K
SSBmb3VuZCBzb21lIGNvbXBsZW1lbnRhcnkgaW5mb3JtYXRpb24gaGVyZSA6DQpodHRwczovL2l0
c2Zvc3MuY29tL3doeS1kaXN0cm9zLXVzZS1vbGQta2VybmVsLw0KDQpJdCBzZWVtcyB0aGF0IGV2
ZW4gaWYgdGhlIGtlcm5lbCB2ZXJzaW9uIGlzIEVPTCBpdCdzIG5vdCBhIG1hdHRlciB3aGlsZSB0
aGUgZGlzdHJpYnV0aW9uIHZlcnNpb24gKGluIG91ciBjYXNlIERlYmlhbiAxMCAoQnVzdGVyKSBp
cyBzdGlsbCB1bmRlciBzdXBwb3J0Lg0KSXMgbXkgdW5kZXJzdGFuZGluZyBjb3JyZWN0ID8NCg0K
QW5kIGlzIHRoaXMgaW5mb3JtYXRpb24gdHJ1ZSA/DQoNClRoYW5rcyBhZ2FpbiBmb3IgeW91ciBh
cHByZWNpYXRlZCBoZWxwLg0KQmVzdCByZWdhcmRzLg0KRnJhbsOnb2lzDQotLS0tLU1lc3NhZ2Ug
ZCdvcmlnaW5lLS0tLS0NCkRlwqA6IEtvbnN0YW50aW4gUnlhYml0c2V2IDxrb25zdGFudGluQGxp
bnV4Zm91bmRhdGlvbi5vcmc+IA0KRW52b3nDqcKgOiBtYXJkaSAyMyBub3ZlbWJyZSAyMDIxIDE1
OjM3DQrDgMKgOiBGZXJuYW5kZXMsIEZyYW5jb2lzIDxGcmFuY29pcy5GZXJuYW5kZXNAY29uZHVl
bnQuY29tPg0KQ2PCoDogd2VibWFzdGVyQGtlcm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCk9iamV0wqA6IFtFeHRlcm5hbF0gLSBSZTogRU9MIEtlcm5lbHMgdmVyc2lvbnMNCg0KDQoN
ClRoaXMgZW1haWwgaXMgZnJvbSBhbiBleHRlcm5hbCBzb3VyY2UuICBVc2UgY2F1dGlvbiByZXNw
b25kaW5nIHRvIGl0LCBvcGVuaW5nIGF0dGFjaG1lbnRzIG9yIGNsaWNraW5nIGxpbmtzLg0KDQog
DQoNCk9uIFR1ZSwgTm92IDIzLCAyMDIxIGF0IDEwOjA1OjIwQU0gKzAwMDAsIEZlcm5hbmRlcywg
RnJhbmNvaXMgd3JvdGU6DQo+IEhpLA0KPiANCj4gRmlyc3Qgb2YgYWxsIHRoYW5rcyBmb3IgeW91
ciB2ZXJ5IGludGVyZXN0aW5nIHdlYnNpdGUuDQo+IFdlIGNvbnRhY3QgeW91IHRvZGF5IGJlY2F1
c2Ugd2UgYXJlIGxvb2tpbmcgZm9yIGFuIGluZm9ybWF0aW9uIHJlZ2FyZGluZyB0aGUgS2VybmVs
cyB2ZXJzaW9ucy4NCg0KPiBXZSBhcmUgdXNpbmcgdGhlIGZvbGxvd2luZyB2ZXJzaW9uIDogS2Vy
bmVsIFY1LjRWMjANCj4gDQo+IFJlZ2FyZGluZyB5b3VyIHRhYmxlIGhlcmV1bmRlciwgd2UgdW5k
ZXJzdGFuZCB0aGF0IHRoaXMgdmVyc2lvbiB3aWxsIGJlIEVPTCBpbiBEZWNlbWJlciAyMDI1Lg0K
PiANCj4gW2NpZDppbWFnZTAwNC5qcGdAMDFEN0UwNUEuMDdGNzYwNTBdDQo+IA0KPiBDb3VsZCB5
b3UgcGxlYXNlIGFkdmlzZSA6DQo+IC0gV2hhdCB3aWxsIGhhcHBlbmVkIGluIEphbnVhcnkgMjAy
NiA/DQoNClR3byB0aGluZ3M6DQoNCjEuIG1vc3QgbGlrZWx5OiBhIGZpbmFsIDUuNC54IHZlcnNp
b24gd2lsbCBiZSByZWxlYXNlZCBhbmQgbm8gbmV3IDUuNC54DQogICB2ZXJzaW9ucyB3aWxsIGJl
IHByb3ZpZGVkIGFmdGVyIHRoYXQgKG1lYW5pbmcgbm8gbmV3IHNlY3VyaXR5IG9yIGJ1ZyBmaXhl
cyksDQogICBvcg0KMi4gbGVzcyBsaWtlbHk6IHNvbWVvbmUgZWxzZSB3aWxsIHN0ZXAgdXAgdG8g
bWFpbnRhaW4gdGhlIDUuNCBzZXJpZXMgaW5zdGVhZA0KICAgb2YgdGhlIGN1cnJlbnQgc3RhYmxl
IGtlcm5lbCB0ZWFtLCBpbiB3aGljaCBjYXNlIHRoZSBFT0wgZGVhZGxpbmUgd2lsbCBiZQ0KICAg
ZXh0ZW5kZWQgZnVydGhlcg0KDQo+IC0gSXMgdGhlIGV2b2x1dGlvbiB0byBhIG5ld2VyIHZlcnNp
b24gaW1wZXJhdGl2ZSA/DQoNClllcy4gSXQgaXMgbmV2ZXIgYSBnb29kIGlkZWEgdG8gcnVuIGEg
a2VybmVsIHZlcnNpb24gdGhhdCBpcyBubyBsb25nZXIgcmVjZWl2aW5nIHNlY3VyaXR5IHVwZGF0
ZXMgLS0gdW5sZXNzIHlvdXIgZGV2aWNlcyBydW4gY29tcGxldGVseSBvZmZsaW5lIHdpdGggbm8g
ZXh0ZXJuYWwgaW5wdXQgb2YgYW55IGtpbmQuDQoNCk5vdGUsIHRoYXQgeW91IGRvbid0IGhhdmUg
dG8gd2FpdCBmb3IgdGhlIDUuNC54IHRvIHJlYWNoIEVPTCBiZWZvcmUgeW91IHBsYW4geW91ciBz
d2l0Y2ggdG8gYSBuZXdlciBMVFMgdHJlZS4gWW91IHNob3VsZCBwcmVwYXJlIGZvciBpdCB3ZWxs
IGluIGFkdmFuY2UuDQoNCj4gLSBJcyB0aGlzIGV2b2x1dGlvbiBhIGRpZmZpY3VsdCBvcGVyYXRp
b24gPw0KDQpUaGVyZSBpcyBubyBzaW1wbGUgYW5zd2VyIHRvIHRoaXMgcXVlc3Rpb24uIEl0IGdy
ZWF0bHkgZGVwZW5kcyBvbiBob3cgeW91IHVzZSB0aGUga2VybmVsIGZvciB5b3VyIHByb2plY3Qu
IElmIHlvdSBtYWludGFpbiBtYW55IGN1c3RvbSBrZXJuZWwgbW9kdWxlcywgdGhlbiBwb3J0aW5n
IHRoZW0gdG8gYSBuZXdlciB2ZXJzaW9uIG9mIHRoZSBrZXJuZWwgY2FuIHJlcXVpcmUgc29tZSBl
ZmZvcnQuIElmIHlvdSBhcmUgdXNpbmcgYSB2YW5pbGxhIGtlcm5lbCB2ZXJzaW9uIHJ1bm5pbmcg
b24gY29tbW9uIGhhcmR3YXJlLCB0aGVuIHN3aXRjaGluZyB0byBhIG5ld2VyIGtlcm5lbCB0cmVl
IGNvdWxkIGJlIHZlcnkgZWFzeS4gSW4gYW55IGNhc2UsIHlvdSBzaG91bGQgcGxhbiBvdXQgcHJv
cGVyIGRldmVsb3BtZW50IGFuZCB0ZXN0aW5nIHJlc291cmNlcy4NCg0KPiBUaGFua3MgaW4gYWR2
YW5jZSBmb3IgeW91ciBoZWxwIG9uIHRoaXMgc3ViamVjdC4NCg0KSSBoYXZlIGNjJ2QgdGhlIHN0
YWJsZSBsaXN0LCB3aGVyZSB5b3UgY2FuIGdldCBmdXJ0aGVyIGhlbHAgZm9yIHF1ZXN0aW9ucyB5
b3UgbWF5IGhhdmUuDQoNCi1LDQo=
