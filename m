Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A98214439
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 07:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgGDF7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 01:59:01 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:42484 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgGDF7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 01:59:01 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5624840703;
        Sat,  4 Jul 2020 05:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1593842340; bh=2DFnoxwgarmbOhrayPQSopqOP01B4VH4Aa4YouvuazI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=k3LgJFiXxkE+xL8p2bqB+X1EQC+baNx3xu5JEkgwmgssIAFuWSCu+8kV2IAaZcG4S
         4f7j9mGW5V8qlLybuJU+Gzb8/YR5kYSJ6iA+qdJnue0N+fv2xUT3xIguqE7b2BjtvC
         pqiwC8HyATCK/xXU0ZGGSbZ+bi9K/T73BhRP/WXdt+O2GYvBO2K7Iy84odNLImnfAQ
         0E2RuZRk9+pmnoHi4LBaOcMEVhhzt/tidpK+Ux5zqAPoLWN3BcTaaaqW2DqkZ3azEU
         fRjehrwMswsvXRzP8y9d/cKmWdFxWXiM+zLGDxeTcPsAXQHQuhu1jnveY7SV+mBko0
         L86TEzOEBnJZw==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0A326A006F;
        Sat,  4 Jul 2020 05:58:58 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id AB02140140;
        Sat,  4 Jul 2020 05:58:57 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=hminas@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="B3dxDbNi";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMqFFZN9HbztRJh0D6eKPY1ir1wmnvIVfg+ePPHYRT26PR4uKkejyeyayK+VhL2HO/2astQHLN9p/m6tmd5EZu6INlPLDI8ITL1ctxcrElZPc/16eDG/TnUgjJPhHlGa3px9cKLpjyERluxSuK6iPf6Z1BbR5kLB4fSOge+fb41e1jmmtPJ7rToRKMyqkkfb/gqYA/+JJS94/80QKRpEkkPhD4AF2bbIt7uDfhh9NvwvW9YEY7ne+MQqhETib11KjdvSfovfjMC+bD9m4Eej9sSaex/3FHYtbOfcoEB0EePudA+dBNeNzsTzubqHloDNMvagFjRsMUthKuI1wZINAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DFnoxwgarmbOhrayPQSopqOP01B4VH4Aa4YouvuazI=;
 b=oLdd8i268AYCoSS2kqmBQRc+nVEJbwXhjSaUe7VN+f/2Y21V1fPEjpC22LeXkKWHWn4ADqP2kxW83DfOvujzO4z3va3v+EphrDHDN5QDvAhrIdiCNU+Y9DKcggyBij30+BpVD5TxLNyux2CBwdvMwkQmvhXDEkMo98WitXu2qaDxzPFwy0tdhvbYEh6vK+g9/L0C9RLjPGSm8FPyh8RNJOh8IGVF3T2gOrO3cBfVR3H7N7uDhzr2s0QQ7g7foJpzy6wCQqe+68egwj8mB5WPs/nRXewHg5yGjRHhWdGNXj8itqSEe/Ze7gIAfM6KSN95q2ukpwg8U3NYFqFoExeaZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DFnoxwgarmbOhrayPQSopqOP01B4VH4Aa4YouvuazI=;
 b=B3dxDbNi3dDyIxy+rFlz62Ijj/zyRe6B9fvJwvUYseCjWCQfLEQQXMamk0vkPmvbZqbFqc1FmTx5jIWuVQpAgsw8EuTQiqsN2Jm0rh0DdFtrC3nrZQA4ndZd4yi4ahotSPLDbQOgB+FXN1BahJHPcbaoyxSyN1JAIMYtxMlkYCw=
