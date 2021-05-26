Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB866391157
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhEZHWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 03:22:49 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:7488
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232971AbhEZHWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 03:22:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLd6b7A9ToUJUmAUB4UiYZk6PZzX0trkomk0qL5MqjsW7fNU8uhO3eRncMA3QOe/inD4N1OcOTCdK65ktQP/Rkuxachkbw1UwKQoI81Oeiaiqr13PBnZnxalO2BdyXFc35nhR9YBe6JzOMqUS79LskOkxDjjdIqZs1l/N6N+/t2AizY6rvMgrWtjxTfuOH95cIQ/RqzZ5Yl7MPsNvgTRfZE/su4+RwetxgTh0TrvGWG5iSE07bKjeSq7nttxoOQ+vkwFgYy9ZbsbyTlkUtjlmPc/Ifq9M00docRo45FgXjM87RTeK5bgSlCL2hffPP+/q3nrEDxREB4PBTWt+cpGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbs8WNzdbvH90unDQ3xwa9t8idoCi/49VZAfGmDqjUY=;
 b=Yi2QZ+P5+M/XeJD1Sr8rf6m1YMk4KW2I8mjb5i5cYaMAnmBn6U5GIvwMnwzs/dldOFw/1Y6QjNzhHJj+VnX3JJlLq/0Jrd9Okb2Z6oi4blr/DXMmuNMO2r5xmOVBElRj9iwxvr+PrUCAQCbzGMPgwLnl8dvmGrPcpPxN1JAFM3aE7pHgbuKXh4uxjOOZLYB09hmIUgBRXorQPfFzEoFbm6P5DwQWSfrFHiEodjhln5Rl41t9Z/aqoQIK30dyvhyxmV5AoaVugN3ZAt2oieGOMsUOLFktRv5Aon7WQE1YPag+TI1L80SwlKQR0M27O/h+iW4ItRUS3k5sR2bKde5ozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbs8WNzdbvH90unDQ3xwa9t8idoCi/49VZAfGmDqjUY=;
 b=N1LyKMztulFaIGuPipuMCogM8ul8fCtLxz8o34DV9kQ4iW5UsPY5LuOrVOZToGKQlbCKEEXTs9ssYz0aod+8D+EpYu77dRkYuD3Gec63M4r5qM/4tFGXBBkXQDVTrqqQrk2dOSi5Tws0YK7YOObImfnEHCFYNYMJaixKBm4GUAk=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR07MB4172.eurprd07.prod.outlook.com (2603:10a6:7:99::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.12; Wed, 26 May 2021 07:21:15 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf%7]) with mapi id 15.20.4173.020; Wed, 26 May 2021
 07:21:15 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: Re: LTS perf unwind fix
Thread-Topic: LTS perf unwind fix
Thread-Index: AQHXUWNAMimraUixrEyqdytsWPBp16r0KrIAgAEx8AA=
Date:   Wed, 26 May 2021 07:21:15 +0000
Message-ID: <45b140543ccb85ab184ed17befca4a9e64661051.camel@nokia.com>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
         <YKz2RIcTyD/FCF+a@kroah.com>
