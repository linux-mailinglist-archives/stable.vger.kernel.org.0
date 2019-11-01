Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28E6EC52A
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 15:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfKAO53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 10:57:29 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:19766
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727365AbfKAO53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 10:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsn2EABBrgQlakRZQk2poUFSp4JMqQJm8JBfUBeVtaM=;
 b=lq95Vdkk+cL2gDgMlsgOHojP5xUVfSCVy/hZgZmvlgWjEYSfrHRUuOKyTFmqaEX1bMC9I025xXOyLhAv3qGFHpjvMA9ui5AXTYBwydslbR9JeSLV02GoNplkOzZFSlXoYF1E057/rPEnQmsoTv7xYTGw7Cg1C4IXWq15LAxBhKo=
Received: from AM6PR08CA0047.eurprd08.prod.outlook.com (2603:10a6:20b:c0::35)
 by AM6PR08MB3832.eurprd08.prod.outlook.com (2603:10a6:20b:89::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.24; Fri, 1 Nov
 2019 14:57:19 +0000
Received: from DB5EUR03FT016.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::207) by AM6PR08CA0047.outlook.office365.com
 (2603:10a6:20b:c0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2408.20 via Frontend
 Transport; Fri, 1 Nov 2019 14:57:18 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT016.mail.protection.outlook.com (10.152.20.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.26 via Frontend Transport; Fri, 1 Nov 2019 14:57:18 +0000
Received: ("Tessian outbound 081de437afc7:v33"); Fri, 01 Nov 2019 14:57:18 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ffb9f46cfbce3bbd
X-CR-MTA-TID: 64aa7808
Received: from c91185b60a79.1 (cr-mta-lb-1.cr-mta-net [104.47.4.50])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C66C0FD4-F928-44C5-8A56-CA65CF6B7C29.1;
        Fri, 01 Nov 2019 14:57:13 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2050.outbound.protection.outlook.com [104.47.4.50])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c91185b60a79.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 01 Nov 2019 14:57:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFNSmThCLaGYXTl9QsMD+I/kE5NKwJ0Y6nikM+KepEjamP7Nj+XAgi+MZmgClCHkbWym/opnaNS2MaqNtxNuz8NaslvmqMuKf7FpsChBj0SyYTrY06bDlohdWXThuvu4gB5CQwkfM8clxJ6gU/Pz9WroDHF7zaM5jri3u7m5P9yPvQc0bzn2Rq+oMM0HAvGo6ZPYOtXOcCsu9O2R2L8MXb5kJid5P9u8B+0M8WIN2gYXTFayNpGWXZigcAPNM4bI9SF7puBRIkS0t/hqXIVSWD+Uxsit+qHXNtM05+LV0+VkvHsYr7+3b1BHnanYm7t1FN+fvHczLKOv8ZJbrhBt7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsn2EABBrgQlakRZQk2poUFSp4JMqQJm8JBfUBeVtaM=;
 b=TpbMl8QOZE1TJFinjAZq2MWiH4ksQvk8S1apy0lO0AALUv14qKzUEP/hzBYe7Az5Q8JyBfV/Ji6dmzeruxt4Mh+xrkEGlxKN4Mg8LCaAADIF2pnBps462zrt3U3Spfkviou52v4dcVDK1oliTqMFiWAJIREfQuqHpV8gaIjdH48Ng1A5c3iLsrJXDvL9sITumUJ3aSbk+LJR1IwJfag/PJ8vgiZdh7x1o1K6InYM1zLrp6M44sH+hkJ7PWlfe67VC1MPwA5/8k7pmaD7gP0OAnaNbKnw7FLqyHaIlceO+oqufJgjpWKoVeoOqZ+RZ9Amo05bIsb/hTkSACcYOuzO7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsn2EABBrgQlakRZQk2poUFSp4JMqQJm8JBfUBeVtaM=;
 b=lq95Vdkk+cL2gDgMlsgOHojP5xUVfSCVy/hZgZmvlgWjEYSfrHRUuOKyTFmqaEX1bMC9I025xXOyLhAv3qGFHpjvMA9ui5AXTYBwydslbR9JeSLV02GoNplkOzZFSlXoYF1E057/rPEnQmsoTv7xYTGw7Cg1C4IXWq15LAxBhKo=
Received: from DB7PR08MB3292.eurprd08.prod.outlook.com (52.134.111.30) by
 DB7PR08MB3610.eurprd08.prod.outlook.com (20.176.239.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 14:57:10 +0000
Received: from DB7PR08MB3292.eurprd08.prod.outlook.com
 ([fe80::bc69:7a3a:d0f6:b45d]) by DB7PR08MB3292.eurprd08.prod.outlook.com
 ([fe80::bc69:7a3a:d0f6:b45d%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 14:57:10 +0000
From:   Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>
CC:     nd <nd@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clone3: validate stack arguments
Thread-Topic: [PATCH] clone3: validate stack arguments
Thread-Index: AQHVj99z7K5LXOVU/k6bNRWiXK31o6d2aYQA
Date:   Fri, 1 Nov 2019 14:57:10 +0000
Message-ID: <f51d97a2-8130-0ba2-c591-638b7fd6b14d@arm.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [217.140.106.54]
x-clientproxiedby: LO2P265CA0163.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::31) To DB7PR08MB3292.eurprd08.prod.outlook.com
 (2603:10a6:5:1f::30)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78407f62-3380-4ed7-299c-08d75edbcac7
X-MS-TrafficTypeDiagnostic: DB7PR08MB3610:|AM6PR08MB3832:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3832157A4E62BDF66CFCDF28ED620@AM6PR08MB3832.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:4303;OLM:4303;
x-forefront-prvs: 020877E0CB
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(66066001)(99286004)(14444005)(6486002)(25786009)(110136005)(5660300002)(54906003)(71200400001)(52116002)(64756008)(6512007)(229853002)(36756003)(2616005)(31696002)(81166006)(15650500001)(256004)(14454004)(478600001)(71190400001)(58126008)(86362001)(6436002)(446003)(11346002)(81156014)(8676002)(6246003)(31686004)(7416002)(476003)(4326008)(8936002)(186003)(65956001)(65806001)(486006)(76176011)(7736002)(66476007)(386003)(6506007)(53546011)(66946007)(26005)(316002)(66446008)(2906002)(66556008)(2501003)(44832011)(6116002)(102836004)(3846002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB3610;H:DB7PR08MB3292.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: NI/HtMWguQFz9WmwgBucoHCFtn8cLuUiV5mn7LfhpyMkoIEJwnQGKYpXGAYxzoTCrlaWGc6qJYiP6Cj5oUwDj4FDND9RGmUV9/Mu3Cu+MFdk9IS5pO4VvAX4I3/Iq7qBi2W3cNscg/d6Ow4qkYR9gTNtgezYqOVc+QIsTwgRAeBpdY6Z4zsvm79enCNHDf/Anc8Rb/+PNcN8JIWdhLsKgevhcTjgQPzz0HfDrwpMMQQylY33U9wiGKZLSNK3yY4aZ8ChqgE82dpxEM10w/StRkGQk9J1DdravdXDds34X8/hsA7b2FK3T0kxuyxjweTy94mZH+4swiAyZ1OL40mNfy/j9l7e1QydDoHI3Otjbg7TxxSKWZMCH07nlXEYiOxMDd7qfF6fpUNDPPAHq/F6e3UwBY2ohw25V7XiMsnBiDMAKO5HpzHUEX3/EvN75xOK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC1913B4DAE40F4E984CAAD8757FF6B1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3610
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT016.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(346002)(1110001)(339900001)(199004)(189003)(486006)(105606002)(126002)(2906002)(58126008)(70586007)(5660300002)(316002)(229853002)(3846002)(6486002)(54906003)(50466002)(70206006)(6512007)(47776003)(31686004)(76130400001)(15650500001)(6116002)(31696002)(2616005)(476003)(36756003)(8676002)(81166006)(14454004)(81156014)(25786009)(478600001)(11346002)(26005)(446003)(6246003)(110136005)(26826003)(14444005)(436003)(8936002)(2501003)(22756006)(2486003)(23676004)(450100002)(99286004)(66066001)(4326008)(305945005)(6506007)(102836004)(65956001)(53546011)(386003)(356004)(76176011)(65806001)(7736002)(336012)(186003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3832;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: f81e3000-72ed-4291-94a9-08d75edbc56a
NoDisclaimer: True
X-Forefront-PRVS: 020877E0CB
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zy69OZLFBhKPsfn98Pdj0NLCsz7PLXx7AjrnFJc9X1uaQYYPHa1UZI2pgWcxTwA8XaTdtNbmQZIgdIgJSQXnMCrS5cRVJYkHA4S5S2TbITZEvvGuyKUMSuE12exRVocVTXZ6W5VOjnN4/6fXkjK63PLbNaX9PTNcUMyv56zpKdX5bzZTvQ8GNZpzXr0q/My2e2G+kMhmEuvY+J/CRh4sJTQZysoPnLlsfGrt2ZYy1DDOn5uXcNx64G3ZoR4Tq/jd0Q/PZgUnVjb6xW7FWYtlKLOkOyS26vo0frBSom57/K3tfsxmaPhYVXN/kXju8G/SGrqFF/K6v9ncLwdjxqHNGy6aGP5kw44/3NoUOUnF0DV2asP8qf87kqIfn4CP2JfXE12leAPq3x+VhORfO9syaW7sxNB61qA/Kw6vHM5pXtgNfX3nhQ+Lus9lL365cMNg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2019 14:57:18.8002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78407f62-3380-4ed7-299c-08d75edbcac7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3832
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMzEvMTAvMjAxOSAxMTozNiwgQ2hyaXN0aWFuIEJyYXVuZXIgd3JvdGU6DQo+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvc2NoZWQuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9zY2hl
ZC5oDQo+IGluZGV4IDk5MzM1ZTFmNGEyNy4uMjViNGZhMDBiYWQxIDEwMDY0NA0KPiAtLS0gYS9p
bmNsdWRlL3VhcGkvbGludXgvc2NoZWQuaA0KPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvc2No
ZWQuaA0KPiBAQCAtNTEsNiArNTEsMTAgQEANCj4gICAqICAgICAgICAgICAgICAgc2VudCB3aGVu
IHRoZSBjaGlsZCBleGl0cy4NCj4gICAqIEBzdGFjazogICAgICAgU3BlY2lmeSB0aGUgbG9jYXRp
b24gb2YgdGhlIHN0YWNrIGZvciB0aGUNCj4gICAqICAgICAgICAgICAgICAgY2hpbGQgcHJvY2Vz
cy4NCj4gKyAqICAgICAgICAgICAgICAgTm90ZSwgQHN0YWNrIGlzIGV4cGVjdGVkIHRvIHBvaW50
IHRvIHRoZQ0KPiArICogICAgICAgICAgICAgICBsb3dlc3QgYWRkcmVzcy4gVGhlIHN0YWNrIGRp
cmVjdGlvbiB3aWxsIGJlDQo+ICsgKiAgICAgICAgICAgICAgIGRldGVybWluZWQgYnkgdGhlIGtl
cm5lbCBhbmQgc2V0IHVwDQo+ICsgKiAgICAgICAgICAgICAgIGFwcHJvcHJpYXRlbHkgYmFzZWQg
b24gQHN0YWNrX3NpemUuDQo+ICAgKiBAc3RhY2tfc2l6ZTogIFRoZSBzaXplIG9mIHRoZSBzdGFj
ayBmb3IgdGhlIGNoaWxkIHByb2Nlc3MuDQo+ICAgKiBAdGxzOiAgICAgICAgIElmIENMT05FX1NF
VFRMUyBpcyBzZXQsIHRoZSB0bHMgZGVzY3JpcHRvcg0KPiAgICogICAgICAgICAgICAgICBpcyBz
ZXQgdG8gdGxzLg0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2ZvcmsuYyBiL2tlcm5lbC9mb3JrLmMN
Cj4gaW5kZXggYmNkZjUzMTI1MjEwLi41NWFmNjkzMWM2ZWMgMTAwNjQ0DQo+IC0tLSBhL2tlcm5l
bC9mb3JrLmMNCj4gKysrIGIva2VybmVsL2ZvcmsuYw0KPiBAQCAtMjU2MSw3ICsyNTYxLDM1IEBA
IG5vaW5saW5lIHN0YXRpYyBpbnQgY29weV9jbG9uZV9hcmdzX2Zyb21fdXNlcihzdHJ1Y3Qga2Vy
bmVsX2Nsb25lX2FyZ3MgKmthcmdzLA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+IC1zdGF0
aWMgYm9vbCBjbG9uZTNfYXJnc192YWxpZChjb25zdCBzdHJ1Y3Qga2VybmVsX2Nsb25lX2FyZ3Mg
KmthcmdzKQ0KPiArLyoqDQo+ICsgKiBjbG9uZTNfc3RhY2tfdmFsaWQgLSBjaGVjayBhbmQgcHJl
cGFyZSBzdGFjaw0KPiArICogQGthcmdzOiBrZXJuZWwgY2xvbmUgYXJncw0KPiArICoNCj4gKyAq
IFZlcmlmeSB0aGF0IHRoZSBzdGFjayBhcmd1bWVudHMgdXNlcnNwYWNlIGdhdmUgdXMgYXJlIHNh
bmUuDQo+ICsgKiBJbiBhZGRpdGlvbiwgc2V0IHRoZSBzdGFjayBkaXJlY3Rpb24gZm9yIHVzZXJz
cGFjZSBzaW5jZSBpdCdzIGVhc3kgZm9yIHVzIHRvDQo+ICsgKiBkZXRlcm1pbmUuDQo+ICsgKi8N
Cj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBjbG9uZTNfc3RhY2tfdmFsaWQoc3RydWN0IGtlcm5lbF9j
bG9uZV9hcmdzICprYXJncykNCj4gK3sNCj4gKwlpZiAoa2FyZ3MtPnN0YWNrID09IDApIHsNCj4g
KwkJaWYgKGthcmdzLT5zdGFja19zaXplID4gMCkNCj4gKwkJCXJldHVybiBmYWxzZTsNCj4gKwl9
IGVsc2Ugew0KPiArCQlpZiAoa2FyZ3MtPnN0YWNrX3NpemUgPT0gMCkNCj4gKwkJCXJldHVybiBm
YWxzZTsNCj4gKw0KPiArCQlpZiAoIWFjY2Vzc19vaygodm9pZCBfX3VzZXIgKilrYXJncy0+c3Rh
Y2ssIGthcmdzLT5zdGFja19zaXplKSkNCj4gKwkJCXJldHVybiBmYWxzZTsNCj4gKw0KPiArI2lm
ICFkZWZpbmVkKENPTkZJR19TVEFDS19HUk9XU1VQKSAmJiAhZGVmaW5lZChDT05GSUdfSUE2NCkN
Cj4gKwkJa2FyZ3MtPnN0YWNrICs9IGthcmdzLT5zdGFja19zaXplOw0KPiArI2VuZGlmDQo+ICsJ
fQ0KDQpmcm9tIHRoZSBkZXNjcmlwdGlvbiBpdCBpcyBub3QgY2xlYXIgd2hvc2UNCnJlc3BvbnNp
YmlsaXR5IGl0IGlzIHRvIGd1YXJhbnRlZSB0aGUgYWxpZ25tZW50DQpvZiBzcCBvbiBlbnRyeS4N
Cg0KaSB0aGluayAwIHN0YWNrIHNpemUgbWF5IHdvcmsgaWYgc2lnbmFscyBhcmUNCmJsb2NrZWQg
YW5kIHRoZW4gcHJvaGliaXRpbmcgaXQgbWlnaHQgbm90IGJlDQp0aGUgcmlnaHQgdGhpbmcuDQoN
Cml0J3Mgbm90IGNsZWFyIGhvdyBsaWJjIHNob3VsZCBkZWFsIHdpdGggdjUuMw0Ka2VybmVscyB3
aGljaCBkb24ndCBoYXZlIHRoZSBzdGFjays9c3RhY2tfc2l6ZQ0KbG9naWMuDQo=
