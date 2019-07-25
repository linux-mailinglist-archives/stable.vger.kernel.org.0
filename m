Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF174D9E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404382AbfGYL6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:58:49 -0400
Received: from mail-eopbgr750073.outbound.protection.outlook.com ([40.107.75.73]:19429
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404362AbfGYL6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 07:58:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sfd5HIVRVygk7jomR8n7tpvhzWZvLGvsLNMS7ME+t6rIatN/EdChTw0dvoLrs30BFlWoUVbgdvExy0f8yPcvGOz4KrDGBcqeBvUtDpYaby3+p3ADOJGihE1B6RpyTfaNQvV51icGFsarrkt6w6/YAtKJ6ZRmsh1GlOjeHMTqzItCOtReaWyCA7lShH/ovA+s6OKimeVAVKCa/TZZkuKZYly7CJz7yDYXPpY9vbPsxiODCG4W2q6pkd5bHj2GpckTnoeGHAgk3tyg14PU7h1ekpg4anh6ohwCL0OM2eOxzN2VX6NX5lLP0f7j4Rbm4rnCVOoRSEdn6dH4NxDgO5IR+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWcaCKmCjwGqczVZ7SsC/DlGteVp13hcZqyZ+lvM0WI=;
 b=BwGAVBbSnq2bJypkYbGyghHtpW3EcVWX6C1so8l2tgGmRxa7LLH3cGES7raUp0ZBMwvYej3FfmPX/9S7DINkvFnYGu7duMFlYp2a0sIKXqy0CAe4kbovzjArl1FIXuVStoD/ANmWwfU+oBGpx/k6jet9v7Vj5k8in1PM7Z67myWwkyuY2W6hFc40OmQaBsgVTTux/Eq5OP7LJLsaKpjDAFB7HwgU+nF2AlA+odmhK+rEj1KTsfIuFWVikt+KD7QUDBo5G5AWUGjEH4gZhOKL/4ekeMYCKNyvqGMqRD0P65eNziqMVec5SRQnj7xvMH2Uz8EM5JjtCJmKXwVCcxyCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWcaCKmCjwGqczVZ7SsC/DlGteVp13hcZqyZ+lvM0WI=;
 b=SFQE98tWpQIZrfPlLInsTh+8IC4cU1gr0D+MxLId3h2YuSOgx3oo79PAhAaPcDOvAiv1Kn/BCeSGRPwmMPhRQRIcVyijz17zTE/o++2SO7zy/ohDTHbJFe7KA4iuIKms/02t/djXpiyE2NMuVftCInGTKh4ASbLvwepjwmXsSoc=
Received: from DM5PR12MB1546.namprd12.prod.outlook.com (10.172.36.23) by
 DM5PR12MB1466.namprd12.prod.outlook.com (10.172.38.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 11:58:45 +0000
Received: from DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::cda7:cfc1:ce62:bcb7]) by DM5PR12MB1546.namprd12.prod.outlook.com
 ([fe80::cda7:cfc1:ce62:bcb7%10]) with mapi id 15.20.2094.013; Thu, 25 Jul
 2019 11:58:45 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR control
 register
Thread-Topic: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR
 control register
