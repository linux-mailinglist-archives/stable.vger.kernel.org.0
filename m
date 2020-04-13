Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68281A6242
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 06:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgDMEvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 00:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgDMEvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 00:51:03 -0400
Received: from mo-csw.securemx.jp (mo-csw1515.securemx.jp [210.130.202.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6844C0086B6
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 21:51:03 -0700 (PDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 03D4oucl026617; Mon, 13 Apr 2020 13:50:56 +0900
X-Iguazu-Qid: 34trDAmeI5Be4MZxmk
X-Iguazu-QSIG: v=2; s=0; t=1586753455; q=34trDAmeI5Be4MZxmk; m=9RO8O4t+IIkeQHP1foPPhipksQfwK3JEFjl1o9KWRBw=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 03D4otM0007777;
        Mon, 13 Apr 2020 13:50:55 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 03D4osWD021004;
        Mon, 13 Apr 2020 13:50:55 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 03D4os6M029469;
        Mon, 13 Apr 2020 13:50:54 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqJl8J9dEt+6PcPlcCeMZZrlcFuKRSAo+kC88ZA9f9/MyLcbUF6oEkZswdTba1exMH73SU7ssnM5VFxtLKJZGpz2mbRVg1xpXge7uyAfZNsappxZAMkb/OXGZLtQN6/akQWXt9owqki+UoUgmW5sO/6PtB/FokJ7dzvR2U12ZUXVKnsRLogh6AzSO0cuQMQU7Cf2f3GoY7Q9ZL9Rrvvm/Rc+Smn1LBDqks9+OzJtXSuj+nnHRxtLR78++yrHBmM5su9aLorUiDF8hHLb0GvSM8uBYjAt2MVMwtxjw5EAEZ9y+26sNsQdAHY/+aM4cGsiPxwLUdFLGtJ7MlFJvNLa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmBOUIidT+UNtIBkFBxs/ocFJ/plX0g1TFNbDIY3RVc=;
 b=M1jJL2tor1ZGXURDjFUBW/GBPrOMa+X9jVawdUjuu8JO4BKm6QiDH5V79lV+w5TBZkVuRwQLrN3zKm0ka3o2yFl8SDbuX6Tl68SgmLxsFbsib9H+4MbaURgI7mnEy3WHW3MoWdJZhzq6Sr2B/+mPliRiaxfOGBotvjRBlzxIg7Iwt6vDcUh2VZjLQjZoGKU4e9FNjJ7vVamBxZy8YDEBbxM3t30g4Q6numWgHHlAy11zvCfuQgmk5YBtWo5gFURPuo1xQD4827vb6zc4+5n1ZGU3NMXE3Pr47Q8G5/O71uTg2xNeU91M7De6X63jtKOxfQqarj0CGp/yX97OL7aKDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <greg@kroah.com>
CC:     <stable@vger.kernel.org>
Subject: RE: [PATCH for 4.4.y] x86/vdso: Fix lsl operand order
Thread-Topic: [PATCH for 4.4.y] x86/vdso: Fix lsl operand order
Thread-Index: AQHWDX85MP9dRIM/WEutneW1ksqYiqhyDM+AgAR2LYA=
Date:   Mon, 13 Apr 2020 04:50:50 +0000
X-TSB-HOP: ON
Message-ID: <OSAPR01MB3667DF22B454AF9C14D7512892DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
References: <20200408082430.4132299-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20200410084201.GA1670984@kroah.com>
In-Reply-To: <20200410084201.GA1670984@kroah.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nobuhiro1.iwamatsu@toshiba.co.jp; 
x-originating-ip: [209.137.146.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4472b25-7f0a-4a6b-9f50-08d7df663d59
x-ms-traffictypediagnostic: OSAPR01MB2497:
x-microsoft-antispam-prvs: <OSAPR01MB24979D8707DE0BAEE4F21BD392DD0@OSAPR01MB2497.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3667.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(7696005)(64756008)(478600001)(966005)(53546011)(66946007)(6506007)(66446008)(316002)(86362001)(66476007)(76116006)(9686003)(66556008)(52536014)(71200400001)(81156014)(186003)(55016002)(33656002)(2906002)(26005)(5660300002)(8936002)(8676002)(4326008)(6916009);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: toshiba.co.jp does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJMWyna05zS+JVauSJKXBTrsavVVq4bBMKLbn5GMAYrKusQG99NfFCBN59gppcO8g3qLQeOjPTE2BwaGed8OOwFew6J8ltDJb129ibMGY4+NP7jUxo2f25LGjKRbkEWArF48AdO4jfdh5wU1o09RHZ9uJNzUXDtujp1RVhQPR9OzEwzNTohDI/LPuyPML5J4l1OgOriSfdsMiSD66rEMmvikz0psMtO9KyGBfhGFg8nNtxQm/9+cBDuTW3UAjxPY8JVMKF0jOEqOGT9ztdfGJYV/xL/34Zh96Mihc7El+wcjrvoDSJizITuFKZ1TKoTKK5OtpFf/ccwKOcszCg9XeY+t8joQvAu7mW7M5n+gEcF80OpXWfVuKYhrWhS+DWr3vRC/oqcls4s/FzIkHhchnfjRm2Qhi+ff3iaqUZ2PJlrilAFPVbvLeer9ZNdw3H2sxrbXxDwQOkCmVFzNXstABIYAI1HfiNpYHdJcax08esdTPYmXZBP1GoOpltkAvd/tAt+4hulFI/42KRtHq0fwXA==
x-ms-exchange-antispam-messagedata: iYLtrDa39CgnSnDz3yTav+65KR1+0jzHxCSl26QKU5FU2fQZyYSsMGENbQsycKARaJxZbfNe/sSkH1+GzuK4zFrXe/w3hkKU4z3/n4Q/bqu4C3NK8kQm/6jq4ol/Ur82fVRt/tLZCxHwVOuQldBiYw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4472b25-7f0a-4a6b-9f50-08d7df663d59
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 04:50:50.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0SjQjAUCh8ykfPoQaXphivJe4c+8AvrtNuLJGHeuOr/WOSUHBglxYlkj0536bIE7pmBKFPyRIKvLXPzkZaGBsYfHCM6MA9yQjXPPTmA3DMYrI17CxkqFV2L3QKgAkro
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2497
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLSCBbbWFp
bHRvOmdyZWdAa3JvYWguY29tXQ0KPiBTZW50OiBGcmlkYXksIEFwcmlsIDEwLCAyMDIwIDU6NDIg
UE0NCj4gVG86IGl3YW1hdHN1IG5vYnVoaXJvKOWyqeadviDkv6HmtIsg4pah77yz77y377yj4pev
77yh77yj77y0KSA8bm9idWhpcm8xLml3YW1hdHN1QHRvc2hpYmEuY28uanA+DQo+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggZm9yIDQuNC55XSB4ODYv
dmRzbzogRml4IGxzbCBvcGVyYW5kIG9yZGVyDQo+IA0KPiBPbiBXZWQsIEFwciAwOCwgMjAyMCBh
dCAwNToyNDozMFBNICswOTAwLCBOb2J1aGlybyBJd2FtYXRzdSB3cm90ZToNCj4gPiBGcm9tOiBT
YW11ZWwgTmV2ZXMgPHNuZXZlc0BkZWkudWMucHQ+DQo+ID4NCj4gPiBjb21taXQgZTc4ZTVhOTE0
NTZmY2VjYWEyZWZiYjM3MDY1NzJmZTA0Mzc2NmY0ZCB1cHN0cmVhbS4NCj4gPg0KPiA+IEluIHRo
ZSBfX2dldGNwdSBmdW5jdGlvbiwgbHNsIGlzIHVzaW5nIHRoZSB3cm9uZyB0YXJnZXQgYW5kIGRl
c3RpbmF0aW9uDQo+ID4gcmVnaXN0ZXJzLiBMdWNraWx5LCB0aGUgY29tcGlsZXIgdGVuZHMgdG8g
Y2hvb3NlICVlYXggZm9yIGJvdGggdmFyaWFibGVzLA0KPiA+IHNvIGl0IGhhcyBiZWVuIHdvcmtp
bmcgc28gZmFyLg0KPiA+DQo+ID4gRml4ZXM6IGE1ODJjNTQwYWMxYiAoIng4Ni92ZHNvOiBVc2Ug
UkRQSUQgaW4gcHJlZmVyZW5jZSB0byBMU0wgd2hlbiBhdmFpbGFibGUiKQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFNhbXVlbCBOZXZlcyA8c25ldmVzQGRlaS51Yy5wdD4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gPiBBY2tlZC1ieTogQW5k
eSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5vcmc+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gPiBMaW5rOiBodHRwczovL2xrbWwua2VybmVsLm9yZy9yLzIwMTgwOTAxMjAxNDUy
LjI3ODI4LTEtc25ldmVzQGRlaS51Yy5wdA0KPiA+IFNpZ25lZC1vZmYtYnk6IE5vYnVoaXJvIEl3
YW1hdHN1IChDSVApIDxub2J1aGlybzEuaXdhbWF0c3VAdG9zaGliYS5jby5qcD4NCj4gPiAtLS0N
Cj4gPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdmd0b2QuaCB8IDIgKy0NCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gDQo+IFdoYXQgYWJv
dXQgNC45PyAgSSBjYW4ndCB0YWtlIGEgcGF0Y2ggZm9yIDQuNCB3aXRob3V0IGFsc28gaXQgYmVp
bmcgaW4NCj4gbmV3ZXIga2VybmVscy4NCj4gDQo+IEFOZCBhbHdheXMgY2M6IGFsbCB0aGUgcGVv
cGxlIGludm9sdmVkIGluIGEgcGF0Y2gsIGxldCB0aGVtIGhhdmUgYSBzYXkNCj4gaWYgdGhpcyBp
cyBvayBvciBub3QuDQo+IA0KPiBQbGVhc2UgZml4IHVwIGFuZCByZXNlbmQgZm9yIGJvdGggdHJl
ZXMuDQoNCk9LLCBJIHdpbGwgZml4IHRoaXMgcGF0Y2ggYW5kIHJlc2VuZC4NClRoYW5rcyBmb3Ig
eW91ciBjb21tZW50Lg0KDQpOb2J1aGlybw0K