Received: from BN6PR12MB1428.namprd12.prod.outlook.com (2603:10b6:404:21::16)
 by BN8PR12MB2993.namprd12.prod.outlook.com (2603:10b6:408:63::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sat, 4 Jul
 2020 05:58:55 +0000
Received: from BN6PR12MB1428.namprd12.prod.outlook.com
 ([fe80::acae:5636:6c75:f922]) by BN6PR12MB1428.namprd12.prod.outlook.com
 ([fe80::acae:5636:6c75:f922%11]) with mapi id 15.20.3153.028; Sat, 4 Jul 2020
 05:58:55 +0000
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marex@denx.de" <marex@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for-5.8 v2] usb: dwc2: Add missing cleanups when
 usb_add_gadget_udc() fails
Thread-Topic: [PATCH for-5.8 v2] usb: dwc2: Add missing cleanups when
 usb_add_gadget_udc() fails
Thread-Index: AQHWUYxw1vGLRTulfUiy+Flpr+1fzKj27UwA
Date:   Sat, 4 Jul 2020 05:58:55 +0000
Message-ID: <9405e834-cae9-ee69-aa6b-77a8484e78ec@synopsys.com>
References: <20200703225043.387769-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20200703225043.387769-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: googlemail.com; dkim=none (message not signed)
 header.d=none;googlemail.com; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [37.252.92.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55f61316-53b4-4034-2e76-08d81fdf560f
x-ms-traffictypediagnostic: BN8PR12MB2993:
x-microsoft-antispam-prvs: <BN8PR12MB2993B6B5C40EC3DB2EE320A1A76B0@BN8PR12MB2993.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0454444834
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nJFIKVNsYl0hQ7//sgXzdlat/JR2SmYQiO1Bp0GPDLLax80hX/mC8giYcnmx87jmpoBjIZAX4nJKUcyExCClEWpY5NIBKoJ3lN/+eZLUIlogeSrNHn68juC4VaajQTnFTC8k8POtLyOTCjlfdLJFpM9gDeyCbDFW0DMxm78tTQB9xe4XAeFphpN/dEzuU4dXtomVI2RXg8dlGtp4srAphqmNhvngneWYj2/7R+aa//amG1Gu5UJf3XQHNi6Qf8H27RQyVhnBUChdC9iQ3BwYH7HfQ9MucKjtOyhVH+lD7HCyyrF+ui4MB/hjXFdxS0FY7hCJxyHrf+Zh918Vl9jbWVG8xtFoddLFjyR67PpZw+8mvwqVQNCfhS5e5FIYUWQS7Yw3Av8BsEaVNzTSeuzBvIxwAw7+5vvA2C59wp/CaQ0M/qKekEnHYikDqYli1fJ2LnFV1dZEfMlk0dbe+MxqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1428.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39850400004)(376002)(136003)(396003)(366004)(8676002)(6512007)(966005)(66446008)(64756008)(66556008)(66476007)(66946007)(186003)(478600001)(5660300002)(91956017)(76116006)(6486002)(53546011)(71200400001)(6506007)(31686004)(36756003)(316002)(4326008)(26005)(83380400001)(110136005)(2906002)(86362001)(2616005)(8936002)(31696002)(54906003)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5RTyNHnwTPDN30WBo0P4Pa5NO32xllb/Q2JBtfG9R2HOg7zYlKXPAY7uGuC16EU0Y+7ECziDYQFR1WAd2tlTSa7RrqMB+TSQMoURtd86ioz1OksNKBu8jNDSqaYbgtM4eC++JE0oDgs3ti+Z4Mn/hSD3DwDNgfN6hdMhcTi68HQ9F35YUJ1agiQWv2mAFKVrqenQPQfxAkX3XFQudzz4vl2VRJdqzPmr0E2/OUgx34xDuLWCLLiZS7hBWIPcmcT2kBBkAvL9qLmKFpF1Au0EoyFPLe5TJ25s+hRzt0Sk91JByPxnjzvRuCWSH5/C6LlcJPXKp9NpMIRAdtVUBLMeOFxvDoy6+gYohWW51IgjiQQzCSzok9KOrpJipRhLnZ+1UxCXfhQmkuAyKmxGsI5DGYGy+WiskE1Jc9ll7x45kR/fPAC6rM/t805++9UZNRmFDvPePwIdE6eWanTJxKbNXWg7li8QJ+ObQD2JoPsldJ8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <541C11321BF1C84CAB71EB98B055D3BB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR12MB1428.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f61316-53b4-4034-2e76-08d81fdf560f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2020 05:58:55.3349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5Y0LHZU9PkqSJjuehJKIePcXAjzJZ7ge/WEu00n+mXk3G/dVuCHMWteQZWXRX8DM+N2viDzL/Pps0Fz8haOdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2993
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDcvNC8yMDIwIDI6NTAgQU0sIE1hcnRpbiBCbHVtZW5zdGluZ2wgd3JvdGU6DQo+IENh
bGwgZHdjMl9kZWJ1Z2ZzX2V4aXQoKSBhbmQgZHdjMl9oY2RfcmVtb3ZlKCkgKGlmIHRoZSBIQ0Qg
d2FzIGVuYWJsZWQNCj4gZWFybGllcikgd2hlbiB1c2JfYWRkX2dhZGdldF91ZGMoKSBoYXMgZmFp
bGVkLiBUaGlzIGVuc3VyZXMgdGhhdCB0aGUNCj4gZGVidWdmcyBlbnRyaWVzIGNyZWF0ZWQgYnkg
ZHdjMl9kZWJ1Z2ZzX2luaXQoKSBhcyB3ZWxsIGFzIHRoZSBIQ0QgYXJlDQo+IGNsZWFuZWQgdXAg
aW4gdGhlIGVycm9yIHBhdGguDQo+IA0KPiBGaXhlczogMjA3MzI0YTMyMWE4NjYgKCJ1c2I6IGR3
YzI6IFBvc3Rwb25lZCBnYWRnZXQgcmVnaXN0cmF0aW9uIHRvIHRoZSB1ZGMgY2xhc3MgZHJpdmVy
IikNCj4gU2lnbmVkLW9mZi1ieTogTWFydGluIEJsdW1lbnN0aW5nbCA8bWFydGluLmJsdW1lbnN0
aW5nbEBnb29nbGVtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IE1pbmFzIEhhcnV0eXVueWFuIDxobWlu
YXNAc3lub3BzeXMuY29tPg0KDQo+IC0tLQ0KPiBDaGFuZ2VzIHNpbmNlIHYxIGF0IFswXQ0KPiAt
IGFsc28gY2xlYW51cCB0aGUgSENEIGFzIHN1Z2dlc3RlZCBieSBNaW5hcyAodGhhbmsgeW91ISkN
Cj4gLSB1cGRhdGVkIHRoZSBzdWJqZWN0IGFjY29yZGluZ2x5DQo+IA0KPiANCj4gWzBdIGh0dHBz
Oi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNo
LzExNjMxMzgxL19fOyEhQTRGMlI5R19wZyFLMFpKSXpZVll0cnd5MlZneFRJMjhaX3FBOTk1dXFt
ZzFkRnJNTngzWE1RNjUzUk9NS1BrdF96UWRKZTFPT2skDQo+IA0KPiANCj4gICBkcml2ZXJzL3Vz
Yi9kd2MyL3BsYXRmb3JtLmMgfCA2ICsrKysrLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9k
d2MyL3BsYXRmb3JtLmMgYi9kcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMNCj4gaW5kZXggYzM0
N2Q5M2VhZTY0Li45ZmViYWU0NDEwNjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzIv
cGxhdGZvcm0uYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMNCj4gQEAgLTU4
MiwxMiArNTgyLDE2IEBAIHN0YXRpYyBpbnQgZHdjMl9kcml2ZXJfcHJvYmUoc3RydWN0IHBsYXRm
b3JtX2RldmljZSAqZGV2KQ0KPiAgIAkJcmV0dmFsID0gdXNiX2FkZF9nYWRnZXRfdWRjKGhzb3Rn
LT5kZXYsICZoc290Zy0+Z2FkZ2V0KTsNCj4gICAJCWlmIChyZXR2YWwpIHsNCj4gICAJCQlkd2My
X2hzb3RnX3JlbW92ZShoc290Zyk7DQo+IC0JCQlnb3RvIGVycm9yX2luaXQ7DQo+ICsJCQlnb3Rv
IGVycm9yX2RlYnVnZnM7DQo+ICAgCQl9DQo+ICAgCX0NCj4gICAjZW5kaWYgLyogQ09ORklHX1VT
Ql9EV0MyX1BFUklQSEVSQUwgfHwgQ09ORklHX1VTQl9EV0MyX0RVQUxfUk9MRSAqLw0KPiAgIAly
ZXR1cm4gMDsNCj4gICANCj4gK2Vycm9yX2RlYnVnZnM6DQo+ICsJZHdjMl9kZWJ1Z2ZzX2V4aXQo
aHNvdGcpOw0KPiArCWlmIChoc290Zy0+aGNkX2VuYWJsZWQpDQo+ICsJCWR3YzJfaGNkX3JlbW92
ZShoc290Zyk7DQo+ICAgZXJyb3JfaW5pdDoNCj4gICAJaWYgKGhzb3RnLT5wYXJhbXMuYWN0aXZh
dGVfc3RtX2lkX3ZiX2RldGVjdGlvbikNCj4gICAJCXJlZ3VsYXRvcl9kaXNhYmxlKGhzb3RnLT51
c2IzM2QpOw0KPiANCg==
