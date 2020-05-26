Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89B1E199F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 04:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgEZCnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 22:43:10 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:63446 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388428AbgEZCnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 22:43:10 -0400
X-UUID: 4a9a0bf8295c41558350d89cd6b0d0ec-20200526
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=diGs7P/c4KSIhXYc7oj93Qp0T+jxxg9AoG2TnBsAgcc=;
        b=jrwl5nQmSk9CjJiebW6NI+m7HX6Z/CkhYX75eqncInbLj+uu3ULF4PgQZrT4HmiPsohy2VUtzv0CoJ3sKRQEUU1d+4+OHss1CqFoIJKAlpjmWFAaojTFtUauOmKUwonHxraNNYw91ubXBD8QrMQhbQkZNovafXBsqlHGCPY2vv8=;
X-UUID: 4a9a0bf8295c41558350d89cd6b0d0ec-20200526
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <weiyi.lu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1215273139; Tue, 26 May 2020 10:43:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 26 May 2020 10:42:57 +0800
Received: from [172.21.77.4] (172.21.77.4) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 May 2020 10:43:03 +0800
Message-ID: <1590460982.28324.17.camel@mtksdaap41>
Subject: Re: [PATCH v1] clk: mediatek: assign the initial value to
 clk_init_data of mtk_mux
From:   Weiyi Lu <weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        <srv_heupstream@mediatek.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Fan Chen <fan.chen@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Owen Chen <owen.chen@mediatek.com>,
        <linux-clk@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 26 May 2020 10:43:02 +0800
In-Reply-To: <1abb3571-75ad-10d8-ff62-17be270b5b71@gmail.com>
References: <1590388889-28382-1-git-send-email-weiyi.lu@mediatek.com>
         <1abb3571-75ad-10d8-ff62-17be270b5b71@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: DDDB6C0F3A8AA9AC19A3F7982F4108E532DADCCD36F602FF9C91EF042C7AAF1B2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTA1LTI1IGF0IDExOjA4ICswMjAwLCBNYXR0aGlhcyBCcnVnZ2VyIHdyb3Rl
