Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54FD0BAB
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJIJps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:45:48 -0400
Received: from mail-eopbgr1400104.outbound.protection.outlook.com ([40.107.140.104]:8423
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730506AbfJIJps (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 05:45:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOiqnhpgX7jkNJzhQxDjjAI+ozFlS/mQ0sJkXzNwfSnxHlOo5LGz8mdm5RctWlBIkor18G3wUBTy1FKvMeDlw1xhfBGez9uG38vCD2u/nGB6PdIeMRWPy7gyfmmIdmuwBqoAZFVBzvR23vS8WlIhj85gGsv4HHILe0y4MR/GQy9dClJo6l33i2HUYJQMcRoIa815NKkDn7P0ZcOj5e4Z0gdVHyI5sXP+yOqZ7TI51FREWMM8sk1t0bwzlKilTauQTpE74H7oBeMkYQ8J1KwKK75e6vjna6wwxNTgVGNSqBUOKcc2xvFDgAeJ4xRSINzUjH3QyUjJ9cEf4QBKmA1Eig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHlwQazc7Js6I6I6yk6iHVyRk3SYAfWcTf9pqKePGj4=;
 b=gA+YrmvYHLX4xbvl2v9gtELjnGw7siik8YK9B2eG43LyGo7s/xeuUccpsF12DVR8ayilKBGDi+lhF/uOC0u5nk6zI2ql54MCyQygWpG7mLJ4JIAUd6kEMmg4D2fpzgmrK9SQGMBgUxP+yODi+Vagk9OfwArk0uZL9h6V6hNSJTQjWkuCoeLJspuuAKZI5A0GmaEvnyWqlH0vskp3ugcgL5umCxH2soD6PKFlSPt0YA1vAalDTWoQ8FoJH8PzOdRBE5TqqoIn6QLaeW009D1jy5ZH2sVdXlUcWaQ+h4G44qXppA4EFNpI0TjpuHkI5YMcX6qc/BptaNNfz5Cr7rPvXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHlwQazc7Js6I6I6yk6iHVyRk3SYAfWcTf9pqKePGj4=;
 b=bLp8THEZUOzhD2RYUc3Xg4kPsCNHeOqlT3xUi/qU1Jg+QqkjMwxJXUJ8D78Ms8Tfj8uJoNHomEJfUeofzghXOiIzd2czmIw067PwAqyaSrgKrzrArxhaVFf4VtqW9iBZ48sx1C8qrvbEjpL8D8ae1eXHWlaGM3G1tsbUI53Mvxk=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3039.jpnprd01.prod.outlook.com (20.177.102.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Wed, 9 Oct 2019 09:45:43 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 09:45:43 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Topic: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Thread-Index: AQHVflZ5pjTfDr6TFku09vCbhMul/KdSABuAgAAA8CCAAAGoAIAADRtQ
Date:   Wed, 9 Oct 2019 09:45:43 +0000
Message-ID: <TYAPR01MB45449D8B22413E22E330A47CD8950@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <2b0f09cd-323d-864d-09df-40d431693f19@cogentembedded.com>
 <TYAPR01MB4544EABC75926292D3D80C0AD8950@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <822462e9-4764-6a96-b448-9b8f9f94bd3b@cogentembedded.com>
In-Reply-To: <822462e9-4764-6a96-b448-9b8f9f94bd3b@cogentembedded.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9876db70-3446-4c8f-9a3f-08d74c9d7422
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TYAPR01MB3039:
x-microsoft-antispam-prvs: <TYAPR01MB30395EFDFFD10DBD0D0E79CBD8950@TYAPR01MB3039.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39830400003)(346002)(366004)(396003)(376002)(199004)(189003)(2201001)(8676002)(6116002)(3846002)(4326008)(81166006)(81156014)(66066001)(476003)(508600001)(53546011)(33656002)(6506007)(8936002)(486006)(14454004)(66946007)(76116006)(66446008)(52536014)(2501003)(66476007)(66556008)(64756008)(76176011)(110136005)(74316002)(5660300002)(54906003)(4744005)(71200400001)(9686003)(99286004)(11346002)(71190400001)(256004)(7736002)(55016002)(26005)(305945005)(6246003)(102836004)(7696005)(25786009)(186003)(2906002)(86362001)(229853002)(6436002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3039;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T4uBX102AwHVYZCOHOhi1A0sAcqaaBnw0FlrjjHIjJJ1NLtNT7wraNgiahouMd5uDBEOSliqckXXv5WQ5VZ4VMmC7LF8U3eZcY9pllDpp7bXmMz+vb+B+wqs4a+etIq3SzddhoFc4a/vRXc+eYe5XT7ne0TEiSC6J9zPKFDRjamZwYsxnvyejud6HgABSdw8eJO+kypDDliBSlnYwQcOSz11DjrlNnP6fuRKTInz1KPvtW9z85Crt1YHVkHXpxrQ4N3AJV7Gk6JOwwtRuC/Q3nQpYnTmvNwq8BUduSuO1Ew0Yn2LsOC+n4gnsxbvA/RNi4LKlxeS+SflS9ZBjnXi5AKMmVhqiG2C7/trVWAyEszuGeDRQdDec6ZQGU70cGkMbjesvXJNDXRQc87mrl4upTXCFNNaH2Ms668xCkneuOM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9876db70-3446-4c8f-9a3f-08d74c9d7422
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 09:45:43.6776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t6iwIIjHvWcNmombyGtEPFpO07koC+FxgtePXjMmqSns4ADY+L6fOmlJKjq45Lk1LF2mn/Lw05mhO9ngdMzuINMWI+TYRtS+ljUmF6QKFj7uxCL1YJUrAOgqctXx3Gd+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3039
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU2VyZ2VpLXNhbiwNCg0KPiBGcm9tOiBTZXJnZWkgU2h0eWx5b3YsIFNlbnQ6IFdlZG5lc2Rh
eSwgT2N0b2JlciA5LCAyMDE5IDU6NTggUE0NCj4gDQo+IE9uIDA5LjEwLjIwMTkgMTE6NTQsIFlv
c2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPiANCj4gPj4+IEFjY29yZGluZyB0byB0aGUgUi1DYXIg
R2VuMi8zIG1hbnVhbCwgdGhlIGJpdCAwIG9mIE1BQ0NUTFIgcmVnaXN0ZXINCj4gPj4+IHNob3Vs
ZCBiZSB3cml0dGVuIHRvIDAgYmVjYXVzZSB0aGUgcmVnaXN0ZXIgaXMgc2V0IHRvIDEgb24gcmVz
ZXQuDQo+ID4+DQo+ID4+ICAgICAgVGhlIGJpdCAwIHNldCB0byAxLCBub3QgdGhlIHdob2xlIHJl
Z2lzdGVyIChpdCBoYXMgMXMgYWxzbyBpbiB0aGUNCj4gPj4gYml0cyAxNi0yMykuDQo+ID4NCj4g
PiBUaGFuayB5b3UgZm9yIHRoZSBjb21tZW50LiBTbywgSSdsbCBmaXggdGhlIGNvbW1pdCBsb2cg
YXMgZm9sbG93aW5nLg0KPiA+IElzIGl0IGFjY2VwdGFibGU/DQo+ID4NCj4gPiAtLS0NCj4gPiBB
Y2NvcmRpbmcgdG8gdGhlIFItQ2FyIEdlbjIvMyBtYW51YWwsIHRoZSBiaXQgMCBvZiBNQUNDVExS
IHJlZ2lzdGVyDQo+ID4gc2hvdWxkIGJlIHdyaXR0ZW4gdG8gMCBiZWNhdXNlIHRoZSBiaXQgMCBp
cyBzZXQgdG8gMSBvbiByZXNldC4NCj4gPiBUbyBhdm9pZCB1bmV4cGVjdGVkIGJlaGF2aW9ycyBm
cm9tIHRoaXMgaW5jb3JyZWN0IHNldHRpbmcsIHRoaXMNCj4gPiBwYXRjaCBmaXhlcyBpdC4NCj4g
DQo+ICAgICBBbHJpZ2h0IG5vdy4NCg0KVGhhbmtzIQ0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhp
cm8gU2hpbW9kYQ0KDQo=
