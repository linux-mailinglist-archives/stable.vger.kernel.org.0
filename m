Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3D697A26
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 11:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbjBOKqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 05:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbjBOKqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 05:46:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADD537726
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 02:46:21 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-34-i_adRa_mOdaDGX2RAwwiCA-1; Wed, 15 Feb 2023 10:46:18 +0000
X-MC-Unique: i_adRa_mOdaDGX2RAwwiCA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Wed, 15 Feb
 2023 10:46:16 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Wed, 15 Feb 2023 10:46:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Damien Le Moal' <damien.lemoal@opensource.wdc.com>,
        Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        "alberto.dassatti@heig-vd.ch" <alberto.dassatti@heig-vd.ch>
CC:     "xxm@rock-chips.com" <xxm@rock-chips.com>,
        "rick.wertenbroek@heig-vd.ch" <rick.wertenbroek@heig-vd.ch>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?utf-8?B?S3J6eXN6dG9mIFdpbGN6ecWEc2tp?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 8/9] PCI: rockchip: Use u32 variable to access 32-bit
 registers
Thread-Topic: [PATCH v2 8/9] PCI: rockchip: Use u32 variable to access 32-bit
 registers
Thread-Index: AQHZQN2t4tTaT5pAPkCiUYx37/Wq/67P0uRw
Date:   Wed, 15 Feb 2023 10:46:16 +0000
Message-ID: <2a80c4e1f1ad42c6849521d1e644b003@AcuMS.aculab.com>
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-9-rick.wertenbroek@gmail.com>
 <0fa5cef4-7096-7f59-422a-98011d01437c@opensource.wdc.com>
In-Reply-To: <0fa5cef4-7096-7f59-422a-98011d01437c@opensource.wdc.com>
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

RnJvbTogRGFtaWVuIExlIE1vYWwNCj4gU2VudDogMTUgRmVicnVhcnkgMjAyMyAwMTozNA0KPiAN
Cj4gT24gMi8xNC8yMyAyMzowOCwgUmljayBXZXJ0ZW5icm9layB3cm90ZToNCj4gPiBQcmV2aW91
c2x5IHUxNiB2YXJpYWJsZXMgd2VyZSB1c2VkIHRvIGFjY2VzcyAzMi1iaXQgcmVnaXN0ZXJzLCB0
aGlzDQo+ID4gcmVzdWx0ZWQgaW4gbm90IGFsbCBvZiB0aGUgZGF0YSBiZWluZyByZWFkIGZyb20g
dGhlIHJlZ2lzdGVycy4gQWxzbw0KPiA+IHRoZSBsZWZ0IHNoaWZ0IG9mIG1vcmUgdGhhbiAxNi1i
aXRzIHdvdWxkIHJlc3VsdCBpbiBtb3ZpbmcgZGF0YSBvdXQNCj4gPiBvZiB0aGUgdmFyaWFibGUu
IFVzZSB1MzIgdmFyaWFibGVzIHRvIGFjY2VzcyAzMi1iaXQgcmVnaXN0ZXJzDQo+ID4NCj4gPiBG
aXhlczogY2Y1OTBiMDc4MzkxICgiUENJOiByb2NrY2hpcDogQWRkIEVQIGRyaXZlciBmb3IgUm9j
a2NoaXAgUENJZSBjb250cm9sbGVyIikNCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
PiA+IFNpZ25lZC1vZmYtYnk6IFJpY2sgV2VydGVuYnJvZWsgPHJpY2sud2VydGVuYnJvZWtAZ21h
aWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3BjaS9jb250cm9sbGVyL3BjaWUtcm9ja2No
aXAtZXAuYyB8IDEwICsrKysrLS0tLS0NCj4gPiAgZHJpdmVycy9wY2kvY29udHJvbGxlci9wY2ll
LXJvY2tjaGlwLmggICAgfCAgMSArDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2Nv
bnRyb2xsZXIvcGNpZS1yb2NrY2hpcC1lcC5jIGIvZHJpdmVycy9wY2kvY29udHJvbGxlci9wY2ll
LXJvY2tjaGlwLWVwLmMNCj4gPiBpbmRleCBjYTViMzYzYmEuLmI3ODY1YTk0ZSAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL3BjaS9jb250cm9sbGVyL3BjaWUtcm9ja2NoaXAtZXAuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNpZS1yb2NrY2hpcC1lcC5jDQo+ID4gQEAgLTI5
MiwxNSArMjkyLDE1IEBAIHN0YXRpYyBpbnQgcm9ja2NoaXBfcGNpZV9lcF9zZXRfbXNpKHN0cnVj
dCBwY2lfZXBjICplcGMsIHU4IGZuLCB1OCB2Zm4sDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCByb2Nr
Y2hpcF9wY2llX2VwICplcCA9IGVwY19nZXRfZHJ2ZGF0YShlcGMpOw0KPiA+ICAJc3RydWN0IHJv
Y2tjaGlwX3BjaWUgKnJvY2tjaGlwID0gJmVwLT5yb2NrY2hpcDsNCj4gPiAtCXUxNiBmbGFnczsN
Cj4gPiArCXUzMiBmbGFnczsNCj4gPg0KPiA+ICAJZmxhZ3MgPSByb2NrY2hpcF9wY2llX3JlYWQo
cm9ja2NoaXAsDQo+ID4gIAkJCQkgICBST0NLQ0hJUF9QQ0lFX0VQX0ZVTkNfQkFTRShmbikgKw0K
PiA+ICAJCQkJICAgUk9DS0NISVBfUENJRV9FUF9NU0lfQ1RSTF9SRUcpOw0KPiA+ICAJZmxhZ3Mg
Jj0gflJPQ0tDSElQX1BDSUVfRVBfTVNJX0NUUkxfTU1DX01BU0s7DQo+ID4gIAlmbGFncyB8PQ0K
PiA+IC0JICAgKChtdWx0aV9tc2dfY2FwIDw8IDEpIDw8ICBST0NLQ0hJUF9QQ0lFX0VQX01TSV9D
VFJMX01NQ19PRkZTRVQpIHwNCj4gPiAtCSAgIFBDSV9NU0lfRkxBR1NfNjRCSVQ7DQo+ID4gKwkg
ICAobXVsdGlfbXNnX2NhcCA8PCBST0NLQ0hJUF9QQ0lFX0VQX01TSV9DVFJMX01NQ19PRkZTRVQp
IHwNCj4gDQo+IFJPQ0tDSElQX1BDSUVfRVBfTVNJX0NUUkxfTU1DX09GRlNFVCBpcyAxNyBhbmQg
bXVsdGlfbXNnX2NhcCBpcyBhIHU4Li4uDQo+IE5vdCBuaWNlLg0KDQpJdCByZWFsbHkgZG9lc24n
dCBtYXR0ZXIuDQpBcyBzb29uIGFzIHlvdSBkbyBhbnkgYXJpdGhtZXRpYyBjaGFyIGFuZCBzaG9y
dCBhcmUgcHJvbW90ZWQgdG8gaW50Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

