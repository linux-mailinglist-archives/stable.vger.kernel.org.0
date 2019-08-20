Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D75195FF0
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfHTNXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:23:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728248AbfHTNXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:23:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDETb0013265;
        Tue, 20 Aug 2019 06:22:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6jfewJXOsb6CVa6VAgwTaur0quLGoyfct0cD22RgsGI=;
 b=Ek37MDAdLOb2vDRIWUL8SzpRp/1hq44fafaCzGAl+dEoDDPcTTL9h5eDCtQcoqERv6Da
 cw9jajEddgScJRfIl/eHUx7wpiagKfTF/umlgtx883I71juFRIrvB/V+JKhkTnYNT4rR
 QmH1G0xtvf3WRS5N9JC5/Z/W/T0oOoRRgvM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugemngqh3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 06:22:00 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 06:21:58 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 06:21:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dALkxzG1LB6J63EqeoCfygsCyqEtxnIt2rUrAYTJ7cnryoakhHVLPtOrF484ovszZJimUZbWG3pkNcP30gOMdJye/41FtqCev/itxs2sdXo3A28N1xsR4b9LwuujHKnJHzijDG9QKVAHRgArEDyDMKGXPoK+V8HHU7nCWIV5WUeLHznbKK+LFvh/Gl+Chdqmh8U5mefqDlwVIy/DZ/PFRWlQrbMh0gwiUuF/WAfJle1zbH/FmvjLxPBf4fXplxLrNO5lCGRYxHmjpagUTQPllAMYgq+oSCRv8Em3GVrWrdTbo6kuVcStp51Iovp+Ls5H04KHtZJmDe1k9EApqNQedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jfewJXOsb6CVa6VAgwTaur0quLGoyfct0cD22RgsGI=;
 b=eUhG2+ymuVT3VTXQUhV4Rt03gBS0UGPQWOG3yf3u2Lv134aegFOYF/KboBiccLGadVrD/AZg8IUcTrrQ5RHzDlxxy24Yr9Vr83I2v2tJrgt0ojJYxcn6/LeurU6wkQ5qo9fUvPyDWhKgd9W217a2Hhlq42zNAX42BBGRtQg0i9vAufGxn4vWl3a3BILBaqhdQFrJSPyi1IMhd1tm2Y+O8/ENxSswuW69Dr1+dxX+Uzks64USE+tWW1SrShAFMEKXMJQOOfSAUCa+YoCtDcTwrWqj9f7ySI9+jWkzIDgOvqegHMaMFAg+/7tEPnzN4yX01RWNOfmi64Ew7fxlStBI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jfewJXOsb6CVa6VAgwTaur0quLGoyfct0cD22RgsGI=;
 b=H4g29hZho/bzETsbd+VOkP8AfCDvRUYpHwWSvZ+eLUCQ+WPY4TQFbvpOVUE2lTO2iNfG7u3ZzwwSuYF6OVV3ObNZCexAprsh0fEY6gSbRXjvSTSbwWIUfiPlDLgWOZBBoFtrHiV3Rsn0xPAglhVMqC1munDRn7YWUo8XtLWoeyY=
