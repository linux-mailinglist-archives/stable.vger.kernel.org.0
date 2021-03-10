Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344633418E
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 16:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCJPbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 10:31:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46316 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhCJPbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 10:31:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615390299; x=1646926299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BQ5NEaaT2kzGvC2gV4xeKdhUXmUr+GPo2bX7sf8YDfs=;
  b=aaaxngQ13UOjnIrc4AhcKjpZYHuyIYhdhun8vn0Zu3lmVd1DyFXbxFEm
   t4F4oFevxvoEZVIlsvAo6tj7UBV2em0vKvlkpMTEdKcQwsVoHwYDeu4gu
   tGq6ziJFHq6WJc1/oLtvp48mjqwJi2oScOZeWSTwNtc/CMJ2pGZSD+vUa
   HVxnJG+Ah1Sqb/2X3LUyZY748h2fvLArbcPr0Dmu3WgQld5nDAph83DLR
   3O3pxd4BYfdhWXo1LaMlW5yu45ro+/8LCPsiM64ydLgF+i4qrNWL4PoSD
   FAPt3T6Q0ftQ6U4CYPvvzczGXTLDy2RQfULkB4lXRyp/2vZFpysX518gS
   Q==;
IronPort-SDR: lqP+lhVvYoZHa02TaRZ8JNnC+zCDPvGutN0D+nHR3S3hoBehCWYqU6xQea3DO4pElC5pHfI5yJ
 EdXyW+YE/M3sdM7uOp0hqvvXXvLcmkt8CHMjOQ0Fnro4Bug9tWPw29NIOMRgofKeHWKDba+x+l
 6dDGa7L8hdZmvwkt6BsqMsSRmYomg3orOakRcAIlCzv7xxd6Dhf+woALZVDy1SBlhR4hYtNyZh
 t1S3P6cpuYBCGWzbaK517DLAUSz7Ix8njxeTqdn/8ksXEde65Joha94vc+bRN0uPjHGndBLBF8
 9as=
X-IronPort-AV: E=Sophos;i="5.81,237,1610434800"; 
   d="scan'208";a="106652964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 08:31:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 08:31:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 08:31:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCqJb1ZVz6ElvrdDgdRrQLBF4ML7QI5nqBrmg3iB0L/lOu/ZSEEgUfoi/JZXvx9OJpjIIG2y9cWjvfh/CyJhwPTRmZgpOEbdQsovN0sql/0lyQXOeSJ9gPhZbyBibRHG58WX8r3h6NXRsiDpZw3kSBNjBgEgI0jSsWIvn2PN7W/l8uuV/FJTuVHZwafxi4w4RG0TCzik+7p49xKP49B3DuROGJ6NrbIDn+YaOvmJ6/1NongM8eh2VUZhl8e5PUZMChTaZHMyD98ZBuLZXwLPbbriNrU+ueegAZLEN4KOR3OG6KWzrkNGNAExIvI6FqF1K2N1/em1ZqehFb9CfWXHMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQ5NEaaT2kzGvC2gV4xeKdhUXmUr+GPo2bX7sf8YDfs=;
 b=kvkFS++RXVuNpjRfH4zO00aadpRDm1Ye9Kiyxvi8OZ1Gh9aa2o2+qSxjbO43bIQY3K3uAwt38B+Y6rJCGA8UQ87Qkma2OIJ7F8zjiMFJGplsxhlUfrx8FbN3B1NN0GCUo+ihMlqiDCVoOpSPZ9Ay1dUAKglLHDL8BjbG34eK2xnyFxRggLvZiOZKaSL2lO9tZSlgOoGi5omTSc73Z7Rod3jL3G960fYNcSHtv4Ns+v/8EZxeEZRc8cPKmLlYlObqCiPmXPY423pitzr2KYneLTH4/mBFdWZ6AKTF6keYstaKfQivc932raVc6lpsBswUK9E/agmwiXpN+z6usZhBhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQ5NEaaT2kzGvC2gV4xeKdhUXmUr+GPo2bX7sf8YDfs=;
 b=d4CuKoE9sqSkA9l654IGZSrFdV0r21p3jSehITGVh63CiBu/irglYNHZIte3EMFjNK4nC2izpZCAOGmjqSsspHtTuOplMPnLBa8tbMwNtOZmlLXuJZLCue16JUbu4zpOmFOVMy0Tb2YNDce2E+sHOj8Sd3C1ksrJTEhV4jvb8fg=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA2PR11MB5130.namprd11.prod.outlook.com (2603:10b6:806:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Wed, 10 Mar
 2021 15:31:37 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::c9e8:9bf4:b08c:c30f%7]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 15:31:36 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <Nicolas.Ferre@microchip.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>
