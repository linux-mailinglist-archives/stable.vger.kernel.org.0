Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13E8747BA
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfGYHDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:03:08 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17829 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYHDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 03:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564038187; x=1595574187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xgKRr18w+/ReKK7VMgfO9TfGUlpDnAunbBHIvHltBYc=;
  b=L8IvOwr31n/qWSDDDEKoadSXIBU85iTOZ5AXx3wyzpxFANvUkjtOYu36
   Oh6JiXzSOFpMpPDBPjOHeJeCiIfR6tULY6JXrxrj2hcYm65K4amJUlKm9
   Yf2p8OT4eEDj0dWsFcqTCC0kgeqBM+BV/nWIAZ6qGxYWL0s4xCAmbhTCq
   7eRn/68XeItuv2yV108Ut5PNd1UDeV30K81ZgC2pnMgihcuZmjxnwG4Xw
   BqyMr6Zl3NDFMlgo6RMqdbGbkdEvWFOfImHyDw5abZG4Jvm7nVsBrR/Si
   wc3nzYM0yA6tGimop4fLZl7idlHr85ZI9lyXKd3cR+YTOUKuD8j1ZQLdM
   g==;
IronPort-SDR: 3r/o3iizMhzH8cWKu2u/+3s64aoifxYQk5G0L8NvXcfaEQPRBzWdK+ifPp4rNANsT13kSLqLCJ
 QWBGUtRFK829fAs0gki5kaIKRnhopW6/ga/rn3pR6+VDYy6tLp/NvaBBoCvI9t8ojj2Wf/28Y2
 vv8tMyx7tMdKR0NMumWzHaYZTD+LXJDTZ/8yL7ij3kbJkXI7Ld02kqAgZObB5tVwXmnnpPpVJ1
 k+0SLgoUjp3WxNiEsnOmE5pz0YI8kaXtZyhHG5MlX/XkD8ltkinRr/EEani3GdPaDaqg1hpcHo
 WYQ=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="220432988"
Received: from mail-by2nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.50])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 15:03:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdJUMKrzzS6jU+g2H5EAs+LO+nS5WZCfwtOTUq3SsTQNjyqXa7n0wP5vQikV+79WW75PlxQEbJUF4cJPcYrU8YMF/0ySqAf7GGJK55cGuxTC3LWh2JJUMeOX/0sKE8In3ouWHHm5glW53hijWEDyPTyU1N94QBqp2wbrE0AGkxDvd5JApL1J5i78zf5Aicp3SN+RxKZgl0vQkEtw96nfkrlZLvE7xkKMv6+V64NW6KwWBYQtHQRkzdyLenTwDjkXp00BX+WWipfqTUobg9zxbkrjZ8pZY/cwumEyYph8+liYODjDI6EqBAF5M4MElcoKqbqy/NEmjwZthZGfFJCMgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgKRr18w+/ReKK7VMgfO9TfGUlpDnAunbBHIvHltBYc=;
 b=GMnbg60d/2HtAAkgv6S9w7xvrDQSmDtfA7grkr+y9oFbX35RnVm7Ja1AnEfPSW6PA5KNeLPRJh+SyfCWZvYhmln5BkAopUfeascU9vyEMTEtZite8i8+vfrfmL0Uu4WjwDOUic6uiel9su2TVKJFmGUuCL1/gHdWL0kLPS1ngub7eezXqvKDFPAvE8oicoS5/hpjtSlA9ES/Ohl4AkcKKmZqgb10ZlY7dwzvO55VuHnBZ8SZ+rN9VlQ3g89KbPoz1CHyhN7mZX+MLV99hb70guu9/2jJQuI6bcE6FgI/IVn/75AthJ266OUE0YpOlyG59Qosdb1YhYkQbEuA0BG60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgKRr18w+/ReKK7VMgfO9TfGUlpDnAunbBHIvHltBYc=;
 b=CYYWMY5yTbYGLPM3KyIi1mz/jsaWxhYnwTDQ0iJtfCNPo0AbjC5y15LjBQTGP4cNFovwauRPBQ7yUNxulFVPt2uaUQ/Wv6D/540Pf5zY/La5dDsroZ1oU3PiC5JbiSuECNYumMoQiESfibtu9HCjVUzbXQb1nhNViWH45lw7woM=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB4965.namprd04.prod.outlook.com (52.135.232.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 07:03:04 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e%6]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 07:03:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: FAILED: patch "[PATCH] block: Limit zone array allocation size"
 failed to apply to 5.1-stable tree
Thread-Topic: FAILED: patch "[PATCH] block: Limit zone array allocation size"
 failed to apply to 5.1-stable tree
