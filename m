Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F9C479803
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 02:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhLRBbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 20:31:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:44015 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhLRBbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 20:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639791084; x=1671327084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wggVBZPndJwL3wpuF76fjqTUVVIppnY5YbRwVqgaM7E=;
  b=lz+3HVlza9sKZU85yF6bUnBqKjj2QSgBz9jfKC1nTiX5bWBIFTSc61VB
   i0fjL2uujZ8M/EWeLDEDHQJ+MdcKdxWXs6utRewxpv/EGTOFe+ljYLsIf
   IDor7+z3p4Cb/16o+YKiy6MIuE9mJuLaZCW9X3NPaeTl5vkghAuq2G71D
   tZW2PP3ybZB2eZYMK93QMMwXIgCQ12UTUNsv+N400Bfl9oDatnZY3oEz1
   0IyoZL0ZdDewxhOGExEI10/YYOKgbLME+2sJSw64yNmnkToJ76aqc5UGN
   /hJ5HOk9yp+CmGRhUs8ookAxD+IyCjPNxhgANTz+ixml0aps5hrByaQ91
   w==;
IronPort-SDR: qKOBw4vyrfifFP2PA5Wj6IerDXDE9s5H8DlTnCokPwiAhX0cid6+Qb9Qm6N7gP1Ecz5alXuogt
 GdGc9tWAv0zrYtvBr3oIN5KGnLiMLwJit4G6/zVLoJAMe7PBWc8XdOM3a/iYBnewk5Y3PF83i1
 f3PYfQP+2MniVs+/E5WgdWu4N64yWIG2uKGQX0ItK286PnmqeFaZwQ8HZoBmGsHupPmP7lZHoT
 1euL2qd6IoE7klVbyE1TAuUUWNfpx1dwugEZbdDB+yba0NCGZvC8oMUlq+HSyTYUKrLOjhZjRy
 BvnqoBnu6vlZK1v/YW6IuAJr
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="147084900"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 18:31:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 18:31:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 18:31:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCllmc5bV8vexKuDDvhdAe9j2C7G0PpyH9Pz6lHwy2owPD+Y5K1pQGnSA2FEVivabKgN2WZi6nA8vwHJ+ROIqxKO51DUch/Rvy//jwqYWnWFNihJ5Ulx7HnuRVJt61ygW2ZiSKKvS37x4z1nYxYalriiY3WfMQ2wpVj4scypFDXugRPRF32In7Hl41T3o8+HQgF2fYBlpZ9VPFpAFj97zNPgJjxBCUGBXEfe3ocHdggM+JmFTt98YEnaMFiQhe0O/vZ+OCI/l21Z3MVHyXy3I4OfEj323KYt4k/WWhTHFNGpTdRQ8jPF8oeCfYtUCFcK8NkbzOGPfHOVXAsmXGtWvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wggVBZPndJwL3wpuF76fjqTUVVIppnY5YbRwVqgaM7E=;
 b=DnRsrULNdYuMoexUuMRK1nbP4Fcye89zkVhPXmC6sKJIOmA/PSpZg/qq6H5i4YPwvbWVWATve3X71ZQirEC7YjELVkmVOlaEKMK/+3b6/yu6kDXQdR5UjereNTsCnK0mCuLHnRwNLwkwrTUhQH1Yfa/gHb9eNj/V/72zqc3W+AeXeaYgrcCVpjDDNQL4X3zBY8y7dw93gOjzxI5O7AA0xeYrkoTzu5IgzeQVv4WhPAGwF3C46IqVcaTxIaWpDkeNNceqUEPxAvTMrDVz5moHXxKIBDn2sl6LHjGYehcu2yoAd7WgxA6VcGo8R69NDf0E94VN81oDB7fg1cQoRT1/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wggVBZPndJwL3wpuF76fjqTUVVIppnY5YbRwVqgaM7E=;
 b=LEl/ugj2rWQ+aH3uJn1CYMoz05cQwssPIs3pf6n4SridKFjaMESixjPFs7qd+7WFPMcItLnDvFawOYxyQvgE34uCNg8Q/i76qakok2RiDYsBtXgSq4+pHb4Uzn8vzo32e5pMqZFY9LpqfnJZOJ2rzRCHY1b+r/EfrI/KhhSB+h0=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB3056.namprd11.prod.outlook.com (2603:10b6:805:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 01:31:17 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::5c96:23c3:4407:d3b1]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::5c96:23c3:4407:d3b1%9]) with mapi id 15.20.4778.018; Sat, 18 Dec 2021
 01:31:17 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>, <linux-mtd@lists.infradead.org>
