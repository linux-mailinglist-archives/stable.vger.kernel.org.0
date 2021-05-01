Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4648B37084E
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhEARz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 13:55:29 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:11558 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhEARz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 13:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619891679; x=1651427679;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=vYzlsLsafZsT2f+P/qHzBl3cDiuePRZPFVQIgCtULm4=;
  b=vYX/VSbxND2avjQzP0pZ+n78bP+ZAsvCA3GhiTlWsQmShUTdtRxbx9hb
   0SPUdU40OFePQ1zByq84hxPvAnH4zsJ/8bzIz4l9vGr44ofZVx7WIJKsu
   HotrkrTxmZTJxaPoyJnVIZnsgS0LxT2cvl1Okvo62c+8gV/pzNkvL0R7B
   4=;
X-IronPort-AV: E=Sophos;i="5.82,266,1613433600"; 
   d="scan'208";a="930594499"
Subject: Re: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Thread-Topic: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 01 May 2021 17:54:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 8901DA014B;
        Sat,  1 May 2021 17:54:38 +0000 (UTC)
Received: from EX13D13UWB003.ant.amazon.com (10.43.161.233) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 17:54:38 +0000
Received: from EX13D13UWB003.ant.amazon.com (10.43.161.233) by
 EX13D13UWB003.ant.amazon.com (10.43.161.233) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 17:54:37 +0000
Received: from EX13D13UWB003.ant.amazon.com ([10.43.161.233]) by
 EX13D13UWB003.ant.amazon.com ([10.43.161.233]) with mapi id 15.00.1497.015;
 Sat, 1 May 2021 17:54:37 +0000
From:   "van der Linden, Frank" <fllinden@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Thread-Index: AQHXPcZG0+zluwfS4Ui0HteGWjdqGKrMzZkAgAFWsoCAAFDpgA==
Date:   Sat, 1 May 2021 17:54:37 +0000
Message-ID: <E91B1B83-B606-4342-B273-B0990EF54B94@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
 <YIwIX2mB/+tR0AuG@kroah.com>
 <275977B4-72C4-4B86-9B94-47054AAA8067@amazon.com>
 <YIzvjSU6xAHsNOkd@kroah.com>
In-Reply-To: <YIzvjSU6xAHsNOkd@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.253]
Content-Type: text/plain; charset="utf-8"
Content-ID: <05324E7490688C4A914A40AC6C73BE93@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T2ssIHRoYXQncyBmaW5lLiBJIGNhbid0IHJlYWxseSBkbyA0LjE5IHJpZ2h0IG5vdywgc29tZW9u
ZSBlbHNlIHdpbGwgaGF2ZSB0byB0YWtlIGNhcmUgb2YgdGhhdCBvbmUuDQoNCkluIHRoZSBtZWFu
dGltZSwgSSdsbCByZS1zZW5kIG15IDQuMTQgc2VyaWVzIHdpdGgganVzdCB0aGUgZmlyc3QgdHdv
IHBhdGNoZXMsIHRoYXQgZml4IGEgNC4xNC1zcGVjaWZpYyBiYWNrcG9ydCBlcnJvci4NCg0KRnJh
bmsNCg0K77u/T24gNC8zMC8yMSwgMTE6MDUgUE0sICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91
bmRhdGlvbi5vcmc+IHdyb3RlOg0KDQogICAgQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVk
IGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCg0KDQoNCiAgICBPbiBGcmksIEFwciAzMCwgMjAyMSBh
dCAwNDozODoyOVBNICswMDAwLCB2YW4gZGVyIExpbmRlbiwgRnJhbmsgd3JvdGU6DQogICAgPiBT
dXJlLiBJIGhhdmUgYSA0LjE0IG9uZSBjb21pbmcgdXAgdG9vLCBidXQgdGhhdCBvbmUgd2FzIGp1
c3QgYSBsaXR0bGUgaGFyZGVyLCBhbmQgaXQgYWxzbyBjb3JyZWN0cyBhIHByZXZpb3VzIGJhY2tw
b3J0IGVycm9yIHRoYXQgd2FzIG1hZGUgKGNvcnJlY3Rpb24gd2FzIGFscmVhZHkgYWNrZWQpLCBh
bmQgcGlja3Mgc29tZSBvdGhlciBjb21taXRzIHRvIGdldCBzZWxmdGVzdHMgY2xlYW4uIFNvIEkn
bGwgcHJvYmFibHkgc2VuZCBpdCB0byBqdXN0IGJwZkAgZmlyc3QuDQogICAgPg0KICAgID4gT3Ro
ZXJzIHdpbGwgaGF2ZSB0byB0YWtlIGNhcmUgb2YgNC4xOSBvciBvbGRlciBrZXJuZWxzLCB0aG91
Z2gsIGp1c3QgZmxhZ2dpbmcgdGhhdCBJIGhhdmUgZG9uZSB0aGUgNC4xNCBiYWNrcG9ydCBmb3Ig
dGhlc2UuDQoNCiAgICBJIGNhbiBub3QgdGFrZSBmaXhlcyBmb3IgNC4xNCB0aGF0IGFyZSBub3Qg
YWxzbyBpbiA0LjE5LCBzb3JyeSwgYXMgd2UNCiAgICBjYW4gbm90IGhhdmUgcGVvcGxlIHVwZ3Jh
ZGluZyB0byBuZXdlciBrZXJuZWxzIGFuZCBoYXZlIHJlZ3Jlc3Npb25zLg0KDQogICAgdGhhbmtz
LA0KDQogICAgZ3JlZyBrLWgNCg0K
