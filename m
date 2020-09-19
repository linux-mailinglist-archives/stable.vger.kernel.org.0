Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90116270A6B
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 05:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgISDim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 23:38:42 -0400
Received: from mail1.bemta24.messagelabs.com ([67.219.250.5]:47232 "EHLO
        mail1.bemta24.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbgISDil (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 23:38:41 -0400
Received: from [100.112.129.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.us-west-2.aws.symcld.net id 2E/A8-53750-E3D756F5; Sat, 19 Sep 2020 03:38:38 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRWlGSWpSXmKPExsWSLveKVdeuNjX
  e4Nl9Tov1p44xW0yfeoHRYu+72awWs6c3M1lc3jWHzaJ54m12i7aNXxktFmx8xOjA4bF4z0sm
  j+7Z/1g83u+7yuZxZsERdo/Pm+QCWKNYM/OS8isSWDNuvvvNVHBboaLh63fWBsYlCl2MXBxCA
  g1MEn8PLGKGcF4xSnza8JwRLvN/6gQghxPI+c0ocXa6CEiCUWAps8SThx9YIJxjLBJNd6awQj
  gbGCW6f30Ga2ER2M0s0fbHGmLWPCaJi39amSCcx4wS72buAFrJwcEmoCVxdlMiSIOIQKTEjlV
  LwJYzC/QzSfQ9WwI2SVjAWeLQkQYWiCIXifYrm9khbCOJrY/msEFsU5XY9eU0WA2vQILEg+Pr
  2CEOj5F4sukvM4jNKRArcezNIrCZjAJiEt9PrWECsZkFxCVuPZkPZksICEgs2XOeGcIWlXj5+
  B/Ua12MEi9On2OFSChIPDv+nR3ClpW4NL+bEcL2lXh9exvUIC2JZbtvQMWzJSbeaWKBsNUkmg
  /sgbLlJFb1PmSZwGg0C8kds4DhwiygKbF+lz5EWFFiSvdD9llgrwlKnJz5hGUBI8sqRoukosz
  0jJLcxMwcXUMDA11DQyNdQ2MDXSNDS73EKt1EvdJi3fLU4hJdI73E8mK94src5JwUvbzUkk2M
  wISWUtB0ewfjv9cf9A4xSnIwKYnyPqlMjRfiS8pPqcxILM6ILyrNSS0+xCjDwaEkwTunGignW
  JSanlqRlpkDTK4waQkOHiURXrUaoDRvcUFibnFmOkTqFKMxx4SXcxcxcxyZu3QRsxBLXn5eqp
  Q4ryhIqQBIaUZpHtwgWNK/xCgrJczLyMDAIMRTkFqUm1mCKv+KUZyDUUmY9wfIPTyZeSVw+4B
  JF+gLEd7vf1NATilJREhJNTDN+GEleeX4jSdhapvd2Vn3OL4udAkwmBYSFsu8bI695sQsb9GA
  ZXabt8sUX+xMn3lhUr2xCLc6t6hz+Gv27Hq/27K6fd/c1j5WONKU09J5Pjd51sd8gVCNtopjr
  Bf+zNzyqyb8QoGNzBaTJQ09VXPXMc7+e22W3xsVvZv2e98znVipIvqp41Ui08JJFRJKR4VPT/
  8ZlLbvHkvsa68D676kbbCIMZU/t/Hn4aOr7k4U1f+0YhrvS+mnl/64J5ktT59gsqrtVWEXzyH
  PbWq577g155bX+0z361ONTfGs5TrLIL9ySuumrxpOYfrn1qdpBXh869YU3Nj83FU8MV9UTYF1
  knALn/6DZ9pe4UkeF5RYijMSDbWYi4oTAfyDYgl1BAAA
X-Env-Sender: ahuang12@lenovo.com
X-Msg-Ref: server-18.tower-335.messagelabs.com!1600486716!31260!1
X-Originating-IP: [103.30.234.5]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 7200 invoked from network); 19 Sep 2020 03:38:37 -0000
Received: from unknown (HELO lenovo.com) (103.30.234.5)
  by server-18.tower-335.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 19 Sep 2020 03:38:37 -0000
Received: from HKGWPEMAIL02.lenovo.com (unknown [10.128.3.70])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by Forcepoint Email with ESMTPS id 9A0265CB35CCC630C22E;
        Sat, 19 Sep 2020 11:38:35 +0800 (CST)
Received: from HKGWPEMAIL01.lenovo.com (10.128.3.69) by
 HKGWPEMAIL02.lenovo.com (10.128.3.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2044.4; Sat, 19 Sep 2020 11:38:35 +0800
Received: from HKEXEDGE02.lenovo.com (10.128.62.72) by HKGWPEMAIL01.lenovo.com
 (10.128.3.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2044.4 via Frontend
 Transport; Sat, 19 Sep 2020 11:38:35 +0800
Received: from APC01-HK2-obe.outbound.protection.outlook.com (104.47.124.56)
 by mail.lenovo.com (10.128.62.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2044.4; Sat, 19 Sep
 2020 11:38:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faZNoX6VwoyTSW0xc13pBYpQXYc8MCVtTVHIjwFrhMHQBdPu7ShckYYZ33PwSf5YLArJJP99nNMGhDIUr0jUd5SCTFx+K9N4BuuqOb/UjFy40wZPNUz+VI2rkZMxqMnVcScJeHda59Jkkm+wNFsVFz7a5vAJvG4lXzetyA2VK5L+zVs6D4eQXYv6+JNdhlqnqeA9swKeby1EcvZwa+y3ZCD8B37OegLN2+x8cssCYG+OBkiUwGPyVYEnCE7QrC0dP+KzRaMslZgZCRaUmSy3P1J7OHp5i6xt26e82WEOXBxLx9VdDi2BjDWmL/2qzXchaV+S5AYgJBIXQcwqFdLTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53svdA6xhZcZ3lHsZnTjpABAw/2AjUFnVhN80/epqO8=;
 b=k4gkQAUT4W9kc1KvV+PCZh87iE7xqEfI19tINT8ewyhF6QvEqhKLi/yRsw/mZkPTbd+wwZkL6XQ1RXXRqnp2KUNApqNo6FOym+0xVCPzgpXyo8cZLKGXukDlBJi10AFDUssRtQeSbrj8jKcl9msF0X29PAS+8vJgmaFy1ECRcCyb68hNpgXdMSOONn5vI4l33SSW+lOgF2cP7e0qhX/A7ddt7F2k/9DNJl4tusFAu6p8e19WEWGsBO3Fp1gi5TN8+eKTJ5ho2H+8IlZHpejN6PsLG240ib5aBxtROak6dMDJIHSQ3FYn8wQHoHTs3X+QiSZHqLvlTkFJsoyLx//7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lenovo.com; dmarc=pass action=none header.from=lenovo.com;
 dkim=pass header.d=lenovo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=LenovoBeijing.onmicrosoft.com; s=selector2-LenovoBeijing-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53svdA6xhZcZ3lHsZnTjpABAw/2AjUFnVhN80/epqO8=;
 b=cdVyN6FKDdbBwWg0IgmRHKS535Htu0xQXBtHPJYqAxN7ZaTM8Wzg3HjZaxZxDWR6xw9StE8yridoCV19MzFMy6gTAQQeWEnD7OpXKIk5OCbUXu+KQJUu7It5YtDxSk9Zxtl0beqhD6kXy4NekuQwC8ii8jh/b8UlN4KhIDW4rSc=
Received: from HK2PR0302MB2594.apcprd03.prod.outlook.com (2603:1096:202:c::8)
 by HK2PR03MB4449.apcprd03.prod.outlook.com (2603:1096:202:1f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5; Sat, 19 Sep
 2020 03:38:21 +0000
Received: from HK2PR0302MB2594.apcprd03.prod.outlook.com
 ([fe80::dc8d:b50c:1dfa:b164]) by HK2PR0302MB2594.apcprd03.prod.outlook.com
 ([fe80::dc8d:b50c:1dfa:b164%7]) with mapi id 15.20.3391.009; Sat, 19 Sep 2020
 03:38:21 +0000
From:   Adrian Huang12 <ahuang12@lenovo.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [External]  [PATCH] dm/dax: Fix table reference counts
Thread-Topic: [External]  [PATCH] dm/dax: Fix table reference counts
Thread-Index: AQHWjfe11ZIxZN3pikmRBt5326cygqlvT5EA
Date:   Sat, 19 Sep 2020 03:38:20 +0000
Message-ID: <HK2PR0302MB25949288D7E87B5C9CDD60A9B33C0@HK2PR0302MB2594.apcprd03.prod.outlook.com>
References: <160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [1.174.62.240]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91b8524d-5de6-4af7-dcbc-08d85c4d7495
x-ms-traffictypediagnostic: HK2PR03MB4449:
x-microsoft-antispam-prvs: <HK2PR03MB44497664BD87A395E14A4EB4B33C0@HK2PR03MB4449.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JCrWxhTizKKDAOk7ivv9s+zgB51QtgqegDxa6FeczzGfiijcf7oRX4fzAeQIQR8GLKXdUzuP59p96EjbXivL2o8uSAqXbFZ5RX1TBpC5qtYHGSDjs7gYP4sjFVD89mo4AtVUkBHUsIFTAeLF5WZn0qPsbbBM38hYe30iMZ6LgnxuAjkrbCtsQjjh273nk9y8bM+Q1YCLT0Od/YEPSVOzwSVwnhyDBdszhggJbh74zFsUfTeuip+HZZCQ+CdBbLHiMExfCWu4RokqkPEwu/zJ1HC7OnqsA4EkSkL/DPr6TwnWcqZog8eCRBL94UGbtOhgLJTLwC333Xn3eLU13J9ys4Gv37oc/omQwHsoqDldqgMNBcWXswMVxqpHGDY9u8aO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR0302MB2594.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(6506007)(110136005)(316002)(26005)(186003)(8936002)(4326008)(66476007)(83380400001)(2906002)(66556008)(7696005)(8676002)(478600001)(64756008)(66446008)(9686003)(66946007)(54906003)(53546011)(71200400001)(86362001)(52536014)(5660300002)(33656002)(76116006)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Tgzkw+00OkDqehMuVqoAR2p/kYsz0kAAWocWJOZOzshVOpiRJlT6MoGdOogpeZDUDaozbQSmg7XWC7Xdf3TizhsP+gkiKtPWcyvl1A0jhHMBWE+n5UwWdKNbJwHKLZIa9SI7Wszpros84bS9YIS+dhms8GcHoz5Or3YWPDRANDaQ8yWStcgC94m43QAUeYxwLU9z7zqnMrUZPPqG0n3WTXvWXiqI6Jdzz5dcYZelPwHVqjyog2PiJvwuDQ2sEgGmsA2SykLic+aSEFucFR+UQdF3dTmvhKmHd5Y4llklaKXWggPeZCBzvEm838RswtmsvMqmeWDNngYK1om4U0882HXexYibHPFk2Co8y0BQMUUFtVOc2Tf3kEPA3EBDLZ2g4FTgt4ExeCIdXZoQ2S7EejosXmMcbA0AcMgHA7uNFTsSFWUC8pFEdUFwByXy2zWEb1UQr8w0vP7/Awg2oFUQpiKdD+RcpDeAk9Rg1KhrDZFHn+pQVk8eXGSIDHkL+A5T004d7Hze86Q4eZwIWjDQzSdECqKxC1NicZ+JV1gDaCBgtfcIv0krG06vStg8KzBNHoZB3p4b1111ljUxH6whufNL/tfih3yykk07LShK+XMV/dx8E2GiSE4vnMd9210tkXTtDQ26SdnQGFJtvQbbAw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR0302MB2594.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b8524d-5de6-4af7-dcbc-08d85c4d7495
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 03:38:21.0111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nHoXS4G7bZb1BvioEKy2KuSvK89UpjEbjHdjy1oxJpJ6pjspAyHFtMfEEnbjaJRyfBqy9p/UO9XfrbDzZZTKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR03MB4449
X-OriginatorOrg: lenovo.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDogU2F0dXJkYXksIFNlcHRlbWJlciAxOSwgMjAy
MCAzOjUxIEFNDQo+IFRvOiBkbS1kZXZlbEByZWRoYXQuY29tDQo+IENjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnOyBKYW4gS2FyYSA8amFja0BzdXNlLmN6PjsgQWxhc2RhaXIgS2VyZ29uDQo+IDxh
Z2tAcmVkaGF0LmNvbT47IE1pa2UgU25pdHplciA8c25pdHplckByZWRoYXQuY29tPjsgQWRyaWFu
IEh1YW5nMTINCj4gPGFodWFuZzEyQGxlbm92by5jb20+OyBsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRXh0ZXJu
YWxdIFtQQVRDSF0gZG0vZGF4OiBGaXggdGFibGUgcmVmZXJlbmNlIGNvdW50cw0KPiANCj4gQSBy
ZWNlbnQgZml4IHRvIHRoZSBkbV9kYXhfc3VwcG9ydGVkKCkgZmxvdyB1bmNvdmVyZWQgYSBsYXRl
bnQgYnVnLiBXaGVuDQo+IGRtX2dldF9saXZlX3RhYmxlKCkgZmFpbHMgaXQgaXMgc3RpbGwgcmVx
dWlyZWQgdG8gZHJvcCB0aGUgc3JjdV9yZWFkX2xvY2soKS4gV2l0aG91dA0KPiB0aGlzIGNoYW5n
ZSB0aGUgbHZtMiB0ZXN0LXN1aXRlIHRyaWdnZXJzIHRoaXMNCj4gd2FybmluZzoNCj4gDQo+ICAg
ICAjIGx2bTItdGVzdHN1aXRlIC0tb25seSBwdm1vdmUtYWJvcnQtYWxsLnNoDQo+IA0KPiAgICAg
V0FSTklORzogbG9jayBoZWxkIHdoZW4gcmV0dXJuaW5nIHRvIHVzZXIgc3BhY2UhDQo+ICAgICA1
LjkuMC1yYzUrICMyNTEgVGFpbnRlZDogRyAgICAgICAgICAgT0UNCj4gICAgIC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgICAgbHZtLzEzMTggaXMg
bGVhdmluZyB0aGUga2VybmVsIHdpdGggbG9ja3Mgc3RpbGwgaGVsZCENCj4gICAgIDEgbG9jayBo
ZWxkIGJ5IGx2bS8xMzE4Og0KPiAgICAgICMwOiBmZmZmOTM3MmFiYjVhMzQwICgmbWQtPmlvX2Jh
cnJpZXIpey4uLi59LXswOjB9LCBhdDoNCj4gZG1fZ2V0X2xpdmVfdGFibGUrMHg1LzB4YjAgW2Rt
X21vZF0NCj4gDQo+IC4uLmFuZCBsYXRlciBvbiB0aGlzIGhhbmcgc2lnbmF0dXJlOg0KPiANCj4g
ICAgIElORk86IHRhc2sgbHZtOjEzNDQgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDEyMiBzZWNvbmRz
Lg0KPiAgICAgICAgICAgVGFpbnRlZDogRyAgICAgICAgICAgT0UgICAgIDUuOS4wLXJjNSsgIzI1
MQ0KPiAgICAgImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2Vj
cyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLg0KPiAgICAgdGFzazpsdm0gICAgICAgICAgICAgc3Rh
dGU6RCBzdGFjazogICAgMCBwaWQ6IDEzNDQgcHBpZDogICAgIDEgZmxhZ3M6MHgwMDAwNDAwMA0K
PiAgICAgQ2FsbCBUcmFjZToNCj4gICAgICBfX3NjaGVkdWxlKzB4NDVmLzB4YTgwDQo+ICAgICAg
PyBmaW5pc2hfdGFza19zd2l0Y2grMHgyNDkvMHgyYzANCj4gICAgICA/IHdhaXRfZm9yX2NvbXBs
ZXRpb24rMHg4Ni8weDExMA0KPiAgICAgIHNjaGVkdWxlKzB4NWYvMHhkMA0KPiAgICAgIHNjaGVk
dWxlX3RpbWVvdXQrMHgyMTIvMHgyYTANCj4gICAgICA/IF9fc2NoZWR1bGUrMHg0NjcvMHhhODAN
Cj4gICAgICA/IHdhaXRfZm9yX2NvbXBsZXRpb24rMHg4Ni8weDExMA0KPiAgICAgIHdhaXRfZm9y
X2NvbXBsZXRpb24rMHhiMC8weDExMA0KPiAgICAgIF9fc3luY2hyb25pemVfc3JjdSsweGQxLzB4
MTYwDQo+ICAgICAgPyBfX2JwZl90cmFjZV9yY3VfdXRpbGl6YXRpb24rMHgxMC8weDEwDQo+ICAg
ICAgX19kbV9zdXNwZW5kKzB4NmQvMHgyMTAgW2RtX21vZF0NCj4gICAgICBkbV9zdXNwZW5kKzB4
ZjYvMHgxNDAgW2RtX21vZF0NCj4gDQo+IEZpeGVzOiA3YmY3ZWFjOGQ2NDggKCJkYXg6IEFycmFu
Z2UgZm9yIGRheF9zdXBwb3J0ZWQgY2hlY2sgdG8gc3BhbiBtdWx0aXBsZQ0KPiBkZXZpY2VzIikN
Cj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogSmFuIEthcmEgPGphY2tAc3Vz
ZS5jej4NCj4gQ2M6IEFsYXNkYWlyIEtlcmdvbiA8YWdrQHJlZGhhdC5jb20+DQo+IENjOiBNaWtl
IFNuaXR6ZXIgPHNuaXR6ZXJAcmVkaGF0LmNvbT4NCj4gUmVwb3J0ZWQtYnk6IEFkcmlhbiBIdWFu
ZyA8YWh1YW5nMTJAbGVub3ZvLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoNCkNvb2wsIHRoYW5rcyBmb3IgdGhlIGZpeC4gVGhp
cyBzb2x2ZXMgdGhlIGlzc3VlLg0KDQpUZXN0ZWQtYnk6IEFkcmlhbiBIdWFuZyA8YWh1YW5nMTJA
bGVub3ZvLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbWQvZG0uYyB8ICAgIDUgKysrLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jIGluZGV4DQo+IGZi
MDI1NWQyNWU0Yi4uNGE0MGRmOGFmN2QzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21kL2RtLmMN
Cj4gKysrIGIvZHJpdmVycy9tZC9kbS5jDQo+IEBAIC0xMTM2LDE1ICsxMTM2LDE2IEBAIHN0YXRp
YyBib29sIGRtX2RheF9zdXBwb3J0ZWQoc3RydWN0IGRheF9kZXZpY2UNCj4gKmRheF9kZXYsIHN0
cnVjdCBibG9ja19kZXZpY2UgKmJkICB7DQo+ICAJc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kID0g
ZGF4X2dldF9wcml2YXRlKGRheF9kZXYpOw0KPiAgCXN0cnVjdCBkbV90YWJsZSAqbWFwOw0KPiAr
CWJvb2wgcmV0ID0gZmFsc2U7DQo+ICAJaW50IHNyY3VfaWR4Ow0KPiAtCWJvb2wgcmV0Ow0KPiAN
Cj4gIAltYXAgPSBkbV9nZXRfbGl2ZV90YWJsZShtZCwgJnNyY3VfaWR4KTsNCj4gIAlpZiAoIW1h
cCkNCj4gLQkJcmV0dXJuIGZhbHNlOw0KPiArCQlnb3RvIG91dDsNCj4gDQo+ICAJcmV0ID0gZG1f
dGFibGVfc3VwcG9ydHNfZGF4KG1hcCwgZGV2aWNlX3N1cHBvcnRzX2RheCwgJmJsb2Nrc2l6ZSk7
DQo+IA0KPiArb3V0Og0KPiAgCWRtX3B1dF9saXZlX3RhYmxlKG1kLCBzcmN1X2lkeCk7DQo+IA0K
PiAgCXJldHVybiByZXQ7DQoNCg==
