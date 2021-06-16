Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0093AA724
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 01:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhFPXCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 19:02:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9018 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhFPXCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 19:02:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GMukmD028355;
        Wed, 16 Jun 2021 22:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ub1O40Kw4rDDxmsda79HOtXvA7wv6s2+eBDzSNjmJVQ=;
 b=aKAdK2Z/O4YSGQSMMK2qj0M7YSQ7/wDeJneBqberG3J074ciceSlXUUrEg3Q81IRnJTq
 9j5BwHXEMtknXmR32dBLZzsz3oNX+X9fio2RlQtU+eMpKlUVjhf53S+E+s+4xu3rOjbx
 5cpG9kucTkjms9Rwt7afKOAIUg69yCWabyZFIzs3jlsH3jFUHHT1gx3YbQVcVRcgWtbf
 hKxpbePMiUAFNYZvjyO2oZHOUnqB/CZ5D4wBs8my2b5AXHe6wjNen6NMbIR5RBF/MICo
 3e1pB9WtDZmKkWiVrZla1u7I0b/2vhv0mQH6FYp9FlPnXw9De3cTxK9Ejn7PXzWX8TP+ uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 397mptgkjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 22:59:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15GMtKbD007344;
        Wed, 16 Jun 2021 22:59:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by aserp3030.oracle.com with ESMTP id 396wauw6ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 22:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT5R0KTOBv0oTlYbQBQPHq8bvd2qK7NUpdTXSGk8VtS3CmxZWi1puCW224v/3pCcRKF53kVe7xOKqLsVii2r1tGDh8KfXi6egm7T4nK4Ja/LQwEzk2sliMpRG6QwAKvaaW0TQS10yU3Y+Luln3C9iMxh5DU+MsTV/TyJfyxPIQ5506cuTuRcSSmUEOdkvm4S8ds9lM1zTtihBfPMmATWZSsZgKdfRB1hUm61SsXwSkqrGtEzS0FYlFpM6VEdebIl0NUQjoCPlra8pTqxvPjfDp44W1kZ/V/NSb1XhMZCQOaj3RxYUI9/Cr4psu4TF+D8zFyu/62KUhK+KXS5onYjoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub1O40Kw4rDDxmsda79HOtXvA7wv6s2+eBDzSNjmJVQ=;
 b=bNnDzQASbz6GdmTN5buEoW97e5PiDiVdO9yc62A1H0jpBEoWkAjwHosJJ4xpjBQ7OEIJInW0iVsc+IsEN52wirEnB20J0lsu77ezDH230jUhfwSQbKKhO46x40C2OQ/0YpJMRN2RlkCzRfBIAfzwMit1R/8nfPqf3FF/V8pSrjJhBlLvjImhRFCgm49vI95yIx2tgN/jeEFsDPZ+hx0sgf5ib6FtgoTWQxuSkPItVSP+vwDKtPdpOz//UtsVZS2Q17rVCnqvfJ4iNoeRMnA/VyNJGagftemp98JeFTj5xpMqXA3RHZOd9ntKgAJZH7bpUzMtSCg213xM/OdftUb32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub1O40Kw4rDDxmsda79HOtXvA7wv6s2+eBDzSNjmJVQ=;
 b=t+3n1vff6AKr2geGTH2cGdoXYkmvCUFDdrOjqmHiOU2YRLb/Uy6mxwUUyPh8OQ8oVakmefHXazwPoJViZxK0ZUehpvfkwn82zkCI47qjYfdJPJ+mSYMTqnkrRgMz4j8I06D94GoMMRGbwQJLbLV7lprqvDAyYYbsENXjp6d/omw=
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14)
 by BYAPR10MB3477.namprd10.prod.outlook.com (2603:10b6:a03:128::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 22:59:46 +0000
Received: from SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::d8d2:586c:80a4:1f4d]) by SJ0PR10MB4718.namprd10.prod.outlook.com
 ([fe80::d8d2:586c:80a4:1f4d%3]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 22:59:46 +0000
From:   Sherry Yang <sherry.yang@oracle.com>
To:     "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherry Yang <sherry.yang@oracle.com>
Subject: Re: [PATCH 5.4 0/2] Backports "x86, sched: Treat Intel SNC topology
 as default, COD as exception"
Thread-Topic: [PATCH 5.4 0/2] Backports "x86, sched: Treat Intel SNC topology
 as default, COD as exception"
Thread-Index: AQHXW/5v9A7Q4t0/E0ac2TszhVkoCKsXTpyA
Date:   Wed, 16 Jun 2021 22:59:46 +0000
Message-ID: <A969D4BF-D21B-4AB0-97AE-5C881C6F187D@oracle.com>
References: <20210608003715.66882-1-sherry.yang@oracle.com>
In-Reply-To: <20210608003715.66882-1-sherry.yang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [2600:1700:2329:4220:c165:6663:81dc:f898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a534f42-9634-49c2-3346-08d9311a6fa6
x-ms-traffictypediagnostic: BYAPR10MB3477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB3477010519B19E183836F7419B0F9@BYAPR10MB3477.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWMcj6CQ+TTOaS/mJ+FOg6hxAx05jtKshvtVyq3z9C/rLe1RgdRJ+nz7U2HXZ6BS6jDUMIlGrqaeqFwAw3PYJ2yib7XiNmL+ckH/MkqzWbFwZH6BeuAXj2pG/DcybCPuMgfuslCM56kA+EUOv2Q01rxM7BTGjcePGDhTrDOe28ymbdHzikFXFt7IrK3Fgxl/rfg5rzQiGtKjPhnJr0qrty2dtkoC8rdF4WGu+RAI5YREB1WOxo5d/QjL2qyM0Xf4wKJgCE7IjZU8IVJFdJ+QwczcKCH2H1NqC530nH09pB/v4tgsjz5vvcpYhWWNu5C0PG5Fa/A34AiStn7KdWsbMRnJEVuFcNCOtEM1vtsmeBcA5dxikwEsyKmi2d7UP38VqQJGuA4WGwSfZkqb930znI2Vflz6S9S/qg3NYkcU04bzoEDpkJm+CmzJ4ttS8fF6kJLEiildlrHvRK8rUjldTrg+VfP7WZ+OUjR85ziCiMPmvRQU3l+Yp5MazO/9n4oGhxW3DPcktqPVxf8+hQOrBfM39IUUwWvhVq/H+gpfC2F3bI+7lCUsHs9b7zElKMPq8GPR+QX+WG1qd9HXIOKotNRrPrjiKJuSn+aRI+6bMKSEYPHWjxa6Qkm5tDWOq07uInmASToCw6cflO0trvDUHTwLX2L+UeBOZprgblMLioQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4718.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(6512007)(66946007)(66446008)(8936002)(66476007)(38100700002)(64756008)(66556008)(2616005)(2906002)(478600001)(91956017)(6486002)(76116006)(71200400001)(6506007)(122000001)(33656002)(186003)(83380400001)(53546011)(36756003)(44832011)(107886003)(316002)(4326008)(8676002)(110136005)(5660300002)(86362001)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2lCLzdlRUFua1BlbjVIMUsrWkhTQXY2dHdycEhsSHNKWGw5VFhrUTVabVYx?=
 =?utf-8?B?RUg3UlVUZmdkNVNkYjBuZUVHK2taSnVWSjQvck90dkRzUkk1Vk1lZ0hlSFNW?=
 =?utf-8?B?d0dDZG5hdEp1SU5qemNrRGJDcE1VcUkzOGJRYkVwTVlmVTFYZVNiR0hWc3c0?=
 =?utf-8?B?YkN4cE43d2FkdG00Vk9UMXp4MzdXOHBuUmY3WC9scEtwNnVsbTR2NExsRFk5?=
 =?utf-8?B?S1JueEdIZEJlREpuOXFrRlNaRHZoa3ZTZm51UWxGcmpFTHc3LzBmc25XZzYz?=
 =?utf-8?B?aUs2M3k2WmM1OXV0TWUwN0VGQWZ2T3E1L0dLTllRZlVFQjhpeDViY2I4bmkx?=
 =?utf-8?B?UG1qb0M3VVh1ZldwSk1NRnRJZkZzSkdZYit4Mks4NVBjWGJ2QVZnWkxOay9H?=
 =?utf-8?B?TEVjUEhpdXpkTXQraUEwc2FJZ2F3MEZMUDc3T2l4RjlJSHhTbG9BMlFkNUkv?=
 =?utf-8?B?bDdHZWQ4enI1TDg0dVVBZ0NlU0Q5MmR5NTBIeUZzdktqVXRBbjBMODBuT0FK?=
 =?utf-8?B?QWlXcFpHMnlpMGllMUZUUTdDVFpZcEZkNHFQellYOERIc0kzZnJRLy9xYlB4?=
 =?utf-8?B?bG1zSFNhbk9xTENmbXBxakswaHMydHhZNlVlK0FPTExJUUVtS0hFYVBCc2NI?=
 =?utf-8?B?QmFDYk81UWlVbUNSOGxhQllndmEyRXpjVFRmS21ISm5PMjlYNllKVGtvbldB?=
 =?utf-8?B?QWhDU1RkR2p0RmcyanR6MjVBL0kwamhPL2ZwOFMrRzV6bzVSTmxROS9iVDNl?=
 =?utf-8?B?K29kaGR6LzhJVWFxb2t3clVVVGZYVmNKYzg3cFZuZ1BIZi80T1B0MjJKRzBh?=
 =?utf-8?B?NkdlczFWSFFmUmxCMVJadVVzT3RHVHFlTWI0NHEwQWh5cW5hR093MmpYMTQr?=
 =?utf-8?B?Ky9yampwL21oSVBuckFkMmlpeUd6a3ArSXU1NTkrQjFmakljbUxyREk1WHJr?=
 =?utf-8?B?UzNwMFpFZFhVczlOK09YZVpVYjBVVklRTS8rM3F5eFZHS1hlTGcxSzFRVnBC?=
 =?utf-8?B?ek5uMFpncWRwMVA3SlNQWkJIQ3loZmZsMDJrZXYzMG4xcWM4cndhUGE3QUhK?=
 =?utf-8?B?UXBvcFg0M2w5Qnd5cWYwS1FaeGtCdUtqSVJVNWNQZC92eWVZR3kybk5nSFZW?=
 =?utf-8?B?NjZpaXhpN2d6SkllcjdmQVl0TXdUYi9QVWQ3NDBROS9XOXRrNDJSaEpNOTRV?=
 =?utf-8?B?dHYxZWZ1S0xITzlrWTc3eE0ydDNrTTFFTjFGSmJySEZ2RjF5UlkvVnNERHpP?=
 =?utf-8?B?ZGF2T2lZemk0TjRoWjYxWGVUdlZGbi9mVkRnK0M4Nmp6b20xUk0zUXJtczVy?=
 =?utf-8?B?ZmROcWp6a0RJYm5LbHBRbWtnZmYxbWtRM1lwVE1FRzVpRmtqQ1dpc0dqS2Nh?=
 =?utf-8?B?UW1PMEVvQU5ONG51cEtJRXBIQWYzVkFVaFhKSE5kRGVRenkwRnBYT1pFM280?=
 =?utf-8?B?Q1ZHRkNOVVVnUzB1d21Sb1FrYzFDeFQrb0VWTldqMnk3QWEyemh1eUNoa0tj?=
 =?utf-8?B?TWtuWmQ4bDFISVJsVVpDaWJ2dFBTQlBOamhSRk9NYzhZVG05YnA2aGF6dnAw?=
 =?utf-8?B?MnhTWmEzREUzcHYzSW1Rc01qQzN4dnVJRmJhMDV3M3JNWnNjbjFsTTNCbnhJ?=
 =?utf-8?B?enFtWFBNR1NNWTNocElZZnQ4bDJZOVRRRlNWbGFiUGh1SThtSHZ6R1VLYXJU?=
 =?utf-8?B?VGNNWnU5bFVjWVVaWXBKRlNteUd2VUVhYkJLdFBQWFhlS3RWV1FxYkRNTko4?=
 =?utf-8?B?MXVCYWtHQUFxOEIvSmV2YkdKY1dBbzQvN2hQNDVvbzNpNkx4SG56K3FQYTlu?=
 =?utf-8?B?ZTdFVTBRUko1RVJZUVlRZlFjNit3SkFaWUdaN2ZBTWIrODFDcW9rcldvMFBE?=
 =?utf-8?Q?VrQTB2FUZ3v01?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13F1B05076C4B14CBC57279EEB851BD3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4718.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a534f42-9634-49c2-3346-08d9311a6fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 22:59:46.0455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HiFGBgaeRsGzERjtisti52lczy4R1fs7pkx9GtxLXfuwD3L3DpsMpCw8xtjWNUUKQiGlcnU5WvWOCnYNnUOQqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3477
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10017 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160131
X-Proofpoint-GUID: B6Em0XYBqEascBWQ9X2iJMvpUCWbc8MI
X-Proofpoint-ORIG-GUID: B6Em0XYBqEascBWQ9X2iJMvpUCWbc8MI
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IE9uIEp1biA3LCAyMDIxLCBhdCA1OjM3IFBNLCBTaGVycnkgWWFuZyA8c2hlcnJ5LnlhbmdA
b3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBDb3VsZCB5b3UgYWxzbyBiYWNrcG9ydCB0aGVzZSB0
d28gY29tbWl0cw0KPiBhZGVmZTU1ZTcyNTggKCJ4ODYva2VybmVsOiBDb252ZXJ0IHRvIG5ldyBD
UFUgbWF0Y2ggbWFjcm9zIikNCj4gMmM4OGQ0NWVkYmI4ICgieDg2LCBzY2hlZDogVHJlYXQgSW50
ZWwgU05DIHRvcG9sb2d5IGFzIGRlZmF1bHQsDQo+IENPRCBhcyBleGNlcHRpb24iKSB0byA1LjQu
eT8NCj4gDQo+IENvbW1pdCBhZGVmZTU1ZTcyNTggKCJ4ODYva2VybmVsOiBDb252ZXJ0IHRvIG5l
dyBDUFUgbWF0Y2ggbWFjcm9zIikNCj4gaXMgYSBwcmVyZXF1aXNpdGUgb2YgdGhlIHNlY29uZCBj
b21taXQuIFRoZXJlIGFyZSBjb25mbGljdHMgd2hpbGUNCj4gY2hlcnJ5LXBpY2tpbmcgY29tbWl0
IGFkZWZlNTVlNzI1OCAoIng4Ni9rZXJuZWw6IENvbnZlcnQgdG8gbmV3DQo+IENQVSBtYXRjaCBt
YWNyb3MiKSwgd2hpY2ggYXJlIGNhdXNlZCBieSBhIGxhdGVyIGNvbW1pdA0KPiBjODRjYjM3MzVm
ZDUgKCJ4ODYvYXBpYzogTW92ZSBUU0MgZGVhZGxpbmUgdGltZXIgZGVidWcgcHJpbnRrIikuDQo+
IEtlZXAgdGhlIGxhdGVyIGNvZGUgYmFzZS4NCj4gDQo+IEFsaXNvbiBTY2hvZmllbGQgKDEpOg0K
PiAgeDg2LCBzY2hlZDogVHJlYXQgSW50ZWwgU05DIHRvcG9sb2d5IGFzIGRlZmF1bHQsIENPRCBh
cyBleGNlcHRpb24NCj4gDQo+IFRob21hcyBHbGVpeG5lciAoMSk6DQo+ICB4ODYva2VybmVsOiBD
b252ZXJ0IHRvIG5ldyBDUFUgbWF0Y2ggbWFjcm9zDQo+IA0KPiBhcmNoL3g4Ni9rZXJuZWwvYXBp
Yy9hcGljLmMgfCAzMiArKysrKystLS0tLS0tDQo+IGFyY2gveDg2L2tlcm5lbC9zbXBib290LmMg
ICB8IDkwICsrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0NCj4gYXJjaC94ODYv
a2VybmVsL3RzY19tc3IuYyAgIHwgMTQgKysrLS0tDQo+IGFyY2gveDg2L3Bvd2VyL2NwdS5jICAg
ICAgICB8IDE2ICstLS0tLS0NCj4gNCBmaWxlcyBjaGFuZ2VkLCA2OCBpbnNlcnRpb25zKCspLCA4
NCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tIA0KPiAyLjI3LjANCj4gDQoNCkhpLA0KIA0KV2UgaGF2
ZSBzZWVuIHRoYXQgdGhlIHdhcm5pbmcg4oCcc2NoZWQ6IENQVSAjMjAncyBsbGMtc2libGluZyBD
UFUgIzAgaXMgbm90IG9uIA0KdGhlIHNhbWUgbm9kZSEgW25vZGU6IDEgIT0gMF0uIElnbm9yaW5n
IGRlcGVuZGVuY3kuIOKAnSBhcHBsaWVzIHRvIDUuNCBidXQgd2UgZG9u4oCZdCANCm9ic2VydmUg
dGhlIGZpeCBpbiA1LjQuIEknbSBzZW5kaW5nIHRoaXMgZW1haWwgdG8gYXBwbHkgdGhlIGZpeCBm
cm9tIHVwc3RyZWFtIA0KMmM4OGQ0NWVkYmI4ICgieDg2LCBzY2hlZDogVHJlYXQgSW50ZWwgU05D
IHRvcG9sb2d5IGFzIGRlZmF1bHQsIENPRCBhcyANCmV4Y2VwdGlvbiIpIHRvIDUuNCBhbmQgYWxz
byByZXNvbHZlIHRoZSBkZXBlbmRlbmN5IGNvbmZsaWN0IGNhdXNlZCBieSANCnByZXJlcXVpc2l0
ZSBjb21taXQgYWRlZmU1NWU3MjU4ICgieDg2L2tlcm5lbDogQ29udmVydCB0byBuZXcgQ1BVIG1h
dGNoIA0KbWFjcm9z4oCdKSBieSBrZWVwaW5nIHRoZSBsYXRlciBjb2RlIGJhc2UsIHBsZWFzZSBy
ZWZlciB0byB0aGUNCnByZXZpb3VzIHR3byBwYXRjaGVzIGZvciB0aGUgZGV0YWlsLg0KIA0KVGhh
bmtzLA0KU2hlcnJ5DQoNCg==