CC:     <p.yadav@ti.com>, <michael@walle.cc>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Thread-Topic: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Thread-Index: AQHX867zGrsgvJvvRkumR0zAW0g6cQ==
Date:   Sat, 18 Dec 2021 01:31:17 +0000
Message-ID: <0cabce03-bc22-eb3d-fa77-a1f5f787784d@microchip.com>
References: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f56ed9b0-d40e-48b5-7509-08d9c1c616ab
x-ms-traffictypediagnostic: SN6PR11MB3056:EE_
x-microsoft-antispam-prvs: <SN6PR11MB3056E1CBC56CEBD29DD11D87F0799@SN6PR11MB3056.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AkMpa0MjxAqVwXS15kHeH+8+EmRNJ3eXoKdX58hAzCTp6K05eO3XMwDX7zdtpmVUHGEU03BIpIZv3diw1p9n11FThp36WZEBJOtTZVmNNgnXzBbIt6MibCv+3hivBl3WkLQJSXoPNy3vKOit+1Pvq9U6eX5cQNYLVG6hD/HE8tcIvnrHETZe9FCuFHgGRbWnEgLqOWIHNDCqd44x2wljszdzD/Rx7rAn46wyLVzkY8PKUxwnvDoCFAczHOGAU/NjDAYMA0/mcIyF9lLZHX3mDUCMFjMHI4WVsVA6urn8O0KaLBiTT3pjBFghM5wIHBlAJi3vxadk/lQRG9BvCBwyYE99GlfHwxoId46tb8QyT1Xu3oI4iNxKESFOUKOrdiNUA0JR/6W2tva16YIoembjOXtRrazKrZnubCqyC7U1C2sIh/s9Tl3KH8D4N9wg8Y5LSZd6FVW/Rmgsu8BP0nmgTOypCMEnLfeynusOHUoETLk6+BeaXDZ/NtKOQdRq3zkWP6R+bSwjx1Uc7ML34yKMufmQY132tEMn/Ye3SZE4wBXe5CfzL4TM2OYNJGKbPrz7d5MKAjbDlgl96+/xz5Kx1J7pUUo/YOv6ZGMy7o8UQU2BqwHUr6mEu177e1SM42KwO9kAxbBhOo4rbwayvYSedfyLvy4v3FcqXdY86lAyZXsH8ZzIWb0vQA83sresVAgWAsr7vQp4J0N4N9x1rKKIn207SYUBGNVf1HikJ7QbU3/uQ1qOxAoj7JLYZawCVtXXgUGMzCDrpOI1m/49GRdQvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(26005)(31686004)(91956017)(83380400001)(186003)(86362001)(38100700002)(508600001)(53546011)(76116006)(66476007)(64756008)(6506007)(2906002)(66446008)(31696002)(66946007)(296002)(316002)(66556008)(54906003)(4326008)(8676002)(110136005)(6486002)(122000001)(8936002)(6512007)(38070700005)(36756003)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekIyY0dhb1lTUkZXMnI0cUtCUk9xa1hHTUI5M0JxdnNqVjdvSktmVlc0N0Fo?=
 =?utf-8?B?L0lmdFRXMGVUWkV3Ni9YNktLalducys5ckJHYnhtNnhIT1F1SUcrT1NyRFJs?=
 =?utf-8?B?ZzNIUW1XZkErOXNIZ1R6dDBBN2xaQVl0YVlOMzR6ZnNSeUwvY0VyNWh5NVM5?=
 =?utf-8?B?Wkw2RnJtU1hTZU1DdUhwVjZaMWcwTWhHd2dDUE9oZ0NLa2pUQkE1cHJnUWRG?=
 =?utf-8?B?alRjbThJMk1sTTRUZUI0anpDcDcxMWRISnJOdnlsdHZLU1E5WXhKSk1yZ2tT?=
 =?utf-8?B?bmlRd3k2QXNMbTNrS3lHcFJSNEhkYy94QytUUDFNS0lUMi9mRHozR01TdU9y?=
 =?utf-8?B?Y1dLamJQRHUrd2ZFa3oyenpnUWg3QUlCM1RidFE5YVhrTmVFRVV2N09oNUJi?=
 =?utf-8?B?MnFMRlhUSnkvUTFZVXhnMVpyMTlFWFFlb3dRMThRNWN6Z01oSXBheWJEam5N?=
 =?utf-8?B?YWxzMEdxSVZQTndEOUQyNzl5TzRERys2RWljeTdBWFo2d3krOEJEc0NsV3d6?=
 =?utf-8?B?Qm9EWGwyTzZ0VVdvdXplR0VHbmN3VDZ2djV6bkdIcEYvYVlBdHUwNlRIZS81?=
 =?utf-8?B?MTFhREhIb2t6clRMMEdsSzlHSCt0VFZoMkluL2p3VUw0Nnkwc1RCMmNKcEFl?=
 =?utf-8?B?c0ZlVkJwdkt3Y1hQREQ1L0tVcUMyTkpRYUxNa1JLS3NmeklJLzBtU1BzaUJL?=
 =?utf-8?B?TnlabkxyQU1TeUZwZ0FlaGRZNTAvYldBaTBvWnVlSTlGeitKaHg2VnMvajdX?=
 =?utf-8?B?cVZSNDNuTTlYS3B3ZUNCTElNZUVRNk1Jd0tJZGplUmd5UUJHQlZkOC9TQTVj?=
 =?utf-8?B?bXFxK1MrekpoL0NCc2lmUmhWK0s3dGxOQlpPeHdBMlRxdkJScTZGS0VmRnRT?=
 =?utf-8?B?UXdVWXlRY3BpczV5Z0IvRDY2TGgvVlJOL1IzVTJMcVB2WVREcWlDUlNVN2lI?=
 =?utf-8?B?ZklvWkl4TEtwQWxKUFZ3MEY1dVJQUWJUNXM4UVQvNktuR1NEMWlBdEswQzB5?=
 =?utf-8?B?TmM4S0NwR01JdWlNL3VXakRyVm8wMjIzbi9xQWpKbTVBS0FSRDF0c2J5SWlV?=
 =?utf-8?B?dDlKQis1NHduZEh0dVlBMVI4aTFzejdiQXpDN0tHeDNVWnRMdXZOYkkzaWZJ?=
 =?utf-8?B?Tlg0d0dabVF6d2VOVUFmYmhQajJKaE9PbW9yVGFUMXJ2QjRQUW1ETHZXcHhN?=
 =?utf-8?B?S0M2a2I3dVlJQ1M2d3ByMkVVSWM5cEd3MG12a1UzM1FrRVM1Tkh2M1RhcWRN?=
 =?utf-8?B?WU1lbHp4RUtMUmV3UW1OOG4vQ1c2UW5aMVQ4eEJhaWRIWXdWRm9menZjTG9N?=
 =?utf-8?B?VjZLdWNCcUZsN3E4djNwMUh3MTJBQllKeEYyZEp2SHVVaDRzQ2ZkSmo3UnAw?=
 =?utf-8?B?OUhrNFBGWnpDWUZhQnJRRnVNR1Zpb29EaXVvbXRPZU9sa2x3MWxPaTRvdk5M?=
 =?utf-8?B?OENabmNIdG9OZkEvQ3hsRzBTRm1ZNzYxZVpRcW1haVpxZndYeDJYL0VnV0M0?=
 =?utf-8?B?dlhPKzlVVGNNTVA3UHpFLzhYVTZOc1BkM1lpYmtlTU05T2Z5YVpZUklhMksy?=
 =?utf-8?B?akR5RG9idk9xTzJjK3FNVVlGY0Z1dElocXZVamMrcFBWVEhHRXN4Q1MvV2hs?=
 =?utf-8?B?UmJqV0I3WXBEMmZDOHZTQURSYis4TzgrM0FlVy94UVNILzdwakZFT25MQWVk?=
 =?utf-8?B?QmxqTUVQZUNxQlZEYStEaXpwamxLdTlpVTVYZk10YjJwMStaclVoMERBK3da?=
 =?utf-8?B?elhySUpzWmZrNG1yNDBqYVJjMnlFc3lFaEhKLzRyZ3V0OXFTNk13MlRndlk5?=
 =?utf-8?B?ek9GWXgwNGxmMlZFNWJ6K3dFSnR2WSs2eklYQlJPM29xNi9sYU5wa3RXOEI0?=
 =?utf-8?B?aC9tVlgvTmlWWUg3eHZ5UGtKVS9rL2pXK1h6cm5QZW1lWTd6OU14bFhZZVdv?=
 =?utf-8?B?azhYZ0dCRDFFajJPY1BlV1VnRVYrTng2ckpya2J4K1FxR1Vqd0xhWjJHT1JL?=
 =?utf-8?B?ckNEQ0l3cDUrY2pPQWtsdFZKOW9EQjFKU1JYeEV3VFZob1VsK0cyYjlHS0M3?=
 =?utf-8?B?c2kvekZGeFhHTzJnWjViMGlkZ3g5OW1QWmdOdGxmZWcrRCtNeG9mRGlpT3Q2?=
 =?utf-8?B?TmVlSmp4ZUZZSmVBajVPNmxaRlZ3ZlAxNHYzdXkzY0F0TzE4WTlrMFQ5eko0?=
 =?utf-8?B?OEVmbHJnOGo4N3JRWnZhWHZ6YVFabkdMZndBNThjU2xLeXRpcTQ2WVFLRWZQ?=
 =?utf-8?B?alpUOTdBWUlhN1NMQ1lvdStzNm53PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85975FFD84A3C24C9A5E8057735780C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56ed9b0-d40e-48b5-7509-08d9c1c616ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2021 01:31:17.6431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ikPKwHFhPn/Hw5hOdJKZlGaAKBc6pdU5d4e1bUZw/UGhUDawzENS83av8eck1dch3nDECURYN+/zOwThuW2TlO7VyAzS8cwgnV9zgd5u9Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTEvMTkvMjEgMTA6MTQgQU0sIEFsZXhhbmRlciBBIFN2ZXJkbGluIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEZyb206IEFsZXhhbmRlciBTdmVy
