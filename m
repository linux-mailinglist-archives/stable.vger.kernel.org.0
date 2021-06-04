Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFBA39AF48
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 02:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFDBAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 21:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFDBAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 21:00:45 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E1C06175F
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 17:58:59 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 3FD2583646;
        Fri,  4 Jun 2021 12:58:55 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1622768335;
        bh=zwNUaTjAbpv1AFg+QPg/Vg7UwSsAWQWNnYKed5KvvTk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=KR96dkMMQinX+bP65+2Q0rszCTuMvoppTCWuy+gQS4p6ZIGBeItOQ0p3MA77t8/Lu
         y/FeFVhvYSxOI97mdpXkL9U0U5gQVkUJeRI+MSbI9vCJkzho5VsSzd1v1HReV8zFGX
         jDY+VVsVte0g97KU0VoYxmywQC4JiP881XWx8A8xzqA3YuQxjPkBv1qHKnrGAf8dlN
         MHtyFWEYs9sWHIBcvpeT0YrIMXQEBi3xc085hTf6H0AVuKad4l1/QALPvedTpr1lYK
         Y44s4AczmzuEDySiGOkwBCQjb+cHeiqpEkv+xu7eA6YoVhrjyfBxM/gzSlUwzLZx3p
         9BMpXCuFlrAmA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60b97acf0001>; Fri, 04 Jun 2021 12:58:55 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 4 Jun 2021 12:58:54 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.018; Fri, 4 Jun 2021 12:58:54 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Wolfram Sang <wsa@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH AUTOSEL 5.12 42/43] powerpc/fsl: set
 fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Thread-Topic: [PATCH AUTOSEL 5.12 42/43] powerpc/fsl: set
 fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Thread-Index: AQHXWJsTg7j0i+0vFEmVHttQ1zQLv6sCOo2AgAAEpgA=
Date:   Fri, 4 Jun 2021 00:58:54 +0000
Message-ID: <81ce50f1-73eb-687b-898a-df5f6ac68c5a@alliedtelesis.co.nz>
References: <20210603170734.3168284-1-sashal@kernel.org>
 <20210603170734.3168284-42-sashal@kernel.org>
 <87y2bqfok8.fsf@mpe.ellerman.id.au>
