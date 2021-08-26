Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DA43F831E
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 09:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbhHZHav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 03:30:51 -0400
Received: from mail-eopbgr1320084.outbound.protection.outlook.com ([40.107.132.84]:30144
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234415AbhHZHau (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 03:30:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv1u+Mi2qmzSC74r4c2A3A079O1rRWspKyTNamfFYBAIuQnfXLHds3bc6hNSncKgWkEtHvwoOgMTnl3CwGQyFxa0QCvYd/qEKThhTdiKbS2JxdYvDG0v8KsROMMGeNtwx+Ott2TGR3Btin9rDcIW/CMGGVFTm95u1eEUZWmSL9amEXgyGIdXE3HajcdpcgxbMVKEgQV5XqjKwCLVs+v+ZB/CWm0GS3hkv7DmXaN3x/vlEeP0VpJyVfhiXkYDyW25YVTrjy8XOUlayapagOppcS+Y7/s5j/r2WxjJcAAlbdMD4DCO/+Ce9/hUGYOWg5inbQ3/MBrjGtabs42cqo4JRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SybVc6vlZUFk8nCH/o/OHpyAkA/Gqkb2ouKSmtGs8Q=;
 b=KFPq6fLsnKxPNtUsOs4+7O9NrptZPuPCibPnIx9xBHeAKxxtY88C8hM8dJprT9tnNkOwo0b6BIhn3PK1ALUHGw+eaIB8Mg/ZEWrA8c8XItiNGaKnpVOBGV/vypOZmMSrBcql+ftKz6gGlzeEv8Ir8YPY+ZLC38QyWLs+I/twIw4Z6/aJzeG6DxXDHDgGA/UYIww30THEwcuztDaRxdVGBVE5MoOM/yJ/9vvgCTvh9NlUoesxaRT3J3XKVPn6lzSjmK50TG54gcjmyvJDUQhyAeW0L8XMQctx3XUUyOCO7gaTnray6DUFCPMkojRf2xEQqSjaKiGVqDLf+5GWpRf2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SybVc6vlZUFk8nCH/o/OHpyAkA/Gqkb2ouKSmtGs8Q=;
 b=YoGmlZqJgqniUhouZEVMdDSM9ZzfzR73Esp4sz27RebWzwtf9dMA+1Yqgrpg4bUa7fuqmmfVqTIq4ZMGhJV6zevXcJ7dDZXAXE+XBTSX4rX5llDwqayYKeNK6by/eXyOdRK7BRIYsvUCVbVhQonxJKsuy4zYdjgtZWbhKMhG2y8=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TY2PR01MB2091.jpnprd01.prod.outlook.com (2603:1096:404:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Thu, 26 Aug
 2021 07:29:55 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::4401:f9e:2afb:ebc0]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::4401:f9e:2afb:ebc0%7]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 07:29:55 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Liu Zixian <liuzixian4@huawei.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "wuxu.wu@huawei.com" <wuxu.wu@huawei.com>
Subject: Re: [PATCH v2] mm/hugetlb: initialize hugetlb_usage in mm_init
Thread-Topic: [PATCH v2] mm/hugetlb: initialize hugetlb_usage in mm_init
Thread-Index: AQHXmkp9ooGoykmSNU6HXa8W9sd+lKuFY74A
Date:   Thu, 26 Aug 2021 07:29:55 +0000
Message-ID: <20210826072954.GA2917170@hori.linux.bs1.fc.nec.co.jp>
References: <20210826071742.877-1-liuzixian4@huawei.com>
In-Reply-To: <20210826071742.877-1-liuzixian4@huawei.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d558e1d8-89df-4706-0cdc-08d968634d28
x-ms-traffictypediagnostic: TY2PR01MB2091:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB20915CDB6D68937DF977792AE7C79@TY2PR01MB2091.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 21l+PyiqI6wf1OEfyicYh3y4wlqbVDyMkgJkC819QiWdWDF+4PpYC0WwnaYoWIZGlSkgTx0vcYxotPLrUkUY9XYu4mf12Sq+r7l9EyT4swmjqW/4oSX1ayRDgXedAgdYR7cki5c6nLFlPWvXALhfs2Cw5o0S1vTOw7yShYRUW81vPGxJpzLKlNn0ywZDDDi8ML8PF7gzUxmJZa5LZAGsW64EGQEAqeiqhv6EVx3oWmVGAKvBFz+GyFfcaYdi3iONE6ZYmoJcwal64lv6db2zWeD4C+b15AkNuASBs0HcsfLQK+NXUwGNAQ3WnAPjf4sszqF81al60i34ebxL1XoCnN5d2020c0uOtSnJ8LHuxEuksmu7G0CrpkShy8hb+xjFlipI9+GrAJ99g3Xn/pEnLmUJWQh/XyDwCtXMAk8yWA2boKzFLszu+28cigfjKGvdNYmG1cX8avYzlCIJTRc9sivYzcL0/f79hlOXXotXi/zYlyLNkCgg1i/7hBeclj2SioUBpAwv1VdhnxXsMQrV0y+0D7z3MylFNTJlLCuWyWXEyNvVFBF5gnnuUXkh8JZ1Ncrdefpj+TCeRX01rss4ebafiGiSq3x2AvCuiSz2QiT1l6Kkyun5bVGu/t2dSKNUuVEwZSwE1l5LVqa9qHANiT/xEmOq6SoLrJp+6mssG+JsY83LrOwrVz8WaYQdasgJSPV0qvH3PW3kFSpSJTo/UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(55236004)(4326008)(76116006)(86362001)(6916009)(66946007)(316002)(66476007)(66556008)(64756008)(66446008)(8676002)(54906003)(38100700002)(85182001)(2906002)(38070700005)(122000001)(6512007)(26005)(9686003)(186003)(4744005)(5660300002)(478600001)(6486002)(33656002)(8936002)(6506007)(71200400001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2NqVExQNnFSWFhrNWpUdWVQTkIzMi9qRDJ6MThUTGhCL2NlTG9yei9RMExi?=
 =?utf-8?B?cFZzSlEwUGRmRmJzTHUzcFk3SWRJL3kxcFpwdE9GK3RkYWltOHU3RVVpcGkv?=
 =?utf-8?B?OVN6cmx6Z1pSM0g0eWVlUklRZjlDNldrMG1qLzVNOG00ZnR0K3RlcUl2NGZI?=
 =?utf-8?B?SmxDRE50ek5ZckhKMXJSV1ZWdkRYd21oSzVLSXJ6N3hWdEVjc0dsekwza2Y5?=
 =?utf-8?B?a2xmVDlXd1BqZ3ZLdkFxV1F4anVUb1ltekU0QkJsUGdsQmVMczY1S2xuODI4?=
 =?utf-8?B?MXZBWHJDeEZNQmhwaXcrQzJIb2YxUHExdWc2Z0NuL1ZqY1pDOEFnUnZhazV4?=
 =?utf-8?B?V3llUDZMS1c5SGtaUTN1Y0J0T0pTNlE2Z1FlTk84K1FRS21JUVF5RGxHQ0lQ?=
 =?utf-8?B?R2E5d0MyangrWnFsUHY0UjgzUTh5NVNMRFNXZ0s2OFhIWXZkeDJGcGJMaDBv?=
 =?utf-8?B?RFVWeGJQcmFxdTdieDFiQUx1YUlTcUVYSkNLYWdPS2s1WHNyVkNySU5zN0pz?=
 =?utf-8?B?RnpmOTZRbG5IbnRxY3pyNGgvM0VHd1pxTzJVeGFmN1Jid0FYaDBuUXp3eE9x?=
 =?utf-8?B?VG54d1RlQnZTYjNOTGk1dVVwZGt5WXZaeXo2cU9YbXk2TFpObzBvTURUSm05?=
 =?utf-8?B?bkJLZUMvYWIzR05yNWlwa2YvcjdBcndlQXYrakZyNndhV2FKR0pzWFZYV042?=
 =?utf-8?B?QzI3Ym1xRmx1bk9ySlZoRGlWYi9uSVAyK3Vmc0lOMHlLanN6Yjk1Qjdxb2po?=
 =?utf-8?B?RFlHODNjQnc2VUQ0TzBEZXdLbk83ZmxQS0NJMFVTdGxIMFFYVU1qQ3NVaXR0?=
 =?utf-8?B?KzdIM041ZlFRdXBJUHNtNDhKcmJPMmdrdWwzd2loZU1CMkZNbWIrbzhtd0x4?=
 =?utf-8?B?WVZGTDBKZ1dEaGFrQ3QyUGJQdS9SdUxicXJlQVdsYVE0UHJFMFZ6ckIzYjM2?=
 =?utf-8?B?QXM5cGtvVDcydmJDaVhPUE5hZjBjZGU4VEpNbDhoOVBXeE90SGFXdHIzckRU?=
 =?utf-8?B?a29idTR0aEFBYXRwamV6T0ZzTUluaE9jSTM4aStnZVA2Uk1kT0MyN2ZTbWtW?=
 =?utf-8?B?T0VnUldveDRsSk1pMmwzS2R5Q0k2T3N5b1dWSWxDTW9GZWZxVWhUVlRuNXV6?=
 =?utf-8?B?ODdNM0tmNVZJZlFoUFlVaXhoOXJHbVYyaFpOY2Y2cU9iVGQ5cTkxNk9ONHV0?=
 =?utf-8?B?SUFlaURyN3pwNDBoNmRNZ2I1d1ZvLzdrWEFGcTBOb1UxdDdxM3d4VkJrSDho?=
 =?utf-8?B?L2lNelRnZEhYTzduTjRMemFXcVBKK1BFOCthb3cyVzJpcHZSREg1TGtacUhr?=
 =?utf-8?B?aVAySXVsMnBpSzNmb04xRko5cXhPSUx4OEdWN0JTN3JDUnF1Q0JWd1RtQWRw?=
 =?utf-8?B?VEw1RjRhZk0rMmE0L0lnTC94V0xzQjc4L1F1dG9lZUVXZ2RtTXpTYWNSbjNt?=
 =?utf-8?B?ZXpicHhHVXVXT3dZYjBaZkd1ZnNSajVKM1hVbnVHOUVXa1NtMTJEY3NueTZT?=
 =?utf-8?B?YVJKQjlZbVlFZVY2aVd5TmRGWnRlR3Y2QUdvK1BtM2NZYUZrWmJ2RUl2RzBW?=
 =?utf-8?B?b3hWUkJvS2s0SWxNOTU0ckEydkpiZmJwdGpHdlh3QzdEYThNVG5tVFdHQVdZ?=
 =?utf-8?B?aFpzRFNZRjB1N3hyTDlzNnhrdzR6c1RqNU5mV3Z3Q1V4djd1U0s1ZE9zMFhY?=
 =?utf-8?B?NHFKQXR4b2NtekExZ3BXSkhtLzhHOEZRbGluUWxuQWlDdDNmYXV0M28wbnBJ?=
 =?utf-8?B?dGJzeVFsbVZFVEZhM3RhZVV6anhRcmdLNjEvbUg3dkZjbXJCMklWRnFnNUMx?=
 =?utf-8?B?dS85L2p6NXQyNXorZEREdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C770745D95DE142A605E7B7D913ACDA@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d558e1d8-89df-4706-0cdc-08d968634d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 07:29:55.3857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDdNFKxhIQ2y+YIVBhDwAPRIdgbMRkTARq/fQwpC+UtA81MKnxosyudtnQKC9boPSNZpg7Y5YEE4b0/YuPkBGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2091
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBBdWcgMjYsIDIwMjEgYXQgMDM6MTc6NDJQTSArMDgwMCwgTGl1IFppeGlhbiB3cm90
ZToNCj4gQWZ0ZXIgZm9yaywgdGhlIGNoaWxkIHByb2Nlc3Mgd2lsbCBnZXQgaW5jb3JyZWN0ICgy
eCkgaHVnZXRsYl91c2FnZS4NCj4gSWYgYSBwcm9jZXNzIHVzZXMgNSAyTUIgaHVnZXRsYiBwYWdl
cyBpbiBhbiBhbm9ueW1vdXMgbWFwcGluZywNCj4gCUh1Z2V0bGJQYWdlczoJICAgMTAyNDAga0IN
Cj4gYW5kIHRoZW4gZm9ya3MsIHRoZSBjaGlsZCB3aWxsIHNob3csDQo+IAlIdWdldGxiUGFnZXM6
CSAgIDIwNDgwIGtCDQo+IFRoZSByZWFzb24gZm9yIGRvdWJsZSB0aGUgYW1vdW50IGlzIGJlY2F1
c2UgaHVnZXRsYl91c2FnZSB3aWxsIGJlDQo+IGNvcGllZCBmcm9tIHRoZSBwYXJlbnQgYW5kIHRo
ZW4gaW5jcmVhc2VkIHdoZW4gd2UgY29weSBwYWdlIHRhYmxlcw0KPiBmcm9tIHBhcmVudCB0byBj
aGlsZC4gQ2hpbGQgd2lsbCBoYXZlIDJ4IGFjdHVhbCB1c2FnZS4NCj4gDQo+IEZpeCB0aGlzIGJ5
IGFkZGluZyBodWdldGxiX2NvdW50X2luaXQgaW4gbW1faW5pdC4NCj4gDQo+IEZpeGVzOiA1ZDMx
N2IyYjY1MzYgKCJtbTogaHVnZXRsYjogcHJvYzogYWRkIEh1Z2V0bGJQYWdlcyBmaWVsZCB0bw0K
PiAvcHJvYy9QSUQvc3RhdHVzIikNCj4gU2lnbmVkLW9mZi1ieTogTGl1IFppeGlhbiA8bGl1eml4
aWFuNEBodWF3ZWkuY29tPg0KDQpUaGFuayB5b3UgZm9yIHRoZSBmaXguDQoNClJldmlld2VkLWJ5
OiBOYW95YSBIb3JpZ3VjaGkgPG5hb3lhLmhvcmlndWNoaUBuZWMuY29tPg==
