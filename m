Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9E161427
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBQOIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:08:04 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:47624 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgBQOID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:08:03 -0500
Received: from sntmail11s.snt-is.com (unknown [10.203.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id E80A467A879;
        Mon, 17 Feb 2020 15:08:00 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail11s.snt-is.com
 (10.203.32.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 17 Feb
 2020 15:08:00 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Mon, 17 Feb 2020 15:08:00 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: [PATCH 0/2] serial: imx: Backport fixes for irq handling to v4.14
Thread-Topic: [PATCH 0/2] serial: imx: Backport fixes for irq handling to
 v4.14
Thread-Index: AQHV5ZuphrtwteBzhkWCeOYI46C5sw==
Date:   Mon, 17 Feb 2020 14:08:00 +0000
Message-ID: <20200217140740.29743-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EB2326F2D33094BA6652B3B5DC2A7BA@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: E80A467A879.AFDD3
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        shawnguo@kernel.org, stable@vger.kernel.org,
        u.kleine-koenig@pengutronix.de
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogRnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KDQpB
IGN1c3RvbWVyIG9mIG91cnMgaGFzIHByb2JsZW1zIHdpdGggUlM0ODUgb24gaS5NWDZVTCB3aXRo
IHRoZSBsYXRlc3QgdjQuMTQNCmtlcm5lbC4gVGhleSBnZXQgYW4gZXhjZXB0aW9uIGxpa2UgYmVs
b3cgZnJvbSB0aW1lIHRvIHRpbWUgKHRoZSB0cmFjZSBpcw0KZnJvbSBhbiBvbGRlciBrZXJuZWws
IGJ1dCB0aGUgcHJvYmxlbSBhbHNvIGV4aXN0cyBpbiB2NC4xNC4xNzApLg0KDQpBcyB0aGUgY3B1
aWRsZSBzdGF0ZSAyIGNhdXNlcyBsYXJnZSBkZWxheXMgZm9yIHRoZSBpbnRlcnJ1cHQgdGhhdCBj
b250cm9scyB0aGUNClJTNDg1IFJUUyBzaWduYWwgKHdoaWNoIGNhbiBsZWFkIHRvIGNvbGxpc2lv
bnMgb24gdGhlIGJ1cyksIGNwdWlkbGUgc3RhdGUgMiB3YXMNCmRpc2FibGVkIG9uIHRoaXMgc3lz
dGVtLiBUaGlzIGFzcGVjdCBtaWdodCBjYXVzZSB0aGUgZXhjZXB0aW9uIGhhcHBlbmluZyBtb3Jl
DQpvZnRlbiBvbiB0aGlzIHN5c3RlbSB0aGFuIG9uIG90aGVyIHN5c3RlbXMgd2l0aCBkZWZhdWx0
IGNwdWlkbGUgc2V0dGluZ3MuDQoNCkxvb2tpbmcgZm9yIHNvbHV0aW9ucyBJIGZvdW5kIFV3ZSdz
IHBhdGNoZXMgdGhhdCB3ZXJlIGFwcGxpZWQgaW4gdjQuMTcgYmVpbmcNCm1lbnRpb25lZCBoZXJl
IFsxXSBhbmQgaGVyZSBbMl0uIEluIFsxXSBVd2Ugbm90ZXMgdGhhdCBiYWNrcG9ydGluZyB0aGVz
ZSBmaXhlcw0KdG8gdjQuMTQgbWlnaHQgbm90IGJlIHRyaXZpYWwsIGJ1dCBJIHRyaWVkIGFuZCBp
biBteSBvcGluaW9uIGZvdW5kIGl0IG5vdCB0byBiZQ0KdG9vIHByb2JsZW1hdGljIGVpdGhlci4N
Cg0KV2l0aCB0aGUgYmFja3BvcnRlZCBwYXRjaGVzIGFwcGxpZWQsIG91ciBjdXN0b21lciByZXBv
cnRzIHRoYXQgdGhlIGV4Y2VwdGlvbnMNCnN0b3BwZWQgb2NjdXJpbmcuIEdpdmVuIHRoaXMgYW5k
IHRoZSBmYWN0IHRoYXQgdGhlIHByb2JsZW0gc2VlbXMgdG8gYmUga25vd24NCmFuZCBxdWl0ZSBj
b21tb24sIGl0IHdvdWxkIGJlIG5pY2UgdG8gZ2V0IHRoaXMgaW50byB0aGUgdjQuMTQgc3RhYmxl
IHRyZWUuIA0KDQpbMV0gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTM0Mjgz
MS8NClsyXSBodHRwczovL2NvbW11bml0eS5ueHAuY29tL3RocmVhZC80ODEwMDANCg0KU3RhY2sg
dHJhY2U6DQoNClVuaGFuZGxlZCBmYXVsdDogZXh0ZXJuYWwgYWJvcnQgb24gbm9uLWxpbmVmZXRj
aCAoMHgxMDA4KSBhdCAweDkwOTI4MDAwDQpwZ2QgPSA4Y2UxYzAwMA0KWzkwOTI4MDAwXSAqcGdk
PThkODA2ODExLCAqcHRlPTAyMWVjNjUzLCAqcHB0ZT0wMjFlYzQ1Mw0KSW50ZXJuYWwgZXJyb3I6
IDogMTAwOCBbIzFdIFBSRUVNUFQgU01QIEFSTQ0KTW9kdWxlcyBsaW5rZWQgaW46IHVzYl9mX2Vj
bSBnX2V0aGVyIHVzYl9mX3JuZGlzIHVfZXRoZXIgbGliY29tcG9zaXRlIHh0X3RjcHVkcCBpcHRh
YmxlX2ZpbHRlciBpcF90YWJsZXMgeF90YWJsZXMgc3BpZGV2DQpDUFU6IDAgUElEOiAyNzcgQ29t
bTogbXRpb3NTeXM1LmVsZiBOb3QgdGFpbnRlZCA0LjE0Ljg5LWV4Y2VldCAjNDAxNQ0KSGFyZHdh
cmUgbmFtZTogRnJlZXNjYWxlIGkuTVg2IFVsdHJhbGl0ZSAoRGV2aWNlIFRyZWUpDQp0YXNrOiA4
ZGE5ZGUwMCB0YXNrLnN0YWNrOiA4Y2Q1MDAwMA0KUEMgaXMgYXQgaW14X3J4aW50KzB4NTgvMHgy
OTgNCkxSIGlzIGF0IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgxOC8weDVjDQpwYyA6IFs8ODA0
NGZhMDg+XSAgICBsciA6IFs8ODA3MTEyMDg+XSAgICBwc3I6IDIwMDcwMTkzDQpzcCA6IDhjZDUx
Y2UwICBpcCA6IDhkNDAwMjM0ICBmcCA6IDhkYTk0MDEwDQpyMTA6IDgwOTU3OTAwICByOSA6IDgw
YzNlN2VkICByOCA6IDAwMDAwMDA0DQpyNyA6IDgwYzAyZDAwICByNiA6IDAwMDAwMDAwICByNSA6
IDhkYWU0OWYwICByNCA6IDAwMDAwMDAxDQpyMyA6IDAwMDBlMzhlICByMiA6IDAwMDIxNTAwICBy
MSA6IDkwOTI4MDAwICByMCA6IDQwMDcwMTkzDQpGbGFnczogbnpDdiAgSVJRcyBvZmYgIEZJUXMg
b24gIE1vZGUgU1ZDXzMyICBJU0EgQVJNICBTZWdtZW50IG5vbmUNCkNvbnRyb2w6IDEwYzUzODdk
ICBUYWJsZTogOGNlMWMwNmEgIERBQzogMDAwMDAwNTENClByb2Nlc3MgbXRpb3NTeXM1LmVsZiAo
cGlkOiAyNzcsIHN0YWNrIGxpbWl0ID0gMHg4Y2Q1MDIxMCkNClN0YWNrOiAoMHg4Y2Q1MWNlMCB0
byAweDhjZDUyMDAwKQ0KWy4uLl0NCls8ODA0NGZhMDg+XSAoaW14X3J4aW50KSBmcm9tIFs8ODA0
NTBjMWM+XSAoaW14X2ludCsweDEyNC8weDIwYykNCls8ODA0NTBjMWM+XSAoaW14X2ludCkgZnJv
bSBbPDgwMTVlYTk0Pl0gKF9faGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg1MC8weDExYykNCls8
ODAxNWVhOTQ+XSAoX19oYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSkgZnJvbSBbPDgwMTVlYjdjPl0g
KGhhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KzB4MWMvMHg1OCkNCls8ODAxNWViN2M+XSAoaGFuZGxl
X2lycV9ldmVudF9wZXJjcHUpIGZyb20gWzw4MDE1ZWJmMD5dIChoYW5kbGVfaXJxX2V2ZW50KzB4
MzgvMHg1YykNCls8ODAxNWViZjA+XSAoaGFuZGxlX2lycV9ldmVudCkgZnJvbSBbPDgwMTYyMWQ0
Pl0gKGhhbmRsZV9mYXN0ZW9pX2lycSsweGI4LzB4MTZjKQ0KWzw4MDE2MjFkND5dIChoYW5kbGVf
ZmFzdGVvaV9pcnEpIGZyb20gWzw4MDE1ZGQ5OD5dIChnZW5lcmljX2hhbmRsZV9pcnErMHgyNC8w
eDM0KQ0KWzw4MDE1ZGQ5OD5dIChnZW5lcmljX2hhbmRsZV9pcnEpIGZyb20gWzw4MDE1ZTJjMD5d
IChfX2hhbmRsZV9kb21haW5faXJxKzB4N2MvMHhlYykNCls8ODAxNWUyYzA+XSAoX19oYW5kbGVf
ZG9tYWluX2lycSkgZnJvbSBbPDgwMTAxNDQ4Pl0gKGdpY19oYW5kbGVfaXJxKzB4NGMvMHg5MCkN
Cls8ODAxMDE0NDg+XSAoZ2ljX2hhbmRsZV9pcnEpIGZyb20gWzw4MDEwYmY0Yz5dIChfX2lycV9z
dmMrMHg2Yy8weGE4KQ0KWy4uLl0NCls8ODAxMGJmNGM+XSAoX19pcnFfc3ZjKSBmcm9tIFs8ODA3
MTE1ODA+XSAoX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MjAvMHg1NCkNCls8ODA3MTE1
ODA+XSAoX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKSBmcm9tIFs8ODA0NGJhZjQ+XSAodWFy
dF93cml0ZSsweDExMC8weDE3OCkNCls8ODA0NGJhZjQ+XSAodWFydF93cml0ZSkgZnJvbSBbPDgw
NDMzOWI4Pl0gKG5fdHR5X3dyaXRlKzB4MzUwLzB4NDQwKQ0KWzw4MDQzMzliOD5dIChuX3R0eV93
cml0ZSkgZnJvbSBbPDgwNDJmYmU4Pl0gKHR0eV93cml0ZSsweDE4MC8weDM1NCkNCls8ODA0MmZi
ZTg+XSAodHR5X3dyaXRlKSBmcm9tIFs8ODAxZjkzYmM+XSAoX192ZnNfd3JpdGUrMHgxYy8weDEy
MCkNCls8ODAxZjkzYmM+XSAoX192ZnNfd3JpdGUpIGZyb20gWzw4MDFmOTYzND5dICh2ZnNfd3Jp
dGUrMHhhNC8weDE2OCkNCls8ODAxZjk2MzQ+XSAodmZzX3dyaXRlKSBmcm9tIFs8ODAxZjk3Zjg+
XSAoU3lTX3dyaXRlKzB4M2MvMHg5MCkNCls8ODAxZjk3Zjg+XSAoU3lTX3dyaXRlKSBmcm9tIFs8
ODAxMDc5MDA+XSAocmV0X2Zhc3Rfc3lzY2FsbCsweDAvMHg1NCkNCkNvZGU6IGU1OWIyMDc0IGU1
OWIxMDA4IGUyODIyMDAxIGU1OGIyMDc0IChlNTkxYTAwMCkNCg0KVXdlIEtsZWluZS1Lw7ZuaWcg
KDIpOg0KICBzZXJpYWw6IGlteDogZW5zdXJlIHRoYXQgUlggaXJxcyBhcmUgb2ZmIGlmIFJYIGlz
IG9mZg0KICBzZXJpYWw6IGlteDogT25seSBoYW5kbGUgaXJxcyB0aGF0IGFyZSBhY3R1YWxseSBl
bmFibGVkDQoNCiBkcml2ZXJzL3R0eS9zZXJpYWwvaW14LmMgfCAxNjkgKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDExNyBpbnNlcnRpb25z
KCspLCA1MiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE3LjENCg==
