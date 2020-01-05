Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B73A1306AF
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 08:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgAEHzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 02:55:31 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:42302 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAEHzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 02:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578210930; x=1609746930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i6YSI8Y28SS0aLT83HJtSYrdFWceOuALB146DZrreTo=;
  b=gN5vmhLzwOxHF9M9eLk/jfENkmvCO2addawdjc9UCLOqulAB3R9l6P+V
   28BIk+OmCe6Ipuhy63/qRCph2GCK1RhYR5Go/DlCCE9U0ta4kcFKNXzWd
   v2t7wy065axN8j12lAxSWsV98kuf8APT0UvP0+VJ2NAt98Ph6j00TmbFn
   yC9PaboiCr8DnALjSMjHrqqQfBfShtBudOjKOMFrAgIO4EysUd9EKyuT8
   ZYG9HXEjfGDLWmjO9Qa0wUpzzti5s4XVP78Ug/gAIP426bqSmOsIr04Ha
   j77BNW1QvJXq6kd9vUfzJ2eVY8wHRB7cAeG/Al+leFB1Oxf2/+qNnBW1z
   A==;
IronPort-SDR: 83eG4I/ouLraYtHRMW1IIMjiqDudAip9WSNP+SkmPIefPUbfRiojokw7rrv8lNlnOjJY5HIaG5
 1kOHX+g0s4scjlqP5pnDm0lxjvERCKT2cIYQk1yREG9N1vR2jb05g4gKp1Rwr3V74shJky06N/
 frCwfuLgcVOPhs6AdqbiJYoTTNHrLG/UClSlOrv/3c7a+Do049vnogfPsG5JbM1LKeU//8L+vp
 NSgn30bSWFWpdm7hBR+4aSLvrQbImx48gdRWMMnJeJk1sQRxUpvjlUbTOju1eOexeC3CT0G83p
 6sE=
X-IronPort-AV: E=Sophos;i="5.69,397,1571673600"; 
   d="scan'208";a="126731207"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2020 15:55:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNQ2NGv95B4T7MECQcXTh4grN2FoHtBJNoFtTBYPtjBUv7CWbNXPpck3VZFIDudE7zCRPwpUyb7Pxs7Guqmedm18WyBpG7UjAT9yodexcPRvwTUKHRk7qdjjC/ew1/9iIZks4CFODxZVrivMFmaocKCjotZ8sZP3owKM2TC1snPil02jb/yfjS6lPJIkc0eSwFIarXjUtmKvtzZNKpjfGua8vFLGsFyMX3IP3G4DPD5lbSALBCUJrP/3sMlt0dLSfCKv3HaUiCvuovvLQhLtVaA3pi27hysjU+SUtqqvEGR84TAB29Bzg9/HkRQ+dmf4GbEYbVUwQgfRGKINk2IIwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6YSI8Y28SS0aLT83HJtSYrdFWceOuALB146DZrreTo=;
 b=HK/lF4ekqUhRceZjJKZBhtADPgkeKF7NxQuGTB1oCdAB2MOrT302LTbzem9C5AfABUdjcQjqabZ1GmNlwfy5tVpqxuTll5horx51rlPqybIiSvXZui1hIkJXsRD1bY9oJmwkiR0+GdxMiBZGRrKO5PYWoMUaJhgmJxwvrgWHmegMs2/SeHwuBdOxnmnIUwdjt4HsZrf05gXEpg5wjfyE+nz1MMU2rJ0mv+lCTHhDXYOsF4qoIaFwbLvWKLyKxGP4+V4qXMrBIiRiFz/k2ahfq7JEeS0nY7r4J6W90A/wzMELzfquI56xWFYTI/Oug5jlEEZG936WzrEOmx2RgaY9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6YSI8Y28SS0aLT83HJtSYrdFWceOuALB146DZrreTo=;
 b=Q1/06elEKuT7coN8bNHjCjn7gZhBF3HgmnXnrYTwODc62Ku2IeekKrbY6cAqM0/xeuzcFQjxr6MMapN1Imcg0CL2bZl+AHZBx2SojJbY3njzaeM/ow88SEGosXXRzJXLpFhimrSh7d+O4nR4nc5udyYLxNB/5aX/jxv0uRtRfm4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6704.namprd04.prod.outlook.com (10.186.144.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Sun, 5 Jan 2020 07:55:26 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2602.015; Sun, 5 Jan 2020
 07:55:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "ron.hsu@mediatek.com" <ron.hsu@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v1 1/2] scsi: ufs: set device as default active power mode
 during initialization only
Thread-Topic: [PATCH v1 1/2] scsi: ufs: set device as default active power
 mode during initialization only
