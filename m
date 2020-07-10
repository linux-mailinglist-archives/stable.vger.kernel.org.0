Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8843521B35C
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGJKsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:48:07 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:46944
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbgGJKsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C45W4uzhL4IZMKccLRC4oHG40g9H0wfHedzDdWqBFh5H0bOFMtUIEh7xTchrmzDHeWqSMnxwaKbfW4Ziyc3yzugb7mQii2plQ/mr6kWsArfVQSt9swpDmL588lkNZpAWzTZUaFhdXKlGFUk2Fd2kb/grjc/hXxaVERLsNcMsQq8SjpsS6WL5fIeWoD6ya+dmcBLjlZP/EVfIiOpr+Tk/6DSNfsBhpRlHworjNFrUTaJDzD/qrHlmZ/1EEZFXdpAIiFGJrl8ZbiOOEkJGDwC2WrDzp6XWvR23xKxFWTtOu5uxa8gdUJaJP8PeVMHOI73ye0uRGYZFRQ9JQyZiJ+wHHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd39GXYp1yJuw6YUnbztVR0DZqZwqbSD0p6QX+VOrsY=;
 b=Efa3RTm5YaGXWCmW5m5oiHLQ55ZesJd4vvGKuiZOeD/s1Kwj9PdMcLaDKOxNsOy856xtfS1SyuWc/TCUYIbl7ZTGIQ5AqmmGWE/yJJ/gYAeMzeYnTcFu90ZCDy4yV3RLQSyifVJ+5aM2Z0GwZCmnRgq63NM5F56KbphSYWn8Afet/lcFZqBHkctIp0Wl/CK/dRToO2XFhYP+ogikNEIM2UUC1jN98p9R34EzpYEEix1g5+1VcJhRtzzwE4reh0JDhPVC6jHkoX13p32Um7NYkM5iR2V62H4G2GjfKYVUxDrkEOFWT1fXBVOOAo5EVGkE7QB3aiLVi9sMFKsg0vSGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd39GXYp1yJuw6YUnbztVR0DZqZwqbSD0p6QX+VOrsY=;
 b=cYo2oLwJFdLD3dAwnaSMvXzE9OZ+JTUXsSe+56Kd//I30NFsY3boUqEXxTI4riV8M3STTVcmi8iSA+qBhFsh3lU8d1VHR0yi4o8UtLEDN2b0TtBxTRyBLgVIJh2YDeAutj8Rs9nTMMX9VL/9WnoO8AR3K4G7QejzSVURpZaGtGE=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1471.namprd10.prod.outlook.com
 (2603:10b6:300:23::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 10:48:04 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3174.021; Fri, 10 Jul 2020
 10:48:04 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "greg@kroah.com" <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "johan@kernel.org" <johan@kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAkwyAgAAGFgCAAAWFgIAAA0gA
Date:   Fri, 10 Jul 2020 10:48:03 +0000
Message-ID: <6ce704d468c9c63707e7ae7a3c4970f70dd93171.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710095445.GS3453@localhost>
         <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
         <20200710103617.GB1203263@kroah.com>
In-Reply-To: <20200710103617.GB1203263@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92b38c93-2208-4881-d1ad-08d824beb916
x-ms-traffictypediagnostic: MWHPR10MB1471:
x-microsoft-antispam-prvs: <MWHPR10MB1471D2F617F5CF634AEA96DEF4650@MWHPR10MB1471.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DbHSt2KFKZtw+sZGx5El6nGHBxCY+h6OtIeRMWTatO51YyVZSk5gkP1z0MIH9ne21FQCFAKzT9G6At7FtNK7Ve03BGbQIKdp1ZRF0t7aWw/ukxOrY7tgMV2rt52y4apvvwP2727WFdOMKTa8OUrg8YPVSHH2CLzQsKn3gifLp1cC91LwjTTAwGJ2KPDH47VnLj4TPNDQkHUuxAhu86eOyDjo7HiTww0UkvYPALhHWOarVM5d7Y1PxxNbCnTabVp/iRrcoOIPWUM9l7PYWvH04nuZdQXb7X1MVtTCrh1zfUkFys3bGTzTE1V7sw/L2Ac8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(8676002)(6916009)(4326008)(6486002)(71200400001)(66446008)(316002)(66556008)(66946007)(64756008)(66476007)(2906002)(54906003)(91956017)(36756003)(76116006)(478600001)(6506007)(186003)(5660300002)(8936002)(26005)(86362001)(6512007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QGI1Mn2MM2evHbb9r51VM2E1drZ5OzXumn4pUVU6C/1gOydyJBwleAWOk+xudNIn3/ViJIhd1xiIlfk6ydBP8zQBf1bht5iIww3sYhuMXJj2gI2pyj2Ss+WDiqkC+i2CgmtlGKCzjqv4MLHZ34Eud9P8Ir9x5SJq89QqCF+LP01E3GSfI7Gufi3jJl8R91huIBlMJKuwspyjAJ8WASvDDHDnwWHoSA9Qb0LUringwaQ7KK5Mj9gqKe+o0oUR3JxGSEALLxbJBlCMS5/8m9O+XRYhBAxb9QdM4S4mP1tQ+uCS7qnAbUGOF+EnLYbo4/Kx72bAdyEUPgvBkFeMFsK2Ky/Xr+jrTYi7dLvr862IFQnEyYTnGRw95IePwdEY1Ef7YX+s3PELcahigZAvVbiS4HKoUzFHFRWkW1pZyJsemNMnvDo8rAwLVYQ4q0VdyhUobm2dlpLq+2P40NP6WOyoh3DZOZfUptlYbOoZE4ENs8veRVYx63n08tXA34rugLa6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <269C74C82983F3429083D533905213C0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2190.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b38c93-2208-4881-d1ad-08d824beb916
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 10:48:03.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fOBv9NOJvFNXiJGvmYifXqYH0dcXTRX4OcJymolOLF5VSoP5IlsGKeSG1O3jp31UeWlAUJ6//s0O41lubQklPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1471
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDEyOjM2ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBG
cmksIEp1bCAxMCwgMjAyMCBhdCAxMDoxNjozM0FNICswMDAwLCBKb2FraW0gVGplcm5sdW5kIHdy
b3RlOg0KPiA+IE9uIEZyaSwgMjAyMC0wNy0xMCBhdCAxMTo1NCArMDIwMCwgSm9oYW4gSG92b2xk
IHdyb3RlOg0KPiA+ID4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lk
ZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50
IGlzIHNhZmUuDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gT24gRnJpLCBKdWwgMTAsIDIwMjAgYXQg
MTE6MzU6MThBTSArMDIwMCwgSm9ha2ltIFRqZXJubHVuZCB3cm90ZToNCj4gPiA+ID4gQk8gd2ls
bCBkaXNhYmxlIFVTQiBpbnB1dCB1bnRpbCB0aGUgZGV2aWNlIG9wZW5zLiBUaGlzIHdpbGwNCj4g
PiA+ID4gYXZvaWQgZ2FyYmFnZSBjaGFycyB3YWl0aW5nIGZsb29kIHRoZSBUVFkuIFRoaXMgbWlt
aWNzIGEgcmVhbCBVQVJUDQo+ID4gPiA+IGRldmljZSBiZXR0ZXIuDQo+ID4gPiA+IEZvciBpbml0
aWFsIHRlcm1pb3MgdG8gcmVhY2ggVVNCIGNvcmUsIFVTQiBkcml2ZXIgaGFzIHRvIGJlDQo+ID4g
PiA+IHJlZ2lzdGVyZWQgYmVmb3JlIFRUWSBkcml2ZXIuDQo+ID4gPiA+IA0KPiA+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKb2FraW0gVGplcm5sdW5kIDxqb2FraW0udGplcm5sdW5kQGluZmluZXJhLmNv
bT4NCj4gPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+ID4gLS0tDQo+ID4g
PiA+IA0KPiA+ID4gPiDCoEkgaG9wZSB0aGlzIGNoYW5nZSBtYWtlcyBzZW5zZSB0byB5b3UsIGlm
IHNvIEkgYmVsaXZlDQo+ID4gPiA+IMKgdHR5VVNCIGNvdWxkIGRvIHRoZSBzYW1lLg0KPiA+ID4g
DQo+ID4gPiBObywgdGhpcyBkb2Vzbid0IG1ha2Ugc2Vuc2UuIEIwIGlzIHVzZWQgdG8gaGFuZyB1
cCBhbiBhbHJlYWR5IG9wZW4gdHR5Lg0KPiA+IA0KPiA+IFRoaXMgaXMgYXQgbW9kdWxlIGluaXQg
c28gdGhlcmUgaXMgbm8gdHR5IHlldC4NCj4gPiBhY21fcHJvYmUoKSB3aWxsIGxhdGVyIHNldDoN
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgYWNtLT5saW5lLmR3RFRFUmF0ZSA9IGNwdV90b19sZTMyKDk2
MDApOw0KPiA+IAlhY20tPmxpbmUuYkRhdGFCaXRzID0gODsNCj4gPiAJYWNtX3NldF9saW5lKGFj
bSwgJmFjbS0+bGluZSk7DQo+ID4gDQo+ID4gPiANCj4gPiA+IEZ1cnRoZXJtb3JlLCB0aGlzIGNo
YW5nZSBvbmx5IGFmZmVjdHMgdGhlIGluaXRpYWwgdGVybWluYWwgc2V0dGluZ3MgYW5kDQo+ID4g
PiB3b24ndCBoYXZlIGFueSBlZmZlY3QgdGhlIG5leHQgdGltZSB5b3Ugb3BlbiB0aGUgc2FtZSBw
b3J0Lg0KPiA+IA0KPiA+IGhtbSwgaXQgaXMgbm90IGlkZWFsIGJ1dCBhY21fcHJvYmUoKSB3aWxs
IGxhdGVyIHNldDoNCj4gPiDCoMKgwqDCoMKgwqDCoMKgYWNtLT5saW5lLmR3RFRFUmF0ZSA9IGNw
dV90b19sZTMyKDk2MDApOw0KPiA+IAlhY20tPmxpbmUuYkRhdGFCaXRzID0gODsNCj4gPiAJYWNt
X3NldF9saW5lKGFjbSwgJmFjbS0+bGluZSk7DQo+ID4gDQo+ID4gQnV0LCB3b3VsZCBpdCBub3Qg
bWFrZSBzZW5zZSB0byBub3QgYWNjZXB0IGlucHV0IHVudGlsIFRUWSBpcyBvcGVuZWQgPw0KPiA+
IFRoYXQgd291bGQgYmUgbW9yZSBpbmxpbmUgd2l0aCBhIHJlYWwgUlMyMzIsIHdvdWxkIGl0IG5v
dD8NCj4gDQo+IFlvdSBjYW4ndCBrZWVwIHRoZSBjaGlwIGluIHRoZSB1c2ItdG8tc2VyaWFsIGRl
dmljZSBmcm9tIGFjY2VwdGluZyBkYXRhDQo+IGJlZm9yZSB5b3UgZG8gYW55dGhpbmcgd2l0aCBp
dCwgdGhhdCByZXF1aXJlcyBmaXJtd2FyZSB0byBub3QgZG8gdGhpcy4NCj4gQXJlIHlvdSBzdXJl
IHlvdXIgZmlybXdhcmUgaXMgY29ycmVjdD8NCg0KTm8sIEkgZG9uJ3QgdGhpbiBpdCBpcyBjb3Jy
ZWN0LiBJIGFtIHdvcmtpbmcgYm90aCBlbmRzIGhlcmUgOikNCg0KPiANCj4gPiA+IFdoeSBub3Qg
Zml4IHlvdXIgZmlybXdhcmUgc28gdGhhdCBpdCBkb2Vzbid0IHRyYW5zbWl0IGJlZm9yZSBEVFIg
aXMNCj4gPiA+IGFzc2VydGVkIGR1cmluZyBvcGVuKCk/DQo+ID4gDQo+ID4gSSB3b3VsZCBidXQg
aXQgaXMgbm90IG15IGZpcm13YXJlLCBpdCBpcyBhIHJlYWR5IG1hZGUgVVNCIHRvIFVBUlQgY2hp
cC4gd2lsbCB0YWxrDQo+ID4gdG8gdGhlIG1hbnVmYWN0dXJlciB0aG91Z2guDQo+IA0KPiBXaGF0
IGNoaXAgaXMgdGhpcz8NCg0KTWljcm9jaGlwIFVTQjU3MzQNCg0KPiANCj4gdGhhbmtzLA0KPiAN
Cj4gZ3JlZyBrLWgNCg0K
