Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23222104C7
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgGAHQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 03:16:21 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43332 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgGAHQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 03:16:21 -0400
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 09845C0349;
        Wed,  1 Jul 2020 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1593587780; bh=m+idlSgNiT1NtwZx1babGcISPQeVwnYqrDR8Kx4WDIw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=j33vLmOorpptfDRphYChjwBFXHSj/Br5Z3cFrmBX4zSpK1Iq2SLxcQUFz7oFqJHJu
         fCFeV+5cZl5NPnl9yMr0DcfeUsKRPaRAmIriLONh+sz9MOPym5GQOG3NggRTO5VeoQ
         +tQmB352o33TC5d2ubKwealVJ4rygSomTvELYQYSGhPry6vtYDyy3uLN+FDhuJjDME
         vNmwdNBWlRHkgWrR0Kibe6i55D4O7ZgiNNQNEkdEO53z423BTYgG9NhJiCYM2+Th+b
         IOumlize7JZCGn89jo3/rIPa+ATLxd/ZTc+8qXqtWjg7nHKR2qLh32aXSTYt0Nw9ST
         eggsza0mjQtnA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C08F7A0084;
        Wed,  1 Jul 2020 07:16:17 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id F37514017A;
        Wed,  1 Jul 2020 07:16:15 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=hminas@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ssUTWnsB";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5EYGJM02Yrz5KhyAhNw7bNwRRERg5H7YAFJ6LasVH+uoVvjN1CEPvwC0bxPnzfwRiDm/W9hG78KNhkZKqHBXc7gYCKOd/fubzefbLFS94GvTR0UcQq/JheamOB+b8tPx+XENyhP/b1iZWvP4UH+mlV0RSnAf7kQKqHHUYcqnG5UTqad/9eqpXR1JMLgLtgC+niRQWPVT+JFQo4DYwkA07Z0JUAuePBboJW11X7kip9NlaFCaBv0NXtN/P/utM63tN16QscQl9K4x3Lzzy+8jM9A7QNTgp6XiYHWtkUALGnvECOwtRLc8wJJ+QJH03OdJjn9/VSF4FH3H0iajhdFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+idlSgNiT1NtwZx1babGcISPQeVwnYqrDR8Kx4WDIw=;
 b=N6IF2rYAHrUk+aQyzxPfDxXdKPSV2bQRewHXCJp6pxspPjxkinnsQYMBpr71LJXYsNhqGeqVmWmlKFAMhfPh2OAUDHoOFGisbGJYBmxm1H+8AM2CxHJx+dXgRedio9LoHOZqCQrkEaIJBRFuwwRfq8qQnCcJImEiA43MkIyo1C692nEuYtMn0Cy0z6YMIrvBpLQyMTSEnvZsI2swdSeGX1J5TLnPOcqiMb51IlQSDGPlfJMZ7+A2QvLoNFaiB+K3D98Pc0MkUmDm8K6COxKLfYjjoSrL/OissqjkhltFbtMpxg4F0168ATxKWFthgPoN2ncBiVHy1uGAz2lVJ4ttug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+idlSgNiT1NtwZx1babGcISPQeVwnYqrDR8Kx4WDIw=;
 b=ssUTWnsBg4MFf8uTu1Hx1Q7dBmlGIkf0AI8n/AbyVs5WdYuhv3zKgAN9BHzCmNBoSzvZqFm4Nded6dFVqxdVQI65lBq/PDUwB8rmwVPhGwGG4rhGaJ9sEdThHFrIKDn8KZ+RHo0qq+t8jdsyFaVdGjCKKq9+ckyFyirUKB0WMM4=