CC:     <stable@vger.kernel.org>, <Sandeep.Sheriker@microchip.com>
Subject: Re: [PATCH v2] ARM: dts: at91: sam9x60: fix mux-mask to match
 product's datasheet
Thread-Topic: [PATCH v2] ARM: dts: at91: sam9x60: fix mux-mask to match
 product's datasheet
Thread-Index: AQHXFcJ1r797dPs5j0Skd/1imYqMzg==
Date:   Wed, 10 Mar 2021 15:31:36 +0000
Message-ID: <1f27858d-6779-8acb-e70a-dd58c44ade8c@microchip.com>
References: <20210308184527.33036-1-nicolas.ferre@microchip.com>
 <20210310152006.15018-1-nicolas.ferre@microchip.com>
In-Reply-To: <20210310152006.15018-1-nicolas.ferre@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [79.115.63.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60783d33-e71b-462b-5a7f-08d8e3d997d5
x-ms-traffictypediagnostic: SA2PR11MB5130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5130437096B0168254FB0C7CF0919@SA2PR11MB5130.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rCX1+FSEKLQ3fIgATwARGkU4xdfY2eg8zR8hYeyzMDelfDq9hVOk0Cw1VgJyzuXc9P4bGCSt7YlB4Inn+7UeMIiyRCUsoGLKlv6m5FxKMu7V2FrH5Yau8Dm3X1xteJe+NenNtgbURoPcfTbQaK7TPm92VQrs8bo+vKe1VBoas2De7692aldLsGseQY4AiDgrtVGDv3NI2OF+kaKaiJZDAuygpI/yKrsqN3cxgNV8309B1rUVk1PQ5bjKLPcK0X9Xkr/e9ygkJtuA+ZxtSUyxwBvNPMkpgzJZPYB67HnRGpbVGYeKsTRO61+8hcbmiF6UuuDpnhxmlCAj6TbXPqgnEtk6w3u30zsbzxk0WqmGVDAHyGAUWlIXu+F4EC9Jj2ujvg2XAtGmBes17SN3M7y71DY5g0Q0RI9wMigKRO/ZWRFabOgaB5ryXUNisDwL4diiwd8FVPWSuWne72JB/5sEG24JgQk5qVM71aSlD4bkaBSLfNiM92hRaWfLeNDMF9+E5WesA2ds+FrwB1Q3ky/At6IWdRSB0wEhHz1XZc3AKJZ53Wj0fYIZlgOewL7unjByPfKPS0qrBnKyUfEcIkFWeqS+GuRSSCnPtlLR0snatPI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(5660300002)(66446008)(76116006)(91956017)(71200400001)(64756008)(31696002)(6636002)(107886003)(6486002)(83380400001)(2616005)(4326008)(26005)(8936002)(6506007)(53546011)(6512007)(8676002)(186003)(86362001)(31686004)(66476007)(54906003)(110136005)(36756003)(316002)(478600001)(66556008)(2906002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q0E4SkJZcnZoVmtDdTQ4aHlxMjNpeE1KbU1oZ0xTRXR3Zkt6NUY1NW9ZYVlK?=
 =?utf-8?B?TC9VdmkzVWNidU84TlhvVkI5MnJxdzlZS0VVc1NFdFlFcjNBUy96K2hiSEVH?=
 =?utf-8?B?aDE0eWZJZHFYNW5wQmo0SG5jWDE5cndteTdtTUVpVWsvbFN4UnpaNlJQY0Va?=
 =?utf-8?B?MkhXcjBqMmRNdGdKQWgrbjhwK3RMb1BjMStpcUR6dmZtQ3dCMDdnaDN3aW15?=
 =?utf-8?B?YXFqcHp3SW1ZRFVEL0VyVll5TnhxUDlOb1hsQnFNT0JPMk5LalBLYVNUMWVE?=
 =?utf-8?B?Qk1EWGdJTjA3K2RIZ0hRZ0xnYmFKUW83Uy9SS2swTkpmMmZ4bmZ0b0N5MVpM?=
 =?utf-8?B?U0lHTG9EVVRPVnFjYVdwS2tRY3loaGNycW9pMkdvSnRhZmNKdHlucVJZd0ZH?=
 =?utf-8?B?UTJnYWU1VEdoR050dXVUaTNodDExWmZyR1BKQkVSbllFVmhEY2YrTWF4cGJh?=
 =?utf-8?B?WS9yQ002cHZMZ2hCSHR1MmNwVzZYMTdPVWhsSXAvNWZpeGtqV2liSEVveHV0?=
 =?utf-8?B?b3ZNcW5RTDNOMTZrTHpnVFlTaERiSnhkSlVkMTlVLzV1UERWNWE3VXBBUTA3?=
 =?utf-8?B?b2JTWkxYN25HOXVYd1F3YWtQUEhXRGdSMWdiYTAvUzRuNE1hRUlpdzhyUG1B?=
 =?utf-8?B?cCtnWk01MXd3TnZDUUI2WjBDKzJDL0pDdTU1MTZSYmNSdEdHMFZZcjZZUnd0?=
 =?utf-8?B?NzBFdE9udzNHQ2twMDR4dGZsendlamFZR2dKYS9TV1pBSTZHQlJURGhzV05O?=
 =?utf-8?B?YWZ5dTRKcTNZZTZlUVNQVlYzdXlnMzFINFA2S3lacHVCVDlNVXQyZjNVaHND?=
 =?utf-8?B?ejlhOEIxcVlYMHA0M01OR0lEcUMwYWJUbTFzdkp6cWsrSTdFc1dkM0JUSUJS?=
 =?utf-8?B?eG9MOURhNEptZ2MwWWtJN2kwb0cwaEZFN2Y3LzI0Y25XSGJFVVVXL0FLbFFN?=
 =?utf-8?B?aWkxenpOdVA3UkNHVHYxZktaeHhSeld1ZFdzK096UGFQSWdCcGs0ak1XN250?=
 =?utf-8?B?TWl0dG5FalJKSitUalYzc0poVk8vZnZKcXFLYTZmMCtHK1ZGUFJ0Vi9CazRH?=
 =?utf-8?B?OGNoMzNaT1BvT0s5MUQ5VFNubmRUdTNCUHc1aDdZNkJVUlhYN3U3TUV1b3hv?=
 =?utf-8?B?a0hHTUNZS0VtNUNCUzFZc3BUSXBzdTVaMCtMZUpFSTlad0Vyb1U0MDM1cW0y?=
 =?utf-8?B?dHR2ZXJLQ2pURXN2MHVHZktZenYyRTJndHVSY20yemloT0NMR2pyckhyYmNK?=
 =?utf-8?B?RnR5RXA3UXVZQy9zWFQ3aVR2TFRSNFJBMXAvcC9IdEFSTFFyZ09sNFJWODQr?=
 =?utf-8?B?MDFLM05YS0FCbkdRVzRWWmxsQXozREVJaWpvdm1KdGN4TGpHQWxIc00xMkFI?=
 =?utf-8?B?ZmVpekoxelg0M1Z3SnVjcjlQaCtyenlVaUVmN0JHa2RBaHZIWGNROWxhTTMz?=
 =?utf-8?B?OVFQRGpuWWFycG8xeXM5OUFGcFZ3SnlUenF2N05KUmJIaDVMdUhpZkpDcXFz?=
 =?utf-8?B?cGRhaE5Fb2t2bUFGRk42c1l0Z0c1Zk9hT2hrRmtIQTZqSWZZaTZyb1pyMzJ4?=
 =?utf-8?B?bnhDRHUrd0hOajNxbDQycmdPRmt1SmNmWFNXNjIvWXVoeEdyWFhodDhlcHE4?=
 =?utf-8?B?cUZGUzA5am4walRJUG5rQ012MHZPMnI2TmlOMFlNc0NvYmlUU0NsWGRoRldI?=
 =?utf-8?B?Q1VkazZjLy80WWxtSHBQMXBTOTNVQllQYWZZVVpnNmlEa1gwOVcwbE9ERVF4?=
 =?utf-8?Q?DOCc78tU/ZPJAT+V5g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F956C6D3732CF942A4EFBB5D589930F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60783d33-e71b-462b-5a7f-08d8e3d997d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 15:31:36.6859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFkguzIGAo07W60vuSWmJOGy/o2Js41zIK7ye42lTBwE3uDF0xnzANrsptirtYNSc8FrZw7DCgUP7cUDyAqB6mxXPoXsr3fNfS9HjUMj9YU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8xMC8yMSA1OjIwIFBNLCBuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+
IEZyb206IE5pY29sYXMgRmVycmUgPG5pY29sYXMuZmVycmVAbWljcm9jaGlwLmNvbT4NCj4gDQo+
IEZpeCB0aGUgd2hvbGUgbXV4LW1hc2sgdGFibGUgYWNjb3JkaW5nIHRvIGRhdGFzaGVldCBmb3Ig
dGhlIHNhbTl4NjANCj4gcHJvZHVjdC4gIFRvbyBtdWNoIGZ1bmN0aW9ucyBmb3IgcGlucyB3ZXJl
IGRpc2FibGVkIGxlYWRpbmcgdG8NCj4gbWlzdW5kZXJzdGFuZGluZ3Mgd2hlbiBlbmFibGluZyBt
b3JlIHBlcmlwaGVyYWxzIG9yIHRha2luZyB0aGlzIHRhYmxlDQo+IGFzIGFuIGV4YW1wbGUgZm9y
IGFub3RoZXIgYm9hcmQuDQo+IFRha2UgYWR2YW50YWdlIG9mIHRoaXMgZml4IHRvIG1vdmUgdGhl
IG11eC1tYXNrIGluIHRoZSBTb0MgZmlsZSB3aGVyZSBpdA0KPiBiZWxvbmdzIGFuZCB1c2UgbG93
ZXIgY2FzZSBsZXR0ZXJzIGZvciBoZXggbnVtYmVycyBsaWtlIGV2ZXJ5d2hlcmUgaW4NCj4gdGhl
IGZpbGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJl
QG1pY3JvY2hpcC5jb20+DQo+IEZpeGVzOiAxZTVmNTMyYzI3MzcgKCJBUk06IGR0czogYXQ5MTog
c2FtOXg2MDogYWRkIGRldmljZSB0cmVlIGZvciBzb2MgYW5kIGJvYXJkIikNCj4gQ2M6IDxzdGFi
bGVAdmdlci5rZXJuZWwub3JnPiAjIDUuNisNCj4gQ2M6IFNhbmRlZXAgU2hlcmlrZXIgTWFsbGlr
YXJqdW4gPHNhbmRlZXBzaGVyaWtlci5tYWxsaWthcmp1bkBtaWNyb2NoaXAuY29tPg0KDQpJIHdl
bnQgdGhyb3VnaCBhbGwgdGhlIHBpbnMgZGVzY3JpYmVkIGluIERTNjAwMDE1NzlELCBhbmQgSSBv
YnRhaW5lZA0KdGhlIHNhbWUgbXV4LW1hc2sgdmFsdWVzOg0KDQpSZXZpZXdlZC1ieTogVHVkb3Ig
QW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiB2MSAtPiB2
MjoNCj4gLSBtb3ZlIHRvIFNvQyBkdHNpIGZpbGU6IGl0IGFwcGxpZXMgdG8gYWxsIGJvYXJkcyB1
c2luZyB0aGUgc2FtOXg2MCBTb0MgdmVyc2lvbg0KPiAtIHVzZSBsb3dlciBjYXNlIGZvciBoZXgg
bnVtYmVycyBpbnN0ZWFkIG9mIG1peGVkIG5vbnNlbnNlDQo+IA0KPiAgYXJjaC9hcm0vYm9vdC9k
dHMvYXQ5MS1zYW05eDYwZWsuZHRzIHwgOCAtLS0tLS0tLQ0KPiAgYXJjaC9hcm0vYm9vdC9kdHMv
c2FtOXg2MC5kdHNpICAgICAgIHwgOSArKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
L2Jvb3QvZHRzL2F0OTEtc2FtOXg2MGVrLmR0cyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTEtc2Ft
OXg2MGVrLmR0cw0KPiBpbmRleCA0YzQwYWU1NzExNTQuLjc3NWNlYjNhY2I2YyAxMDA2NDQNCj4g
LS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW05eDYwZWsuZHRzDQo+ICsrKyBiL2FyY2gv
YXJtL2Jvb3QvZHRzL2F0OTEtc2FtOXg2MGVrLmR0cw0KPiBAQCAtMzM0LDE0ICszMzQsNiBAQCBl
dGhlcm5ldC1waHlAMCB7DQo+ICB9Ow0KPiAgDQo+ICAmcGluY3RybCB7DQo+IC0JYXRtZWwsbXV4
LW1hc2sgPSA8DQo+IC0JCQkgLyoJQQlCCUMJKi8NCj4gLQkJCSAweEZGRkZGRUZGIDB4QzBFMDM5
RkYgMHhFRjAwMDE5RAkvKiBwaW9BICovDQo+IC0JCQkgMHgwM0ZGRkZGRiAweDAyRkM3RTY4IDB4
MDA3ODAwMDAJLyogcGlvQiAqLw0KPiAtCQkJIDB4ZmZmZmZmZmYgMHhGODNGRkZGRiAweEI4MDBG
M0ZDCS8qIHBpb0MgKi8NCj4gLQkJCSAweDAwM0ZGRkZGIDB4MDAzRjgwMDAgMHgwMDAwMDAwMAkv
KiBwaW9EICovDQo+IC0JCQkgPjsNCj4gLQ0KPiAgCWFkYyB7DQo+ICAJCXBpbmN0cmxfYWRjX2Rl
ZmF1bHQ6IGFkY19kZWZhdWx0IHsNCj4gIAkJCWF0bWVsLHBpbnMgPSA8QVQ5MV9QSU9CIDE1IEFU
OTFfUEVSSVBIX0EgQVQ5MV9QSU5DVFJMX05PTkU+Ow0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0v
Ym9vdC9kdHMvc2FtOXg2MC5kdHNpIGIvYXJjaC9hcm0vYm9vdC9kdHMvc2FtOXg2MC5kdHNpDQo+
IGluZGV4IDg0MDY2YzEyOThkZi4uZWM0NWNlZDNjZGU2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2Fy
bS9ib290L2R0cy9zYW05eDYwLmR0c2kNCj4gKysrIGIvYXJjaC9hcm0vYm9vdC9kdHMvc2FtOXg2
MC5kdHNpDQo+IEBAIC02MDYsNiArNjA2LDE1IEBAIHBpbmN0cmw6IHBpbmN0cmxAZmZmZmY0MDAg
ew0KPiAgCQkJCWNvbXBhdGlibGUgPSAibWljcm9jaGlwLHNhbTl4NjAtcGluY3RybCIsICJhdG1l
bCxhdDkxc2FtOXg1LXBpbmN0cmwiLCAiYXRtZWwsYXQ5MXJtOTIwMC1waW5jdHJsIiwgInNpbXBs
ZS1idXMiOw0KPiAgCQkJCXJhbmdlcyA9IDwweGZmZmZmNDAwIDB4ZmZmZmY0MDAgMHg4MDA+Ow0K
PiAgDQo+ICsJCQkJLyogbXV4LW1hc2sgY29ycmVzcG9uZGluZyB0byBzYW05eDYwIFNvQyBpbiBU
RkJHQTIyOEwgcGFja2FnZSAqLw0KPiArCQkJCWF0bWVsLG11eC1tYXNrID0gPA0KPiArCQkJCQkJ
IC8qCUEJQglDCSovDQo+ICsJCQkJCQkgMHhmZmZmZmZmZiAweGZmZTAzZmZmIDB4ZWYwMDAxOWQJ
LyogcGlvQSAqLw0KPiArCQkJCQkJIDB4MDNmZmZmZmYgMHgwMmZjN2U3ZiAweDAwNzgwMDAwCS8q
IHBpb0IgKi8NCj4gKwkJCQkJCSAweGZmZmZmZmZmIDB4ZmZmZmZmZmYgMHhmODNmZmZmZgkvKiBw
aW9DICovDQo+ICsJCQkJCQkgMHgwMDNmZmZmZiAweDAwM2Y4MDAwIDB4MDAwMDAwMDAJLyogcGlv
RCAqLw0KPiArCQkJCQkJID47DQo+ICsNCj4gIAkJCQlwaW9BOiBncGlvQGZmZmZmNDAwIHsNCj4g
IAkJCQkJY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsc2FtOXg2MC1ncGlvIiwgImF0bWVsLGF0OTFz
YW05eDUtZ3BpbyIsICJhdG1lbCxhdDkxcm05MjAwLWdwaW8iOw0KPiAgCQkJCQlyZWcgPSA8MHhm
ZmZmZjQwMCAweDIwMD47DQo+IA0KDQo=
