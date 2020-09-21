Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4672721C8
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 13:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgIULEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 07:04:48 -0400
Received: from mail6.tencent.com ([220.249.245.26]:51298 "EHLO
        mail6.tencent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIULEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 07:04:47 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 07:04:46 EDT
Received: from EX-SZ022.tencent.com (unknown [10.28.6.88])
        by mail6.tencent.com (Postfix) with ESMTP id 5FF89CC3BF;
        Mon, 21 Sep 2020 18:56:04 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1600685764;
        bh=O8QNbStQ058O9sOlx9j+oIL3VADETImqZw5uMR/3tZQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=UI099YqNC+KVhbsZpqPRRhs1KNzDFPd57Wneq6hIulYgxRNVBnf5qWf2YbXsPJewz
         DVTSyrWlOGpNJLFJ9Cc6XukPwCkdyuhjVUZ1CFhg2tzqUlvQwoDs4UFHLqWrZvWR9T
         ww15QK5MFeesJKxB3iiMfbIVNktdggU5/fkrcVfU=
Received: from EX-SZ037.tencent.com (10.28.6.119) by EX-SZ022.tencent.com
 (10.28.6.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 21 Sep
 2020 18:54:39 +0800
Received: from EX-SZ030.tencent.com (10.28.6.105) by EX-SZ037.tencent.com
 (10.28.6.119) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 21 Sep
 2020 18:54:39 +0800
Received: from EX-SZ030.tencent.com ([fe80::d886:80d1:7745:55f2]) by
 EX-SZ030.tencent.com ([fe80::d886:80d1:7745:55f2%5]) with mapi id
 15.01.2106.002; Mon, 21 Sep 2020 18:54:39 +0800
From:   =?utf-8?B?bGloYWl3ZWko5p2O5rW35LyfKQ==?= <lihaiwei@tencent.com>
To:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree(Internet mail)
Thread-Topic: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree(Internet mail)
Thread-Index: AQHWkAPyNsvRBY9Y6ECvlUfIeS5CYqlyZQ2A
Date:   Mon, 21 Sep 2020 10:54:38 +0000
Message-ID: <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
References: <20200921104234.9C539216C4@mail.kernel.org>
In-Reply-To: <20200921104234.9C539216C4@mail.kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.87.252]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD3BD3C11E30714D955D7583459AD011@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IE9uIFNlcCAyMSwgMjAyMCwgYXQgMTg6NDIsIFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBUaGlzIGlzIGEgbm90ZSB0byBsZXQgeW91IGtub3cgdGhhdCBJ
J3ZlIGp1c3QgYWRkZWQgdGhlIHBhdGNoIHRpdGxlZA0KPiANCj4gICAgS1ZNOiBDaGVjayB0aGUg
YWxsb2NhdGlvbiBvZiBwdiBjcHUgbWFzaw0KPiANCj4gdG8gdGhlIDUuOC1zdGFibGUgdHJlZSB3
aGljaCBjYW4gYmUgZm91bmQgYXQ6DQo+ICAgIGh0dHA6Ly93d3cua2VybmVsLm9yZy9naXQvP3A9
bGludXgva2VybmVsL2dpdC9zdGFibGUvc3RhYmxlLXF1ZXVlLmdpdDthPXN1bW1hcnkNCj4gDQo+
IFRoZSBmaWxlbmFtZSBvZiB0aGUgcGF0Y2ggaXM6DQo+ICAgICBrdm0tY2hlY2stdGhlLWFsbG9j
YXRpb24tb2YtcHYtY3B1LW1hc2sucGF0Y2gNCj4gYW5kIGl0IGNhbiBiZSBmb3VuZCBpbiB0aGUg
cXVldWUtNS44IHN1YmRpcmVjdG9yeS4NCj4gDQo+IElmIHlvdSwgb3IgYW55b25lIGVsc2UsIGZl
ZWxzIGl0IHNob3VsZCBub3QgYmUgYWRkZWQgdG8gdGhlIHN0YWJsZSB0cmVlLA0KPiBwbGVhc2Ug
bGV0IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBrbm93IGFib3V0IGl0Lg0KPiANCg0KVGhpcyBw
YXRjaCBpcyBub3QgYSBjb3JyZWN0IHZlcnNpb24sIHNvIHBsZWFzZSBkb27igJl0IGFkZCB0aGlz
IHRvIHRoZSBzdGFibGUgdHJlZSwgdGhhbmtzLg0KDQpIYWl3ZWkgTGk=
