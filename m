Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9681042
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 04:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfHECZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 22:25:49 -0400
Received: from mx.socionext.com ([202.248.49.38]:10681 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfHECZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 22:25:49 -0400
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 05 Aug 2019 11:25:47 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id 951B560629;
        Mon,  5 Aug 2019 11:25:47 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Mon, 5 Aug 2019 11:25:47 +0900
Received: from SOC-EX01V.e01.socionext.com (10.213.24.21) by
 SOC-EX03V.e01.socionext.com (10.213.24.23) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Mon, 5 Aug 2019 11:25:46 +0900
Received: from SOC-EX01V.e01.socionext.com ([10.213.24.21]) by
 SOC-EX01V.e01.socionext.com ([10.213.24.21]) with mapi id 15.00.0995.028;
 Mon, 5 Aug 2019 11:25:46 +0900
From:   <yamada.masahiro@socionext.com>
To:     <sashal@kernel.org>, <m.v.b@runbox.com>
CC:     <stable@vger.kernel.org>
Subject: RE: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Thread-Topic: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
Thread-Index: AQHVSeKTgbguKTggi0CvgT1Bp7Xeaqbo0kSAgAMDyuA=
Date:   Mon, 5 Aug 2019 02:25:46 +0000
Message-ID: <e47da726a612446fb48f7e044e8a9857@SOC-EX01V.e01.socionext.com>
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

SGkgU2FzaGEsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FzaGEg
TGV2aW4gW21haWx0bzpzYXNoYWxAa2VybmVsLm9yZ10NCj4gU2VudDogU2F0dXJkYXksIEF1Z3Vz
dCAwMywgMjAxOSAxMDoyMiBQTQ0KPiBUbzogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3Jn
PjsgTS4gVmVmYSBCaWNha2NpIDxtLnYuYkBydW5ib3guY29tPjsNCj4gWWFtYWRhLCBNYXNhaGly
by8bJEI7M0VEGyhCIBskQj8/OTAbKEIgPHlhbWFkYS5tYXNhaGlyb0Bzb2Npb25leHQuY29tPg0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBr
Y29uZmlnOiBDbGVhciAid3JpdHRlbiIgZmxhZyB0byBhdm9pZCBkYXRhIGxvc3MNCj4gDQo+IEhp
LA0KPiANCj4gW1RoaXMgaXMgYW4gYXV0b21hdGVkIGVtYWlsXQ0KPiANCj4gVGhpcyBjb21taXQg
aGFzIGJlZW4gcHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMgYSAiRml4ZXM6IiB0YWcsDQo+
IGZpeGluZyBjb21taXQ6IDhlMjQ0MmE1Zjg2ZSBrY29uZmlnOiBmaXggbWlzc2luZyBjaG9pY2Ug
dmFsdWVzIGluDQo+IGF1dG8uY29uZi4NCj4gDQo+IFRoZSBib3QgaGFzIHRlc3RlZCB0aGUgZm9s
bG93aW5nIHRyZWVzOiB2NS4yLjUsIHY0LjE5LjYzLg0KPiANCj4gdjUuMi41OiBCdWlsZCBPSyEN
Cj4gdjQuMTkuNjM6IEZhaWxlZCB0byBhcHBseSEgUG9zc2libGUgZGVwZW5kZW5jaWVzOg0KPiAg
ICAgYWZmMTFjZDk4M2VjICgia2NvbmZpZzogVGVybWluYXRlIG1lbnUgYmxvY2tzIHdpdGggYSBj
b21tZW50IGluIHRoZQ0KPiBnZW5lcmF0ZWQgY29uZmlnIikNCj4gDQo+IA0KPiBOT1RFOiBUaGUg
cGF0Y2ggd2lsbCBub3QgYmUgcXVldWVkIHRvIHN0YWJsZSB0cmVlcyB1bnRpbCBpdCBpcyB1cHN0
cmVhbS4NCj4gDQo+IEhvdyBzaG91bGQgd2UgcHJvY2VlZCB3aXRoIHRoaXMgcGF0Y2g/DQoNCg0K
DQpGb3IgNC4xOS54LCBJIGp1c3Qgc2VudCBhIGNsZWFubHktYXBwbGljYWJsZSBwYXRjaC4NCg0K
VGhhbmtzLg0KDQo=
