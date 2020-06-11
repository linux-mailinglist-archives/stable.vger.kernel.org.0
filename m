Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561EE1F6FC5
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 00:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFKWRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 18:17:39 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:15521
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbgFKWRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 18:17:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDUvJx4RFrLD9a0Hn3w4p5O1TcFii/c8AsIzYgr+BRXGOKfhCMFQYKhL4/Fww6vhRKXKYq7YJUfmKwh1B/zoUrldXxeOMqU9vjKV0pPtHUTz6Rnjk7bs/OmtMCeDFX3rLHIbtd5i4U5mRVYw4teaVJ8nDUe9cc+++ZmE0tC3tx64czcTR6/2YZ88c8i4Yu8XpZIoA3Fgd/ek/1el8u66HKfVSgBJP5MiPVYzQTJ5CkmYTWPYcVmQIEetQhvZwMfABicsypxkx7ACsPiMSvPX/JRZ7Rg38WuOJNVWdZVJlcJQDj+hJyeHYcMRf71ObZ4vVN25Mh1CWJnQuOsMReu4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/wLyGNP8P7wkKjHYZ+thMLyxzgwUd9YwTOsJhNYAfc=;
 b=atyuoOKD5zf7tU2o4CFar+JoVmO0ntPpYSZO8scT1nAAzEBVDkpXc0xPGraZ4UsTlJWATmLuVeN1/WXnEBCGU62CZhWUBklXBkAu+7gpQKgq605dQWjvNp0IZEloH2SYU6z6N69Gu4PmVhNVIB1W5MGPYdYNrQmtDcN2WRr9DuwV87mNg/gKgMXxyDkCV/PsTNmWl6Z+j3RcMHk/6bXCB4z3Y1gREj/u/jn6UDoFnX8+annCVZ5EF/EfuqxlWIwiBLt4cNdss4GObNLPS3bXebZvvWyKmf/GOuCZNOYD38cV7EFn9yTAJrMqE3umIY0bbQ4UiQzZjd2M/qOqDSF00w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/wLyGNP8P7wkKjHYZ+thMLyxzgwUd9YwTOsJhNYAfc=;
 b=VD60zoJmM6J6KKDLfH7KcqjMO+hDJ+yOFW1VK2vwEBgVDcYqXIIWTZO/n0ssJYxJxW3fFjGnlmdO5g/UBrVidg6zCtxz1K9OaLOvLfYiTIXeKMN2SvexDkm3rw9ZgnLdz0T0LqvYRaA8tIyB6nDCKl1BiB3vLqKbtd2oRL7D8co=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6415.eurprd05.prod.outlook.com (2603:10a6:803:fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Thu, 11 Jun
 2020 22:17:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:17:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        Mark Bloch <markb@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH 4.19 25/25] Revert "net/mlx5: Annotate mutex destroy for
 root ns"
Thread-Topic: [PATCH 4.19 25/25] Revert "net/mlx5: Annotate mutex destroy for
 root ns"
Thread-Index: AQHWPoakt4ZlaJvazkSLO+TkHJ4eL6jT/yWA
Date:   Thu, 11 Jun 2020 22:17:33 +0000
Message-ID: <9233056dbbce44ab5e3a3d401e4e5da119a36780.camel@mellanox.com>
References: <20200609174048.576094775@linuxfoundation.org>
         <20200609174051.624603139@linuxfoundation.org>
