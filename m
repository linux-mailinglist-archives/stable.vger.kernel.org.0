Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2850F750F5
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfGYOZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 10:25:05 -0400
Received: from mail-eopbgr140111.outbound.protection.outlook.com ([40.107.14.111]:43399
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfGYOZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 10:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRhuvVV/uWjzfTox5HuVkl/1BCnq1WVwHB6PpQd0CpEDdyms4AD/BbgP8gBTs439CYRn62+RssafQmlmXPAsE3XjOWlTwH7k3U/SRJwva5VjyH6O3V+rxl9agISt9eCMkgF+CGNX8bxEAAULAFobp6NCkDmdw+nLd76Nlkv4Xt+XmJe9soRjkJnqfSbehPTeUxwKJKhBaj2XSorh7W1qrPR3POkH5G82N3YKo8I7vX3G/j3UOvihalGWsQJ8UDln1eDWkEoOvrKBDYnk/bC7iwNFSdkTkGcv0AP7Hi+ape+gv9D3TSjd9gzuNj+JIG0IG7CzQvrnPMOOtJcvFxoK3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWnThwFADHrsvV/Ftm5gA4+CXuDpFFL6i/jkV/9vRkU=;
 b=DcKBxdE/ghSrPk0cEEulwHkXM4r8VOaytU5gZDZQDxgYPRyrrXqUZWc/3y/SkxDFJbGdiVXx9/io2wZQ/J5oiWbYUMFTtjLm1y/hfbrv4iOzqWmhYAj/IbyWI8IiPPSZa6KfmO2PnVURg6S9gRLgwA9pwc6QruZe26av0BJtbRluChvf1HAV4kTmkY8dQnE1AXXWrwl8YuZ/WWnEaONN78pTaprTubPzA1KjSJkke+namr+BQqVKpVycvMPpQNHgwGIJ8yxDSo8yMDQmCs4Pb4Gs5MrR1eVEm8BWymUrQRIgmJ22a1YCrr09uI8XcrKt1UbMcFDPC0JbdIaTDcFXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nokia.com;dmarc=pass action=none
 header.from=nokia.com;dkim=pass header.d=nokia.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWnThwFADHrsvV/Ftm5gA4+CXuDpFFL6i/jkV/9vRkU=;
 b=r3xV0XQ+vJAn85AjSooCCkxYMgcvdXCtEimAUP85CSCOCIGSTpYjAQy4SIXTLfpAq3yHb4D6Jia34fD3ljmed3d3jidwgNqmp/+qYdz2uPsBv7oD0ydJGkvoy1FBDzURkgyLb75Ym+oLY1K+w2oSA1rA/Aj3ht5OvZrDNiPxDlk=
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com (20.178.88.217) by
 AM6PR07MB5640.eurprd07.prod.outlook.com (20.178.91.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.11; Thu, 25 Jul 2019 14:25:00 +0000
Received: from AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::406f:957:9c7a:123d]) by AM6PR07MB5464.eurprd07.prod.outlook.com
 ([fe80::406f:957:9c7a:123d%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 14:25:00 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
CC:     "qat-linux@intel.com" <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Topic: [PATCH] crypto: qat - Silence smp_processor_id() warning
Thread-Index: AQHVQSeZEH10CvozN0KsW1z2XZZxpqbbVuWAgAAQQYA=
Date:   Thu, 25 Jul 2019 14:25:00 +0000
Message-ID: <205755dd-57f4-9c20-744f-849c8a67e881@nokia.com>
References: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
 <20190725132645.GA16573@sivswdev08.ir.intel.com>
In-Reply-To: <20190725132645.GA16573@sivswdev08.ir.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.166]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
x-clientproxiedby: HE1P189CA0035.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::48)
 To AM6PR07MB5464.eurprd07.prod.outlook.com (2603:10a6:20b:84::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1c828e9-b9ce-4f48-f100-08d7110be036
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR07MB5640;
x-ms-traffictypediagnostic: AM6PR07MB5640:
x-microsoft-antispam-prvs: <AM6PR07MB564028AD1AD2850402CF360D88C10@AM6PR07MB5640.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(189003)(199004)(6486002)(53546011)(8676002)(6506007)(25786009)(11346002)(8936002)(2616005)(386003)(446003)(14454004)(31686004)(71190400001)(66556008)(6116002)(186003)(54906003)(3846002)(478600001)(305945005)(58126008)(52116002)(66476007)(66446008)(81166006)(81156014)(64126003)(486006)(6436002)(71200400001)(316002)(7736002)(64756008)(66946007)(26005)(31696002)(65806001)(65956001)(36756003)(66066001)(4744005)(6916009)(5660300002)(2906002)(65826007)(4326008)(229853002)(86362001)(256004)(14444005)(76176011)(53936002)(99286004)(102836004)(6512007)(68736007)(6246003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR07MB5640;H:AM6PR07MB5464.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Pqq1vspbKuaXxRKAY80P3oPNKAHCdEq6NwExJsQmA/qTYfH1L5GcqL82e/Lw9O8yz2E8YMjJTMAm2eblbkziDD7musZ1kZrEE4zsNOW519vfA1FZCzxaG4Ouhdqgz/0ngdn4wTUbC+wB64hijvhaOCESArWZ5Ve9TzVJqVdlatX42nYBkDw9nOHwUUyHaFb8FV7cP+tHgiiFD4sb7dF5gp4CHyyigYjDKS5DYBiaxFFHrhaJ5/is0P6niM+UP1yN4QBmVQghPoTmMp+AArEjsegjo5D32cc04enryZacwCtyJO+rs3jeNMl6Ahm5Apg8Fd7SWfOlUvtbECHxYpaV5Pa/qCR8Ihcvi1IIuzkAdBF8xI+zERPN47YaH6SZw6/W70kVV4bcO17zqxHIJGChlFLLJxlODptCQy7lhZhJnH0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EEF549802F4B54598059CCA82C7F258@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c828e9-b9ce-4f48-f100-08d7110be036
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 14:25:00.1633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alexander.sverdlin@nokia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5640
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkhDQoNCk9uIDI1LzA3LzIwMTkgMTU6MjYsIEdpb3Zhbm5pIENhYmlkZHUgd3JvdGU6DQo+PiBJ
dCBzZWVtcyB0aGF0IHNtcF9wcm9jZXNzb3JfaWQoKSBpcyBvbmx5IHVzZWQgZm9yIGEgYmVzdC1l
ZmZvcnQNCj4+IGxvYWQtYmFsYW5jaW5nLCByZWZlciB0byBxYXRfY3J5cHRvX2dldF9pbnN0YW5j
ZV9ub2RlKCkuIEl0J3Mgbm90IGZlYXNpYmxlDQo+PiB0byBkaXNhYmxlIHByZWVtcHRpb24gZm9y
IHRoZSBkdXJhdGlvbiBvZiB0aGUgY3J5cHRvIHJlcXVlc3RzLiBUaGVyZWZvcmUsDQo+PiBqdXN0
IHNpbGVuY2UgdGhlIHdhcm5pbmcuIFRoaXMgY29tbWl0IGlzIHNpbWlsYXIgdG8gZTdhOWIwNWNh
NA0KPj4gKCJjcnlwdG86IGNhdml1bSAtIEZpeCBzbXBfcHJvY2Vzc29yX2lkKCkgd2FybmluZ3Mi
KS4NCj4+DQo+PiBTaWxlbmNlcyB0aGUgZm9sbG93aW5nIHNwbGF0Og0KPj4gQlVHOiB1c2luZyBz
bXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2RlOiBjcnlwdG9t
Z3JfdGVzdC8yOTA0DQo+PiBjYWxsZXIgaXMgcWF0X2FsZ19hYmxrY2lwaGVyX3NldGtleSsweDMw
MC8weDRhMCBbaW50ZWxfcWF0XQ0KPj4gQ1BVOiAxIFBJRDogMjkwNCBDb21tOiBjcnlwdG9tZ3Jf
dGVzdCBUYWludGVkOiBQICAgICAgICAgICBPICAgIDQuMTQuNjkgIzENCj4gSG93IGRpZCB5b3Ug
cmVwcm9kdWNlIHRoaXMgcHJvYmxlbT8NCg0KU29ycnksIHRoZSBwcmV2aW91cyBtZXNzYWdlIHNo
b3VsZCBoYXZlIGNvbnRhaW5lZCAiQ09ORklHX0RFQlVHX1BSRUVNUFQiLi4uDQoNCi0tIA0KQmVz
dCByZWdhcmRzLA0KQWxleGFuZGVyIFN2ZXJkbGluLg0K