In-Reply-To: <YKz2RIcTyD/FCF+a@kroah.com>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f6a01d2-58be-40b4-7b9c-08d92016d95e
x-ms-traffictypediagnostic: HE1PR07MB4172:
x-microsoft-antispam-prvs: <HE1PR07MB41724D5994FDBD3ECC45EE90B4249@HE1PR07MB4172.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zc7PIjX5Bw6LR8GzcZ4VJE4YQfVBmTduAy6JaiUJzxTyqtsFPp+RD1hdjaW3m0i/YnDM4pj4JUiFKROaO1CpbEwOQOsOgCD8PtJqEvOSKQMAxa9FmOefTZciYOphYENH7Hc0qEEiXXof6LikvDATUu8B1pFq57Q89GY0P1gSPmszAIaNqEtq20oH0vFKqvi3d99Kriu5yZZG7lQybqqhEPPmgfPPvha9kaQkZBiNfjIJdvcDXfkXwbgoKPHtJFRGXGM7wX5eU4ChBOMpfhE+lbVa9ZXTr2TUVxxvJSJIvgqLNIZ1zrF0R15c8eTGmtSQE0ZhYiwTv3sgS2E7DNkbe89Wp0W9XuPcKXA+55bkxQC0p/ugJVUvExyHj2dZgNAvMDYNylG5ZDDnJqQNvcqVyVjkvVHA+Rt/Sdtyg2JoIOiLA1jJD9iDIBiNRipTYv4C816Ca/+S85qc6GD6y5e6CsXuehw/c6OiWv2bNl9lW7uxD7SKPWk5fTN8ke+Ii4TepdAagasbuorhoAemVQX8OyEKl3lr8nLmSd0zmRJZERMBFToAwOLw3jTNMPcnQ0BM0a2hFOq7tc+tBV5/oLd8iCkANttzERlsVVRfLbsi/es=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(3480700007)(6506007)(2906002)(4326008)(76116006)(6512007)(8676002)(6916009)(86362001)(26005)(4744005)(36756003)(478600001)(54906003)(2616005)(186003)(71200400001)(66946007)(8936002)(5660300002)(316002)(6486002)(38100700002)(64756008)(66556008)(66446008)(122000001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b3MrT1hwdldzN2xNck1BbWFQY2JFeUhMV2U2RzZpMkQzaElqcDJodjVvbHFz?=
 =?utf-8?B?M09WRVBOM3FHUUhJZXhzenNEVmEza2ozT3Blcmh3MnlDU3U0UGJkcUxWc2NW?=
 =?utf-8?B?eTk4YVFaekthYjBMTW9EeDJKeUtzRTdsTHF1QVpuczNFN0treXU1bCtJWmJq?=
 =?utf-8?B?bWVXSVUyRksrWXJVRndQS25ReTJITytRb1FFYkxiV1lkTlg1ZjdGY2RaLytW?=
 =?utf-8?B?b1JsazdFd0JvVyswL2pRY0hpVkpjZ3h6czV2VVo2NjU4UGVSeXBoRzFMMDBw?=
 =?utf-8?B?bjkrSE5tWnpGMGpwSDVreWpqQWtudkd2bmkvWHl6UXpESmwxeWREb2cveHhv?=
 =?utf-8?B?Wm1CWkRxZlduTTgrYllPdlpWczU3TjFhRjBtS25EMVFYMjAvN0JzaHZrMWgy?=
 =?utf-8?B?U0dXcVRrQUU1eENueW9zMUxZQ2RkTVFsbHlWZm5YV3REOFErbmNuTzF6TEE4?=
 =?utf-8?B?ZWtJdUZZeWQ0NmtsK2g4QjJRU0VSYmZnM21XZW8za1VZOXE3Y3kwMjVWeU5C?=
 =?utf-8?B?d2V0UTYvRGE5NFJDRkRhZnJxQWN3STArRW1xTng1bC95YWQxMGpJSHhhbjdF?=
 =?utf-8?B?SkJ3cjdVcFJCWWlzQlZMcUxYUHBubmxpdDJvOFgwb1pEVE1reDZDblRMS0Ns?=
 =?utf-8?B?TFBlcklVTGFoQUlXNWovWDYwb081OTFhS2lSeWdzQlQ5c05zY0VLdlU0bVJH?=
 =?utf-8?B?NnAvbTNEMmw3M0dZbm5KZVhKdVR2b2tId0lnM1hKcTIzLzk0c0Npb2tydTQv?=
 =?utf-8?B?SW9RNmswYm5UbEJDODIwUzJEWDlMN21XYm5JUlhUM0pJcStMZC8rZTFJeHVK?=
 =?utf-8?B?M2JYQTBMdlhLV1pJTitDUXlkcmQ3SWZIalJhNGJqZm1PU3pYVUhsLzFKY3JK?=
 =?utf-8?B?RlF0MXp1VDRUUlZwQXNYVUIxTXk2Zkh1WmhLWUpjQXFsRVlsbGdNc2hNRHpm?=
 =?utf-8?B?Tm1pUStOMDB4Z21BcG1JeWh5cGxWKzN4YjRaZVBzQmJNTjV5MTFsSzR4bVl0?=
 =?utf-8?B?bTR3ZTZDVHByYXM5d09UbGJoUnJBYUxOdGREQytCVkJlT0lmcFhUZUgvd1Aw?=
 =?utf-8?B?SCswcUtUTk4yWVRycGRBSEx3ZmROVVVRNGQrMm4wb3RHNFpOQlNLQ2d2R1Rk?=
 =?utf-8?B?RFdjQjZsamJDRlZvWmpXUkZaS1puYkoxOERtL3JNclFWU0RiRGdTOGJpTmxY?=
 =?utf-8?B?ZFhvN1lXRkN5ZFovNjV6SC9IZjhaQnlTbXNDZWlMbFdjbmJNMkZEdGt6Rkhk?=
 =?utf-8?B?ejZvVWFVWTljN25RNDJnWVZ6YzV1Wk96K1dYbDhRMGJJcFVPaVpPOUYrSFdI?=
 =?utf-8?B?Z2JZKzhETFlYUDVxNkloZEgwUEJ3blBYS201a0tid0w3R01nYXYwKzNoWTU1?=
 =?utf-8?B?Y2dKMjB1TjJvWUUvWFE4cldNVzQwR0tLbzU0ekYvVHM2Mm9YeFZoTVhoL3NP?=
 =?utf-8?B?NHE2VEVlU3FLSlVuUzNwb2NrUXl3OVdYQXNQZzdodFdraEhFaithVC91cGFF?=
 =?utf-8?B?TkIwZFdKQitLUnBnLzJvMVVqREQ1aUdzZ2RLcTZ6MDhhNkh5c21GWVNUaFVJ?=
 =?utf-8?B?WFo4bkg5UVhjTHV6dUdjeXhyc0pEc1hnQUVka2tyQWQ4RzAwT3pxZ0YwblVp?=
 =?utf-8?B?OWw5Z2xhUnp6TmxxcWtuMDlwQ1NHUWo2QnNmNDFnVHc0N0xaNlU5VTREa3pX?=
 =?utf-8?B?NVh1SjNsL2dFdHhwd21rVDU1Z1RwajM1cHU2bUFQb1FlMitTdFVSWWhudksv?=
 =?utf-8?Q?Fq1nLGFjU8Y6CTJZtqvdpuJa4yeWXawAtocTmzS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF3E283E30DF2F4CA087EB24A83A450B@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6a01d2-58be-40b4-7b9c-08d92016d95e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2021 07:21:15.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+lE+I0gmpMua1J8OmgyM3MTnhFFphhuJwxSJwQZk4ZSqUY37eZjQMkKU+cbaOrS02L7HKiRMcb5ZyFen2t09bNjkzgsbls2D+8qekzkJUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB4172
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MjAyMS0wNS0yNSAxNTowNiArMDIwMCwgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc6DQo+IE9u
IFR1ZSwgTWF5IDI1LCAyMDIxIGF0IDEyOjQxOjE1UE0gKzAwMDAsIFJhbnRhbGEsIFRvbW1pIFQu
IChOb2tpYSAtDQo+IEZJL0VzcG9vKSB3cm90ZToNCj4gPiBDYW4geW91IHBsZWFzZSBjaGVycnkt
cGljayB0aGlzIHRvIExUUzoNCj4gPiANCj4gPiBjb21taXQgYmY1M2ZjNmI1ZjQxNWNkZGM3MTE4
MDkxY2I4ZmQ2YTIxMWIyMzIwZA0KPiA+IEF1dGhvcjogSmFuIEtyYXRvY2h2aWwgPGphbi5rcmF0
b2NodmlsQHJlZGhhdC5jb20+DQo+ID4gRGF0ZTrCoMKgIEZyaSBEZWMgNCAwOToxNzowMiAyMDIw
IC0wMzAwDQo+ID4gDQo+ID4gwqDCoMKgIHBlcmYgdW53aW5kOiBGaXggc2VwYXJhdGUgZGVidWcg
aW5mbyBmaWxlcyB3aGVuIHVzaW5nIGVsZnV0aWxzJw0KPiA+IGxpYmR3J3MgdW53aW5kZXINCj4g
DQo+IFdoYXQgZXhhY3Qga2VybmVsKHMpIGRvIHlvdSB3YW50IGl0IGJhY2twb3J0ZWQgdG8/DQoN
CjUuNC55IHBsZWFzZSwgdGVzdGVkIEphbidzIGFuZCBEYXZlJ3MgcGF0Y2hlcyB3aXRoIGl0LCBh
bmQgdGhleSBjdXJlDQpzb21lIGJyb2tlbiBiYWNrdHJhY2VzLg0KDQoNCiAgY29tbWl0IDRlMTQ4
MTQ0NTQwN2I4NmE0ODM2MTZjNDU0MmZmZGM4MTBlZmI2ODANCiAgQXV0aG9yOiBEYXZlIFJpZ2J5
IDxkLnJpZ2J5QG1lLmNvbT4NCiAgRGF0ZTogICBUaHUgRmViIDE4IDE2OjU2OjU0IDIwMjEgKzAw
MDANCg0KICAgIHBlcmYgdW53aW5kOiBTZXQgdXNlcmRhdGEgZm9yIGFsbCBfX3JlcG9ydF9tb2R1
bGUoKSBwYXRocw0KDQoNCg==
