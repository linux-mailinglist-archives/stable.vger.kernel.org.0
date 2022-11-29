Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A185763B899
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 04:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiK2DM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 22:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiK2DM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 22:12:26 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 19:12:24 PST
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 596D3326CD
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 19:12:24 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,202,1665417600"; 
   d="scan'208";a="39313112"
Received: from hk-mbx11.mioffice.cn (HELO xiaomi.com) ([10.56.21.121])
  by outboundhk.mxmail.xiaomi.com with ESMTP; 29 Nov 2022 11:11:19 +0800
Received: from yz-mbx03.mioffice.cn (10.237.88.123) by HK-MBX11.mioffice.cn
 (10.56.21.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 11:11:18 +0800
Received: from BJ-MBX04.mioffice.cn (10.237.8.124) by yz-mbx03.mioffice.cn
 (10.237.88.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 11:11:17 +0800
Received: from BJ-MBX04.mioffice.cn ([fe80::44a0:4515:f68b:f8b1]) by
 BJ-MBX04.mioffice.cn ([fe80::44a0:4515:f68b:f8b1%18]) with mapi id
 15.02.0986.036; Tue, 29 Nov 2022 11:11:17 +0800
From:   =?utf-8?B?RGF2aWQgV2FuZyDnjovmoIc=?= <wangbiao3@xiaomi.com>
To:     Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        "Daniel Bristot de Oliveira" <bristot@redhat.com>
CC:     Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtFeHRlcm5hbCBNYWlsXVtQQVRDSC10aXBdIHNj?=
 =?utf-8?B?aGVkOiBGaXggdXNlLWFmdGVyLWZyZWUgYnVnIGluIGR1cF91c2VyX2NwdXNf?=
 =?utf-8?Q?ptr()?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbRXh0ZXJuYWwgTWFpbF1bUEFUQ0gtdGlwXSBzY2hlZDogRml4?=
 =?utf-8?B?IHVzZS1hZnRlci1mcmVlIGJ1ZyBpbiBkdXBfdXNlcl9jcHVzX3B0cigp?=
Thread-Index: AQHZAssNy10XwAaeOEOvH5Jk+DM0Hq5UU+6w//+gmoCAAURCsA==
Date:   Tue, 29 Nov 2022 03:11:17 +0000
Message-ID: <2e85a57310184654bcde18156ddf2e8d@xiaomi.com>
References: <20221128014441.1264867-1-longman@redhat.com>
 <63373bf9adfc4e0abd9480d40afa2c5a@xiaomi.com>
 <f5abd919-c996-6549-8d48-a93a66daaef8@redhat.com>
In-Reply-To: <f5abd919-c996-6549-8d48-a93a66daaef8@redhat.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.8.11]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_SOFTFAIL,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgIFdhaW1hbiwgIFBldGVyeiwNCg0KV2UgdGVzdCBuZXcgcGF0Y2ggYmFzaW5nIG9uIHVzZXIg
cmVxdWVzdGVkIGFmZmluaXR5IHBhdGNoc2V0KHRoZSBsYXRlc3QgdGlwIHRyZWUpLg0KDQpZb3Ug
dXNlIDcgcGF0Y2ggZnJvbSBBQ0sgY29kZSAuIFlvdSBjaGVjayBmb2xsb3dpbmcgIGxpbmsgY2hh
bmdlLg0KaHR0cHM6Ly9hbmRyb2lkLXJldmlldy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVsL2Nv
bW1vbi8rLzIyNjY3MjQNCmh0dHBzOi8vYW5kcm9pZC1yZXZpZXcuZ29vZ2xlc291cmNlLmNvbS9j
L2tlcm5lbC9jb21tb24vKy8yMjY2NzQ0DQpodHRwczovL2FuZHJvaWQtcmV2aWV3Lmdvb2dsZXNv
dXJjZS5jb20vYy9rZXJuZWwvY29tbW9uLysvMjI2Njc0NQ0KaHR0cHM6Ly9hbmRyb2lkLXJldmll
dy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVsL2NvbW1vbi8rLzIyNjY4MDQNCmh0dHBzOi8vYW5k
cm9pZC1yZXZpZXcuZ29vZ2xlc291cmNlLmNvbS9jL2tlcm5lbC9jb21tb24vKy8yMjY2Nzg0DQpo
dHRwczovL2FuZHJvaWQtcmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9rZXJuZWwvY29tbW9uLysv
MjI2NzQ2OA0KaHR0cHM6Ly9hbmRyb2lkLXJldmlldy5nb29nbGVzb3VyY2UuY29tL2Mva2VybmVs
L2NvbW1vbi8rLzIyNjc2NjQNCg0KWW91IGNhbiBjb25maXJtIHRoaXMgd2l0aCBnb29nbGUgdGVh
bSBhbmQgY2hlY2sNCmh0dHBzOi8vcGFydG5lcmlzc3VldHJhY2tlci5jb3JwLmdvb2dsZS5jb20v
dS8wL2lzc3Vlcy8yNTY1NzgzMDIgLg0KDQpIaSAgUGV0ZXJ6ICwNCg0KQ291bGQgeW91IGhlbHAg
bWVyZ2UNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMTEyNTAyMzk0My4xMTE4NjAz
LTEtbG9uZ21hbkByZWRoYXQuY29tLw0KDQpXZSB3YW50IHRvIHByb3ZpZGUgYmV0dGVyIHByb2R1
Y3QgZm9yIHVzZXIuDQpUaGFua3MNCg0KRGF2aWQuDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0N
CuWPkeS7tuS6ujogV2FpbWFuIExvbmcgPGxvbmdtYW5AcmVkaGF0LmNvbT4NCuWPkemAgeaXtumX
tDogMjAyMuW5tDEx5pyIMjjml6UgMjM6NDMNCuaUtuS7tuS6ujogRGF2aWQgV2FuZyDnjovmoIcg
PHdhbmdiaWFvM0B4aWFvbWkuY29tPjsgSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+OyBQ
ZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+OyBKdXJpIExlbGxpIDxqdXJpLmxl
bGxpQHJlZGhhdC5jb20+OyBWaW5jZW50IEd1aXR0b3QgPHZpbmNlbnQuZ3VpdHRvdEBsaW5hcm8u
b3JnPjsgRGlldG1hciBFZ2dlbWFubiA8ZGlldG1hci5lZ2dlbWFubkBhcm0uY29tPjsgU3RldmVu
IFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+OyBCZW4gU2VnYWxsIDxic2VnYWxsQGdvb2ds
ZS5jb20+OyBNZWwgR29ybWFuIDxtZ29ybWFuQHN1c2UuZGU+OyBEYW5pZWwgQnJpc3RvdCBkZSBP
bGl2ZWlyYSA8YnJpc3RvdEByZWRoYXQuY29tPg0K5oqE6YCBOiBQaGlsIEF1bGQgPHBhdWxkQHJl
ZGhhdC5jb20+OyBXZW5qaWUgTGkgPHdlbmppZWxpQHF0aS5xdWFsY29tbS5jb20+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQrkuLvpopg6IFJl
OiDnrZTlpI06IFtFeHRlcm5hbCBNYWlsXVtQQVRDSC10aXBdIHNjaGVkOiBGaXggdXNlLWFmdGVy
LWZyZWUgYnVnIGluIGR1cF91c2VyX2NwdXNfcHRyKCkNCg0KW+WklumDqOmCruS7tl0g5q2k6YKu
5Lu25p2l5rqQ5LqO5bCP57Gz5YWs5Y+45aSW6YOo77yM6K+36LCo5oWO5aSE55CG44CC6Iul5a+5
6YKu5Lu25a6J5YWo5oCn5a2Y55aR77yM6K+35bCG6YKu5Lu26L2s5Y+R57uZbWlzZWNAeGlhb21p
LmNvbei/m+ihjOWPjemmiA0KDQpPbiAxMS8yOC8yMiAwODozNCwgRGF2aWQgV2FuZyDnjovmoIcg
d3JvdGU6DQo+IEhpLCBXYWltYW4NCj4NCj4gV2UgdXNlIDE0MCBkZXZpY2VzIHRvIHRlc3QgdGhp
cyBwYXRjaCA3MiBob3Vycy4gIFRoZSBpc3N1ZSBjYW4gbm90IGJlIHJlcHJvZHVjZWQuICBJZiBu
byB0aGlzIHBhdGNoLCAgdGhlIGlzc3VlIGNhbiBiZSByZXByb2R1Y2VkLg0KPiBDb3VsZCB5b3Ug
aGVscCBtZXJnZSB0aGlzIHBhdGNoIHRvIG1haWxpbmU/DQo+DQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC8yMDIyMTEyNTAyMzk0My4xMTE4NjAzLTEtbG9uZ21hbkByZWRoYXQuY28NCj4g
bS8NCj4NCj4gSWYgdGhpcyBwYXRjaCBpcyBhcHBsaWVkIHRvIHRoZSBtYWludGFpbmVyJ3MgdHJl
ZSwgIHdlIGNhbiByZXF1ZXN0IGdvb2dsZSB0byBoZWxwIGNoZXJyeXBpY2sgdG8gQUNLIHRvIGZp
eCBpc3N1ZS4NCg0KSnVzdCB3YW50IHRvIGNsYXJpZnkgaWYgeW91IGFyZSB0ZXN0aW5nIHRoZSBw
YXRjaCB1c2luZyB0aGUgbGF0ZXN0IHRpcCB0cmVlIG9yIG9uIHRvcCBvZiBhbiBleGlzdGluZyBs
aW51eCB2ZXJzaW9uIHdpdGhvdXQgdGhlIHBlcnNpc3RlbnQgdXNlciByZXF1ZXN0ZWQgYWZmaW5p
dHkgcGF0Y2hzZXQuDQoNClBldGVyWiBpcyB0aGUgc2NoZWR1bGVyIG1haW50YWluZXIgd2hvIGlz
IHJlc3BvbnNpYmxlIGZvciBtZXJnaW5nIHNjaGVkdWxlciByZWxhdGVkIHBhdGNoLiBJdCBpcyB1
cCB0byBoaW0gYXMgdG8gd2hlbiB0aGF0IHdpbGwgaGFwcGVuLg0KDQpDaGVlcnMsDQpMb25nbWFu
DQoNCiMvKioqKioq5pys6YKu5Lu25Y+K5YW26ZmE5Lu25ZCr5pyJ5bCP57Gz5YWs5Y+455qE5L+d
5a+G5L+h5oGv77yM5LuF6ZmQ5LqO5Y+R6YCB57uZ5LiK6Z2i5Zyw5Z2A5Lit5YiX5Ye655qE5Liq
5Lq65oiW576k57uE44CC56aB5q2i5Lu75L2V5YW25LuW5Lq65Lul5Lu75L2V5b2i5byP5L2/55So
77yI5YyF5ous5L2G5LiN6ZmQ5LqO5YWo6YOo5oiW6YOo5YiG5Zyw5rOE6Zyy44CB5aSN5Yi244CB
5oiW5pWj5Y+R77yJ5pys6YKu5Lu25Lit55qE5L+h5oGv44CC5aaC5p6c5oKo6ZSZ5pS25LqG5pys
6YKu5Lu277yM6K+35oKo56uL5Y2z55S16K+d5oiW6YKu5Lu26YCa55+l5Y+R5Lu25Lq65bm25Yig
6Zmk5pys6YKu5Lu277yBIFRoaXMgZS1tYWlsIGFuZCBpdHMgYXR0YWNobWVudHMgY29udGFpbiBj
b25maWRlbnRpYWwgaW5mb3JtYXRpb24gZnJvbSBYSUFPTUksIHdoaWNoIGlzIGludGVuZGVkIG9u
bHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHdob3NlIGFkZHJlc3MgaXMgbGlzdGVkIGFib3Zl
LiBBbnkgdXNlIG9mIHRoZSBpbmZvcm1hdGlvbiBjb250YWluZWQgaGVyZWluIGluIGFueSB3YXkg
KGluY2x1ZGluZywgYnV0IG5vdCBsaW1pdGVkIHRvLCB0b3RhbCBvciBwYXJ0aWFsIGRpc2Nsb3N1
cmUsIHJlcHJvZHVjdGlvbiwgb3IgZGlzc2VtaW5hdGlvbikgYnkgcGVyc29ucyBvdGhlciB0aGFu
IHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykgaXMgcHJvaGliaXRlZC4gSWYgeW91IHJlY2VpdmUg
dGhpcyBlLW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBieSBwaG9uZSBv
ciBlbWFpbCBpbW1lZGlhdGVseSBhbmQgZGVsZXRlIGl0ISoqKioqKi8jDQo=
