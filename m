Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD029291D
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 16:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgJSORo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 10:17:44 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:32227 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgJSORo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 10:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1603117063; x=1634653063;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=f73gjar+qQ0VoBhxMU/i1WGElHpj0meOcMRJIbKvZuM=;
  b=HXQ3MZt7bSqShhyA3D5qdgONk+wmoOayw7tsVChUt2S36phOoYo2y5VS
   55jCKbOLMb5O5JrN5HOxQsC2u8BvYrS/NPoQhBF1SlNITwBhA2Gq+EVg7
   CdADmHu+NBe8wMSPP0gx10rNKyaYuOj0NRZ50QPzmUDEe1weX1VlzkCSS
   E=;
X-IronPort-AV: E=Sophos;i="5.77,394,1596499200"; 
   d="scan'208";a="60561965"
Subject: Re: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Thread-Topic: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Oct 2020 14:17:37 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id E32F3B986D;
        Mon, 19 Oct 2020 14:17:36 +0000 (UTC)
Received: from EX13D11UEB001.ant.amazon.com (10.43.60.235) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 14:17:36 +0000
Received: from EX13D11UEB004.ant.amazon.com (10.43.60.132) by
 EX13D11UEB001.ant.amazon.com (10.43.60.235) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 14:17:35 +0000
Received: from EX13D11UEB004.ant.amazon.com ([10.43.60.132]) by
 EX13D11UEB004.ant.amazon.com ([10.43.60.132]) with mapi id 15.00.1497.006;
 Mon, 19 Oct 2020 14:17:35 +0000
From:   "Protopopov, Boris" <pboris@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     stable <stable@vger.kernel.org>
Thread-Index: AQHWpJoxvkgDfMnA7kSnhOBbCo9a7qmc3VCAgAHbm4A=
Date:   Mon, 19 Oct 2020 14:17:35 +0000
Message-ID: <B1901644-CAEB-45B7-87F8-A05C70423914@amazon.com>
References: <20201017152839.4398-1-pboris@amazon.com>
 <20201018055519.GB599591@kroah.com>
