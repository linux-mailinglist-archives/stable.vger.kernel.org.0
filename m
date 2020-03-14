Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF11853FA
	for <lists+stable@lfdr.de>; Sat, 14 Mar 2020 03:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCNCZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 22:25:56 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:51374 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726414AbgCNCZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 22:25:56 -0400
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E2PqDo012517;
        Sat, 14 Mar 2020 02:25:52 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0b-002e3701.pphosted.com with ESMTP id 2yrpcu80t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Mar 2020 02:25:52 +0000
Received: from G2W6310.americas.hpqcorp.net (g2w6310.austin.hp.com [16.197.64.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 410AA54;
        Sat, 14 Mar 2020 02:25:19 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
 G2W6310.americas.hpqcorp.net (2002:10c5:4034::10c5:4034) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Sat, 14 Mar 2020 02:25:19 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (15.241.52.12) by
 G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Sat, 14 Mar 2020 02:25:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndB8XQwg0mI1aOBG48c4kuE5RtBKr2XmkXlQfk9MVrqCTlYvEoRim7vC2iArJ/QL4VUye1uwd0G9rXdcDvgD/JeK31Set3On1V39B8pIt/U3UCn/MxKDeydTP2sYduNhOCP96GW3hWCiWeUKw5Etk+/bGPI6DBULywy5dJJErwV4J69MEuZxcPbqDBsn7LNvTJIkr0tADHYwFHfeZFC3NY701YWd9ODgLJz7a9lhW57UHFqym0JHDddwr4cTIrxhbDAasJFRdjBPTS0bfpFXC3MguAzu6+jEuok+BpdhHLylngdguF1pYnhES/1FmKMUP45CxVnyo0RGjBT71eaVjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fszlLaMtAlccGHfqP3v2/s4X3zMI1FvziJvAMQtz3zs=;
 b=OVDVGzGkRc4De6UrqbXEcsB7hX0zvjd18xCgLskwwfd8noVAKztikwvnSvGMVw/kd0zeE+NsKsrnPSlT2kbDksZ6a8zd29At+7fugEY331i4f8GfD1Q24vK+y23vW/j/4i+vg2/DOCj6VUcZMgVtVEGS3GoT1L8ZvrFnZLdGJttJqmWEFWmPP0Azncn8zCk9QJGxRWXJzHsAX37dWRDdKWUkHm5NHfFMZjRqrTqtnKPa1DC5K0uWlQ46xryInDcJRAfTukZ1ACApZcYaYPewjOsOY5W/gr0258Y84dJL7SDp6mKecTmMJYqIUETinWBFeerTmzm8qjAryyroqNzruA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7613::16) by DF4PR8401MB1178.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7611::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 02:25:18 +0000
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::97d:4683:6c97:19f2]) by DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::97d:4683:6c97:19f2%12]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 02:25:18 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Amit Shah <amit@kernel.org>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Thread-Topic: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Thread-Index: AQHV95Eelm8i6f9q4U+J7lkCvZ3HDqhDOqQAgAAF5ICAAAasAIAEFJrA
Date:   Sat, 14 Mar 2020 02:25:17 +0000
Message-ID: <DF4PR8401MB1241779D53613DD3986893F7ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
 <5d68479b9a852cc8c29b36eaa76c45cbd4fdd39a.camel@kernel.org>
 <CAK=zhgrpov8=MkJVVhyr2O6zcJHaR3B-2h2TcRbyCXBx9i8GCQ@mail.gmail.com>
 <CAK=zhgp-oFoMkG_X8e5sm13=14TA5WZAHXYSeuZAV2fmUKbPow@mail.gmail.com>
