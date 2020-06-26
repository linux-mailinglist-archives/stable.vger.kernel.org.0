Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9020BC6C
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 00:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgFZWXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 18:23:43 -0400
Received: from mail-bn7nam10on2100.outbound.protection.outlook.com ([40.107.92.100]:26626
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgFZWXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 18:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkc9Dj6pO+P8NFl5vfO+MeLhrRXNM7iuOd+4UXerzzYDH5GREiaFjYay6SNKVfWFKBGZ4ZIBp3Vl0A6GUDTPvYhhMmrecN+1jt+pimCYcNwa9gxIuCyxwrEKI/sFYEMKLnaBBpZj1Fgub+ZlM1DSH0UdAyVvrAPn9CkQqQzvJITSZWOvKCcKNY0oIFbURHCna+6K1vMEMMOnLLd+pP2swSBYk5r84GVLZI4gy95JFQK4we17DPQG4C7FKAC6a68X45gksaARIwECY7GdJwVXb97E8wOY/+1Ece5D8B7xF0qG60iPsf4Be/mgdMqO6asDbhw9Jj+PWCb7snl2i3iuag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGVo213mmz8l7o7E1r9aKa5cr+nN7fMeacsv/QR18no=;
 b=iYyAprnI+wri5p9JFdkmSi8irh+0QAgbmHPWbCwq5znHjcRG8Bs+enlrsIv1yOzTwFqsWcY+t6AkC0lqVoH4c1qgDsyTc1oSIdF0w22elU4X83tbHqa7jcdzWCa78G/hqL4ZBbcoZNNky5KQlKcSCLWDaCGaFsAXsEqcGuc3EI+rFo+YkOkG5HoffqgBYD6NptEjizDYybBy2/Xa5FD3uqHfqpwlSBrKltNo04rrkUpzAEv6mlOdX9Ly/c9/AxOck+EnVxqQ/+GpdEoFe+Yjv/ZNU02PTLFohmY2B1pq+3LwCIEl6MCs8N1ORCkDD2semp/Ab1SR+Bh5cPp8SAf25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGVo213mmz8l7o7E1r9aKa5cr+nN7fMeacsv/QR18no=;
 b=SkvTvfjB2zlvdoajFfrnzk2J4iHIJzsfKXt85Z03QNwUVhPyoN6l9h9SgdLfqh/pLFzfYj9T0ucfm8nB1YhebNWRE/Ge3MOD6FQV/Ek0PlbsD9jJaqYROMJ1crWSqKvIJ8U6dr/5O7rxaQizXyCMiXzln6+CZGc0e3hGxhKsw0M=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0811.namprd21.prod.outlook.com (2603:10b6:301:7b::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.4; Fri, 26 Jun
 2020 22:23:38 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%9]) with mapi id 15.20.3153.005; Fri, 26 Jun 2020
 22:23:38 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: Change flag to write log level in panic msg
 to false
Thread-Topic: [PATCH] Drivers: hv: Change flag to write log level in panic msg
 to false
Thread-Index: AQHWS+HzVTYTKiLVr0O7dTomrubg4KjrWqJQgAAa/lCAAAJBEA==
Date:   Fri, 26 Jun 2020 22:23:38 +0000
Message-ID: <MW2PR2101MB1052837695100EF9B4BC9874D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <1593193685-74615-1-git-send-email-joseph.salisbury@microsoft.com>
 <MW2PR2101MB10520D5E1FDE45C5DF03D073D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <MN2PR21MB1453A27BD0EBE78E7ECA49C99C930@MN2PR21MB1453.namprd21.prod.outlook.com>
