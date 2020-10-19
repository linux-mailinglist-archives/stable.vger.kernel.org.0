Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76912292D54
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 20:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgJSSKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 14:10:24 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39033 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgJSSKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 14:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1603131023; x=1634667023;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=u9iVOEYGVwkJxH5kuaRa1Cbf+1PMW+0hv98iKdr9koQ=;
  b=XI2qBtY/6NjKdwt9QxK2JulfTdhIsJ5aTmARfWcQNktSAgXMu3YjAzS5
   o3j6OdO6wCoJvDWoMb/IZ/s4thgRUITxrI0iZXDcRoMhR2/b3Nzich+m7
   Rm2qjO+7Yf3fmsS4adIpSpik599d1EI+NKOIb4sFjQYJzV0pzVMbpj/pD
   o=;
X-IronPort-AV: E=Sophos;i="5.77,395,1596499200"; 
   d="scan'208";a="59994102"
Subject: Re: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Thread-Topic: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Oct 2020 18:10:17 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 189FAB9B08;
        Mon, 19 Oct 2020 18:10:15 +0000 (UTC)
Received: from EX13D11UEB003.ant.amazon.com (10.43.60.110) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 18:10:15 +0000
Received: from EX13D11UEB004.ant.amazon.com (10.43.60.132) by
 EX13D11UEB003.ant.amazon.com (10.43.60.110) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 18:10:14 +0000
Received: from EX13D11UEB004.ant.amazon.com ([10.43.60.132]) by
 EX13D11UEB004.ant.amazon.com ([10.43.60.132]) with mapi id 15.00.1497.006;
 Mon, 19 Oct 2020 18:10:14 +0000
From:   "Protopopov, Boris" <pboris@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     stable <stable@vger.kernel.org>
Thread-Index: AQHWpJoxvkgDfMnA7kSnhOBbCo9a7qmc3VCAgAHbm4CAAHyRgP//xHAA
Date:   Mon, 19 Oct 2020 18:10:14 +0000
Message-ID: <7EF7E73F-E149-4A15-8AE6-4F4A79C2BBE5@amazon.com>
References: <20201017152839.4398-1-pboris@amazon.com>
 <20201018055519.GB599591@kroah.com>
 <B1901644-CAEB-45B7-87F8-A05C70423914@amazon.com>
 <20201019174325.GD3327376@kroah.com>
In-Reply-To: <20201019174325.GD3327376@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.60.242]
Content-Type: text/plain; charset="utf-8"
Content-ID: <561317E571ABA141841B60012D8178B7@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T0sgdGhhbmtzIEkgd2lsbCByZXN1Ym1pdCBsYXRlci4gDQoNCu+7v09uIDEwLzE5LzIwLCAxOjQy
IFBNLCAiR3JlZyBLSCIgPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiB3cm90ZToNCg0KICAg
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2Fu
aXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQoN
Cg0KDQogICAgQTogaHR0cDovL2VuLndpa2lwZWRpYS5vcmcvd2lraS9Ub3BfcG9zdA0KICAgIFE6
IFdlcmUgZG8gSSBmaW5kIGluZm8gYWJvdXQgdGhpcyB0aGluZyBjYWxsZWQgdG9wLXBvc3Rpbmc/
DQogICAgQTogQmVjYXVzZSBpdCBtZXNzZXMgdXAgdGhlIG9yZGVyIGluIHdoaWNoIHBlb3BsZSBu
b3JtYWxseSByZWFkIHRleHQuDQogICAgUTogV2h5IGlzIHRvcC1wb3N0aW5nIHN1Y2ggYSBiYWQg
dGhpbmc/DQogICAgQTogVG9wLXBvc3RpbmcuDQogICAgUTogV2hhdCBpcyB0aGUgbW9zdCBhbm5v
eWluZyB0aGluZyBpbiBlLW1haWw/DQoNCiAgICBBOiBOby4NCiAgICBROiBTaG91bGQgSSBpbmNs
dWRlIHF1b3RhdGlvbnMgYWZ0ZXIgbXkgcmVwbHk/DQoNCiAgICBodHRwOi8vZGFyaW5nZmlyZWJh
bGwubmV0LzIwMDcvMDcvb25fdG9wDQoNCiAgICBPbiBNb24sIE9jdCAxOSwgMjAyMCBhdCAwMjox
NzozNVBNICswMDAwLCBQcm90b3BvcG92LCBCb3JpcyB3cm90ZToNCiAgICA+IEkgY291bGQgbm90
IGZpbmQgdGhlIHBhdGNoIGluIExpbnVzJ3MgdHJlZSBhdCBodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9mcy9jaWZz
L2NpZnNfdW5pY29kZS5jI240OTEgb3IgaW4gdGhlIGNvbW1pdCBsaXN0LiBUaGUgcGF0Y2ggaXMg
aW4gbGludXgtbmV4dCwgY29tbWl0IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L25leHQvbGludXgtbmV4dC5naXQvY29tbWl0Lz9pZD03Njk4YTQ2ZWQ4Njhm
MDNhZmUxODcxZDdjYjYzMDYxZGI2YTYyYjcxDQoNCiAgICBIYXZlIHlvdSByZWFkIHRoZSBydWxl
cyBmb3Igc3RhYmxlIHBhdGNoZXM6DQogICAgICAgIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9j
L2h0bWwvbGF0ZXN0L3Byb2Nlc3Mvc3RhYmxlLWtlcm5lbC1ydWxlcy5odG1sDQoNCiAgICBQbGVh
c2UgZG8gc28sIHlvdSBzZWVtIHRvIGJlIG1pc3NpbmcgdGhlICJNVVNUIEJFIElOIExJTlVTJ1Mg
VFJFRSINCiAgICByZXF1aXJlbWVudC4uLg0KDQogICAgZ3JlZyBrLWgNCg0K
