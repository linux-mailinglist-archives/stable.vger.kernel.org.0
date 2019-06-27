Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20124583D7
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF0Nvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 09:51:31 -0400
Received: from mx0b-00328301.pphosted.com ([148.163.141.47]:30704 "EHLO
        mx0b-00328301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbfF0Nva (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 09:51:30 -0400
X-Greylist: delayed 1892 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2019 09:51:29 EDT
Received: from pps.filterd (m0156136.ppops.net [127.0.0.1])
        by mx0b-00328301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x5RDJvCw014932;
        Thu, 27 Jun 2019 06:19:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt1; bh=HgtP1RXkEGsA1aI9a7Puj0bHIr9+t2NSCo6mWXp6X6Q=;
 b=qGOOpxuWHo5jQQk3OBBQq+MpISde4CbL9WiKqLdp95cbH4thktikVTdesSNEEd7tDzIr
 usZRQh+FxpPSp0SZJ56kQHUybqYvCTgMAd9swqDykE0QfXXsqqlyGpIOpSoH1qEzGf+y
 sduzcnoh6VuOGzd5nAUv0bjxb3lF5UvzDb+0lpjNiwGp56IKUgXU9STFOmcYbLBbr8ES
 0DeWGhks1RQevU6mvAQcWCn4tXxgVQ3aTR9BnrO7DJzoS0SBOJcQztqeC0vdpeOiYCQ1
 PM84fshps85Ed/xskIic1cltm4jiF6r52f5Az3ZjuM8sMtbRkXHAutfujVEPxqyKQyz8 Lg== 
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by mx0b-00328301.pphosted.com with ESMTP id 2tcaturf67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 06:19:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector1-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgtP1RXkEGsA1aI9a7Puj0bHIr9+t2NSCo6mWXp6X6Q=;
 b=C2x3gjnuwhgFtqSxydq1gIRpU9fL7ZitO+JPyix4EY8ePaJKoaO2Lp2+dvlB1la/jS1Jhw1J2+6IhCGK/grFugTedlEVlyS+h+SLCixhMqZQ3z1neNPB2Fy5NGErLS69cN11Cg1rwrKGPRsrYF3uxxMgh/CtkcTvspXuc3qpFBQ=
Received: from MN2PR12MB3373.namprd12.prod.outlook.com (20.178.242.33) by
 MN2PR12MB3550.namprd12.prod.outlook.com (20.179.84.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 13:19:53 +0000
Received: from MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::f5e0:d455:c8e0:4c13]) by MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::f5e0:d455:c8e0:4c13%5]) with mapi id 15.20.2008.017; Thu, 27 Jun 2019
 13:19:53 +0000
From:   Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
To:     "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Subject: [PATCH v2] iio: imu: mpu6050: add missing available scan masks
Thread-Topic: [PATCH v2] iio: imu: mpu6050: add missing available scan masks
Thread-Index: AQHVLOsB+Bohq3cjZUigraO6Qp/HnA==
Date:   Thu, 27 Jun 2019 13:19:53 +0000
Message-ID: <20190627131918.19619-1-jmaneyrol@invensense.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB7PR05CA0054.eurprd05.prod.outlook.com
 (2603:10a6:10:2e::31) To MN2PR12MB3373.namprd12.prod.outlook.com
 (2603:10b6:208:c8::33)
