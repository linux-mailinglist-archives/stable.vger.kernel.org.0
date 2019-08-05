Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9881032
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 04:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfHECIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 22:08:50 -0400
Received: from mx.socionext.com ([202.248.49.38]:10465 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfHECIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 22:08:50 -0400
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 05 Aug 2019 11:08:48 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id C3C7160629;
        Mon,  5 Aug 2019 11:08:48 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Mon, 5 Aug 2019 11:08:48 +0900
Received: from SOC-EX01V.e01.socionext.com (10.213.24.21) by
 SOC-EX03V.e01.socionext.com (10.213.24.23) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Mon, 5 Aug 2019 11:08:48 +0900
Received: from SOC-EX01V.e01.socionext.com ([10.213.24.21]) by
 SOC-EX01V.e01.socionext.com ([10.213.24.21]) with mapi id 15.00.0995.028;
 Mon, 5 Aug 2019 11:08:47 +0900
From:   <yamada.masahiro@socionext.com>
To:     <sashal@kernel.org>, <m.v.b@runbox.com>
CC:     <stable@vger.kernel.org>
Subject: RE: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Thread-Topic: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Thread-Index: AQHVSeKTgbguKTggi0CvgT1Bp7Xeaqbo0kSAgAL8nMA=
Date:   Mon, 5 Aug 2019 02:08:47 +0000
Message-ID: <3f2c04dc61d24816b57189256af1dda5@SOC-EX01V.e01.socionext.com>
References: <20190803100212.8227-1-m.v.b@runbox.com>
 <20190803132212.1849D2075C@mail.kernel.org>
In-Reply-To: <20190803132212.1849D2075C@mail.kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.5.2
x-shieldmailcheckerpolicyversion: POLICY190801
x-originating-ip: [10.213.24.1]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FzaGEgTGV2aW4gW21h
aWx0bzpzYXNoYWxAa2VybmVsLm9yZ10NCj4gU2VudDogU2F0dXJkYXksIEF1Z3VzdCAwMywgMjAx
OSAxMDoyMiBQTQ0KPiBUbzogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPjsgTS4gVmVm
YSBCaWNha2NpIDxtLnYuYkBydW5ib3guY29tPjsNCj4gWWFtYWRhLCBNYXNhaGlyby8bJEI7M0VE
GyhCIBskQj8/OTAbKEIgPHlhbWFkYS5tYXNhaGlyb0Bzb2Npb25leHQuY29tPg0KPiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBrY29uZmlnOiBD
bGVhciAid3JpdHRlbiIgZmxhZyB0byBhdm9pZCBkYXRhIGxvc3MNCj4gDQo+IEhpLA0KPiANCj4g
W1RoaXMgaXMgYW4gYXV0b21hdGVkIGVtYWlsXQ0KPiANCj4gVGhpcyBjb21taXQgaGFzIGJlZW4g
cHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMgYSAiRml4ZXM6IiB0YWcsDQo+IGZpeGluZyBj
b21taXQ6IDhlMjQ0MmE1Zjg2ZSBrY29uZmlnOiBmaXggbWlzc2luZyBjaG9pY2UgdmFsdWVzIGlu
DQo+IGF1dG8uY29uZi4NCj4gDQo+IFRoZSBib3QgaGFzIHRlc3RlZCB0aGUgZm9sbG93aW5nIHRy
ZWVzOiB2NS4yLjUsIHY0LjE5LjYzLg0KPiANCj4gdjUuMi41OiBCdWlsZCBPSyENCj4gdjQuMTku
NjM6IEZhaWxlZCB0byBhcHBseSEgUG9zc2libGUgZGVwZW5kZW5jaWVzOg0KPiAgICAgYWZmMTFj
ZDk4M2VjICgia2NvbmZpZzogVGVybWluYXRlIG1lbnUgYmxvY2tzIHdpdGggYSBjb21tZW50IGlu
IHRoZQ0KPiBnZW5lcmF0ZWQgY29uZmlnIikNCj4gDQo+IA0KPiBOT1RFOiBUaGUgcGF0Y2ggd2ls
bCBub3QgYmUgcXVldWVkIHRvIHN0YWJsZSB0cmVlcyB1bnRpbCBpdCBpcyB1cHN0cmVhbS4NCj4g
DQo+IEhvdyBzaG91bGQgd2UgcHJvY2VlZCB3aXRoIHRoaXMgcGF0Y2g/DQoNCg0KSXQgaGFzIGxh
bmRlZCBpbiBMaW51cycgdHJlZSBub3cuDQoNCkNvbW1pdCAwYzViNmMyOGVkNjhiZWNiNjkyYjQz
ZWFlNWU0NGQ1YWE3ZTE2MGMgdXBzdHJlYW0NCg0KDQpJIHdpbGwgcmVzb2x2ZSB0aGUgY29uZmxp
Y3QgZm9yIDQuMTkueCBsYXRlci4NCg0KVGhhbmtzLg0KDQo=
