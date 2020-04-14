Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21E01A7809
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438077AbgDNKFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:05:16 -0400
Received: from esa4.mentor.iphmx.com ([68.232.137.252]:39640 "EHLO
        esa4.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438054AbgDNKFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:05:15 -0400
IronPort-SDR: TiLek+a2/r6GdLmWlpuMKXK9N+KW7PjR/zhkIvOy4PLzhLynfJuZQqMqo/v5DG3dOP/g/VZ/vP
 K/L9bclQXwUvOzh9EdHIieKoLwOgKuI+P3tru68MLJuRfNaH8pG37jLpdx9lNQ6NbdBNzLHg2x
 o1KxgAR33WIZ08wihNx/O2rGNFl9gh3009u8vuphZdRMGkmZMtVheAQodkfX3pycBC+ZitntzZ
 /gbt0xv+Cf4y6etMiTTYNkBuiz/evFSBx++xzMlg7LHdFBWUlzkEARvj2hQGkSV52r+LioGmPX
 P4w=
X-IronPort-AV: E=Sophos;i="5.72,382,1580803200"; 
   d="scan'208";a="47775850"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa4.mentor.iphmx.com with ESMTP; 14 Apr 2020 02:05:14 -0800
IronPort-SDR: mZRSFsLxdKwc5YdeZbqbpf/k5RDlWQh3qrT5vBBnVLhlgKf+x4UTKKLH/GDSnsAN5LxQdkZ1Ch
 jpmRQ0e9LC4hywQuw6XT9RPC2qf0JfbEfKMbXpSxIx10eDyIi5NNTIm00Fc29VUsqfTvmvGyag
 6ByCgYiXvFF0VgVKMSdzBEET9vdz4Qp+wbjBhNal+fgGaith2FpbOjvWHdi+YSUDLwYIJMiGMa
 +soPhhdqT1aoTN1sNID1FfHSavOqot10rBzepYO0FqRKTK4EEfCbfx3bzIa3WQQZTGro8EUr6F
 WR8=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: AW: Patchset for CVE-2020-1749 Kernel 4.19
Thread-Topic: Patchset for CVE-2020-1749 Kernel 4.19
Thread-Index: AQHWDNb1sUl0Jcmg8Eu4qmgAVBhB7qhzwsUAgASnSiA=
Date:   Tue, 14 Apr 2020 10:05:09 +0000
Message-ID: <baec5c33121948aca8660b5bdaf9643c@SVR-IES-MBX-03.mgc.mentorg.com>
References: <1586262823357.14177@mentor.com>
 <20200411114450.GE2606747@kroah.com>
In-Reply-To: <20200411114450.GE2606747@kroah.com>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiA+IEFwcGxpZXMgdG8gc3RhYmxlIGxpbnV4LXY0LjE5LnkgKHdpdGggeT0xMTQpLg0KPg0KPiBI
YXZlIHlvdSBiZWVuIGFibGUgdG8gdGVzdCB0aGVzZSBwYXRjaGVzIHNvIHRoYXQgeW91IGtub3cg
dGhleSB3b3JrPw0KPg0KSSBkaWQgYXBwbHkgYW5kIGNvbXBpbGUgb24geDg2IGluIGJvdGggNC4x
NCBhbmQgNC4xOSAobWFraW5nIHN1cmUgdG8gaGF2ZSBhbGwgQ09ORklHX3Mgc2V0DQp0byBjb21w
aWxlIHRoZSBjaGFuZ2VkIGNvZGUpLg0KSSB0aGVuIHJhbiA0LjE0IChwcm9qZWN0IGtlcm5lbCkg
b24gb3VyIHRhcmdldDsgaG93ZXZlciBpIGNhbid0IGJ1aWxkIGFuDQplbmNyeXB0ZWQgSVB2NiB0
dW5uZWwgdG8gdmVyaWZ5IGlmIHRoZSBwYXRjaHNldCBoZWxwcy4NCihGcm9tIHRoZSBwYXRjaCBk
ZXNjcmlwdGlvbnMsIGl0IHJlYWxseSBsb29rcyBsaWtlIHRoZXkgZml4IHRoaXMpDQoNCklQdjYg
dHVubmVsIHRlc3Rpbmcgd2lsbCBiZSBkb25lIGJ5IG90aGVyIGZvbGtzIGluIHRoZSBwcm9qZWN0
LCBpIGNhbid0IHRlbGwgd2hlbiBkdWUgdG8NCnRoZSBDb1ZpZCBzaXR1YXRpb24gYXMgdGhpcyBy
ZXF1aXJlcyBzcGVjaWFsIGVxdWlwbWVudCB0aGF0IGkgY2FuJ3QgYWNjZXNzIGF0IGFsbC4NCg0K
PiBBbmQgY2FuIHlvdSBwbGVhc2Ugc2VuZCB0aGVtIGFzIGEgcGF0Y2ggc2VyaWVzLCBub3QgYXMg
YXR0YWNobWVudHMsIGFuZA0KPiAgY2M6IGFsbCB0aGUgb3JpZ2luYWwgYXV0aG9ycyBzbyB0aGF0
IGV2ZXJ5b25lIGNhbiBrbm93IHdoYXQgaXMgZ29pbmcgb24NCj4gYW5kIHdlaWdoIGluIGlmIHRo
ZXkgc2VlIGFueSBpc3N1ZXM/DQpPZiBjb3Vyc2UuIFNvcnJ5IHRoYXQgaSBkaWRuJ3QgZG8gdGhp
cyB5ZXQuDQoNCj4NCj4gQW5kIGZpbmFsbHksIGRvIG5vdCBjaGFuZ2UgdGhlIGNoYW5nZWxvZyB0
ZXh0IGZyb20gdGhlIG9yaWdpbmFsIGNvbW1pdHMsDQo+IHRoYXQncyBub3Qgb2suDQpFeGNlcHQg
Zm9yIHRoZSAidXBzdHJlYW0gY29tbWl0IGlkIiwgcmlnaHQ/DQoNCj4gSWYgeW91IG5lZWQgdG8g
cHV0IGFueSBub3RlcyBpbiB0aGVyZSBhcyB0byB3aGF0IHlvdQ0KPiBkaWQsIGZvbGxvdyB0aGUg
Zm9ybWF0IHdlIGhhdmUgYmVlbiB1c2luZyBmb3IgeWVhcnMsIGFuZCBwdXQgaXQgaW4gdGhlDQo+
IHMtby1iOiBhcmVhIGluIGEgc21hbGwgWyBib3ggXQ0KPg0KPiBTYW1lIGZvciB0aGUgNC4xNCBw
YXRjaGVzLg0KPg0KPiB0aGFua3MsDQo+DQo+IGdyZWcgay1oDQoNCk9mIGNvdXJzZSBpIHdpbGwg
ZG8gc28sIGlmIGl0IG1ha2VzIHNlbnNlIGR1ZSB0byBsaXR0bGUgdGVzdGluZyBlZmZvcnQgcG9z
c2libGUuDQpQbGVhc2UgZ2l2ZSBhIHNob3J0IG5vdGljZSBpZiB5b3UgdGhpbmsgaSBzaG91bGQg
cmVzZW5kIHRoZSBwYXRjaCBzZXJpZXMuDQoNCk9uZSBxdWVzdGlvbjoNCk91ciBJVCBkZXBhcnRt
ZW50IGFkZHMgYSBzaWduYXR1cmUgc2luY2UgYSBmZXcgZGF5cywgYWZ0ZXIgYSBsaW5lIHdpdGgg
Ii0tLS0iLg0KSXMgdGhpcyBhIHByb2JsZW0/IEkgY2FuJ3QgdHVybiB0aGF0IG9mZiwgdW5mb3J0
dW5hdGVseS4NCihBdCBsZWFzdCB0aGV5IGtlZXAgdGhlICJ0ZXh0IG9ubHkiIGFuZCBkb24ndCBz
d2l0Y2ggdG8gSFRNTCkNCg0KVGhhbmtzIGZvciB5b3VyIGd1aWRhbmNlIGFuZCBwYXRpZW5jZQ0K
Q2Fyc3Rlbg0KDQoNCi0tLS0tLS0tLS0tLS0tLS0tDQpNZW50b3IgR3JhcGhpY3MgKERldXRzY2hs
YW5kKSBHbWJILCBBcm51bGZzdHJhw59lIDIwMSwgODA2MzQgTcO8bmNoZW4gLyBHZXJtYW55DQpS
ZWdpc3RlcmdlcmljaHQgTcO8bmNoZW4gSFJCIDEwNjk1NSwgR2VzY2jDpGZ0c2bDvGhyZXI6IFRo
b21hcyBIZXVydW5nLCBBbGV4YW5kZXIgV2FsdGVyDQo=
