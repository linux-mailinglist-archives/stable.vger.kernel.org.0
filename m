Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FBB476B46
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 09:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhLPIAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 03:00:38 -0500
Received: from mail-db3eur04lp2052.outbound.protection.outlook.com ([104.47.12.52]:6480
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232196AbhLPIAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 03:00:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLB7qoZqUW0zcgzelRmegvt1TYnQSmQkp6VCkfViid0MIz+vDcmzI7XUjBhwOC5ahRK/+L9HGKFPIu834LSx9EqU5nPtCop5IrqxaYX0E6FJeY6fem6Z0OnNM2NXV0pja1fghIN0S8tkWRHPUp9kXh+z7I/ggriz9fevK9Wc3A6ZaMwYLdLO5G0gXdu6uUa0MPB45o+fORi4/5QwLPTIXnXXmshfItgF1j/Xuw/opHLTBmxcczNDNQSEU/SrGQNPivWyGnibWUPeUoIuV35L63glAJsKV4P5dXaI9fCQmoW662t3jeZSJrfUo9ptqjBSslFrSr08tQn6L1fL/j44yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nawVDFZa1Vu555d2vIi5FuaWsA5p8TC8LCBOUDQZnGs=;
 b=O0VQr/0YhKRGmTDrdS7oPnBVmj8CskHMT2a3yeWdrT7b4Y8xsY2Q50OnujX2CZHN3/QQoA9odynWGRQSsbdPym4EkwMlgyDyuCsat25O41VRKIhoSzohnRzpIDooHZV9nstq01Ch5grsd/aLKfDnkQSHCnr3rzBC7Q90ROPDq9FSn2tTX374jYMfuTeZPENYbwIq0JFYpW/FQQHtsYWkcVcL6Sh8n3gUqdGjiSkMy1z8/0IqkMb0I93Oti2LNDo8zaxypXJ/l3CFfykU7EHpKf+UXKO5m/35RVdMsrNiGgnd/vr6H/IToMn72m2YxwRdhDIp+O5aPMU4hfhjwj50fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nawVDFZa1Vu555d2vIi5FuaWsA5p8TC8LCBOUDQZnGs=;
 b=pAitCyLW/zyROpB5vBIvHrFkHC5Zx/Zs6ZW325NL18Nk/+889KfAvHicqr1j5/OXNNfslX1nAeAi5h+2DIrYLOYyAHUGePAKqc+BlEC2ttAVqZtFljXN0VAr6AnggW9l0KzI/afhkiNFg4lPSL3G57WgUq5mdhVyQaMm/euUQIg=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR07MB3098.eurprd07.prod.outlook.com (2603:10a6:7:38::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Thu, 16 Dec 2021 08:00:30 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::682a:d25f:504a:78eb]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::682a:d25f:504a:78eb%6]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 08:00:30 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "fw@strlen.de" <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: LTS "Warning: file conntrack_vrf.sh is not executable, correct this."
Thread-Topic: LTS "Warning: file conntrack_vrf.sh is not executable, correct
 this."
