Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1330B392B68
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhE0KGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 06:06:33 -0400
Received: from mail-eopbgr40115.outbound.protection.outlook.com ([40.107.4.115]:64251
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236008AbhE0KG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 06:06:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ8usuNqD7cH/7R+YRKzuOSNxP7qag4HUZC/yMx0kD2WDVJJeOOr+QCGRfuV5i24f/JUYPbIPMvo2LVQFnD5nESLZAc8cr2jDiTIf+eNf2fQvpn7u10defFSy1aBhvlnJJojW/mjCUjt0iqGkachWZ8TJNZ0qPqHtcHF4GY2yMXhwRAPaiyUjR1cXnXW37yLtkJmIlcESxP3BL1WBOxVuh4dyMHFQ7j/Jo7vFe5/t6YBa4UIDz4b7HxTshRW7hLbNT7r/+fHeZhNQC4DN4OCvvToDizK6LJA52x4ckHE13Xr/+KQ4MsvKGlbBZie6g4eKCsTzdOZ0XhhxnFL8CfuXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG0az8fXZGtJFKw0cjO54qRtJaSTpF8FOychNNjpu/4=;
 b=H7PQwAwkiNb/k94RGVUxy2NfkBLw3eZJIt55SLCZjkhzulWb7JxtMUyzTJg/Cu5aHz63pUNm5tmQ2R8w+/vMEMTfZK3ZUPuvpMQUAJuQ1CdHgogHt5xQgCUkiRPGSXAqW1jN8TFOFa4Xmit7RsgTpKJQf5FMs2/d169Q+22e5FLqtkn1YHSkiAr8g6U255nMXcT5sA5SGUQZ8c+df5fu5w0HqpvHe65frdEHxmSp3gaF9xEfThzEle9MbTJHDj1ZzTGrC20twCNgMDV438Bj8FozI7Z/+yqw9JlALGbJhingn2l8jRgqpMzsWvpw/CXYnRgKhPEeZhmhiyBwXMn8bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WG0az8fXZGtJFKw0cjO54qRtJaSTpF8FOychNNjpu/4=;
 b=UsbG3bvnqZ+DTOPsmrDfst3/NuJWwwIIqKFZ+G7Jo8yoEnL+3qmT8/kP1YKTd5l+gxO8qBsaUw1HwvZTHMtYq3a7y+LkovXEThe5en0AvzcaTZjK4FJdRWIBC3dq5fBBcDNk7M8Igl/zr39qy+2uBZfoXQgoNGn1cpuKY6/bfV4=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR0701MB2570.eurprd07.prod.outlook.com (2603:10a6:3:96::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.12; Thu, 27 May 2021 10:04:51 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::85ed:ce03:c8de:9abf%7]) with mapi id 15.20.4173.020; Thu, 27 May 2021
 10:04:51 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jan.kratochvil@redhat.com" <jan.kratochvil@redhat.com>
Subject: Re: LTS perf unwind fix
Thread-Topic: LTS perf unwind fix
Thread-Index: AQHXUWNAMimraUixrEyqdytsWPBp16r0KrIAgAEx8ACAAbKpAIAADWIA
Date:   Thu, 27 May 2021 10:04:51 +0000
Message-ID: <ef44cde0f3493eb9ab2efe951bc03e4e6ccc416b.camel@nokia.com>
References: <682895f7a145df0a20814001c508688113322854.camel@nokia.com>
         <YKz2RIcTyD/FCF+a@kroah.com>
         <45b140543ccb85ab184ed17befca4a9e64661051.camel@nokia.com>
         <YK9jhtj/hwTKU5+N@kroah.com>
