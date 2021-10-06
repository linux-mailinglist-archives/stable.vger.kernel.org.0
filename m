Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00432424426
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbhJFRad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:30:33 -0400
Received: from mail-bn8nam11on2122.outbound.protection.outlook.com ([40.107.236.122]:44384
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238485AbhJFRad (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 13:30:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHXp8mm5P5GPfy7KLHG5t36Dp2MvM9H39Z57vUTpA8SjUxRagJViMuALGOecCUyVHJ6t5BjgAydVNt/boSNqTvm1Od1Z3LUnOrJ/7J9N3SamswCEGDiBu4Qsc7hmOxcVB26ZAjkTDHrTH21OohDTWiDewf/YY/HhfC33krTCsaNXDh0u8wNLncMtB13o92TrTtO09CB+ThwtQE0kHRvknPk0orSXlyU5X1h4FFCLxkFuKP+L0lIPiU48qXHxHzHU48uSLc2mjrtSIJ3gE4CJcRUgj/y2VMBPCXF1v+vJbTg0wo1EDyZ+ea3Sk8Q8WKSNI9veGSwME07q2touL1dwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YesaSKdnz/beBqh3LUw48VowWISJ9tmstaEk9ot6qQg=;
 b=jK6iZ/FKIUXkBRNrRdCPiWy62xAJpL7vB3gDdGrPJUeNRuidcPqXnFICIqYqrmIhfIsDUo8dnsyI8d2d6iLVViO0FRFarhEuiLcrbFtbrfOMTg9RYj2qQMQmOXnkwCf7kOrosuqjGUvpTDf86+xIJ4t1HdvarGOM5rVa/NBhcJiqOkR3UEZoh1g8adc6JxZHH0mhdjY1PqxeXrHL1O1TG1RfuY/dKQYGR8MKDF09P6/8qzAOILlsQWGSjqERUsCmAmLMLIXy2TOFw1+ZHXT2lk9cbLTkccvjNpfnDkyXN66hw1GCIMG9azhgxPRJB21ZYFsYGnC3hbjeXDARqUFgiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YesaSKdnz/beBqh3LUw48VowWISJ9tmstaEk9ot6qQg=;
 b=KqZa9JMHNb8o8ynrB0oPZ8725fH3BuYR9W02NQ/Xap1zGoroTzWR60ziExEexV+nrCMOVmsSC03JQWqT3HrLtjhWXN/tg3n92vcVQ2o5OPLeYFUY2NEhcYqMDuMRBmAoTdH/quX0ZXdDbI3Ic/njrvxrf/cOT0BXfIKNXUMslpw=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB2037.namprd21.prod.outlook.com (2603:10b6:a03:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.3; Wed, 6 Oct
 2021 17:28:37 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac%9]) with mapi id 15.20.4608.004; Wed, 6 Oct 2021
 17:28:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     John Garry <john.garry@huawei.com>,
        Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
Thread-Topic: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
Thread-Index: AQHXustRTfLk3BqV10WJxd04SSykkavGLl8A
Date:   Wed, 6 Oct 2021 17:28:37 +0000
Message-ID: <BYAPR21MB1270BBC14D5F1AE69FC31A16BFB09@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211006070345.51713-1-decui@microsoft.com>
 <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
 <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
In-Reply-To: <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e46b62f6-a7c4-4481-99f3-734c79b3b587;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-06T16:48:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28eeefcb-2761-4b48-b897-08d988eebb51
x-ms-traffictypediagnostic: SJ0PR21MB2037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR21MB20370CB122C2E6C17EBAA205BFB09@SJ0PR21MB2037.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y3kxlyGfmMpUUC5w63BKx8A3SNqMH6Q7ZzqVPIZeIQhweiSurykwvflzoJV6ZnSfB4cgJRC8lRkxCn8GoDMSBaLQtziLGY/4t7a+fM5RQAnBapVXk32ECTNIAe0XraGOQPefFeFEsM63DaLVkl43nJYFFRQpaWihI/M4/Jzb/QHNjNGqii1p3YNIGbWiU98a3OQ7fE4hS+26thQNv8P0JmWyXHq5WvgMRlTATumqJZYU8RoavfYOCtN3KyDFPcm/ogTFE4ZPOWVYxhGZiz+IdiimFCgzHhYReK1Fk/e+X4OvLLPmtXyHGH+JO2SKsx8Le/bpUkgbDg1rSyzPo67wJ+8WOn+91zrLRboVxH2VCqm8psOpefYiSHHINSd87VUF8E3f01YbEzcrASkEjBQTyMw7el50cG8O9sRtid3nqA8dbegdE2+O/M4KfZzVu+hX0+qYBYwdRNo+ypZx007fDAf5V9KMb6cffcygxGGez8ayu5rth9z7UjXDdZ5aW9ADugm1Y4y/V3yUTNSdR+4On/3AU54ohwII19j16Qc94I5jboGcZY7+GAJDsEfyIOVAz/jv/UnXNzGUH0bdSnVqIHPc+EdxpODYZNoQdnHYzbwdQglQeMqqnVoKA5KZZTgd9+1wUIOxiAbJ8uvg/zvVEBvw+/mdoOxQCz37R7+qLHd0ZKOmQ+uk74+sdpzzdJCv0oAByn3WPM+SN0OX+8TmxoB3B4svni8OTnIuTxjuLA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(82950400001)(33656002)(82960400001)(921005)(86362001)(26005)(186003)(38070700005)(71200400001)(110136005)(316002)(66476007)(66556008)(76116006)(508600001)(66446008)(54906003)(5660300002)(8676002)(122000001)(4326008)(64756008)(10290500003)(6506007)(8990500004)(66946007)(55016002)(9686003)(2906002)(7696005)(7416002)(38100700002)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWh5cVBHdHdXWWQ1UHFVeUZxL3oyRUgyQ1p0UHZKbDNRYitxRWVSemhRRTlM?=
 =?utf-8?B?V3RWUFhWdkpzUkhGY0VTZUNxRWEwVEdMelBXYzNmSnp2eGVoalNvY2kxdFBn?=
 =?utf-8?B?NFNTQnJjM09TdGtpQm9wdEsxYUN4NGxPUCt2bDFvTHArTlNaUXpvRkVpSlVa?=
 =?utf-8?B?THhYZHBEUlBEVVN6eFk5VVovaEQ1WXM2dHg5M2RuNUhhOXdwUURlS1FBNE9j?=
 =?utf-8?B?V3ViUVNRQjRlMzI4R0MrMGcvQU1RRFMxVXE3K2R2dG81MUh0ak16S2FsalZL?=
 =?utf-8?B?U3FIWWFmbTdIQzdxL1hhalBjdTJ2UTBXZXQ4b0x5cmorYmg2cUcxU1Z1R2xj?=
 =?utf-8?B?OGZ5MWhhV0JsUUhkRHNQZURsOVgzZGg4M25lSDFKZStod0dKYTNKcWljbkFS?=
 =?utf-8?B?TVEvQnhpV2pUcE95bFJFQzNuZkE0aExrdUR4VEI0WjlMa2tEbEhjOWhDVVVs?=
 =?utf-8?B?ajJQVUh6RVBSck15aksxQ29nMXI3MS9IcGo1VUlWU1FWOHdubGNzK0VWMzNN?=
 =?utf-8?B?NEpuMWhlRlovdzd1WkhNUTBtUnRTd1VXTjladVI1aWYxR2NpcGlzWmlWTWFr?=
 =?utf-8?B?aVA2ZGkxTTVEMS9iMHMzWVpjQVJnQ0QrSituL1FXZlFwV2V5QmVybFZGSHNB?=
 =?utf-8?B?YWdxaTlyWE5xbjdKOHU1bWZZZUhXUWpuMkU0SVE2QTl4N3hFV29zTGxxM3Fy?=
 =?utf-8?B?ZS83ZGRiWDdDWnRPYlRRWW05WWx2VE5lZ0libmxiVVQxc0oyT1ZOU25XUWN1?=
 =?utf-8?B?MFh6c0pJU2NPTlpnNkdyVCsvaEpPMDRDMjBoSDZMNnJJM1kyUDdxSmQya0xE?=
 =?utf-8?B?SitpKzdQM3o1L2tGb0c5ZFVDWUc1MkgzOHdOZlQ1R0RVbTVNRlNkZVUzYWV6?=
 =?utf-8?B?d1JWTVlYeFI4NXpPc0NxZzJWKzJ3VlVBWWlIV3kyRU56OVhUVGFLQ0lYenpS?=
 =?utf-8?B?YzNRakJPNjhvMnpkclNJeVFRMjhneUZSQ0Y3amRXQjJjK0Rick1RRGdsaXow?=
 =?utf-8?B?aHM1SU1OL0paczIrTE9oaVV4K3pBWjdlaHBsdGRqRlpvU2hOTUUrTUUraDJw?=
 =?utf-8?B?aGF1bk81QlVhOXVBVlE1ZTN5azh3UkN0c0NIa2I1QlJQMEZHcHQvZ2RCMndz?=
 =?utf-8?B?ZElDWXRqc09xbmJXazRUWGlsbU84c0FmSHNMU240aEZ3Nk52QzNtc1VZb2Rm?=
 =?utf-8?B?Mi9xKzRNZytsdEk2eFZkUUE4emZyMDRXMkVpamhWTXFDNEVoc05lMTk3amZT?=
 =?utf-8?B?ZmpCRjU2NVBHRTVRYUczT2RobHlYeXc3WVRDQWZ0MjRudC90NUV1NUd5Z3hD?=
 =?utf-8?B?QTlhQnlzd0FKRldhdDMwQzR5N0lxbVlqU0xUMWNaUk5TRlp0Mi9GM2lRcUZQ?=
 =?utf-8?B?TkkzQ01GZGgzcFBURkg1MXdsUFhrVHA0aDFsUU9qa0Y5RVRrTjRUNXo5N1Nl?=
 =?utf-8?B?MDFvTmY3ZFVxSkJxRXZxWkp6Mmt5V3U2TEpSMFZDeHFvaWxqMFFMZTlBTkZT?=
 =?utf-8?B?alptejZYRUVpcVJEWXlQbjBpNmdVUFp3Z0VUajZsYi8xZW1WaU9OMlVsdXBF?=
 =?utf-8?B?Q0lBWXVHZm1QUGZ6K0RQaFFDN0tMb1lZQjBjbWZtWXh4a0FSQ1J6TGd0RW1S?=
 =?utf-8?B?Zm5lKzRnczFIdlo2TElLd3NlRC9yQWZ1NkYzZ1Y1WUo3Qk4vWkR5cWJyZi9G?=
 =?utf-8?B?Y29XbHU3N3cxSDNab2h4cmR0Z2o2TjJJcDF6WVRQcWo0Mnd2VGE3Uk11aXZl?=
 =?utf-8?Q?nKuDisWJ6e8ruBGV0oRxtaEbBv9Ex/7rDT1Jmtz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28eeefcb-2761-4b48-b897-08d988eebb51
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 17:28:37.4205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UA0n2ocnAThGRqVnqzOJe2kQGfO67YT3KI/6J3QC9eRRPeW97Yqr1z46xe7gaUwNBTlcYZRtEw87RGUYNdprAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2037
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmdhcnJ5QGh1YXdlaS5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgT2N0b2JlciA2LCAyMDIxIDk6MDMgQU0NCj4gPj4gLi4uDQo+ID4+PiArCWlmIChzY3Np
X2RyaXZlci5jYW5fcXVldWUgPiBTSFJUX01BWCkNCj4gPj4+ICsJCXNjc2lfZHJpdmVyLmNhbl9x
dWV1ZSA9IFNIUlRfTUFYOw0KPiA+Pj4gKw0KPiA+DQo+ID4gVGhpcyBmaXggd29ya3MsIGJ1dCBp
cyBhIG1vcmUgb2YgYSB0ZW1wb3JhcnkgaGFjayB1bnRpbCBJIGNhbiBmaW5pc2gNCj4gPiBhIGxh
cmdlciBvdmVyaGF1bCBvZiB0aGUgYWxnb3JpdGhtLg0KPiANCj4gPiBCdXQgZm9yIG5vdywgSSB0
aGluayB0aGUgYmV0dGVyDQo+ID4gZml4IGlzIGZvciBlYTJmMGY3NzUzOGMgdG8gZG8gdGhlIGNv
bXBhcmlzb24gYXMgImludCIgaW5zdGVhZCBvZiAic2hvcnQiLg0KPiA+DQo+IA0KPiBUaGF0IHNl
ZW1zIGJldHRlciB0byBtZS4gQnV0IExldCdzIHdhaXQgZm9yIG90aGVyIHBvc3NpYmxlIG9waW5p
b24uDQo+IA0KPiBUaGFua3MsDQo+IEpvaG4NCg0KSXQgbG9va3MgbGlrZSBzaG9zdC0+Y21kX3Bl
cl9sdW4gaGFzIGJlZW4gInNob3J0IiBzaW5jZSBkYXkgMS4NCkkgZG9uJ3Qga25vdyB3aGV0aGVy
IGl0IHNob3VsZCBiZSBjaGFuZ2VkIHRvIHVuc2lnbmVkIGludC4NCg0KVGhhbmtzIGZvciB0aGUg
dGhvdWdodHMhIEknbGwgcG9zdCBhIHYyIGxpa2UgdGhlIGJlbG93IGluIDI0IGhvdXJzLg0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2hvc3RzLmMgYi9kcml2ZXJzL3Njc2kvaG9zdHMuYw0K
aW5kZXggM2Y2ZjE0ZjBjYWZiLi4yNGI3MmVlNDI0NmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvaG9zdHMuYw0KKysrIGIvZHJpdmVycy9zY3NpL2hvc3RzLmMNCkBAIC0yMjAsNyArMjIwLDgg
QEAgaW50IHNjc2lfYWRkX2hvc3Rfd2l0aF9kbWEoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QsIHN0
cnVjdCBkZXZpY2UgKmRldiwNCiAgICAgICAgICAgICAgICBnb3RvIGZhaWw7DQogICAgICAgIH0N
Cg0KLSAgICAgICBzaG9zdC0+Y21kX3Blcl9sdW4gPSBtaW5fdChzaG9ydCwgc2hvc3QtPmNtZF9w
ZXJfbHVuLA0KKyAgICAgICAvKiBVc2UgbWluX3QoaW50LCAuLi4pIGluIGNhc2Ugc2hvc3QtPmNh
bl9xdWV1ZSBleGNlZWRzIFNIUlRfTUFYICovDQorICAgICAgIHNob3N0LT5jbWRfcGVyX2x1biA9
IG1pbl90KGludCwgc2hvc3QtPmNtZF9wZXJfbHVuLA0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzaG9zdC0+Y2FuX3F1ZXVlKTsNCg0KICAgICAgICBlcnJvciA9IHNjc2lfaW5p
dF9zZW5zZV9jYWNoZShzaG9zdCkNCg==