In-Reply-To: <20200609174051.624603139@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eae2f9bb-5d53-4469-917d-08d80e553d4e
x-ms-traffictypediagnostic: VI1PR05MB6415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6415274F0B5BBAA65D07B6F7BE800@VI1PR05MB6415.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2LgKirO2OkXIPhPSq/CG3mtoVbN5sc1mJ6AiR3tYPJ/n/zUpnjftQTQYROksWuDIb2zB+4uCdn6BbP4CcP25GS/JiFi0VN5gq9rkUhrAc5hP32LKJa9y+XGtrY1jB4H/sLYTPF0v3wqE3B+rqOn1kBsEz1bkfxjlbPRj7yuqY9OZWBYe9TTFU/X1chgMkmq+2Ezp6LKBDO1L5yJTygmgIS5ZqApqovXLsj0MbeCF6W5U8v1oOx9U3kWFNPgjjyGYHtAyCdZol1nzNn9mEdoPRa82ve41a6ybTo81oq/OMSX0ZWRGmLX6tg84lF9GwfpcD8J5T8hGQ2ycztYmU+ETq0fA6HTEH5BSgAaa3O4XgAgrcVmYh/WE6l+VweJqmUwlcdd4tJ/uQdG3VRZ8BSvl7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(478600001)(83380400001)(86362001)(91956017)(66946007)(26005)(66556008)(66446008)(64756008)(76116006)(2616005)(186003)(6506007)(36756003)(66476007)(966005)(4326008)(5660300002)(2906002)(6512007)(71200400001)(8676002)(316002)(8936002)(110136005)(107886003)(6486002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Uo61zOYyOa1VUR4WOqjbDSFw0yzlhcYO2YVF5E9JX5PTpj03621z8zn1fezluFcLmOzN3M7/coNubgimBZ+u7Yd48M5AsdWj0XWc2hPWt+tQ7c0DWeuk+ri5VivXJzXD2borYhS6fb7+l0HDUS1VmTLy/Bm39Gxqa9kv3KiCpx8XrmJI4ZJvm3WgPphb5XTpA6HE60kd+C/a1AM1zcL+TjYI4EsESFT+9+eEEiMTXlMnXNRJXDZw5/quRgU5V51y4WSD0x3hjRaVdq5c+WPUfqB+V6Bd5D+CjPzjlucYQ4raiotT/b1HRKsG15+J4e3HvCwEP1QA3Z6i61I3fsT66cipZuC03xEm5PMs/ejWY1eDxH+cNjQGDqqoNozKWUt6N8q0ch1DPy8gJ7u7qLY5l+TBE99B8Rz1iKuR/k0zriABv5zCMfSDi3tJe3GcylarM77ua41FiLboh7W3kQiwU3AAbkKBJ6t3nZL9Ocn5Lg0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE8410C29DF85F49B4087BCB8350FFC6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae2f9bb-5d53-4469-917d-08d80e553d4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 22:17:33.4004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zOAcWe8XSP/1xP6BQPM7NWMuUkHZk2G2BcI6TBtgO7YFmsnpStMMGHjtgorUqG/vX36jkPffnSnyk1VQe/k9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6415
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTA5IGF0IDE5OjQ1ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IEZyb206IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmc+DQo+IA0KPiBUaGlzIHJldmVydHMgY29tbWl0IDk1ZmRlMmU0Njg2MGMxODNmNmY0N2E5OTM4
MWEzYjliZmY0ODhiZDUgd2hpY2ggaXMNCj4gY29tbWl0IDljYTQxNTM5OWRhZTEzM2IwMDI3M2E0
MjgzZWYzMWQwMDNhNjgxOGQgdXBzdHJlYW0uDQo+IA0KPiBJdCB3YXMgYmFja3BvcnRlZCBpbmNv
cnJlY3RseSwgUGF1bCB3cml0ZXMgYXQ6DQo+IAlodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIw
MjAwNjA3MjAzNDI1LkdEMjM2NjJAd2luZHJpdmVyLmNvbQ0KPiANCj4gCUkgaGFwcGVuZWQgdG8g
bm90aWNlIHRoaXMgY29tbWl0Og0KPiANCj4gCTljYTQxNTM5OWRhZSAtICJuZXQvbWx4NTogQW5u
b3RhdGUgbXV0ZXggZGVzdHJveSBmb3Igcm9vdCBucyINCj4gDQo+IAkuLi53YXMgYmFja3BvcnRl
ZCB0byA0LjE5IGFuZCA1LjQgYW5kIHY1LjYgaW4gbGludXgtc3RhYmxlLg0KPiANCj4gCUl0IHBh
dGNoZXMgZGVsX3N3X3Jvb3RfbnMoKSAtIHdoaWNoIG9ubHkgZXhpc3RzIGFmdGVyIHY1LjctcmM3
DQo+IGZyb206DQo+IA0KPiAJNmViN2EyNjhhOTliIC0gIm5ldC9tbHg1OiBEb24ndCBtYWludGFp
biBhIGNhc2Ugb2YgZGVsX3N3X2Z1bmMNCj4gYmVpbmcNCj4gCW51bGwiDQo+IA0KPiAJd2hpY2gg
Y3JlYXRlcyB0aGUgb25lIGxpbmUgZGVsX3N3X3Jvb3RfbnMgc3R1YiBmdW5jdGlvbiBhcm91bmQN
Cj4gCWtmcmVlKG5vZGUpIGJ5IGJyZWFraW5nIGl0IG91dCBvZiB0cmVlX3B1dF9ub2RlKCkuDQo+
IA0KPiAJSW4gdGhlIGFic2Vuc2Ugb2YgZGVsX3N3X3Jvb3RfbnMgLSB0aGUgYmFja3BvcnQgZmlu
ZHMgYW4NCj4gaWRlbnRpY2FsIG9uZQ0KPiAJbGluZSBrZnJlZSBzdHViIGZjbiAtIG5hbWVkIGRl
bF9zd19wcmlvIGZyb20gdGhpcyBlYXJsaWVyDQo+IGNvbW1pdDoNCj4gDQo+IAkxMzllZDZjNmM0
NmEgLSAibmV0L21seDU6IEZpeCBzdGVlcmluZyBtZW1vcnkgbGVhayIgIFtpbiB2NC4xNS0NCj4g
cmM1XQ0KPiANCj4gCWFuZCB0aGVuIHB1dHMgdGhlIG11dGV4X2Rlc3Ryb3koKSBpbnRvIHRoYXQg
KHdyb25nKSBmdW5jdGlvbiwNCj4gaW5zdGVhZCBvZg0KPiAJcHV0dGluZyBpdCBpbnRvIHRyZWVf
cHV0X25vZGUgd2hlcmUgdGhlIHJvb3QgbnMgY2FzZSB1c2VkIHRvIGJlDQo+IGhhbmQNCj4gDQo+
IFJlcG9ydGVkLWJ5OiBQYXVsIEdvcnRtYWtlciA8cGF1bC5nb3J0bWFrZXJAd2luZHJpdmVyLmNv
bT4NCj4gQ2M6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQo+IENjOiBNYXJrIEJsb2No
IDxtYXJrYkBtZWxsYW5veC5jb20+DQo+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz4NCg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KDQoNCkkgZG9uJ3Qga25vdyBpZiB0aGlzIHdhcyBkdWUgdG8gc29tZXRoaW5n
IHdyb25nIGluIG15IGJhY2twb3J0aW5nDQpwcm9jZXNzIG9yIEFVVE9TRUwvd3JvbmcgRml4ZXMg
dGFnIHJlbGF0ZWQuIEkgd2lsbCBjaGVjayBsYXRlciBhbmQgd2lsbA0KdHJ5IG15IGJlc3QgdG8g
YXZvaWQgdGhpcyBpbiB0aGUgZnV0dXJlLiANCg0KVGhhbmtzLA0KU2FlZWQuDQo=
