Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A918385B2D
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 09:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfHHHBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 03:01:46 -0400
Received: from mail-eopbgr730084.outbound.protection.outlook.com ([40.107.73.84]:22688
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725817AbfHHHBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 03:01:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZLOm3kJgtPJNBvOfg2v6+oEz5yCo77eE3W6HrjrGtaUWR8jFmx8oy7C0qpMn2yREHzWbmTCSmZrjJsWVE/Stv17TaaekXtNjPsSbzAWaNMjQRMuBnbqU2MaohfE1xdLKAipMord+KbbH5d1tIXe/uEY5QO/02Z9bCOpDw4kKjGVxerZKPPu+aLn+E41eIbxETgCrowuaZpn/RDbc6DnZWI4aoOCVIi/DwTJFpSn9VZADT3Z4ovKjujhCQawKVbTmtlU3S5UolFbsV3Ovpk672Vpgo4mfNchXYepCS6+6qmXN62IOb0f0xkcn7MBXBEzN4IH0xjfbRtWkEz2JtYIUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kB2dpSYa22LoBl7Ptzy5v8bfQEgpdajDtATYblzYooI=;
 b=QPPj1Y8U86pKnxwakij2hwwkJzfOBZgB0xfTEhKB3ofJKEEeScRUtcmj56iP1PTz4JoGwhJf3G3K43OqvtL5LrT+7nvXhAI2Y1WugG/S153C1cqLoeQUvTXh/DGgzncWt8IQv7cFGOKxk0Dm3ElXfJ9phBRSM68E1lBz8VOHaDn5cF/CT2CfjGqXBVfNNJpx3XlyiqLlitSlK7LBZZZ+selQG0BrBHhK3RTAxG55CNevgQ9dfXRIj/eJt0jAtScIw6RbeOBwsc6Do/h6oVD4BxoSBCLi2CpHmnN3UCsthBPIOgbrs1LsqVSBXoLNRlGtQP0UMGh/1jEX2N42DYFoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kB2dpSYa22LoBl7Ptzy5v8bfQEgpdajDtATYblzYooI=;
 b=gPWKz6oYT5bzGoFXMyR3AXm8ByBFZPuIBzPrXu2arKQPGWKgnD7gfG0qxwGhhflCy31IFYI6kpTRFsvO1aRRWyDpstAIzlhuc7zijwRX85QhRl5FBTebIdjtf9xnEl7XhWJArbEQ7BIRyhYIP4okiT3HMK3dXEXnKcqiKo+FVWQ=
Received: from DM5PR12MB1546.namprd12.prod.outlook.com (10.172.36.23) by
 DM5PR12MB1659.namprd12.prod.outlook.com (10.172.40.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 8 Aug 2019 07:01:04 +0000
Received: from DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::fc5f:ce01:e8c8:db89]) by DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::fc5f:ce01:e8c8:db89%12]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 07:01:03 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR control
 register
Thread-Topic: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR
 control register
Thread-Index: AQHVQtvpdtZk0qe7TkWQldEObdm2T6bwYniAgACF4IA=
Date:   Thu, 8 Aug 2019 07:01:03 +0000
Message-ID: <ed70bffc-eed8-c3c5-ee9b-22e1cad1ae06@amd.com>
References: <20190725192552.24295-1-sumit.saxena@broadcom.com>
 <20190807230149.GA151852@google.com>