Thread-Index: AQHX8lL+n8lEGmpclEiUKlhP3M88zg==
Date:   Thu, 16 Dec 2021 08:00:30 +0000
Message-ID: <234d7a6a81664610fdf21ac72730f8bd10d3f46f.camel@nokia.com>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0780adc-9234-40b4-8e91-08d9c06a2141
x-ms-traffictypediagnostic: HE1PR07MB3098:EE_
x-microsoft-antispam-prvs: <HE1PR07MB3098CD91BC5DFC114F3E9482B4779@HE1PR07MB3098.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:308;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SOYnH7BLHIbmrD1jdaO4+KnXNd1f6bALC77kRtHmtZ0IRdOkvXRjzBxNxJI/mdp/ZocTW3pobzuCATXREfN4DNnm1wFDjEEh7x/htkC21d/Z+L6SfZxWsnMqaL3KnfjLg7ZhRpZDcAD1wDJU7ieJa00Zreea99V003yhAvhT46rVBp98IdUGwzyobZwGjssfTA56p2mDW/f7fsUrGOOOvxV498Crp9o7lJdHXf/RZo0hP+1Wyj18VALLI/VzgvY+Nq9yL1Xm6F5GLtuJPz2/H6r2C0RpJkkT/OOmFG6vZxyh+Y/DjUG98PLeJE6g7MhK22Vev7+efx5a/tqUyi9Up0SF1YW36hxbTbimpurEQzP5WkS3IdMbc0P+Jf32f3MJ+d41Zd/wI9F2DNdbOl7d0Nc56IVuCHmZdLy2ZVR08txD6Vh9PAru9gY0cjxkIkOxy3O4rrblDkrCMexZvIgaUNsCUHFejccYJKphNrSOOq4YxDgCNqFGyWTp7bWRKWHr/yhY618s/U2w5vzI3WHaajkhT1Cg0Ayfeq80AlnyKGwRkWaKeESLsRXHEz1Kp3XDsIDpW5a4pt38lVC/xJpGpAweLakFQRbnrPe4s5npjsAfcm+3aNDJ6JhmTNOzXQjUJDx8dOHdFt+4LxS/g1QWvN70qyf6UUO9I10KONGIDJ3FG2Itk+3UPJLhrDEf5gzh6lRF1/1lr4knkWm4AKKowQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(76116006)(91956017)(5660300002)(86362001)(6506007)(508600001)(64756008)(6512007)(8936002)(26005)(8676002)(54906003)(110136005)(316002)(66556008)(66476007)(66446008)(4326008)(186003)(66946007)(2616005)(38100700002)(122000001)(2906002)(71200400001)(36756003)(6486002)(82960400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUlOY1VxRVVsYlFsV0RPOGJnZE10L0dvL242ZlA3TVZuZlc3a3hpRFNHOVZ3?=
 =?utf-8?B?UW1OWkU0U21SRUkwVGFaMTNSTWVmdjErZnd6NW9wTzRCZzVzb1Q4MUt3Wm9B?=
 =?utf-8?B?aXFrRE1rT3NLL24yYnBNK1ZXUWNNdTAvRnpROEVNNllBekpwVGtlZDFSTEpn?=
 =?utf-8?B?eXBkczBIZ3huYXloTFJRUnVSU3ExWCtsdFdIS1VQQ2Nrd1ZKL2xoV1FmZ25x?=
 =?utf-8?B?aXVEcHN2QzJYVCtrV2hzeXp4SVZBck1xS2FXaUpaeUZkQ3FvZ3p4RjAwSEJw?=
 =?utf-8?B?UUw1Z3VKWFUxaG83VXUyYmlibnovQ0NOVTY1YzhDM3UzZUkwNUE5WlBmUTJV?=
 =?utf-8?B?dFlLc1RsU0VEczdPckdRalNWRXNDMkxsL2V5bCt1TXlsaXFXVGhXZ25MNzJG?=
 =?utf-8?B?VXVzOWQrQjNGWmZFTFcwdW5kbndOM0tlRWRwT2J1RGM3TExVdERyaVhwbkxU?=
 =?utf-8?B?bDZGNHh4M3ZVMkIwMUpaaGF3NzIrVEwzU0JUZENKbjMvTVVkQVo1dVN5SWVs?=
 =?utf-8?B?dmNHS1hxc2EzaFRkUjBxOVdKcGYxT0dERzlpNnp0cFhBZ3BDMFQwSlNRMDBU?=
 =?utf-8?B?ejFqM2FPNHgySGtGckNnUFdaVmtVSDFIeVRqZm95Wkw1dnp0cWpJOEg4SWxu?=
 =?utf-8?B?VEQ3eHV4R2paV3J4Skhjd0F5MVV1bCtQMnh5clhHWmNieEdwV3B2VmNWSmIy?=
 =?utf-8?B?Q2RGMUlidVBCR0JIWW5HbGQwZlVyMkFrWW9tempLRzMrMkhVdEZnSEdiSkJ1?=
 =?utf-8?B?WDY2RXYyY05GTko1aHB4UzYvdVdGeGlETGZ0alNIN2x3dlIyZ1liY3dIWmFT?=
 =?utf-8?B?RklVYnN4TEhOL1hCZHB6U2RYc3RaVEQwSllUMGxMOXlpTkUrdmlnN3B0RW1Y?=
 =?utf-8?B?WFQrc2x1bGtySURXZk5wem9QcXVjdk5MQThkWCtyNjU3a0tYMnZwTThINjds?=
 =?utf-8?B?L2pWcHJYUlowTHJtQjRsRktCUXdDWVBUeHZOYS9HdTRVWFltTTBJTEZEdyta?=
 =?utf-8?B?TEtXRlNOeTlYYnEwUnEwdlA4UE5TcVZFWnB5WnQwRDBmMjB0ZVQ3S3VZRCta?=
 =?utf-8?B?bmxhcUJRQW5wTlRubVBWNWZOTHQvSXQ3T2lJb0RoUGEyOHdmTkMyYURLbXNv?=
 =?utf-8?B?VFJEOTV1bmtDTVhkMkV2Q3lDcmtJMTU0MkRHanVZQ2pEY29WTEJGUkpXbTNw?=
 =?utf-8?B?M0JCV1NRTFdtejFOcDlyWlZIeE5hUzBQcnREN21XZVEwbVhlVDk3OUlZN1dO?=
 =?utf-8?B?bVBVbTBnd0RVRDBzRDZMRmRIT0xCWUY1ejUzYTF6QVMxZlhXVjdlYVdHdEM2?=
 =?utf-8?B?YlQyeHRVaUtTcEN1a1k3Qlh1Qnl3Q09Id2tmNlR6emJSZlNRZGs4WkVlZ3RT?=
 =?utf-8?B?S0NsMWFabVRUK25vMlQ1cFRubDl5WGpjbVFOd3A5VUwrV0NGWjE4N2VlT0N0?=
 =?utf-8?B?bHZXU1pIbDdEdFFDVTdCSHNOR0R0NnU4dld0YU1BSWJidk1zVzZQSnJ4ZmhT?=
 =?utf-8?B?dmM2OEozWDZ1Smtrcms4S3dRWTZ6ZVBjRmpOOStEUmhlbE5VWVlSR05IZzd4?=
 =?utf-8?B?L25ZOW85cWJPQzNoQ1BQdDVJeFZaZ08zZXFEMVByV2lmUGlyYTdKL2hGZlEw?=
 =?utf-8?B?ZmRpMGozL3ZVZkxpN3VtbE5wSkVjZkZmU2lNbVlVTUxjR3dSZzkvek5QcnpI?=
 =?utf-8?B?RXRXeEJOamQyc0JRNDU2c2plZllsNkhlb1RLZTc2SE5WenpzcXFzOXNhcCtm?=
 =?utf-8?B?QlJyR0c1QzBscTRxbE02bkZRMU9VYjF1YzNvS2dRd3VsYVptK2Y2TXZoUVdK?=
 =?utf-8?B?M2d5ajN1RjA2SjZzeVZQL0s2QUp5YTA5RW1Zb3hyMmh0T3FCQU53ZFprY2cr?=
 =?utf-8?B?VHFmc3puU1pJb2dKdGx0OE5kRUg5M1h6dnVLSkNSNk16S0RuekQ3NkpOOXpH?=
 =?utf-8?B?NTAwdi9iQk1KWWwwZXJnbTV4SGJkTlNOOU1LdCt6OHo1RzBTdVg3S2NZL2ll?=
 =?utf-8?B?Tk9nak92VngyaitnWUFVZEFabUR3akIwVFNYMnBsNkNCUFVNM3Q1ZitIV05F?=
 =?utf-8?B?OFEveW5zdU1HcUk5bXoyVnorQUlpNkNkRjJyK2p2anBxd1ZJaHZCSzY3QzFm?=
 =?utf-8?B?ZDhRMVBkSjNidmEvSkVwK1hMUDVDQ0ZvQ2xRRDZnQTk2RjkrcmlVWisxcVRv?=
 =?utf-8?B?T28zdGZKcTJaVEJTNTE5VVhRMDcyekwvQWVqMEV6bkczbVFYRWVtemRXV0Ra?=
 =?utf-8?Q?Ml9Ja0w5Z7fTkyxXMMu345SlMWR1114g0GJ+7C8wW0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECFFE5C6773FEB48852C2562511601C0@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0780adc-9234-40b4-8e91-08d9c06a2141
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 08:00:30.4707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUhA8iFur4o7c9HEHpnjJcuuHZk4A/29gxqqw0qyhQaGWrDvjt6XWri775/evorjz8g4weAufmvfkOf4cOj5evduiXt3MuOfTegmywSqVhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KSW5jb3JyZWN0IDA2NDQgaW4gTFRTIGZvciBuZXcgc2VsZnRlc3QgZmlsZSwg
c2VlbiBpbiA1LjQuMTY1IHNpbmNlDQoic2VsZnRlc3RzOiBuZXRmaWx0ZXI6IGFkZCBhIHZyZitj
b25udHJhY2sgdGVzdGNhc2UiIHdhcyBhZGRlZCB0byBMVFMuDQpJdCdzIGNvcnJlY3QgNzU1IGlu
IHVwc3RyZWFtLCBidXQgc29tZWhvdyBtZXNzZWQgdXAgaW4gTFRTIDotKA0KDQoNCmxpbnV4LTUu
NC55DQo9PT09PT09PT09PQ0KY29tbWl0IDhkMzU2M2VjYmNhMzUyNmZjYzY2MzkwNjVjOWZiMTFi
MmYyMzQ3MDYNCkF1dGhvcjogRmxvcmlhbiBXZXN0cGhhbCA8ZndAc3RybGVuLmRlPg0KRGF0ZTog
ICBNb24gT2N0IDE4IDE0OjM4OjEzIDIwMjEgKzAyMDANCg0KICAgIHNlbGZ0ZXN0czogbmV0Zmls
dGVyOiBhZGQgYSB2cmYrY29ubnRyYWNrIHRlc3RjYXNlDQogICAgDQogICAgY29tbWl0IDMzYjhh
YWQyMWFjMTc1ZWJhOTU3N2E3M2ViNjJiMGFhMTQxYzI0MWMgdXBzdHJlYW0uDQoNClsuLi5dICAg
IA0KZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldGZpbHRlci9jb25udHJh
Y2tfdnJmLnNoIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbmV0ZmlsdGVyL2Nvbm50cmFja192
cmYuc2gNCm5ldyBmaWxlIG1vZGUgMTAwNjQ0ICAgICAgICAgICA8LS0tLS0tLS0tLS0tLS0tLQ0K
DQoNCmxpbnV4LTUuMTUueQ0KPT09PT09PT09PT09DQpjb21taXQgY2ZmYWI5NjhlOTRlNTEzYmRj
ZWYyNWUxMTQwMjI0M2NlMjkxOTgwMw0KWy4uLl0NCm5ldyBmaWxlIG1vZGUgMTAwNjQ0ICAgICAg
ICAgICA8LS0tLS0tLS0tLS0tLS0tLQ0KDQoNCnVwc3RyZWFtDQo9PT09PT09PQ0KJCBnaXQgc2hv
dyAzM2I4YWFkMjFhYzE3NWViYTk1NzdhNzNlYjYyYjBhYTE0MWMyNDFjDQoNCmNvbW1pdCAzM2I4
YWFkMjFhYzE3NWViYTk1NzdhNzNlYjYyYjBhYTE0MWMyNDFjDQpBdXRob3I6IEZsb3JpYW4gV2Vz
dHBoYWwgPGZ3QHN0cmxlbi5kZT4NCkRhdGU6ICAgTW9uIE9jdCAxOCAxNDozODoxMyAyMDIxICsw
MjAwDQoNCiAgICBzZWxmdGVzdHM6IG5ldGZpbHRlcjogYWRkIGEgdnJmK2Nvbm50cmFjayB0ZXN0
Y2FzZQ0KICAgIA0KWy4uLl0NCmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9u
ZXRmaWx0ZXIvY29ubnRyYWNrX3ZyZi5zaCBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldGZp
bHRlci9jb25udHJhY2tfdnJmLnNoDQpuZXcgZmlsZSBtb2RlIDEwMDc1NSAgICAgICAgICA8LS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KDQotVG9tbWkNCg0K