Thread-Index: AQHVQtvpdtZk0qe7TkWQldEObdm2T6bbOt4A
Date:   Thu, 25 Jul 2019 11:58:45 +0000
Message-ID: <20b10b86-6967-5515-5183-e6a3fe5aa268@amd.com>
References: <20190725192552.24295-1-sumit.saxena@broadcom.com>
In-Reply-To: <20190725192552.24295-1-sumit.saxena@broadcom.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: PR0P264CA0079.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::19) To DM5PR12MB1546.namprd12.prod.outlook.com
 (2603:10b6:4:8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c859c30c-99cb-42bb-4f5b-08d710f771fa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1466;
x-ms-traffictypediagnostic: DM5PR12MB1466:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB146664FA9B66D474CAA5230E83C10@DM5PR12MB1466.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(199004)(189003)(256004)(316002)(36756003)(58126008)(76176011)(66574012)(65956001)(2501003)(54906003)(110136005)(6436002)(65806001)(7736002)(86362001)(386003)(478600001)(31696002)(2906002)(229853002)(6512007)(305945005)(11346002)(102836004)(966005)(6486002)(446003)(25786009)(486006)(6506007)(64126003)(31686004)(65826007)(99286004)(46003)(186003)(6116002)(476003)(14444005)(14454004)(66446008)(8676002)(64756008)(4326008)(5660300002)(81156014)(66556008)(2616005)(81166006)(66946007)(71190400001)(53936002)(6246003)(8936002)(6306002)(68736007)(52116002)(66476007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1466;H:DM5PR12MB1546.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rBUth4bcuTagnsXcku9AJkUd7WL7Q43ZCRlxT/3Du1IjbMfJbcJdAJ9t5PGOqlWbCAF7b9XsWYNdTTHay1KOnQ5SKN17wR8Tpjra7COROuOSEEDQ14wIJDEmrk90dOAh9ffxIQAm4AyDZx3ZGaGBKfPe4zQC8ovKfNopUm/wlRtXU12ODOs1/0ERZiOvutZdFR3FkXReuGzAdRNjuxczG4zBBF4bK6DCearh8r4wrqGyAPZQIid36OQUKP61MoZ9iKCIxSiFNviCUFg08Hl/QsteQQp4810G8J0foqtYYpmOKbfOsthLC42eMytrbdaHZor5lK832BBjm0hn2dA612bTVVJBWjkKT3vsi1EhuBtGwFykOBdHkH/2x+5fDYrZkb8/2sxq9xbxNNM9UrLUAnrZy0FW4rmnbDyz4n+p48E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D471349B71964E458089242D071056A8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c859c30c-99cb-42bb-4f5b-08d710f771fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 11:58:45.3372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ckoenig@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1466
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW0gMjUuMDcuMTkgdW0gMjE6MjUgc2NocmllYiBTdW1pdCBTYXhlbmE6DQo+IEluIFJlc2l6ZSBC
QVIgY29udHJvbCByZWdpc3RlciwgYml0c1s4OjEyXSByZXByZXNlbnRzIHNpemUgb2YgQkFSLg0K
PiBBcyBwZXIgUENJZSBzcGVjaWZpY2F0aW9uLCBiZWxvdyBpcyBlbmNvZGVkIHZhbHVlcyBpbiBy
ZWdpc3RlciBiaXRzDQo+IHRvIGFjdHVhbCBCQVIgc2l6ZSB0YWJsZToNCj4NCj4gQml0cyAgQkFS
IHNpemUNCj4gMCAgICAgMSBNQg0KPiAxICAgICAyIE1CDQo+IDIgICAgIDQgTUINCj4gMyAgICAg
OCBNQg0KPiAtLQ0KPg0KPiBGb3IgMSBNQiBCQVIgc2l6ZSwgQkFSIHNpemUgYml0cyBzaG91bGQg
YmUgc2V0IHRvIDAgYnV0IGluY29ycmVjdGx5DQo+IHRoZXNlIGJpdHMgYXJlIHNldCB0byAiMWYi
LiBMYXRlc3QgbWVnYXJhaWRfc2FzIGFuZCBtcHQzc2FzIGFkYXB0ZXJzDQo+IHdoaWNoIHN1cHBv
cnQgUmVzaXphYmxlIEJBUiB3aXRoIDEgTUIgQkFSIHNpemUgZmFpbHMgdG8gaW5pdGlhbGl6ZQ0K
PiBkdXJpbmcgc3lzdGVtIHJlc3VtZSBmcm9tIFMzIHNsZWVwLg0KPg0KPiBGaXg6IENvcnJlY3Rs
eSBjYWxjdWxhdGUgQkFSIHNpemUgYml0cyBmb3IgUmVzaXplIEJBUiBjb250cm9sIHJlZ2lzdGVy
Lg0KPg0KPiBWMjoNCj4gLVNpbXBsaWZpZWQgY2FsY3VsYXRpb24gb2YgQkFSIHNpemUgYml0cyBh
cyBzdWdnZXN0ZWQgYnkgQ2hyaXN0aWFuIEtvZW5pZy4NCj4NCj4gQ0M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcgIyB2NC4xNisNCj4gQnVnemlsbGE6IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9y
Zy9zaG93X2J1Zy5jZ2k/aWQ9MjAzOTM5DQo+IEZpeGVzOiBkMzI1MmFjZTBiYzY1MmExYTI0NDQ1
NTU1NmI2YTU0OWY5NjliZjk5ICgiUENJOiBSZXN0b3JlIHJlc2l6ZWQgQkFSIHN0YXRlIG9uIHJl
c3VtZSIpDQo+IFNpZ25lZC1vZmYtYnk6IFN1bWl0IFNheGVuYSA8c3VtaXQuc2F4ZW5hQGJyb2Fk
Y29tLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2Vu
aWdAYW1kLmNvbT4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL3BjaS9wY2kuYyB8IDIgKy0NCj4gICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMNCj4gaW5kZXggMjll
ZDVlYzFhYzI3Li5lNTk5MjEyOTYxMjUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvcGNpL3BjaS5j
DQo+ICsrKyBiL2RyaXZlcnMvcGNpL3BjaS5jDQo+IEBAIC0xNDM4LDcgKzE0MzgsNyBAQCBzdGF0
aWMgdm9pZCBwY2lfcmVzdG9yZV9yZWJhcl9zdGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCj4g
ICAJCXBjaV9yZWFkX2NvbmZpZ19kd29yZChwZGV2LCBwb3MgKyBQQ0lfUkVCQVJfQ1RSTCwgJmN0
cmwpOw0KPiAgIAkJYmFyX2lkeCA9IGN0cmwgJiBQQ0lfUkVCQVJfQ1RSTF9CQVJfSURYOw0KPiAg
IAkJcmVzID0gcGRldi0+cmVzb3VyY2UgKyBiYXJfaWR4Ow0KPiAtCQlzaXplID0gb3JkZXJfYmFz
ZV8yKChyZXNvdXJjZV9zaXplKHJlcykgPj4gMjApIHwgMSkgLSAxOw0KPiArCQlzaXplID0gb3Jk
ZXJfYmFzZV8yKHJlc291cmNlX3NpemUocmVzKSA+PiAyMCk7DQo+ICAgCQljdHJsICY9IH5QQ0lf
UkVCQVJfQ1RSTF9CQVJfU0laRTsNCj4gICAJCWN0cmwgfD0gc2l6ZSA8PCBQQ0lfUkVCQVJfQ1RS
TF9CQVJfU0hJRlQ7DQo+ICAgCQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKHBkZXYsIHBvcyArIFBD
SV9SRUJBUl9DVFJMLCBjdHJsKTsNCg0K
