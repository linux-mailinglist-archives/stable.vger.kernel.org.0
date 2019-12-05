Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA09D114512
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 17:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfLEQrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 11:47:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58826 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfLEQrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 11:47:24 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5Gg0bJ004655;
        Thu, 5 Dec 2019 08:47:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=PMLAAzKKMqVAZMaAWfGvXkyYIYDiJtfBOA47bmY8HKM=;
 b=IIj3urk05p6h7hrrp3iWtin8/uTtS4RWPGh5/TZPALlA6K4NKOmoYHPu08rhgq/BV4H2
 5xQAg3mMhZj2oyPK5+4d4630D/jghmg4kHh2xpCvBHR1tqf7cxKh5qvcdCgyJlyJVndW
 IRzUtzIKhhlAn9cZb8dlIZeyO6yFth0uDN8sVHdZqowAjfz5pYMW94Kpzut0hLKWiIeF
 ODE6lUU2W887qSYgpfS0271hcemB+aAsMd1m1kYAKahOPTx1Ix9bKZVgSgXtRElMKLlG
 T2ZjH2KtatrrfqHu60U7D38f5MLG7BsHZDtqEeNSB4CbV26GKLvl/zeEiLPGlQ/mfOLr YA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wpybwhgns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Dec 2019 08:47:14 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 5 Dec
 2019 08:47:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 5 Dec 2019 08:47:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYNwqcKXsFeGGWteZXU+rozgAMabYHeBUY7o/Obyrxg8bjPWZu9P0nlM0B+BuLmpZt9a+pW4iCpHcHERW2IFYgIr8rzxuD0TL44vKvo+b8PPU+0ymYUzyXIz0qaEBSrZFbC7dsGbiBq5R5ldw/cSjjVfA/7U+JK1Ennge4gB/6/WeWEWQ2rzEJ7Ez7Xnii7eBqeIRGVQlT8ycDygug+i0c63AKT1ZcyOyROjv5biB0YHPFYVQ1/V5tf+kRdYHMh+9+z4uNelNK8ca2sMP34WqV3EvrSBQTaxA4Lwss1jn3Sm5FzXbKPNq000PgbXsOg8qTwsb+P5IpwumxawztFrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMLAAzKKMqVAZMaAWfGvXkyYIYDiJtfBOA47bmY8HKM=;
 b=kcf0nLp58NAtoajrfiCaclPzfP1QAEz2pN4Cr8pPH0fdxg7NXZ3jaaDlHMicyibcgVVXRluTTIr3/Yi4xlGvr5djYlFupdCTN89WSB4+WsvK2wyyF265fiLgu99nEiGDTK4On+u2A3mJeC4NjwzkaxqtRsNOJsD80B49nqODyB47jyIvZ1wVY6ADR/6rCYmhACJy9D3TJfcxHYax6oHqrLMXdC0meUj63AGIom1A49ieuwTaectQdqSFkxkjcjg72XYX4cqxQRS+fDAK9NvpMYPuIv+X7Ea2dsDLele9m+1L7DB7N3lMMoeI5QRQguzee8gKSaFoQlnMnsjQfdMCjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMLAAzKKMqVAZMaAWfGvXkyYIYDiJtfBOA47bmY8HKM=;
 b=pWzB2EuAExvYJo67dKa925+7t0gYd1iFO6eRdbWBFaEWMnsYjtK3TeNSHJJMuV4csd4o1w1QXTb2Pj9aAgNqaWC3sK8E3ooZQF7CI/gQPc8ifn3h1ypFiQHv/aLRNdZE+/yox6i86pqCZf57qRCd3lJhip1M/N9VyIAxDVQl1sU=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2463.namprd18.prod.outlook.com (20.179.82.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Thu, 5 Dec 2019 16:47:10 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 16:47:10 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 084/321] scsi: qla2xxx: Fix NPIV handling for FC-NVMe
Thread-Topic: [PATCH 4.19 084/321] scsi: qla2xxx: Fix NPIV handling for
 FC-NVMe
