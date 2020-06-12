Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE01F7E56
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 23:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFLVPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 17:15:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:14108 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFLVPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 17:15:04 -0400
IronPort-SDR: MCCOQCChfnCwX2l+PV2o/UCnHO1vKHjL6EFZo2Fa1/O5zCGRrWIu+6+b5bq5nG9HQgz7c0LMdG
 tRKyFbv/6ZAw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 14:15:02 -0700
IronPort-SDR: 9jEnb0J/8iNb01XP8SgVt48Z+yUyBMYTIJ1nvmUz11iwfDE/fFBeyitAij+2I08k+AzOu9s232
 vZ9fEwOl+vAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,504,1583222400"; 
   d="scan'208";a="474177969"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2020 14:15:02 -0700
Received: from fmsmsx116.amr.corp.intel.com ([169.254.2.40]) by
 fmsmsx107.amr.corp.intel.com ([169.254.6.74]) with mapi id 14.03.0439.000;
 Fri, 12 Jun 2020 14:15:02 -0700
From:   "Bloomfield, Jon" <jon.bloomfield@intel.com>
To:     "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     Alexandre Oliva <lxoliva@fsfla.org>,
        "Nikula, Jani" <jani.nikula@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: RE: [Intel-gfx] [PATCH] drm/i915: Include asm sources for {ivb,
 hsw}_clear_kernel.c
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Include asm sources for {ivb,
 hsw}_clear_kernel.c
Thread-Index: AQHWPb0fo9enPoB9uE2hEd1TN1omiajPelMAgANIDYCAAr1QgA==
Date:   Fri, 12 Jun 2020 21:15:02 +0000
Deferred-Delivery: Fri, 12 Jun 2020 21:14:22 +0000
Message-ID: <AD48BB7FB99B174FBCC69E228F58B3B6B78F0D73@fmsmsx116.amr.corp.intel.com>
References: <159163988890.30073.8976615673203599761@build.alporthouse.com>
 <20200610201807.191440-1-rodrigo.vivi@intel.com>