Thread-Index: AQHVQU3FeLJlIR4aIU2+m03jiRGu86ba26kAgAAH3gCAAAfbgA==
Date:   Thu, 25 Jul 2019 07:03:03 +0000
Message-ID: <54fce28aff5f014e3e1318f0db88c2cb9b4b2d97.camel@wdc.com>
References: <1563883019244153@kroah.com>
         <c1ed04aded7fb0e68cd4095cb4c7049c02a11e3f.camel@wdc.com>
         <20190725063454.GD6723@kroah.com>
In-Reply-To: <20190725063454.GD6723@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e7577b6-f8dc-4da9-4981-08d710ce2378
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4965;
x-ms-traffictypediagnostic: BYAPR04MB4965:
x-microsoft-antispam-prvs: <BYAPR04MB49658261B4C47D3F9477BB64E7C10@BYAPR04MB4965.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(199004)(189003)(72854002)(6246003)(53936002)(3846002)(6512007)(66066001)(14454004)(5660300002)(25786009)(2351001)(68736007)(316002)(99286004)(6116002)(2501003)(58126008)(36756003)(7736002)(76176011)(305945005)(76116006)(54906003)(6506007)(6436002)(71200400001)(71190400001)(102836004)(4326008)(118296001)(26005)(8936002)(8676002)(86362001)(256004)(6916009)(5640700003)(478600001)(2906002)(66946007)(229853002)(446003)(11346002)(2616005)(81156014)(81166006)(476003)(4744005)(66446008)(6486002)(1730700003)(64756008)(66556008)(66476007)(91956017)(486006)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4965;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ORqPZJVIlowhZ17j2A7d6aXeBfmXT6M081cJQAKgnNZVBHnwzPi086FYZUyp+XOYb2LnNoIQ9gYg2x2zsdPOilJJCOZL1WHNx695BKHJHJgwRJZnIRqFt4Rf9awkBvNfUCYf/8tjVRbEPmK0PxO0OFf43ekJNuWvKvVSkt4mzsn+jEZDpssIl/ERKPjeHkWt3Yuh4E3t5vqnCFH8sGP8WSmrLs8CNWUAPVFUs/lm1gAiGccEWQ2KhzvqoUTe5q0N2O8Uz6wjnbTBhOUpEUOyP5cNbjRYSriPiZYmfjIm2rSDZH2vA3Xkd6PB5vVl1rxYBYqjU126EDvqDEMGP6kvF9oUuhKO1BbSfvM7TG6Z6fLi4s0AWhxkBWFETrFIHzsQZKlW9zTEeNAEVrY9/VHkiTae2i/i4Jdb9bNkBBe2SyU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE729CB2A58117468F468378A1C17AB0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7577b6-f8dc-4da9-4981-08d710ce2378
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 07:03:03.2502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Damien.LeMoal@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4965
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDA4OjM0ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVGh1LCBKdWwgMjUsIDIwMTkgYXQgMDY6MDY6NDVBTSArMDAwMCwg
RGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE5LTA3LTIzIGF0IDEzOjU2ICsw
MjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZyB3cm90ZToNCj4gPiA+IFRoZSBwYXRjaCBi
ZWxvdyBkb2VzIG5vdCBhcHBseSB0byB0aGUgNS4xLXN0YWJsZSB0cmVlLg0KPiA+ID4gSWYgc29t
ZW9uZSB3YW50cyBpdCBhcHBsaWVkIHRoZXJlLCBvciB0byBhbnkgb3RoZXIgc3RhYmxlIG9yIGxv
bmd0ZXJtDQo+ID4gPiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0aGUgYmFja3BvcnQsIGluY2x1
ZGluZyB0aGUgb3JpZ2luYWwgZ2l0IGNvbW1pdA0KPiA+ID4gaWQgdG8gPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+Lg0KPiA+ID4gDQo+ID4gPiB0aGFua3MsDQo+ID4gPiANCj4gPiA+IGdyZWcgay1o
DQo+ID4gDQo+ID4gR3JlZywNCj4gPiANCj4gPiBJIHNlbnQgeW91IGEgYmFja3BvcnRlZCB2ZXJz
aW9uIHRoYXQgYXBwbGllcyBjbGVhbmx5IHRvIGJvdGggNS4xIGFuZA0KPiA+IDUuMiBzdGFibGUg
dHJlZXMuDQo+IA0KPiBQbGVhc2UgZml4IHVwIHlvdXIgYmFja3BvcnRzIGFuZCBzZW5kIHRoZW0g
aW4gYSBmb3JtYXQgdGhhdCBJIGNhbiB1c2UNCj4gdGhhdCBkb2VzIG5vdCBsaWUgYWJvdXQgdGhl
IGF1dGhvciBvZiB0aGUgcGF0Y2ggOikNCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQoN
Ck9vb3BzLiBTb3JyeSBhYm91dCB0aGF0LiBGaXhpbmcgYW5kIHJlc2VuZGluZy4NCg0KLS0gDQpE
YW1pZW4gTGUgTW9hbA0KV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoDQo=
