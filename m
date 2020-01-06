Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEAE130FBE
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAFJvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 04:51:14 -0500
Received: from mail-eopbgr760044.outbound.protection.outlook.com ([40.107.76.44]:47808
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgAFJvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 04:51:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtIAHWymFODXKggNy7KLFhpu1Nz8Naky9l3Cr/3TSpUPEyymfK2b6vDQ5nBK+1Pa92/S12AewVkJmLAlOdAbRx3736lsm8ueYsMaF7iCsrzxdcdGlSnn7W5f7YcqA8Z55Uo2Br+Uq7NHocJl0/fpmwkqQKwM62WLgAOm6c0a/T/oxMUe9hfFOcuM4OWCCUScP7mkIHAyJAOvL9U51GM2Ip+Ni1KrNvDcn25f2Co7kd7XmLm+IYhuIntekWK42Y6fgf/c02G7443ec2aXS1reuGDAkEu0kzu6r4YgnBla3I0LR/hnxj9rSqWMRO4z0AUqJ9gAW6tjIK9dbnSjplXbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUOl9eO20YlY77Vn4aeJkKBhgSuWy9Gg1o5UOmaY5SA=;
 b=neTWe1h8HPsjrugpGbhlikW1/a96J1bHyoYQ8tXUTMDcmZ68ubyIQtn5UNrfk7L4aA7bckMKQZ7L2+lcfoTbYKJ46nfY47FGZ9rOMPlaHncSLC0Th3HOxWWQZCcjfq4kM7qEqKjYZrKdIXhZMYGchXFoNiP5e3GBri1B+Ohm0z/YAYOniaWsze20JFd13qFk7p2SWqD/FtVQoWtUDM/f9WbS6zjylSt0YicrX9xQo4IE++/E2skceEoxOFWwYdX2elzN/W3XDuY5+zkI3a4fxZCzJeGE//P/zjot7PoVzHq+9V2rqzAPcEPcgU5eJXZHlfo66M22iPoeB2AmwFrhsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUOl9eO20YlY77Vn4aeJkKBhgSuWy9Gg1o5UOmaY5SA=;
 b=qW+0HBogDVVpdthzMTosqZ1Mcu0S5yRRdV7+9oc1pYswHzUtR7VxL9lYp3Cc7HNYYxEQVxv7ygJYCgWZ+rAAUsUli8hofft379DPSeTJ6P8JKPfQYKe2nYzfwkcwWtfaIDRrKY7tfxNNdQaYfH4NqPmSFlNQbYTzr33pPIf9a9s=
Received: from DM6PR12MB4137.namprd12.prod.outlook.com (10.141.186.21) by
 DM6PR12MB3977.namprd12.prod.outlook.com (10.255.175.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 09:51:10 +0000
Received: from DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::cd1d:def3:d2df:3882]) by DM6PR12MB4137.namprd12.prod.outlook.com
 ([fe80::cd1d:def3:d2df:3882%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 09:51:10 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ
Thread-Topic: [PATCH v2] drm/dp_mst: correct the shifting in
 DP_REMOTE_I2C_READ
Thread-Index: AQHVwfm4yImNp/sqV0Wxucimaiw6RKfZfuOAgAPqiiA=
Date:   Mon, 6 Jan 2020 09:51:10 +0000
Message-ID: <DM6PR12MB41373C39680BC72A00B1A9D2FC3C0@DM6PR12MB4137.namprd12.prod.outlook.com>
References: <20200103055001.10287-1-Wayne.Lin@amd.com>
 <246412a450f123e0bbc29c6feb68513cdce2c576.camel@redhat.com>
In-Reply-To: <246412a450f123e0bbc29c6feb68513cdce2c576.camel@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2020-01-06T09:53:14Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=7b0001af-a75f-426b-9111-00009e797593;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_enabled: true
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_setdate: 2020-01-06T09:53:22Z
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_method: Privileged
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_name: Public_0
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_actionid: 3e604ec2-3094-45d0-a5c1-000081c8feac
msip_label_0d814d60-469d-470c-8cb0-58434e2bf457_contentbits: 0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wayne.Lin@amd.com; 
x-originating-ip: [165.204.68.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 444a79ee-e4ba-41f2-d154-08d7928df5ae
x-ms-traffictypediagnostic: DM6PR12MB3977:|DM6PR12MB3977:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB39772D5721E782ABFA5964F7FC3C0@DM6PR12MB3977.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(13464003)(199004)(189003)(316002)(53546011)(2906002)(86362001)(6506007)(66476007)(66556008)(66446008)(66946007)(33656002)(64756008)(110136005)(5660300002)(54906003)(7696005)(26005)(186003)(55016002)(81156014)(81166006)(8676002)(8936002)(71200400001)(52536014)(4326008)(966005)(76116006)(9686003)(45080400002)(478600001)(70780200001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3977;H:DM6PR12MB4137.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mweFjO7C91o7bG27nB3sI4yTBcv8MhbRGiC1CvFJA4ZjhvDDwplSLh8D+CQWOuQcjqkRZ6MQmgp7tzUC2J+AbhMjvSDJKv4Qnniiyruc6Y3lA1CxMEfpUSpIPNgEHUtivxspcCpVOTxykkE3ANUbn2N4nBGYRn5J5uOi92jz9GLkVL87ja1lXdiPwy3btdVjLjTziZyPKDeo7vCJ4W7D3Nq3p3uV5r1aWjDOEXWutOb9sElyOUoG+eRz6XjxHrfAKINTcVfD71RwV1qTazLxPO6v6FTQ+1h/4Gsd/9T8PmvhMKRZrXe18c6kNmZ8koO4YSHJWDmVMRJ/lPKytcWyyORdUyHIINHs0PFBzrGPETWvYBkjEavKhn3xQ9FHshG83eo1vyKgDirkE/0A4Vx0ZbLznliv5hEJmJxZ/br3eGcf2JjMOnODfoq0pMXK8T9jpWICAalk8Y79vC6BbQYXXEId7mbN+DtTIzUHRfZfn9gWLvH3z+Yau/bGC6VAxLchr1sWglNUZvPAe2a2afLthdATcldmwasJFoHHMn1VQtkGoWNiIArm9ZDv7NVl0OC9
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 444a79ee-e4ba-41f2-d154-08d7928df5ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 09:51:10.4749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lTP68+h1kYCd25ZvsmKcyLRBts5sh6eB0CH0GNXQ5b6MVbwhlnfsucvBjib/h448oKvJA+sPk7ayyMb5mzfXoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3977
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBMeXVkZSBQYXVsIDxseXVkZUByZWRoYXQuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgSmFu
dWFyeSA0LCAyMDIwIDY6MDIgQU0NCj4gVG86IExpbiwgV2F5bmUgPFdheW5lLkxpbkBhbWQuY29t
PjsgZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsNCj4gYW1kLWdmeEBsaXN0cy5mcmVl
ZGVza3RvcC5vcmcNCj4gQ2M6IEthemxhdXNrYXMsIE5pY2hvbGFzIDxOaWNob2xhcy5LYXpsYXVz
a2FzQGFtZC5jb20+OyBXZW50bGFuZCwgSGFycnkNCj4gPEhhcnJ5LldlbnRsYW5kQGFtZC5jb20+
OyBadW8sIEplcnJ5IDxKZXJyeS5adW9AYW1kLmNvbT47DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gZHJtL2RwX21zdDogY29ycmVjdCB0aGUgc2hp
ZnRpbmcgaW4NCj4gRFBfUkVNT1RFX0kyQ19SRUFEDQo+IA0KPiBPaCEgSnVzdCBhIGZyaWVuZGx5
IHRpcCwgSSBmaXhlZCB0aGlzIGJlZm9yZSBwdXNoaW5nIHlvdXIgcGF0Y2g6DQo+IA0KPiDinpwg
IGRybS1tYWludCBnaXQ6KGRybS1taXNjLWZpeGVzKSBkaW0gcHVzaA0KPiBkaW06IDBiMWQ1NGNl
ZGJiNCAoImRybS9kcF9tc3Q6IGNvcnJlY3QgdGhlIHNoaWZ0aW5nIGluDQo+IERQX1JFTU9URV9J
MkNfUkVBRCIpOiBGaXhlczogU0hBMSBuZWVkcyBhdCBsZWFzdCAxMiBkaWdpdHM6DQo+IGRpbTog
ICAgIGFkN2Y4YTFmOWNlIChkcm0vaGVscGVyOiBhZGQgRGlzcGxheXBvcnQgbXVsdGktc3RyZWFt
IGhlbHBlciAodjAuNikpDQo+IGRpbTogRVJST1I6IGlzc3VlcyBpbiBjb21taXRzIGRldGVjdGVk
LCBhYm9ydGluZw0KPiANCj4gRm9yIHRoZSBmdXR1cmUsIHdlIGhhdmUgYSBzZXQgb2YgRFJNIG1h
aW50YWluZXIgdG9vbHMgKHRoZXkncmUgcXVpdGUgdXNlZnVsDQo+IGZvciBwZW9wbGUgd2hvIGFy
ZW4ndCBtYWludGFpbmVycyB0aG91Z2ghKSB0aGF0IHlvdSBjYW4gdXNlIHRvIG1ha2Ugc3VyZQ0K
PiB5b3VyIHBhdGNoIGlzIGZvcm1hdHRlZCBjb3JyZWN0bHkgYWhlYWQgb2YgdGltZToNCj4gDQo+
IGh0dHBzOi8vZHJtLnBhZ2VzLmZyZWVkZXNrdG9wLm9yZy9tYWludGFpbmVyLXRvb2xzL2RpbS5o
dG1sPg0KPg0KPiBQYXJ0aWN1bGFybHkgdXNlZnVsIGNvbW1hbmRzOg0KPiAgKiBkaW0gc3BhcnNl
ICMgQ2hlY2tzIGZvciB0cml2aWFsIGNvZGUgaXNzdWVzLCBsaWtlIHNldCBidXQgdW51c2VkIHZh
cmlhYmxlcw0KPiAgKiBkaW0gY2hlY2twYXRjaCAjIENoZWNrcyBmb3IgY29kZSBzdHlsZSBpc3N1
ZXMNCj4gICogZGltIGZpeGVzICRDT01NSVRfSUQgIyBBZGRzIGFuIGFwcHJvcHJpYXRlbHkgZm9y
bWF0dGVkIEZpeGVzOiB0YWcNCj4gICogZGltIGNpdGUgJENPTU1JVF9JRCAjIEFkZHMgYW4gYXBw
cm9wcmlhdGVseSBmb3JtYXR0ZWQgUmVmZXJlbmNlOiB0YWcNCj4NClJlYWxseSBhcHByZWNpYXRl
IGZvciB5b3VyIHRpbWUhDQpJIHdpbGwgaGF2ZSBhIGxvb2sgb24gdGhpcy4gVGhhbmtzIGEgbG90
Lg0KIA0KPiBPbiBGcmksIDIwMjAtMDEtMDMgYXQgMTM6NTAgKzA4MDAsIFdheW5lIExpbiB3cm90
ZToNCj4gPiBbV2h5XQ0KPiA+IEFjY29yZGluZyB0byBEUCBzcGVjLCBpdCBzaG91bGQgc2hpZnQg
bGVmdCA0IGRpZ2l0cyBmb3IgTk9fU1RPUF9CSVQgaW4NCj4gPiBSRU1PVEVfSTJDX1JFQUQgbWVz
c2FnZS4gTm90IDUgZGlnaXRzLg0KPiA+DQo+ID4gSW4gY3VycmVudCBjb2RlLCBOT19TVE9QX0JJ
VCBpcyBhbHdheXMgc2V0IHRvIHplcm8gd2hpY2ggbWVhbnMgSTJDDQo+ID4gbWFzdGVyIGlzIGFs
d2F5cyBnZW5lcmF0aW5nIGEgSTJDIHN0b3AgYXQgdGhlIGVuZCBvZiBlYWNoIEkyQyB3cml0ZQ0K
PiA+IHRyYW5zYWN0aW9uIHdoaWxlIGhhbmRsaW5nIFJFTU9URV9JMkNfUkVBRCBzaWRlYmFuZCBt
ZXNzYWdlLiBUaGlzDQo+ID4gaXNzdWUgbWlnaHQgaGF2ZSB0aGUgZ2VuZXJhdGVkIEkyQyBzaWdu
YWwgbm90IG1lZXRpbmcgdGhlIHJlcXVpcmVtZW50Lg0KPiA+IFRha2UgcmFuZG9tIHJlYWQgaW4g
STJDIGZvciBpbnN0YW5jZSwgSTJDIG1hc3RlciBzaG91bGQgZ2VuZXJhdGUgYQ0KPiA+IHJlcGVh
dCBzdGFydCB0byBzdGFydCB0byByZWFkIGRhdGEgYWZ0ZXIgd3JpdGluZyB0aGUgcmVhZCBhZGRy
ZXNzLg0KPiA+IFRoaXMgaXNzdWUgd2lsbCBjYXVzZSB0aGUgSTJDIG1hc3RlciB0byBnZW5lcmF0
ZSBhIHN0b3Atc3RhcnQgcmF0aGVyDQo+ID4gdGhhbiBhIHJlLXN0YXJ0IHdoaWNoIGlzIG5vdCBl
eHBlY3RlZCBpbiBJMkMgcmFuZG9tIHJlYWQuDQo+ID4NCj4gPiBbSG93XQ0KPiA+IENvcnJlY3Qg
dGhlIHNoaWZ0aW5nIHZhbHVlIG9mIE5PX1NUT1BfQklUIGZvciBEUF9SRU1PVEVfSTJDX1JFQUQg
Y2FzZQ0KPiA+IGluIGRybV9kcF9lbmNvZGVfc2lkZWJhbmRfcmVxKCkuDQo+ID4NCj4gPiBDaGFu
Z2VzIHNpbmNlDQo+ID4NCj4gdjE6KGh0dHBzOi8vbmFtMTEuc2FmZWxpbmtzLnByb3RlY3Rpb24u
b3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRg0KPiA+DQo+IHBhdGNod29yay5rZXJuZWwu
b3JnJTJGcGF0Y2glMkYxMTMxMjY2NyUyRiZhbXA7ZGF0YT0wMiU3QzAxJTdDdw0KPiBheW5lLmxp
DQo+ID4NCj4gbiU0MGFtZC5jb20lN0NlNDI5OWMxNzIxYmQ0YmNiNDg2NzA4ZDc5MDk4OTE0OCU3
QzNkZDg5NjFmZTQ4ODRlDQo+IDYwOGUxMWENCj4gPg0KPiA4MmQ5OTRlMTgzZCU3QzAlN0MwJTdD
NjM3MTM2ODU3MjcxMDY1NTQ5JmFtcDtzZGF0YT1lb3hpUm9qZmZCZXBZDQo+IFlvUWJqcA0KPiA+
IGo4YjZSJTJCa3dhT1FXQm9VJTJGdThsWTVnSVElM0QmYW1wO3Jlc2VydmVkPTApDQo+ID4gKiBB
ZGQgbW9yZSBkZXNjcmlwdGlvbnMgaW4gY29tbWl0IGFuZCBjYyB0byBzdGFibGUNCj4gPg0KPiA+
IEZpeGVzOiBhZDdmOGExZjljZSAoZHJtL2hlbHBlcjogYWRkIERpc3BsYXlwb3J0IG11bHRpLXN0
cmVhbSBoZWxwZXINCj4gPiAodjAuNikpDQo+ID4gUmV2aWV3ZWQtYnk6IEhhcnJ5IFdlbnRsYW5k
IDxoYXJyeS53ZW50bGFuZEBhbWQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFdheW5lIExpbiA8
V2F5bmUuTGluQGFtZC5jb20+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiAt
LS0NCj4gPiAgZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYyB8IDIgKy0NCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiA+
IGIvZHJpdmVycy9ncHUvZHJtL2RybV9kcF9tc3RfdG9wb2xvZ3kuYw0KPiA+IGluZGV4IDFjZjVm
OGI4YmJiOC4uOWQyNGM5OGJlY2UxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9k
cm1fZHBfbXN0X3RvcG9sb2d5LmMNCj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2RwX21z
dF90b3BvbG9neS5jDQo+ID4gQEAgLTM5Myw3ICszOTMsNyBAQCBkcm1fZHBfZW5jb2RlX3NpZGVi
YW5kX3JlcShjb25zdCBzdHJ1Y3QNCj4gPiBkcm1fZHBfc2lkZWJhbmRfbXNnX3JlcV9ib2R5ICpy
ZXEsDQo+ID4gIAkJCW1lbWNweSgmYnVmW2lkeF0sIHJlcS0NCj4gPiA+dS5pMmNfcmVhZC50cmFu
c2FjdGlvbnNbaV0uYnl0ZXMsIHJlcS0NCj4gPiA+dS5pMmNfcmVhZC50cmFuc2FjdGlvbnNbaV0u
bnVtX2J5dGVzKTsNCj4gPiAgCQkJaWR4ICs9IHJlcS0+dS5pMmNfcmVhZC50cmFuc2FjdGlvbnNb
aV0ubnVtX2J5dGVzOw0KPiA+DQo+ID4gLQkJCWJ1ZltpZHhdID0gKHJlcS0NCj4gPiA+dS5pMmNf
cmVhZC50cmFuc2FjdGlvbnNbaV0ubm9fc3RvcF9iaXQgJiAweDEpIDw8IDU7DQo+ID4gKwkJCWJ1
ZltpZHhdID0gKHJlcS0NCj4gPiA+dS5pMmNfcmVhZC50cmFuc2FjdGlvbnNbaV0ubm9fc3RvcF9i
aXQgJiAweDEpIDw8IDQ7DQo+ID4gIAkJCWJ1ZltpZHhdIHw9IChyZXEtDQo+ID4gPnUuaTJjX3Jl
YWQudHJhbnNhY3Rpb25zW2ldLmkyY190cmFuc2FjdGlvbl9kZWxheSAmIDB4Zik7DQo+ID4gIAkJ
CWlkeCsrOw0KPiA+ICAJCX0NCj4gLS0NCj4gQ2hlZXJzLA0KPiAJTHl1ZGUgUGF1bA0KLS0NCkJl
c3QgUmVnYXJkcywNCldheW5lIExpbg0K
