Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CE322DDE2
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgGZKEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 06:04:48 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54012 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgGZKEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 06:04:48 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BA832C008A;
        Sun, 26 Jul 2020 10:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1595757886; bh=uni/yAdy8Ynbr+uWeWtM9PiOOIfgtoCNQL+lzIUO7yM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=bt0rKAOItiugQmffJMAGipvrQJKmo+KDzurxmfeLXIKA0H41VKRxvYI2m/0oil3T4
         USzFf7uDEiO0sfDkB2BVEd9bf/t7LZmBAbKWiEcDi7vloviOYFO37iaEwOIWGF0nQg
         mBXf3FwSlbrfxoLDOBSnbIipnFfzhGBtyLkerHx6vzP4X322hNkoKq6Wy9JrHMhYCy
         sUrcdIYFjfbxvbhM556hfDOxnacxe5dq64QAAqs4XZ9TCfKOdv01oK5Jo6tcsl+Ngz
         ArXLliOv99SrKxjipjrU/K+j7IGtn8o3g2yXzRa6b+ulgXbCUSzVbfWbhL6EKj0FPI
         TUNRSCmubTv6g==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B5FCEA005C;
        Sun, 26 Jul 2020 10:04:44 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 9D819801BF;
        Sun, 26 Jul 2020 10:04:42 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=hminas@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="lAehGUB9";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jc8rjIqRdAUbq1tnS6k2n7dHhm7NiMHqKOz/KHY4S+0lBbWNP+SOiyRqYzpWXdQjgFYomQbTbLV6cvVKsB4pqJcFhjUKlsMIqN73xpEJWnmFz6S1HC8f/PNh+J2Iv/HGSMROMvpo/N61w+yJjFSAcPPShfzNik1DMojOSXioIVsmNdnTsZ93nHq6PNk5Ca+/0xE2rLJhftFgW7sb+tzu6k3b8a7A4nemIeVscvOG8CshXb0/cHzgcD1sq0OcaKGaegh7SFuXe+ADVvs6tHTIVS85QXib4trLNfbpJ7AVlrFgz1Mkmj8e1nsAfqkARj24B5wZAdDYkRmH96cqxciZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uni/yAdy8Ynbr+uWeWtM9PiOOIfgtoCNQL+lzIUO7yM=;
 b=Iku/PnuF6XLaqqvsZvm9qgm8s1hXy20+Vx0wp3QeeFFVkE5Bul55lPR/vR5fYFgSSQFEEIs6Bm+U/8dtRYaaOrxTOJlrcZWHWRRnk7PPFRmJI/Jom+qbkqiA3T0zXuW77gzGKMyaVFUNA+r+oo7oP5XTS4r8rwMafnrDwc91BQS2/W3iH7Ct22ElY0cUOSX6QfTYAsF0gvqRv/hpoX8i0romajB0zDpXqql5IPDfW4nd94uvJxIqlBlsD0QLG/wCy1Dxc1Rvz5QwDz7DHytkrV5r9LHFbTVmhJkr9yFR5PfVjyPFNUpgPgd3AIotqpzdxPH24JdZXg1j0ggGG9xh7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uni/yAdy8Ynbr+uWeWtM9PiOOIfgtoCNQL+lzIUO7yM=;
 b=lAehGUB9nXrKDoopsZkm9euNLghGSkj7hRUa2T3JkRQeyNr63RN0RZIUzeZu2i8qC2MA8zQImfxGYVb5wOjVsBbTwWy/10IauBYUwrjv/4RBzPSttVydqqYXikdPfUT5ff1A5ofIaIOLs+5PnUMKx4qUFln+FMYosDysQOHR3bM=
