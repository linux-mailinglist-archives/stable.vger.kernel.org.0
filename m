Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92267961AD
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfHTN4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:56:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730033AbfHTN4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:56:15 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDlqX4015824;
        Tue, 20 Aug 2019 06:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xpTfgEWHO8zSxSSk1x9GvYDrVgIph2RroPkqwh7t5xQ=;
 b=apRZqeG2J7WLwnhELqxVizNskrOZyXdPUuSeHZst8p3HyJ3twoLYNOwSqBM2RqU1fQ1E
 vAIPy+cGdo+jBiVJDJp9JgXApnwvs+CQYDb5+9iuBcIYDNk1KKolxygMc16T5uzl9DGu
 tN84tr5V9ChTscLWNpnU/jorCfv+d9MSiiU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ug6dyafcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 06:56:00 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 06:55:59 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 06:55:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTavsT3xpJFynkUp86hXc+KgwbjiUSEBrYK+2MTzz2qisJwyjbzMDWPdNsLOhbebO1Gea2ydeMrSRVp6IRzS87NihkXQyVMWGWR1VBkQDjYhJQIrYbwexBNB7nofiWFGKHaTL8cuceiv/nKuqPXn60erv439hDKnQmImfWrDLxDpb+8zl5ObVW2cO6q+vrX3+4B4xqsh8GdD1h5hmI2Qb8qnQXXPB30wmvW3fUugCNDQq2Em1oeGIGwwbS1GA1M61deEWCeFuEMW7hBdhM5zyaCtwiFpiEyKY3dIRnUbqhEFTfR+4jPPYsgl3o+78LbKG9YTXgDUfrlG4qzA0tM9BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpTfgEWHO8zSxSSk1x9GvYDrVgIph2RroPkqwh7t5xQ=;
 b=Eeo1SJBQvP8shNfPKk/JxravRLFcyALNrlm8CD5SNNFFSKRmlYCf40tWJyqBOPXJKaKwuar261GUuUJJLWgyHiluWo/2RHp8uHUsG0HLjufm7BkBLOkShD1yYWss44pCT3+6pJfXix40HZQuOd2+5D6b1HjAwK4RFcJAa2hoRs66k3LuGNxJ6R2R61irFXP4FEPTfURVOKieRnsBCpVPKJ0zCCzDAAERQ53Mj6a40XDq0OUHiZ36QEtC8p8Bfrgu+JcfkpRsWqsYe3Y0n+afQz8Ub9vTPex6yG86ZXYtLiV23VwSPYS9FHF3SDKqK0Xeas2aYAPODwnV7WkHy3aqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpTfgEWHO8zSxSSk1x9GvYDrVgIph2RroPkqwh7t5xQ=;
 b=P39FNSq15JU+I52fncGSHgBr26CjZaj5ECahkNZhWPfuPoYUkDR38U4wscGnTMZVZeon9yvv73kwPyoQ3Pg+HAnXALOgdtAsabydZITtc47G8CRVR/2Tkiwjj53aYU6l6U3MUBfjvH1/RuMMsbZui7jgAS5HVvTLvPc+fSmQcX4=