In-Reply-To: <YK9jhtj/hwTKU5+N@kroah.com>
Accept-Language: en-US, en-150, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nokia.com;
x-originating-ip: [131.228.2.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45773392-d530-4512-b878-08d920f6de70
x-ms-traffictypediagnostic: HE1PR0701MB2570:
x-microsoft-antispam-prvs: <HE1PR0701MB2570E2AEC7EC82AAB9660B58B4239@HE1PR0701MB2570.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yrubQn06V3Eob+FCDkmUQ/S3eCsqOe9UdpCbvY/zZHdm78EUuFXdNE5otJpJqAE+BhRwYQL9mJFSn9ECj84ABjwQM5botbH028Xm0GZWnzYZWqeniDTt2URoKMIZ5p5DY86cwiZRGlrXvVRWG3CzeA4wkJPaYRyWHDcReNUNcwh8adnaQNkQo9zcdK1oOR5BAUiWxSZ8ZKgUyBg45LVLpXEmZTM4UNMTa9dTGiVDLKTRU+NBjB3PomVVYY6y5PkCnJWLWw9xHbwOqk/X1LCFn/d7Nb7VZG1e4x9LfC6f3VYUnrKBPa/DmscGOTYKkYi30BQusf0+5Z1RCrrkvgMtCPi3953RJQmw7voRWsOT01HcS1EtZqCZrhXfTf++Fx5W1dvsAJnX+JbEqmK14YAtIOhnpk+C8PiUxlCW/e7qtyC12ZsIL1ZUodEgLdxTDOnZXnpzUXC0q2T/n28YYm80dFf+GZ4hvRnJylv4RuGbrVRbVEAa7pBnAlkK0YViQ2pKe/q8Wz+Ky7yMCmj7vRsHeNJAWDee9wzpg3k5jgOKB6Hg3icp8V+xgL2XAMavWQrLmwA9ifjiXo9zsfiUGS/VTvIvnxslgiynVoXkMZJGQcA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(2906002)(38100700002)(122000001)(8936002)(6512007)(478600001)(3480700007)(8676002)(6916009)(4744005)(54906003)(6486002)(26005)(316002)(6506007)(186003)(4326008)(36756003)(76116006)(91956017)(66946007)(66446008)(66556008)(2616005)(86362001)(71200400001)(5660300002)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZHhDUEFKUkxTWWd4SFhkWkF5Rm80L2VDTGRRY293ZVJ4UTQ4VE5tVUJ6RldK?=
 =?utf-8?B?QjlKSERKaWczbTNzMXlEeTA2cXpzM0VycXZTRU4zNjMvSjdRQjZWbFpYZGFU?=
 =?utf-8?B?V1UrTmtiMGFyMTREV3pERmUyU0xtWWZjZUZ2NTlSUXJERkVtZVh1Y05GNkRS?=
 =?utf-8?B?UGlxWGd5MVBIb2lLMXdwSzVocFpmczV6SnNKRDNRRmxhdnlRdUFPenlsY1ZB?=
 =?utf-8?B?bDVEeVBLNjhDRVJjUHBKdUJVNTZ1a2VyT1lQcHh0cGtEeEJhNm9pUm1CMjJP?=
 =?utf-8?B?dmZiMGxvQy9tQ3l2TkhXY2dPQ2RzZ3dnMDI4cFZDNGpWK0pZK2NMck1QU05k?=
 =?utf-8?B?d0V4U2loNk1yNWp0UFlEVHdyRk1jM1hYaW1rUmM5Rk5zSDl0bWY5MlN5V2RP?=
 =?utf-8?B?aFJUcUZCRXNrNk1JemppcHB1WU0xWlJ5cTl4aHEycTQvUTBxZjFPRzViRlRr?=
 =?utf-8?B?aEY1YzVnV1dBTWpJQUcxdExOckZYQzVOZEMxMmRZQ0hjRk1CeHpXMkU2c3cz?=
 =?utf-8?B?M0VkbWpkVi9ZZVNFblduVEJvN1doWU12TmpJK1AyVEZwb0VmbGFlL3BQODdu?=
 =?utf-8?B?RjgyaEFVNmZhMGtadjliVHRGRlhOTlhZSXBTUFh3b3hhbWNJeC9JUy9oemRp?=
 =?utf-8?B?ditBYW9ZZFFrbzl4eWlsZ3lpN0g4Vk5LODIxZnB0eWtoRU5XNW9kQXJTSU5B?=
 =?utf-8?B?d1JYRXNjcUZBdUVHK3ZTQ1Z2MHd4MDk5NEVHeExxdXN2b0YxZ2tkSW02Vldj?=
 =?utf-8?B?aXhXNmd4YkdML0llUzUyVWxnMll3a1JaNWE5Y1FOUU5jSzFLeHBzN2tqek5B?=
 =?utf-8?B?RC92bG44aTY2UStuNXgwOGU0eUp6Z2J5ckhuS2xxZmhQUCtZeUlNTGpVNlNq?=
 =?utf-8?B?Rk5NSk44bGZ6K0NhcXAzSFc3Q2RKTU93ZHIvRzgzOXl6RjIrejAxN1BwOUpo?=
 =?utf-8?B?K3huV2tBZUt3MGJqS0x0eXBCelJGRkVOSVMyNzNVYlc1UGxtejBPelVuUnJZ?=
 =?utf-8?B?d0Q2UmhMNVRVOE5PLzdYQVJBTHllb0h1SVZCM202OWUxT2Q0NVMzL1NuL0lk?=
 =?utf-8?B?K1RpeHpoUGtiVVZleG91YzJLU25IclNsZWhmdWM5VlV3WGlhUEZ3UWhQYUxT?=
 =?utf-8?B?RXA4WVM3MnhsSkhObFE2VFR6eUNYZTNueS92alA3aTVzMEg4VWdUNGRNM3Qy?=
 =?utf-8?B?bktZS0RMZHRnQzh4eG05OFgvc2RCOExocUZwdDNodlA5ZFc1YkF4aUhQZjRq?=
 =?utf-8?B?ZnV2VURQU1dGazE5RlVtT2RqMTdQeG1rSEY4QTRGU3hWaktndVJhZ1Z3bm9H?=
 =?utf-8?B?bUNFMTYzV3NDWmE0Tk1EVkxaMnp3eDhQWXpvVmFBeFpYQkxnSy8wRmVGM3hk?=
 =?utf-8?B?VitrM1R3eTZ4SGdKUzlIWFFCWjgvOTI1Zk1DUkFQVHlZWnlXYmdpTm1teCt1?=
 =?utf-8?B?dUQ1WlZKSGoxWUlHZXFlTEtaZEhvZWdyVTJwckRDdVlZSnpsL3VkcXFIUk5W?=
 =?utf-8?B?akhFWTh6VnpYb29STzhFK21QdnNuRURPcnJlamN4RHhCUFpCd05pd0ZHb0tT?=
 =?utf-8?B?ekQwMFlxNlJVWUJQalN6Vm42S2k4dCtGRmpLREs2d21jaldVa3FxRWcxRFpm?=
 =?utf-8?B?S3lOQ1I0TVdQcUNrMjdzQTdySkFQVEN2TjF4UmVrais2QmNnZDhKTE42TFMx?=
 =?utf-8?B?R200cDdrdmk5b2QxS0hrMWtxR0VKS3g5ZDVrajIxQXVrZjRqMDN3K0MzZXJT?=
 =?utf-8?Q?gXCUmBj9T5jNAx3523oE4xPtHQts/eRpmvESo0J?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <61908516BABAFB4F97E5EE61C857342B@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45773392-d530-4512-b878-08d920f6de70
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 10:04:51.3979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImvTR5Sp2gs5qiM4iLcBkMtNr4KdHTnCTxzxafjJ5KC3KfjOpQ9ycRoH1vA4NgeI5cThdTJZ0U8ZleANpfooo4quuQD9apAmidVzWmaJFPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2570
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KUGxlYXNlIGFwcGx5IHRoZXNlIHR3byBjb21taXRzIHRvIDUuNC55DQoob3Ro
ZXIgTFRTZXMgYXJlIHByb2JhYmx5IGZpbmUgdG9vLCBidXQgSSBkaWRuJ3QgdGVzdCk6DQoNCg0K
Y29tbWl0IGJmNTNmYzZiNWY0MTVjZGRjNzExODA5MWNiOGZkNmEyMTFiMjMyMGQNCkF1dGhvcjog
SmFuIEtyYXRvY2h2aWwgPGphbi5rcmF0b2NodmlsQHJlZGhhdC5jb20+DQpEYXRlOiAgIEZyaSBE
ZWMgNCAwOToxNzowMiAyMDIwIC0wMzAwDQoNCiAgICBwZXJmIHVud2luZDogRml4IHNlcGFyYXRl
IGRlYnVnIGluZm8gZmlsZXMgd2hlbiB1c2luZyBlbGZ1dGlscycNCmxpYmR3J3MgdW53aW5kZXIN
Cg0KDQpjb21taXQgNGUxNDgxNDQ1NDA3Yjg2YTQ4MzYxNmM0NTQyZmZkYzgxMGVmYjY4MA0KQXV0
aG9yOiBEYXZlIFJpZ2J5IDxkLnJpZ2J5QG1lLmNvbT4NCkRhdGU6ICAgVGh1IEZlYiAxOCAxNjo1
Njo1NCAyMDIxICswMDAwDQoNCiAgICBwZXJmIHVud2luZDogU2V0IHVzZXJkYXRhIGZvciBhbGwg
X19yZXBvcnRfbW9kdWxlKCkgcGF0aHMNCg0KICAgIFsuLi5dDQoNCiAgICBGaXhlczogYmY1M2Zj
NmI1ZjQxICgicGVyZiB1bndpbmQ6IEZpeCBzZXBhcmF0ZSBkZWJ1ZyBpbmZvIGZpbGVzDQp3aGVu
IHVzaW5nIGVsZnV0aWxzJyBsaWJkdydzIHVud2luZGVyIikNCg0KDQpUaGVzZSBjb21taXRzIGZp
eCBzb21lIGJyb2tlbiBiYWNrdHJhY2VzIHdoZW4gdXNpbmcgdGhlIHBlcmYgdG9vbC4NCg0KVGhh
bmtzIQ0KLVRvbW1pDQoNCg==