Og0KPiANCj4gT24gMjUvMDUvMjAyMCAwODo0MSwgV2VpeWkgTHUgd3JvdGU6DQo+ID4gSXQnZCBi
ZSBkYW5nZXJvdXMgd2hlbiBzdHJ1Y3QgY2xrX2NvcmUgaGF2ZSBuZXcgbWVtZWJlcnMuDQo+ID4g
QWRkIHRoZSBtaXNzaW5nIGluaXRpYWwgdmFsdWUgdG8gY2xrX2luaXRfZGF0YS4NCj4gPiANCj4g
DQo+IFNvcnJ5IEkgZG9uJ3QgcmVhbGx5IHVuZGVyc3RhbmQgdGhpcyBjb21taXQgbWVzc2FnZSwg
Y2FuIHBsZWFzZSBleHBsYWluLg0KPiBJbiBhbnkgY2FzZSBpZiB0aGlzIGlzIGEgcHJvYmxlbSwg
dGhlbiB3ZSBwcm9iYWJseSB3ZSBzaG91bGQgZml4IGl0IGZvciBhbGwgZHJpdmVycy4NCj4gQXBh
cnQgZnJvbSBkcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstY3B1bXV4LmMNCj4gDQoNCkFjdHVhbGx5
LCB3ZSB3ZXJlIGxvb2tpbmcgaW50byBhbiBhbmRyb2lkIGtlcm5lbCBwYXRjaCAiQU5EUk9JRDog
R0tJOg0KY2xrOiBBZGQgc3VwcG9ydCBmb3Igdm9sdGFnZSB2b3RpbmciIFsxXQ0KDQpJbiB0aGlz
IHBhdGNoLCB0aGVyZSBhZGRzIGEgbmV3IG1lbWJlciBzdHJ1Y3QgY2xrX3ZkZF9jbGFzcwkqdmRk
X2NsYXNzOw0KaW4gc3RydWN0IGNsa19pbml0X2RhdGEgYW5kIHN0cnVjdCBjbGtfY29yZQ0KDQpB
bmQgdGhlbiBpbiBjbGtfcmVnaXN0ZXIoLi4uKQ0KY29yZS0+dmRkX2NsYXNzID0gaHctPmluaXQt
PnZkZF9jbGFzczsNCg0KSW4gbWFueSBjbG9jayBBUElzLCBpdCB3aWxsIGNoZWNrIHRoZSBjb3Jl
LT52ZGRfY2xhc3MgdG8gc2VsZWN0IHRoZQ0KY29ycmVjdCBjb250cm9sIGZsb3cuDQpTbywgaWYg
d2UgZG9uJ3QgYXNzaWduIGFuIGluaXRpYWwgdmFsdWUgdG8gY2xrX2luaXRfZGF0YSBvZiBtdGtf
bXV4DQpjbG9jayB0eXBlLCBzb21ldGhpbmcgbWlnaHQgZ28gd3JvbmcuIEFuZCBhc3NpZ25pbmcg
YW4gaW5pdGlhbCB2YWx1ZQ0KbWlnaHQgYmUgdGhlIGVhc2llc3QgYW5kIGdvb2Qgd2F5IHRvIGF2
b2lkIHN1Y2ggcHJvYmxlbSBpZiBhbnkgbmV3IGNsb2NrDQpzdXBwb3J0IGFkZGVkIGluIHRoZSBm
dXR1cmUuDQoNClsxXSBodHRwczovL2FuZHJvaWQtcmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9r
ZXJuZWwvY29tbW9uLysvMTI3ODA0Ng0KDQo+IEl0J3MgYSB3aWRlbHkgdXNlZCBwYXR0ZXJuOg0K
PiAkIGdpdCBncmVwICJzdHJ1Y3QgY2xrX2luaXRfZGF0YSBpbml0OyJ8IHdjIC1sDQo+IDIzNQ0K
PiANCj4gUmVnYXJkcywNCj4gTWF0dGhpYXMNCj4gDQo+ID4gRml4ZXM6IGEzYWU1NDk5MTdmMSAo
ImNsazogbWVkaWF0ZWs6IEFkZCBuZXcgY2xrbXV4IHJlZ2lzdGVyIEFQSSIpDQo+ID4gQ2M6IDxz
dGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFdlaXlpIEx1IDx3ZWl5
aS5sdUBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvY2xrL21lZGlhdGVrL2Ns
ay1tdXguYyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Ns
ay1tdXguYyBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdXguYw0KPiA+IGluZGV4IDc2Zjlj
ZDAuLjE0ZTEyN2UgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW11
eC5jDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW11eC5jDQo+ID4gQEAgLTE2
MCw3ICsxNjAsNyBAQCBzdHJ1Y3QgY2xrICptdGtfY2xrX3JlZ2lzdGVyX211eChjb25zdCBzdHJ1
Y3QgbXRrX211eCAqbXV4LA0KPiA+ICAJCQkJIHNwaW5sb2NrX3QgKmxvY2spDQo+ID4gIHsNCj4g
PiAgCXN0cnVjdCBtdGtfY2xrX211eCAqY2xrX211eDsNCj4gPiAtCXN0cnVjdCBjbGtfaW5pdF9k
YXRhIGluaXQ7DQo+ID4gKwlzdHJ1Y3QgY2xrX2luaXRfZGF0YSBpbml0ID0ge307DQo+ID4gIAlz
dHJ1Y3QgY2xrICpjbGs7DQo+ID4gIA0KPiA+ICAJY2xrX211eCA9IGt6YWxsb2Moc2l6ZW9mKCpj
bGtfbXV4KSwgR0ZQX0tFUk5FTCk7DQo+ID4gDQoNCg==

