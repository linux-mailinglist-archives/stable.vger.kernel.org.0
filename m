Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638D969F5F6
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjBVN4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 08:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjBVN4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 08:56:47 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522DE367D4
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 05:56:46 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-206-sdCVamJYOHihlMTsH2h34w-1; Wed, 22 Feb 2023 13:56:43 +0000
X-MC-Unique: sdCVamJYOHihlMTsH2h34w-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Wed, 22 Feb
 2023 13:56:41 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Wed, 22 Feb 2023 13:56:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Borislav Petkov' <bp@alien8.de>, KP Singh <kpsingh@kernel.org>
CC:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "evn@google.com" <evn@google.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kim.phillips@amd.com" <kim.phillips@amd.com>,
        "alexandre.chartre@oracle.com" <alexandre.chartre@oracle.com>,
        "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>, "bp@suse.de" <bp@suse.de>,
        "linyujun809@huawei.com" <linyujun809@huawei.com>,
        "jmattson@google.com" <jmattson@google.com>,
        =?utf-8?B?Sm9zw6kgT2xpdmVpcmE=?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Thread-Topic: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Thread-Index: AQHZRrnENHDoHoAiDEivYbQVDCYqo67a/I1Q
Date:   Wed, 22 Feb 2023 13:56:40 +0000
Message-ID: <2cfb89db3cfb418cb3e929b1c0d80ee5@AcuMS.aculab.com>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <20230222030728.v4ldlndtnx6gqd6x@desk>
 <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
 <Y/YLYbr5CV2Vtxph@zn.tnic>
In-Reply-To: <Y/YLYbr5CV2Vtxph@zn.tnic>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQm9yaXNsYXYgUGV0a292DQo+IFNlbnQ6IDIyIEZlYnJ1YXJ5IDIwMjMgMTI6MzMNCj4g
DQo+IE9uIFR1ZSwgRmViIDIxLCAyMDIzIGF0IDA5OjQ5OjU3UE0gLTA4MDAsIEtQIFNpbmdoIHdy
b3RlOg0KPiA+IFRoYXQgaXMgYSBiaXQgbW9yZSBjb21wbGljYXRlZCBhcywgZm9yIG5vdywgdGhl
IHVzZXIgaXMgbm90IHJlYWxseQ0KPiA+IGV4cG9zZWQgdG8gU1RJQlAgZXhwbGljaXRseSB5ZXQu
DQo+IA0KPiBSZW1lbWJlciB0aGF0IHdlJ3JlIGV4cG9zaW5nIHRoZSBub3JtYWwgdXNlciB0byBh
IGdhemlsbGlvbiBzd2l0Y2hlcw0KPiBhbHJlYWR5LiBBbmQgbm90IGV2ZXJ5IHVzZXIgaGFzIGRv
bmUgYSBQaEQgaW4gaHcgdnVsbnMgbGlrZSB3ZSB3ZXJlDQo+IGZvcmNlZCB0byBpbiB0aGUgbGFz
dCwgYXQgbGVhc3QgNSwgeWVhcnMuDQoNCkl0IGlzIGFsc28gd29ydGggZXhwbGFpbmluZyB0aGUg
YWNyb255bXMgYW5kIHdoYXQgdGhlIG1pdGlnYXRpb25zDQphY3R1YWxseSBkby4NClRoZXJlIGFy
ZSBhbHNvIHRoZSBiaWcgZmFtaWx5IHdoZXJlIGRpc2FibGluZyBoeXBlcnRocmVhZGluZw0KaXMg
cHJvYmFibHkgYSBiZXR0ZXIgd2F5IHRvIGF2b2lkIHRoZSB2dWxuZXJhYmlsaXR5Lg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

