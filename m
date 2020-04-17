Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AAC1AD427
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 03:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgDQBar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 21:30:47 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45044 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727879AbgDQBar (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 21:30:47 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0FEFEC008C;
        Fri, 17 Apr 2020 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587087046; bh=92YYRqQ7APIXWAOb5Kb0RTa5cdSM+NP2pSTwuJjtgVc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=MeYL/p/3iQelBSAZ02BymvvkoFj8qBRQHk4AdNzRVw7itQeZoukcCUKJvr9l5XUkk
         2dUi4iie4dU/tpKwgmP8Eu8/6ONVrnr9q5f/ab7FIwX3DJdzOVCbXxMQs/7aldrQOI
         KqfDCtPgu6NFEQKb1aAY534yVyU+Hd20uXfRwJ+7ju4EkTPc9r/F7kdZdA47icrQNv
         I+mtI8d2Eld/5X1KxgdS9VaBrAHsyaPPOPaYxqMWAwtLvSUybclX6y+0anc/B1EcGA
         RY8zMti3K74+3M/7cr8Vb1uook6l9EaEVREpy1gXCo6ssLCv48jXQibAra1qzu4lnE
         nJoRzCfXhgyDA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 76B0CA008A;
        Fri, 17 Apr 2020 01:30:45 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 16 Apr 2020 18:29:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 16 Apr 2020 18:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6iI7Yugvm5hcMoLoGbtCRZ1wFpNDIK7PSPCJ4VDhgAGvVngsbVITFD3UbmBmg3zslYK5Uaia0tV6c7moKOMynJ3IxtdPwjr8w1j/RlLSVurGPuVjXYfP+IhT+opbFv44I1d6BARKlodpu1Xvam3kTXt+K00JyBHJl2rtVrU0t1xfLCjF4UReAga/tizNgYnbnYJ/nm4eKxIcpQcjik2YB87V3eYj5cX8AasuBS0RlvXIBd5N+V8VzlnglmuOi0z5yVGNw4caIJFTF0b8a7W8R1VEIadRrp8A2fcSNNxGc2JrjuAK0AjwPXw+MJwimA/G1VeFKLbcZP4T3uhmO3K+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92YYRqQ7APIXWAOb5Kb0RTa5cdSM+NP2pSTwuJjtgVc=;
 b=i/BOzQmZ7x+BnXAJDVOLWe4CSJL2hyxCize9+JzEknDvDP/ATYbaLSLr67RrY3i6nzYthYfBPkBUs3KX8KgUPhrrtByRPj5Z/HQABmsvwxAcWBcx931YRGUGm9btMWnQDOPAAFtciGVgfNWyzfwPl3ayYNoXUqDTa1pHYRsijFENfaMEdQao7Ic6Rv1WD27jnEC0vG6739iwdXC8D+EzllOH4XOkQuVxfL+4oZfLh24cX+mKfBUmphzS4jrtyOIvjKxxOhxze3k8jVheYPlD3g8GBm+I6Lo639Hs5BLi3eW6zJaQgvHGsXzzqvH7VR/UKQGwnIiP8zpnAMSan9/ZWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92YYRqQ7APIXWAOb5Kb0RTa5cdSM+NP2pSTwuJjtgVc=;
 b=MkFuYtXbJIMYYrnxHjhjSDHFtm+0bygXBUA70UE5UTH19eS5E95kDN4MmI8TkgtkW6ZzKUG6WBOS2h1ujzGVDWAYN4U1Dq4JEizQwf+LwlXOmOTUPzUyj27Sxk2Cm31tFqHsjtpq2ztwFRTiRmkErZyg+cMO29bf01LGQLYbztM=
Received: from BYAPR12MB2917.namprd12.prod.outlook.com (2603:10b6:a03:130::14)
 by BYAPR12MB3544.namprd12.prod.outlook.com (2603:10b6:a03:131::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Fri, 17 Apr
 2020 01:29:47 +0000
Received: from BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3860:a61:5aeb:a248]) by BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3860:a61:5aeb:a248%7]) with mapi id 15.20.2900.028; Fri, 17 Apr 2020
 01:29:47 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Fix request completion check