In-Reply-To: <CAK=zhgp-oFoMkG_X8e5sm13=14TA5WZAHXYSeuZAV2fmUKbPow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.211.195.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f456047-5e5c-4d61-fa4b-08d7c7bef005
x-ms-traffictypediagnostic: DF4PR8401MB1178:
x-microsoft-antispam-prvs: <DF4PR8401MB1178B7EE9E7C8DC2BBF0F084ABFB0@DF4PR8401MB1178.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(39860400002)(376002)(199004)(2906002)(55016002)(9686003)(33656002)(4326008)(64756008)(71200400001)(52536014)(26005)(6506007)(5660300002)(66946007)(76116006)(53546011)(66476007)(66556008)(66446008)(478600001)(110136005)(86362001)(54906003)(316002)(7696005)(186003)(81166006)(8936002)(81156014)(8676002)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DF4PR8401MB1178;H:DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V26A2cODGke7EPbHRTxkpYdEU2su7XPQxLeAnExpQpefuEKZp/Zcso2lhyxJAQqV987vIsKYf9rQ7pA/XH5nhNF3pw/i+GIbeEjxCPsPL2JQfaqJenSI5onxRoktM2Q2O/ee3gbFAX2AlhKs8mBztLm8ZNgR5x/X2ybv+JUVi0A+j222AfqKEWipzNygL7CsOx+ESS5SYa1kdIDVck3CBG64ZfOg3jrE+ToaSCYgVlD+DuyMFGrVF4pUJAFCvj1ksOioGpDyMDQVmjh3Q/1HMrrvFgODl8MhuM9Be8kEnKm/ZQ1GNbymkIdRgd99TBlykerv9Qx1Ci4Mi24/xpyTFSIy0Ucnp61t4yEhbtic4pLNPu7U0zQ+GnhUjEBpkWgxzKyqr3XrVh3bEvADGfWM8wSAiQPglTBa4T9OfxCEYBGZ+ITwyCWKCVIGcMDuFzl6FP4i7GIQR2+2sISYW6OvGcsLTYvK38i704uMlWFMT9WIYYX954RBOxGfE+cxAKwc
x-ms-exchange-antispam-messagedata: omCxMPZTB45I37DWTniK+5x8Ca8UN5W66wkgQO9Q/5Uce5/L4MqKbWZD8hfVipo8v2UFqABSCC9Iy70rg043DeDdJ5evKYtWo55s9eZEZRwcV1b7EN7f+zSOYs7jKlq7G4sZyILi6QCkfOhG/DKmAQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f456047-5e5c-4d61-fa4b-08d7c7bef005
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 02:25:17.9792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIFZJt/Hm5P5xZRDqNLCE8elZJ74HS396GN3MKHVTn+emYgvyFJNa5wr3uoLQfNW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB1178
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140011
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtc2NzaS1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LXNjc2ktDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIFNyZWVrYW50aCBSZWRkeQ0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDEx
LCAyMDIwIDY6NTAgQU0NCj4gVG86IEFtaXQgU2hhaCA8YW1pdEBrZXJuZWwub3JnPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIXSBtcHQzc2FzOiBGaXgga2VybmVsIHBhbmljIG9ic2VydmVkIG9uIHNv
ZnQgSEJBDQo+IHVucGx1Zw0KPiANCj4gT24gV2VkLCBNYXIgMTEsIDIwMjAgYXQgNDo1NSBQTSBT
cmVla2FudGggUmVkZHkNCj4gPHNyZWVrYW50aC5yZWRkeUBicm9hZGNvbS5jb20+IHdyb3RlOg0K
PiA+DQo+ID4gT24gV2VkLCBNYXIgMTEsIDIwMjAgYXQgNDozNSBQTSBBbWl0IFNoYWggPGFtaXRA
a2VybmVsLm9yZz4gd3JvdGU6DQouLi4NCj4gPiA+ID4gQEAgLTk5OTIsOCArOTk5Miw4IEBAIHN0
YXRpYyB2b2lkIHNjc2loX3JlbW92ZShzdHJ1Y3QgcGNpX2Rldg0KPiAqcGRldikNCj4gPiA+DQo+
ID4gPiBKdXN0IGEgbm90ZTogdGhpcyBmdW5jdGlvbiBpcyBzY3NpaF9zaHV0ZG93bigpLiAgRG9l
c24ndCBibG9jaw0KPiA+ID4gYXBwbGljYXRpb24gb2YgdGhlIHBhdGNoLCB0aG91Z2guICBKdXN0
IHdvbmRlcmluZyBob3cgdGhlIHBhdGNoIHdhcw0KPiA+ID4gY3JlYXRlZC4NCj4gDQo+IEkgZ290
IHlvdXIgcXVlcnkgbm93LCAgeWVzIHRoaXMgaHVuayBjaGFuZ2UgaXMgaW4gc2NzaWhfc2h1dGRv
d24oKQ0KPiBmdW5jdGlvbi4gSSBhbSBub3Qgc3VyZSB3aHkgc2NzaWhfcmVtb3ZlIG5hbWUgaXMg
Z2V0dGluZyBkaXNwbGF5ZWQNCj4gaGVyZSBpbiB0aGlzIGh1bmsuIEkgaGF2ZSB1c2VkICdnaXQg
Zm9ybWF0LXBhdGNoJyB0byBnZW5lcmF0ZSB0aGUNCj4gcGF0Y2guDQo+IA0KDQpUaGUgc2NzaWhf
c2h1dGRvd24oKSBmdW5jdGlvbiBkZWZpbml0aW9uIGlzIHNwcmVhZCBvdmVyIHRocmVlIGxpbmVz
DQooYWx0aG91Z2ggaXQgY291bGQgZWFzaWx5IGZpdCBvbiBvbmUgbGluZSksIHdoaWxlIHNjc2lo
X3JlbW92ZSgpIHdhcw0KdGhlIGxhc3QgZnVuY3Rpb24gd2hvc2UgZGVmaW5pdGlvbiB3YXMgb24g
b25lIGxpbmUuIGdpdCBpcyBhcHBhcmVudGx5DQpub3QgcmVjb2duaXppbmcgc2NzaV9zaHV0ZG93
bigpIGFzIGEgZnVuY3Rpb24gZGVmaW5pdGlvbi4NCg0K
