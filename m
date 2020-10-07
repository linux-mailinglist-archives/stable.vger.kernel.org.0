Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC02285B3E
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgJGItC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 04:49:02 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:55309 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgJGItB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 04:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602060541; x=1633596541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DhE+3rR02b6KzfMf2ZTiSgLoY/6hg+L+vnMGM8B1A5Y=;
  b=cRwwCJrScJLnA6claDaitH3ncG7EjdV6iUUfAG2uiZjF0mHFvrAg2DpA
   oq8zE3JiJlQR79dFtiFKvafGjMV9ZwaXtxjS1p8gAdqPWyxe9jO7BtS3q
   UhB6taqLojCmz5PPZ9tAUuLPr/4tvGOEjpKOLob6w412vqYKUal46p48k
   NiNJz1zfKOSwDWGnjTqR5FjAVKHVjifpWv8ZHuln+sw8J0WhhAvNNsJEQ
   RbmQWPhs4rx341m3xQZt7zapqRWc9GqNm896k0dLlIISVvfION+4W7DRm
   9M3UrcNzKAHiXDM65K8xCSKwwennIgN5X5JdTV9WMS8/KrBWuE02h2HK7
   g==;
IronPort-SDR: d7aWoCLj+oj021gI54dTZp/YmK/i8FPa/aPTxEThpkNQfLQ2n8WWXCYhcLx3rMY54UmAlyytdp
 Kb1D/NHPjSlu0q/fc8x1TyzDo3IM3ssX3dPYuTecN3qeXbctT4TAJxhfJXsJco04sZp8sGVeN8
 SmAeij8ad9g9YAsFEzh5o5dO8diJv5EALR5UYJVfEK8mj4sgQ3+7Mv/aHJOOjvCRm/r/CJsm0R
 XIE5eM8zXZD/xd9Bwg1Ey4BLefs+2bRrL59IP58zCofIY2LtBkwv2QIrCzx1SyS1pXrVIGguwj
 OWs=
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="98581730"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2020 01:48:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 01:48:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 7 Oct 2020 01:48:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiXYD+lQbsaC/5j3XY7MsA8jo2ta/FE89RSj1qPMNMKUeg7DdAIq0TKvj1pcWYzonUsRt7RqKlj8nbNNZA0pCrPaLYbz7ZGDWUIPVDAZdzMSDvI0vShv98nWfzWO4CefDC/WP4aIU/XiE5iKgxRmFn5LVd5xyZDqeE3Gi2YMMMxosrvxl1JY2H/r3l5QGf3vV76EPPV+kY/sgt5sZvlrN/FowQueAKckwUnLtw8+mOE03V2277S+u5+XrhlN9PWwhnVHMyi/g9rMXdo32LtVh6UEMfd1Z+QyDLyjunFzLdnp2o+OYjHiMBzZtVv3BO5nX713h9YWU+TFcMWI36LweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE+3rR02b6KzfMf2ZTiSgLoY/6hg+L+vnMGM8B1A5Y=;
 b=Unj5GP/db6zG99fOchCKNSQHBwnfuAKZD9d6x4yFWavuTMnCMbNYXWCqLh1cKzBnY7nNX2hxzH5b6aZG2EJXlS6gUw4XDXJ60S2FCGpdITMXUePsll429sFzkeQdgPyxdSexnA6hV2wNUkjNgXRkdPvLJer9qIvpkvVKDCmj12YImRaTonuszP15soBIzPmt9wLOpg4rxOU4CtB146rD9iRWCfJnj+FpktEIUMXJJAEOZGEKSd0t/L5LwMHi/K8g+sD/WcLQlnfsovo5ydmq9/HZgFkSS1mohUeyusq8yE81FQeMp58mibpQ8J9mpyyKMMCibBO2fx/Itrgmf44UPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE+3rR02b6KzfMf2ZTiSgLoY/6hg+L+vnMGM8B1A5Y=;
 b=odOU4Q7AYA+tFGw1PTWg4bDF+8DwSMXYl20D5hyHApj2IIzIqFn8m/rDcagY6MRSe7n66roUNYkkcEoISp/D9o8TRViZKQudrExdRXsnim0WvPyJUMnUkKzHwybnQeeUu6uG070QBZ6LqcVwq9LaDWiXYtCAnB493RT3bieW0Bo=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB2574.namprd11.prod.outlook.com (2603:10b6:805:59::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 08:48:45 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::7c1b:6212:7f1e:5c6f]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::7c1b:6212:7f1e:5c6f%3]) with mapi id 15.20.3455.021; Wed, 7 Oct 2020
 08:48:44 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <alexander.sverdlin@nokia.com>, <linux-mtd@lists.infradead.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <matija.glavinic-pecotic.ext@nokia.com>
