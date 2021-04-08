Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A223357EEF
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 11:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHJSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 05:18:17 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35170 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhDHJSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 05:18:16 -0400
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8A27BC09B1;
        Thu,  8 Apr 2021 09:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617873484; bh=zmXebjFZk4A7AC1iWMElYXYAkUNbIC1hh8hFCkmMURE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=FNIqW4ZIBICqylRbVQA70BACDc7z4439seqH+i2bgwmQ/RlhTVgIcSUCVURSL8OUP
         /XXZD7cEQkT4ISl6k3w3+994dgXxDyuknz1aLMuYeXIFhRxw2nje8bxbslNBWGFcnR
         Oh9fIYqRgBSITkpVXEsEWNN5pAyzC2YlXNJl7wMkzw/xXssHVkicakfVtbiqeTAytV
         0Q94ukdsPMZDezTYkDgm4OoXguQNwTgiOrxXTjkmmlqvE99IRCKxP318LBj1pIl0rl
         SqT8E5m6aNutcGCySjEPsVoKPgsFvhq80nEAgE3fEhaX6G6Lax2vdR1c8+XDgrFKCI
         ztQe5yCckqRcQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2E515A0077;
        Thu,  8 Apr 2021 09:18:01 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 05A21400C0;
        Thu,  8 Apr 2021 09:18:01 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=arturp@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ch58UAvu";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLjDh9bD9m+TvvnUJIfiNVWvZkKsroUo7RCS1VGdN8I9rHKPqEkIkeUlFiIQSL5TDSlbVV3dim76RNTvdPTEMDvrLczvC1hbaLuMNqdhuPdtA5jcfatsLqGvi4SNtztFwlwL79xsu7K4EAifhHvf6zce9qq3Lonws3Jx0HRHf68OKobYZIH0XI7TbMIxwTrRgyTk8BhtMAPdMeaSviMrT3FO/vQawKaxX8zQhhCXadkJfds/cSDYk6z7Nb3dmSE1uqiF4zZ0WlSH8z+hZ+IlktqOakri772fm4NkryWcuyz0ZecTKO2bdXbe0295XVPz4AQehWpb1LYtPyUdk34fuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmXebjFZk4A7AC1iWMElYXYAkUNbIC1hh8hFCkmMURE=;
 b=ZzP7vrO8g7kMVLd0vjLthNvQAXn0Y9sG2tisTpLoDKTgyjA2Jla8xnRR8ZdvUo7xf/UNiwDLtzRgcx4rx/0C52+iJdRJJ366cZ6my6dKgBQtvJ1KyhPCgKeKBiRFiC9flAPuhyg6asE4HHbIryOktZucQYU/DhINQZaI7AjGbDu6+7WTtgIacLkZfPvsLwkXt57ZsaL/dN95LvsE8QCPjNm+CxcuOe7n16U/Nwxi0xhxKC9Zk/khSnk+YlxHJ+6eQahVIMLg0KEpKeu4xB9UikMgm/Cw+xVUEDILWxd/Alkod3MWSRqFC49/FptoNpGisO1vmGZT4PGj+henpi17+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmXebjFZk4A7AC1iWMElYXYAkUNbIC1hh8hFCkmMURE=;
 b=ch58UAvuVlx/r05t7Q4PLGM/GDl6ppbuCc0XYUGXv06hHOjhdeBSDlAgExgAEpEBf9DwgWPWiHbNcZmyL/A5621Qs9oO1HXsYxvjWqQtLxkZdqSLTlzFXl5eCahXrKekjorFweFbX3M9Ky9LLhwAAWFYa6EHHnxd2UEAk9jZh1s=
Received: from CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22)
 by CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 09:17:59 +0000
Received: from CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c]) by CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c%7]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 09:17:59 +0000
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>,
        Douglas Anderson <dianders@chromium.org>
CC:     Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Topic: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Index: AQHXLEjGTAAr4ldgzUSBIe37KXOig6qqV46A
Date:   Thu, 8 Apr 2021 09:17:58 +0000
Message-ID: <3625b740-b362-5ec6-8fba-cd7babcab35b@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
 <20210408072825.61347A022E@mailhost.synopsys.com>
