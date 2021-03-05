Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EFF32EF2C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhCEPlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:41:02 -0500
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:27105
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229560AbhCEPkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 10:40:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYxh3h5eMfEjtRT9sPi2/bcEwQ/vEQ4GYIsV+0L31bqokIXaJnnRaib6dFWPwBBAZnPN4hTLz+f+dv9sTI8oSfd5pDRSg27VrMhMt9Ux/8zp4j3CrqdBifAaK01nacXqBE5F1J6eF5v/SbC4JCWvuS8N4QocD1fjiPrRBAhN6Q8JorIbk/0RznDwKARVGfjqdpaU/FDxTpWCo9iahpJrUKapoM++BaVTrXBWUlhZB4iM3teShTtANe6DCoCW6YNOhl6Njs8ftIMKbyzEE+HZAgxRY0JKUvOQGXkh+antE21Cb7SjdsJARF3p9Ui/T/R3rB9a2QPpQVO4Ag58KdtNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYRYIsnKHjnJbATWJbnV1XNINkiw0s8mqGRJLrIoVqk=;
 b=GUMR6JjGzIksrV93REGAfUB+1BbKGdGi/H2qaR28ZHRmxn83pYH6N0v0V+x8gGrPFwYwHmPZhxrTYarzJnTU3d3sOiXg13Xh7phUOfc51GSmWDZrc6lf86JHjPoxBSmGTOV2ZQuOYmKJb4hBlehv5rIOAwQCByvmOlwQccOBf0iIqvNruWGCWp5VOmjOL1MTEr+g3hd4M2gpn30H1S5WxV1ZYzPwxOtctX6wU61l+zHNOfpbxMn0hjJs6BLzqY+jmyESk5WnNedPRIwaUtMu4bwgr1rs6dQzkqShakmopKqrBikndvwbtZeCn/9szfSmB5rlN+wkS+IgBdwuPbJeEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYRYIsnKHjnJbATWJbnV1XNINkiw0s8mqGRJLrIoVqk=;
 b=svYsSPHBE++4o/aWGPfrb4zGGKtNs7ANCEMXsD0pHsNO+lU2WSHVtxVWn7dfSq4ZpTCBbwTb4oHZRhXBuZMuZIvaA+xTb58v1MH5Je+Po5o+dSJyw4CRbo7ptcC7jN7/kWpAOilcipvJPvpFfRLn21UDUhodB+cYfQxLIsN7zlo=
