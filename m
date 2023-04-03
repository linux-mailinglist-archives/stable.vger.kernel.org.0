Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37406D41CB
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjDCKTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjDCKTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 06:19:14 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0899E12BE2;
        Mon,  3 Apr 2023 03:19:04 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333AIxRv066487;
        Mon, 3 Apr 2023 05:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680517139;
        bh=lz60oJMNNApxne8XKp/602Q9lIfj7nEOb+EHhaiTYjs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=ut/O3TJrZ7cYB2UFtQbBxbcm4N+UKk8glOPyb4oXyWveZeXmoqxUgCuSEQjiNPYpm
         DCATvGnpEYcOwS90pUs4+RPCrYmtPeKUCxGYELON/Oz2vmiNCvU5/MyQq8+lDEIMi9
         H9JTQoKGXHhj7rSM3SOxESkIN8HBTmvBwcHObg9w=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333AIxUh006403
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 05:18:59 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 05:18:58 -0500
Received: from DLEE114.ent.ti.com ([fe80::bdc7:eccc:cd13:af84]) by
 DLEE114.ent.ti.com ([fe80::bdc7:eccc:cd13:af84%17]) with mapi id
 15.01.2507.016; Mon, 3 Apr 2023 05:18:58 -0500
From:   "Purohit, Kaushal" <kaushal.purohit@ti.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: issues with cdc ncm host class driver
Thread-Topic: [EXTERNAL] Re: issues with cdc ncm host class driver
Thread-Index: Adll85tYAc+Cq2MlRoaUYHp7CXh/XQASqSKAAAo4+VA=
Date:   Mon, 3 Apr 2023 10:18:58 +0000
Message-ID: <6a8da52391f349ffbdaf2ab6d81e5cff@ti.com>
References: <da37bb0d43de465185c10aad9924f265@ti.com>
 <28ec4e65-647f-2567-fb7d-f656940d4e43@suse.com>
In-Reply-To: <28ec4e65-647f-2567-fb7d-f656940d4e43@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.249.138.33]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T2xpdmVyLCBUaGFua3MgZm9yIHRoZSBxdWljayBjb25maXJtYXRpb24uIFRyYWNrZWQgaW4ga2Vy
bmVsIEJ1Z3ppbGxhIGJ5ICJCdWcgMjE3MjkwIi4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCkZyb206IE9saXZlciBOZXVrdW0gPG9uZXVrdW1Ac3VzZS5jb20+IA0KU2VudDogTW9uZGF5
LCBBcHJpbCAzLCAyMDIzIDM6MzkgUE0NClRvOiBQdXJvaGl0LCBLYXVzaGFsIDxrYXVzaGFsLnB1
cm9oaXRAdGkuY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KQ2M6IHJlZ3Jlc3Npb25zQGxp
c3RzLmxpbnV4LmRldjsgbGludXgtdXNiQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogW0VYVEVS
TkFMXSBSZTogaXNzdWVzIHdpdGggY2RjIG5jbSBob3N0IGNsYXNzIGRyaXZlcg0KDQpPbiAwMy4w
NC4yMyAwODoxNCwgUHVyb2hpdCwgS2F1c2hhbCB3cm90ZToNCj4gSGksDQo+IA0KDQpIaSwNCg0K
PiBSZWZlcnJpbmcgdG8gcGF0Y2ggd2l0aCBjb21taXQgSUQgKCplMTBkY2IxYjZiYTcxNDI0M2Fk
NWEzNWExMWI5MWNjMTQxMDNhOWE5KikuDQo+IA0KPiBUaGlzIGlzIGEgc3BlYyB2aW9sYXRpb24g
Zm9ywqBDREMgTkNNIGNsYXNzIGRyaXZlci4gRHJpdmVyIGNsZWFybHkgc2F5cyANCj4gdGhlIHNp
Z25pZmljYW5jZSBvZiBuZXR3b3JrIGNhcGFiaWxpdGllcy4gKHNuYXBzaG90IGJlbG93KQ0KPiAN
Cj4gSG93ZXZlciwgd2l0aCB0aGUgbWVudGlvbmVkIHBhdGNoIHRoZXNlIHZhbHVlcyBhcmUgZGlz
cmVzcGVjdGVkIGFuZCBjb21tYW5kcyBzcGVjaWZpYyB0byB0aGVzZSBjYXBhYmlsaXRpZXMgYXJl
IHNlbnQgZnJvbSB0aGUgaG9zdCByZWdhcmRsZXNzIG9mIGRldmljZScgY2FwYWJpbGl0aWVzIHRv
IGhhbmRsZSB0aGVtLg0KDQpSaWdodC4gU28gZm9yIHlvdXIgZGV2aWNlLCB0aGUgY29ycmVjdCBi
ZWhhdmlvciB3b3VsZCBiZSB0byBkbyBub3RoaW5nLCB3b3VsZG4ndCBpdD8gVGhlIHBhY2tldHMg
d291bGQgYmUgZGVsaXZlcmVkIGFuZCB0aGUgaG9zdCBuZWVkcyB0byBmaWx0ZXIgYW5kIGRpc2Nh
cmQgdW5yZXF1ZXN0ZWQgcGFja2V0cy4NCg0KPiBDdXJyZW50bHkgd2UgYXJlIHNldHRpbmcgdGhl
c2UgYml0cyB0byAwIGluZGljYXRpbmcgbm8gY2FwYWJpbGl0aWVzIG9uIG91ciBkZXZpY2UgYW5k
IHN0aWxsIHdlIG9ic2VydmUgdGhhdCBIb3N0IChMaW51eCBrZXJuZWwgaG9zdCBjZGMgZHJpdmVy
KSBoYXMgYmVlbiBzZW5kaW5nIHJlcXVlc3RzIHNwZWNpZmljIHRvIHRoZXNlIGNhcGFiaWxpdGll
cy4NCj4gDQo+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB0aGVyZSBpcyBhIGJldHRlciB3YXkgdG8g
aW5kaWNhdGUgaG9zdCB0aGF0IGRldmljZSBkb2VzIG5vdCBoYXZlIHRoZXNlIGNhcGFiaWxpdGll
cy4NCg0Kbm8geW91IGFyZSBkb2luZyB0aGluZ3MgYXMgdGhleSBhcmUgc3VwcG9zZWQgdG8gYmUg
ZG9uZSBhbmQgdGhlIGhvc3QgaXMgYXQgZmF1bHQuIFRoaXMga2VybmVsIGJ1ZyBuZWVkcyB0byBi
ZSBmaXhlZC4NCg0KCVJlZ2FyZHMNCgkJT2xpdmVyDQoNCg==