Received: from BYAPR15MB3479.namprd15.prod.outlook.com (20.179.60.19) by
 BYAPR15MB3494.namprd15.prod.outlook.com (20.179.60.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 13:21:54 +0000
Received: from BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::cd53:3e19:5b34:c385]) by BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::cd53:3e19:5b34:c385%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:21:53 +0000
From:   Rik van Riel <riel@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywhQLSFzdLXp0en14V4x7p7pacDzfeAgAAVLICAACL1AA==
Date:   Tue, 20 Aug 2019 13:21:53 +0000
Message-ID: <e9b314d03804024d1de09e1ad83eda9f54964828.camel@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
         <20190820100055.GI2332@hirez.programming.kicks-ass.net>
         <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR01CA0021.prod.exchangelabs.com (2603:10b6:208:10c::34)
 To BYAPR15MB3479.namprd15.prod.outlook.com (2603:10b6:a03:112::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:480::751a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47b791a3-ef78-49a2-7f47-08d725715e0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3494;
x-ms-traffictypediagnostic: BYAPR15MB3494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB349473827FA6FA835ADA8550A3AB0@BYAPR15MB3494.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(136003)(346002)(39860400002)(199004)(189003)(6116002)(71190400001)(86362001)(305945005)(7736002)(446003)(8676002)(71200400001)(6436002)(6486002)(6512007)(256004)(229853002)(66946007)(14454004)(5660300002)(4744005)(66446008)(64756008)(66556008)(66476007)(118296001)(76176011)(25786009)(36756003)(99286004)(8936002)(46003)(2906002)(478600001)(52116002)(476003)(316002)(6506007)(54906003)(11346002)(386003)(81166006)(2616005)(102836004)(81156014)(6246003)(4326008)(53936002)(186003)(110136005)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3494;H:BYAPR15MB3479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ffLk1ME0kZvzp/05hdHmDPXAD5igxtGxI1XXuYw1fqXgql8jxZw6A7FlNjoxBfJaeksY46r0ysHM5CgaGi1YhsQB2bg0MbqBVta1mW+Th+ivtnO4P42NadgKlIz1ZIKsha1L3tljLiiN8Y2L0AhSHbwYRcC8nOUT7h+tMKKo2iLBfmo5eKxL9TjhZJeICyNnY4jVw9O/XXVteajXtnoQnzVcDb25ULT67thmvUjpeVMwwbc8ij9qyfEivPmKGrp4Zg2deFND5loifW+7NkwrwAdGR1fKYiEbTJ3J2g6dA+ew1xlIsgtlzhm4Y460X0+cpiHNMyrCzl3mXFbTYuO8XL8DayWopg5qAC/EbYPztlTxS8selUMgZonX10JaVuSTVRA2NfcmXktGQn18bLKzGwveOTld+hxZ9I828DfFpts=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81246B1FA3B7F041B5E42D4BA46D481E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b791a3-ef78-49a2-7f47-08d725715e0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:21:53.8467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMBYQz6HvEyUQri3m9igQKeZot6FBmGiu7RRvd0NvBOGp2KUyt1cM9TCBaGiffet
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3494
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=780 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200140
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTIwIGF0IDEzOjE2ICswMjAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+IE9uIFR1ZSwgMjAgQXVnIDIwMTksIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiA+IFdoYXQg
dGhhdCBjb2RlIHdhbnRzIHRvIGRvIGlzIHNraXAgdG8gdGhlIGVuZCBvZiB0aGUgcHVkLCBhDQo+
ID4gcG1kX3NpemUNCj4gPiBpbmNyZWFzZSB3aWxsIG5vdCBkbyB0aGF0LiBBbmQgcmlnaHQgYmVs
b3cgdGhpcywgdGhlcmUncyBhIHNlY29uZA0KPiA+IGluc3RhbmNlIG9mIHRoaXMgZXhhY3QgcGF0
dGVybi4NCj4gPiANCj4gPiBEaWQgSSBnZXQgdGhlIGJlbG93IHJpZ2h0Pw0KPiA+IA0KPiA+IC0t
LQ0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9wdGkuYyBiL2FyY2gveDg2L21tL3B0aS5j
DQo+ID4gaW5kZXggYjE5NjUyNDc1OWVjLi4zMmIyMGIzY2IyMjcgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC94ODYvbW0vcHRpLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9tbS9wdGkuYw0KPiA+IEBAIC0z
MzAsMTIgKzMzMCwxNCBAQCBwdGlfY2xvbmVfcGd0YWJsZSh1bnNpZ25lZCBsb25nIHN0YXJ0LA0K
PiA+IHVuc2lnbmVkIGxvbmcgZW5kLA0KPiA+ICANCj4gPiAgCQlwdWQgPSBwdWRfb2Zmc2V0KHA0
ZCwgYWRkcik7DQo+ID4gIAkJaWYgKHB1ZF9ub25lKCpwdWQpKSB7DQo+ID4gKwkJCWFkZHIgJj0g
UFVEX01BU0s7DQo+ID4gIAkJCWFkZHIgKz0gUFVEX1NJWkU7DQo+IA0KPiAJCQlyb3VuZF91cChh
ZGRyLCBQVURfU0laRSk7DQo+IA0KPiBwZXJoYXBzPw0KDQpXb24ndCB0aGF0IGtlZXAgcmV0dXJu
aW5nIHRoZSBzYW1lIGFkZHJlc3MgZm9yZXZlcg0KaWYgYWRkciAmIFBVRF9NQVNLID09IDA/DQoN
Cg==
