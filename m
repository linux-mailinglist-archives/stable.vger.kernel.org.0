Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A570D5BEA4E
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 17:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiITPeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 11:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiITPeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 11:34:20 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F32A6746C
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 08:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1663688060; x=1695224060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4fAgG3ushHeWZeT8y1lPEGeHUM3kF+Hdz+jUxFLG7Vk=;
  b=nN3oUjnDC5qbpljXI1/V/VWv75BmNEDv/wUqgSs56L7rv7ia6UX//ex6
   C52z5btg/iPADJb84cgSU/VAbWKeg74ClrKq2JZY84i4+5IL4pBRKgUE2
   j4KWJty3uQZcdq2me5tiEkr38HXjkhfCNCDRlPG5tkrFR+4owFAf7fnba
   w=;
X-IronPort-AV: E=Sophos;i="5.93,330,1654560000"; 
   d="scan'208";a="243108224"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 15:34:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 87D1080370;
        Tue, 20 Sep 2022 15:34:05 +0000 (UTC)
Received: from EX19D012UWC001.ant.amazon.com (10.13.138.177) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 20 Sep 2022 15:34:05 +0000
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19D012UWC001.ant.amazon.com (10.13.138.177) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Tue, 20 Sep 2022 15:34:04 +0000
Received: from EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754]) by
 EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754%4]) with mapi id
 15.02.1118.012; Tue, 20 Sep 2022 15:34:04 +0000
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Jitindar Singh, Suraj" <surajjs@amazon.com>,
        "Bacco, Mike" <mbacco@amazon.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH 0/9] KVM backports to 5.10
Thread-Topic: [PATCH 0/9] KVM backports to 5.10
Thread-Index: AQHYxH3aOO8q2nby0kmhnIisUBLSYa3nHA+A
Date:   Tue, 20 Sep 2022 15:34:04 +0000
Message-ID: <A0B41A72-984A-4984-81F3-B512DFF92F59@amazon.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
In-Reply-To: <20220909185557.21255-1-risbhat@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.160.214]
Content-Type: text/plain; charset="utf-8"
Content-ID: <64F88DBD1459F949B897777A6C6ACB31@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

