Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9814144256
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 17:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAUQjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 11:39:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:38958 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgAUQjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 11:39:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 08:39:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,346,1574150400"; 
   d="scan'208";a="220011714"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga008.jf.intel.com with ESMTP; 21 Jan 2020 08:39:38 -0800
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jan 2020 08:39:38 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.29]) by
 FMSMSX113.amr.corp.intel.com ([169.254.13.183]) with mapi id 14.03.0439.000;
 Tue, 21 Jan 2020 08:39:37 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Gal Pressman <galpress@amazon.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Alexander Matushevsky" <matua@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
Subject: RE: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
 memory blocks aligned to device supported page size"
Thread-Topic: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
 memory blocks aligned to device supported page size"
Thread-Index: AQHVz5toT/HPCKVY4k6ca7L8Mx85A6f1W0WA///1nqA=
Date:   Tue, 21 Jan 2020 16:39:37 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C1E2A8D0@fmsmsx124.amr.corp.intel.com>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
In-Reply-To: <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTEwODk1YzItNDZiZi00ZTVkLWIwNWYtZTFjNzRhYTViNDc1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUlk4VEFxZ0xPMDBJS1RXcEwralVxUTR3QzdMclNsNFRSR1ltUGFlZkxjS0M4Vmx0NEoxWitydXNIbnk4QUY3aSJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIGZvci1yY10gUmV2ZXJ0ICJSRE1BL2VmYTogVXNlIEFQSSB0
byBnZXQgY29udGlndW91cw0KPiBtZW1vcnkgYmxvY2tzIGFsaWduZWQgdG8gZGV2aWNlIHN1cHBv
cnRlZCBwYWdlIHNpemUiDQo+IA0KPiBPbiAyMC8wMS8yMDIwIDE2OjEwLCBHYWwgUHJlc3NtYW4g
d3JvdGU6DQo+ID4gVGhlIGNpdGVkIGNvbW1pdCBsZWFkcyB0byByZWdpc3RlciBNUiBmYWlsdXJl
cyBhbmQgcmFuZG9tIGhhbmdzIHdoZW4NCj4gPiBydW5uaW5nIGRpZmZlcmVudCBNUEkgYXBwbGlj
YXRpb25zLiBUaGUgZXhhY3Qgcm9vdCBjYXVzZSBmb3IgdGhlIGlzc3VlDQo+ID4gaXMgc3RpbGwg
bm90IGNsZWFyLCB0aGlzIHJldmVydCBicmluZ3MgdXMgYmFjayB0byBhIHN0YWJsZSBzdGF0ZS4N
Cj4gPg0KPiA+IFRoaXMgcmV2ZXJ0cyBjb21taXQgNDBkZGIzZjAyMDgzNGY5YWZiN2FhYjMxMzg1
OTk0ODExZjRkYjI1OS4NCj4gPg0KPiA+IEZpeGVzOiA0MGRkYjNmMDIwODMgKCJSRE1BL2VmYTog
VXNlIEFQSSB0byBnZXQgY29udGlndW91cyBtZW1vcnkNCj4gPiBibG9ja3MgYWxpZ25lZCB0byBk
ZXZpY2Ugc3VwcG9ydGVkIHBhZ2Ugc2l6ZSIpDQo+ID4gQ2M6IFNoaXJheiBTYWxlZW0gPHNoaXJh
ei5zYWxlZW1AaW50ZWwuY29tPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4z
DQo+ID4gU2lnbmVkLW9mZi1ieTogR2FsIFByZXNzbWFuIDxnYWxwcmVzc0BhbWF6b24uY29tPg0K
PiANCj4gU2hpcmF6LCBJIHRoaW5rIEkgZm91bmQgdGhlIHJvb3QgY2F1c2UgaGVyZS4NCj4gSSdt
IG5vdGljaW5nIGEgcmVnaXN0ZXIgTVIgb2Ygc2l6ZSAzMmssIHdoaWNoIGlzIGNvbnN0cnVjdGVk
IGZyb20gdHdvIHNnZXMsIHRoZSBmaXJzdA0KPiBzZ2Ugb2Ygc2l6ZSAxMmsgYW5kIHRoZSBzZWNv
bmQgb2YgMjBrLg0KPiANCj4gaWJfdW1lbV9maW5kX2Jlc3RfcGdzeiByZXR1cm5zIHBhZ2Ugc2hp
ZnQgMTMgaW4gdGhlIGZvbGxvd2luZyB3YXk6DQo+IA0KPiAweDEwM2RjYjIwMDAgICAgICAweDEw
M2RjYjUwMDAgICAgICAgMHgxMDNkZDVkMDAwICAgICAgICAgICAweDEwM2RkNjIwMDANCj4gICAg
ICAgICAgICstLS0tLS0tLS0tKyAgICAgICAgICAgICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0t
LS0tKw0KPiAgICAgICAgICAgfCAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgIHwgICAg
ICAgICAgICAgICAgICB8DQo+ICAgICAgICAgICB8ICAxMmsgICAgIHwgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgMjBrICAgICAgICAgIHwNCj4gICAgICAgICAgICstLS0tLS0tLS0tKyAgICAg
ICAgICAgICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiANCj4gICAgICAgICAgICst
LS0tLS0rLS0tLS0tKyAgICAgICAgICAgICAgICAgKy0tLS0tLSstLS0tLS0rLS0tLS0tKw0KPiAg
ICAgICAgICAgfCAgICAgIHwgICAgICB8ICAgICAgICAgICAgICAgICB8ICAgICAgfCAgICAgIHwg
ICAgICB8DQo+ICAgICAgICAgICB8IDhrICAgfCA4ayAgIHwgICAgICAgICAgICAgICAgIHwgOGsg
ICB8IDhrICAgfCA4ayAgIHwNCj4gICAgICAgICAgICstLS0tLS0rLS0tLS0tKyAgICAgICAgICAg
ICAgICAgKy0tLS0tLSstLS0tLS0rLS0tLS0tKw0KPiAweDEwM2RjYjIwMDAgICAgICAgMHgxMDNk
Y2I2MDAwICAgMHgxMDNkZDVjMDAwICAgICAgICAgICAgICAweDEwM2RkNjIwMDANCj4gDQo+IA0K
DQpHYWwgLSB3b3VsZCBiZSB1c2VmdWwgdG8ga25vdyB0aGUgSU9WQSAodmlydCkgYW5kIHVtZW0t
PmFkZHIgYWxzbyBmb3IgdGhpcyBNUiBpbiBpYl91bWVtX2ZpbmRfYmVzdF9wZ3N6DQoNCg==