Subject: Re: [PATCH] mtd: spi-nor: Don't copy self-pointing struct around
Thread-Topic: [PATCH] mtd: spi-nor: Don't copy self-pointing struct around
Thread-Index: AQHWnIapYR7N4KU+CU6dtI266TT3Dg==
Date:   Wed, 7 Oct 2020 08:48:44 +0000
Message-ID: <f815c4e5-eabe-af3d-efb6-87000f5ba411@microchip.com>
References: <20201005084803.23460-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20201005084803.23460-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: nokia.com; dkim=none (message not signed)
 header.d=none;nokia.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1282a35-fec6-4ba2-4c13-08d86a9dcca6
x-ms-traffictypediagnostic: SN6PR11MB2574:
x-microsoft-antispam-prvs: <SN6PR11MB25749541B84536123DC54115F00A0@SN6PR11MB2574.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X/lm+uyEOnwvcKfSFmJMwLjCJq331PEtNiNa3dHmeJteQMJCH0hLApyAOXcultLDIwzKpvk/ov/qrMarfDj2tEILmOe3JWhBTBBdaxdnbfj63hrgVvsScM6xJlQI7rVOciCLCHoUzIFEPMltz9CcasyxH98+5TNKcO4Jp0PE0yx1H6+iFNPYnQF2og1CeGvBOEeT6ACjg3D+rjuCMQyEj146dJ37/k0qFOTkhX3ppmKheO00r3aUqNkSCcUCNYC4Qwmcedb0xMb2SLtpIzucTaR88sCSuSKf8reWWPuJlrKknoLgtekPgV9A02Kb4NYgDmoChJg+fvzXynZ1wX4tgAYej+VUVhwPTFmXTu7rCPOSxTIv1qfAMHMB2Q/hLxsC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(366004)(376002)(478600001)(8676002)(31686004)(2616005)(26005)(71200400001)(2906002)(31696002)(36756003)(6486002)(86362001)(6512007)(76116006)(110136005)(66446008)(6506007)(8936002)(4326008)(186003)(83380400001)(296002)(316002)(66556008)(66476007)(66946007)(53546011)(5660300002)(64756008)(54906003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TAH9ClBN6iNAljqm44iXtpgoXT9DkIeiKGYdLXA0MIsZDoFLb036BQyLvCAR44BtPxmeQ1a0K5e77jXrzRMP7gQNIzLGUHy79o2PQVLuA/cT3/FeqB3i2XU5uEBRkgUm9Zc6UhKZqA4lCbYSfC04RTP8iqCongDWXuITrAtlzLZsvHmnhdPBf6Upc4fP2RHL3uVeI+KDPQZOWAuddelYjxk6m8PPK5Xby2SRxoj9eOgyE1kUW8SWOODITk6oZq+HxmolxndTXOHALx+/bzVvOG8i/5AMFkE0H3adPoJcKMn1S0TwopCkATYWUy48pukRfKTwMKR18iaWeHOyXvdqlDuJNMNKeis+9zo+FyV+YrTqVPCB7t98ButFoUc2akjlylunhDJLDAIAB9no+TVbmw8iyOR7DjNgaKSQRnnSbAE3AoOdkQma78GjSTmzIVGvNBr2KUV0akJulVmBRS+OkO5XyNnnPfJTBWTwpneHgd6NM1L1Sh+8YTc3axug9QReiqA1J+TzwTIOMNo11Y/UAUJY0lvvZiL3dQ+hebUSUnjpdV0TN6KtdkA3vsFEvtsYnP8mNtz6ScR35/VfNJI9djyun0T+hx/xHEseOfhPCNE2l97BY0AB7beFyom4kjXc6ho+xjpCJRlYOK9bUzvqGQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A46B7CC5A4696459646E5C20AF17174@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1282a35-fec6-4ba2-4c13-08d86a9dcca6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 08:48:44.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JmrlP90QFEWylxhfVlmzZMkzzyjui8eHOvrdKl9F92rNgMFg6uIRMVM3WvYnR9WG8rJkNBkKgntzs/xOlt7rnxPViQoW+Puz4KOSjxKjMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2574
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTAvNS8yMCAxMTo0OCBBTSwgQWxleGFuZGVyIEEgU3ZlcmRsaW4gd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogQWxleGFuZGVyIFN2ZXJk
bGluIDxhbGV4YW5kZXIuc3ZlcmRsaW5Abm9raWEuY29tPg0KPiANCj4gc3BpX25vcl9wYXJzZV9z
ZmRwKCkgbW9kaWZpZXMgdGhlIHBhc3NlZCBzdHJ1Y3R1cmUgc28gdGhhdCBpdCBwb2ludHMgdG8N
Cj4gaXRzZWxmIChwYXJhbXMuZXJhc2VfbWFwLnJlZ2lvbnMgdG8gcGFyYW1zLmVyYXNlX21hcC51
bmlmb3JtX3JlZ2lvbikuIFRoaXMNCj4gbWFrZXMgaXQgaW1wb3NzaWJsZSB0byBjb3B5IHRoZSBs
b2NhbCBzdHJ1Y3QgYW55d2hlcmUgZWxzZS4NCj4gDQo+IFRoZXJlZm9yZSBvbmx5IHVzZSBtZW1j
cHkoKSBpbiBiYWNrdXAtcmVzdG9yZSBzY2VuYXJpby4gVGhlIGJ1ZyBtYXkgc2hvdyB1cA0KPiBs
aWtlIGJlbG93Og0KPiANCj4gQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFk
ZHJlc3M6IGZmZmZjOTAwMDBiMzc3ZjgNCj4gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIE5P
UFRJDQo+IENQVTogNCBQSUQ6IDM1MDAgQ29tbTogZmxhc2hjcCBUYWludGVkOiBHICAgICAgICAg
ICBPICAgICAgNS40LjUzLS4uLiAjMQ0KPiAuLi4NCj4gUklQOiAwMDEwOnNwaV9ub3JfZXJhc2Ur
MHg4ZS8weDVjMA0KPiBDb2RlOiA2NCAyNCAxOCA4OSBkYiA0ZCA4YiBiNSBkMCAwNCAwMCAwMCA0
YyA4OSA2NCAyNCAxOCA0YyA4OSA2NCAyNCAyMCBlYiAxMiBhOCAxMCAwZiA4NSA1OSAwMiAwMCAw
MCA0OSA4MyBjNiAxMCAwZiA4NCA0ZiAwMiAwMCAwMCA8NDk+IDhiIDA2IDQ4IDg5IGMyIDQ4IDgz
IGUyIGMwIDQ4IDg5IGQxIDQ5IDAzIDRlIDA4IDQ4IDM5IGNiIDczIGQ4DQo+IFJTUDogMDAxODpm
ZmZmYzkwMDAyMTdmYzQ4IEVGTEFHUzogMDAwMTAyMDYNCj4gUkFYOiAwMDAwMDAwMDAwNzQwMDAw
IFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDA3NDAwMDANCj4gUkRYOiBmZmZm
ODg4NDU1MGM5OTgwIFJTSTogZmZmZjg4ODQ0ZjljMGJjMCBSREk6IGZmZmY4ODg0NGVkZTdiYjgN
Cj4gUkJQOiAwMDAwMDAwMDAwNzQwMDAwIFIwODogZmZmZmZmZmY4MTViZmJlMCBSMDk6IGZmZmY4
ODg0NGY5YzBiYzANCj4gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAw
MCBSMTI6IGZmZmZjOTAwMDIxN2ZjNjANCj4gUjEzOiBmZmZmODg4NDRlZGU3ODE4IFIxNDogZmZm
ZmM5MDAwMGIzNzdmOCBSMTU6IDAwMDAwMDAwMDAwMDAwMDANCj4gRlM6ICAwMDAwN2Y0Njk5Nzgw
NTAwKDAwMDApIEdTOmZmZmY4ODg0NmZmMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MA0KPiBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQo+
IENSMjogZmZmZmM5MDAwMGIzNzdmOCBDUjM6IDAwMDAwMDA0NTM4ZWUwMDAgQ1I0OiAwMDAwMDAw
MDAwMzQwZmUwDQo+IENhbGwgVHJhY2U6DQo+ICBwYXJ0X2VyYXNlKzB4MjcvMHg1MA0KPiAgbXRk
Y2hhcl9pb2N0bCsweDgzMS8weGJhMA0KPiAgPyBmaWxlbWFwX21hcF9wYWdlcysweDE4Ni8weDNk
MA0KPiAgPyBkb19maWxwX29wZW4rMHhhZC8weDExMA0KPiAgPyBfY29weV90b191c2VyKzB4MjIv
MHgzMA0KPiAgPyBjcF9uZXdfc3RhdCsweDE1MC8weDE4MA0KPiAgbXRkY2hhcl91bmxvY2tlZF9p
b2N0bCsweDJhLzB4NDANCj4gIGRvX3Zmc19pb2N0bCsweGEwLzB4NjMwDQo+ICA/IF9fZG9fc3lz
X25ld2ZzdGF0KzB4M2MvMHg2MA0KPiAga3N5c19pb2N0bCsweDcwLzB4ODANCj4gIF9feDY0X3N5
c19pb2N0bCsweDE2LzB4MjANCj4gIGRvX3N5c2NhbGxfNjQrMHg2YS8weDIwMA0KPiAgPyBwcmVw
YXJlX2V4aXRfdG9fdXNlcm1vZGUrMHg1MC8weGQwDQo+ICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVy
X2h3ZnJhbWUrMHg0NC8weGE5DQo+IFJJUDogMDAzMzoweDdmNDY5OTZiNjgxNw0KPiANCj4gRml4
ZXM6IDFjMWQ4ZDk4ZTFjNyAoIm10ZDogc3BpLW5vcjogU3BsaXQgc3BpX25vcl9pbml0X3BhcmFt
cygpIikNCg0KSSB0aGluayB0aGUgY29ycmVjdCBGaXhlcyB0YWcgaXM6DQpGaXhlczogYzQ2ODcy
MTcwYTU0ICgibXRkOiBzcGktbm9yOiBNb3ZlIGVyYXNlX21hcCB0byAnc3RydWN0IHNwaV9ub3Jf
Zmxhc2hfcGFyYW1ldGVyJyIpDQoNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gVGVz
dGVkLWJ5OiBCYXVyemhhbiBJc21hZ3Vsb3YgPGlickByYWRpeDUwLm5ldD4NCj4gQ28tZGV2ZWxv
cGVkLWJ5OiBNYXRpamEgR2xhdmluaWMgUGVjb3RpYyA8bWF0aWphLmdsYXZpbmljLXBlY290aWMu
ZXh0QG5va2lhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTWF0aWphIEdsYXZpbmljIFBlY290aWMg
PG1hdGlqYS5nbGF2aW5pYy1wZWNvdGljLmV4dEBub2tpYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEFsZXhhbmRlciBTdmVyZGxpbiA8YWxleGFuZGVyLnN2ZXJkbGluQG5va2lhLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYyB8IDUgKystLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tdGQvc3BpLW5vci9jb3JlLmMgYi9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYw0K
PiBpbmRleCAyYWRkNGEwLi5jY2UwNjcwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL210ZC9zcGkt
bm9yL2NvcmUuYw0KPiArKysgYi9kcml2ZXJzL210ZC9zcGktbm9yL2NvcmUuYw0KPiBAQCAtMjcw
MSwxMSArMjcwMSwxMCBAQCBzdGF0aWMgdm9pZCBzcGlfbm9yX3NmZHBfaW5pdF9wYXJhbXMoc3Ry
dWN0IHNwaV9ub3IgKm5vcikNCj4gDQo+ICAgICAgICAgbWVtY3B5KCZzZmRwX3BhcmFtcywgbm9y
LT5wYXJhbXMsIHNpemVvZihzZmRwX3BhcmFtcykpOw0KPiANCj4gLSAgICAgICBpZiAoc3BpX25v
cl9wYXJzZV9zZmRwKG5vciwgJnNmZHBfcGFyYW1zKSkgew0KPiArICAgICAgIGlmIChzcGlfbm9y
X3BhcnNlX3NmZHAobm9yLCBub3ItPnBhcmFtcykpIHsNCj4gKyAgICAgICAgICAgICAgIG1lbWNw
eShub3ItPnBhcmFtcywgJnNmZHBfcGFyYW1zLCBzaXplb2YoKm5vci0+cGFyYW1zKSk7DQo+ICAg
ICAgICAgICAgICAgICBub3ItPmFkZHJfd2lkdGggPSAwOw0KPiAgICAgICAgICAgICAgICAgbm9y
LT5mbGFncyAmPSB+U05PUl9GXzRCX09QQ09ERVM7DQo+IC0gICAgICAgfSBlbHNlIHsNCj4gLSAg
ICAgICAgICAgICAgIG1lbWNweShub3ItPnBhcmFtcywgJnNmZHBfcGFyYW1zLCBzaXplb2YoKm5v
ci0+cGFyYW1zKSk7DQoNCm5lYXQhDQpXaXRoIHRoZSBGaXhlcyB0YWcgZml4ZWQsIG9uZSBjYW4g
YWRkOg0KUmV2aWV3ZWQtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWljcm9jaGlw
LmNvbT4NCg0KPiAgICAgICAgIH0NCj4gIH0NCj4gDQo+IC0tDQo+IDIuMTAuMg0KPiANCg0K