R2VudGxlIHJlbWluZGVyIHRvIHJldmlldyB0aGlzIHBhdGNoIHNlcmllcy4NCg0K77u/T24gOS85
LzIyLCAxMTo1NiBBTSwgIlJpc2hhYmggQmhhdG5hZ2FyIiA8cmlzYmhhdEBhbWF6b24uY29tPiB3
cm90ZToNCg0KICAgIFRoaXMgcGF0Y2ggc2VyaWVzIGJhY2twb3J0cyBhIGZldyBWTSBwcmVlbXB0
aW9uX3N0YXR1cywgc3RlYWxfdGltZSBhbmQNCiAgICBQViBUTEIgZmx1c2hpbmcgZml4ZXMgdG8g
NS4xMCBzdGFibGUga2VybmVsLg0KDQogICAgTW9zdCBvZiB0aGUgY2hhbmdlcyBiYWNrcG9ydCBj
bGVhbmx5IGV4Y2VwdCBpIGhhZCB0byB3b3JrIGFyb3VuZCBhIGZldw0KICAgIGJlY2F1c2VvZiBt
aXNzaW5nIHN1cHBvcnQvQVBJcyBpbiA1LjEwIGtlcm5lbC4gSSBoYXZlIGNhcHR1cmVkIHRob3Nl
IGluDQogICAgdGhlIGNoYW5nZWxvZyBhcyB3ZWxsIGluIHRoZSBpbmRpdmlkdWFsIHBhdGNoZXMu
DQoNCiAgICBDaGFuZ2Vsb2cNCiAgICAtIFVzZSBtYXJrX3BhZ2VfZGlydHlfaW5fc2xvdCBhcGkg
d2l0aG91dCBrdm0gYXJndW1lbnQgKEtWTTogeDg2OiBGaXgNCiAgICAgIHJlY29yZGluZyBvZiBn
dWVzdCBzdGVhbCB0aW1lIC8gcHJlZW1wdGVkIHN0YXR1cykNCiAgICAtIEF2b2lkIGNoZWNraW5n
IGZvciB4ZW5fbXNyIGFuZCBTRVYtRVMgY29uZGl0aW9ucyAoS1ZNOiB4ODY6DQogICAgICBkbyBu
b3Qgc2V0IHN0LT5wcmVlbXB0ZWQgd2hlbiBnb2luZyBiYWNrIHRvIHVzZXIgc3BhY2UpDQogICAg
LSBVc2UgVkNQVV9TVEFUIG1hY3JvIHRvIGV4cG9zZSBwcmVlbXB0aW9uX3JlcG9ydGVkIGFuZA0K
ICAgICAgcHJlZW1wdGlvbl9vdGhlciBmaWVsZHMgKEtWTTogeDg2OiBkbyBub3QgcmVwb3J0IGEg
dkNQVSBhcyBwcmVlbXB0ZWQNCiAgICAgIG91dHNpZGUgaW5zdHJ1Y3Rpb24gYm91bmRhcmllcykN
Cg0KICAgIERhdmlkIFdvb2Rob3VzZSAoMik6DQogICAgICBLVk06IHg4NjogRml4IHJlY29yZGlu
ZyBvZiBndWVzdCBzdGVhbCB0aW1lIC8gcHJlZW1wdGVkIHN0YXR1cw0KICAgICAgS1ZNOiBGaXgg
c3RlYWwgdGltZSBhc20gY29uc3RyYWludHMNCg0KICAgIExhaSBKaWFuZ3NoYW4gKDEpOg0KICAg
ICAgS1ZNOiB4ODY6IEVuc3VyZSBQViBUTEIgZmx1c2ggdHJhY2Vwb2ludCByZWZsZWN0cyBLVk0g
YmVoYXZpb3INCg0KICAgIFBhb2xvIEJvbnppbmkgKDUpOg0KICAgICAgS1ZNOiB4ODY6IGRvIG5v
dCBzZXQgc3QtPnByZWVtcHRlZCB3aGVuIGdvaW5nIGJhY2sgdG8gdXNlciBzcGFjZQ0KICAgICAg
S1ZNOiB4ODY6IGRvIG5vdCByZXBvcnQgYSB2Q1BVIGFzIHByZWVtcHRlZCBvdXRzaWRlIGluc3Ry
dWN0aW9uDQogICAgICAgIGJvdW5kYXJpZXMNCiAgICAgIEtWTTogeDg2OiByZXZhbGlkYXRlIHN0
ZWFsIHRpbWUgY2FjaGUgaWYgTVNSIHZhbHVlIGNoYW5nZXMNCiAgICAgIEtWTTogeDg2OiBkbyBu
b3QgcmVwb3J0IHByZWVtcHRpb24gaWYgdGhlIHN0ZWFsIHRpbWUgY2FjaGUgaXMgc3RhbGUNCiAg
ICAgIEtWTTogeDg2OiBtb3ZlIGd1ZXN0X3B2X2hhcyBvdXQgb2YgdXNlcl9hY2Nlc3Mgc2VjdGlv
bg0KDQogICAgU2VhbiBDaHJpc3RvcGhlcnNvbiAoMSk6DQogICAgICBLVk06IHg4NjogUmVtb3Zl
IG9ic29sZXRlIGRpc2FibGluZyBvZiBwYWdlIGZhdWx0cyBpbg0KICAgICAgICBrdm1fYXJjaF92
Y3B1X3B1dCgpDQoNCiAgICAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAgNSAr
LQ0KICAgICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAgICAgIHwgICAyICsNCiAgICAgYXJj
aC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICB8ICAgMSArDQogICAgIGFyY2gveDg2L2t2bS94
ODYuYyAgICAgICAgICAgICAgfCAxNjQgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0N
CiAgICAgNCBmaWxlcyBjaGFuZ2VkLCAxMjIgaW5zZXJ0aW9ucygrKSwgNTAgZGVsZXRpb25zKC0p
DQoNCiAgICAtLSANCiAgICAyLjM3LjENCg0KDQo=
