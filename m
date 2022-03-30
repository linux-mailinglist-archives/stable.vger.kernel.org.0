Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498964EC9FC
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349026AbiC3QvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349024AbiC3QvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:51:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2830291B95
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:49:31 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-171-OdJNmHH-OkG16xrsJn1FdQ-1; Wed, 30 Mar 2022 17:49:28 +0100
X-MC-Unique: OdJNmHH-OkG16xrsJn1FdQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 17:49:26 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 17:49:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Brooks' <m@sweetwater.ai>, Sasha Levin <sashal@kernel.org>
CC:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Thread-Topic: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Thread-Index: AQHYRFBkazg7jsklk0a1utosLd+h4azYHFQA
Date:   Wed, 30 Mar 2022 16:49:25 +0000
Message-ID: <9e78091d07d74550b591c6a594cd72cc@AcuMS.aculab.com>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-16-sashal@kernel.org>
 <CAOnCY6TTx65+Z7bBwgmd8ogrCH78pps59u3_PEbq0fUpd1n_6A@mail.gmail.com>
In-Reply-To: <CAOnCY6TTx65+Z7bBwgmd8ogrCH78pps59u3_PEbq0fUpd1n_6A@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTWljaGFlbCBCcm9va3MNCj4gU2VudDogMzAgTWFyY2ggMjAyMiAxNzowOA0KLi4uDQo+
IEnigJlkIGxpa2UgdG8gZGVzY3JpYmUgdGhpcyBidWcgdXNpbmcgbWF0aGVtYXRpY3MsIGJlY2F1
c2UgdGhhdCBpcyBob3cgSQ0KPiB3b3JrIC0gSSBhbSB0aGUga2luZCBvZiBwZXJzb24gdGhhdCBh
cHByZWNpYXRlcyByaWdvci4gIEluIHRoaXMgY2FzZSwNCj4gbGV0J3MgdXNlIGluZHVjdGl2ZSBy
ZWFzb25pbmcgdG8gaWxsdW1pbmF0ZSB0aGlzIGlzc3VlLg0KPiANCj4gTm93LCBpbiB0aGlzIGF0
dGFjayBzY2VuYXJpbyBsZXQg4oCccOKAnSBiZSB0aGUgb3ZlcmFsbCBwb29sIHN0YXRlIGFuZCBs
ZXQNCj4g4oCcbuKAnSBiZSB0aGUgZ29vZCB1bmtub3duIHZhbHVlcyBhZGRlZCB0byB0aGUgcG9v
bC4gIEZpbmFsbHksIGxldCDigJxr4oCdIGJlDQo+IHRoZSBrbm93biB2YWx1ZXMgLSBzdWNoIGFz
IGppZmZpZXMuICBJZiB3ZSB0aGVuIGRlc2NyaWJlIHRoZSByYXRpbyBvZg0KPiB1bmtub3duIHVu
aXF1ZW5lc3Mgd2l0aCBrbm93biB1bmlxdWVuZXNzIGFzIHA9bi9rIHRoZW4gYXMgYSBrIGdyb3dz
DQo+IHRoZSBvdmVyYWxsIHByZWRpY3RhYmlsaXR5IG9mIHRoZSBwb29sIGFwcHJvYWNoZXMgYW4g
aW5maW5pdGUgdmFsdWUgYXMNCj4gayBhcHByb2FjaGVzIHplcm8uICAgQSBwYXJhbGxlbCBwb29s
LCBsZXQncyBjYWxsIGl0IHDigJkgKHRoYXQgaXMNCj4gcHJvbm91bmNlZCDigJxwLXByaW1l4oCd
IGZvciB0aG9zZSB3aG8gZG9u4oCZdCBnZXQgdGhlIG5vdGF0aW9uKS4gIGxldA0KPiBw4oCZPW7i
gJkva+KAmS4gSW4gdGhpcyBjYXNlIHRoZSBhdHRhY2tlciBoYXMgbm8gaG9wZSBvZiBjb25zdHJ1
Y3RpbmcgbuKAmSwNCj4gYnV0IHRoZXkgY2FuIGNvbnN0cnVjdCBr4oCZIC0gdGhlcmVmb3JlIHRo
ZSBhdHRhY2tlcuKAmXMgcGFyYXNvbCBtb2RlbCBvZg0KPiB0aGUgcG9vbCBw4oCZIHdpbGwgYmVj
b21lIG1vcmUgYWNjdXJhdGUgYXMgdGhlIGF0dGFjayBwZXJzaXN0cyBsZWFkaW5nDQo+IHRvIHDi
gJkgPSBwIGFzIHRpbWUtPuKIni4NCj4gDQo+IFEuRS5ELg0KDQpUaGF0IHJhdGhlciBkZXBlbmRz
IG9uIGhvdyB0aGUgKG5vdCkgJ3JhbmRtb25lc3MnIGlzIGFkZGVkIHRvIHRoZSBwb29sLg0KSWYg
dGhlcmUgYXJlICdyJyBiaXRzIG9mIHJhbmRvbW5lc3MgaW4gdGhlIHBvb2wgYW5kIGEgJ3N0aXIg
aW4nIGEgcGlsZQ0Kb2Yga25vd24gYml0cyB0aGVyZSBjYW4gc3RpbGwgYmUgJ24nIGJpdHMgb2Yg
cmFuZG9tbmVzcyBpbiB0aGUgcG9vbC4NCg0KVGhlIHdob2xlIHRoaW5nIHJlYWxseSByZWxpZXMg
b24gdGhlIG5vbi1yZXZlcnNhYmlsaXR5IG9mIHRoZSBmaW5hbCBwcm5nLg0KT3RoZXJ3aXNlIGlm
IHlvdSBoYXZlICdyJyBiaXRzIG9mIHJhbmRvbW5lc3MgaW4gdGhlIHBvb2wgYW5kICdwJyBiaXRz
DQppbiB0aGUgcHJuZyB5b3Ugb25seSBuZWVkIHRvIHJlcXVlc3QgJ3IgKyBwJyBiaXRzIG9mIG91
dHB1dCB0byBiZSBhYmxlDQp0byBzb2x2ZSB0aGUgJ3AgKyByJyBzaW11bHRhbmVvdXMgZXF1YXRp
b25zIGluICdwICsgcicgdW5rbm93bnMNCihJIHRoaW5rIHRoYXQgaXMgaW4gdGhlIGZpZWxkIHsw
LCAxfSkuDQoNClRoZSBvbGQga2VybmVsIHJhbmRvbSBudW1iZXIgZ2VuZXJhdG9yIHRoYXQgdXNl
ZCB4b3IgdG8gY29tYmluZSB0aGUNCm91dHB1dHMgb2Ygc2V2ZXJhbCBMRlNSIGlzIHRyaXZpYWxs
eSByZXZlcnNhYmxlLg0KSXQgd2lsbCBsZWFrIHdoYXRldmVyIGl0IHdhcyBzZWVkZWQgd2l0aC4N
Cg0KVGhlIG5vbi1yZXZlcnNhYmlsaXR5IG9mIHRoZSBwb29sIGlzbid0IGFzIGltcG9ydGFudCBz
aW5jZSB5b3UgbmVlZA0KdG8gcmV2ZXJzZSB0aGUgcHJuZyBhcyB3ZWxsLg0KDQpTbyB3aGlsZSwg
aW4gc29tZSBzZW5zZSwgcmVtb3ZpbmcgJ3AnIGJpdHMgZnJvbSB0aGUgZW50cm9weSBwb29sDQp0
byBzZWVkIHRoZSBwcm5nIG9ubHkgbGVhdmVzICdyIC0gcCcgYml0cyBsZWZ0Lg0KVGhhdCBpcyBv
bmx5IHRydWUgaWYgeW91IHRoaW5rIHRoZSBwcm5nIGlzIHJldmVyc2FibGUuDQpQcm92aWRlZCAn
ciA+IHAnIChwcmVmZXJhYmx5ICdyID4+IHAnKSB5b3UgY2FuIHJlc2VlZCB0aGUgcHJuZw0KYWdh
aW4gKHByb3ZpZGVkIHlvdSB0YWtlIHJlYXNvbmFibHkgcmFuZG9tIGJpdHMpIHdpdGhvdXQNCnJl
YWxseSBleHBvc2luZyBhbnkgbW9yZSBzdGF0ZSB0byBhbiBhdHRhY2tlci4NCg0KU29tZW9uZSBk
b2luZyBjYXQgL2Rldi91cmFuZG9tID4vZGV2L251bGwgc2hvdWxkIGp1c3Qga2VlcCByZWFkaW5n
DQp2YWx1ZXMgb3V0IG9mIHRoZSBlbnRyb3B5IHBvb2wuDQpCdXQgaWYgdGhleSBhcmUgZGlzY2Fy
ZGluZyB0aGUgdmFsdWVzIHRoYXQgc2hvdWxkbid0IGhlbHAgdGhlbQ0KcmVjb3ZlciB0aGUgc3Rh
dGUgb2YgdGhlIGVudHJvcHkgcG9vbCBvciB0aGUgcHJuZyAtIGV2ZW4gaWYgb25seQ0KY29uc3Rh
bnQgdmFsdWVzIGFyZSBiZWluZyBhZGRlZCB0byB0aGUgcG9vbC4NCg0KUmVhbGx5IHdoYXQgeW91
IG11c3RuJ3QgZG8gaXMgZGVsZXRlIHRoZSBiaXRzIHVzZWQgdG8gc2VlZCB0aGUgcHJuZw0KZnJv
bSB0aGUgZW50cm9weSBwb29sLg0KQWJvdXQgdGhlIG9ubHkgd2F5IHRvIGFjdHVhbGx5IHJlZHVj
ZSB0aGUgcmFuZG9tbmVzcyBvZiB0aGUgZW50cm9weQ0KcG9vbCBpcyBpZiB5b3UndmUgZGlzY292
ZXJlZCB3aGF0IGlzIGFjdHVhbGx5IGluIGl0LCBrbm93IHRoZQ0KJ3N0aXJyaW5nJyBhbGdvcml0
aG0gYW5kIGZlZWQgaW4gZGF0YSB0aGF0IGV4YWN0bHkgY2FuY2VscyBvdXQNCmJpdHMgdGhhdCBh
cmUgcHJlc2VudCBhbHJlYWR5Lg0KSSBzdXNwZWN0IHRoYXQgYW55dGhpbmcgd2l0aCByb290IGFj
Y2VzcyBjYW4gbWFuYWdlIHRoYXQhDQooQWx0aG91Z2ggdGhleSBjYW4ganVzdCBvdmVyd3JpdGUg
dGhlIGVudHJvcHkgcG9vbCBpdHNlbGYsDQphbmQgdGhlIHBybmcgZm9yIHRoYXQgbWF0dGVyLikN
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCg==