Received: from MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18)
 by MWHPR12MB1487.namprd12.prod.outlook.com (2603:10b6:301:3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Fri, 5 Mar
 2021 15:40:26 +0000
Received: from MW3PR12MB4491.namprd12.prod.outlook.com
 ([fe80::e0fc:4c91:e080:7b]) by MW3PR12MB4491.namprd12.prod.outlook.com
 ([fe80::e0fc:4c91:e080:7b%3]) with mapi id 15.20.3890.030; Fri, 5 Mar 2021
 15:40:26 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
Thread-Topic: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
Thread-Index: AQHXEbrD+AwEoICrsEykqiCghv8goKp1XFaAgAAdBrCAAAijAIAAAhiAgAABjYCAAAE8AIAAAQtA
Date:   Fri, 5 Mar 2021 15:40:26 +0000
Message-ID: <MW3PR12MB4491C79B8F847B982066A3ABF7969@MW3PR12MB4491.namprd12.prod.outlook.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
 <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <YEJOt6KXCzNb5y+x@sashalap> <1b5bfcb0-3860-bb81-f0ad-91a522beef0a@amd.com>
In-Reply-To: <1b5bfcb0-3860-bb81-f0ad-91a522beef0a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: Nirmoy.Das@amd.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-03-05T15:40:22Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=8265900c-4065-4e48-9737-b85d66ac61ef;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 742d19b1-b9f2-402c-464f-08d8dfecff58
x-ms-traffictypediagnostic: MWHPR12MB1487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB148733104CBE2CCD3980237AF7969@MWHPR12MB1487.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OR1CP+QZV7D8KggfCkhZJZYPMJHJfbaM3B2BLhJrpefb6TMHOSXtATJx5fWSdGMswdU+plp6LOTizeIN2YotyuvJXo0ay2zbi62tnBeEy0/qi5tJlZ1iIFgevKx17pvmHFznflTQsEBRyXt+FmNjs+ZBUxbD2jWtXhM2RYlf0AXgNkE1dpi13ffv9/dh2Hinpuj4Zub2WG1WDzLaBqOSIHZ0HNst2KUZg662SgiqlvI4KJ8Sk5j5dTQucHDUzrvuQd0NxNBAgfLgigm1Gyc5wlGyrX52LsN9B7+VwKxxrvtm0VQX+hY5HcVMojfOYVEk7Da2c3tXSsbQEjmCyK4Rf+VOM8+byI79S/Y3fRy2GrDhyx91uacLAnd8Q1dwYthzdKeIEPRpxYA6zyRtBxeXeiW0CPN5OnE5mqDI/LvziQYBrH3BoJKS76JYfb4EjzvyOgVdQe0jCrwwDCrgL7tg2G01zAjLo5RvT/QpP2qZGZAiqug7jOegqw/c5rCsdMRBpk5HPTp6WPVcOEioHfT5OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4491.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(316002)(66446008)(7696005)(8676002)(66946007)(66556008)(66476007)(55016002)(6506007)(478600001)(83380400001)(26005)(86362001)(64756008)(4326008)(110136005)(5660300002)(54906003)(76116006)(52536014)(33656002)(2906002)(53546011)(9686003)(71200400001)(186003)(6636002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HM/wSy2NG5KtmUwYtv8KgwXFdsFpAxj4cqjFwKaDWvpZG/49emSnwZzh8vBFzbTyPDjm/Muit3g6jcG0oEMHZvdIY5gtvGuvmnuyst3LkbXnFYjCeHsKJ2Xa3cmbT60Qs+sqLFhhT9XHy5xBKOFsfJDdqoL5qC9XfzCO2ieAdzqEwvS1qu0mcDtl8+yQ4yLfaRTQn8FyyitYH2kG+SNvYXwtUKVpBkrG2RVlaby0PXkT4msttgu7AoALlbqjWncewiNU8FMXG1rLGh9aUck0dYCbIFSMgSoygYgLIomrcboXvQ79N9ggZh6JzFzbHVDVZXiUFxtfOKXKISW6/DAyO5CodYugcGb7dSWeMUQJsTBvp6YSmrMpOaWhVf0go0Q5m2GDyHqT+sMPfQktRY/IKKbHZRabCyJjovjkjGV+502vBQS3uzgczkxFKsHITbMkvDcVllYbepDuzvHHYhvPh5G0vLAJUqMyqP4f7VwmlGmppSlLmMnZFQoFkZuMXUIcAx9A0dYydrfgwidCS28iecoA2r0pb1VirX8dXhkbC1JtLaeJJWlwcDa+hVQSnleE7eZUtq8jdR53uTg6bJgT7w6vksXa9mjWP6z0xz2kqMW2VQkVyRqmN4Q/Mlzr1nCLbAY3GOLyaZ3PxcM7WfYDmxWZTnQfT39DIe48bIoWf8iPqbAAFDt6pdL7xH6KdyFv0ubBoBcTto6P/6eaoEgcdy+N8NWg1LKeFZfwDs9tOPI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4491.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742d19b1-b9f2-402c-464f-08d8dfecff58
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2021 15:40:26.0882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2+UzLZ7gGzuLCrhqJVeQV+S+hZvxX8ONpDtsZJREcyHT3Fi0Csj2q/nR5f+0+1wDMShNosMhtNbGmfj3tXdcXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBQdWJsaWMgVXNlXQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IEtvZW5pZywgQ2hyaXN0aWFuIDxDaHJpc3RpYW4uS29lbmlnQGFtZC5jb20+DQo+IFNlbnQ6IEZy
aWRheSwgTWFyY2ggNSwgMjAyMSAxMDozNSBBTQ0KPiBUbzogU2FzaGEgTGV2aW4gPHNhc2hhbEBr
ZXJuZWwub3JnPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQu
Y29tPg0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
Zz47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwu
b3JnOyBEYXMsIE5pcm1veQ0KPiA8TmlybW95LkRhc0BhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIDUuMTEgMDc5LzEwNF0gZHJtL2FtZGdwdTogZW5hYmxlIG9ubHkgb25lIGhpZ2ggcHJp
bw0KPiBjb21wdXRlIHF1ZXVlDQo+IA0KPiBBbSAwNS4wMy4yMSB1bSAxNjozMSBzY2hyaWViIFNh
c2hhIExldmluOg0KPiA+IE9uIEZyaSwgTWFyIDA1LCAyMDIxIGF0IDAzOjI3OjAwUE0gKzAwMDAs
IERldWNoZXIsIEFsZXhhbmRlciB3cm90ZToNCj4gPj4gTm90IHN1cmUgaWYgU2FzaGEgcGlja2Vk
IHRoYXQgdXAgb3Igbm90LiBXb3VsZCBuZWVkIHRvIGNoZWNrIHRoYXQuIElmDQo+ID4+IGl0J3Mg
bm90LCB0aGlzIHBhdGNoIHNob3VsZCBiZSBkcm9wcGVkLg0KPiA+DQo+ID4gWWVzLCBpdCB3ZW50
IGluIHZpYSBhdXRvc2VsLiBJIGNhbiBkcm9wIGl0IGlmIGl0J3Mgbm90IG5lZWRlZC4NCj4gPg0K
PiANCj4gSUlSQyB0aGlzIHBhdGNoIHdhcyBjcmVhdGVkICpiZWZvcmUqIHRoZSBmZWF0dXJlIHdo
aWNoIG5lZWRzIGl0IHdhcyBtZXJnZWQuDQo+IFNvIGl0IGlzbid0IGEgYnVnIGZpeCwgYnV0IHJh
dGhlciBqdXN0IGEgcHJlcmVxdWlzaXRlIGZvciBhIG5ldyBmZWF0dXJlLg0KPiANCj4gQmVjYXVz
ZSBvZiB0aGlzIGl0IHNob3VsZCBvbmx5IGJlIG1lcmdlZCBpbnRvIGFuIG9sZGVyIGtlcm5lbCBp
ZiB0aGUgbmV3DQo+IGZlYXR1cmVzIGlzIGJhY2sgcG9ydGVkIGFzIHdlbGwuDQo+IA0KPiBBbGV4
IGRvIHlvdSBhZ3JlZSB0aGF0IHdlIGNhbiBkcm9wIGl0Pw0KDQpJIHRoaW5rIHNvLCBidXQgSSBk
b24ndCByZW1lbWJlciB0aGUgZXhhY3Qgc2VxdWVuY2UuICBARGFzLCBOaXJtb3k/DQoNCkFsZXgN
Cg==