In-Reply-To: <87y2bqfok8.fsf@mpe.ellerman.id.au>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFC7101B35858B4299C03D6BEAC444BB@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=WOcBoUkR c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=0PHfWf00bOpdARfqvbcA:9 a=QEXdDO2ut3YA:10 a=N53muDpBR4cA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiA0LzA2LzIxIDEyOjQyIHBtLCBNaWNoYWVsIEVsbGVybWFuIHdyb3RlOg0KPiBTYXNoYSBM
ZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+IHdyaXRlczoNCj4+IEZyb206IENocmlzIFBhY2toYW0g
PGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNpcy5jby5uej4NCj4+DQo+PiBbIFVwc3RyZWFtIGNv
bW1pdCA3YWRjN2IyMjVjZGRjZmQwZjM0NmQxMDE0NGZkN2EzZDNkOWY5ZWE3IF0NCj4+DQo+PiBU
aGUgaTJjIGNvbnRyb2xsZXJzIG9uIHRoZSBQMjA0MC9QMjA0MSBoYXZlIGFuIGVycmF0dW0gd2hl
cmUgdGhlDQo+PiBkb2N1bWVudGVkIHNjaGVtZSBmb3IgaTJjIGJ1cyByZWNvdmVyeSB3aWxsIG5v
dCB3b3JrIChBLTAwNDQ0NykuIEENCj4+IGRpZmZlcmVudCBtZWNoYW5pc20gaXMgbmVlZGVkIHdo
aWNoIGlzIGRvY3VtZW50ZWQgaW4gdGhlIFAyMDQwIENoaXANCj4+IEVycmF0YSBSZXYgUSAobGF0
ZXN0IGF2YWlsYWJsZSBhdCB0aGUgdGltZSBvZiB3cml0aW5nKS4NCj4+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBDaHJpcyBQYWNraGFtIDxjaHJpcy5wYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+DQo+
PiBBY2tlZC1ieTogTWljaGFlbCBFbGxlcm1hbiA8bXBlQGVsbGVybWFuLmlkLmF1Pg0KPj4gU2ln
bmVkLW9mZi1ieTogV29sZnJhbSBTYW5nIDx3c2FAa2VybmVsLm9yZz4NCj4+IFNpZ25lZC1vZmYt
Ynk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPj4gICBhcmNoL3Bv
d2VycGMvYm9vdC9kdHMvZnNsL3AyMDQxc2ktcG9zdC5kdHNpIHwgMTYgKysrKysrKysrKysrKysr
Kw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKQ0KPiBUaGlzIHBhdGNoIChh
bmQgdGhlIHN1YnNlcXVlbnQgb25lKSwganVzdCBzZXQgYSBmbGFnIGluIHRoZSBkZXZpY2UgdHJl
ZS4NCj4NCj4gVGhleSBoYXZlIG5vIGVmZmVjdCB1bmxlc3MgeW91IGFsc28gYmFja3BvcnQgdGhl
IGNvZGUgY2hhbmdlIHRoYXQgbG9va3MNCj4gZm9yIHRoYXQgZmxhZywgd2hpY2ggd2FzIHVwc3Ry
ZWFtIGNvbW1pdDoNCj4NCj4gICAgOGYwY2RlYzhiNWZkICgiaTJjOiBtcGM6IGltcGxlbWVudCBl
cnJhdHVtIEEtMDA0NDQ3IHdvcmthcm91bmQiKQ0KDQpUaGF0IGNoYW5nZSBpdHNlbGYgaXNuJ3Qg
Y2hlcnJ5LXBpY2sgYWJsZSB3aXRob3V0DQoNCjY1MTcxYjJkZjE1ZSAoImkyYzogbXBjOiBNYWtl
IHVzZSBvZiBpMmNfcmVjb3Zlcl9idXMoKSIpDQoNCmFuZCBpbiBiZXR3ZWVuIDY1MTcxYjJkZjE1
ZSBhbmQgOGYwY2RlYzhiNWZkIGFyZSBhIGJ1bmNoIG9mIGNsZWFudXBzIGFuZCANCmEgZmFpcmx5
IG1ham9yIHJld3JpdGUgd2hpY2ggbWF5IGFsc28gYWZmZWN0IHRoZSBjaGVycnktcGljayBhYmls
aXR5Lg0KDQo+IEFGQUlDUyB5b3UgaGF2ZW4ndCBwaWNrZWQgdGhhdCBvbmUgdXAgZm9yIGFueSBv
ZiB0aGUgc3RhYmxlIHRyZWVzLg0KPg0KPiBJJ2xsIGRlZmVyIHRvIENocmlzICYgV29sZnJhbSBv
biB3aGV0aGVyIGl0J3MgYSBnb29kIGlkZWEgdG8gdGFrZSB0aGUNCj4gY29kZSBjaGFuZ2UgZm9y
IHN0YWJsZS4NCg0KV2UgaGF2ZSBiZWVuIGRvaW5nIHNvbWUgZXh0cmEgUUEgb24gb3VyIGVuZCBm
b3IgdGhlICJpMmM6IG1wYzogUmVmYWN0b3IgDQp0byBpbXByb3ZlIHJlc3BvbnNpdmVuZXNzIiBh
bmQgIlAyMDQwL1AyMDQxIGkyYyByZWNvdmVyeSBlcnJhdHVtIiBzZXJpZXMgDQp3aGljaCBoYXNu
J3QgdGhyb3duIHVwIGFueSBpc3N1ZXMuIEJ1dCBpdCdzIHN0aWxsIGEgbG90IG9mIG5ldyBjb2Rl
IGFuZCANCmF0IHNvbWUgcG9pbnQgd2UncmUgZ29pbmcgdG8gcnVuIGludG8gQVBJIGNoYW5nZXMu
DQoNCkdpdmVuIHRoZSBmYWN0IHRoYXQgaXQncyBzdGFydGluZyB0byBzbm93YmFsbCBvbmUgbWln
aHQgZXJyIG9uIHRoZSBzaWRlIA0Kb2YgY2F1dGlvbi4NCg0KPiBJIGd1ZXNzIGl0J3MgaGFybWxl
c3MgdG8gcGljayB0aGVzZSB0d28gcGF0Y2hlcywgYnV0IGl0J3MgYWxzbw0KPiBwb2ludGxlc3Mu
IFNvIEkgdGhpbmsgeW91IGVpdGhlciB3YW50IHRvIHRha2UgYWxsIHRocmVlLCBvciBkcm9wIHRo
ZXNlDQo+IHR3by4NCg0KQXQgYSBtaW5pbXVtIHlvdSBuZWVkDQoNCjY1MTcxYjJkZjE1ZSAoImky
YzogbXBjOiBNYWtlIHVzZSBvZiBpMmNfcmVjb3Zlcl9idXMoKSIpDQo4ZjBjZGVjOGI1ZmQgKCJp
MmM6IG1wYzogaW1wbGVtZW50IGVycmF0dW0gQS0wMDQ0NDcgd29ya2Fyb3VuZCIpDQo3YWRjN2Iy
MjVjZGQgKCJwb3dlcnBjL2ZzbDogc2V0IGZzbCxpMmMtZXJyYXR1bS1hMDA0NDQ3IGZsYWcgZm9y
IFAyMDQxIA0KaTJjIGNvbnRyb2xsZXJzIikNCjE5YWU2OTdhMWU0ZSAoInBvd2VycGMvZnNsOiBz
ZXQgZnNsLGkyYy1lcnJhdHVtLWEwMDQ0NDcgZmxhZyBmb3IgUDEwMTAgDQppMmMgY29udHJvbGxl
cnMiKQ0KDQo+IGNoZWVycw0KPg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9ib290L2R0
cy9mc2wvcDIwNDFzaS1wb3N0LmR0c2kgYi9hcmNoL3Bvd2VycGMvYm9vdC9kdHMvZnNsL3AyMDQx
c2ktcG9zdC5kdHNpDQo+PiBpbmRleCA4NzJlNDQ4NWRjM2YuLmRkYzAxOGQ0MjI1MiAxMDA2NDQN
Cj4+IC0tLSBhL2FyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wvcDIwNDFzaS1wb3N0LmR0c2kNCj4+
ICsrKyBiL2FyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wvcDIwNDFzaS1wb3N0LmR0c2kNCj4+IEBA
IC0zNzEsNyArMzcxLDIzIEBAIHNkaGNAMTE0MDAwIHsNCj4+ICAgCX07DQo+PiAgIA0KPj4gICAv
aW5jbHVkZS8gInFvcmlxLWkyYy0wLmR0c2kiDQo+PiArCWkyY0AxMTgwMDAgew0KPj4gKwkJZnNs
LGkyYy1lcnJhdHVtLWEwMDQ0NDc7DQo+PiArCX07DQo+PiArDQo+PiArCWkyY0AxMTgxMDAgew0K
Pj4gKwkJZnNsLGkyYy1lcnJhdHVtLWEwMDQ0NDc7DQo+PiArCX07DQo+PiArDQo+PiAgIC9pbmNs
dWRlLyAicW9yaXEtaTJjLTEuZHRzaSINCj4+ICsJaTJjQDExOTAwMCB7DQo+PiArCQlmc2wsaTJj
LWVycmF0dW0tYTAwNDQ0NzsNCj4+ICsJfTsNCj4+ICsNCj4+ICsJaTJjQDExOTEwMCB7DQo+PiAr
CQlmc2wsaTJjLWVycmF0dW0tYTAwNDQ0NzsNCj4+ICsJfTsNCj4+ICsNCj4+ICAgL2luY2x1ZGUv
ICJxb3JpcS1kdWFydC0wLmR0c2kiDQo+PiAgIC9pbmNsdWRlLyAicW9yaXEtZHVhcnQtMS5kdHNp
Ig0KPj4gICAvaW5jbHVkZS8gInFvcmlxLWdwaW8tMC5kdHNpIg0KPj4gLS0gDQo+PiAyLjMwLjI=