In-Reply-To: <20210408072825.61347A022E@mailhost.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c202acdc-7d2e-42fc-eaa2-08d8fa6f33c8
x-ms-traffictypediagnostic: CH0PR12MB5268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR12MB526850BB640E1065CFD07ECEA7749@CH0PR12MB5268.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E8TfCZB52n6eJlJCoMqS6SY5izg7TlzVyrMui8MaXl1abIfr1IPSNQUafFKtS/kKILA3CmpNAf1e4SzH7Jar+OT+0O0SnlP8Vz8gVFL78IR9+6sAL1xpO7chwSqzbnPzG5b8dUTymbrFnHFIX5NGVO0zx6GA1nZlWgg0MdSlVCxrXzBEgPdXx2MZmzPl1BpmFJhIVYxsk0gDqGhXtgP6sQ19pVpPIgQFLTFuv3YfzKkQ80STXTSOdIC29dJpW0hd2dvfjYVuXVwXX/P4UFa5jI5Ky9G/qkFVHB8rF1EkAMV5IUADzmTUaR7YK1jLAXubfP/SDX3TsicAuZc2yaX0T9VVzk/bVntxyU0slIYTt0EYe/m+mQxffb1e27pwP8w8+VVDlP5bKh6zw9pQUEE5RDq6LEH4px7E9Mpf3AvqRA7OSrAD/QLiS+SzCIGozXfk1p/GI+bbGD/CZLQ40MZKOIx9DKrEkVEGRF2jglWq10h1QgsPwW94wcMS/dEPA+9JpC7UoKJO3uqxVcvCmJ+6QHTBz1lL30VIGI24uuxR9ObGMz24djPSZFEzm57h8DoGoxXK24BadeFodSU8F+1bFRQzwhGH6YcsAa4lFDZIgqzh8USJHmqL29mQ2OhTc8ylXPkGyAiE0jU3GhzUOWzY613Z1OiEbv4CO2p4ERj8RdgCXghdmNUKGyxbL7r97TevLUk3GhYwPW/QY8DkLndHpxYRjxzQnm/KJ++y9RLbOwnMFYe+uOZ+TjDrHhkrO5+j94vkGC/DiI/hPar/3dekq6SIz9S1InHW1mLHkmmCm8A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(36756003)(2906002)(8676002)(38100700001)(7416002)(71200400001)(186003)(5660300002)(966005)(6486002)(54906003)(66556008)(66946007)(31686004)(64756008)(53546011)(91956017)(76116006)(4326008)(66476007)(478600001)(110136005)(6512007)(8936002)(316002)(26005)(6506007)(2616005)(83380400001)(86362001)(66446008)(31696002)(45980500001)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K2FCd044dE1tUWZocWQrUTZuR2VLR3FEdDU4N1ZMcmpVdUQ1RldiNDJqUWJJ?=
 =?utf-8?B?TUN5aEJDUXBmR083emtiOGN6WkYwWEpYWWw3UjFIek5lUTlCanlxV1Z1VmY0?=
 =?utf-8?B?MHZ2ejB6UWRzZm1qNkJRWG40azFIaTdRY3NEZThHYzlpOXdjeHAydDdmSWpL?=
 =?utf-8?B?b2NubGg3amNPZExRQVZnMjVJdWEySVhSa21xNkk3MnNGMkdpQU5yMG1OY05x?=
 =?utf-8?B?Y29TTGJKOFRHL0lPSHd4OWNZYU9OTHhWeUtXY21VaUhkelpzN251QTVGc0I3?=
 =?utf-8?B?U091K0dtSE8zN3JTZE5rTlQrNHQ4TUt1WFNublVkYlZycDJzQ1Z5dGN4eUVV?=
 =?utf-8?B?QzVlTXY1QVZIYW93MHIxcHdNM3BwdzJ1dXdORzBKREpkVG1TQjNac2ovNklV?=
 =?utf-8?B?N09wL3R1alVPU1JUTTV5LzF5OWFKVUpKNENpdlBMRG9BQlREZENKT2VhUkNv?=
 =?utf-8?B?QVRRcWZ4WEYrRVpSNVlvbEE5YlQ5TFIva1NkWDFnU2pYNEZodVJoS2Uvekcz?=
 =?utf-8?B?UnFXOXdqUFIvNUMwdjlUdmExbFhLVUVoUXl0S2NCa1g3YWRKOWFYR3l0cTBt?=
 =?utf-8?B?T2w1LzYrUHl4bzZiamxVZDBlSStVUUNPQVV5d2FCeTZLbDJBZXZlQ0NFb29I?=
 =?utf-8?B?OTlZUGtOclByeFRRUTNFZnV2bU9nYWhNa2FTUDhid3JSS1R6WGl2dlZZRWdQ?=
 =?utf-8?B?RlJGQlE1dElRcDBlUWdZR0hYdHZZTkpBaE9kUVBtQUNNM0hLNUovQ2E5NTA1?=
 =?utf-8?B?VWZ6Z0wwWVRQdG9wZGlwMU1GWGluTDNJVmNab1FYeVRRbVFUQUFpU3VSaUJn?=
 =?utf-8?B?SFlSdmQvVmdjdEJJRnIvU1g0dlFyazJ6aHFBRWkvSDdpcjkzekFDWEo1SDJW?=
 =?utf-8?B?WGhsV0hBMThPMTF1dkcydEJyaStqcmdkZ2hlZTc2N1huYy8zdjZYQXBIem5M?=
 =?utf-8?B?Sk1tR05NYnNINFNqOWpmdGVEZHZGSFJTZnljSnFDU0VEVEVxOGo3bUJ3M01S?=
 =?utf-8?B?YzZpb2ZqTlhZczRZOW9qTlpIR2hJOTZ0eVN0TGtqc2dQSUx1cXovbEh2Wkhk?=
 =?utf-8?B?cWhhMTFVTFJ5Z2k5RHF3Z3hTNWtIVEdINkMxVkMvS2wwOXRSZ0ozNVZNOWcw?=
 =?utf-8?B?NFNHKzJzNXJLcml6eWxFNERheDdtaXdmZE1hUE1tdVBPTGlTVTdqSDJ5WW13?=
 =?utf-8?B?UEpPSjFYNThtZ1R5VFBzdFQvZHVnNERJdWtyZENFaEljNHQzT3JxR0RYNWRj?=
 =?utf-8?B?Y2RXaTRVeXFIck52RFNlL0czUFExb3B0R1ZzN0s0VUZTdDN0REJwaUZ1Wkxs?=
 =?utf-8?B?RnlNNC9xU014RC9Yd29lZS94Z3E3YzVTQ2RNeDlzdTc2S01CS1ZZSEd3RGhD?=
 =?utf-8?B?VkNFZkUyQ2FXdjdESXVCVzBOZXdlN3h2OHZPTkdrRmdDbDBOVXhkUEk5WUZk?=
 =?utf-8?B?cUpWb3cveTJtUUo1MTQwNHB1ZVFnWkJkSUFVdjFkUkRNbXhXaTRscWh3SUJN?=
 =?utf-8?B?bzFkVGFoYzNTWk1MUndyUEhqTTVIM0EzTkpZWmRSUG9yQW9sdGk5RVRSVHJL?=
 =?utf-8?B?SEhvMGdNQ3ljZ1BCQmswd2lPSkpYUHBxbGJnMFQ3Q2M1SjRCTzNRaU43L090?=
 =?utf-8?B?N2xLUUxZcFFBZE5SeUUxdU13OW9BTXRiVUZuZlVvNTArT2YwTXZnQXloaW4y?=
 =?utf-8?B?dkVITWZza0h2YlVTdWhOTTVsVHNLMTNSSlZTQ1lhUHVZSm1qOUNNV2JtWFhT?=
 =?utf-8?Q?bgUuDaJMn5bdMbIkiJbysp0Lc9rtYBY32no/Kne?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EF4E581C4710D4D8D6FCC124F3F84F3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c202acdc-7d2e-42fc-eaa2-08d8fa6f33c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 09:17:58.8142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lVMUl+BwZH3ZOv443fJlO51KMT3oaI9i4QMYtZu8XUwXDwgQj95zmm0yrSUH13HAYa6AX/DTaPCuDDH2yQxmLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KT24gNC84LzIwMjEgMTE6MjgsIEFydHVyIFBldHJvc3lhbiB3cm90ZToNCj4g