In-Reply-To: <MN2PR21MB1453A27BD0EBE78E7ECA49C99C930@MN2PR21MB1453.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-06-26T20:53:23Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a4721757-2579-4dc7-adb6-85c2b12895f0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 018969b7-0cb5-4891-ec5f-08d81a1f9318
x-ms-traffictypediagnostic: MWHPR2101MB0811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB0811FB2445CE37B8F183BC68D7930@MWHPR2101MB0811.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qDadN8R34HoyPfYHWeDPB2mW0gjjNvENm4RggVO78eDhpD3aI7dsnr8SXe8ESU1O6XJRhR2UgcTkpigbKmlASGDVv2TY56mr/KlFx16nECYIl3EfkKx2GZyCChhlC2R6KFzUwr201BtPixc3sM+NxcItxE0ZMd/TdhTfEFykx+W+qvrrO/99wBI89Rk69ePSNQDjlD9hnsHhlRrzm689KkvymXegpCBd/cm3aIsldDBXywc3VOK3EnLm/OLupPUhekSOSnKoeYe04417P72ZXCIqeq0piFJjxf3spLe9XolT8hD9luD/GZYPksXVUNabGRb0ohn85VXOXxSU9FPO9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(478600001)(8936002)(7696005)(8676002)(26005)(53546011)(83380400001)(54906003)(4326008)(82950400001)(52536014)(6506007)(82960400001)(55016002)(2906002)(66446008)(66556008)(10290500003)(186003)(110136005)(76116006)(9686003)(64756008)(71200400001)(86362001)(66946007)(5660300002)(33656002)(8990500004)(316002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SN5qJtiiJYQdbOxHaaYpzvJntnw4B4XB/5du+0Fjk/eVTF7N14nrcWPvdmhPXFa9XBIeizGGrw5R7NlOR6qgHTYxYNZno7zCXbQdjM5yvxfNJ+EaNKMgKDUKP5CDujOfG6t58XCFuOQpbxq7JnxfwlAIHpA7lZ3hfZ9XqrUpD7FPOS7HuUqg0T228lyTrKOhUQT3nIdTeFHZ1Wpv3QJ+hAsUWxSsOfqQqKzGMzZA8nHxxUiOGEi2/uolYdHKrQpUoFaEjdxpVIYFVVDqUayFSDHSE66ALL0aZr9SL3N1HlhMGwEwZCw2RRNdUkzkyzY1ShfRwkhQ7fm9qxqRQQ9pWdZLm4LZ7d9VYJr3J7PaIrZVOVb9yn6c1HsHnMyszeRXnqNNsP06fg2LNC5BLeYxqdqar29M05wmE0mrRFTA/WrYGjCRnpw16vwFE25Ut5GwzTnOm/ZSS3bf1OCETCSYgiZ8iBMXSjnPk/epevs+d6BSRSC2WVwUMGi0m+MXoXYz
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018969b7-0cb5-4891-ec5f-08d81a1f9318
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 22:23:38.5898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +b/n21JcSoDm54IvXhbFHW0zXhU3LmUagK1uzGzyzuhB8ZrNenm9UwNhkk+PUjpwhBd419qdrM3mSLiGQzuwnJDBOGwSDHAVqQnJSvO0Ioc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0811
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSm9zZXBoIFNhbGlzYnVyeSA8Sm9zZXBoLlNhbGlzYnVyeUBtaWNyb3NvZnQuY29tPiAg
U2VudDogRnJpZGF5LCBKdW5lIDI2LCAyMDIwIDM6MTYgUE0NCj4gDQo+IFRoYW5rcyBmb3IgdGhl
IGZlZWRiYWNrLCBNaWNoYWVsLiAgSSdsbCBzZW5kIGEgdjIuDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBKb2UNCg0KQSBxdWljayBub3RlOiAgVGhlIHN0eWxlIG9uIHRoZSBMaW51eCBrZXJuZWwgbWFp
bGluZyBsaXN0cyBpcyB0byBhbHdheXMgcmVwbHkNCmlubGluZSwgYWZ0ZXIgdGhlIHRleHQgeW91
IGFyZSByZXBseWluZyB0by4gIFRoaXMgaXMgcXVpdGUgZGlmZmVyZW50IGZyb20gdGhlDQpzdHls
ZSB1c3VhbGx5IHVzZWQgaW5zaWRlIE1pY3Jvc29mdCwgd2hpY2ggaXMgY2FsbGVkICJ0b3AgcG9z
dGluZyIuDQoNCk1pY2hhZWwNCg0KPiANCj4gDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+IEZyb206IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0KPiBTZW50
OiBGcmlkYXksIEp1bmUgMjYsIDIwMjAgNDo1MyBQTQ0KPiBUbzogSm9zZXBoIFNhbGlzYnVyeSA8
Sm9zZXBoLlNhbGlzYnVyeUBtaWNyb3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbg0KPiA8a3lzQG1p
Y3Jvc29mdC5jb20+OyBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsgU3Rl
cGhlbiBIZW1taW5nZXINCj4gPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+OyBzYXNoYWxAa2VybmVs
Lm9yZzsgd2VpLmxpdUBrZXJuZWwub3JnDQo+IENjOiBsaW51eC1oeXBlcnZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0hdIERyaXZlcnM6IGh2OiBDaGFuZ2UgZmxhZyB0byB3cml0
ZSBsb2cgbGV2ZWwgaW4gcGFuaWMgbXNnIHRvIGZhbHNlDQo+IA0KPiBGcm9tOiBKb3NlcGggU2Fs
aXNidXJ5IDxqb3NlcGguc2FsaXNidXJ5QG1pY3Jvc29mdC5jb20+IFNlbnQ6IEZyaWRheSwgSnVu
ZSAyNiwgMjAyMCAxMDo0OA0KPiBBTQ0KPiA+DQo+ID4gV2hlbiB0aGUga2VybmVsIHBhbmljcywg
b25lIHBhZ2Ugd29ydGggb2Yga21zZyBkYXRhIGlzIHdyaXR0ZW4gdG8gYW4NCj4gPiBhbGxvY2F0
ZWQgcGFnZS4gIFRoZSBIeXBlcnZpc29yIGlzIG5vdGlmaWVkIG9mIHRoZSBwYWdlIGFkZHJlc3Mg
dHJvdWdoDQo+ID4gdGhlIE1TUi4gIFRoaXMgcGFuaWMgaW5mb3JtYXRpb24gaXMgY29sbGVjdGVk
IG9uIHRoZSBob3N0LiAgU2luY2Ugd2UNCj4gPiBhcmUgb25seSBjb2xsZWN0aW5nIG9uZSBwYWdl
IG9mIGRhdGEsIHRoZSBmdWxsIHBhbmljIG1lc3NhZ2UgbWF5IG5vdCBiZSBjb2xsZWN0ZWQuDQo+
ID4NCj4gPiBFYWNoIGxpbmUgb2YgdGhlIHBhbmljIG1lc3NhZ2UgaXMgcHJlZml4ZWQgd2l0aCB0
aGUgbG9nIGxldmVsIG9mIHRoYXQNCj4gPiBwYXJ0aWN1bGFyIG1lc3NhZ2UgaW4gdGhlIGZvcm0g
PE4+LCB3aGVyZSBOIGlzIHRoZSBsb2cgbGV2ZWwuICAgVGhlIHR5cGljYWwNCj4gPiA0IEtieXRl
cyBjb250YWlucyBhbnl3aGVyZSBmcm9tIDUwIHRvIDEwMCBsaW5lcyB3aXRoIHRoYXQgbG9nIGxl
dmVsIHByZWZpeC4NCj4gPg0KPiA+IGh2X2Rtc2dfZHVtcCgpIG1ha2VzIGEgY2FsbCB0byBrbXNn
X2R1bXBfZ2V0X2J1ZmZlcigpLiAgVGhlIHNlY29uZA0KPiA+IGFyZ3VtZW50IGluIHRoZSBjYWxs
IGlzIGEgYm9vbCBkZXNjcmliZWQgYXM6IOKAmEBzeXNsb2c6IGluY2x1ZGUgdGhlIOKAnDw0PuKA
nSBQcmVmaXhlc+KAmS4NCj4gPg0KPiA+IFdpdGggdGhpcyBjaGFuZ2UsIHdlIHdpbGwgbm90IHdy
aXRlIHRoZSBsb2cgbGV2ZWwgdG8gdGhlIGFsbG9jYXRlZA0KPiA+IHBhZ2UuICBUaGlzIHdpbGwg
cHJvdmlkZSBhZGRpdGlvbmFsIHJvb20gaW4gdGhlIGFsbG9jYXRlZCBwYWdlIGZvcg0KPiA+IG1v
cmUgaW5mb3JtYXRpdmUgcGFuaWMgaW5mb3JtYXRpb24uDQo+IA0KPiBMZXQgbWUgc3VnZ2VzdCB0
aWdodGVuaW5nIHRoZSBjb21taXQgbWVzc2FnZSBhIGJpdCwgd2l0aCBmb2N1cyBvbiB0aGUgIndo
YXQiDQo+IGFuZCAid2h5IiByYXRoZXIgdGhhbiB0aGUgZGV0YWlscyBvZiB0aGUgY29kZSBjaGFu
Z2UuICBBbHNvIHVzZSBpbXBlcmF0aXZlIHZvaWNlIHBlciB0aGUNCj4gTGludXgga2VybmVsIGd1
aWRlbGluZXM6DQo+IA0KPiBXaGVuIHRoZSBrZXJuZWwgcGFuaWNzLCBvbmUgcGFnZSBvZiBrbXNn
IGRhdGEgbWF5IGJlIGNvbGxlY3RlZCBhbmQgc2VudCB0byBIeXBlci1WIHRvIGFpZA0KPiBpbiBk
aWFnbm9zaW5nIHRoZSBmYWlsdXJlLiAgVGhlIGNvbGxlY3RlZCBrbXNnIGRhdGEgdHlwaWNhbGx5
IGNvbnRhaW5zIDUwIHRvIDEwMCBsaW5lcywgZWFjaCBvZg0KPiB3aGljaCBoYXMgYSBsb2cgbGV2
ZWwgcHJlZml4IHRoYXQgaXNuJ3QgdmVyeSB1c2VmdWwgZnJvbSBhIGRpYWdub3N0aWMgc3RhbmRw
b2ludC4gIFNvIHRlbGwNCj4ga21zZ19kdW1wX2dldF9idWZmZXIoKSB0byBub3QgaW5jbHVkZSB0
aGUgbG9nIGxldmVsLCBlbmFibGluZyBtb3JlIGluZm9ybWF0aW9uIHRoYXQgKmlzKg0KPiB1c2Vm
dWwgdG8gZml0IGluIHRoZSBwYWdlLg0KPiANCj4gPg0KPiA+IFJlcXVlc3RpbmcgaW4gc3RhYmxl
IGtlcm5lbHMsIHNpbmNlIG1hbnkga2VybmVscyBydW5uaW5nIGluIHByb2R1Y3Rpb24NCj4gPiBh
cmUgc3RhYmxlIHJlbGVhc2VzLg0KPiA+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBKb3NlcGggU2FsaXNidXJ5IDxqb3NlcGguc2FsaXNidXJ5QG1p
Y3Jvc29mdC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvaHYvdm1idXNfZHJ2LmMgfCAyICst
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHYvdm1idXNfZHJ2LmMgYi9kcml2ZXJzL2h2L3Zt
YnVzX2Rydi5jIGluZGV4DQo+ID4gOTE0N2VlOWQ1ZjdkLi5kNjlmNGVmYTM3MTkgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9odi92bWJ1c19kcnYuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaHYvdm1i
dXNfZHJ2LmMNCj4gPiBAQCAtMTM2OCw3ICsxMzY4LDcgQEAgc3RhdGljIHZvaWQgaHZfa21zZ19k
dW1wKHN0cnVjdCBrbXNnX2R1bXBlciAqZHVtcGVyLA0KPiA+ICAJICogV3JpdGUgZHVtcCBjb250
ZW50cyB0byB0aGUgcGFnZS4gTm8gbmVlZCB0byBzeW5jaHJvbml6ZTsgcGFuaWMgc2hvdWxkDQo+
ID4gIAkgKiBiZSBzaW5nbGUtdGhyZWFkZWQuDQo+ID4gIAkgKi8NCj4gPiAtCWttc2dfZHVtcF9n
ZXRfYnVmZmVyKGR1bXBlciwgdHJ1ZSwgaHZfcGFuaWNfcGFnZSwgSFZfSFlQX1BBR0VfU0laRSwN
Cj4gPiArCWttc2dfZHVtcF9nZXRfYnVmZmVyKGR1bXBlciwgZmFsc2UsIGh2X3BhbmljX3BhZ2Us
IEhWX0hZUF9QQUdFX1NJWkUsDQo+ID4gIAkJCSAgICAgJmJ5dGVzX3dyaXR0ZW4pOw0KPiA+ICAJ
aWYgKGJ5dGVzX3dyaXR0ZW4pDQo+ID4gIAkJaHlwZXJ2X3JlcG9ydF9wYW5pY19tc2cocGFuaWNf
cGEsIGJ5dGVzX3dyaXR0ZW4pOw0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+IA0KPiBXaXRoIHRoZSBj
b21taXQgbWVzc2FnZSBjaGFuZ2VzLA0KPiANCj4gUmV2aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5
IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0K
