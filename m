Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A592EEB4F
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAHCdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:33:45 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38156 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbhAHCdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:33:44 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7677B4017D;
        Fri,  8 Jan 2021 02:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610073164; bh=XvFAHqsifDSoQPC7+FztIBj0AbhhXOlu35VW8EdqOHA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Q48vthay5wyvAv+NJrSL2ZgmmbYoq+Ne7ugfl2MxwLMufcSylDZH53u/dY66CE9/r
         Ny1A50hMBkgUvSmsTyqVu5WreRLlMJxQgeswC1wYJ4AmX4vNvVxNlpzBrbt1Q/KQhw
         FaHSCqjRvs74iHubXSyTJXrXHrCurp2Qw14smz1e9bH5Zd2zxEJC3BtrFVpvxmBLn3
         gD4BWflG6XDhX1lnNxmugo57eEiqxZ4lyiSumtodNSxtHTLubm/m8APrqaXrGFDQ5p
         87FuDnDAGmkLnhfhKC/VrRP51y+prNsZKhWjExbGYQA+rlLQfIcbyza0Vsat5KUeOj
         H36lIS/qobBXg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5DB28A0068;
        Fri,  8 Jan 2021 02:32:41 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id D59AE80218;
        Fri,  8 Jan 2021 02:32:40 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Pv0Rlw2E";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GamAxDfnKOjZvFMcQZexMQAZ0HrVCv1wIqD+eZ1ynxUr8SPHSjl+GaiC07mwNlGQN/jtJxgSWU/RzQ6/pmdWtI/Y2BjpX4wNq5lFAchfFHgZ8u0JLtua4xwk/5bF+yRQxGbTmb06XrtnS+JFAuDQhZY4mKPt8HH5yHXWC5nnoPabj8bZRUW5S8K8y+DSHKD5Q6wv8mi9AJi/q0a8COyWtn8AuyQGcBTWU/Bo4DZCpebvUe96FhQT14axLgPC+luvrNxJQZH1WDQ4m7sc75smnI/XYtV8Q/XDnCpzRvJ8rwopuqS0xOxe4Mce2o6hfYO/oOdkyF/FTfCuHKXyZo6ifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvFAHqsifDSoQPC7+FztIBj0AbhhXOlu35VW8EdqOHA=;
 b=CY1Rkcb/PQ/mqyaLrHBU8n8AksqF6Y01vnShO3Zp/H49cE+npONYFRpklo9eUumB7ps6SphVkPaFwMMCo38TTdx59GZ6BLpsXsboPyd1lkXGSA0bUzTqgod7G6jEbg5lcLkHuddC2JSCLwz9uBiPk0/lF0PLrsAaG51Lqneag1N8Emh3153n+Qm4mylWjaLfSVeg5yhh1mmjM3MMz/1viBpX2PWnokPfqzLUq+KcJmCvt+rCUlQkHcvRnXkEP7GaxJLZuEQgeYkn64n/n5ZWyMmaGNJ5EPMKmKxf6eAO/frLbcld0XhJekTFhLXt7oFetkuPUm13Sw+HtfBT6+AgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvFAHqsifDSoQPC7+FztIBj0AbhhXOlu35VW8EdqOHA=;
 b=Pv0Rlw2E7O0g6kgyQ/suntPFJMq/E4ktPoUTlN+ooVe+qfnoL6LaD2JZzgDG7CXRzfrKa8v+Zq9ym4P3YPO9CqIfQ8/XF/kQ2QUspCwgnO7u9GsMtw4LZ6kZD+ZV/0pSdakqpWOdEfb/VWPE1RK7yCpoqdyM/m6j5+M2Vgjc5KE=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4641.namprd12.prod.outlook.com (2603:10b6:a03:1f7::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 02:32:39 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Fri, 8 Jan 2021
 02:32:38 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Topic: [PATCH] usb: dwc3: gadget: Init only available HW eps
Thread-Index: AQHW44dsvevXDR9T+0aaJdM98rGhjKoaOlYAgAAbXwCAAZOGAIABHMSA
Date:   Fri, 8 Jan 2021 02:32:38 +0000
Message-ID: <cacf58e7-e131-2caa-5fb3-1af7db8270b4@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
 <87eeiycxld.fsf@kernel.org>
 <75d63bab-1cdc-737e-8ae2-64e0ddeeef75@synopsys.com>
 <87k0spay6z.fsf@kernel.org>
In-Reply-To: <87k0spay6z.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caa7d66a-2828-451f-7107-08d8b37daa9b
x-ms-traffictypediagnostic: BY5PR12MB4641:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4641F686EA17DD3476D65CB6AAAE0@BY5PR12MB4641.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uzGgGaUBEs786WEFO/59htEwxoN0MleCwrddxypIwtOIa14MIiP9BRou8OUNNzMLLLlbH+aEubQUpn8dujzr/TEkHMaDYbLV5gJI5NIpyQZV3owz1QsBBDAzlp0IJDPtAiIV2P7xqsl+LrTV6siQYVSJ/Ff2cGHaHvjCKdTmLA89E33/Zzw0q5K8ZfKQnKtBaMBkQqevTzDtIresdY+kJJFSQiZ6PAdlj2FsmBOsVNrmyxeg6Tf+jffTJooYNfAjh9315G4+yk5cGhzZEECPjNjRgCrvB+En9FwUzqcNwLlJhVDCo+i5O7QpX7G/uQ1/c9F02CkaWR2Dr8CqRg/3V5FlYzja2UOqtcebVPhgm+VAb5eOMWWZjYCVXhAFDpvgsidkXynSgBfgjMQGRIVnjIHfBAyvwMEm+OV3TW4Ebc3lA0rzkBLPGn5dCcr+II66/G2sYKx1O7/H4etUhUP+ShEaSqU/GtKxaXc65IxEb3V//kOnMzV825amQYYd2a50
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(64756008)(6506007)(66946007)(66476007)(66446008)(76116006)(54906003)(66556008)(31696002)(5660300002)(110136005)(86362001)(2616005)(6512007)(8936002)(316002)(186003)(478600001)(6486002)(71200400001)(26005)(83380400001)(36756003)(2906002)(8676002)(31686004)(4326008)(131093003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L1JCTFpvZHR1VnlpMVlqTk5hdTRJeGd0Umd1TGpkaDNPZzNOV1NnbzgxdkR2?=
 =?utf-8?B?VmxKUGFyUWRPOStHM3VtREVTWXNlbFNadDJpdHZTT09JcVcxUUJVaXlGQkx3?=
 =?utf-8?B?REdMMngvVHkwSE81elN0L1JrT0lneVozUUx6VzJTSmNpdXR1azhZdU56ZHAr?=
 =?utf-8?B?K0FEOXFvT2RJMElHM3lrYnJ2eDlaWER1Umg5SXg0aERnaFNZOFZ4aXpEZnBP?=
 =?utf-8?B?V1lSa1l5Q0RseUtoQUFaT1hiVlQ0THNGVk5qU29xb3NCa3FNbGd0M3d6STZT?=
 =?utf-8?B?bmQ0aUZERi9DT3ZYSXZPUkQvbm9SWEZNZHdWMnVLUkdpYnJyaE5jRkJVYTdP?=
 =?utf-8?B?b0huUHJ2QmRQSFQ2MjlkWGFhbjUyV29Mb2NLMG9VelQ4Tlg5VWk2UjMxTDcy?=
 =?utf-8?B?V2xFVG9jR1ZLbmtHcThYUkZMc2VXQ3VLZ0UxaUVwQ3VPdElpTzNRdmxIM3Ew?=
 =?utf-8?B?TUdXdExlTXVlNUJUM0E5V2hncXJKaUNuaWZsNnkvMjM4bFdrS0hCNVBKbkEx?=
 =?utf-8?B?cVpFWUhHOVN0MTk5OTdFTlg4bDNjNHhJSUVSWURaZzZBQS8rd2lIdWVVUkFK?=
 =?utf-8?B?YW5MS05KQ2hEQ2xnT2tleS9JYnk1UENxaUxwU3ZFdndDRlcvUFpuSmNUN2Yr?=
 =?utf-8?B?L1p2OFdBN2RObDY3YTJ2anBEd005NkZoZU1iZkJwd0J2TVlmdGdrelZvZFdo?=
 =?utf-8?B?NzRCYTl6QUNLemNDdXM1cml2ZE9XS0RpSW9pa1ZwMzdmZTdhcTBUMFZydnVW?=
 =?utf-8?B?NjRBZmpKVnhKM3MzTFQxZGlzSlhLTzYyc3l5Z0UzTGl3VTl5a0lzN0ZIUUt4?=
 =?utf-8?B?NG82eGxGU0ZEcG9JMG0vWjh2UFFWdUd3NytmRzVQMmh1Kyt4RnAyby9jR1Uv?=
 =?utf-8?B?c0ZuUVdjVFE3K3N4SW9TUUVNTHoxVTdSSFlhWWlIY2xra0JzaTBPdnphdVNG?=
 =?utf-8?B?bEFLbzRGalkxU052WGVQSXN1L2lvSFNwOXNyQzR6VkZiaFVMR0lGT0pmMUdM?=
 =?utf-8?B?S3N5cjVYZFBxM01LSDBJNDRSVkJ5TGh0dVF3dVptTG4rUnUwT1lGanV2V3ZY?=
 =?utf-8?B?SDhjNG15UlVaN0lUSE9ZUExsbjlLWnMwMUR2amdTOEwyTU9ueVZlaHhmSmhY?=
 =?utf-8?B?b2F2SU55TmFGOCtIb3ZReG54VUN5M0JzVjhzbTJjZFZ5c1ZGZVFoejJOTitk?=
 =?utf-8?B?RXFtcHRQY2tQY0N3ZXA0YldoQU9LQXdWTmpzeGN1eUNsenBaYVc0ZjYyQzVS?=
 =?utf-8?B?ZGw3bXQvOTZlc3BnM2ZNakxFd0x5M2RVaUdWSkRldXZmeVpubk1ueFN5aWlj?=
 =?utf-8?Q?vYWppD6WRbijY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4777E8D1831F0499F5AB3A5B9E9EAC6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa7d66a-2828-451f-7107-08d8b37daa9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 02:32:38.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdyS+d2BK7DAF5qejFFNJXo804KcFXLzHbaLGK5OXKvQISdRUAegYGdtL5JtICZs95hqZRBwqMwlNy12fMnP0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4641
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkZlbGlwZSBCYWxiaSB3cm90ZToNCj4gSGksDQo+DQo+IFRoaW5oIE5ndXllbiA8VGhp
bmguTmd1eWVuQHN5bm9wc3lzLmNvbT4gd3JpdGVzOg0KPj4+PiBAQCAtMzg2Myw3ICszODY4LDcg
QEAgaW50IGR3YzNfZ2FkZ2V0X2luaXQoc3RydWN0IGR3YzMgKmR3YykNCj4+Pj4gIAkgKiBzdXJl
IHdlJ3JlIHN0YXJ0aW5nIGZyb20gYSB3ZWxsIGtub3duIGxvY2F0aW9uLg0KPj4+PiAgCSAqLw0K
Pj4+PiAgDQo+Pj4+IC0JcmV0ID0gZHdjM19nYWRnZXRfaW5pdF9lbmRwb2ludHMoZHdjLCBkd2Mt
Pm51bV9lcHMpOw0KPj4+PiArCXJldCA9IGR3YzNfZ2FkZ2V0X2luaXRfZW5kcG9pbnRzKGR3Yyk7
DQo+Pj4+ICAJaWYgKHJldCkNCj4+Pj4gIAkJZ290byBlcnI0Ow0KPj4+IGhlaCwgbG9va2luZyBh
dCBvcmlnaW5hbCBjb21taXQsIHdlIHVzZWQgdG8gaGF2ZSBudW1faW5fZXBzIGFuZA0KPj4+IG51
bV9vdXRfZXBzLiBJbiBmYWN0LCB0aGlzIGNvbW1pdCB3aWxsIHJlaW50cm9kdWNlIGFub3RoZXIg
cHJvYmxlbSB0aGF0DQo+Pj4gQnJ5YW4gdHJpZWQgdG8gc29sdmUuIG51bV9lcHMgLSBudW1faW5f
ZXBzIGlzIG5vdCBuZWNlc3NhcmlseQ0KPj4+IG51bV9vdXRfZXBzLg0KPj4+DQo+PiBGcm9tIG15
IHVuZGVyc3RhbmRpbmcsIHRoYXQncyBub3Qgd2hhdCBCcnlhbidzIHNheWluZy4gSGVyZSdzIHRo
ZQ0KPj4gc25pcHBldCBvZiB0aGUgY29tbWl0IG1lc3NhZ2U6DQo+Pg0KPj4gIg0KPj4gwqDCoMKg
IEl0J3MgcG9zc2libGUgdG8gY29uZmlndXJlIFJUTCBzdWNoIHRoYXQgRFdDX1VTQjNfTlVNX0VQ
UyBpcyBlcXVhbCB0bw0KPj4gwqDCoMKgIERXQ19VU0IzX05VTV9JTl9FUFMuDQo+Pg0KPj4gwqDC
oMKgIGR3YzMtY29yZSBjYWxjdWxhdGVzIHRoZSBudW1iZXIgb2YgT1VUIGVuZHBvaW50cyBhcyBE
V0NfVVNCM19OVU0gbWludXMNCj4+IMKgwqDCoCBEV0NfVVNCM19OVU1fSU5fRVBTLiBJZiBSVEwg
aGFzIGJlZW4gY29uZmlndXJlZCB3aXRoIERXQ19VU0IzX05VTV9JTl9FUFMNCj4+IMKgwqDCoCBl
cXVhbCB0byBEV0NfVVNCM19OVU0gdGhlbiBkd2MzLWNvcmUgd2lsbCBjYWxjdWxhdGUgdGhlIG51
bWJlciBvZiBPVVQNCj4+IMKgwqDCoCBlbmRwb2ludHMgYXMgemVyby4NCj4+DQo+PiDCoMKgwqAg
Rm9yIGV4YW1wbGUgYSBmcm9tIGR3YzNfY29yZV9udW1fZXBzKCkgc2hvd3M6DQo+PiDCoMKgwqAg
W8KgwqDCoCAxLjU2NTAwMF3CoCAvdXNiMEBmMDFkMDAwMDogZm91bmQgOCBJTiBhbmQgMCBPVVQg
ZW5kcG9pbnRzDQo+PiAiDQo+Pg0KPj4gSGUganVzdCBzdGF0ZWQgdGhhdCB5b3UgY2FuIGNvbmZp
Z3VyZSB0byBoYXZlIG51bV9lcHMgZXF1YWxzIHRvDQo+PiBudW1faW5fZXBzLiBCYXNpY2FsbHkg
aXQgbWVhbnMgdGhlcmUncyBubyBPVVQgcGh5c2ljYWwgZW5kcG9pbnQuIE5vdA0KPiBubywgdGhh
dCdzIG5vdCB3aGF0IGl0IG1lYW5zLiBJIGRvbid0IGhhdmUgYWNjZXNzIHRvIERXQzMgZG9jdW1l
bnRhdGlvbg0KPiBhbnltb3JlLCBidXQgZnJvbSB3aGF0IEkgcmVtZW1iZXIgZXZlcnkgcGh5c2lj
YWwgZW5kcG9pbnQgX2Nhbl8gYmUNCj4gY29uZmlndXJlZCBhcyBiaWRpcmVjdGlvbmFsLiBJbiBv
dGhlciB3b3JkcywgRFdDM19VU0IzX05VTV9FUFMgPT0NCj4gRFdDM19VU0IzX05VTV9JTl9FUFMg
Y291bGQgbWVhbiB0aGF0IGV2ZXJ5IGVuZHBvaW50IGluIHRoZSBzeXN0ZW0gaXMNCj4gYmlkaXJl
Y3Rpb25hbC4NCj4NCj4+IHN1cmUgd2h5IHlvdSB3b3VsZCBldmVyIHdhbnQgdG8gZG8gdGhhdCBi
ZWNhdXNlIHRoYXQgd2lsbCBwcmV2ZW50IGFueQ0KPj4gZGV2aWNlIGZyb20gd29ya2luZy4gVGhl
IHJlYXNvbiB3ZSBoYXZlIERXQ19VU0IzeF9OVU1fSU5fRVBTIGFuZA0KPj4gRFdDX1VTQjN4X05V
TV9FUFMgZXhwb3NlZCBpbiB0aGUgZ2xvYmFsIEhXIHBhcmFtIHNvIHRoYXQgdGhlIGRyaXZlciBr
bm93DQo+PiBob3cgbWFueSBlbmRwb2ludHMgYXJlIGF2YWlsYWJsZSBmb3IgZWFjaCBkaXJlY3Rp
b24uIElmIGZvciBzb21lIHJlYXNvbg0KPj4gdGhpcyBtZWNoYW5pc20gZmFpbHMsIHRoZXJlJ3Mg
c29tZXRoaW5nIGZ1bmRhbWVudGFsbHkgd3JvbmcgaW4gdGhlIEhXDQo+PiBjb25maWd1cmF0aW9u
LiBXZSBoYXZlIG5vdCBzZWVuIHRoaXMgcHJvYmxlbSwgYW5kIEkgZG9uJ3QgdGhpbmsgQnJ5YW4N
Cj4+IGRpZCBmcm9tIGhpcyBjb21taXQgc3RhdGVtZW50IGVpdGhlci4NCj4gUGxlYXNlIGNvbmZp
cm0gdGhpcyBpbnRlcm5hbGx5LiBUaGF0IHdhcyBteSBvcmlnaW5hbCBhc3N1bXB0aW9uIHRvbywN
Cj4gdW50aWwgQnJ5YW4gcG9pbnRlZCBtZSB0byBhIHBhcnRpY3VsYXIgc2VjdGlvbiBvZiB0aGUN
Cj4gc3BlY2lmaWNhdGlvbi4gVW5mb3J0dW5hdGVseSBpdCdzIGZhciB0b28gbG9uZyBhZ28gYW5k
IEkgY2FuJ3QgZXZlbg0KPiB2ZXJpZnkgZG9jdW1lbnRhdGlvbiA6LSkNCj4NCj4+PiBIb3cgaGF2
ZSB5b3UgdmVyaWZpZWQgdGhpcyBwYXRjaD8gRGlkIHlvdSByZWFkIEJyeWFuJ3MgY29tbWl0IGxv
Zz8gVGhpcw0KPj4+IGlzIGxpa2VseSB0byByZWludHJvZHVjZSB0aGUgcHJvYmxlbSByYWlzZWQg
YnkgQnJ5YW4uDQo+Pj4NCj4+IFdlIHZlcmlmaWVkIHdpdGggb3VyIEZQR0EgSEFQUyB3aXRoIHZh
cmlvdXMgbnVtYmVyIG9mIGVuZHBvaW50cy4gTm8NCj4+IGlzc3VlIGlzIHNlZW4uDQo+IFRoYXQn
cyBjb29sLiBDb3VsZCB5b3UgcGxlYXNlIG1ha2Ugc3VyZSBvdXIgdW5kZXJzdGFuZGluZyBvZiB0
aGlzIGlzDQo+IHNvdW5kIGFuZCB3b24ndCBpbnRlcmZlcmUgd2l0aCBhbnkgZGVzaWducz8gSWYg
d2UgbW9kaWZ5IHRoaXMgcGFydCBvZg0KPiB0aGUgY29kZSBhZ2FpbiwgSSdkIGxpa2UgdG8gc2Vl
IGEgY2xlYXIgcmVmZXJlbmNlIHRvIGEgc3BlY2lmaWMgc2VjdGlvbg0KPiBvZiB0aGUgZGF0YWJv
b2sgZGV0YWlsaW5nIHRoZSBleHBlY3RlZCBiZWhhdmlvciA6LSkNCj4NCj4gY2hlZXJzDQo+DQoN
CkhtLi4uIEkgZGlkbid0IGNvbnNpZGVyIGJpZGlyZWN0aW9uIGVuZHBvaW50IG90aGVyIHRoYW4g
Y29udHJvbCBlbmRwb2ludC4NCg0KRFdDM19VU0IzeF9OVU1fRVBTIHNwZWNpZmllcyB0aGUgbnVt
YmVyIG9mIGRldmljZSBtb2RlIGZvciBzaW5nbGUNCmRpcmVjdGlvbmFsIGVuZHBvaW50cy4gQSBi
aWRpcmVjdGlvbmFsIGVuZHBvaW50IG5lZWRzIDIgc2luZ2xlDQpkaXJlY3Rpb25hbCBlbmRwb2lu
dHMsIDEgSU4gYW5kIDEgT1VULiBTbywgaWYgeW91ciBzZXR1cCB1c2VzIDMNCmJpZGlyZWN0aW9u
IGVuZHBvaW50cyBhbmQgb25seSB0aG9zZSwgRFdDM19VU0IzeF9OVU1fRVBTIHNob3VsZCBiZSA2
Lg0KRFdDM19VU0IzeF9OVU1fSU5fRVBTIHNwZWNpZmllcyB0aGUgbWF4aW11bSBudW1iZXIgb2Yg
SU4gZW5kcG9pbnQgYWN0aXZlDQphdCBhbnkgdGltZS4NCg0KSG93ZXZlciwgSSB3aWxsIGhhdmUg
dG8gZG91YmxlIGNoZWNrIGFuZCBjb25maXJtIGludGVybmFsbHkgcmVnYXJkaW5nDQpob3cgdG8g
ZGV0ZXJtaW5lIG1hbnkgZW5kcG9pbnQgd291bGQgYmUgYXZhaWxhYmxlIGlmIGJpZGlyZWN0aW9u
DQplbmRwb2ludHMgY29tZSBpbnRvIHBsYXkuDQoNClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBv
dXQuIFdpbGwgZ2V0IGJhY2sgb24gdGhpcy4NCg0KVGhpbmgNCg0KDQo=