In-Reply-To: <20190807230149.GA151852@google.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: PR2PR09CA0001.eurprd09.prod.outlook.com
 (2603:10a6:101:16::13) To DM5PR12MB1546.namprd12.prod.outlook.com
 (2603:10b6:4:8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c54123f-d1d9-4084-dd7f-08d71bce2d14
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1659;
x-ms-traffictypediagnostic: DM5PR12MB1659:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB16592AB3ED6F25ADDA4C126583D70@DM5PR12MB1659.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(199004)(189003)(65806001)(476003)(65956001)(316002)(11346002)(14454004)(2616005)(486006)(446003)(46003)(2906002)(71200400001)(186003)(8676002)(7736002)(81156014)(305945005)(81166006)(65826007)(102836004)(6506007)(386003)(966005)(86362001)(52116002)(5660300002)(64126003)(31696002)(76176011)(110136005)(54906003)(58126008)(31686004)(36756003)(99286004)(66946007)(66476007)(66556008)(64756008)(66446008)(6486002)(4326008)(6306002)(256004)(6512007)(6116002)(14444005)(8936002)(6436002)(71190400001)(229853002)(25786009)(53936002)(6246003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1659;H:DM5PR12MB1546.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JKHSrKjBFk3DYkPoyQsYXfV0jFoXZZX1OhGcwqHiZ6ayaoG8QMt8UXg28SsjXf5kNfr4QGkaqV6D+KFXymZ7YRVp8oHiiKXcFnTToj26Rz5ElbV5CKoGVS9V1SfvhcwZKTFozKtKaqck+E+VjjpIHyQg5eCP8ATmXV92vl2AOcnX2JbC4bVzBbGQz52yX0b6ZRxUI9dUL9QWbeJNKi3w/roO72c+E0ob8UaAfVEkTU5Z5YG9t1KmaGmc4UROVVBdOJsKXfCCWWXtctpiL0vkW5CDo6dK7fBd7Wb1xr+xu7ky7BaFYEslz4HDLFKjrPPwAuwVWNcCAoONTCc4mrvpV0LnTNBybvvzZsTUpTOYikTFzXgXXt4HrluqDi2rI6QzgWCpr697r5uF2rmobwTAC8VB+BXGNpISgnBYpvw1jRw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <387FDB4C7A1FE14C81DA0EA168215EEE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c54123f-d1d9-4084-dd7f-08d71bce2d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 07:01:03.2358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVdbVd6Csd8lwSbSYDTtf4mVqhTI9jKQnZ+Jk8Ss5GMA7rFj/RIh1sJ92EqTUR8h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW0gMDguMDguMTkgdW0gMDE6MDEgc2NocmllYiBCam9ybiBIZWxnYWFzOg0KPiBPbiBGcmksIEp1
bCAyNiwgMjAxOSBhdCAxMjo1NTo1MkFNICswNTMwLCBTdW1pdCBTYXhlbmEgd3JvdGU6DQo+PiBJ
biBSZXNpemUgQkFSIGNvbnRyb2wgcmVnaXN0ZXIsIGJpdHNbODoxMl0gcmVwcmVzZW50cyBzaXpl
IG9mIEJBUi4NCj4+IEFzIHBlciBQQ0llIHNwZWNpZmljYXRpb24sIGJlbG93IGlzIGVuY29kZWQg
dmFsdWVzIGluIHJlZ2lzdGVyIGJpdHMNCj4+IHRvIGFjdHVhbCBCQVIgc2l6ZSB0YWJsZToNCj4+
DQo+PiBCaXRzICBCQVIgc2l6ZQ0KPj4gMCAgICAgMSBNQg0KPj4gMSAgICAgMiBNQg0KPj4gMiAg
ICAgNCBNQg0KPj4gMyAgICAgOCBNQg0KPj4gLS0NCj4+DQo+PiBGb3IgMSBNQiBCQVIgc2l6ZSwg
QkFSIHNpemUgYml0cyBzaG91bGQgYmUgc2V0IHRvIDAgYnV0IGluY29ycmVjdGx5DQo+PiB0aGVz
ZSBiaXRzIGFyZSBzZXQgdG8gIjFmIi4gTGF0ZXN0IG1lZ2FyYWlkX3NhcyBhbmQgbXB0M3NhcyBh
ZGFwdGVycw0KPj4gd2hpY2ggc3VwcG9ydCBSZXNpemFibGUgQkFSIHdpdGggMSBNQiBCQVIgc2l6
ZSBmYWlscyB0byBpbml0aWFsaXplDQo+PiBkdXJpbmcgc3lzdGVtIHJlc3VtZSBmcm9tIFMzIHNs
ZWVwLg0KPj4NCj4+IEZpeDogQ29ycmVjdGx5IGNhbGN1bGF0ZSBCQVIgc2l6ZSBiaXRzIGZvciBS
ZXNpemUgQkFSIGNvbnRyb2wgcmVnaXN0ZXIuDQo+Pg0KPj4gVjI6DQo+PiAtU2ltcGxpZmllZCBj
YWxjdWxhdGlvbiBvZiBCQVIgc2l6ZSBiaXRzIGFzIHN1Z2dlc3RlZCBieSBDaHJpc3RpYW4gS29l
bmlnLg0KPj4NCj4+IENDOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjQuMTYrDQo+PiBCdWd6
aWxsYTogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDM5MzkN
Cj4+IEZpeGVzOiBkMzI1MmFjZTBiYzY1MmExYTI0NDQ1NTU1NmI2YTU0OWY5NjliZjk5ICgiUENJ
OiBSZXN0b3JlIHJlc2l6ZWQgQkFSIHN0YXRlIG9uIHJlc3VtZSIpDQo+PiBTaWduZWQtb2ZmLWJ5
OiBTdW1pdCBTYXhlbmEgPHN1bWl0LnNheGVuYUBicm9hZGNvbS5jb20+DQo+PiAtLS0NCj4+ICAg
ZHJpdmVycy9wY2kvcGNpLmMgfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9wY2ku
YyBiL2RyaXZlcnMvcGNpL3BjaS5jDQo+PiBpbmRleCAyOWVkNWVjMWFjMjcuLmU1OTkyMTI5NjEy
NSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvcGNpL3BjaS5jDQo+PiArKysgYi9kcml2ZXJzL3Bj
aS9wY2kuYw0KPj4gQEAgLTE0MzgsNyArMTQzOCw3IEBAIHN0YXRpYyB2b2lkIHBjaV9yZXN0b3Jl
X3JlYmFyX3N0YXRlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPj4gICAJCXBjaV9yZWFkX2NvbmZp
Z19kd29yZChwZGV2LCBwb3MgKyBQQ0lfUkVCQVJfQ1RSTCwgJmN0cmwpOw0KPj4gICAJCWJhcl9p
ZHggPSBjdHJsICYgUENJX1JFQkFSX0NUUkxfQkFSX0lEWDsNCj4+ICAgCQlyZXMgPSBwZGV2LT5y
ZXNvdXJjZSArIGJhcl9pZHg7DQo+PiAtCQlzaXplID0gb3JkZXJfYmFzZV8yKChyZXNvdXJjZV9z
aXplKHJlcykgPj4gMjApIHwgMSkgLSAxOw0KPj4gKwkJc2l6ZSA9IG9yZGVyX2Jhc2VfMihyZXNv
dXJjZV9zaXplKHJlcykgPj4gMjApOw0KPiBTaW5jZSBCQVIgc2l6ZXMgYXJlIGFsd2F5cyBwb3dl
cnMgb2YgMiwgd291bGRuJ3QgdGhpcyBiZSBzaW1wbGVyIGFzOg0KPg0KPiAJCXNpemUgPSBpbG9n
MihyZXNvdXJjZV9zaXplKHJlcykpIC0gMjA7DQo+DQo+IHdoaWNoIG5pY2VseSBtYXRjaGVzIHRo
ZSB0YWJsZSBpbiBQQ0llIHI1LjAsIHNlYyA3LjguNi4zPw0KDQpZZWFoLCB0aGF0IHNob3VsZCBv
YnZpb3VzbHkgd29yayBhcyB3ZWxsLg0KDQpXZSB3b3VsZCBoYXZlIGEgc2VyaW91cyBwcm9ibGVt
IGluIHRoZSByZXNvdXJjZSBtYW5hZ2VtZW50IGlmIHRoZSANCnJlc291cmNlIHNpemUgaXMgc21h
bGxlciB0aGFuIDFNQiBvciBub3QgYSBwb3dlciBvZiB0d28uDQoNCkZlZWwgZnJlZSB0byBhZGQg
bXkgci1iLg0KDQpSZWdhcmRzLA0KQ2hyaXN0aWFuLg0KDQo+DQo+PiAgIAkJY3RybCAmPSB+UENJ
X1JFQkFSX0NUUkxfQkFSX1NJWkU7DQo+PiAgIAkJY3RybCB8PSBzaXplIDw8IFBDSV9SRUJBUl9D
VFJMX0JBUl9TSElGVDsNCj4+ICAgCQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKHBkZXYsIHBvcyAr
IFBDSV9SRUJBUl9DVFJMLCBjdHJsKTsNCj4+IC0tIA0KPj4gMi4xOC4xDQo+Pg0KDQo=
