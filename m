Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090D73C417A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 05:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhGLDQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 23:16:11 -0400
Received: from mx04.melco.co.jp ([192.218.140.144]:60222 "EHLO
        mx04.melco.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhGLDQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 23:16:10 -0400
Received: from mr04.melco.co.jp (mr04 [133.141.98.166])
        by mx04.melco.co.jp (Postfix) with ESMTP id 4GNTNx38g0zMt3df;
        Mon, 12 Jul 2021 12:13:21 +0900 (JST)
Received: from mr04.melco.co.jp (unknown [127.0.0.1])
        by mr04.imss (Postfix) with ESMTP id 4GNTNx2kbBzMt0dZ;
        Mon, 12 Jul 2021 12:13:21 +0900 (JST)
Received: from mf04_second.melco.co.jp (unknown [192.168.20.184])
        by mr04.melco.co.jp (Postfix) with ESMTP id 4GNTNx2QS8zMrHLb;
        Mon, 12 Jul 2021 12:13:21 +0900 (JST)
Received: from mf04.melco.co.jp (unknown [133.141.98.184])
        by mf04_second.melco.co.jp (Postfix) with ESMTP id 4GNTNx2NxKzMs8kH;
        Mon, 12 Jul 2021 12:13:21 +0900 (JST)
Received: from JPN01-TY1-obe.outbound.protection.outlook.com (unknown [104.47.93.52])
        by mf04.melco.co.jp (Postfix) with ESMTP id 4GNTNx29bWzMr2J6;
        Mon, 12 Jul 2021 12:13:21 +0900 (JST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqwTH3he8p6XduO44NF5T7I8CyO0mhUcouUHFsuYVpAznq5ytv6a18OCzxs0VS9FWGvsE1Oz7nDBiQ6N7PT1CF7PBOi5RzNLNOHYFeq/ls5m5u40xfVEDAnrI/4HOSYRcepBoPxuauNprRDepx4tebzpc71QJdnjhMYO3KJC29K3UfLSKhsJhxtQNW4PvtQQzJgIUaehSReJgY7mf5MhGepiTjLQbD589xAhcWqpRxs5DVYSXcdoDmzkfEUR7QzgQObqfadh6PF44T7Jy6DE0wvDjkCIsGZqRhBbrYfbCSr7DF/Lqmz7QdEV/Z+2XZ9MkkmGl04BpxZ8O1wi7+dM4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upClHGFaFCjgXEWt/FlUf1D/0Fn4GBZe3DjKEdl9fcI=;
 b=bFj95YZCZqh12Z9stRChvl7078P2xzcGf9SqIHUA44kWoT3Ild41T4/g0FBbLR2Ed45zeXbqD/sepCFSw87i/U3LlEHUXKDIUI/vRRfAso4dthCXBLSqrtLs99+jxc7DDzcGH5NBRurHAALQiXUXC4mhIGiRqWCbuXvb/E4Glk/21jbLXpsCE5EJdQJV+MoVwS7fSwiAJL+vcbaTEsazHqjhrTxB5ok4wR6G0jpHp0GgQE8kwOJOZ2F1yAPIYJf3GJYt8Ly962wbQldWkNcmzfUaRqN71p5/A1TTsLsVh3yN3NY6PVLkOggtY79rYBerfEtiXxY82oTK2aR4GB8r2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dc.mitsubishielectric.co.jp; dmarc=pass action=none
 header.from=dc.mitsubishielectric.co.jp; dkim=pass
 header.d=dc.mitsubishielectric.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mitsubishielectricgroup.onmicrosoft.com;
 s=selector2-mitsubishielectricgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upClHGFaFCjgXEWt/FlUf1D/0Fn4GBZe3DjKEdl9fcI=;
 b=ComGx1OWLt2bJmcjCt78TmynhKEGxDM4nWJ33p8r1YCRZtvP4Ooqm6gBUb951AaXHgJoYwoObIr/MdG5/VCxJxg26qXeJ1A/orNgRZqRDvzrqK01FdFUHOyiabbnnDexJHybwmCXbmOe2X9Ky/6Fy5Pz+ecgru+xYJRJ7Qubf5k=
Received: from OSBPR01MB4535.jpnprd01.prod.outlook.com (2603:1096:604:76::20)
 by OS3PR01MB5990.jpnprd01.prod.outlook.com (2603:1096:604:d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 03:13:20 +0000
Received: from OSBPR01MB4535.jpnprd01.prod.outlook.com
 ([fe80::389f:1ae4:77c1:a9a9]) by OSBPR01MB4535.jpnprd01.prod.outlook.com
 ([fe80::389f:1ae4:77c1:a9a9%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 03:13:20 +0000
From:   "Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp" 
        <Kohada.Tetsuhiro@dc.MitsubishiElectric.co.jp>
To:     "'namjae.jeon@samsung.com'" <namjae.jeon@samsung.com>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "'stable@vger.kernel.org'" <stable@vger.kernel.org>,
        "'flrncrmr@gmail.com'" <flrncrmr@gmail.com>
Subject: RE: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Topic: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Thread-Index: AQHXXlu4ZPuuUBCNZkORJfcd+Jgt4qs0Gf4wgAAKBgCACrQw8A==
Date:   Mon, 12 Jul 2021 03:11:07 +0000
Deferred-Delivery: Mon, 12 Jul 2021 03:13:00 +0000
Message-ID: <OSBPR01MB4535ADA1C04EC9CC3D11D6E890159@OSBPR01MB4535.jpnprd01.prod.outlook.com>
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
        <20210611004024.2925-1-namjae.jeon@samsung.com>
        <OSAPR01MB45311389DB35CA9CEFEDCEF6901C9@OSAPR01MB4531.jpnprd01.prod.outlook.com>
 <004201d77170$5e9d6c50$1bd844f0$@samsung.com>
In-Reply-To: <004201d77170$5e9d6c50$1bd844f0$@samsung.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-melpop: 1
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none
 header.from=dc.MitsubishiElectric.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3b905e4-7248-4fe4-f094-08d944e30098
x-ms-traffictypediagnostic: OS3PR01MB5990:
x-microsoft-antispam-prvs: <OS3PR01MB59906B7BFC5118DF8243888F90159@OS3PR01MB5990.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBP+dw/GX9dVUPIEzDmbDSelUUn/2cjUI+wZ9o7CCNtZkY4zuDNBRd7IkrPFzYxKzg/qCYU7tRlOGsp6xhIe/3Z0pM5+gAagoGI07Bzio/hEt91Jj0VGOqQqE2oOsiAyN1X4RFQ8OOrtKEfPYk7A7AP+ThL1uSlsV1PaviKNAUDRvVDYqRZowYSV1fyVNmJ4oShqHIxCgTw6Lous9zjADKKcRMtDnxgQT1jZA+6dETS81gR7sU/vtd1dlvnoKFn5Jz4yfGwQKCsrgRSRkl8fuqjn1eWOxU1t7PLBhrgKOHSw28VzF4OzwqSfC7on5SHGPMKBMCkcr6N/cSpid0o/dqWMr8GQtm8r9R6XefAm06uJhR71FJ5VzTsamuqJlyfAadfFSEh9rxTGckUIlsGax4RJbC+aD4nALD5LRsd50HP4/x5L+uDEQ0gHa+APWmKfU8Hh2evDCOyD0iuBvKLuvv0BhDwwBJH4jYK0Jv8i/Kqj2raykWVzAkCEQ13Lu78NSaUVNqfVZitdRXkNpxQ8htL6ONLRRHXj0AN8rwFMdlkbYUC6A4OjeHZSb2mzy0K65zLCnYjwN5lTvfn4ImaRJ3FaEimtU1W41OeF8r9R8sBqceiYD34NUENmsRsr8Buy1UqlrwSXXdEatHXQr909YuuIuu6I0bq2+RnU2kscgvfiZJL9z3aaWxWLHtHwTHki
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4535.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2906002)(478600001)(55016002)(6506007)(66946007)(76116006)(8936002)(71200400001)(26005)(6916009)(186003)(54906003)(86362001)(316002)(66476007)(64756008)(66446008)(66556008)(9686003)(4326008)(33656002)(7696005)(5660300002)(122000001)(8676002)(83380400001)(38100700002)(6666004)(52536014)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDdWR1A2ZzBZYU1yMkRHMTVmTytuTTlwQkNwRzFmWGJESjVGRjMwMVExNHNC?=
 =?utf-8?B?bWphZFBNRzg3eENzaGFWQi9rVlgzalRMdlVsb2NwcC9MN0lueDlNZXVkcUxK?=
 =?utf-8?B?bThFMVJDU3VPL2lHREkySSsvSjFSVHkyVDI4RWwrT3JmMWkzamNRWE5wekZz?=
 =?utf-8?B?WjBrN2Jzdk9GR0lPdkhMOGRuRlVYZHRnVUhweWsrNHM5c3Q3dTZqNXNBdllD?=
 =?utf-8?B?V0M1aEF0cFQ0L1RhVm9vY1Q4S2dSRGJETWVFU0ovdTY4Tk45blpiWmtzZ1cr?=
 =?utf-8?B?SSs5TmJPRCttNGRhS0tNZ0xjSGhWMWg2ZDRXWTMweXlBckRqTGQ4RGNXaks2?=
 =?utf-8?B?Ymc4YytYVUQ4enFSN3h0TVZPS2JYVFE5OWJSakpsamVMVVVqQk5ZdGJvQUlL?=
 =?utf-8?B?TjAzNU5oMnRmVTMvZ3B2UGlHZGRmOXlRMnRxY2ZCM1psb08vWWJRbWtEZ0lD?=
 =?utf-8?B?R3JqbTNTNlVJVkZ2NWVQNkR4YWlwTUlYL29qN0ZTeUVXbXVqcElRY0t0MzdD?=
 =?utf-8?B?VjRsSmhoZUMrUzQ4OC90SEQxWGZzV2pVZkcwc3doWGZaLzJ0aTJNUjVBMGhz?=
 =?utf-8?B?amRkR3VRZ2tMWHMrUk92ZkZuNjRVMGIyai9GaWtsSTZPTXJxTnZsdUtqNDQ1?=
 =?utf-8?B?aUhBM1hmYmdmdHVOWlhSK0hTSHhOaTMzVXA2Rmh0VkUxTmVyazFncGJmNjVp?=
 =?utf-8?B?emc3WTJneXFOcVh3VDBPMkpVUlprMjZDMzBtOURoMXBmL0F1ZEc4MFpVMkxm?=
 =?utf-8?B?dTJnOFdZMEpjV0JOdDA4STdJbWphd3dHREUvbE1FVGFpWTNQMStQeTV3MThv?=
 =?utf-8?B?eWhKNmc1TVRsRExOamhkUlY0VXJ6Y2d5RFZjd0dNZmdMdDV3WjFFLzFKbThU?=
 =?utf-8?B?cmk2aS9zNDg3RTlySDdGZHNmdWJGd1FONjVyMTZraFhBYzlJZEc0NGdqaFBI?=
 =?utf-8?B?TFBIWjA5SHpPd3Bsb2VGTG0wNVJRZzRWT1d1N1JOSkNPZVNyQkVZTm9sWUZ5?=
 =?utf-8?B?MjR1Z05SWlR3V3lGMjlDVHR0L1liRlhCTWo2YzNjN1M1UzVGOTRwaTJicFA5?=
 =?utf-8?B?Q2ZodG52UnIya0FJZ3ZqNlFHWC9MWFJ2ZlBycHJLL08vRGpIVk1UL0RPY1F0?=
 =?utf-8?B?azNXcnZmeTEva1JRaHFLQ0dJZ2Q5SEpTSnVjMUpCL1pWZkUwOFNxZkdPcUZN?=
 =?utf-8?B?SDhCWUlpTmZKdkxBbEM4L2xLLytnL3N5djd5b2xwcllKTmdWR1BmQUpHakNm?=
 =?utf-8?B?Z0ljY0w1VWVuYlFmVzJ0MFd6dVpyUW5JQmhXMTVScHlLSEd3NlJxQlZIb21M?=
 =?utf-8?B?OVExY0hBMEs2R1BjWW9TYkhqejRXSmU1aGpxUm5VUS9hRmZlMmdLWFJNaWdB?=
 =?utf-8?B?aFF0WTI0bzBrK2FnSkd0SnY2SUltTGF1RGhoSVhUQ3hXM1hXaTRWZGU3K2lR?=
 =?utf-8?B?OXE3YkdoczV4YU8wUmJoNkxWbUQ1QVJHYUVFQ2xmS0crNDB4ZEhzRkU0VnFq?=
 =?utf-8?B?dkVVYkJVeEZlV29IU1NHZFhuWXk2c3BZUTA3azFSclVQdkFJMlhsMlFIN2xu?=
 =?utf-8?B?aSt2cVdpaUJDS2FKK3V1Mzl6cTZsVTRqWTRlSXdnNkY0M3pVSDdZQU5kNFVl?=
 =?utf-8?B?dm5rQU4yZlZ0VXM2eGtrMzhsd2cvRmtvUGhMUFlRNUpCWVVpdmI1a1hyTmNS?=
 =?utf-8?B?NHJISktHV3M1NGI1WlVKaVNJQ2lGS2x5aHEwVG01VjdvVzdyQmNQUVZZZG01?=
 =?utf-8?Q?sFu6S30djMC3bPTc0QmF6Cs4vPVTUei2FW+GdvM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dc.MitsubishiElectric.co.jp
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4535.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b905e4-7248-4fe4-f094-08d944e30098
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 03:13:20.7514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c5a75b62-4bff-4c96-a720-6621ce9978e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07zLlHbzIASgJDKPWJXQY9eNnmiw66MlpKg1hsijKQaObBzM9252U8Fl70u845pu/7jMnyyfFTwgHfC0vRkVdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5990
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiA+ID4gVGhlIGNvbXBhdGliaWxpdHkgaXNzdWUgYmV0d2VlbiBsaW51eCBleGZhdCBhbmQgZXhm
YXQgb2Ygc29tZSBjYW1lcmENCj4gPiA+IGNvbXBhbnkgd2FzIHJlcG9ydGVkIGZyb20gRmxvcmlh
bi4gSW4gdGhlaXIgZXhmYXQsIGlmIHRoZSBudW1iZXIgb2YNCj4gPiA+IGZpbGVzIGV4Y2VlZHMg
YW55IGxpbWl0LCB0aGUgRGF0YUxlbmd0aCBpbiBzdHJlYW0gZW50cnkgb2YgdGhlDQo+ID4gPiBk
aXJlY3RvcnkgaXMgbm8gbG9uZ2VyIHVwZGF0ZWQuIFNvIHNvbWUgZmlsZXMgY3JlYXRlZCBmcm9t
IGNhbWVyYQ0KPiA+ID4gZG9lcyBub3Qgc2hvdyBpbiBsaW51eCBleGZhdC4gYmVjYXVzZSBsaW51
eCBleGZhdCBkb2Vzbid0IGFsbG93IHRoYXQNCj4gPiA+IGNwb3MgYmVjb21lcyBsYXJnZXIgdGhh
biBEYXRhTGVuZ3RoDQo+ID4gb2Ygc3RyZWFtIGVudHJ5LiBUaGlzIHBhdGNoIGNoZWNrIERhdGFM
ZW5ndGggaW4gc3RyZWFtIGVudHJ5IG9ubHkgaWYNCj4gPiB0aGUgdHlwZSBpcyBBTExPQ19OT19G
QVRfQ0hBSU4gYW5kIGFkZCB0aGUgY2hlY2sgZW5zdXJlIHRoYXQgZGVudHJ5DQo+ID4gb2Zmc2V0
IGRvZXMgbm90IGV4Y2VlZCBtYXggZGVudHJpZXMgc2l6ZSgyNTYgTUIpIHRvIGF2b2lkIHRoZSBj
aXJjdWxhciBGQVQgY2hhaW4gaXNzdWUuDQo+ID4NCj4gPiBJbnN0ZWFkIG9mIHVzaW5nIGZzZCB0
byBoYW5kbGUgdGhpcywgc2hvdWxkbid0IGl0IGJlIGxlZnQgdG8gZnNjaz8NCj4gWWVzLCBUaGF0
J3Mgd2hhdCBJIHRob3VnaHQgYXQgZmlyc3QuIEFuZCBmc2NrLmV4ZmF0IGluIGV4ZmF0cHJvZ3Mg
Y2FuIGRldGVjdCBpdCBsaWtlIHRoaXMuDQo+IA0KPiAkIGZzY2suZXhmYXQgL2Rldi9zZGIxDQo+
IGV4ZmF0cHJvZ3MgdmVyc2lvbiA6IDEuMS4xDQo+IEVSUk9SOiAvRENJTS8zNDRfRlVKSTogbW9y
ZSBjbHVzdGVycyBhcmUgYWxsb2NhdGVkLiB0cnVuY2F0ZSB0byA1MjQyODggYnl0ZXMuIFRydW5j
YXRlICh5L04pPyBuDQo+IA0KPiA+DQo+ID4gSW4gdGhlIGV4ZmF0IHNwZWNpZmljYXRpb24gc2F5
cywgdGhlIERhdGFMZW5ndGggRmllbGQgb2YgdGhlDQo+ID4gZGlyZWN0b3J5LXN0cmVhbSBpcyB0
aGUgZW50aXJlIHNpemUgb2YgdGhlIGFzc29jaWF0ZWQgYWxsb2NhdGlvbi4NCj4gPiBJZiB0aGUg
RGF0YUxlbmd0aCBGaWVsZCBkb2VzIG5vdCBtYXRjaCB0aGUgc2l6ZSBpbiB0aGUgRkFULWNoYWlu
LCBpdCBtZWFucyB0aGF0IGl0IGlzIGNvcnJ1cHRlZC4NCj4gWWVzLiBJIGhhdmUgY2hlY2tlZCBp
dC4NCj4gPg0KPiA+IEFzIHlvdSBrbm93LCB0aGUgRkFULWNoYWluIHN0cnVjdHVyZSBpcyBmcmFn
aWxlLg0KPiA+IEF0IHJ1bnRpbWUsIG9uZSB3YXkgdG8gZGV0ZWN0IGEgYnJva2VuIEZBVC1jaGFp
biBpcyB0byBjb21wYXJlIGl0IHdpdGggRGF0YUxlbmd0aC4NCj4gPiAoRGV0YWlsZWQgdmVyaWZp
Y2F0aW9uIGlzIHRoZSByb2xlIG9mIGZzY2spLg0KPiA+IElnbm9yaW5nIERhdGFMZW5ndGggZHVy
aW5nIGRpci1zY2FuIGlzIHVuc2FmZSBiZWNhdXNlIHdlIGxvc2UgYSB3YXkgdG8gZGV0ZWN0IGEg
YnJva2VuIEZBVC1jaGFpbi4NCj4gPg0KPiA+IEkgdGhpbmsgZnNkIHNob3VsZCBjaGVjayBEYXRh
TGVuZ3RoLCBhbmQgZnNjayBzaG91bGQgcmVwYWlyIERhdGFMZW5ndGguDQo+IEJ1dCBXaW5kb3dz
IGZzY2sgZG9lc27igJl0IGRldGVjdCBpdCBhbmQgaXQgc2hvd3MgdGhlIGFsbCBmaWxlcyBub3Jt
YWxseSB3aXRob3V0IGFueSBtaXNzaW5nIG9uZXMuDQo+IEl0IG1lYW5zIFdpbmRvd3MgZXhmYXQg
ZG9lc24ndCBhbHNvIGNoZWNrIGl0IGluIGNhc2UgdHlwZSBpcyBBTExPQ19GQVRfQ0hBSU4uDQoN
Ck9rYXksIEkgZ2V0IGl0Lg0KQmVjYXVzZSBpZiBvdXIgZHJpdmVyIGFib3J0cyBzY2FubmluZywg
dGhlIGZpbGVzIGFmdGVyIHRoYXQgd2lsbCBub3QgYmUgdmlzaWJsZS4NCklmIEZBVC1DaGFpbiBp
cyBjb3JyZWN0IGFuZCBEYXRhTGVudGggaXMgaW5jb3JyZWN0LCAgdGhpcyBwYXRjaCB3b3JrcyBz
YWZlbHkuKGFzIHRoZSBjYXNlIG9mIEZ1amkpDQpIb3dldmVyLCBpZiBEYXRhTGVudGggaXMgY29y
cmVjdCBhbmQgRkFULUNoYWluIGlzIGluY29ycmVjdCwgaXQgaXMgdW5zYWZlLg0KVGhlcmUgaXMg
YSByaXNrIG9mIGRlc3Ryb3lpbmcgb3RoZXIgZmlsZXMvZGlycy4NCg0KVGhlIGN1cnJlbnQgaW1w
bGVtZW50YXRpb24gc2V0cyBTQl9SRE9OTFkgd2hlbiBpdCBkZXRlY3RzIGEgZGlyZWN0b3JpZXMg
RkFULUNoYWluIGNvdW50IGFuZCBEYXRhTGVudGggY29udHJhZGljdGlvbiBpbiBleGZhdF9maW5k
X2xhc3RfY2x1c3RlciggKS4NCkl0IG9ubHkgd29ya3Mgb25seSBvbiBleGZhdF9hZGRfZW50cnko
KS9leGZhdF9yZW5hbWVfZmlsZSgpL2V4ZmF0X21vdmVfZmlsZSgpLg0KDQpXaHkgZG9uJ3Qgd2Ug
ZG8gYSBzaW1pbGFyIGNoZWNrIGZvciBleGZhdF9yZWFkZGlyKCkvZXhmYXRfZmluZF9kaXJfZW50
cnkoKT8NCkp1c3QgZG8gZXhmYXRfZnNfZXJyb3IoKSBpZiB0aGUgZGVudHJ5IHBvc2l0aW9uIGV4
Y2VlZHMgRGF0YUxlbnRoIGluIHRoZSBzY2FuIGxvb3AuDQpUaGlzIHdpbGwgcmVkdWNlcyB0aGUg
cmlzayBvZiBkZXN0cm95aW5nIG90aGVyIGZpbGVzL2RpcnMgYW5kIHByb21wdHMgdGhlIHVzZXIg
Zm9yIGZzY2suDQoNCg0KPiBGaXhlczogY2EwNjE5NzM4MmJkICgiZXhmYXQ6IGFkZCBkaXJlY3Rv
cnkgb3BlcmF0aW9ucyIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjUuOQ0KPiBS
ZXBvcnRlZC1ieTogRmxvcmlhbiBDcmFtZXIgPGZscm5jcm1yQGdtYWlsLmNvbT4NCj4gUmV2aWV3
ZWQtYnk6IFN1bmdqb25nIFNlbyA8c2oxNTU3LnNlb0BzYW1zdW5nLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogTmFtamFlIEplb24gPG5hbWphZS5qZW9uQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGZz
L2V4ZmF0L2Rpci5jIHwgOCArKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9leGZhdC9kaXIuYyBi
L2ZzL2V4ZmF0L2Rpci5jIGluZGV4IGM0NTIzNjQ4NDcyYS4uZjRlNGQ4ZDk4OTRkIDEwMDY0NA0K
PiAtLS0gYS9mcy9leGZhdC9kaXIuYw0KPiArKysgYi9mcy9leGZhdC9kaXIuYw0KPiBAQCAtNjMs
NyArNjMsNyBAQCBzdGF0aWMgdm9pZCBleGZhdF9nZXRfdW5pbmFtZV9mcm9tX2V4dF9lbnRyeShz
dHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCAgc3RhdGljIGludA0KPiBleGZhdF9yZWFkZGlyKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIGxvZmZfdCAqY3Bvcywgc3RydWN0IGV4ZmF0X2Rpcl9lbnRyeSAqZGly
X2VudHJ5KSAgew0KPiAgCWludCBpLCBkZW50cmllc19wZXJfY2x1LCBkZW50cmllc19wZXJfY2x1
X2JpdHMgPSAwLCBudW1fZXh0Ow0KPiAtCXVuc2lnbmVkIGludCB0eXBlLCBjbHVfb2Zmc2V0Ow0K
PiArCXVuc2lnbmVkIGludCB0eXBlLCBjbHVfb2Zmc2V0LCBtYXhfZGVudHJpZXM7DQo+ICAJc2Vj
dG9yX3Qgc2VjdG9yOw0KPiAgCXN0cnVjdCBleGZhdF9jaGFpbiBkaXIsIGNsdTsNCj4gIAlzdHJ1
Y3QgZXhmYXRfdW5pX25hbWUgdW5pX25hbWU7DQo+IEBAIC04Niw2ICs4Niw4IEBAIHN0YXRpYyBp
bnQgZXhmYXRfcmVhZGRpcihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3QgKmNwb3MsIHN0cnVj
dCBleGZhdF9kaXJfZW50DQo+IA0KPiAgCWRlbnRyaWVzX3Blcl9jbHUgPSBzYmktPmRlbnRyaWVz
X3Blcl9jbHU7DQo+ICAJZGVudHJpZXNfcGVyX2NsdV9iaXRzID0gaWxvZzIoZGVudHJpZXNfcGVy
X2NsdSk7DQo+ICsJbWF4X2RlbnRyaWVzID0gKHVuc2lnbmVkIGludCltaW5fdCh1NjQsIE1BWF9F
WEZBVF9ERU5UUklFUywNCj4gKwkJCQkJICAgKHU2NClzYmktPm51bV9jbHVzdGVycyA8PCBkZW50
cmllc19wZXJfY2x1X2JpdHMpOw0KPiANCj4gIAljbHVfb2Zmc2V0ID0gZGVudHJ5ID4+IGRlbnRy
aWVzX3Blcl9jbHVfYml0czsNCj4gIAlleGZhdF9jaGFpbl9kdXAoJmNsdSwgJmRpcik7DQo+IEBA
IC0xMDksNyArMTExLDcgQEAgc3RhdGljIGludCBleGZhdF9yZWFkZGlyKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIGxvZmZfdCAqY3Bvcywgc3RydWN0IGV4ZmF0X2Rpcl9lbnQNCj4gIAkJfQ0KPiAgCX0N
Cj4gDQo+IC0Jd2hpbGUgKGNsdS5kaXIgIT0gRVhGQVRfRU9GX0NMVVNURVIpIHsNCj4gKwl3aGls
ZSAoY2x1LmRpciAhPSBFWEZBVF9FT0ZfQ0xVU1RFUiAmJiBkZW50cnkgPCBtYXhfZGVudHJpZXMp
IHsNCj4gIAkJaSA9IGRlbnRyeSAmIChkZW50cmllc19wZXJfY2x1IC0gMSk7DQo+IA0KPiAgCQlm
b3IgKCA7IGkgPCBkZW50cmllc19wZXJfY2x1OyBpKyssIGRlbnRyeSsrKSB7IEBAIC0yNDUsNyAr
MjQ3LDcgQEAgc3RhdGljIGludCBleGZhdF9pdGVyYXRlKHN0cnVjdCBmaWxlICpmaWxwLA0KPiBz
dHJ1Y3QgZGlyX2NvbnRleHQgKmN0eCkNCj4gIAlpZiAoZXJyKQ0KPiAgCQlnb3RvIHVubG9jazsN
Cj4gIGdldF9uZXc6DQo+IC0JaWYgKGNwb3MgPj0gaV9zaXplX3JlYWQoaW5vZGUpKQ0KPiArCWlm
IChlaS0+ZmxhZ3MgPT0gQUxMT0NfTk9fRkFUX0NIQUlOICYmIGNwb3MgPj0gaV9zaXplX3JlYWQo
aW5vZGUpKQ0KPiAgCQlnb3RvIGVuZF9vZl9kaXI7DQoNClRoaXMgY2hlY2sgaXMgbm8gbG9uZ2Vy
IG5lY2Vzc2FyeS4NCkluIHRoZSBjYXNlIG9mIEFMTE9DX05PX0ZBVF9DSEFJTiwgdGhlcmUgaXMg
YSBjaGVjayBmb3IgaV9zaXplIGluIGV4ZmF0X3JlYWRkaXIoKSwgd2hpY2ggaXMgYSBkb3VibGUg
Y2hlY2suDQpJbiB0aGUgcGFzdCwgaXQgd2FzIHBvc3NpYmxlIHRvIHNraXAgY2hhaW4gdHJhY2tp
bmcgaW4gdGhlIGNhc2Ugb2YgQUxMT0NfRkFUX0NIQUlOLCBidXQgdGhhdCBlZmZlY3QgaXMgYWxz
byBnb25lLg0KDQo+IA0KPiAgCWVyciA9IGV4ZmF0X3JlYWRkaXIoaW5vZGUsICZjcG9zLCAmZGUp
Ow0KDQoNCkJSDQpLb2hhZGEgVGV0c3VoaXJvIDxLb2hhZGEuVGV0c3VoaXJvQGRjLk1pdHN1Ymlz
aGlFbGVjdHJpYy5jby5qcD4NCg==
