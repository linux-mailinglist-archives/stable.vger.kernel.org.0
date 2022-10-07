Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F68B5F7308
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 05:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJGDIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 23:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJGDIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 23:08:12 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0082D112A83;
        Thu,  6 Oct 2022 20:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665112091; x=1696648091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t0TGTbCRSo1+9eDYc5/sFmyOC1mHTSsFw6KJNuqjFs0=;
  b=gOrzGJt+mfc0H5s+tj6vMBEbnSYGwqiGtCXC1iyjUF4khUhmmVOEmK6i
   UFj8Q0drTqt/Wbv+xj5GlprPt66jZHu8MyW7HRxcD/9S+qmwJEYenxzNd
   sGmw9DIRxywL2icyvPTVrTsmQFDyPBjFtGYR3daDj7bVwtdjqlY0bgJy+
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,164,1661817600"; 
   d="scan'208";a="249322900"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 03:08:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 59A60846E5;
        Fri,  7 Oct 2022 03:07:58 +0000 (UTC)
Received: from EX19D012UWC003.ant.amazon.com (10.13.138.175) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 7 Oct 2022 03:07:57 +0000
Received: from EX19D021UWA002.ant.amazon.com (10.13.139.48) by
 EX19D012UWC003.ant.amazon.com (10.13.138.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Fri, 7 Oct 2022 03:07:57 +0000
Received: from EX19D021UWA002.ant.amazon.com ([fe80::451a:f171:e742:d57d]) by
 EX19D021UWA002.ant.amazon.com ([fe80::451a:f171:e742:d57d%5]) with mapi id
 15.02.1118.012; Fri, 7 Oct 2022 03:07:57 +0000
From:   "Herrenschmidt, Benjamin" <benh@amazon.com>
To:     "Bhatnagar, Rishabh" <risbhat@amazon.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Thread-Topic: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Thread-Index: AQHY2fn/R7SwxdIgikaLo/Tsj+ZW0w==
Date:   Fri, 7 Oct 2022 03:07:56 +0000
Message-ID: <58294d242fc256a48abb31926232565830197f02.camel@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
         <YzmujBxtwUxHexem@kroah.com>
In-Reply-To: <YzmujBxtwUxHexem@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.160.214]
Content-Type: text/plain; charset="utf-8"
Content-ID: <039754907AFB3246A4D68C57570C2BC5@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KHB1dHRpbmcgbXkgQGFtYXpvbi5jb20gaGF0IG9uKQ0KDQpPbiBTdW4sIDIwMjItMTAtMDIgYXQg
MTc6MzAgKzAyMDAsIEdyZWcgS0ggd3JvdGU6DQoNCg0KPiBPbiBUaHUsIFNlcCAyOSwgMjAyMiBh
dCAwOTowNjo0NVBNICswMDAwLCBSaXNoYWJoIEJoYXRuYWdhciB3cm90ZToNCj4gPiBUaGlzIHBh
dGNoIHNlcmllcyBiYWNrcG9ydHMgYSBidW5jaCBvZiBwYXRjaGVzIHJlbGF0ZWQgSVJRIGhhbmRs
aW5nDQo+ID4gd2l0aCByZXNwZWN0IHRvIGZyZWVpbmcgdGhlIGlycSBsaW5lIHdoaWxlIElSUSBp
cyBpbiBmbGlnaHQgYXQgQ1BVDQo+ID4gb3IgYXQgdGhlIGhhcmR3YXJlIGxldmVsLg0KPiA+IFJl
Y2VudGx5IHdlIHNhdyB0aGlzIGlzc3VlIGluIHNlcmlhbCA4MjUwIGRyaXZlciB3aGVyZSB0aGUg
SVJRIHdhcw0KPiA+IGJlaW5nDQo+ID4gZnJlZWQgd2hpbGUgdGhlIGlycSB3YXMgaW4gZmxpZ2h0
IG9yIG5vdCB5ZXQgZGVsaXZlcmVkIHRvIHRoZSBDUFUuDQo+ID4gQXMgYQ0KPiA+IHJlc3VsdCB0
aGUgaXJxY2hpcCB3YXMgZ29pbmcgaW50byBhIHdlZGdlZCBzdGF0ZSBhbmQgSVJRIHdhcyBub3QN
Cj4gPiBnZXR0aW5nDQo+ID4gZGVsaXZlcmVkIHRvIHRoZSBjcHUuIFRoZXNlIHBhdGNoZXMgaGVs
cGVkIGZpeGVkIHRoZSBpc3N1ZSBpbiA0LjE0DQo+ID4ga2VybmVsLg0KPiANCj4gV2h5IGlzIHRo
ZSBzZXJpYWwgZHJpdmVyIGZyZWVpbmcgYW4gaXJxIHdoaWxlIHRoZSBzeXN0ZW0gaXMgcnVubmlu
Zz8NCj4gQWgsIHRoaXMgY291bGQgaGFwcGVuIG9uIGEgdHR5IGhhbmd1cCwgcmlnaHQ/DQoNClJp
Z2h0LiBSaXNoYWJoIGFuc3dlcmVkIHRoYXQgc2VwYXJhdGVseS4NCg0KPiA+IExldCB1cyBrbm93
IGlmIG1vcmUgcGF0Y2hlcyBuZWVkIGJhY2twb3J0aW5nLg0KPiANCj4gV2hhdCBoYXJkd2FyZSBw
bGF0Zm9ybSB3ZXJlIHRoZXNlIHBhdGNoZXMgdGVzdGVkIG9uIHRvIHZlcmlmeSB0aGV5DQo+IHdv
cmsgcHJvcGVybHk/wqAgQW5kIHdoeSBjYW4ndCB0aGV5IG1vdmUgdG8gNC4xOSBvciBuZXdlciBp
ZiB0aGV5DQo+IHJlYWxseSBuZWVkIHRoaXMgZml4P8KgIFdoYXQncyBwcmV2ZW50aW5nIHRoYXQ/
DQo+IA0KPiBBcyBBbWF6b24gZG9lc24ndCBzZWVtIHRvIGJlIHRlc3RpbmcgNC4xNC55IC1yYyBy
ZWxlYXNlcywgSSBmaW5kIGl0DQo+IG9kZCB0aGF0IHlvdSBhbGwgZGlkIHRoaXMgYmFja3BvcnQu
wqAgSXMgdGhpcyBhIGtlcm5lbCB0aGF0IHlvdSBhbGwNCj4gY2FyZSBhYm91dD8NCg0KVGhlc2Ug
d2VyZSB0ZXN0ZWQgb24gYSBjb2xsZWN0aW9uIG9mIEVDMiBpbnN0YW5jZXMsIHZpcnR1YWwgYW5k
IG1ldGFsIEkNCmJlbGlldmUgKFJpc2hhYmgsIHBsZWFzZSBjb25maXJtKS4NCg0KQW1hem9uIExp
bnV4IDIgcnVucyA0LjE0IG9yIDUuMTAuIFVuZm9ydHVuYXRlbHkgd2Ugc3RpbGwgaGF2ZSB0bw0K
c3VwcG9ydCBjdXN0b21lcnMgcnVubmluZyB0aGUgZm9ybWVyLg0KDQpXZSdsbCBiZSBpbmNsdWRp
bmcgdGhlc2UgcGF0Y2hlcyBpbiBvdXIgcmVsZWFzZXMsIHdlIHRob3VnaHQgaXQgd291bGQNCmJl
IG5pY2UgdG8gaGF2ZSB0aGVtIGluIC1zdGFibGUgYXMgd2VsbCBmb3IgdGhlIHNha2Ugb2Ygd2hv
ZXZlciBlbHNlDQptaWdodCBiZSBzdGlsbCB1c2luZyB0aGlzIGtlcm5lbC4gTm8gaHVnZSBkZWFs
IGlmIHRoZXkgZG9uJ3QuDQoNCkFzIGZvciB0ZXN0aW5nIC1yYydzLCB5ZXMsIHdlIG5lZWQgdG8g
Z2V0IGJldHRlciBhdCB0aGF0IChhbmQgcHVibGlzaA0Kd2hhdCB3ZSB0ZXN0KS4gUG9pbnQgdGFr
ZW4gOi0pDQoNCkNoZWVycywNCkJlbi4NCg0K
