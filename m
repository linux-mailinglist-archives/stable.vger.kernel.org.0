Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD2716BB6F
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 09:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgBYIBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 03:01:51 -0500
Received: from skedge04.snt-world.com ([91.208.41.69]:55118 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgBYIBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 03:01:51 -0500
Received: from sntmail14r.snt-is.com (unknown [10.203.32.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 0370867A7DD;
        Tue, 25 Feb 2020 09:01:47 +0100 (CET)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail14r.snt-is.com
 (10.203.32.184) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 25 Feb
 2020 09:01:46 +0100
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1913.005; Tue, 25 Feb 2020 09:01:46 +0100
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: imx-sdma: Fix the event id check to include RX event
 for UART6
Thread-Topic: [PATCH] dma: imx-sdma: Fix the event id check to include RX
 event for UART6
Thread-Index: AQHV6zcHvJnYHLnVJki1UPp7vKjn9agqnVeAgADfHIA=
Date:   Tue, 25 Feb 2020 08:01:46 +0000
Message-ID: <109d4a9e-a862-fd81-9562-0a6d1e8406da@kontron.de>
References: <20200224172236.22478-1-frieder.schrempf@kontron.de>
 <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
In-Reply-To: <CAOMZO5CyYbAZRZrGLJNJXNJiekJXptUTu8tOfVw6y7-n-CXesg@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="utf-8"
Content-ID: <681CD0450FE8924EB5894233DC072D61@snt-world.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 0370867A7DD.A1711
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

SGkgRmFiaW8sDQoNCk9uIDI0LjAyLjIwIDE5OjQzLCBGYWJpbyBFc3RldmFtIHdyb3RlOg0KPiBI
aSBGcmllZGVyLA0KPiANCj4gT24gTW9uLCBGZWIgMjQsIDIwMjAgYXQgMjoyMiBQTSBTY2hyZW1w
ZiBGcmllZGVyDQo+IDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+IHdyb3RlOg0KPj4NCj4+
IEZyb206IEZyaWVkZXIgU2NocmVtcGYgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4+
DQo+PiBPbiBpLk1YNiB0aGUgRE1BIGV2ZW50IGZvciB0aGUgUlggY2hhbm5lbCBvZiBVQVJUNiBp
cyAnMCcuIFRvIGZpeA0KPiANCj4gSSB3b3VsZCBzdWdnZXN0IGJlaW5nIGEgYml0IG1vcmUgc3Bl
Y2lmaWMgdGhhbiBzYXlpbmcgaS5NWDYuDQo+IA0KPiBJIHNlZSBVQVJUNiBpcyBwcmVzZW50IG9u
IGkuTVg2VUwvaS5NWDZTWCwgYnV0IG5vdCBvbiBpLk1YNlEvaS5NWDZETCwNCj4gc28gaXQgd291
bGQgYmUgYmV0dGVyIHRvIHNwZWNpZnkgaXQgaW4gdGhlIGNvbW1pdCBsb2cuDQo+IA0KPiBpbXg2
dWwuZHRzaSBkb2VzIG5vdCBoYXZlIGRtYSBub2RlcyB1bmRlciB1YXJ0Niwgc28gSSBndWVzcyB5
b3UgZml4ZWQNCj4gaXQgZm9yIGlteDZzeC4NCg0KU291bmRzIHJlYXNvbmFibGUuIEkgd2lsbCBj
aGFuZ2UgdGhlIGNvbW1pdCBtZXNzYWdlIHRvIHJlZmVyIHRvIA0KaS5NWDZVTC9VTEwvU1guDQoN
CkFjdHVhbGx5IG9uZSBvZiBvdXIgY3VzdG9tZXJzIGhhcyBhIGR0cyBmb3IgaS5NWDZVTCwgdGhh
dCBlbmFibGVzIHRoZSANCkRNQSBmb3IgVUFSVDYuIFRoZSBETUEgbm90IGJlaW5nIGVuYWJsZWQg
aW4gaW14NnVsLmR0c2kgZG9lc24ndCBtZWFuIG5vIA0Kb25lIGlzIHVzaW5nIGl0LiBBY3R1YWxs
eSBJIGhhdmUgbm8gaWRlYSB3aHkgaXQncyBlbmFibGVkIGJ5IGRlZmF1bHQgZm9yIA0KaS5NWDZT
WCBhbmQgZGlzYWJsZWQgYnkgZGVmYXVsdCBmb3IgaS5NWDZVTC4NCg0KVGhhbmtzLA0KRnJpZWRl
cg0KDQo+IA0KPj4gdGhlIGJyb2tlbiBETUEgc3VwcG9ydCBmb3IgVUFSVDYsIHdlIGNoYW5nZSB0
aGUgY2hlY2sgZm9yIGV2ZW50X2lkMA0KPj4gdG8gaW5jbHVkZSAnMCcgYXMgYSB2YWxpZCBpZC4N
Cj4+DQo+PiBGaXhlczogMWVjMWU4MmYyNTEwICgiZG1hZW5naW5lOiBBZGQgRnJlZXNjYWxlIGku
TVggU0RNQSBzdXBwb3J0IikNCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBGcmllZGVyIFNjaHJlbXBmIDxmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+
DQo+IA0KPiBSZXZpZXdlZC1ieTogRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPg0K
PiA=