x-originating-ip: [77.157.193.39]
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1df100a-113d-4343-b58d-08d6fb022406
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR12MB3550;
x-ms-traffictypediagnostic: MN2PR12MB3550:
x-microsoft-antispam-prvs: <MN2PR12MB355097C3E52E7B4162C3C207C4FD0@MN2PR12MB3550.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(199004)(189003)(50226002)(6116002)(3846002)(99286004)(52116002)(8936002)(2906002)(316002)(7736002)(305945005)(54906003)(8676002)(68736007)(2351001)(81156014)(81166006)(72206003)(36756003)(478600001)(5640700003)(6436002)(107886003)(6486002)(53936002)(6512007)(14454004)(2501003)(25786009)(386003)(186003)(80792005)(476003)(2616005)(6506007)(66066001)(4326008)(450100002)(26005)(6916009)(486006)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(1076003)(86362001)(73956011)(102836004)(71200400001)(71190400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3550;H:MN2PR12MB3373.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: invensense.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FixhnTNOa6EAteqeBSEwNrc6Andgtr8n93iT5lWoKjlGbGiZpWe8oKsnPVEZt4Pag3Le2zRAaRes/x0pWdw7BCwI/P0et/LwTt5bvCuocGPQSbgTLDSh6uNvwMpGwIqfTjOqJ+kQJv3gLNYsOFVJVJYikdKqMvyxUx4a7b/z5uc2K9QBXOBfmTxc0ZJV2XijHMLe6ImlKo7sM9su45bPEGJTZfG+a6PhPfcKtA/AowZ8hiRfVjiyPvpeTGyGXLhg1Dhq1TxOlOoVz9KPtLa9NHfXiUlJzCxlPI1S1WaDd6Ga8U/0Q/AiDLVlZzRPR74cie7mFJ2l/L/9NSILA4na2/mrkv28ID1gztM5UIAjsrhvyT8pLmBDJNaNegvEGOHFe8eSAPf1OyW8VKoi9C8cKJF5OV4bLItTIauYe3aA47A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1df100a-113d-4343-b58d-08d6fb022406
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 13:19:53.5178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JManeyrol@invensense.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-06-27_07:2019-06-25,2019-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1904300001 definitions=main-1906270156
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RHJpdmVyIG9ubHkgc3VwcG9ydHMgMy1heGlzIGd5cm8gYW5kL29yIDMtYXhpcyBhY2NlbC4NCkZv
ciBpY20yMDYwMiwgdGVtcCBkYXRhIGlzIG1hbmRhdG9yeSBmb3IgYWxsIGNvbmZpZ3VyYXRpb25z
Lg0KDQpGaXggYWxsIHNpbmdsZSBhbmQgZG91YmxlIGF4aXMgY29uZmlndXJhdGlvbnMgKGFsbW9z
dCBuZXZlciB1c2VkKSBhbmQgbW9yZQ0KaW1wb3J0YW50bHkgZml4IDMtYXhpcyBneXJvIGFuZCA2
LWF4aXMgYWNjZWwrZ3lybyBidWZmZXIgb24gaWNtMjA2MDIgd2hlbg0KdGVtcCBkYXRhIGlzIG5v
dCBlbmFibGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBKZWFuLUJhcHRpc3RlIE1hbmV5cm9sIDxqbWFu
ZXlyb2xAaW52ZW5zZW5zZS5jb20+DQpGaXhlczogMTYxNWZlNDFhMTk1ICgiaWlvOiBpbXU6IG1w
dTYwNTA6IEZpeCBGSUZPIGxheW91dCBmb3IgSUNNMjA2MDIiKQ0KLS0tDQpDaGFuZ2VzIGluIHYy
Og0KICAtIFVzZSBtb3JlIGV4cGxpY2l0IHNjYW4gZGVmaW5lcyBmb3IgbWFza3MNCg0KIGRyaXZl
cnMvaWlvL2ltdS9pbnZfbXB1NjA1MC9pbnZfbXB1X2NvcmUuYyB8IDQzICsrKysrKysrKysrKysr
KysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9paW8vaW11L2ludl9tcHU2MDUwL2ludl9tcHVfY29yZS5jIGIvZHJpdmVycy9p
aW8vaW11L2ludl9tcHU2MDUwL2ludl9tcHVfY29yZS5jDQppbmRleCAzODVmMTRhNGQ1YTcuLjY2
NjI5YzNhZGMyMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaWlvL2ltdS9pbnZfbXB1NjA1MC9pbnZf
bXB1X2NvcmUuYw0KKysrIGIvZHJpdmVycy9paW8vaW11L2ludl9tcHU2MDUwL2ludl9tcHVfY29y
ZS5jDQpAQCAtODUxLDYgKzg1MSwyNSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGlpb19jaGFuX3Nw
ZWMgaW52X21wdV9jaGFubmVsc1tdID0gew0KIAlJTlZfTVBVNjA1MF9DSEFOKElJT19BQ0NFTCwg
SUlPX01PRF9aLCBJTlZfTVBVNjA1MF9TQ0FOX0FDQ0xfWiksDQogfTsNCiANCitzdGF0aWMgY29u
c3QgdW5zaWduZWQgbG9uZyBpbnZfbXB1X3NjYW5fbWFza3NbXSA9IHsNCisJLyogMy1heGlzIGFj
Y2VsICovDQorCUJJVChJTlZfTVBVNjA1MF9TQ0FOX0FDQ0xfWCkNCisJCXwgQklUKElOVl9NUFU2
MDUwX1NDQU5fQUNDTF9ZKQ0KKwkJfCBCSVQoSU5WX01QVTYwNTBfU0NBTl9BQ0NMX1opLA0KKwkv
KiAzLWF4aXMgZ3lybyAqLw0KKwlCSVQoSU5WX01QVTYwNTBfU0NBTl9HWVJPX1gpDQorCQl8IEJJ
VChJTlZfTVBVNjA1MF9TQ0FOX0dZUk9fWSkNCisJCXwgQklUKElOVl9NUFU2MDUwX1NDQU5fR1lS
T19aKSwNCisJLyogNi1heGlzIGFjY2VsICsgZ3lybyAqLw0KKwlCSVQoSU5WX01QVTYwNTBfU0NB
Tl9BQ0NMX1gpDQorCQl8IEJJVChJTlZfTVBVNjA1MF9TQ0FOX0FDQ0xfWSkNCisJCXwgQklUKElO
Vl9NUFU2MDUwX1NDQU5fQUNDTF9aKQ0KKwkJfCBCSVQoSU5WX01QVTYwNTBfU0NBTl9HWVJPX1gp
DQorCQl8IEJJVChJTlZfTVBVNjA1MF9TQ0FOX0dZUk9fWSkNCisJCXwgQklUKElOVl9NUFU2MDUw
X1NDQU5fR1lST19aKSwNCisJMCwNCit9Ow0KKw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaWlvX2No
YW5fc3BlYyBpbnZfaWNtMjA2MDJfY2hhbm5lbHNbXSA9IHsNCiAJSUlPX0NIQU5fU09GVF9USU1F
U1RBTVAoSU5WX0lDTTIwNjAyX1NDQU5fVElNRVNUQU1QKSwNCiAJew0KQEAgLTg3Nyw2ICs4OTYs
MjggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpaW9fY2hhbl9zcGVjIGludl9pY20yMDYwMl9jaGFu
bmVsc1tdID0gew0KIAlJTlZfTVBVNjA1MF9DSEFOKElJT19BQ0NFTCwgSUlPX01PRF9aLCBJTlZf
SUNNMjA2MDJfU0NBTl9BQ0NMX1opLA0KIH07DQogDQorc3RhdGljIGNvbnN0IHVuc2lnbmVkIGxv
bmcgaW52X2ljbTIwNjAyX3NjYW5fbWFza3NbXSA9IHsNCisJLyogMy1heGlzIGFjY2VsICsgdGVt
cCAobWFuZGF0b3J5KSAqLw0KKwlCSVQoSU5WX0lDTTIwNjAyX1NDQU5fQUNDTF9YKQ0KKwkJfCBC
SVQoSU5WX0lDTTIwNjAyX1NDQU5fQUNDTF9ZKQ0KKwkJfCBCSVQoSU5WX0lDTTIwNjAyX1NDQU5f
QUNDTF9aKQ0KKwkJfCBCSVQoSU5WX0lDTTIwNjAyX1NDQU5fVEVNUCksDQorCS8qIDMtYXhpcyBn
eXJvICsgdGVtcCAobWFuZGF0b3J5KSAqLw0KKwlCSVQoSU5WX0lDTTIwNjAyX1NDQU5fR1lST19Y
KQ0KKwkJfCBCSVQoSU5WX0lDTTIwNjAyX1NDQU5fR1lST19ZKQ0KKwkJfCBCSVQoSU5WX0lDTTIw
NjAyX1NDQU5fR1lST19aKQ0KKwkJfCBCSVQoSU5WX0lDTTIwNjAyX1NDQU5fVEVNUCksDQorCS8q
IDYtYXhpcyBhY2NlbCArIGd5cm8gKyB0ZW1wIChtYW5kYXRvcnkpICovDQorCUJJVChJTlZfSUNN
MjA2MDJfU0NBTl9BQ0NMX1gpDQorCQl8IEJJVChJTlZfSUNNMjA2MDJfU0NBTl9BQ0NMX1kpDQor
CQl8IEJJVChJTlZfSUNNMjA2MDJfU0NBTl9BQ0NMX1opDQorCQl8IEJJVChJTlZfSUNNMjA2MDJf
U0NBTl9HWVJPX1gpDQorCQl8IEJJVChJTlZfSUNNMjA2MDJfU0NBTl9HWVJPX1kpDQorCQl8IEJJ
VChJTlZfSUNNMjA2MDJfU0NBTl9HWVJPX1opDQorCQl8IEJJVChJTlZfSUNNMjA2MDJfU0NBTl9U
RU1QKSwNCisJMCwNCit9Ow0KKw0KIC8qDQogICogVGhlIHVzZXIgY2FuIGNob29zZSBhbnkgZnJl
cXVlbmN5IGJldHdlZW4gSU5WX01QVTYwNTBfTUlOX0ZJRk9fUkFURSBhbmQNCiAgKiBJTlZfTVBV
NjA1MF9NQVhfRklGT19SQVRFLCBidXQgb25seSB0aGVzZSBmcmVxdWVuY2llcyBhcmUgbWF0Y2hl
ZCBieSB0aGUNCkBAIC0xMTM2LDkgKzExNzcsMTEgQEAgaW50IGludl9tcHVfY29yZV9wcm9iZShz
dHJ1Y3QgcmVnbWFwICpyZWdtYXAsIGludCBpcnEsIGNvbnN0IGNoYXIgKm5hbWUsDQogCWlmIChj
aGlwX3R5cGUgPT0gSU5WX0lDTTIwNjAyKSB7DQogCQlpbmRpb19kZXYtPmNoYW5uZWxzID0gaW52
X2ljbTIwNjAyX2NoYW5uZWxzOw0KIAkJaW5kaW9fZGV2LT5udW1fY2hhbm5lbHMgPSBBUlJBWV9T
SVpFKGludl9pY20yMDYwMl9jaGFubmVscyk7DQorCQlpbmRpb19kZXYtPmF2YWlsYWJsZV9zY2Fu
X21hc2tzID0gaW52X2ljbTIwNjAyX3NjYW5fbWFza3M7DQogCX0gZWxzZSB7DQogCQlpbmRpb19k
ZXYtPmNoYW5uZWxzID0gaW52X21wdV9jaGFubmVsczsNCiAJCWluZGlvX2Rldi0+bnVtX2NoYW5u
ZWxzID0gQVJSQVlfU0laRShpbnZfbXB1X2NoYW5uZWxzKTsNCisJCWluZGlvX2Rldi0+YXZhaWxh
YmxlX3NjYW5fbWFza3MgPSBpbnZfbXB1X3NjYW5fbWFza3M7DQogCX0NCiANCiAJaW5kaW9fZGV2
LT5pbmZvID0gJm1wdV9pbmZvOw0KLS0gDQoyLjE3LjENCg0K
