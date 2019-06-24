Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AA851CE4
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 23:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFXVPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 17:15:52 -0400
Received: from mail-eopbgr790124.outbound.protection.outlook.com ([40.107.79.124]:6066
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfFXVPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 17:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dfwf3TF+lS/iR+X2mq4ahhgzHkVR/U+ePaJeYMDxZFc=;
 b=gsJ66+3zPefERI39m9thM2dOAtLyVY4a6QqJOwppJIzFGmZcrwdoqxzV4+2maOKYceaq1E25Pq/TJaBUUWm308pMh80oaTW0hwv1Bc7nSxaNNVDRF9kby1o8FZH8k+NpiGb52YH6/09ivaXBsMC59947m7i3Int5a+4zwm5Kkms=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1760.namprd22.prod.outlook.com (10.164.206.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 21:15:49 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 21:15:49 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Dmitry Korotin <dkorotin@wavecomp.com>
CC:     Paul Burton <pburton@wavecomp.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Topic: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Index: AQHVKr/IJ/I3WfJb9EWmSHJfQfE2CKarTn0A
Date:   Mon, 24 Jun 2019 21:15:49 +0000
Message-ID: <MWHPR2201MB1277CA4A6C1D2DC01E395489C1E00@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <CY4PR22MB0245F6CD97467AAB12E437A5AFE00@CY4PR22MB0245.namprd22.prod.outlook.com>
In-Reply-To: <CY4PR22MB0245F6CD97467AAB12E437A5AFE00@CY4PR22MB0245.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::17) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbea753c-f986-4736-494b-08d6f8e9219f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1760;
x-ms-traffictypediagnostic: MWHPR2201MB1760:
x-microsoft-antispam-prvs: <MWHPR2201MB1760DD39AB516879B08B8DD7C1E00@MWHPR2201MB1760.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39840400004)(136003)(366004)(376002)(396003)(189003)(199004)(486006)(53936002)(7736002)(68736007)(76176011)(386003)(66066001)(25786009)(450100002)(4326008)(186003)(305945005)(42882007)(316002)(256004)(74316002)(6506007)(99286004)(54906003)(476003)(52116002)(11346002)(446003)(44832011)(7696005)(26005)(8676002)(102836004)(6116002)(3846002)(9686003)(71190400001)(71200400001)(14454004)(5660300002)(229853002)(6862004)(8936002)(52536014)(4744005)(6436002)(64756008)(66556008)(33656002)(66446008)(66476007)(6246003)(73956011)(2906002)(55016002)(478600001)(66946007)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1760;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uOnH0nwfNR6+SDRs41VjlsUrJ/fqsiEuY7p4yUmbe26FGEKtkvnzhzRORFi5QeoWi4wg2Xm+dd+hfWgAgzZpgSpAKLFI08wm4q9oRetCXxaso1BFj1gNqtx76u1+yXl3XH51o04YhdbQPGN7i8dwyeZVga8M8rXLtsE/gUoQwzqlENZsyyG0b+qPEXJBZsKAsLM90NFXeE7b4vXGnt0Hzy0KT8ZUDkHYTePKjlSjVfi5tgMXbEW+SSvq84UeyHtn8DVMBZiBMCPEnSSOCWJj9JnbD2YaDrxAZ/7QSdNGKqzbdZhtCBOpgpVDNPEkwxb14fNV0DMfA+RiKDdmxGYsiFLaZ28Qmh8iT4+F+r7h5BOVBJm1HgBm18eX0wCW/ijnc0fk9V7Zx0wl6gcIqXb3ObzrymtO7K6dLo2Sh9803qA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbea753c-f986-4736-494b-08d6f8e9219f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 21:15:49.7451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1760
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNCkRtaXRyeSBLb3JvdGluIHdyb3RlOg0KPiBBZGRlZCBtaXNzaW5nIEVIQiAoRXhl
Y3V0aW9uIEhhemFyZCBCYXJyaWVyKSBpbiBtdGMwIC0+IG1mYzAgc2VxdWVuY2UuDQo+IFdpdGhv
dXQgdGhpcyBleGVjdXRpb24gaGF6YXJkIGJhcnJpZXIgaXQncyBwb3NzaWJsZSBmb3IgdGhlIHZh
bHVlIHJlYWQNCj4gYmFjayBmcm9tIHRoZSBLU2NyYXRjaCByZWdpc3RlciB0byBiZSB0aGUgdmFs
dWUgZnJvbSBiZWZvcmUgdGhlIG10YzAuDQo+IA0KPiBSZXByb2R1Y2lhYmxlIG9uIFA1NjAwICYg
UDY2MDAuDQo+IA0KPiBNaXBzIGRvY3VtZW50YXRpb24gVm9sdW1lIElJSSAocmV2IDYuMDMpIHRh
YmxlIDguMS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERtaXRyeSBLb3JvdGluIDxka29yb3RpbkB3
YXZlY29tcC5jb20+DQoNCkFwcGxpZWQgdG8gbWlwcy1maXhlcy4NCg0KVGhhbmtzLA0KICAgIFBh
dWwNCg0KWyBUaGlzIG1lc3NhZ2Ugd2FzIGF1dG8tZ2VuZXJhdGVkOyBpZiB5b3UgYmVsaWV2ZSBh
bnl0aGluZyBpcyBpbmNvcnJlY3QNCiAgdGhlbiBwbGVhc2UgZW1haWwgcGF1bC5idXJ0b25AbWlw
cy5jb20gdG8gcmVwb3J0IGl0LiBdDQo=