ZGxpbiA8YWxleGFuZGVyLnN2ZXJkbGluQG5va2lhLmNvbT4NCg0KSGksIG5pY2UgdG8gaGVhciBm
cm9tIHlvdSBhZ2FpbiENCg0KPiANCj4gRXJhc2UgY2FuIGJlIHplcm9lZCBpbiBzcGlfbm9yX3Bh
cnNlXzRiYWl0KCkgb3INCj4gc3BpX25vcl9pbml0X25vbl91bmlmb3JtX2VyYXNlX21hcCgpLiBJ
biBwcmFjdGljZSBpdCBoYXBwZW5lZCB3aXRoDQo+IG10MjVxdTI1NmEsIHdoaWNoIHN1cHBvcnRz
IDRLLCAzMkssIDY0SyBlcmFzZXMgd2l0aCAzYiBhZGRyZXNzIGNvbW1hbmRzLA0KPiBidXQgb25s
eSA0SyBhbmQgNjRLIGVyYXNlIHdpdGggNGIgYWRkcmVzcyBjb21tYW5kcy4NCg0KOkQNCg0KPiAN
Cj4gRml4ZXM6IGRjOTI4NDMxNTlhNyAoIm10ZDogc3BpLW5vcjogZml4IGVyYXNlX3R5cGUgYXJy
YXkgdG8gaW5kaWNhdGUgY3VycmVudCBtYXAgY29uZiIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBTdmVyZGxpbiA8YWxleGFuZGVyLnN2
ZXJkbGluQG5va2lhLmNvbT4NCj4gLS0tDQo+IENoYW5nZXMgaW4gdjI6DQo+IGVyYXNlLT5vcGNv
ZGUgLT4gZXJhc2UtPnNpemUNCj4gDQo+ICBkcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYyB8IDIg
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYyBiL2RyaXZlcnMvbXRkL3NwaS1ub3IvY29yZS5j
DQo+IGluZGV4IDg4ZGQwOTAuLjE4M2VhOWQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbXRkL3Nw
aS1ub3IvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbXRkL3NwaS1ub3IvY29yZS5jDQo+IEBAIC0x
NDAwLDYgKzE0MDAsOCBAQCBzcGlfbm9yX2ZpbmRfYmVzdF9lcmFzZV90eXBlKGNvbnN0IHN0cnVj
dCBzcGlfbm9yX2VyYXNlX21hcCAqbWFwLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBjb250
aW51ZTsNCj4gDQo+ICAgICAgICAgICAgICAgICBlcmFzZSA9ICZtYXAtPmVyYXNlX3R5cGVbaV07
DQo+ICsgICAgICAgICAgICAgICBpZiAoIWVyYXNlLT5zaXplKQ0KPiArICAgICAgICAgICAgICAg
ICAgICAgICBjb250aW51ZTsNCg0KSSBuZWVkIGEgYml0IG9mIGNvbnRleHQgaGVyZS4gRG9lcyBt
dDI1cXUyNTZhIGhhcyBhIHVuaWZvcm0gZXJhc2UgbGF5b3V0Pw0KaS5lLiBEb2VzIHlvdXIgZmxh
c2ggaGFzIHNlY3RvcnMgb2YgbW9yZSB0aGFuIG9uZSBzaXplIG9yIGRvZXMgbm90IGFsbG93DQp0
aGUgNEsgYW5kIDY0SyBlcmFzZSB0eXBlcyB0byBiZSBhcHBsaWVkIG9uIGFsbCBzZWN0b3JzIGlu
IHRoZSA0QiBjYXNlPw0KSWYgbm8sIHlvdSBzaG91bGQgaGF2ZSBiZWVuIGluIHRoZSBzcGlfbm9y
X2hhc191bmlmb3JtX2VyYXNlKCkgY2FzZSwgYW5kDQppZiB0aGlzIGNhc2UgZG9lcyBub3Qgc3Vp
dCB5b3UsIG1heWJlIHdlIHNob3VsZCB1cGRhdGUgdGhlIGNvZGUgZm9yIHRoaXMNCnNwZWNpZmlj
IGNhc2UgaW5zdGVhZC4NCg0KT24gYSBzaG9ydCBsb29rIEkgc2VlIHRoYXQgdGhpcyBmbGFzaCBk
ZWZpbmVzIGp1c3QgQkZQVCBhbmQgNEJBSVQgdGFibGUsDQpzbyBubyBTTVBULiBJdCBsb29rcyBs
aWtlIHlvdSdyZSBmb3JjaW5nIHRoZSBmbGFzaCB0byBiZWhhdmUgYXMgaXQgaGFkIGRlZmluZWQN
ClNNUFQuIEFtIEkgd3Jvbmc/DQoNCkFsc28sIHNob3VsZCB3ZSB1cGRhdGUgdGhlIHJlZ2lvbidz
IGVyYXNlIG1hc2sgaW5zdGVhZCBhbmQgbWFzayBvdXQgdGhlDQp1bnN1cHBvcnRlZCBlcmFzZSB0
eXBlPyBJIHdvdWxkIGxvdmUgdG8gaGVhciBtb3JlIGFib3V0IHlvdXIgdXNlIGNhc2UuDQoNCkNo
ZWVycywNCnRhDQo=