Received: from BYAPR15MB3479.namprd15.prod.outlook.com (20.179.60.19) by
 BYAPR15MB3207.namprd15.prod.outlook.com (20.179.56.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 20 Aug 2019 13:55:58 +0000
Received: from BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::cd53:3e19:5b34:c385]) by BYAPR15MB3479.namprd15.prod.outlook.com
 ([fe80::cd53:3e19:5b34:c385%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:55:58 +0000
From:   Rik van Riel <riel@fb.com>
To:     Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
Thread-Index: AQHVVywhQLSFzdLXp0en14V4x7p7pacDzfeAgAAVLICAACLkAIAACZgA
Date:   Tue, 20 Aug 2019 13:55:57 +0000
Message-ID: <d887e9e228440097b666bcd316aabc9827a4b01e.camel@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
         <20190820100055.GI2332@hirez.programming.kicks-ass.net>
         <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
         <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
In-Reply-To: <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:404:f7::28) To BYAPR15MB3479.namprd15.prod.outlook.com
 (2603:10b6:a03:112::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:480::751a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24fcdb2c-ed5b-4135-3986-08d725762087
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3207;
x-ms-traffictypediagnostic: BYAPR15MB3207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB320769EB8227C27279CB83AEA3AB0@BYAPR15MB3207.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(136003)(39860400002)(199004)(189003)(102836004)(71190400001)(2906002)(110136005)(5660300002)(6116002)(476003)(8936002)(7736002)(54906003)(99286004)(305945005)(46003)(86362001)(486006)(446003)(8676002)(2616005)(186003)(11346002)(256004)(64756008)(229853002)(66446008)(66476007)(66946007)(6512007)(478600001)(76176011)(25786009)(66556008)(53546011)(81166006)(81156014)(52116002)(6486002)(386003)(71200400001)(6246003)(316002)(53936002)(6436002)(4326008)(118296001)(36756003)(14454004)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3207;H:BYAPR15MB3479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tJ9buLUJevEhLDM//RGIWdKifxGUinXi4puAndUh/VMBTK61Mz1ZbDzOjUZk2ywkP/U4uLqmGAb26hVCQS3LgHt2ibis1uWud+VG6AK3f0tOg62lSjuNNLXCMMAolbKEuAI9X9kuHyoOrzZs//iCL+OOI1Z8B7STHONRtWk0JAzCyhb37mILBj0dZnfobI2WnEMeJ55fJ8Oj3e76L3N5BAKjZmXPC3+6IMIDYX8NTeNUAZbhHvgjF492CYJ7CstYMOYeJfNKw5ThQmQHJU53mQmO30wr2aG/RpjJDJevWOC/nkIUuq1ZTjgMS90iLwAis4bMtd8YpEEMvEqIzcFeMODr4rDPGXfg5RcEoEYWaNlhbrmkUt/Wdl32yG5/yA9oJNUH1CbMGFjN3xGE3O5Yh99xMJ8KYhpfdEjgi3PXVbg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DB66446F223444BADC7C0AD6B0EB412@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 24fcdb2c-ed5b-4135-3986-08d725762087
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:55:58.0085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGSaxADpG91lP0+yzTihckwwbhoL/2mJ3/0F3eWBecAJ9RaiX2czcPDuRmzHQNrx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=708 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200142
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTIwIGF0IDA5OjIxIC0wNDAwLCBTb25nIExpdSB3cm90ZToNCj4gPiBP
biBBdWcgMjAsIDIwMTksIGF0IDQ6MTYgQU0sIFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJv
bml4LmRlPg0KPiA+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAgQXVnIDIwMTksIFBldGVy
IFppamxzdHJhIHdyb3RlOg0KPiA+ID4gV2hhdCB0aGF0IGNvZGUgd2FudHMgdG8gZG8gaXMgc2tp
cCB0byB0aGUgZW5kIG9mIHRoZSBwdWQsIGENCj4gPiA+IHBtZF9zaXplDQo+ID4gPiBpbmNyZWFz
ZSB3aWxsIG5vdCBkbyB0aGF0LiBBbmQgcmlnaHQgYmVsb3cgdGhpcywgdGhlcmUncyBhIHNlY29u
ZA0KPiA+ID4gaW5zdGFuY2Ugb2YgdGhpcyBleGFjdCBwYXR0ZXJuLg0KPiA+ID4gDQo+ID4gPiBE
aWQgSSBnZXQgdGhlIGJlbG93IHJpZ2h0Pw0KPiA+ID4gDQo+ID4gPiAtLS0NCj4gPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9tbS9wdGkuYyBiL2FyY2gveDg2L21tL3B0aS5jDQo+ID4gPiBpbmRl
eCBiMTk2NTI0NzU5ZWMuLjMyYjIwYjNjYjIyNyAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gveDg2
L21tL3B0aS5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9tbS9wdGkuYw0KPiA+ID4gQEAgLTMzMCwx
MiArMzMwLDE0IEBAIHB0aV9jbG9uZV9wZ3RhYmxlKHVuc2lnbmVkIGxvbmcgc3RhcnQsDQo+ID4g
PiB1bnNpZ25lZCBsb25nIGVuZCwNCj4gPiA+IA0KPiA+ID4gCQlwdWQgPSBwdWRfb2Zmc2V0KHA0
ZCwgYWRkcik7DQo+ID4gPiAJCWlmIChwdWRfbm9uZSgqcHVkKSkgew0KPiA+ID4gKwkJCWFkZHIg
Jj0gUFVEX01BU0s7DQo+ID4gPiAJCQlhZGRyICs9IFBVRF9TSVpFOw0KPiA+IA0KPiA+IAkJCXJv
dW5kX3VwKGFkZHIsIFBVRF9TSVpFKTsNCj4gDQo+IEkgZ3Vlc3Mgd2UgbmVlZCAicm91bmRfdXAo
YWRkciArIFBNRF9TSVpFLCBQVURfU0laRSkiLiANCg0KV2hhdCBkb2VzIHRoYXQgZG8gaWYgc3Rh
cnQgaXMgbGVzcyB0aGFuIFBNRF9TSVpFDQphd2F5IGZyb20gdGhlIG5leHQgUFVEX1NJWkUgYm91
bmRhcnk/DQoNCkhvdyBhYm91dDogICByb3VuZF91cChhZGRyICsgMSwgUFVEX1NJWkUpICA/DQoN
Cg==
