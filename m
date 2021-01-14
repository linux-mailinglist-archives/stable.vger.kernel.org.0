Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA232F5895
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbhANCmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 21:42:24 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54326 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbhANCmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 21:42:22 -0500
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 19A06C00E8;
        Thu, 14 Jan 2021 02:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1610592081; bh=ICJVbqpe9vGpVg5Ux5AWlsdlEg28V+12xMtTLRRuFrs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=eEN406TPAZHRdmdjV2eDAcKYpvziU6YUIAhDcZCdP9g0UHCxgcDM34N2d4U/Xiviz
         BS2o6HomrQ/IVlvVL5J9Y0KggOmwHfI0o/tAv/j2OfqeZbnInFHv8hvLlwvLHALJpQ
         PbUaJrExp1VSRPZIGSWEL6WRJMLuMpN1OVC1gvZBV5vZmhmdnFBaMrMoirtVhgMm1e
         PUEtJ6a5/1BLxozjjk201xk8RXSo7pPM4xSi14dtPA1eqHEJzQe9YouxZsGwtm0R4j
         ZpW8Bvc/h40ZPnUSZunXPQKgyb16CtxiPQSLAXWj/28cbZb9pLRr//mKz9ToteufLt
         AHTu9EMnnTm2Q==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7EB8DA007F;
        Thu, 14 Jan 2021 02:41:16 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id AE2CF40152;
        Thu, 14 Jan 2021 02:41:14 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kSro34Ed";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioahMCUqGoenD1/feDZL0Gk8IkNozoUtK+ollUPa3eED6lHJyJBvkAvsY78ePiK0D5vtoxwrDHkD+dP2UfL6K8WxjI1iyE++EpO0qs6Bv6sAKTvEcARL06owtJ8c2RaML/TzoOfltA54YRzxy2Dp/5oL3fGa4UXuMH4QWOuu8P22W9/yONUQSO8476NR1JEEiIT8vtyEW3c8XzZ5Vje8deM/CKG0+H4WhhK1RPfcreHx7zMQ04cB4U7HB3m9dwtpQoy8q+CXyHgn0PzAa5NdmNaWQuaNT47fjN1jCEbFOYkGKw9/F0l/InaeVHuOa56ftfLZ3a7XEGN7rlOh5AeKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICJVbqpe9vGpVg5Ux5AWlsdlEg28V+12xMtTLRRuFrs=;
 b=KUAiOrNrhWON/2MM3XnDc8jgBcSUYBi8A9lLcEALofP5DUDr1ZE34FzWliAA+cMtz8V8q6eY7IArt0859idzT7e8XbCeXAbD4iyixAzqu+vgIHgqsA6mUe60u1BtygVOq9oFAmfCXGj08xWRYF+No+t/qxIcgcvRB6lhRtqOR1T1aFtlp+E4jzlZTX++3HFqNH7Wa09/kfvsm88g4EW5n1gc8TIGi07NbJi3qWEdTsKonfbwHlDzsLwA0IJ3YNK3fpd4X/PIf9A/YtsyJBWBZecCBmJSIgbcrk2OQQv2BUrS95ZiafMHsmXu8kYNVCYFF3Xl0BUqD5335QIxxRWboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICJVbqpe9vGpVg5Ux5AWlsdlEg28V+12xMtTLRRuFrs=;
 b=kSro34Edr/Eaa6cWTToAqxyFQ0IxEf48I/tyy+HqKZFALHHrlfH2OzAIlgC+fPZAlTNodhVluZcsBxTajsV53Wu+B1+jqehAWwJ9yleqsLSKLy+ITYl2qwzgyNsY1AA4LVqSHb5QcodRY8UTI+nkaWUCrmmTY/Ro88dSOr5Kf5Q=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4242.namprd12.prod.outlook.com (2603:10b6:a03:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 02:41:12 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 02:41:12 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Topic: [PATCH] usb: udc: core: Use lock for soft_connect
Thread-Index: AQHW6TqPA5FX8bEPGkiCDn1hzxU8g6olNAsAgAE274A=
Date:   Thu, 14 Jan 2021 02:41:12 +0000
Message-ID: <e8801d4f-32aa-7ed3-292e-365732eafa85@synopsys.com>
References: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
 <X/6qctJ6eVcPHO/m@lx-t490>
In-Reply-To: <X/6qctJ6eVcPHO/m@lx-t490>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c729c4d7-a916-4bba-f9d6-08d8b835db4d
x-ms-traffictypediagnostic: BY5PR12MB4242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4242D67DB4A391F8D0B32995AAA80@BY5PR12MB4242.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aW2/idVtWMMcmQ72c3rH7r2TZ+2BqlFnsQR08aWLylnf0lqu5cKrlBuwpwdB+kO/KMNGb6sxCtrCaLhYMgYiZ3B/2LR6DatPLBjO9nRd1HlamuFwyjshlmzOzP4uPihTCoKNgSDE96dIaIxrrYLL4P7uNGJbiEuLCx+f2FaVldcE0TBdAM/bLjlmOBGhHVr5jOVNx+x0xYkK0L2qw6SSbCLCi8iMYG7P2Tj/yOJcrewhLwOc0zZqFvBx/y+P/SUGnDCfrn9KEPfmniud1CuHc3wvZM+q2bnS17p+y91dxoKstMvcBkznaPJYda+Jy5lRlrg0mtePmFpbeP5nfDQDc2QY92EQJPF1CNLZnsJEZo2GlXn4tsPTda4RqmnYKlbely+TIvEyWWf1ReNSF1uZHwCDQzcUedb1yBVUBDcC0xd981HQQH78j7fjaDmqtUwUqZfVWd2U7WEU5vNthQjhyX5uMHMl8onpBPH/GbVBBM4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39860400002)(346002)(136003)(6486002)(316002)(6512007)(110136005)(8936002)(8676002)(7416002)(186003)(478600001)(66446008)(66556008)(83380400001)(76116006)(4326008)(6506007)(31686004)(5660300002)(4744005)(86362001)(31696002)(36756003)(71200400001)(66476007)(54906003)(2616005)(26005)(64756008)(66946007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eDVEakhHNHZRYmhyVjR1LzhwdTJ2ZkhjcjMxUHM1MnhCdGRQZmp3dzcvbDNN?=
 =?utf-8?B?ZGJsRlBPMWFZVEdIdWdGZDZkRkxPQjlLaG9UMTZ0RWlVajlFazBxZUE4ZlVZ?=
 =?utf-8?B?WTM0Rk81djNiYk50blp0S25LbVpNYWdFT20rTHFOR1c3Y0FydVhOWjVGQUhJ?=
 =?utf-8?B?OE9zREdVUVNTcDJNcmlpZ090WE40MnNCMDNSNmErS056c0Z5YW1NUVVBeVhX?=
 =?utf-8?B?S2V1L1hPaEU0WWp6dmkyUit2ZkVWMTBuSDhWR0trSTMyU2JIcXlKdCswRElW?=
 =?utf-8?B?WTNIdzcwV1RlQjl5YTd1NGNQZzNQT283YzJXRzFDekZwSGk3MllLbWpNcFNm?=
 =?utf-8?B?SmlSdC9oWktLK0Z0SDV5N3U4V2tVMGFQdG9wcndiM2ZUdnpaOVYrMTR2T3RD?=
 =?utf-8?B?RmY5RUEveXdsRThoYVJERzJMZ1lWdlhuRFBYTExhUXk5M1UxUlo4Y3RlMkJk?=
 =?utf-8?B?MzFINDZJL1hDaEhYdjdINnVMdkUrT0hzNXdHRVFtMlhLdnVNNGRWb2lBUjg3?=
 =?utf-8?B?NTRhSFRYTzhNSDRRZGczK0EwdXVLN2t0WEhWeHRoNis5K3FSL0dTWHMrNit3?=
 =?utf-8?B?dUM0ZHFSREtkc3NMRzIvdlRMOXIySlFidFJRSCtGdFpvYmdyaExLTk9rUndD?=
 =?utf-8?B?MkRVandGNFdqKzUrbHJ3Vm1PSmx4cFVYRm01OVB1RWhlN041L2VLcmhQck05?=
 =?utf-8?B?eVpSVmJyaWlHMngyNmxwUVBZV2hDVTU0NzhNRWUxY1RNY3pwazdMSnVxZHUv?=
 =?utf-8?B?dTNFalRkMTcxa2NGajFzNE5uWmU0Qk1GNGVhOVB6Vk9QMFBBNEJQMmRSWjJp?=
 =?utf-8?B?UmVCSkFqY1NWLzRYbkwxUkEwcmljMmkwSG1jUUloaWNMMmhFYm1tdTJuVTg5?=
 =?utf-8?B?aUUxYVNEVzFJeWJvS1NFdDBNNHMvU3RBZ0ZHT3ZLMG5VTS8wTFM2czBxaXF2?=
 =?utf-8?B?Q1ljRVc3UGJqNmVDSkZYU3pTZ3Ayb2dGNTMzTlE2cHBBbExoNGdkdWowMHZY?=
 =?utf-8?B?ejBib21lVUNydXN2U25JRkxnNk5DTkZNWFFVSjNMNTFWamlLSEdvem4wa1J5?=
 =?utf-8?B?eDh3MzlNSGxQQzJrajlpQ1A2b1Z3MHE2K3dOcDFUZG92eDFIREIwWk5keHYr?=
 =?utf-8?B?ajJNc283M2Z0ekVsNFBabWNkZXdrc3BXY2Y4TSt3Y2M4QW1WMkk5ZHNqMUFO?=
 =?utf-8?B?YWl4NEczeXQ1blZmVWdRZFltRnRjY3NZQUJvanRlVGxicUEwRStTLzdqOTFl?=
 =?utf-8?B?cnRCSlNJUllvd2E1QVhvOEFpOEZOZHFDTC8vai9EaHgxdWt3ejZydFludVIz?=
 =?utf-8?Q?WpgvWLrOCui7I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31F04386956602409D0C66E377775ED8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c729c4d7-a916-4bba-f9d6-08d8b835db4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 02:41:12.4043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDsdza9ropknPwB3+OBZ9JArud2+yt87cqUx88QA2yF7/eyWh7fmAFq9gHeNfgG0JaLYd8r4Ki2oAlu7oMYkUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4242
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWhtZWQgUy4gRGFyd2lzaCB3cm90ZToNCj4gT24gVHVlLCBKYW4gMTIsIDIwMjEgYXQgMDM6MjY6
MjFQTSAtMDgwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPiAuLi4NCj4+ICsJbXV0ZXhfbG9jaygm
dWRjX2xvY2spOw0KPj4gIAlpZiAoIXVkYy0+ZHJpdmVyKSB7DQo+PiArCQltdXRleF91bmxvY2so
JnVkY19sb2NrKTsNCj4+ICAJCWRldl9lcnIoZGV2LCAic29mdC1jb25uZWN0IHdpdGhvdXQgYSBn
YWRnZXQgZHJpdmVyXG4iKTsNCj4+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4+ICAJfQ0KPj4g
QEAgLTE1NDIsMTAgKzE1NDQsMTIgQEAgc3RhdGljIHNzaXplX3Qgc29mdF9jb25uZWN0X3N0b3Jl
KHN0cnVjdCBkZXZpY2UgKmRldiwNCj4+ICAJCXVzYl9nYWRnZXRfZGlzY29ubmVjdCh1ZGMtPmdh
ZGdldCk7DQo+PiAgCQl1c2JfZ2FkZ2V0X3VkY19zdG9wKHVkYyk7DQo+PiAgCX0gZWxzZSB7DQo+
PiArCQltdXRleF91bmxvY2soJnVkY19sb2NrKTsNCj4+ICAJCWRldl9lcnIoZGV2LCAidW5zdXBw
b3J0ZWQgY29tbWFuZCAnJXMnXG4iLCBidWYpOw0KPj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+PiAg
CX0NCj4+DQo+PiArCW11dGV4X3VubG9jaygmdWRjX2xvY2spOw0KPj4gIAlyZXR1cm4gbjsNCj4+
ICB9DQo+IFBsZWFzZSB1c2UgImdvdG8gb3V0IiBpbnN0ZWFkIG9mIHJlcGVhdGluZyB0aGUgbXV0
ZXggdW5sb2NrIGxpbmUgdGhyZWUNCj4gdGltZXMuDQo+DQo+IFRoYW5rcywNCj4NCj4gLS0NCj4g
QWhtZWQgUy4gRGFyd2lzaA0KPiBMaW51dHJvbml4IEdtYkgNCg0KU3VyZS4gV2UgY2FuIGRvIHRo
YXQuDQoNClRoYW5rcywNClRoaW5oDQo=