In-Reply-To: <20201018055519.GB599591@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.62.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB3E1CFA4B52CD4E816930498C17A693@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSBjb3VsZCBub3QgZmluZCB0aGUgcGF0Y2ggaW4gTGludXMncyB0cmVlIGF0IGh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90
cmVlL2ZzL2NpZnMvY2lmc191bmljb2RlLmMjbjQ5MSBvciBpbiB0aGUgY29tbWl0IGxpc3QuIFRo
ZSBwYXRjaCBpcyBpbiBsaW51eC1uZXh0LCBjb21taXQgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0LmdpdC9jb21taXQvP2lkPTc2
OThhNDZlZDg2OGYwM2FmZTE4NzFkN2NiNjMwNjFkYjZhNjJiNzENCg0K77u/T24gMTAvMTgvMjAs
IDE6NTYgQU0sICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0K
DQogICAgQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUg
b3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxl
c3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2Fm
ZS4NCg0KDQoNCiAgICBPbiBTYXQsIE9jdCAxNywgMjAyMCBhdCAwMzoyODozOVBNICswMDAwLCBC
b3JpcyBQcm90b3BvcG92IHdyb3RlOg0KICAgID4gV2hlbiBjb252ZXJ0aW5nIHRyYWlsaW5nIHNw
YWNlcyBhbmQgcGVyaW9kcyBpbiBwYXRocywgZG8gc28NCiAgICA+IGZvciBldmVyeSBjb21wb25l
bnQgb2YgdGhlIHBhdGgsIG5vdCBqdXN0IHRoZSBsYXN0IGNvbXBvbmVudC4NCiAgICA+IElmIHRo
ZSBjb252ZXJzaW9uIGlzIG5vdCBkb25lIGZvciBldmVyeSBwYXRoIGNvbXBvbmVudCwgdGhlbg0K
ICAgID4gc3Vic2VxdWVudCBvcGVyYXRpb25zIGluIGRpcmVjdG9yaWVzIHdpdGggdHJhaWxpbmcg
c3BhY2VzIG9yDQogICAgPiBwZXJpb2RzIChlLmcuIGNyZWF0ZSgpLCBta2RpcigpKSB3aWxsIGZh
aWwgd2l0aCBFTk9FTlQuIFRoaXMNCiAgICA+IGlzIGJlY2F1c2Ugb24gdGhlIHNlcnZlciwgdGhl
IGRpcmVjdG9yeSB3aWxsIGhhdmUgYSBzcGVjaWFsDQogICAgPiBzeW1ib2wgaW4gaXRzIG5hbWUs
IGFuZCB0aGUgY2xpZW50IG5lZWRzIHRvIHByb3ZpZGUgdGhlIHNhbWUuDQogICAgPg0KICAgID4g
Q2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDQuOS54LTUuOC54DQogICAgPiBTaWduZWQt
b2ZmLWJ5OiBCb3JpcyBQcm90b3BvcG92IDxwYm9yaXNAYW1hem9uLmNvbT4NCiAgICA+IC0tLQ0K
ICAgID4gIGZzL2NpZnMvY2lmc191bmljb2RlLmMgfCA4ICsrKysrKystDQogICAgPiAgMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KICAgID4NCiAgICA+IGRp
ZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNfdW5pY29kZS5jIGIvZnMvY2lmcy9jaWZzX3VuaWNvZGUu
Yw0KICAgID4gaW5kZXggNDk4Nzc3ZDg1OWViLi45YmQwM2EyMzEwMzIgMTAwNjQ0DQogICAgPiAt
LS0gYS9mcy9jaWZzL2NpZnNfdW5pY29kZS5jDQogICAgPiArKysgYi9mcy9jaWZzL2NpZnNfdW5p
Y29kZS5jDQogICAgPiBAQCAtNDg4LDcgKzQ4OCwxMyBAQCBjaWZzQ29udmVydFRvVVRGMTYoX19s
ZTE2ICp0YXJnZXQsIGNvbnN0IGNoYXIgKnNvdXJjZSwgaW50IHNyY2xlbiwNCiAgICA+ICAgICAg
ICAgICAgICAgZWxzZSBpZiAobWFwX2NoYXJzID09IFNGTV9NQVBfVU5JX1JTVkQpIHsNCiAgICA+
ICAgICAgICAgICAgICAgICAgICAgICBib29sIGVuZF9vZl9zdHJpbmc7DQogICAgPg0KICAgID4g
LSAgICAgICAgICAgICAgICAgICAgIGlmIChpID09IHNyY2xlbiAtIDEpDQogICAgPiArICAgICAg
ICAgICAgICAgICAgICAgLyoqDQogICAgPiArICAgICAgICAgICAgICAgICAgICAgICogUmVtYXAg
c3BhY2VzIGFuZCBwZXJpb2RzIGZvdW5kIGF0IHRoZSBlbmQgb2YgZXZlcnkNCiAgICA+ICsgICAg
ICAgICAgICAgICAgICAgICAgKiBjb21wb25lbnQgb2YgdGhlIHBhdGguIFRoZSBzcGVjaWFsIGNh
c2VzIG9mICcuJyBhbmQNCiAgICA+ICsgICAgICAgICAgICAgICAgICAgICAgKiAnLi4nIGRvIG5v
dCBuZWVkIHRvIGJlIGRlYWx0IHdpdGggZXhwbGljaXRseSBiZWNhdXNlDQogICAgPiArICAgICAg
ICAgICAgICAgICAgICAgICogdGhleSBhcmUgYWRkcmVzc2VkIGluIG5hbWVpLmM6bGlua19wYXRo
X3dhbGsoKS4NCiAgICA+ICsgICAgICAgICAgICAgICAgICAgICAgKiovDQogICAgPiArICAgICAg
ICAgICAgICAgICAgICAgaWYgKChpID09IHNyY2xlbiAtIDEpIHx8IChzb3VyY2VbaSsxXSA9PSAn
XFwnKSkNCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVuZF9vZl9zdHJpbmcg
PSB0cnVlOw0KICAgID4gICAgICAgICAgICAgICAgICAgICAgIGVsc2UNCiAgICA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGVuZF9vZl9zdHJpbmcgPSBmYWxzZTsNCiAgICA+IC0tDQog
ICAgPiAyLjE4LjQNCiAgICA+DQoNCiAgICBXaGF0IGlzIHRoZSBnaXQgY29tbWl0IGlkIG9mIHRo
aXMgaW4gTGludXMncyB0cmVlPw0KDQogICAgdGhhbmtzLA0KDQogICAgZ3JlZyBrLWgNCg0K