Thread-Topic: [PATCH v2 1/2] usb: dwc3: gadget: Fix request completion check
Thread-Index: AQHWBzgjYE0rpmq7/Eun5jRlryeIBah8oOuA
Date:   Fri, 17 Apr 2020 01:29:47 +0000
Message-ID: <5cdcb770-fb6a-14fe-e652-857234c9f69c@synopsys.com>
References: <bed19f474892bb74be92b762c6727a6a7d0106e4.1585643834.git.thinhn@synopsys.com>
In-Reply-To: <bed19f474892bb74be92b762c6727a6a7d0106e4.1585643834.git.thinhn@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.7.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ccfea6b-c321-425c-9e08-08d7e26ed11c
x-ms-traffictypediagnostic: BYAPR12MB3544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB354438FD7EACA3F4226D02EBAAD90@BYAPR12MB3544.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2917.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(81156014)(8676002)(316002)(31686004)(71200400001)(6506007)(4326008)(8936002)(26005)(186003)(86362001)(31696002)(6486002)(5660300002)(6512007)(36756003)(2616005)(66446008)(478600001)(76116006)(64756008)(66476007)(54906003)(66946007)(66556008)(2906002)(110136005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PCQn8EGJ0U7yC/lBaISuoMyiY4BtazfSsHHb5Mm1T+Om9+4SgHcsrasqCN2vxi6twOpPnhFqT/D+A82d/4Z/CzRDScmmV1NbLPXQLwxlim7dr69t4hwjO1U2Cy3bFnfBrFM2uGJ5jmftdHZAuk/kEWKWroUGOVJSMBbgc56HsgeRxstTEH2zvq6yegBZzZ5q9/8AuuibVBMmmQxDL4aeqGomwiJoiGfXlK8WGsOIwq+ziMDrDFvitFiatu95X+dUABxh31UyFesmeAYvF1x2Hxs9N6URDoblV1tMDwsmKEktUY2/G92HAbCBpWa19PaRMDqYaDrL4m+JxWm7jtKCVnKctHyTc8fOSofht7OcR5daFNwLpU5KW5Snju+4UGkuzRiLd/F9eoVkt01Jt9qEePtF40V93uJKxvBdxpXe9k9fNnnIG3qozV7wT4ojeCOt
x-ms-exchange-antispam-messagedata: vJHkcqKFOO4nNf/mEMOM3i31OPV1D8ZAUAI465ePtwkW71b1c7wHaGJ9Vfwlh44GQAc8Ce0olJrmgYsQRuMGRXXRPkMYCMcoPnNBKT0/qiRzL4QVhN+aTMojVMB7h1pIOqXPgTzka50qgCyN/bzDNA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3329E75DEEE1514E98FBE5D7958E0C4D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccfea6b-c321-425c-9e08-08d7e26ed11c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 01:29:47.7618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9H+DEU6AOnYVN47eTntpKyQhiZr0aeMyl8HymVLeNpZBiyqjOdG7+IVaKXQtPBDUZAnbKrbbnAWmq2LubECSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3544
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+IEEgcmVxdWVzdCBtYXkgbm90IGJl
IGNvbXBsZXRlZCBiZWNhdXNlIG5vdCBhbGwgdGhlIFRSQnMgYXJlIHByZXBhcmVkIGZvcg0KPiBp
dC4gVGhpcyBoYXBwZW5zIHdoZW4gd2UgcnVuIG91dCBvZiBhdmFpbGFibGUgVFJCcy4gV2hlbiBz
b21lIFRSQnMgYXJlDQo+IGNvbXBsZXRlZCwgdGhlIGRyaXZlciBuZWVkcyB0byBwcmVwYXJlIHRo
ZSByZXN0IG9mIHRoZSBUUkJzIGZvciB0aGUNCj4gcmVxdWVzdC4gVGhlIGNoZWNrIGR3YzNfZ2Fk
Z2V0X2VwX3JlcXVlc3RfY29tcGxldGVkKCkgc2hvdWxkbid0IGJlDQo+IGNoZWNraW5nIHRoZSBh
bW91bnQgb2YgZGF0YSByZWNlaXZlZCBidXQgcmF0aGVyIHRoZSBudW1iZXIgb2YgcGVuZGluZw0K
PiBUUkJzLiBSZXZpc2UgdGhpcyByZXF1ZXN0IGNvbXBsZXRpb24gY2hlY2suDQo+DQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+IEZpeGVzOiBlMGM0MmNlNTkwZmUgKCJ1c2I6IGR3YzM6
IGdhZGdldDogc2ltcGxpZnkgSU9DIGhhbmRsaW5nIikNCj4gU2lnbmVkLW9mZi1ieTogVGhpbmgg
Tmd1eWVuIDx0aGluaG5Ac3lub3BzeXMuY29tPg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4g
ICAtIEFkZCBDYzogc3RhYmxlIHRhZw0KPg0KPiAgIGRyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMg
fCAxMiArKy0tLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
MCBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0
LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IGluZGV4IDFhNGZjMDM3NDJhYS4uYzQ1
ODUzYjE0Y2ZmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+ICsr
KyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gQEAgLTI1NTAsMTQgKzI1NTAsNyBAQCBz
dGF0aWMgaW50IGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fdHJiX2xpbmVhcihzdHJ1Y3QgZHdjM19l
cCAqZGVwLA0KPiAgIA0KPiAgIHN0YXRpYyBib29sIGR3YzNfZ2FkZ2V0X2VwX3JlcXVlc3RfY29t
cGxldGVkKHN0cnVjdCBkd2MzX3JlcXVlc3QgKnJlcSkNCj4gICB7DQo+IC0JLyoNCj4gLQkgKiBG
b3IgT1VUIGRpcmVjdGlvbiwgaG9zdCBtYXkgc2VuZCBsZXNzIHRoYW4gdGhlIHNldHVwDQo+IC0J
ICogbGVuZ3RoLiBSZXR1cm4gdHJ1ZSBmb3IgYWxsIE9VVCByZXF1ZXN0cy4NCj4gLQkgKi8NCj4g
LQlpZiAoIXJlcS0+ZGlyZWN0aW9uKQ0KPiAtCQlyZXR1cm4gdHJ1ZTsNCj4gLQ0KPiAtCXJldHVy
biByZXEtPnJlcXVlc3QuYWN0dWFsID09IHJlcS0+cmVxdWVzdC5sZW5ndGg7DQo+ICsJcmV0dXJu
IHJlcS0+bnVtX3BlbmRpbmdfc2dzID09IDA7DQo+ICAgfQ0KPiAgIA0KPiAgIHN0YXRpYyBpbnQg
ZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdChzdHJ1Y3QgZHdjM19lcCAq
ZGVwLA0KPiBAQCAtMjU4MSw4ICsyNTc0LDcgQEAgc3RhdGljIGludCBkd2MzX2dhZGdldF9lcF9j
bGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0KHN0cnVjdCBkd2MzX2VwICpkZXAsDQo+ICAgDQo+ICAg
CXJlcS0+cmVxdWVzdC5hY3R1YWwgPSByZXEtPnJlcXVlc3QubGVuZ3RoIC0gcmVxLT5yZW1haW5p
bmc7DQo+ICAgDQo+IC0JaWYgKCFkd2MzX2dhZGdldF9lcF9yZXF1ZXN0X2NvbXBsZXRlZChyZXEp
IHx8DQo+IC0JCQlyZXEtPm51bV9wZW5kaW5nX3Nncykgew0KPiArCWlmICghZHdjM19nYWRnZXRf
ZXBfcmVxdWVzdF9jb21wbGV0ZWQocmVxKSkgew0KPiAgIAkJX19kd2MzX2dhZGdldF9raWNrX3Ry
YW5zZmVyKGRlcCk7DQo+ICAgCQlnb3RvIG91dDsNCj4gICAJfQ0KDQpTaW5jZSB5b3UnbGwgYmUg
cGlja2luZyB0aGlzIHVwIGZvciB0aGUgcmMgY3ljbGUgZm9yIHlvdXIgZml4IHBhdGNoZXMsIA0K
c2hvdWxkIEkgc3BsaXQgdGhpcyBzZXJpZXMgdG8gcmVzZW5kIGFuZCB3YWl0IGZvciB0aGlzIHBh
dGNoIHRvIGJlIA0KbWVyZ2VkIGZpcnN0IGJlZm9yZSBJIHJlc2VuZCB0aGUgcGF0Y2ggMi8yPw0K
TGV0IG1lIGtub3cgaG93IHlvdSdkIGxpa2UgdG8gcHJvY2VlZC4NCg0KVGhhbmtzLA0KVGhpbmgN
Cg==
