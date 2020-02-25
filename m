Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B4A16BB73
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 09:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgBYID3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 03:03:29 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:55228 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgBYID3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 03:03:29 -0500
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 715CC67A7DD;
        Tue, 25 Feb 2020 09:03:26 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 25 Feb
 2020 09:03:25 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 25 Feb 2020 09:03:25 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Vinod Koul <vkoul@kernel.org>, Fabio Estevam <festevam@gmail.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: imx-sdma: Fix the event id check to include RX event
 for UART6
Thread-Topic: [PATCH] dma: imx-sdma: Fix the event id check to include RX
 event for UART6
Thread-Index: AQHV6zcHvJnYHLnVJki1UPp7vKjn9agqnVeAgADAigCAAB8JgA==
Date:   Tue, 25 Feb 2020 08:03:25 +0000
Message-ID: <3940d827-2886-5507-4a52-d97e572ce0d2@kontron.de>
References: <20200224172236.22478-1-frieder.schrempf@kontron.de>
 <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
 <20200225061220.GK2618@vkoul-mobl>
In-Reply-To: <20200225061220.GK2618@vkoul-mobl>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <76DF38E9541B5747898C65CC4CC71FC9@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 715CC67A7DD.A0FDD
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        festevam@gmail.com, kernel@pengutronix.de,
        linus.ml.walleij@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-imx@nxp.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, shawnguo@kernel.org, stable@vger.kernel.org,
        vkoul@kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjUuMDIuMjAgMDc6MTIsIFZpbm9kIEtvdWwgd3JvdGU6DQo+IE9uIDI0LTAyLTIwLCAxNTo0
MywgRmFiaW8gRXN0ZXZhbSB3cm90ZToNCj4+IEhpIEZyaWVkZXIsDQo+Pg0KPj4gT24gTW9uLCBG
ZWIgMjQsIDIwMjAgYXQgMjoyMiBQTSBTY2hyZW1wZiBGcmllZGVyDQo+PiA8ZnJpZWRlci5zY2hy
ZW1wZkBrb250cm9uLmRlPiB3cm90ZToNCj4+Pg0KPj4+IEZyb206IEZyaWVkZXIgU2NocmVtcGYg
PGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4+Pg0KPj4+IE9uIGkuTVg2IHRoZSBETUEg
ZXZlbnQgZm9yIHRoZSBSWCBjaGFubmVsIG9mIFVBUlQ2IGlzICcwJy4gVG8gZml4DQo+Pg0KPj4g
SSB3b3VsZCBzdWdnZXN0IGJlaW5nIGEgYml0IG1vcmUgc3BlY2lmaWMgdGhhbiBzYXlpbmcgaS5N
WDYuDQo+Pg0KPj4gSSBzZWUgVUFSVDYgaXMgcHJlc2VudCBvbiBpLk1YNlVML2kuTVg2U1gsIGJ1
dCBub3Qgb24gaS5NWDZRL2kuTVg2REwsDQo+PiBzbyBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gc3Bl
Y2lmeSBpdCBpbiB0aGUgY29tbWl0IGxvZy4NCj4+DQo+PiBpbXg2dWwuZHRzaSBkb2VzIG5vdCBo
YXZlIGRtYSBub2RlcyB1bmRlciB1YXJ0Niwgc28gSSBndWVzcyB5b3UgZml4ZWQNCj4+IGl0IGZv
ciBpbXg2c3guDQo+IA0KPiBhbmQgdXNlIHJpZ2h0IHN1YnN5c3RlbSB0YWcgZG1hZW5naW5lLiBH
aXQgbG9nIG9mIHRoZSBmaWxlIHNob3VsZCB0ZWxsDQo+IHlvdSB0aGUgcmlnaHQgb25lIHRvIHVz
ZSA6KQ0KDQpTb3JyeSwgbXkgYmFkLiBJIHdpbGwgZml4IGl0Lg0KDQo+IA0KPj4NCj4+PiB0aGUg
YnJva2VuIERNQSBzdXBwb3J0IGZvciBVQVJUNiwgd2UgY2hhbmdlIHRoZSBjaGVjayBmb3IgZXZl
bnRfaWQwDQo+Pj4gdG8gaW5jbHVkZSAnMCcgYXMgYSB2YWxpZCBpZC4NCj4+Pg0KPj4+IEZpeGVz
OiAxZWMxZTgyZjI1MTAgKCJkbWFlbmdpbmU6IEFkZCBGcmVlc2NhbGUgaS5NWCBTRE1BIHN1cHBv
cnQiKQ0KPj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+Pj4gU2lnbmVkLW9mZi1ieTog
RnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KPj4NCj4+IFJl
dmlld2VkLWJ5OiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+IA==