In-Reply-To: <20200610201807.191440-1-rodrigo.vivi@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC1nZnggPGludGVsLWdm
eC1ib3VuY2VzQGxpc3RzLmZyZWVkZXNrdG9wLm9yZz4gT24gQmVoYWxmIE9mDQo+IFJvZHJpZ28g
Vml2aQ0KPiBTZW50OiBXZWRuZXNkYXksIEp1bmUgMTAsIDIwMjAgMToxOCBQTQ0KPiBUbzogaW50
ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBDYzogQWxleGFuZHJlIE9saXZhIDxseG9s
aXZhQGZzZmxhLm9yZz47IE5pa3VsYSwgSmFuaSA8amFuaS5uaWt1bGFAaW50ZWwuY29tPjsNCj4g
c3RhYmxlQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxzb24u
Y28udWs+DQo+IFN1YmplY3Q6IFtJbnRlbC1nZnhdIFtQQVRDSF0gZHJtL2k5MTU6IEluY2x1ZGUg
YXNtIHNvdXJjZXMgZm9yIHtpdmIsDQo+IGhzd31fY2xlYXJfa2VybmVsLmMNCj4gDQo+IEFsZXhh
bmRyZSBPbGl2YSBoYXMgcmVjZW50bHkgcmVtb3ZlZCB0aGVzZSBmaWxlcyBmcm9tIExpbnV4IExp
YnJlDQo+IHdpdGggY29uY2VybnMgdGhhdCB0aGUgc291cmNlcyB3ZXJlbid0IGF2YWlsYWJsZS4N
Cj4gDQo+IFRoZSBzb3VyY2VzIGFyZSBhdmFpbGFibGUgb24gSUdUIHJlcG9zaXRvcnksIGFuZCBv
bmx5IG9wZW4gc291cmNlDQo+IHRvb2xzIGFyZSB1c2VkIHRvIGdlbmVyYXRlIHRoZSB7aXZiLGhz
d31fY2xlYXJfa2VybmVsLmMgZmlsZXMuDQo+IA0KPiBIb3dldmVyLCB0aGUgcmVtYWluaW5nIGNv
bmNlcm4gZnJvbSBBbGV4YW5kcmUgT2xpdmEgd2FzIGFyb3VuZA0KPiBHUEwgbGljZW5zZSBhbmQg
dGhlIHNvdXJjZSBub3QgYmVlbiBwcmVzZW50IHdoZW4gZGlzdHJpYnV0aW5nDQo+IHRoZSBjb2Rl
Lg0KPiANCj4gU28sIGl0IGxvb2tzIGxpa2UgMiBhbHRlcm5hdGl2ZXMgYXJlIHBvc3NpYmxlLCB0
aGUgdXNlIG9mDQo+IGxpbnV4LWZpcm13YXJlLmdpdCByZXBvc2l0b3J5IHRvIHN0b3JlIHRoZSBi
bG9iIG9yIG1ha2luZyBzdXJlDQo+IHRoYXQgdGhlIHNvdXJjZSBpcyBhbHNvIHByZXNlbnQgaW4g
b3VyIHRyZWUuIFNpbmNlIHRoZSBnb2FsDQo+IGlzIHRvIGxpbWl0IHRoZSBpOTE1IGZpcm13YXJl
IHRvIG9ubHkgdGhlIG1pY3JvLWNvbnRyb2xsZXIgYmxvYnMNCj4gbGV0J3MgbWFrZSBzdXJlIHRo
YXQgd2UgZG8gaW5jbHVkZSB0aGUgYXNtIHNvdXJjZXMgaGVyZSBpbiBvdXIgdHJlZS4NCj4gDQo+
IEJ0dywgSSB0cmllZCB0byBoYXZlIHNvbWUgZGlsaWdlbmNlIGhlcmUgYW5kIG1ha2Ugc3VyZSB0
aGF0IHRoZQ0KPiBhc21zIHRoYXQgdGhlc2UgY29tbWl0cyBhcmUgYWRkaW5nIGFyZSB0cnVseSB0
aGUgc291cmNlIGZvcg0KPiB0aGUgbWVudGlvbmVkIGZpbGVzOg0KPiANCj4gaWd0JCAuL3Njcmlw
dHMvZ2VuZXJhdGVfY2xlYXJfa2VybmVsLnNoIC1nIGl2YiBcDQo+ICAgICAgLW0gfi9tZXNhL2J1
aWxkL3NyYy9pbnRlbC90b29scy9pOTY1X2FzbQ0KPiBPdXRwdXQgZmlsZSBub3Qgc3BlY2lmaWVk
IC0gdXNpbmcgZGVmYXVsdCBmaWxlICJpdmItY2JfYXNzZW1ibGVkIg0KPiANCj4gR2VuZXJhdGlu
ZyBnZW43IENCIEtlcm5lbCBhc3NlbWJsZWQgZmlsZSAiaXZiX2NsZWFyX2tlcm5lbC5jIg0KPiBm
b3IgaTkxNSBkcml2ZXIuLi4NCj4gDQo+IGlndCQgZGlmZiB+L2k5MTUvZHJtLXRpcC9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9ndC9pdmJfY2xlYXJfa2VybmVsLmMgXA0KPiAgICAgIGl2Yl9jbGVhcl9r
ZXJuZWwuYw0KPiANCj4gPCAgKiBHZW5lcmF0ZWQgYnk6IElHVCBHcHUgVG9vbHMgb24gRnJpIDIx
IEZlYiAyMDIwIDA1OjI5OjMyIEFNIFVUQw0KPiA+ICAqIEdlbmVyYXRlZCBieTogSUdUIEdwdSBU
b29scyBvbiBNb24gMDggSnVuIDIwMjAgMTA6MDA6NTQgQU0gUERUDQo+IDYxYzYxDQo+IDwgfTsN
Cj4gPiB9Ow0KPiBcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUNCj4gDQo+IGlndCQgLi9zY3Jp
cHRzL2dlbmVyYXRlX2NsZWFyX2tlcm5lbC5zaCAtZyBoc3cgXA0KPiAgICAgIC1tIH4vbWVzYS9i
dWlsZC9zcmMvaW50ZWwvdG9vbHMvaTk2NV9hc20NCj4gT3V0cHV0IGZpbGUgbm90IHNwZWNpZmll
ZCAtIHVzaW5nIGRlZmF1bHQgZmlsZSAiaHN3LWNiX2Fzc2VtYmxlZCINCj4gDQo+IEdlbmVyYXRp
bmcgZ2VuNy41IENCIEtlcm5lbCBhc3NlbWJsZWQgZmlsZSAiaHN3X2NsZWFyX2tlcm5lbC5jIg0K
PiBmb3IgaTkxNSBkcml2ZXIuLi4NCj4gDQo+IGlndCQgZGlmZiB+L2k5MTUvZHJtLXRpcC9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9ndC9oc3dfY2xlYXJfa2VybmVsLmMgXA0KPiAgICAgIGhzd19jbGVh
cl9rZXJuZWwuYw0KPiA1YzUNCj4gPCAgKiBHZW5lcmF0ZWQgYnk6IElHVCBHcHUgVG9vbHMgb24g
RnJpIDIxIEZlYiAyMDIwIDA1OjMwOjEzIEFNIFVUQw0KPiA+ICAqIEdlbmVyYXRlZCBieTogSUdU
IEdwdSBUb29scyBvbiBNb24gMDggSnVuIDIwMjAgMTA6MDE6NDIgQU0gUERUDQo+IDYxYzYxDQo+
IDwgfTsNCj4gPiB9Ow0KPiBcIE5vIG5ld2xpbmUgYXQgZW5kIG9mIGZpbGUNCj4gDQo+IFVzZWQg
SUdUIGFuZCBNZXNhIG1hc3RlciByZXBvc2l0b3JpZXMgZnJvbSBGcmkgSnVuIDUgMjAyMCkNCj4g
SUdUOiA1M2U4Yzg3OGE2ZmIgKCJ0ZXN0cy9rbXNfY2hhbWVsaXVtOiBGb3JjZSByZXByb2JlIGFm
dGVyIHJlcGx1Z2dpbmcNCj4gICAgICB0aGUgY29ubmVjdG9yIikNCj4gTWVzYTogNWQxM2M3NDc3
ZWIxICgicmFkdjogc2V0IGtlZXBfc3RhdGlzdGljX2luZm8gd2l0aA0KPiAgICAgICBSQURWX0RF
QlVHPXNoYWRlcnN0YXRzIikNCj4gTWVzYSBidWlsdCB3aXRoOiBtZXNvbiBidWlsZCAtRCBwbGF0
Zm9ybXM9ZHJtLHgxMSAtRCBkcmktZHJpdmVycz1pOTY1IFwNCj4gICAgICAgICAgICAgICAgICAt
RCBnYWxsaXVtLWRyaXZlcnM9aXJpcyAtRCBwcmVmaXg9L3VzciBcDQo+IAkJIC1EIGxpYmRpcj0v
dXNyL2xpYjY0LyAtRHRvb2xzPWludGVsIFwNCj4gCQkgLURrdWxrYW4tZHJpdmVycz1pbnRlbCAm
JiBuaW5qYSAtQyBidWlsZA0KPiANCj4gdjI6IEhlYWRlciBjbGVhbi11cCBhbmQgaW5jbHVkZSBi
dWlsZCBpbnN0cnVjdGlvbnMgaW4gYSByZWFkbWUgKENocmlzKQ0KPiAgICAgTW9kaWZpZWQgY29t
bWl0IG1lc3NhZ2UgdG8gcmVzcGVjdCBjaGVjay1wYXRjaA0KPiANCj4gUmVmZXJlbmNlOiBodHRw
Oi8vd3d3LmZzZmxhLm9yZy9waXBlcm1haWwvbGludXgtbGlicmUvMjAyMC0NCj4gSnVuZS8wMDMz
NzQuaHRtbA0KPiBSZWZlcmVuY2U6IGh0dHA6Ly93d3cuZnNmbGEub3JnL3BpcGVybWFpbC9saW51
eC1saWJyZS8yMDIwLQ0KPiBKdW5lLzAwMzM3NS5odG1sDQo+IEZpeGVzOiA0N2Y4MjUzZDJiODkg
KCJkcm0vaTkxNS9nZW43OiBDbGVhciBhbGwgRVUvTDMgcmVzaWR1YWwgY29udGV4dHMiKQ0KPiBD
YzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuNysNCj4gQ2M6IEFsZXhhbmRyZSBPbGl2
YSA8bHhvbGl2YUBmc2ZsYS5vcmc+DQo+IENjOiBQcmF0aGFwIEt1bWFyIFZhbHNhbiA8cHJhdGhh
cC5rdW1hci52YWxzYW5AaW50ZWwuY29tPg0KPiBDYzogQWtlZW0gRyBBYm9kdW5yaW4gPGFrZWVt
LmcuYWJvZHVucmluQGludGVsLmNvbT4NCj4gQ2M6IE1pa2EgS3VvcHBhbGEgPG1pa2Eua3VvcHBh
bGFAbGludXguaW50ZWwuY29tPg0KPiBDYzogQ2hyaXMgV2lsc29uIDxjaHJpc0BjaHJpcy13aWxz
b24uY28udWs+DQo+IENjOiBKYW5pIE5pa3VsYSA8amFuaS5uaWt1bGFAaW50ZWwuY29tPg0KPiBD
YzogSm9vbmFzIExhaHRpbmVuIDxqb29uYXMubGFodGluZW5AbGludXguaW50ZWwuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBSb2RyaWdvIFZpdmkgPHJvZHJpZ28udml2aUBpbnRlbC5jb20+DQoNClJl
dmlld2VkLWJ5OiBKb24gQmxvb21maWVsZCA8am9uLmJsb29tZmllbGRAaW50ZWwuY29tPg0K
