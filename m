Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1A4DC4A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 23:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfFTVMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 17:12:35 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:36995 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTVMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 17:12:35 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=svr-ies-mbx-01.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1he4MC-0007MN-8K from Cedric_Hombourger@mentor.com ; Thu, 20 Jun 2019 14:12:32 -0700
Received: from svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2) by
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1) with Microsoft SMTP Server
 (TLS) id 15.0.1320.4; Thu, 20 Jun 2019 22:12:26 +0100
Received: from svr-ies-mbx-02.mgc.mentorg.com ([fe80::a01f:51c9:5b6c:e0c]) by
 svr-ies-mbx-02.mgc.mentorg.com ([fe80::a01f:51c9:5b6c:e0c%22]) with mapi id
 15.00.1320.000; Thu, 20 Jun 2019 22:12:26 +0100
From:   "Hombourger, Cedric" <Cedric_Hombourger@mentor.com>
To:     Paul Burton <paul.burton@mips.com>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Topic: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Index: AQHVIcVrw5tGiAGyckKhKLs3W2AnEaadO4kAgACh3B+ABltc6YAAuWWAgAAkB9I=
Date:   Thu, 20 Jun 2019 21:12:26 +0000
Message-ID: <366B6D73-2DCF-49B6-80B2-B1FAD6C73580@mentor.com>
References: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
 <20190615221604.E6FB82183F@mail.kernel.org> <1560668291651.87711@mentor.com>
 <1561017706300.81899@mentor.com>,<20190620200325.se6e6yicvlkjrb46@pburton-laptop>
In-Reply-To: <20190620200325.se6e6yicvlkjrb46@pburton-laptop>
Accept-Language: en-US, en-IE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gUGF1bCwgDQoNCkkgd2lsbCByZWNoZWNrIHRvbW9ycm93IG1vcm5pbmcgYnV0IHRoZSBr
ZXJuZWwgSSB3YXMgaW5pdGlhbGx5IHdvcmtpbmcgd2l0aCB3YXMgNC4xOSBhbmQgSSBkaWQgbm90
IGZpbmQgZHRicyBiZWluZyBjb21waWxlZCBmcm9tIGEgcGxhaW4gbWFrZSBvciBmcm9tIGJ1aWxk
ZGViIA0KDQpGb3Igd2hhdCBpdOKAmXMgd29ydGgsIEkgd2FzIHVzaW5nIHRoZSBwaXN0YWNoaW9f
ZGVmY29uZmlnLg0KDQpNeSB0ZXN0IHdvcmtmbG93IGlzIGFzIGZvbGxvd3MgKEFSQ0ggYW5kIENS
T1NTX0NPTVBJTEUgYXJlIHNldCBpbiBteSBlbnZpcm9ubWVudCkNCg0KbWFrZSBtcnByb3BlciAN
Cm1ha2UgcGlzdGFjaGlvX2RlZmNvbmZpZw0KbWFrZQ0KZmluZCBhcmNoL21pcHMgLW5hbWUgKi5k
dGINCg0KQ2VkcmljDQoNCj4gT24gMjAgSnVuIDIwMTksIGF0IDIyOjAzLCBQYXVsIEJ1cnRvbiA8
cGF1bC5idXJ0b25AbWlwcy5jb20+IHdyb3RlOg0KPiANCj4gSGkgQ2VkcmljLA0KPiANCj4+IE9u
IFRodSwgSnVuIDIwLCAyMDE5IGF0IDA4OjAxOjQ2QU0gKzAwMDAsIEhvbWJvdXJnZXIsIENlZHJp
YyB3cm90ZToNCj4+IEp1c3QgdG8gZm9sbG93LXVwLiBJIGhhdmUgdmVyaWZpZWQgdGhhdCB3ZSBj
YW4gYXBwbHkgdGhpcyBwYXRjaCB0byA0LjQNCj4+IGFuZCA0Ljkgd2l0aG91dCBpbnRyb2R1Y2lu
ZyBhZGRpdGlvbmFsIHBhdGNoZXMgYnV0IHNpbXBseSByZXNvbHZpbmcNCj4+IGNvbmZsaWN0cy4g
U2hvdWxkIEkgcG9zdCBzZXBhcmF0ZSBwYXRjaGVzIGZvciA0LjQgYW5kIDQuOT8NCj4gDQo+IElz
IHRoZSBwYXRjaCBhY3R1YWxseSBuZWVkZWQgYW55IGVhcmxpZXIgdGhhbiB2NC4yMD8NCj4gDQo+
IExvY2FsbHkgSSd2ZSBhcHBsaWVkIGl0IHRvIG1pcHMtZml4ZXMgJiB0YWdnZWQgaXQgd2l0aDoN
Cj4gDQo+IEZpeGVzOiBkNTYxNWU0NzJkMjMgKCJidWlsZGRlYjogRml4IGluY2x1c2lvbiBvZiBk
dGJzIGluIGRlYmlhbiBwYWNrYWdlIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2
NC4yMCsNCj4gDQo+IEl0IGxvb2tzIHRvIG1lIGxpa2UgcHJpb3IgdG8gdGhhdCBjb21taXQgdGhp
cyBpcyB1bm5lY2Vzc2FyeS4gSWYgdGhhdCdzDQo+IHdyb25nIHBsZWFzZSBsZXQgbWUga25vdy4N
Cj4gDQo+IFRoYW5rcywNCj4gICAgUGF1bA0K
