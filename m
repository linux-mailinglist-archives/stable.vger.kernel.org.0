Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7920C5FC566
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 14:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJLMfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 08:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiJLMe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 08:34:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE88DFA9
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 05:34:49 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-229-kq7pF1itNsC6iyqikphG3w-1; Wed, 12 Oct 2022 13:34:47 +0100
X-MC-Unique: kq7pF1itNsC6iyqikphG3w-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 12 Oct
 2022 13:34:45 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Wed, 12 Oct 2022 13:34:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Steven Rostedt' <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] tracing: Add "(fault)" name injection to kernel
 probes
Thread-Topic: [PATCH v2 2/3] tracing: Add "(fault)" name injection to kernel
 probes
Thread-Index: AQHY3ifBg4j8RCzGYUSWbqKRph9Bsa4KsQDw
Date:   Wed, 12 Oct 2022 12:34:45 +0000
Message-ID: <13544aa157fc4083a59127bbc5a2bb1e@AcuMS.aculab.com>
References: <20221012104055.421393330@goodmis.org>
 <20221012104534.644803645@goodmis.org>
In-Reply-To: <20221012104534.644803645@goodmis.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogU3RldmVuIFJvc3RlZHQNCj4gU2VudDogMTIgT2N0b2JlciAyMDIyIDExOjQxDQo+IA0K
PiBIYXZlIHRoZSBzcGVjaWZpYyBmdW5jdGlvbnMgZm9yIGtlcm5lbCBwcm9iZXMgdGhhdCByZWFk
IHN0cmluZ3MgdG8gaW5qZWN0DQo+IHRoZSAiKGZhdWx0KSIgbmFtZSBkaXJlY3RseS4gdHJhY2Vf
cHJvYmVzLmMgZG9lcyB0aGlzIHRvbyAoZm9yIHVwcm9iZXMpDQo+IGJ1dCBhcyB0aGUgY29kZSB0
byByZWFkIHN0cmluZ3MgYXJlIGdvaW5nIHRvIGJlIHVzZWQgYnkgc3ludGhldGljIGV2ZW50cw0K
PiAoYW5kIHBlcmhhcHMgb3RoZXIgdXRpbGl0aWVzKSwgaXQgc2ltcGxpZmllcyB0aGUgY29kZSBi
eSBtYWtpbmcgc3VyZSB0aG9zZQ0KPiBvdGhlciB1c2VzIGRvIG5vdCBuZWVkIHRvIGltcGxlbWVu
dCB0aGUgIihmYXVsdCkiIG5hbWUgaW5qZWN0aW9uIGFzIHdlbGwuDQo+IA0KPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBGaXhlczogYmQ4MjYzMWQ3Y2NkYyAoInRyYWNpbmc6IEFkZCBz
dXBwb3J0IGZvciBkeW5hbWljIHN0cmluZ3MgdG8gc3ludGhldGljIGV2ZW50cyIpDQo+IFNpZ25l
ZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IChHb29nbGUpIDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0K
PiAtLS0NCj4gIGtlcm5lbC90cmFjZS90cmFjZV9wcm9iZV9rZXJuZWwuaCB8IDMxICsrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFj
ZV9wcm9iZV9rZXJuZWwuaCBiL2tlcm5lbC90cmFjZS90cmFjZV9wcm9iZV9rZXJuZWwuaA0KPiBp
bmRleCAxZDQzZGYyOWExZjguLjc3ZGJkOWZmOTc4MiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL3Ry
YWNlL3RyYWNlX3Byb2JlX2tlcm5lbC5oDQo+ICsrKyBiL2tlcm5lbC90cmFjZS90cmFjZV9wcm9i
ZV9rZXJuZWwuaA0KPiBAQCAtMiw2ICsyLDggQEANCj4gICNpZm5kZWYgX19UUkFDRV9QUk9CRV9L
RVJORUxfSF8NCj4gICNkZWZpbmUgX19UUkFDRV9QUk9CRV9LRVJORUxfSF8NCj4gDQo+ICsjZGVm
aW5lIEZBVUxUX1NUUklORyAiKGZhdWx0KSINCj4gKw0KPiAgLyoNCj4gICAqIFRoaXMgZGVwZW5k
cyBvbiB0cmFjZV9wcm9iZS5oLCBidXQgY2FuIG5vdCBpbmNsdWRlIGl0IGR1ZSB0bw0KPiAgICog
dGhlIHdheSB0cmFjZV9wcm9iZV90bXBsLmggaXMgdXNlZCBieSB0cmFjZV9rcHJvYmUuYyBhbmQg
dHJhY2VfZXByb2JlLmMuDQo+IEBAIC0xMyw4ICsxNSwxNiBAQCBzdGF0aWMgbm9rcHJvYmVfaW5s
aW5lIGludA0KPiAga2Vybl9mZXRjaF9zdG9yZV9zdHJsZW5fdXNlcih1bnNpZ25lZCBsb25nIGFk
ZHIpDQo+ICB7DQo+ICAJY29uc3Qgdm9pZCBfX3VzZXIgKnVhZGRyID0gIChfX2ZvcmNlIGNvbnN0
IHZvaWQgX191c2VyICopYWRkcjsNCj4gKwlpbnQgcmV0Ow0KPiANCj4gLQlyZXR1cm4gc3Rybmxl
bl91c2VyX25vZmF1bHQodWFkZHIsIE1BWF9TVFJJTkdfU0laRSk7DQo+ICsJcmV0ID0gc3Rybmxl
bl91c2VyX25vZmF1bHQodWFkZHIsIE1BWF9TVFJJTkdfU0laRSk7DQo+ICsJLyoNCj4gKwkgKiBz
dHJubGVuX3VzZXJfbm9mYXVsdCByZXR1cm5zIHplcm8gb24gZmF1bHQsIGluc2VydCB0aGUNCj4g
KwkgKiBGQVVMVF9TVFJJTkcgd2hlbiB0aGF0IG9jY3Vycy4NCj4gKwkgKi8NCj4gKwlpZiAocmV0
IDw9IDApDQo+ICsJCXJldHVybiBzdHJsZW4oRkFVTFRfU1RSSU5HKSArIDE7DQo+ICsJcmV0dXJu
IHJldDsNCj4gIH0NCg0KSXNuJ3QgdGhhdCBnb2luZyB0byBkbyB0aGUgd3JvbmcgdGhpbmcgaWYg
dGhlIHVzZXINCnN0cmluZyBpcyB2YWxpZCBtZW1vcnkgYnV0IGp1c3QgemVybyBsZW5ndGg/Pw0K
DQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQs
IE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86
IDEzOTczODYgKFdhbGVzKQ0K