Received: from CY4PR12MB1432.namprd12.prod.outlook.com (2603:10b6:903:44::11)
 by CY4PR12MB1462.namprd12.prod.outlook.com (2603:10b6:910:8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Sun, 26 Jul
 2020 10:04:40 +0000
Received: from CY4PR12MB1432.namprd12.prod.outlook.com
 ([fe80::9ce6:eb39:3f1f:c14d]) by CY4PR12MB1432.namprd12.prod.outlook.com
 ([fe80::9ce6:eb39:3f1f:c14d%10]) with mapi id 15.20.3216.028; Sun, 26 Jul
 2020 10:04:40 +0000
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
Thread-Index: AQHWUYxw1vGLRTulfUiy+Flpr+1fzKkZxUCA
Date:   Sun, 26 Jul 2020 10:04:40 +0000
Message-ID: <9de38c5f-6fdb-5fc0-3fd3-bec42b8807a2@synopsys.com>
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
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a38056a-b61b-4065-da6d-08d8314b4fdf
x-ms-traffictypediagnostic: CY4PR12MB1462:
x-microsoft-antispam-prvs: <CY4PR12MB1462DC02534F9F598E338C92A7750@CY4PR12MB1462.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oCn0pSChiuFnS942GDVp4TdoTk/E5W05JieQKE6Au2RmjVNWl4xYB2Y7w1v0vJmrZXDPK8QMctQqE0bKKImz7z8jGlt5THadb19I/EIZJCQcl2bSeWs0A31GTWS4AN8MKl+FV4vaHBXubm39kxphdqZzlmj2FT+eKEJfwV3bMGZie3B0zp9/1fZNKBXtn8e/aIGjt9bH9BX77rK08xScYT+uOhW/5fHUHfl5d1oPDD1wUezeVivc7nmEIQczOP8/FsDiSSLHNmAI3TS0NseN8nCpcuHLX63PzXXGMKavGbh2VUvVy4h/QUYKzuuwSL22Ke/IlMeQkghVjeUS4iaz6ysUHKor5dSsZDDxL/OtNGJDJijtV6J6Is6kH141/gLmOhOvhxwHebFS0WdDrxpJnmYzUCI4zt+ZnJ+EgGo/AB7sSkv5hJPlLZ9mhu5pJchY0XIstaSAiZCCJSVgENHjzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(136003)(376002)(39850400004)(66946007)(36756003)(91956017)(2616005)(2906002)(316002)(83380400001)(76116006)(6486002)(66446008)(26005)(66476007)(71200400001)(64756008)(66556008)(6512007)(186003)(5660300002)(31686004)(8936002)(478600001)(4326008)(31696002)(53546011)(86362001)(110136005)(6506007)(8676002)(54906003)(966005)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3gllFtmyIvL41vciFIVGTeR0r8LmspJFF5wyHrCgygb6bLw2aCWie4WbJdIl0FiyHlpvImaL0rcDmicv/N5FJZXm9SCRa+zXHJCyDXjDCgW83jrMcntO+KuH1T6Fuc5a/Oe/VDLKaiCScSI7h7WJ2LYxjuBFmDILug+2fLHZrbM9GvxsinWnYvU10es+m4m37u472vuY6fv/F2uh86ssdaM798ckEcYBjLfUzvn7spY9Yb2Wqjde4TK22hB7rtKgAJS6/3ZV19OxksshM0QML13aB/oRT1gOLbSz5DApRJNlwgt6oeVb4HPBKpriKwqUdgKegDyMzPaAKBOpI8jcm5G9cbQ1KvTXGJ180SP70nAuWya+Md8I+M2Ti9rVUPKiW/+w5RIDTZeuokGXePQs7/lLXoZwPP1p7RBgIn64GmAeHb0CG7G/Vw1LEEzGGL/kxeT0kwIOmRh9qvzbAk8NFilVG6H1ElTuUm582h++8XEJL0miZYKdQ0Gm7zSj9JG8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3592F26AF5D04E418C3BD2CB793C2F43@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a38056a-b61b-4065-da6d-08d8314b4fdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2020 10:04:40.2974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8fcslOb9uXn5JuQycipzi9edAXl0IWi2OCfdgNQrB0M3Oc5rsm2d4BDM0i6sLsre0fLi/gJk8UtMXgHjbpRUxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1462
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWFydGluLA0KDQpPbiA3LzQvMjAyMCAyOjUwIEFNLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBDYWxsIGR3YzJfZGVidWdmc19leGl0KCkgYW5kIGR3YzJfaGNkX3JlbW92ZSgpIChp
ZiB0aGUgSENEIHdhcyBlbmFibGVkDQo+IGVhcmxpZXIpIHdoZW4gdXNiX2FkZF9nYWRnZXRfdWRj
KCkgaGFzIGZhaWxlZC4gVGhpcyBlbnN1cmVzIHRoYXQgdGhlDQo+IGRlYnVnZnMgZW50cmllcyBj
cmVhdGVkIGJ5IGR3YzJfZGVidWdmc19pbml0KCkgYXMgd2VsbCBhcyB0aGUgSENEIGFyZQ0KPiBj
bGVhbmVkIHVwIGluIHRoZSBlcnJvciBwYXRoLg0KPiANCj4gRml4ZXM6IDIwNzMyNGEzMjFhODY2
ICgidXNiOiBkd2MyOiBQb3N0cG9uZWQgZ2FkZ2V0IHJlZ2lzdHJhdGlvbiB0byB0aGUgdWRjIGNs
YXNzIGRyaXZlciIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBCbHVtZW5zdGluZ2wgPG1hcnRp
bi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIHNpbmNlIHYx
IGF0IFswXQ0KPiAtIGFsc28gY2xlYW51cCB0aGUgSENEIGFzIHN1Z2dlc3RlZCBieSBNaW5hcyAo
dGhhbmsgeW91ISkNCj4gLSB1cGRhdGVkIHRoZSBzdWJqZWN0IGFjY29yZGluZ2x5DQo+IA0KPiAN
Cj4gWzBdIGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3BhdGNoLzExNjMxMzgxL19fOyEhQTRGMlI5R19wZyFLMFpKSXpZVll0cnd5MlZneFRJ
MjhaX3FBOTk1dXFtZzFkRnJNTngzWE1RNjUzUk9NS1BrdF96UWRKZTFPT2skDQo+IA0KPiANCj4g
ICBkcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMgfCA2ICsrKysrLQ0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMgYi9kcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3JtLmMN
Cj4gaW5kZXggYzM0N2Q5M2VhZTY0Li45ZmViYWU0NDEwNjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvdXNiL2R3YzIvcGxhdGZvcm0uYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MyL3BsYXRmb3Jt
LmMNCj4gQEAgLTU4MiwxMiArNTgyLDE2IEBAIHN0YXRpYyBpbnQgZHdjMl9kcml2ZXJfcHJvYmUo
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqZGV2KQ0KPiAgIAkJcmV0dmFsID0gdXNiX2FkZF9nYWRn
ZXRfdWRjKGhzb3RnLT5kZXYsICZoc290Zy0+Z2FkZ2V0KTsNCj4gICAJCWlmIChyZXR2YWwpIHsN
Cj4gICAJCQlkd2MyX2hzb3RnX3JlbW92ZShoc290Zyk7DQo+IC0JCQlnb3RvIGVycm9yX2luaXQ7
DQo+ICsJCQlnb3RvIGVycm9yX2RlYnVnZnM7DQo+ICAgCQl9DQo+ICAgCX0NCj4gICAjZW5kaWYg
LyogQ09ORklHX1VTQl9EV0MyX1BFUklQSEVSQUwgfHwgQ09ORklHX1VTQl9EV0MyX0RVQUxfUk9M
RSAqLw0KPiAgIAlyZXR1cm4gMDsNCj4gIA0KDQpLZXJuZWwgdGVzdCByb2JvdCBmb3VuZCBpc3N1
ZToNCiA+PiB3YXJuaW5nOiB1bnVzZWQgbGFiZWwgJ2Vycm9yX2RlYnVnZnMnIFstV3VudXNlZC1s
YWJlbF0NCiAgICBlcnJvcl9kZWJ1Z2ZzOg0KICAgIF5+fn5+fn5+fn5+fn5+DQogICAgMSB3YXJu
aW5nIGdlbmVyYXRlZC4NCg0KU28sICdlcnJvcl9kZWJ1Z2ZzOicgbGFiZWwgc2hvdWxkIGJlIHVu
ZGVyICNpZi8jZW5kaWY6DQoNCiNpZiBJU19FTkFCTEVEKENPTkZJR19VU0JfRFdDMl9QRVJJUEhF
UkFMKSB8fCBcDQogICAgICAgICBJU19FTkFCTEVEKENPTkZJR19VU0JfRFdDMl9EVUFMX1JPTEUp
DQplcnJvcl9kZWJ1Z2ZzOg0KI2VuZGlmIC8qIENPTkZJR19VU0JfRFdDMl9QRVJJUEhFUkFMIHx8
IENPTkZJR19VU0JfRFdDMl9EVUFMX1JPTEUgKi8NCg0KT3IgeW91IGhhdmUgb3RoZXIgc3VnZ2Vz
dGlvbj8NCg0KQ291bGQgeW91IHBsZWFzZSBmaXggdGhpcyBpc3N1ZSBhbmQgc3VibWl0IG5ldyB2
ZXJzaW9uIG9mIHBhdGNoLg0KDQpUaGFua3MsDQpNaW5hcw0KDQoNCj4gK2Vycm9yX2RlYnVnZnM6
DQo+ICsJZHdjMl9kZWJ1Z2ZzX2V4aXQoaHNvdGcpOw0KPiArCWlmIChoc290Zy0+aGNkX2VuYWJs
ZWQpDQo+ICsJCWR3YzJfaGNkX3JlbW92ZShoc290Zyk7DQo+ICAgZXJyb3JfaW5pdDoNCj4gICAJ
aWYgKGhzb3RnLT5wYXJhbXMuYWN0aXZhdGVfc3RtX2lkX3ZiX2RldGVjdGlvbikNCj4gICAJCXJl
Z3VsYXRvcl9kaXNhYmxlKGhzb3RnLT51c2IzM2QpOw0KPiANCg==
