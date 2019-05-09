Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C531935D
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfEIU2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 16:28:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726715AbfEIU2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 16:28:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49KLRcF017514;
        Thu, 9 May 2019 13:28:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=VNMivec6S5r3BtH95kxfXhH6gyUb/FyKeg0DAFVpzjQ=;
 b=vk1ft51tquUkJFZ70VaKEtMHEv8fXyKEXHVX35Hmbvk5M0bG1H6Y0Obageewx+/Huua7
 T4Fn1WGr/Agy3iznkhrbFPCad0X+vnnpbwbs5/FrLiDt9BjracmmpzUAe5p+/wG8at4c
 TlOGM7sCyZG3IdvQ9cLaHqjWptDht515yxCYOgSceukfeZxZkvNBikBx/ov6Sq1tr279
 jUegS7eEgmjHhJWaVFkS83ZkU4EcCYo1NqwZlHbFYfAElAUw/QPblUlZtAZQiPQ8xE1q
 6Ks+tgG3AhKrBzdsdM5RQgMKPTv6RY7g1+XOAEhkSMCDIQXnOb+rz+JiI8eS+RIWGCpp EQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2scn0ca6jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 May 2019 13:28:35 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 9 May
 2019 13:28:35 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 9 May 2019 13:28:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNMivec6S5r3BtH95kxfXhH6gyUb/FyKeg0DAFVpzjQ=;
 b=OQxb4C7kI9j/NUOwC3/egn3X71MK2r/zbTa2IOv1zHosy0onSRmRjGWwhzLIBGiZnDJje7a5dQEVtYL+bwQZ3X/J6UGnVVXjWx3zN6/W5qQ9e1au+upWclxxRSjKICDcwEVvIe8Vy6NZAUsEqDKtYA4hhg754eZAEbP9wHBRoO4=