Received: from CY4PR12MB1432.namprd12.prod.outlook.com (2603:10b6:903:44::11)
 by CY4PR12MB1640.namprd12.prod.outlook.com (2603:10b6:910:11::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 1 Jul
 2020 07:16:14 +0000
Received: from CY4PR12MB1432.namprd12.prod.outlook.com
 ([fe80::3cb9:e2f2:a4ff:14bd]) by CY4PR12MB1432.namprd12.prod.outlook.com
 ([fe80::3cb9:e2f2:a4ff:14bd%10]) with mapi id 15.20.3153.020; Wed, 1 Jul 2020
 07:16:14 +0000
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marex@denx.de" <marex@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [RFC for-5.8] usb: dwc2: Cleanup debugfs when
 usb_add_gadget_udc() fails
Thread-Topic: [RFC for-5.8] usb: dwc2: Cleanup debugfs when
 usb_add_gadget_udc() fails
Thread-Index: AQHWTj+WdJa7ovkKfUm4iPONUJfWFKjyUoGA
Date:   Wed, 1 Jul 2020 07:16:14 +0000
Message-ID: <0ba4b7ce-3551-0453-bac7-4d86c53dd2e8@synopsys.com>
References: <20200629180314.2878638-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20200629180314.2878638-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
authentication-results: googlemail.com; dkim=none (message not signed)
 header.d=none;googlemail.com; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 972f5d82-76c3-4693-9dbf-08d81d8ea3d5
x-ms-traffictypediagnostic: CY4PR12MB1640:
x-microsoft-antispam-prvs: <CY4PR12MB16401368CAE8918305F97E70A76C0@CY4PR12MB1640.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gLhR94f3NPnk2sQwyW/9CrpGF1fXJ2qYyS+uqnI35q8a8Ee7Lg8lBjoKyQ0uiBd6a+RBI9L84J+OlZpXhPWk1e87jQI9SRlDDi2+qcHFr0+wFISaXc0mHHthAbF5TPZZsjabAJM6ZrA5IiofDOonKMDPjoTAvytHSUTht5s8LMm+bxPWjA+sB0uOS7+3MhET4qTUnwlMgIwdyC7tBc1t+h5IA7dHFTdr6/hp+Nk34d4ZzPWS9jHh/m/TouuSAZAhitvqxjwkpM5mx7Sr/XScRhjnUjM5I/OcI2negNeX7c5ChY/USlKXxbzSa5u2cqURRRpH7qT8/97zJDJKMrRVmfzaWYhS+yhyUIOT8BJVTqt1AV0yx6qkMGAyFKXDUcYQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(396003)(39860400002)(376002)(346002)(86362001)(8936002)(6512007)(2906002)(4326008)(26005)(5660300002)(31686004)(66946007)(31696002)(2616005)(76116006)(478600001)(66556008)(66446008)(64756008)(66476007)(6506007)(53546011)(186003)(91956017)(36756003)(6486002)(71200400001)(54906003)(83380400001)(110136005)(8676002)(316002)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OhyjSswetl5KRtd9/ueYzb7I9w+CILNplaaF3JmMNa7OdnzwBtrqrMeg/CK5pI8y4n681dzPckTpQcE1BVwwN+sTsNZIOkV/7bLO80LYfjX8VXIt1KzK1bTpJUz3NNAFzRO41kvFdTm20wjPKmuy1xTnh0bRHEWvqC+BxR/JGoaOdu+Wu3Bw9s0zInF+jhBpePXXFx5N/iYyhcSBztQzrI1F+GSgOeRn0/IyqFWnJmqvDGqwc8Ck2bjDgsP1wV/7BBivhP8wJIl79tCgyQCRq5uNZT2uPuJWvcSIFoGeeh+CrlmhagVKjhKWSxlV+8AqvyA/1RtEX4mXAPDPmm3BNc5X0UlcT1KUMsEERMpDP4E4QJO72EuDifKBHW5eAbScrgR5MlGCwg86f353D9Ggnk/FzSQY+WK3sdF/5RKD/xfh27q9FYr/D7zZLeI7VdboN1Z8Ap1vmeBBWWfHMJWTVprfvbuIxuwodsw/bqWNcJZS+wA82uqxVPptoAcLPMA+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAF879171D06FA4FB0E2AF7837CEBF49@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 972f5d82-76c3-4693-9dbf-08d81d8ea3d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 07:16:14.2473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WOq2zwKcqbnU1iQeXw1fKOiV6BYBHVICPM/kYKDdUXxbRr0qfbkZdMIFhA3ldeafyWhSZRsXxyqJYRbeT2RfZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1640
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWFydGluLA0KDQpPbiA2LzI5LzIwMjAgMTA6MDMgUE0sIE1hcnRpbiBCbHVtZW5zdGluZ2wg
d3JvdGU6DQo+IENhbGwgZHdjMl9kZWJ1Z2ZzX2V4aXQoKSB3aGVuIHVzYl9hZGRfZ2FkZ2V0X3Vk
YygpIGhhcyBmYWlsZWQuIFRoaXMNCj4gZW5zdXJlIHRoYXQgdGhlIGRlYnVnZnMgZW50cmllcyBj
cmVhdGVkIGJ5IGR3YzJfZGVidWdmc19pbml0KCkgYXJlDQo+IGNsZWFuZWQgdXAgaW4gdGhlIGVy
cm9yIHBhdGguDQo+IA0KPiBGaXhlczogMjA3MzI0YTMyMWE4NjYgKCJ1c2I6IGR3YzI6IFBvc3Rw
b25lZCBnYWRnZXQgcmVnaXN0cmF0aW9uIHRvIHRoZSB1ZGMgY2xhc3MgZHJpdmVyIikNCj4gU2ln
bmVkLW9mZi1ieTogTWFydGluIEJsdW1lbnN0aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29n
bGVtYWlsLmNvbT4NCj4gLS0tDQo+IFRoaXMgcGF0Y2ggaXMgY29tcGlsZS10ZXN0ZWQgb25seS4g
SSBmb3VuZCB0aGlzIHdoaWxlIHRyeWluZyB0bw0KPiB1bmRlcnN0YW5kIHRoZSBsYXRlc3QgY2hh
bmdlcyB0byBkd2MyL3BsYXRmb3JtLmMuDQo+IA0KPiANCj4gICBkcml2ZXJzL3VzYi9kd2MyL3Bs
YXRmb3JtLmMgfCA0ICsrKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9y
bS5jIGIvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9ybS5jDQo+IGluZGV4IGMzNDdkOTNlYWU2NC4u
MDJiNmRhN2UyMWQ3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMN
Cj4gKysrIGIvZHJpdmVycy91c2IvZHdjMi9wbGF0Zm9ybS5jDQo+IEBAIC01ODIsMTIgKzU4Miwx
NCBAQCBzdGF0aWMgaW50IGR3YzJfZHJpdmVyX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KmRldikNCj4gICAJCXJldHZhbCA9IHVzYl9hZGRfZ2FkZ2V0X3VkYyhoc290Zy0+ZGV2LCAmaHNv
dGctPmdhZGdldCk7DQo+ICAgCQlpZiAocmV0dmFsKSB7DQo+ICAgCQkJZHdjMl9oc290Z19yZW1v
dmUoaHNvdGcpOw0KPiAtCQkJZ290byBlcnJvcl9pbml0Ow0KPiArCQkJZ290byBlcnJvcl9kZWJ1
Z2ZzOw0KPiAgIAkJfQ0KPiAgIAl9DQo+ICAgI2VuZGlmIC8qIENPTkZJR19VU0JfRFdDMl9QRVJJ
UEhFUkFMIHx8IENPTkZJR19VU0JfRFdDMl9EVUFMX1JPTEUgKi8NCj4gICAJcmV0dXJuIDA7DQo+
ICAgDQo+ICtlcnJvcl9kZWJ1Z2ZzOg0KPiArCWR3YzJfZGVidWdmc19leGl0KGhzb3RnKTsNCj4g
ICBlcnJvcl9pbml0Og0KPiAgIAlpZiAoaHNvdGctPnBhcmFtcy5hY3RpdmF0ZV9zdG1faWRfdmJf
ZGV0ZWN0aW9uKQ0KPiAgIAkJcmVndWxhdG9yX2Rpc2FibGUoaHNvdGctPnVzYjMzZCk7DQo+IA0K
SSdtIE9rIHdpdGggdGhpcyBmaXguIE9uZSBtb3JlIHRoaW5nLiBJIG1pc3NlZCB0byByZW1vdmUg
aGNkIGFsc28gaW4gDQpmYWlsIGNhc2UuIENvdWxkIHlvdSBwbGVhc2UgYWRkIGR3YzJfaGNkX3Jl
bW92ZSgpIGNhbGwgYWZ0ZXIgDQpkd2MyX2RlYnVnZnNfZXhpdChoc290ZykgYW5kIHN1Ym1pdCBh
cyBwYXRjaDoNCg0KK2Vycm9yX2RlYnVnZnM6DQorCWR3YzJfZGVidWdmc19leGl0KGhzb3RnKTsN
CisJaWYgKGhzb3RnLT5oY2RfZW5hYmxlZCkNCisJCWR3YzJfaGNkX3JlbW92ZShoc290Zyk7DQog
ICBlcnJvcl9pbml0Og0KDQoNClRoYW5rcywNCk1pbmFzDQo=
