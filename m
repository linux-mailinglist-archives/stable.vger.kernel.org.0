Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7E36FEBF
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhD3QjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 12:39:20 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:26776 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhD3QjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 12:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619800711; x=1651336711;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=dyHTRrmMKeQMW5NnwS4hH6SwPusdNgVTJayFnKa1DvM=;
  b=Rxy/w0piMbT3eMkTLV1M28Dk+erRKAFHhY9EJh8Oq1A957xBr/sBkEb6
   8UyhEF/Z3IrLAYYt0bpBrOxZQmqJ1mkC1da2xI6iwo0wdmgBM8NYnOKqD
   9o4OHiqCZdcbt3G5Oht8N9IqLNvm8a/Cgcr4zDJiZNXdVgfG3NKO1I7fB
   8=;
X-IronPort-AV: E=Sophos;i="5.82,263,1613433600"; 
   d="scan'208";a="930430958"
Subject: Re: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Thread-Topic: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 30 Apr 2021 16:38:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 35CDBA1CA4;
        Fri, 30 Apr 2021 16:38:29 +0000 (UTC)
Received: from EX13D13UWB004.ant.amazon.com (10.43.161.218) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 30 Apr 2021 16:38:29 +0000
Received: from EX13D13UWB003.ant.amazon.com (10.43.161.233) by
 EX13D13UWB004.ant.amazon.com (10.43.161.218) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 30 Apr 2021 16:38:29 +0000
Received: from EX13D13UWB003.ant.amazon.com ([10.43.161.233]) by
 EX13D13UWB003.ant.amazon.com ([10.43.161.233]) with mapi id 15.00.1497.015;
 Fri, 30 Apr 2021 16:38:29 +0000
From:   "van der Linden, Frank" <fllinden@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Thread-Index: AQHXPcZG0+zluwfS4Ui0HteGWjdqGKrMzZkA
Date:   Fri, 30 Apr 2021 16:38:29 +0000
Message-ID: <275977B4-72C4-4B86-9B94-47054AAA8067@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
 <YIwIX2mB/+tR0AuG@kroah.com>
In-Reply-To: <YIwIX2mB/+tR0AuG@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.17]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A829820E73BC564CB00676E50A999E4C@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

U3VyZS4gSSBoYXZlIGEgNC4xNCBvbmUgY29taW5nIHVwIHRvbywgYnV0IHRoYXQgb25lIHdhcyBq
dXN0IGEgbGl0dGxlIGhhcmRlciwgYW5kIGl0IGFsc28gY29ycmVjdHMgYSBwcmV2aW91cyBiYWNr
cG9ydCBlcnJvciB0aGF0IHdhcyBtYWRlIChjb3JyZWN0aW9uIHdhcyBhbHJlYWR5IGFja2VkKSwg
YW5kIHBpY2tzIHNvbWUgb3RoZXIgY29tbWl0cyB0byBnZXQgc2VsZnRlc3RzIGNsZWFuLiBTbyBJ
J2xsIHByb2JhYmx5IHNlbmQgaXQgdG8ganVzdCBicGZAIGZpcnN0Lg0KDQpPdGhlcnMgd2lsbCBo
YXZlIHRvIHRha2UgY2FyZSBvZiA0LjE5IG9yIG9sZGVyIGtlcm5lbHMsIHRob3VnaCwganVzdCBm
bGFnZ2luZyB0aGF0IEkgaGF2ZSBkb25lIHRoZSA0LjE0IGJhY2twb3J0IGZvciB0aGVzZS4NCg0K
RnJhbmsNCg0K77u/T24gNC8zMC8yMSwgNjozOSBBTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZz4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0
ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQg
a25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9uIFRodSwgQXByIDI5LCAyMDIx
IGF0IDEwOjA4OjMxUE0gKzAwMDAsIEZyYW5rIHZhbiBkZXIgTGluZGVuIHdyb3RlOg0KICAgID4g
VGhpcyBpcyBhIGJhY2twb3J0IG9mIHRoZSBCUEYgdmVyaWZpZXIgZml4ZXMgZm9yIENWRS0yMDIx
LTI5MTU1LiBPcmlnaW5hbA0KICAgID4gc2VyaWVzIHdhcyBwYXJ0IG9mIHRoZSBwdWxsIHJlcXVl
c3QgaGVyZTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMjEwNDE2MjIzNzAwLjE1NjEx
LTEtZGFuaWVsQGlvZ2VhcmJveC5uZXQvVC8NCiAgICA+DQogICAgPiBUaGlzIHdhc24ndCBhIGNv
bXBsaWNhdGVkIGJhY2twb3J0LCBidXQgY29weWluZyBicGZAIHRvIHNlZSBpZg0KICAgID4gdGhl
cmUgYXJlIGFueSBjb25jZXJucy4NCiAgICA+DQogICAgPiA1LjQgdmVyaWZpZXIgc2VsZnRlc3Rz
IGFyZSBjbGVhbiB3aXRoIHRoaXMgYmFja3BvcnQ6DQogICAgPiAgICAgICBTdW1tYXJ5OiAxNTY2
IFBBU1NFRCwgMCBTS0lQUEVELCAwIEZBSUxFRA0KICAgID4NCiAgICA+IFRoZSBpbmRpdmlkdWFs
IGNvbW1pdHM6DQoNCiAgICBNYW55IHRoYW5rcyBmb3IgdGhlc2UsIG5vdyBxdWV1ZWQgdXAuDQoN
CiAgICBncmVnIGstaA0KDQo=