Received: from MWHPR18MB1552.namprd18.prod.outlook.com (10.173.243.146) by
 MWHPR18MB1438.namprd18.prod.outlook.com (10.175.7.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Thu, 9 May 2019 20:28:30 +0000
Received: from MWHPR18MB1552.namprd18.prod.outlook.com
 ([fe80::604b:87ea:ded:96fa]) by MWHPR18MB1552.namprd18.prod.outlook.com
 ([fe80::604b:87ea:ded:96fa%4]) with mapi id 15.20.1856.012; Thu, 9 May 2019
 20:28:30 +0000
From:   Quoc Tran <qtran@marvell.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [EXT] [PATCH 4.19 60/66] scsi: qla2xxx: Fix device staying in
 blocked state
Thread-Topic: [EXT] [PATCH 4.19 60/66] scsi: qla2xxx: Fix device staying in
 blocked state
Thread-Index: AQHVBpfuC67+UZa+jkGwf/xMDjodcqZjO0XQ
Date:   Thu, 9 May 2019 20:28:29 +0000
Message-ID: <MWHPR18MB1552A7E447C11875F5FDD31FA0330@MWHPR18MB1552.namprd18.prod.outlook.com>
References: <20190509181301.719249738@linuxfoundation.org>
 <20190509181307.754166157@linuxfoundation.org>
In-Reply-To: <20190509181307.754166157@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28fa3f7c-04d3-4714-e86f-08d6d4bce636
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR18MB1438;
x-ms-traffictypediagnostic: MWHPR18MB1438:
x-microsoft-antispam-prvs: <MWHPR18MB14381A795F84F9466021A1A1A0330@MWHPR18MB1438.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(366004)(199004)(189003)(53754006)(13464003)(66066001)(5660300002)(76116006)(4326008)(64756008)(8676002)(256004)(8936002)(81156014)(81166006)(73956011)(33656002)(2906002)(2501003)(14444005)(71200400001)(71190400001)(3846002)(6116002)(305945005)(74316002)(76176011)(99286004)(7736002)(86362001)(68736007)(6436002)(7696005)(66556008)(66446008)(110136005)(25786009)(66946007)(52536014)(66476007)(229853002)(316002)(478600001)(15650500001)(55016002)(102836004)(53546011)(6506007)(6246003)(9686003)(26005)(53936002)(14454004)(54906003)(486006)(6636002)(476003)(186003)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR18MB1438;H:MWHPR18MB1552.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t2kZiEpWoVO3u/V7IHXcWcJ5AFC0PNXA//ENCvO1lKKj0ilT9eYsQM37/+SIjj4YO6gzdOwbdWJx8H599AmxavfTZ0V1RMdtM944gPwKye40qjPFSCKkkygO2BCSjvjImcPINQpuNuZ+PUKyOF/CiI1L7WctZQRv66bPyE6mZi47bc+rt6EVUyHmeIPppPYdfY2FCelUHhrB2GMnIp/qEB/MfV5skxI+63aR2QXQok3BRyaHoKjzSH/+ZBRSD1htD+mWCyLaTSChT0ZP5MQZXSaVac3TUOTCAMr3Hqb/N447auggSf4G+DPhrS/LeRIE9pg/alnnI21xIFEGrSnOa0Rmus6lMaLGBRoeDsfcGpEVMlZXKmx+MXPqW9TIBnu1N4EXXYgC5Z62KiblbEMVxK8Iiu5lXlzWmI0srM/HWlA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fa3f7c-04d3-4714-e86f-08d6d4bce636
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 20:28:29.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1438
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQWxsLA0KDQpQbGVhc2UsIHJlbW92ZSBRdW9jIFRyYW4gKHF0cmFuQG1hcnZlbGwuY29tKSBm
cm9tIHRoaXMgZW1haWwuICBJIHRoaW5rIHRoZSBjb3JyZWN0IGNvbnRhY3QgaXMgUXVpbm4gVHJh
biAocXV0cmFuQG1hcnZlbGwuY29tKQ0KDQpUaGFua3MNClF1b2MNCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+IA0KU2VudDogVGh1cnNkYXksIE1heSA5LCAyMDE5IDExOjQzIEFNDQpUbzogbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KQ2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBRdW9jIFRyYW4g
PHF0cmFuQG1hcnZlbGwuY29tPjsgSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5j
b20+OyBFd2FuIEQuIE1pbG5lIDxlbWlsbmVAcmVkaGF0LmNvbT47IE1hcnRpbiBLLiBQZXRlcnNl
biA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+DQpTdWJqZWN0OiBbRVhUXSBbUEFUQ0ggNC4x
OSA2MC82Nl0gc2NzaTogcWxhMnh4eDogRml4IGRldmljZSBzdGF5aW5nIGluIGJsb2NrZWQgc3Rh
dGUNCg0KRXh0ZXJuYWwgRW1haWwNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KRnJvbTogUXVpbm4gVHJhbiA8
cXRyYW5AbWFydmVsbC5jb20+DQoNCmNvbW1pdCAyMTM3NDkwZjIxNDdhOGQwNzk5YjcyYjlhMTAy
M2VmYjAxMmQ0MGM3IHVwc3RyZWFtLg0KDQpUaGlzIHBhdGNoIGZpeGVzIGlzc3VlIHJlcG9ydGVk
IGJ5IHNvbWUgb2YgdGhlIGN1c3RvbWVycywgd2hvIGRpc2NvdmVyZWQgdGhhdCBhZnRlciBjYWJs
ZSBwdWxsIHNjZW5hcmlvIHRoZSBkZXZpY2VzIGRpc2FwcGVhciBhbmQgcGF0aCBzZWVtcyB0byBy
ZW1haW4gaW4gYmxvY2tlZCBzdGF0ZS4gT25jZSB0aGUgZGV2aWNlIHJlYXBwZWFycywgZHJpdmVy
IGRvZXMgbm90IHNlZW0gdG8gdXBkYXRlIHBhdGggdG8gb25saW5lLiBUaGlzIGlzc3VlIGFwcGVh
cnMgYmVjYXVzZSBvZiB0aGUgZGVmZXIgZmxhZyBjcmVhdGluZyByYWNlIGNvbmRpdGlvbiB3aGVy
ZSB0aGUgc2FtZSBzZXNzaW9uIHJlYXBwZWFycy4gIFRoaXMgcGF0Y2ggZml4ZXMgdGhpcyBpc3N1
ZSBieSBpbmRpY2F0aW5nIFNDU0ktTUwgb2YgZGV2aWNlIGxvc3Qgd2hlbg0KcWx0X2ZyZWVfc2Vz
c2lvbl9kb25lKCkgaXMgY2FsbGVkIGZyb20gcWx0X3VucmVnX3Nlc3MoKS4NCg0KRml4ZXM6IDQx
ZGM1MjlhNDYwMmEgKCJxbGEyeHh4OiBJbXByb3ZlIFJTQ04gaGFuZGxpbmcgaW4gZHJpdmVyIikN
ClNpZ25lZC1vZmYtYnk6IFF1aW5uIFRyYW4gPHF0cmFuQG1hcnZlbGwuY29tPg0KQ2M6IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcgIzQuMTkNClNpZ25lZC1vZmYtYnk6IEhpbWFuc2h1IE1hZGhhbmkg
PGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KUmV2aWV3ZWQtYnk6IEV3YW4gRC4gTWlsbmUgPGVtaWxu
ZUByZWRoYXQuY29tPg0KU2lnbmVkLW9mZi1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbT4NClNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8
Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQoNCi0tLQ0KIGRyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV90YXJnZXQuYyB8ICAgIDQgKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQoNCi0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJn
ZXQuYw0KKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jDQpAQCAtOTgxLDYg
Kzk4MSw4IEBAIHZvaWQgcWx0X2ZyZWVfc2Vzc2lvbl9kb25lKHN0cnVjdCB3b3JrX3MNCiAJCXNl
c3MtPnNlbmRfZWxzX2xvZ28pOw0KIA0KIAlpZiAoIUlTX1NXX1JFU1ZfQUREUihzZXNzLT5kX2lk
KSkgew0KKwkJcWxhMngwMF9tYXJrX2RldmljZV9sb3N0KHZoYSwgc2VzcywgMCwgMCk7DQorDQog
CQlpZiAoc2Vzcy0+c2VuZF9lbHNfbG9nbykgew0KIAkJCXFsdF9wb3J0X2xvZ29fdCBsb2dvOw0K
IA0KQEAgLTExNjEsOCArMTE2Myw2IEBAIHZvaWQgcWx0X3VucmVnX3Nlc3Moc3RydWN0IGZjX3Bv
cnQgKnNlc3MNCiAJaWYgKHNlc3MtPnNlX3Nlc3MpDQogCQl2aGEtPmh3LT50Z3QudGd0X29wcy0+
Y2xlYXJfbmFjbF9mcm9tX2ZjcG9ydF9tYXAoc2Vzcyk7DQogDQotCXFsYTJ4MDBfbWFya19kZXZp
Y2VfbG9zdCh2aGEsIHNlc3MsIDAsIDApOw0KLQ0KIAlzZXNzLT5kZWxldGVkID0gUUxBX1NFU1Nf
REVMRVRJT05fSU5fUFJPR1JFU1M7DQogCXNlc3MtPmRpc2Nfc3RhdGUgPSBEU0NfREVMRVRFX1BF
TkQ7DQogCXNlc3MtPmxhc3RfcnNjbl9nZW4gPSBzZXNzLT5yc2NuX2dlbjsNCg0KDQo=