Thread-Index: AQHVquyLRjY+eSFPF020YeMjBWRRf6erXNaA
Date:   Thu, 5 Dec 2019 16:47:10 +0000
Message-ID: <DBFA5257-A719-4A62-8DE1-2497B025D4E8@marvell.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223431.527072152@linuxfoundation.org> <20191204214800.GD7678@amd>
In-Reply-To: <20191204214800.GD7678@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:88a6:d8fe:176e:8e0d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecada224-76c3-492e-05f4-08d779a2c5d7
x-ms-traffictypediagnostic: MN2PR18MB2463:
x-microsoft-antispam-prvs: <MN2PR18MB24630C8ED02C91164713A606D65C0@MN2PR18MB2463.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(54534003)(189003)(199004)(305945005)(81166006)(81156014)(8936002)(99286004)(8676002)(76116006)(966005)(91956017)(36756003)(11346002)(14454004)(2906002)(2616005)(4326008)(66446008)(66556008)(66476007)(66946007)(64756008)(229853002)(478600001)(186003)(102836004)(6486002)(86362001)(316002)(6506007)(5660300002)(6512007)(71190400001)(71200400001)(58126008)(76176011)(33656002)(54906003)(110136005)(25786009)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2463;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u5CmxQqMdeRaC5rWu1afFI5Pikl7sxaFIcsxy4xHYTzs7slxkezb835kBdW2oEwmfAhPQHmw9RscjVw2QM042VTkiHjl8NdqMcPWhLaWGeWk4qp1w1ZXG+/27iLc5zrZoAV3y3HdeWdeyrWXWbkdvGHbLGbSoSG8WPhHIaPYdAuGbX1d8fDcBpP8JP6F6YpCnhz6izriSt9TZ09OPqlQzQtgOk2zyEzVb8nsL72TnZBPlDo5mHLDi9bjAdYmFxb1lKdt4WWRo+t55/unyzeDeATXkvYKUR9bTch3o1z5MXpM6wDeL6ahm+aZLf7h3F3pAbQrS82uMhBUD9Lh9zPjTHxyM00Mf1KgACxnxw7fJ5Uh2z/Fe6Cp/3xFRTY79KxNBMUur0GhxsPT5NgEggQeXJputBe401I/k2KXrawao2kdexvZ2l3nSLNtnURdhSUdZsMxvs+V6TJp6F9KrKWRmVjpDmZfimWLbjIwj6KBnujvi2FM50etOCjuPVvxxpvwpGjoG1VV8jjVSxAI7vFajL+S41ECVLvXWWcy0XVBaJo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E052A0DAAAA6AC488EBC6FD4C79263DD@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ecada224-76c3-492e-05f4-08d779a2c5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 16:47:10.5831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 05hmz0Y6gXUVK0AhvHhuy+4QWSo4F0GBL7X6Y2s7ebxbwAq7YmRe4TGOYj+Od4N/hr03hlOVr5zSb7OZXGeY4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2463
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_05:2019-12-04,2019-12-05 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sIA0KDQrvu79PbiAxMi80LzE5LCAzOjQ4IFBNLCAiUGF2ZWwgTWFjaGVrIiA8bGludXgt
a2VybmVsLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgcGF2ZWxAZGVueC5kZT4g
d3JvdGU6DQoNCiAgICBIaSENCiAgICANCiAgICA+IEZyb206IEhpbWFuc2h1IE1hZGhhbmkgPGht
YWRoYW5pQG1hcnZlbGwuY29tPg0KICAgID4gDQogICAgPiBbIFVwc3RyZWFtIGNvbW1pdCA1ZTY4
MDNiNDA5YmEzYzE4NDM0ZGU2NjkzMDYyZDk4YTQ3MGJjYjFlIF0NCiAgICA+IA0KICAgID4gVGhp
cyBwYXRjaCBmaXhlcyBpc3N1ZXMgd2l0aCBOUElWIHBvcnQgd2l0aCBGQy1OVk1lLiBDbGVhbiB1
cCBjb2RlIGZvcg0KICAgID4gcmVtb3RlcG9ydCBkZWxldGUgYW5kIGFsc28gY2FsbCBudm1lX2Rl
bGV0ZSB3aGVuIGRlbGV0aW5nIFZQcy4NCiAgICANCiAgICA+IEBAIC01NjQsNyArNTU0LDcgQEAg
c3RhdGljIHZvaWQgcWxhX252bWVfcmVtb3RlcG9ydF9kZWxldGUoc3RydWN0IG52bWVfZmNfcmVt
b3RlX3BvcnQgKnJwb3J0KQ0KICAgID4gIAkJc2NoZWR1bGVfd29yaygmZmNwb3J0LT5mcmVlX3dv
cmspOw0KICAgID4gIAl9DQogICAgPiAgDQogICAgPiAtCWZjcG9ydC0+bnZtZV9mbGFnICY9IH4o
TlZNRV9GTEFHX1JFR0lTVEVSRUQgfCBOVk1FX0ZMQUdfREVMRVRJTkcpOw0KICAgID4gKwlmY3Bv
cnQtPm52bWVfZmxhZyAmPSB+TlZNRV9GTEFHX0RFTEVUSU5HOw0KICAgID4gIAlxbF9sb2cocWxf
bG9nX2luZm8sIGZjcG9ydC0+dmhhLCAweDIxMTAsDQogICAgPiAgCSAgICAicmVtb3RlcG9ydF9k
ZWxldGUgb2YgJXAgY29tcGxldGVkLlxuIiwgZmNwb3J0KTsNCiAgICA+ICB9DQogICAgDQogICAg
Q3VycmVudCAtbmV4dC0yMDE5MTIwNCBjb250YWlucw0KICAgIA0KICAgICBmY3BvcnQtPm52bWVf
ZmxhZyAmPSB+TlZNRV9GTEFHX1JFR0lTVEVSRUQ7DQogICAgIGZjcG9ydC0+bnZtZV9mbGFnICY9
IH4gTlZNRV9GTEFHX0RFTEVUSU5HOw0KICAgIA0KICAgIC4uLiBhbmQgdGhlcmUncyBubyBleHBs
YW5hdGlvbiBpbiBjaGFuZ2Vsb2cgd2h5IHJlbW92aW5nDQogICAgTlZNRV9GTEFHX1JFR0lTVEVS
RUQgaXMgZ29vZCBpZGVhLg0KDQpUaGlzIHBhdGNoIHdhcyBtb3N0bHkgY2xlYW51cCBhbmQgaWYg
eW91IG5vdGljZSBvbiBsaW5lIDU0MSB3ZSBhcmUgYWxyZWFkeSBjbGVhcmluZyB1cCBOVk1FX0ZM
QUdfUkVHSVNURVJFRCBmbGFnLg0KDQplODQwNjdkNzQzMDEwIChEdWFuZSBHcmlnc2J5ICAgICAg
ICAgICAgICAgMjAxNy0wNi0yMSAxMzo0ODo0MyAtMDcwMCA1NDEpICAgICAgIGZjcG9ydC0+bnZt
ZV9mbGFnICY9IH5OVk1FX0ZMQUdfUkVHSVNURVJFRDsNCg0Kc28gdGhpcyBwYXRjaCBpcyBqdXN0
IHJlbW92aW5nIGR1cGxpY2F0ZSBjbGVhcmluZy4gQXQgc29tZSBwb2ludCB3ZSB3aWxsIG5lZWQg
dG8gZml4IGRvdWJsZSBsaW5lIG9mIGNsZWFyaW5nIE5WTUVfRkxBR19SRUdJU1RFUkVEIGFuZCBO
Vk1FX0ZMQUdfREVMRVRJTkcNCmluIG9uZSBsaW5lLiBJJ2xsIHNlbmQgcGF0Y2ggdG8gZml4IHRo
YXQgZm9yIG5ldC1uZXh0LiANCg0KVGhhbmtzLA0KSGltYW5zaHUNCiAgICANCiAgICBBcmUgeW91
IHN1cmUgdGhpcyBjaGFuZ2UgaXMgY29ycmVjdCBhbmQgc3VpdGFibGUgZm9yIC1zdGFibGU/DQog
ICAgIAkJCQkJCQkJUGF2ZWwNCiAgICAtLSANCiAgICAoZW5nbGlzaCkgaHR0cDovL3d3dy5saXZl
am91cm5hbC5jb20vfnBhdmVsbWFjaGVrDQogICAgKGNlc2t5LCBwaWN0dXJlcykgaHR0cDovL2F0
cmV5Lmthcmxpbi5tZmYuY3VuaS5jei9+cGF2ZWwvcGljdHVyZS9ob3JzZXMvYmxvZy5odG1sDQog
ICAgDQoNCg0K
