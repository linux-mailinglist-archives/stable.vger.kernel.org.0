Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5B2EEC0D
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 04:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbhAHDzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 22:55:50 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:40432 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbhAHDzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 22:55:50 -0500
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EDFCE4023B;
        Fri,  8 Jan 2021 03:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610078089; bh=uv61z0Vy2fb8Tg7A7+ICR486eDbzeww7Ogr2RJ8q9XM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZolLsKuoZDtOt+o0JXT2JNKZKZIsAkrdOPjg1JxJDUzSC00kyGbaxoEYbowPHYXBg
         /yVgJvRtwICk7c5d5WLBFzM52Ht43VlkmfRNN8nPcjhjSI9refTFnWSJaL2ZN5B2Y1
         5L7+1lPT34P4PAl5yoZK26TMJEetuI5me644FplXCi2H3JymjDWu+Fa9rc7DUasY7I
         r+Ca60ya1h8fTqZL93eU/hkEITqgL6Zx0tQhMz13nN0s/qNUSSMM6loCIjEIojw/3C
         6x6qDn6/gKWqzkA2T5NK4ZwWg/hA3SMahfy2S96Ow/N2K8Av3UKYbqwKQ7Xbjmwaqu
         T9H76LibXupPw==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 11FD2A0063;
        Fri,  8 Jan 2021 03:54:47 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C19604004D;
        Fri,  8 Jan 2021 03:54:46 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="B+Xii0sg";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJRkJYIUODSxCl1nVQQg7otH1HZ6rbiWtf94VXj5NKAr6B1/QpSUMTZcydzragV9MtzjWUEjM8VuWwDfvU7psO0TcxldvSSPYHoJZFpRQLiLlzgbbk+4bRYI+pCz6pXUlkmmSOWquIJb6MbUxA0O9x3aFOPH2CgijPrDIxj2Y231M7jOlre9Alnqu8uvtLEnqHtIqWPWSoyMbKT0aPRCFaebSqd4uqbgjkFdNjfoQlMOXza3pxXKvU+73c81EopGcO/V/EBhToCFpZturd1yGfxhMOUUZYDR8/pROvbI2V595f9Qw6q9uxAK0pSXZltxNGINFswX+rDH9Z5JSOXEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv61z0Vy2fb8Tg7A7+ICR486eDbzeww7Ogr2RJ8q9XM=;
 b=EHI7Aa5tTBGxkc+PwVdyi4v7qu8aCDcrKwLvFP5dIGtYRW8o4xxFAmtAwNlEiC62fjjvb93iubE1GncM/1bmn0JTRTtBWBp5EDM9l3sFITSCx12cIVW7c2xkQ1R8fIZ6XP6TSC2nAKE7KcBTBfEmYV4BlUNVQZy0h+AeXX7mDTuhRqlRXYlrabS7hQYtpPGeIWAgL+f0kEonAetA6ZyigbPyM5faDvV83jPzvZ5UkTWAkq6Y9u96TcD3ppElzg7JUVXUN/SkdfxTCiNdk8J2U1+qf7Qiq+Oz6oWjw7IgoFGO941otgLtg8D4lzRxzF3NLNWcwD/+c9xzGcyIbPoilA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv61z0Vy2fb8Tg7A7+ICR486eDbzeww7Ogr2RJ8q9XM=;
 b=B+Xii0sgF3VjPeY+3QEp3Qtjk1/kWHBLORTbGmmooZOtiIRH9ME8bOnNB3BaMaU0jsXQe1ceJFk+IJl9ljNLg42iafzDOkqcbNqpU/VdSdJ4LmFnUsaqO/2JUB+XF4eM2vAgcge3gcgmBhxiESvPR2y/ENAEahQbtUy+KoiobhQ=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB3302.namprd12.prod.outlook.com (2603:10b6:a03:12f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Fri, 8 Jan
 2021 03:54:44 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Fri, 8 Jan 2021
 03:54:44 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Topic: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Index: AQHW44dsvevXDR9T+0aaJdM98rGhjKoaOlYAgAAbXwCAAZOGAIABHMSAgAAW8IA=
Date:   Fri, 8 Jan 2021 03:54:43 +0000
Message-ID: <19b685a9-0c25-9b6c-ecaf-ffca4069182b@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
 <87eeiycxld.fsf@kernel.org>
 <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
 <87k0spay6z.fsf@kernel.org>
 <cacf58e7-e131-2caa-5fb3-1af7db8270b4@synopsys.com>
In-Reply-To: <cacf58e7-e131-2caa-5fb3-1af7db8270b4@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bcfc334-064e-489e-765c-08d8b3892251
x-ms-traffictypediagnostic: BYAPR12MB3302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3302FFD26E3D67741515CAF5AAAE0@BYAPR12MB3302.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uCbpa7PxrIKk02HWEVm5qgwLvODDvAjkgPPJmhy3eXtI8P0rcLp6IB2mIU8hWPD0VdScIYatQxtpfjObG0/ONnVe2VvaA4KDeJuLglmJoQkHnfmwdh71uF+oJybt2p1vZucHdzKDx6HyTujGxIjdGiVbqR2QaGbhVAs5ZLb+j9cQGv+9Rj6mbwa+Cz5ewveyPzV1jalWKvnkEK/z5DVkrPufA+1czQc0Hqfh9y9TzzEH0sk/GxBjzJpuSzHvXaP0xLS5v1WgAOe9FNEHGp8bAARsiiMq23dnVTrpI5APmsZX8/uM9R269SR+kZvFj17gg0XWgnRPmXosubUSUgSbWsYn7/5wY12B75Kv2+Diy6jC2d4bKN+r9v89VO2xvmEeQowiZ8AT0bw/Gbe+OQK80ebnHU5TYGIw4XwS0grP2OOd5J9nv+cf4dGeojoQc9Ui5PEtGiPkKI6HzaRV7KBi5+SW5LeRkRsT6sfNU2QIDIdPcmZ92/yuj2J66NcyC69p
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(71200400001)(478600001)(76116006)(2906002)(86362001)(31696002)(54906003)(64756008)(5660300002)(316002)(110136005)(4326008)(66946007)(83380400001)(8676002)(66556008)(66446008)(6506007)(186003)(26005)(66476007)(6486002)(6512007)(2616005)(36756003)(8936002)(31686004)(131093003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cXcwb1hqUE5KVTBCT2FLRHh0YnZHT3ErQVF1azUyYURrQ1kzTzBjRi8vS2hz?=
 =?utf-8?B?QjhnOUd3elBkTC9LaVdZSTBMek1XVUU2cVh5cmpGSFRRZWRFcDZJZTdaYmpn?=
 =?utf-8?B?OGNzVlpPYWJ2ZS91ajJIQlY2NWVlYk92QXg2Zi9qWVpyRDQxRnNUNlo0MWV1?=
 =?utf-8?B?cTBIUzFvQWtYdnJxamxLK3dOaC9uV0VLM1VKMURGamxYakZvdFlJcStjd0NQ?=
 =?utf-8?B?SEhxMW9WcWtCTWpTVGZTajgzWUF0bDQ4WHNRMFVhYzY5cTAranNsVE9hQjZZ?=
 =?utf-8?B?K3RISzl0Z3AwMGlncjg3UzdQWDFQRVJsTGZRWWlJUEsvdTQwNk9nejVQR2pp?=
 =?utf-8?B?RC95TzN2YjB4YlJtVVB4RDZrUDFEa0xOSzlwZGxFQWFDQlB0Y2FsNWxNZGNV?=
 =?utf-8?B?NGlEQkM5VnBoaW1SKzM1c1gxZ3lzcmh1VzA0QVRLVFVtZ2dPbzg5WUsxNDB4?=
 =?utf-8?B?WWtHZEtzaWk1MlpJNnkzL0laZDFoeU5mTjVSYzNRNzNVQkVyUDZYa3dnL213?=
 =?utf-8?B?djJ2RURxYUVoSlYyTHRaMjM5RkExSTQyUDVXd1F1TnZvL0poSERZWnViV2hP?=
 =?utf-8?B?TU1jUUREbHlYU2xqVTZiTGVKZnF3VEI2SzBZRHRkWU5vV1Y2U1l0dEIybklT?=
 =?utf-8?B?dHdjV25LQkNRblNHWjJsWDNvSzBSUWRvZmU3SkdzZTY5SG1JU3kwaWNVVFJv?=
 =?utf-8?B?ZFQxaUtFWVljLy9IMTAvUHRDN3FNemtaRXFrYzVJcHVyeU0yNzlFNkhGU0xX?=
 =?utf-8?B?VzJQbGp6RS95aXpwQWNlblljN1l5UHFraEVuZ3V2dmdoRS9wYzVqejkwbVJG?=
 =?utf-8?B?SWN0T0c5MTkxOXdOcHRyeDh0TUkzUXc3enNOWXBnTUpOSkNEWWgwYmdSVU14?=
 =?utf-8?B?cHFpZ3pUcS9aSmR2WHAzcjJmU05RT0dDeFd3UWVaRDhxSTZTNWF2Rk1mOFN6?=
 =?utf-8?B?UmpETXQxU2UxM0p1QldEU2dPMlc0dE90d2ZnbEY5aDFucDh1SEJrRkFXYWJi?=
 =?utf-8?B?QU01c2xjdFhjUXQ4Skx6NVM2cncxa3h0UmtqRzVVdmtoeUZKbFVaakxBN2N0?=
 =?utf-8?B?OTR1a0tVRXFMVUhqVEltQjFITm5rNWppSzdnY0VsUG5wdlFnTm44cGkzaFpU?=
 =?utf-8?B?dHJ6ajg4Ry9Yek1xTXJEWW9KbzM4S2x1U04ySmxGZ2EvSG0vaURLUVBSQzFE?=
 =?utf-8?B?TWdiaVI0MDlibmJnYU9qNElHOUhHejQ4TEtQWUQrMXJCOFlDbTlZV3loZ1JS?=
 =?utf-8?B?RlA0TFhiYXdHc3lSS2JkTlJ3Q2IzclpOZmhLQlB5T3F1cGxTa1dTK2lCWFBq?=
 =?utf-8?Q?MhePqdVs2IEKk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DCB3C0879A5B54AAA1077F4E6EFFDF5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bcfc334-064e-489e-765c-08d8b3892251
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 03:54:43.9851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: urHozIwPslbojALhosQGZ6NnwBfau/rOAblJd8iTpZOcUQ6+3E2zTwHa3NSnekfYXRG3FdBeaA30lJ6mutMbjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3302
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpbmggTmd1eWVuIHdyb3RlOg0KPiBIaSwNCj4NCj4gRmVsaXBlIEJhbGJpIHdyb3RlOg0KPj4g
SGksDQo+Pg0KPj4gVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPiB3cml0
ZXM6DQo+Pj4+PiBAQCAtMzg2Myw3ICszODY4LDcgQEAgaW50IGR3YzNfZ2FkZ2V0X2luaXQoc3Ry
dWN0IGR3YzMgKmR3YykNCj4+Pj4+ICAJICogc3VyZSB3ZSdyZSBzdGFydGluZyBmcm9tIGEgd2Vs
bCBrbm93biBsb2NhdGlvbi4NCj4+Pj4+ICAJICovDQo+Pj4+PiAgDQo+Pj4+PiAtCXJldCA9IGR3
YzNfZ2FkZ2V0X2luaXRfZW5kcG9pbnRzKGR3YywgZHdjLT5udW1fZXBzKTsNCj4+Pj4+ICsJcmV0
ID0gZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludHMoZHdjKTsNCj4+Pj4+ICAJaWYgKHJldCkNCj4+
Pj4+ICAJCWdvdG8gZXJyNDsNCj4+Pj4gaGVoLCBsb29raW5nIGF0IG9yaWdpbmFsIGNvbW1pdCwg
d2UgdXNlZCB0byBoYXZlIG51bV9pbl9lcHMgYW5kDQo+Pj4+IG51bV9vdXRfZXBzLiBJbiBmYWN0
LCB0aGlzIGNvbW1pdCB3aWxsIHJlaW50cm9kdWNlIGFub3RoZXIgcHJvYmxlbSB0aGF0DQo+Pj4+
IEJyeWFuIHRyaWVkIHRvIHNvbHZlLiBudW1fZXBzIC0gbnVtX2luX2VwcyBpcyBub3QgbmVjZXNz
YXJpbHkNCj4+Pj4gbnVtX291dF9lcHMuDQo+Pj4+DQo+Pj4gRnJvbSBteSB1bmRlcnN0YW5kaW5n
LCB0aGF0J3Mgbm90IHdoYXQgQnJ5YW4ncyBzYXlpbmcuIEhlcmUncyB0aGUNCj4+PiBzbmlwcGV0
IG9mIHRoZSBjb21taXQgbWVzc2FnZToNCj4+Pg0KPj4+ICINCj4+PiDCoMKgwqAgSXQncyBwb3Nz
aWJsZSB0byBjb25maWd1cmUgUlRMIHN1Y2ggdGhhdCBEV0NfVVNCM19OVU1fRVBTIGlzIGVxdWFs
IHRvDQo+Pj4gwqDCoMKgIERXQ19VU0IzX05VTV9JTl9FUFMuDQo+Pj4NCj4+PiDCoMKgwqAgZHdj
My1jb3JlIGNhbGN1bGF0ZXMgdGhlIG51bWJlciBvZiBPVVQgZW5kcG9pbnRzIGFzIERXQ19VU0Iz
X05VTSBtaW51cw0KPj4+IMKgwqDCoCBEV0NfVVNCM19OVU1fSU5fRVBTLiBJZiBSVEwgaGFzIGJl
ZW4gY29uZmlndXJlZCB3aXRoIERXQ19VU0IzX05VTV9JTl9FUFMNCj4+PiDCoMKgwqAgZXF1YWwg
dG8gRFdDX1VTQjNfTlVNIHRoZW4gZHdjMy1jb3JlIHdpbGwgY2FsY3VsYXRlIHRoZSBudW1iZXIg
b2YgT1VUDQo+Pj4gwqDCoMKgIGVuZHBvaW50cyBhcyB6ZXJvLg0KPj4+DQo+Pj4gwqDCoMKgIEZv
ciBleGFtcGxlIGEgZnJvbSBkd2MzX2NvcmVfbnVtX2VwcygpIHNob3dzOg0KPj4+IMKgwqDCoCBb
wqDCoMKgIDEuNTY1MDAwXcKgIC91c2IwQGYwMWQwMDAwOiBmb3VuZCA4IElOIGFuZCAwIE9VVCBl
bmRwb2ludHMNCj4+PiAiDQo+Pj4NCj4+PiBIZSBqdXN0IHN0YXRlZCB0aGF0IHlvdSBjYW4gY29u
ZmlndXJlIHRvIGhhdmUgbnVtX2VwcyBlcXVhbHMgdG8NCj4+PiBudW1faW5fZXBzLiBCYXNpY2Fs
bHkgaXQgbWVhbnMgdGhlcmUncyBubyBPVVQgcGh5c2ljYWwgZW5kcG9pbnQuIE5vdA0KPj4gbm8s
IHRoYXQncyBub3Qgd2hhdCBpdCBtZWFucy4gSSBkb24ndCBoYXZlIGFjY2VzcyB0byBEV0MzIGRv
Y3VtZW50YXRpb24NCj4+IGFueW1vcmUsIGJ1dCBmcm9tIHdoYXQgSSByZW1lbWJlciBldmVyeSBw
aHlzaWNhbCBlbmRwb2ludCBfY2FuXyBiZQ0KPj4gY29uZmlndXJlZCBhcyBiaWRpcmVjdGlvbmFs
LiBJbiBvdGhlciB3b3JkcywgRFdDM19VU0IzX05VTV9FUFMgPT0NCj4+IERXQzNfVVNCM19OVU1f
SU5fRVBTIGNvdWxkIG1lYW4gdGhhdCBldmVyeSBlbmRwb2ludCBpbiB0aGUgc3lzdGVtIGlzDQo+
PiBiaWRpcmVjdGlvbmFsLg0KPj4NCj4+PiBzdXJlIHdoeSB5b3Ugd291bGQgZXZlciB3YW50IHRv
IGRvIHRoYXQgYmVjYXVzZSB0aGF0IHdpbGwgcHJldmVudCBhbnkNCj4+PiBkZXZpY2UgZnJvbSB3
b3JraW5nLiBUaGUgcmVhc29uIHdlIGhhdmUgRFdDX1VTQjN4X05VTV9JTl9FUFMgYW5kDQo+Pj4g
RFdDX1VTQjN4X05VTV9FUFMgZXhwb3NlZCBpbiB0aGUgZ2xvYmFsIEhXIHBhcmFtIHNvIHRoYXQg
dGhlIGRyaXZlciBrbm93DQo+Pj4gaG93IG1hbnkgZW5kcG9pbnRzIGFyZSBhdmFpbGFibGUgZm9y
IGVhY2ggZGlyZWN0aW9uLiBJZiBmb3Igc29tZSByZWFzb24NCj4+PiB0aGlzIG1lY2hhbmlzbSBm
YWlscywgdGhlcmUncyBzb21ldGhpbmcgZnVuZGFtZW50YWxseSB3cm9uZyBpbiB0aGUgSFcNCj4+
PiBjb25maWd1cmF0aW9uLiBXZSBoYXZlIG5vdCBzZWVuIHRoaXMgcHJvYmxlbSwgYW5kIEkgZG9u
J3QgdGhpbmsgQnJ5YW4NCj4+PiBkaWQgZnJvbSBoaXMgY29tbWl0IHN0YXRlbWVudCBlaXRoZXIu
DQo+PiBQbGVhc2UgY29uZmlybSB0aGlzIGludGVybmFsbHkuIFRoYXQgd2FzIG15IG9yaWdpbmFs
IGFzc3VtcHRpb24gdG9vLA0KPj4gdW50aWwgQnJ5YW4gcG9pbnRlZCBtZSB0byBhIHBhcnRpY3Vs
YXIgc2VjdGlvbiBvZiB0aGUNCj4+IHNwZWNpZmljYXRpb24uIFVuZm9ydHVuYXRlbHkgaXQncyBm
YXIgdG9vIGxvbmcgYWdvIGFuZCBJIGNhbid0IGV2ZW4NCj4+IHZlcmlmeSBkb2N1bWVudGF0aW9u
IDotKQ0KPj4NCj4+Pj4gSG93IGhhdmUgeW91IHZlcmlmaWVkIHRoaXMgcGF0Y2g/IERpZCB5b3Ug
cmVhZCBCcnlhbidzIGNvbW1pdCBsb2c/IFRoaXMNCj4+Pj4gaXMgbGlrZWx5IHRvIHJlaW50cm9k
dWNlIHRoZSBwcm9ibGVtIHJhaXNlZCBieSBCcnlhbi4NCj4+Pj4NCj4+PiBXZSB2ZXJpZmllZCB3
aXRoIG91ciBGUEdBIEhBUFMgd2l0aCB2YXJpb3VzIG51bWJlciBvZiBlbmRwb2ludHMuIE5vDQo+
Pj4gaXNzdWUgaXMgc2Vlbi4NCj4+IFRoYXQncyBjb29sLiBDb3VsZCB5b3UgcGxlYXNlIG1ha2Ug
c3VyZSBvdXIgdW5kZXJzdGFuZGluZyBvZiB0aGlzIGlzDQo+PiBzb3VuZCBhbmQgd29uJ3QgaW50
ZXJmZXJlIHdpdGggYW55IGRlc2lnbnM/IElmIHdlIG1vZGlmeSB0aGlzIHBhcnQgb2YNCj4+IHRo
ZSBjb2RlIGFnYWluLCBJJ2QgbGlrZSB0byBzZWUgYSBjbGVhciByZWZlcmVuY2UgdG8gYSBzcGVj
aWZpYyBzZWN0aW9uDQo+PiBvZiB0aGUgZGF0YWJvb2sgZGV0YWlsaW5nIHRoZSBleHBlY3RlZCBi
ZWhhdmlvciA6LSkNCj4+DQo+PiBjaGVlcnMNCj4+DQo+IEhtLi4uIEkgZGlkbid0IGNvbnNpZGVy
IGJpZGlyZWN0aW9uIGVuZHBvaW50IG90aGVyIHRoYW4gY29udHJvbCBlbmRwb2ludC4NCj4NCj4g
RFdDM19VU0IzeF9OVU1fRVBTIHNwZWNpZmllcyB0aGUgbnVtYmVyIG9mIGRldmljZSBtb2RlIGZv
ciBzaW5nbGUNCj4gZGlyZWN0aW9uYWwgZW5kcG9pbnRzLiBBIGJpZGlyZWN0aW9uYWwgZW5kcG9p
bnQgbmVlZHMgMiBzaW5nbGUNCj4gZGlyZWN0aW9uYWwgZW5kcG9pbnRzLCAxIElOIGFuZCAxIE9V
VC4gU28sIGlmIHlvdXIgc2V0dXAgdXNlcyAzDQo+IGJpZGlyZWN0aW9uIGVuZHBvaW50cyBhbmQg
b25seSB0aG9zZSwgRFdDM19VU0IzeF9OVU1fRVBTIHNob3VsZCBiZSA2Lg0KPiBEV0MzX1VTQjN4
X05VTV9JTl9FUFMgc3BlY2lmaWVzIHRoZSBtYXhpbXVtIG51bWJlciBvZiBJTiBlbmRwb2ludCBh
Y3RpdmUNCj4gYXQgYW55IHRpbWUuDQo+DQo+IEhvd2V2ZXIsIEkgd2lsbCBoYXZlIHRvIGRvdWJs
ZSBjaGVjayBhbmQgY29uZmlybSBpbnRlcm5hbGx5IHJlZ2FyZGluZw0KPiBob3cgdG8gZGV0ZXJt
aW5lIG1hbnkgZW5kcG9pbnQgd291bGQgYmUgYXZhaWxhYmxlIGlmIGJpZGlyZWN0aW9uDQo+IGVu
ZHBvaW50cyBjb21lIGludG8gcGxheS4NCj4NCj4gVGhhbmtzIGZvciBwb2ludGluZyB0aGlzIG91
dC4gV2lsbCBnZXQgYmFjayBvbiB0aGlzLg0KPg0KPiBUaGluaA0KPg0KDQpPay4gSnVzdCBoYWQg
c29tZSBkaXNjdXNzaW9uIGludGVybmFsbHkuIFNvLCBsaWtlIHlvdSBzYWlkLCBhbnkgZW5kcG9p
bnQNCmNhbiBiZSBjb25maWd1cmVkIGluIGVpdGhlciBkaXJlY3Rpb24uIEhvd2V2ZXIsIHdlIGFy
ZSBsaW1pdGVkIHRvDQpjb25maWd1cmluZyB1cCB0byBEV0NfVVNCM3hfTlVNX0lOX0VQUyBiZWNh
dXNlIGVhY2ggSU4gZW5kcG9pbnQgaGFzIGl0cw0Kb3duIFR4RklGTyB3aGlsZSBmb3IgT1VULCB0
aGV5IHNoYXJlIHRoZSBzYW1lIFJ4RklGTy4gU28gd2UgY291bGQgaGF2ZQ0KdXAgdG8gRFdDX1VT
QjN4X05VTV9FUFMgbnVtYmVyIG9mIE9VVCBlbmRwb2ludHMuIFNvLCB0aGUgaXNzdWUgQnJ5YW4N
CmF0dGVtcHRlZCB0byBhZGRyZXNzIGlzIHN0aWxsIHRoZXJlLg0KDQpIb3dldmVyLCB0aGUgY3Vy
cmVudCBjb2RlIHN0aWxsIGhhcyBzb21lIGFzc3VtcHRpb24gb24gdGhlIG51bWJlciBvZiBJTg0K
YW5kIE9VVCBlbmRwb2ludHMsIEkgbmVlZCB0byB0aGluayBvZiBhIGJldHRlciBzb2x1dGlvbi4N
Cg0KVGhhbmtzLA0KVGhpbmgNCg==