Thread-Index: AQHVvujpVCeUwM6XKUGtJJlwmaVE1qfTUtwAgAAcwoCAABJWgIAAJDGAgAA4ZQCAAA4MAIADBCYAgATJMMA=
Date:   Sun, 5 Jan 2020 07:55:25 +0000
Message-ID: <MN2PR04MB69913BBFD9DF5268894C94A9FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
         <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
         <fd129b859c013852bd80f60a36425757@codeaurora.org>
         <1577754469.13164.5.camel@mtkswgap22>
         <836772092daffd8283a97d633e59fc34@codeaurora.org>
         <1577766179.13164.24.camel@mtkswgap22>
         <1577778290.13164.45.camel@mtkswgap22>
         <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
 <1577947124.13164.75.camel@mtkswgap22>
In-Reply-To: <1577947124.13164.75.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.86.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb1c5c05-a557-4402-2095-08d791b49ff5
x-ms-traffictypediagnostic: MN2PR04MB6704:
x-microsoft-antispam-prvs: <MN2PR04MB670456BDB66A0F9FCF33C86BFC3D0@MN2PR04MB6704.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(189003)(199004)(110136005)(71200400001)(4326008)(4001150100001)(52536014)(478600001)(7416002)(54906003)(966005)(81156014)(8936002)(33656002)(316002)(81166006)(8676002)(26005)(7696005)(66946007)(76116006)(66476007)(64756008)(66446008)(66556008)(55016002)(9686003)(186003)(5660300002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6704;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xhSSjs7rJ+qCTQFOZP8YkbRDRjliGSMr9BCZnhh5FP/AbJUBQ9GKaVkJmu/GEfH/Db22aAnebxgxu2auS7mCVm4m0Y8ZgAoAV/rWSIUJ/rL0NRzECSfpoyM8zvrDS29bxCFY8NaKledMmV/hMJ3KlpmLM9wEKF57PdkucjfawPBRdvbDBv02KDOjxTBpQZfax4shKWUacWU0fXrWu8As8Ki7BCg4dB2cGNI4EbYBySDuoRi5OD6kVMNjswiP3G2vgDAxO41jV/pM+mxCA/VtPA7xjkW6wo+RaAEfyzRz8An4fwWx446LIo8M0gr7qw7QIROxQSjFD5510G0R+SR7K1H2uQFi0vt9qaqVKZ4jYepPEBnsmG+uU06YevEABWBVn/vWupY8N5ODFHMqH6FvBtFZB1wAXae2B1psg48TB0BjXiwiCjgRdwtf3Xz8xXTmKBYp7QV3fQ0aMBFerhacYjE99MMv/5Ji49Ca6flFnOU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1c5c05-a557-4402-2095-08d791b49ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2020 07:55:25.8065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caTdqGKOhUYc6wXg7AKlLHFy2/i+iDjyi4JC6ejkF1iccUsZ4FJ94M4yuHlymfFYg1KcKtoaKPSaTdYuhnJswQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6704
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU3RhbmxleSwNCkkgYW0gYXdhcmUgdGhhdCB0aGlzIGRpc2N1c3Npb24gaXMgYWxyZWFkeSBj
b25jbHVkZWQsDQpKdXN0IHBvaW50aW5nIG91dCBhIHNtYWxsIGlzc3VlIHRoYXQgbWlnaHQgZWFz
ZSB5b3VyIG1pbmQgZnVydGhlci4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBIaSBDYW4sDQo+
IA0KPiBPbiBUdWUsIDIwMTktMTItMzEgYXQgMTY6MzUgKzA4MDAsIENhbiBHdW8gd3JvdGU6DQo+
IA0KPiA+IEhpIFN0YW5sZXksDQo+ID4NCj4gPiBJIG1pc3NlZCB0aGlzIG1haWwgYmVmb3JlIEkg
aGl0IHNlbmQuIEluIGN1cnJlbnQgY29kZSwgYXMgcGVyIG15DQo+ID4gdW5kZXJzdGFuZGluZywg
VUZTIGRldmljZSdzIHBvd2VyIHN0YXRlIHNob3VsZCBiZSBBY3RpdmUgYWZ0ZXINCj4gPiB1ZnNo
Y2RfbGlua19zdGFydHVwKCkgcmV0dXJucy4NCj4gPiBJZiBJIGFtIHdyb25nLCBwbGVhc2UgZmVl
bCBmcmVlIHRvIGNvcnJlY3QgbWUuDQo+ID4NCj4gDQo+IFllcywgdGhpcyBhc3N1bXB0aW9uIG9m
IHVmc2hjZF9wcm9iZV9oYmEoKSBpcyB0cnVlIHNvIEkgd2lsbCBkcm9wIHRoaXMgcGF0Y2guDQo+
IFRoYW5rcyBmb3IgcmVtaW5kLg0KPiANCj4gPiBEdWUgdG8geW91IGFyZSBhbG1vc3QgdHJ5aW5n
IHRvIHJldmVydCBjb21taXQgN2NhZjQ4OWI5OWE0MmEsIEkgYW0NCj4gPiBqdXN0IHdvbmRlcmlu
ZyBpZiB5b3UgZW5jb3VudGVyIGZhaWx1cmUvZXJyb3IgY2F1c2VkIGJ5IGl0Lg0KPiANCj4gWWVz
LCB3ZSBhY3R1YWxseSBoYXZlIHNvbWUgZG91YnRzIGZyb20gdGhlIGNvbW1pdCBtZXNzYWdlIG9m
ICJzY3NpOiB1ZnM6DQo+IGlzc3VlIGxpbmsgc3RhcnR1cCAyIHRpbWVzIGlmIGRldmljZSBpc24n
dCBhY3RpdmUiDQo+IA0KPiBJZiB3ZSBjb25maWd1cmVkIHN5c3RlbSBzdXNwZW5kIGFzIGRldmlj
ZT1Qb3dlckRvd24vTGluaz1MaW5rRG93biBtb2RlLA0KPiBkdXJpbmcgcmVzdW1lLCB0aGUgMXN0
IGxpbmsgc3RhcnR1cCB3aWxsIGJlIHN1Y2Nlc3NmdWwsIGFuZCBhZnRlciB0aGF0IGRldmljZSBj
b3VsZA0KPiBiZSBhY2Nlc3NlZCBub3JtYWxseSBzbyBpdCBzaGFsbCBiZSBhbHJlYWR5IGluIEFj
dGl2ZSBwb3dlciBtb2RlLiBXZSBkaWQgbm90DQo+IGZpbmQgZGV2aWNlcyB3aGljaCBuZWVkIHR3
aWNlIGxpbmt1cCBmb3Igbm9ybWFsIHdvcmsuDQo+IA0KPiBBbmQgYmVjYXVzZSB0aGUgMXN0IGxp
bmt1cCBpcyBPSywgdGhlIGZvcmNlZCAybmQgbGlua3VwIGJ5IGNvbW1pdCAic2NzaToNCj4gdWZz
OiBpc3N1ZSBsaW5rIHN0YXJ0dXAgMiB0aW1lcyBpZiBkZXZpY2UgaXNuJ3QgYWN0aXZlIiBsZWFk
cyB0byBsaW5rIGxvc3QgYW5kIGZpbmFsbHkNCj4gdGhlIDNyZCBsaW5rdXAgaXMgbWFkZSBhZ2Fp
biBieSByZXRyeSBtZWNoYW5pc20gaW4NCj4gdWZzaGNkX2xpbmtfc3RhcnR1cCgpIGFuZCBiZSBz
dWNjZXNzZnVsLiBTbyBhIGxpbmt1cCBwZXJmb3JtYW5jZSBpc3N1ZSBpcw0KPiBpbnRyb2R1Y2Vk
IGhlcmU6IFdlIGFjdHVhbGx5IG5lZWQgb25lLXRpbWUgbGlua3VwIG9ubHkgYnV0IGZpbmFsbHkg
Z290IDMgbGlua3VwDQo+IG9wZXJhdGlvbnMuDQo+IA0KPiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBz
cGVjLCBhbGwgcmVzZXQgdHlwZXMgKGluY2x1ZGluZyBQT1IgYW5kIEhvc3QgVW5pUHJvIFdhcm0N
Cj4gUmVzZXQgd2hpY2ggYm90aCBtYXkgaGFwcGVuIGluIGFib3ZlIGNvbmZpZ3VyYXRpb25zKSBv
dGhlciB0aGFuIExVIHJlc2V0LCBVRlMNCj4gZGV2aWNlIHBvd2VyIG1vZGUgc2hhbGwgcmV0dXJu
IHRvIFNsZWVwIG1vZGUgb3IgQWN0aXZlIG1vZGUgZGVwZW5kaW5nIG9uDQo+IGJJbml0UG93ZXJN
b2RlLCBieSBkZWZhdWx0LCBpdCdzIEFjdGl2ZSBtb2RlLg0KQXMgZm9yIGJJbml0UG93ZXJNb2Rl
IC0gcGxlYXNlIHNlZSB0aGUgZGlzY3Vzc2lvbiBpbiBodHRwczovL3d3dy5tYWlsLWFyY2hpdmUu
Y29tL2xpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnL21zZzc4MjYyLmh0bWwNCg0KDQoNCj4gDQo+
IFNvIHdlIGFyZSBjdXJpb3VzIHRoYXQgd2h5IGVuZm9yY2luZyB0d2ljZSBsaW5rdXAgaXMgbmVj
ZXNzYXJ5IGhlcmU/DQo+IENvdWxkIHlvdSBraW5kbHkgaGVscCB1cyBjbGFyaWZ5IHRoaXM/DQo=
