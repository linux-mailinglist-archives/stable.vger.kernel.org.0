Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031A610CF4C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 21:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfK1Ukn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 15:40:43 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:45524 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbfK1Ukn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 15:40:43 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3703BC04B8;
        Thu, 28 Nov 2019 20:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574973642; bh=vrthH7vDf7QnIKgmHn+FaYj+LQpyVkwoKuvouU/jOlU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YRFsqGLcyFgYNuZVUK+p6lhv+6oBaSbggnfQjyLSUvehVCbsBbqjGPB7L+qeHWavL
         a1wRj+LRr9YzPvOS0Topm5bpZuOtUdmdG4Gni/ZBtoOTWKnbMtlIaoqDdNV7amonlK
         xhUhNHT/H4QxiEzcG2sZDSwbOm7+FmDuC94KQi4igWbZ+ffABs9UrVfivpqHESe4HU
         BGJPXeOGQVf/cAMsTBMM3jx11CF81XlXpUwI2hJsx2V6BSs5siKjwudWcJKYVk9pKk
         YDQV3uUkmH5ukqM+cfbXmQH6JgdyoWm0yY8gNJvPa66oTE2HXDabM1epByYaWiyihc
         ZMkphsNEhtWmA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 917FEA0066;
        Thu, 28 Nov 2019 20:40:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 28 Nov 2019 12:40:40 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 28 Nov 2019 12:40:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+F4uNpUzXptogC4wcM3nD9RbCxlQkBmacBrzGsZLtlQi0V7MnCpd101wYtqe3KNDkBQVSU451GdouviID/4tD64aHNi5/O/Thc65UXD/mhL0A/Uss78qU2ILJUOwMaTOm/v8mO6D8fOP9C569nhglPU3Z9saXsuXLXIZ1kscBoFwsEcARJHhgyuqkW/8DWNAaB0KJ9/6juZozjiaIctCj/TJs3y0yHjEy25ymqUNnnti0vpzktPlRLL1zFqnh/azNIDqf7L16Y95j1sYfz96I0x+LokoyqUF+ASZ9wI8zCsM055MBGhBNXMo7HqFt+cOuOiACFi8CNzKHjlRirOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrthH7vDf7QnIKgmHn+FaYj+LQpyVkwoKuvouU/jOlU=;
 b=C6XYyzt360MblL4xHft75YBmND7RlvQkzIB3bkqL0/wBRktrLVdven3qr5Z4OgbY9u56PDFiVUldD+JOSttJ9mF7BvMl5BTqtzIQAX6tqo3Ea6p8gNU2uxn847fbBNTBCoUedoAZJWT5a0HlLmxCs0uncigP/c/M2VpOdeLOjsFf8HTR7a4pcm6d5s1Rfr6rzuL2/ctDR0QqoVy2af+7nmmMkfe6nJobi3+VeWKZxVvBWj16IkKAkX7UTz8nfj0VRQDLSfb5hKh+XPHYIf46JHWSzI4fasjQ4mJWnpTX57RamSp0zlbYy4Tii7R3YsrWEkgnPZdrOXeM/qQ/qiESfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrthH7vDf7QnIKgmHn+FaYj+LQpyVkwoKuvouU/jOlU=;
 b=Tbd5GLqFwDovSxYyO9n7hrUr+HrrfjsowKtBkIOFSSzk5fDxvlJy/zvnNB+1Cea/B5rmbOnJOyBlGx3nz5kAdrtaQfn0vC143RRuUbV7FHTItTcmZQzNiQDiQmbyyjJfRI+2vy9NtqQziLLOuHzTkF85zhiquWMCEGiSslVauAk=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0023.namprd12.prod.outlook.com (10.172.79.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 28 Nov 2019 20:40:38 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2495.014; Thu, 28 Nov 2019
 20:40:38 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
Thread-Topic: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
Thread-Index: AQHVpWwJjRcuVvPds0SRD8AQcHPAOqegLUaAgADgD4A=
Date:   Thu, 28 Nov 2019 20:40:38 +0000
Message-ID: <b72986d6-d23c-1fa7-89c3-0d71a46534da@synopsys.com>
References: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
 <20191128071841.GB3317260@kroah.com>
In-Reply-To: <20191128071841.GB3317260@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20a61b54-7ca8-4f12-f1ab-08d774433a50
x-ms-traffictypediagnostic: CY4PR1201MB0023:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB0023A3FFAB67A9F0CFD561C9AA470@CY4PR1201MB0023.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(66446008)(6512007)(305945005)(81156014)(2616005)(6506007)(186003)(31696002)(8676002)(8936002)(102836004)(76176011)(31686004)(6246003)(14454004)(11346002)(86362001)(478600001)(81166006)(446003)(5660300002)(3846002)(4326008)(25786009)(14444005)(99286004)(66476007)(76116006)(316002)(26005)(71190400001)(6436002)(6116002)(54906003)(110136005)(6486002)(64756008)(2906002)(66066001)(7736002)(66556008)(71200400001)(36756003)(66946007)(229853002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0023;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XjqUAgtB0R55deWkq4+B43bGzhK2D/XMkxLZSO850m6V7La29v6FzakvLg1hwfe6KiEVJ1jLZQqbCmVJ1EW9Mcl/0rbsjE4z/arX2YO/XxfFh4Yqs5o+KM+eb7kzab42sTRkJE4PPqSj0DnZ8dzKcldVer0S7PJhInE53bJs0DfG3njKjjYZSNNEDv1+j7/v/hHM5c8dcIodPl8+zH0XKIUdUrzh2PSN+lPZgSzCKjtB7BmKaHuWxrUMssdPFnxo18M6FwXjq5SaT0afqw2Q4lRvUu75Vrqs7baGoPplRT35LMwG8AYuMY2kYTYj6yma9G0d6cfpUmbUeZtrOYeI97i+V8FCtF4NDOnvP1KmcuvsjQzl7k33jdsXMIlHHcpACCS5s79NX/Vlhk6WCGDZIW06HEeBhyuSd3qipt/9ZWtHT6u/G8GX54hS57ul5cDQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <9460729DD7666D41B3ABB11EF0D94F76@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a61b54-7ca8-4f12-f1ab-08d774433a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 20:40:38.4939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7J1yJK5CeLqqCexdhfbWvmjU1e7wjJ1kpc8orw4NOaY9+SA/K0gaW/wImfHKeURpcVV9xDgE4OUGghDENk/W+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0023
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

R3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBPbiBXZWQsIE5vdiAyNywgMjAxOSBhdCAwMTo0
NToxNVBNIC0wODAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiBUaGUgZnVuY3Rpb24gZHJpdmVy
IG1heSB0cnkgdG8gZW5hYmxlIGFuIHVuY29uZmlndXJlZCBlbmRwb2ludC4gVGhpcw0KPj4gY2hl
Y2sgbWFrZSBzdXJlIHRoYXQgd2UgZG8gbm90IGF0dGVtcHQgdG8gYWNjZXNzIGEgTlVMTCBkZXNj
cmlwdG9yIGFuZA0KPj4gY3Jhc2guDQo+Pg0KPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4+IFNpZ25lZC1vZmYtYnk6IFRoaW5oIE5ndXllbiA8dGhpbmhuQHN5bm9wc3lzLmNvbT4NCj4+
IC0tLQ0KPj4gICBkcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIHwgMyArKysNCj4+ICAgMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4gaW5kZXggN2Y5
Nzg1NmU2YjIwLi4wMGY4ZjA3OWJiZjIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3VzYi9kd2Mz
L2dhZGdldC5jDQo+PiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+PiBAQCAtNjE5
LDYgKzYxOSw5IEBAIHN0YXRpYyBpbnQgX19kd2MzX2dhZGdldF9lcF9lbmFibGUoc3RydWN0IGR3
YzNfZXAgKmRlcCwgdW5zaWduZWQgaW50IGFjdGlvbikNCj4+ICAgCXUzMgkJCXJlZzsNCj4+ICAg
CWludAkJCXJldDsNCj4+ICAgDQo+PiArCWlmICghZGVzYykNCj4+ICsJCXJldHVybiAtRUlOVkFM
Ow0KPiBIb3cgY2FuIHRoaXMgaGFwcGVuPyAgU2hvdWxkbid0IHRoaXMgYmUgY2F1Z2h0IGF0IGFu
IGVhcmxpZXIgcG9pbnQgaW4NCj4gdGltZT8NCg0KWWVhaCwgaXQgc2hvdWxkLCBhbmQgaXQncyBh
bHJlYWR5IGhhbmRsZWQgb3Igbm90ZWQgaW4gYWxsIHRoZSBmdW5jdGlvbiANCmRyaXZlcnMgaW4g
dGhlIGtlcm5lbC4gSXQganVzdCBidWdzIG1lIGEgbGl0dGxlIHNlZWluZyB0aGF0IGl0IGRvZXNu
J3QgDQpmYWlsIGdyYWNlZnVsbHkgaWYgaXQncyBub3QgdGhlIGNhc2UuDQoNCllvdSBjYW4gZGlz
Y2FyZCB0aGlzIHBhdGNoIGlmIHlvdSB0aGluayBpdCdzIHVubmVjZXNzYXJ5Lg0KDQpUaGFua3Ms
DQpUaGluaA0K