VGhpcyBwYXRjaCBzZXQgZml4ZXMgYW5kIGltcHJvdmVzIHRoZSBQYXJ0aWFsIFBvd2VyIERvd24g
bW9kZSBmb3INCj4gZHdjMiBjb3JlLg0KPiBJdCBhZGRzIHN1cHBvcnQgZm9yIHRoZSBmb2xsb3dp
bmcgY2FzZXMNCj4gICAgICAxLiBFbnRlcmluZyBhbmQgZXhpdGluZyBwYXJ0aWFsIHBvd2VyIGRv
d24gd2hlbiBhIHBvcnQgaXMNCj4gICAgICAgICBzdXNwZW5kZWQsIHJlc3VtZWQsIHBvcnQgcmVz
ZXQgaXMgYXNzZXJ0ZWQuDQo+ICAgICAgMi4gRXhpdGluZyB0aGUgcGFydGlhbCBwb3dlciBkb3du
IG1vZGUgYmVmb3JlIHJlbW92aW5nIGRyaXZlci4NCj4gICAgICAzLiBFeGl0aW5nIHBhcnRpYWwg
cG93ZXIgZG93biBpbiB3YWtldXAgZGV0ZWN0ZWQgaW50ZXJydXB0IGhhbmRsZXIuDQo+ICAgICAg
NC4gRXhpdGluZyBmcm9tIHBhcnRpYWwgcG93ZXIgZG93biBtb2RlIHdoZW4gY29ubmVjdG9yIElE
Lg0KPiAgICAgICAgIHN0YXR1cyBjaGFuZ2VzIHRvICJjb25uSWQgQg0KPiANCj4gSXQgdXBkYXRl
cyBhbmQgZml4ZXMgdGhlIGltcGxlbWVudGF0aW9uIG9mIGR3YzIgZW50ZXJpbmcgYW5kDQo+IGV4
aXRpbmcgcGFydGlhbCBwb3dlciBkb3duIG1vZGUgd2hlbiB0aGUgc3lzdGVtIChQQykgaXMgc3Vz
cGVuZGVkLg0KPiANCj4gVGhlIHBhdGNoIHNldCBhbHNvIGltcHJvdmVzIHRoZSBpbXBsZW1lbnRh
dGlvbiBvZiBmdW5jdGlvbiBoYW5kbGVycw0KPiBmb3IgZW50ZXJpbmcgYW5kIGV4aXRpbmcgaG9z
dCBvciBkZXZpY2UgcGFydGlhbCBwb3dlciBkb3duLg0KPiANCj4gTk9URTogVGhpcyBpcyB0aGUg
c2Vjb25kIHBhdGNoIHNldCBpbiB0aGUgcG93ZXIgc2F2aW5nIG1vZGUgZml4ZXMNCj4gc2VyaWVz
Lg0KPiBUaGlzIHBhdGNoIHNldCBpcyBwYXJ0IG9mIG11bHRpcGxlIHNlcmllcyBhbmQgaXMgY29u
dGludWF0aW9uDQo+IG9mIHRoZSAidXNiOiBkd2MyOiBGaXggYW5kIGltcHJvdmUgcG93ZXIgc2F2
aW5nIG1vZGVzIiBwYXRjaCBzZXQuDQo+IChQYXRjaCBzZXQgbGluazogaHR0cHM6Ly9tYXJjLmlu
Zm8vP2w9bGludXgtdXNiJm09MTYwMzc5NjIyNDAzOTc1Jnc9MikuDQo+IFRoZSBwYXRjaGVzIHRo
YXQgd2VyZSBpbmNsdWRlZCBpbiB0aGUgInVzYjogZHdjMjoNCj4gRml4IGFuZCBpbXByb3ZlIHBv
d2VyIHNhdmluZyBtb2RlcyIgd2hpY2ggd2FzIHN1Ym1pdHRlZA0KPiBlYXJsaWVyIHdhcyB0b28g
bGFyZ2UgYW5kIG5lZWRlZCB0byBiZSBzcGxpdCB1cCBpbnRvDQo+IHNtYWxsZXIgcGF0Y2ggc2V0
cy4NCj4gDQo+IENoYW5nZXMgc2luY2UgVjE6DQo+IE5vIGNoYW5nZXMgaW4gdGhlIHBhdGNoZXMg
b3IgdGhlIHNvdXJjZSBjb2RlLg0KPiBTZW5kaW5nIHRoZSBzZWNvbmQgdmVyc2lvbiBvZiB0aGUg
cGF0Y2ggc2V0IGJlY2F1c2UgdGhlIGZpcnN0IHZlcnNpb24NCj4gd2FzIG5vdCByZWNlaXZlZCBi
eSB2Z2VyLmtlcm5lbC5vcmcuDQo+IA0KPiANCj4gDQo+IEFydHVyIFBldHJvc3lhbiAoMTQpOg0K
PiAgICB1c2I6IGR3YzI6IEFkZCBkZXZpY2UgcGFydGlhbCBwb3dlciBkb3duIGZ1bmN0aW9ucw0K
PiAgICB1c2I6IGR3YzI6IEFkZCBob3N0IHBhcnRpYWwgcG93ZXIgZG93biBmdW5jdGlvbnMNCj4g
ICAgdXNiOiBkd2MyOiBVcGRhdGUgZW50ZXIgYW5kIGV4aXQgcGFydGlhbCBwb3dlciBkb3duIGZ1
bmN0aW9ucw0KPiAgICB1c2I6IGR3YzI6IEFkZCBwYXJ0aWFsIHBvd2VyIGRvd24gZXhpdCBmbG93
IGluIHdha2V1cCBpbnRyLg0KPiAgICB1c2I6IGR3YzI6IFVwZGF0ZSBwb3J0IHN1c3BlbmQvcmVz
dW1lIGZ1bmN0aW9uIGRlZmluaXRpb25zLg0KPiAgICB1c2I6IGR3YzI6IEFkZCBlbnRlciBwYXJ0
aWFsIHBvd2VyIGRvd24gd2hlbiBwb3J0IGlzIHN1c3BlbmRlZA0KPiAgICB1c2I6IGR3YzI6IEFk
ZCBleGl0IHBhcnRpYWwgcG93ZXIgZG93biB3aGVuIHBvcnQgaXMgcmVzdW1lZA0KPiAgICB1c2I6
IGR3YzI6IEFkZCBleGl0IHBhcnRpYWwgcG93ZXIgZG93biB3aGVuIHBvcnQgcmVzZXQgaXMgYXNz
ZXJ0ZWQNCj4gICAgdXNiOiBkd2MyOiBBZGQgcGFydC4gcG93ZXIgZG93biBleGl0IGZyb20NCj4g
ICAgICBkd2MyX2Nvbm5faWRfc3RhdHVzX2NoYW5nZSgpLg0KPiAgICB1c2I6IGR3YzI6IEFsbG93
IGV4aXQgcGFydGlhbCBwb3dlciBkb3duIGluIHVyYiBlbnF1ZXVlDQo+ICAgIHVzYjogZHdjMjog
Rml4IHNlc3Npb24gcmVxdWVzdCBpbnRlcnJ1cHQgaGFuZGxlcg0KPiAgICB1c2I6IGR3YzI6IFVw
ZGF0ZSBwYXJ0aWFsIHBvd2VyIGRvd24gZW50ZXJpbmcgYnkgc3lzdGVtIHN1c3BlbmQNCj4gICAg
dXNiOiBkd2MyOiBGaXggcGFydGlhbCBwb3dlciBkb3duIGV4aXRpbmcgYnkgc3lzdGVtIHJlc3Vt
ZQ0KPiAgICB1c2I6IGR3YzI6IEFkZCBleGl0IHBhcnRpYWwgcG93ZXIgZG93biBiZWZvcmUgcmVt
b3ZpbmcgZHJpdmVyDQo+IA0KPiAgIGRyaXZlcnMvdXNiL2R3YzIvY29yZS5jICAgICAgfCAxMTMg
KystLS0tLS0tDQo+ICAgZHJpdmVycy91c2IvZHdjMi9jb3JlLmggICAgICB8ICAyNyArKy0NCj4g
ICBkcml2ZXJzL3VzYi9kd2MyL2NvcmVfaW50ci5jIHwgIDQ2ICsrLS0NCj4gICBkcml2ZXJzL3Vz
Yi9kd2MyL2dhZGdldC5jICAgIHwgMTQ4ICsrKysrKysrKystDQo+ICAgZHJpdmVycy91c2IvZHdj
Mi9oY2QuYyAgICAgICB8IDQ1OCArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQ0K
PiAgIGRyaXZlcnMvdXNiL2R3YzIvaHcuaCAgICAgICAgfCAgIDEgKw0KPiAgIGRyaXZlcnMvdXNi
L2R3YzIvcGxhdGZvcm0uYyAgfCAgMTEgKy0NCj4gICA3IGZpbGVzIGNoYW5nZWQsIDU1OCBpbnNl
cnRpb25zKCspLCAyNDYgZGVsZXRpb25zKC0pDQo+IA0KPiANCj4gYmFzZS1jb21taXQ6IGU5ZmNi
MDc3MDRmY2VmNmZhNmQwMzMzZmQyYjNhNjI0NDJlYWY0NWINCj4gDQoNClJlIHNlbmRpbmcgYXMg
YSAidjIiIGRpZCBub3Qgd29yayA6KC4NClRoZSBwYXRjaGVzIGFyZSBub3QgaW4gbG9yZSBhZ2Fp
bi4NCg0KQ291bGQgdGhlIGlzc3VlIGJlIHdpdGggYSBjb21tYSBpbiB0aGUgZW5kIG9mIFRvOiBv
ciBDYzogbGlzdD8NCkxldCBtZSByZW1vdmUgdGhlIGNvbW1hIGluIHRoZSBlbmQgb2YgdGhvc2Ug
bGlzdHMgYW5kIHRyeSBzZW5kaW5nIGFzICJ2MyIuDQoNClJlZ2FyZHMsDQpBcnR1cg0KDQo=
