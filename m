Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7D5E39D8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 19:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394001AbfJXRYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 13:24:49 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:61708 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394000AbfJXRYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 13:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1571937889; x=1603473889;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=DdiF4fT2tWezlf4zcnBpj6Efy5+OMld1EqjDZRlLN8o=;
  b=rT8WWzlhv2cnYa3/3AqBLaWDKx0BAiuNH3ENF4gtp2p/XntsouSQBEft
   LBgmK37l+NqGxGQnyyBN043IhbgDUm03inKoblu6TOyqmc/Zwhph1r14W
   OsjUVopZUsbCYUP93OvobIhawdg+A/k9rNL0RVNS+APLbYQ3peGa8YyAY
   Y=;
X-IronPort-AV: E=Sophos;i="5.68,225,1569283200"; 
   d="scan'208";a="796980691"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Oct 2019 17:24:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 4BA8E2838F7
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 17:24:44 +0000 (UTC)
Received: from EX13D30UWB001.ant.amazon.com (10.43.161.80) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 24 Oct 2019 17:24:44 +0000
Received: from EX13D30UWB001.ant.amazon.com (10.43.161.80) by
 EX13D30UWB001.ant.amazon.com (10.43.161.80) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 24 Oct 2019 17:24:44 +0000
Received: from EX13D30UWB001.ant.amazon.com ([10.43.161.80]) by
 EX13D30UWB001.ant.amazon.com ([10.43.161.80]) with mapi id 15.00.1367.000;
 Thu, 24 Oct 2019 17:24:44 +0000
From:   "Jitindar SIngh, Suraj" <surajjs@amazon.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: stable/4.14.y: kvm: vmx: Basic APIC virtualization controls have
 three settings
Thread-Topic: stable/4.14.y: kvm: vmx: Basic APIC virtualization controls have
 three settings
Thread-Index: AQHVio/tMhpZXzbjAEm12QDKUZ2srg==
Date:   Thu, 24 Oct 2019 17:24:44 +0000
Message-ID: <17bb312d55c6a00e27941e12cf4898fac2d2cb14.camel@amazon.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.127]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCBED47FD2E70F448531BC38CA2A8B5A@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIGZvbGxvd2luZyBwYXRjaCBmaXhlcyBhIGJ1ZyB3aGVyZSB0aGUgZ3Vlc3QgaXMgc3RpbGwg
YWJsZSB0byBhY2Nlc3MNCnRoZSBhcGljIHJlZ2lzdGVycyB2aWEgbW1pbyBvbmNlIHRoZSBhcGlj
IGhhcyBiZWVuIGRpc2FibGVkLg0KDQo4ZDg2MGJiZWVkZWYga3ZtOiB2bXg6IEJhc2ljIEFQSUMg
dmlydHVhbGl6YXRpb24gY29udHJvbHMgaGF2ZSB0aHJlZQ0Kc2V0dGluZ3MNCg0KVGhpcyBjYXVz
ZXMgdGhlIHg4Ni9hcGljIGt2bS11bml0LXRlc3QgdG8gZmFpbCB3aGVuIHJ1biBvbiBhIGhvc3QN
Cm1pc3NpbmcgdGhpcyBwYXRjaC4NCg0KV2l0aG91dDoNCkZBSUw6IGFwaWNfZGlzYWJsZTogKjB4
ZmVlMDAwMzA6IDUwMDE0DQpGQUlMOiBhcGljX2Rpc2FibGU6IENSODogZg0KUEFTUzogYXBpY19k
aXNhYmxlOiBDUjg6IGYNCkZBSUw6IGFwaWNfZGlzYWJsZTogKjB4ZmVlMDAwODA6IGYwDQpXaXRo
Og0KUEFTUzogYXBpY19kaXNhYmxlOiAqMHhmZWUwMDAzMDogZmZmZmZmZmYNClBBU1M6IGFwaWNf
ZGlzYWJsZTogQ1I4OiAwDQpQQVNTOiBhcGljX2Rpc2FibGU6IENSODogZg0KUEFTUzogYXBpY19k
aXNhYmxlOiAqMHhmZWUwMDA4MDogZmZmZmZmZmYNCg0KVGhpcyBwYXRjaCBoYXMgYmVlbiB1cHN0
cmVhbSBhcyBvZiB2NC4xOC4NCg0KVGhpcyBwYXRjaCBoYXMgMyBkZXBlbmRlbmNpZXMgd2hpY2gg
aW50cm9kdWNlIG5vIGZ1bmN0aW9uYWwNCmNoYW5nZSwgaG93ZXZlciB0aGV5IGFkZCBjb250ZXh0
IHdoaWNoIGFsbG93cyB0aGUgcGF0Y2ggbGlzdGVkIGFib3ZlIHRvDQphcHBseSBjbGVhbmx5Lg0K
DQpjMmJhMDVjY2ZkZTIgS1ZNOiBYODY6IGludHJvZHVjZSBpbnZhbGlkYXRlX2dwYSBhcmd1bWVu
dCB0byB0bGIgZmx1c2gNCjU4ODcxNjQ5NDI1OCBrdm06IHZteDogSW50cm9kdWNlIGxhcGljX21v
ZGUgZW51bWVyYXRpb24NCmE0NjhmMmRiZjkyMSBrdm06IGFwaWM6IEZsdXNoIFRMQiBhZnRlciBB
UElDIG1vZGUvYWRkcmVzcyBjaGFuZ2UgaWYNClZQSURzIGFyZSBpbiB1c2UNCg0KVGhpcyBwYXRj
aCBzZXJpZXMgc2hvdWxkIGJlIGFwcGxpZWQgYWdhaW5zdCA0LjE0LnkNCg==
