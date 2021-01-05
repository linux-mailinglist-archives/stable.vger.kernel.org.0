Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D02EA646
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 09:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbhAEIEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 03:04:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7483 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbhAEIEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 03:04:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609833879; x=1641369879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+UsbZonySPZz3aELHRFoSIEaA3c+NaIo7h4D+e1vFXw=;
  b=CTA6g3/TBttvpVHypTTLbFx6ck2xsbPC6L3JUXXAtjTqiyac5eSDRSY5
   uAz+glKXCh/O1+CrkXEbNrCyECev4OQHnEmCFBRM5W7KIbBxED2aPBDqg
   0od9ZDVCvMmHbhyCvfZuUWyHLXWX7BtyYEtpz9lQfFjOrv93zvtbc38wH
   UI3BO8HkmA4Qa89KLyR0pZbpsx60iBnF21R6uc2BwpPnduv4UYm8NdKgE
   VjOnXS2gvtIAWezIyjxD7r6XF6uNQjUnUaWbcauUJe3pbh4kXRTmXqoqU
   bPV3NLQ30unDGlKM/kDZf/fFr2qPtlfpFrOjnzGfFDJDXIcmKvRXkZySB
   A==;
IronPort-SDR: tO9yqfOdFhYASC/Ikmx/YYTGVX6/QUvp23viFSJGDp6WZEASSB8MsK/y8BqRXYGr7ojW9DRDj0
 oxK0eGWstoDcuigj4YIE796Tmaxv5ogbI/B7VTMNi05mFcxznYlyXK3bYH0J6+W4/Urc38sphx
 fsJnC4dlAyzHyZBihxvKLqyKSIgOKwjKJnV/bMOFy2bOQZvtgjHWf4a4Oh8ks3CEgiFa5/jgoZ
 Ia1Mlx78aLhUMk5mXrpuRnDvepNdxUVZdD2zhrtmNMvxNYgnYNuM7C1kELjH7TtjJfQtKUBezE
 GLo=
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="104274175"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2021 01:03:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 01:03:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 5 Jan 2021 01:03:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkgBLPD3lRmA/OFGlmMjPhbOBRY8Eufod+C9v9Zg63MdabU9RkVu7Kx1HMpZTz/XMAvQjtBkaXqXBkY0QKCw6GblUrE1JZ/YgcYoPgATIwqc1QnAhmjUT+GUbraF1JaOZ1uxyVg5YPCqF7FB4trfrsyerhhF40giX1+5xSothORmgU/K5hr+pxTluW5tHJ5lKHJlUDKuMDpWLmj5E4kJ4y2h7Kx6aadbwk/eCES3r3NYfGV87v6nL85Bfm5JFOrE9pKtEkLHhYJVBLD2WdzyCNEd0yNdeYCY6Xx+AviblCkZUrkiLGV/3NxeIfTtBzdaiqjfLrcndmkkKbLWq9e+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UsbZonySPZz3aELHRFoSIEaA3c+NaIo7h4D+e1vFXw=;
 b=WOj6nu2AGrn5FqT7DbKxg2YzciW0IdsWzF3qQb9bQKmsmOwZUMkOAssKnrLdbgVM8v0U+q9Zk2EgVYVQpw7JFNzRCAc5lvs5q0P+EF6S1bx9IEMWHR9uVCQRWMMZIbm27wRMy6d4ja320PqPf9t7T0ZjzoQpZkY8Yom1ucBVnn1Jj/S7VqJLpsr/aojM/T4PXO5XeMEPxSmUhE2c+cZtY/ov98Lhtgq5tqciQ9lseDJTP7VdLp0oJMjo796bB2pydlqu776EW/96tMKR9FoTPMzskofo3gR/3/LeqR7pudcUJPfNn4A78/G0W/Il3bNMPfntle5vZbJOFotwEUpQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UsbZonySPZz3aELHRFoSIEaA3c+NaIo7h4D+e1vFXw=;
 b=bP2Fliqc9qrcyEAjzJvKzn11ciKqtsJUimbmEYOv+9UdHhcHsDX0yV8WpAhxKfJjuuJneV/MS1fUaGbqY8LMXIRw0RwGvcWslndHpGXHnVK0uKBF6Hggqsf4y4heNUuOExsrTp4pb17R2/GsUgZv+iq+LUAXv9k4o2OxgRqbF0c=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SN6PR11MB2573.namprd11.prod.outlook.com (2603:10b6:805:53::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 08:03:20 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 08:03:20 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <gregkh@linuxfoundation.org>
CC:     <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <dan.j.williams@intel.com>,
        <vkoul@kernel.org>, <Ludovic.Desroches@microchip.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Topic: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Thread-Index: AQHWkYFbVNgbQZmRd0SqW2sKLrUKIA==
Date:   Tue, 5 Jan 2021 08:03:20 +0000
Message-ID: <b7747258-80dd-f5bd-6dd3-ea2cf410f86f@microchip.com>
References: <20200920082838.GA813@amd>
 <80065eac-7dce-aadf-51ef-9a290973b9ec@microchip.com>
 <d3a6fa19-0852-92d9-c434-40297edc625a@microchip.com>
 <X/L1yZgmni6KHsrL@kroah.com>
In-Reply-To: <X/L1yZgmni6KHsrL@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [79.115.63.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9df76a06-a063-42b3-5759-08d8b1505db8
x-ms-traffictypediagnostic: SN6PR11MB2573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2573F9B3D831A25973D714E1F0D10@SN6PR11MB2573.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AbADRiVxcZYfCuQNDhgMNUzOMF972uBkRMB3QHMSI7TEZFiWZu0AQ/YTzKGyvMf1fYMTWFR/gO4yWH3OqFAGw0IJAQCzuMSNe37WpyyPc/DkRHsKrzJ/mqWYs5A3PShJnU40IxaQ99aWo+Omq214AZ2aSRSerhObg8B8R6hV0bibxkTD5VzLyPY781uhq7yQ9jqPGLUg3xUM/TS6uDQqBwDoOdIrQ2GmarcmuV9xDIKRrLXsETjXnemIsNbqpYzXDewWFNZy5DGisaZ1yXclbak7nAYXT4P+jlJwLS5tib2XaztlQqT717E1NFnVSrVMePlpf5fHXAKIRuhsmF2u/uHxLBAPxw6O/b1M1DLhArWZ70sARSAkOY2xh23st2GtGBSklc7hjhCB3B07A9oA0/gvaCYOehIia8XFQIxumx8XxhIKqh7m3br7t6El9kNJvwC7+srNfRz+vdVCwlllGe1pWXavc7WxpwABH6u7B6Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(186003)(86362001)(31696002)(53546011)(2616005)(478600001)(36756003)(6506007)(4326008)(31686004)(6916009)(91956017)(8936002)(26005)(83380400001)(8676002)(76116006)(66946007)(5660300002)(66446008)(66476007)(66556008)(64756008)(71200400001)(316002)(2906002)(6512007)(54906003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?azhNck9TTmZGNzJ6dGIxSTlkOXg1N3dQZ2ZTSUdKcmtjdFloRWlKMElXY212?=
 =?utf-8?B?ZmNTc3NGYUJhNFhPZjFheC9xN0NXcVorRWt0M3VtVWVUZ0pzb1kzUi9RRXhj?=
 =?utf-8?B?dGFPSkZxcDVkbXcxZTV5RUV6NEY5TitiSzMxY0F1bW9lbVcyN0J4bHNZT09W?=
 =?utf-8?B?d3A4UWJQZmVPK3A1NzljZDRoSTFkTU1RN1VXdHhNWGFwejZTTytpWFVxTEdR?=
 =?utf-8?B?ZHhIQkRVWFpLTEl5aHdQNWFDRm1wYlRFMjEwaGViY04xVnpxdE5rWDYwZjZI?=
 =?utf-8?B?RGFSMzdBZWJqajBXM25OcUZIUzJ0OUtsdTZ5SzlRQkpsSDNXdXNiRWRYQmJq?=
 =?utf-8?B?Z1ZVYXFuKzN1WkpwZTl3SC9rdkNPQ1VXT21MTjAyMmN0NDVnaERlZkF1ZnhJ?=
 =?utf-8?B?anF3bGhUOFNOTmdMMW5seXFudklFSFRDdytGSktXdS9WR09jQ0JMdGgyL2FW?=
 =?utf-8?B?SU01SXhZMjZ0SDRNbHZ5Mk5mbGphaTVoQ1NqMHhGZ0VpMmpCWTh6bTZEZjV0?=
 =?utf-8?B?cS9qdmRDWTF6ZFQ0Nm85NGM2NytiWHlxSHdqM3hZRGFLZE9UTkpFaU1HQnpl?=
 =?utf-8?B?dzRPY2V6TWgxUFhzSDRiN1FHN3dBdlhZVlBtRW1VbVU5Z2wrTUhkYjNGdzNX?=
 =?utf-8?B?Z3Z5aVEraUN5Sjh5U0NBQ2FtcTh1RTV4TkdzTk94Z05ybld0TldRZFAvazdR?=
 =?utf-8?B?U096SHNzdkF3NkxCOE1ORVVDVDkrNVF1VEt0RmcxSmlZRFlrVUZLWk1YMlN3?=
 =?utf-8?B?QW42MklEM3BUTDV4eVNWa1NvcUh2VDZ1Q1NoYVRYTC9SZ3lsb0plM05rNmFL?=
 =?utf-8?B?bXFLbjlEdzVjMUV0N0RLQm9YNVhKYUxZQ0tSVlhrVkt3K1QwVDJ5OGhqcW1j?=
 =?utf-8?B?dzZMUk50bjJsdHpDdXdDaDZZWEM4RHV5L3c5ampsTTZNYzNmWkNFZC81WSt5?=
 =?utf-8?B?SkNMWTBFTEV0K05ta0RjN3YwZnVNV24xOC9IZmtBV2MzWUJQcEQ1MUpNcmRr?=
 =?utf-8?B?aDArbzRYdk9SaHIyWHZqcm03bEVDMU0wYXJxYm15SG90YlBZKyswU3Vzeko5?=
 =?utf-8?B?MkFjbXQxOWRGeEFuZHFrMlRqeWttK3pWRm9leFBLWHh1SVJhTTNDMkoyM2dW?=
 =?utf-8?B?N0wvbE9UcGZjSmhWZlRTQnoyZzZWd1R4VmM1a2FaMXlGMitkRjB6V2ZEK0NW?=
 =?utf-8?B?L2lGUWtHNEs0cU4ySHpIWHA3alNxS2xHWWE3K1FnTG5uQ1Rjc3hldm5uYTJH?=
 =?utf-8?B?c3BmcUpJRlBldzY4MVZJZUlaSDEwMGcvRm1xSXZxaWF0c1dzSzNBK2lPNFdH?=
 =?utf-8?Q?oh2OGH0GFv0BI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <415F1FBF1204254AA79B4000C2E8E86C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df76a06-a063-42b3-5759-08d8b1505db8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 08:03:20.0130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 844pml6fdAGZ0vv17msmmOj2/2UYLaSVTIQDm6DEjwNUGIi2KgSx2LtIkYyc7dFAMBIneoKHUbp/RrqMI2V0FYRTCWPTajQfStYBP5gBAMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2573
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMS80LzIxIDE6MDIgUE0sIEdyZWcgS0ggd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCBTZXAgMjMsIDIwMjAgYXQgMDg6MTk6MThBTSAr
MDAwMCwgVHVkb3IuQW1iYXJ1c0BtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gT24gOS8yMy8yMCAx
MToxMyBBTSwgVHVkb3IuQW1iYXJ1c0BtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4+IEhpLCBQYXZl
bCwNCj4+Pg0KPj4+IE9uIDkvMjAvMjAgMTE6MjggQU0sIFBhdmVsIE1hY2hlayB3cm90ZToNCj4+
Pj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4+DQo+Pj4+IFRoaXMgZml4
ZXMgbWVtb3J5IGxlYWsgaW4gYXRfaGRtYWMuIE1haW5saW5lIGRvZXMgbm90IGhhdmUgdGhlIHNh
bWUNCj4+Pj4gcHJvYmxlbS4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgTWFjaGVr
IChDSVApIDxwYXZlbEBkZW54LmRlPg0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9k
bWEvYXRfaGRtYWMuYyBiL2RyaXZlcnMvZG1hL2F0X2hkbWFjLmMNCj4+Pj4gaW5kZXggODY0Mjdm
NmJhNzhjLi4wODQ3YjIwNTU4NTcgMTAwNjQ0DQo+Pj4+IC0tLSBhL2RyaXZlcnMvZG1hL2F0X2hk
bWFjLmMNCj4+Pj4gKysrIGIvZHJpdmVycy9kbWEvYXRfaGRtYWMuYw0KPj4+PiBAQCAtMTcxNCw4
ICsxNzE0LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgZG1hX2NoYW4gKmF0X2RtYV94bGF0ZShzdHJ1Y3Qg
b2ZfcGhhbmRsZV9hcmdzICpkbWFfc3BlYywNCj4+Pj4gICAgICAgICBhdHNsYXZlLT5kbWFfZGV2
ID0gJmRtYWNfcGRldi0+ZGV2Ow0KPj4+Pg0KPj4+PiAgICAgICAgIGNoYW4gPSBkbWFfcmVxdWVz
dF9jaGFubmVsKG1hc2ssIGF0X2RtYV9maWx0ZXIsIGF0c2xhdmUpOw0KPj4+PiAtICAgICAgIGlm
ICghY2hhbikNCj4+Pj4gKyAgICAgICBpZiAoIWNoYW4pIHsNCj4+Pj4gKyAgICAgICAgICAgICAg
IGtmcmVlKGF0c2xhdmUpOw0KPj4+PiAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+Pj4+
ICsgICAgICAgfQ0KPj4+DQo+Pj4gVGhhbmtzIGZvciBzdWJtaXR0aW5nIHRoaXMgdG8gc3RhYmxl
LiBXaGlsZSB0aGUgZml4IGlzIGdvb2QsIHlvdSBjYW4gaW5zdGVhZA0KPj4+IGNoZXJyeS1waWNr
IHRoZSBjb21taXQgdGhhdCBoaXQgdXBzdHJlYW0uIEluIG9yZGVyIHRvIGRvIHRoYXQgY2xlYW5s
eSBvbiB0b3ANCj4+PiBvZiB2NC4xOS4xNDUsIHlvdSBoYXZlIHRvIHBpY2sgdHdvIG90aGVyIGZp
eGVzOg0KPj4+DQo+Pj4gY29tbWl0IGE2ZTdmMTljOTEwMCAoImRtYWVuZ2luZTogYXRfaGRtYWM6
IFN1YnN0aXR1dGUga3phbGxvYyB3aXRoIGttYWxsb2MiKQ0KPj4+IGNvbW1pdCAzODMyYjc4YjNl
YzIgKCJkbWFlbmdpbmU6IGF0X2hkbWFjOiBhZGQgbWlzc2luZyBwdXRfZGV2aWNlKCkgY2FsbCBp
biBhdF9kbWFfeGxhdGUoKSIpPj4+IGNvbW1pdCBhNmU3ZjE5YzkxMDAgKCJkbWFlbmdpbmU6IGF0
X2hkbWFjOiBTdWJzdGl0dXRlIGt6YWxsb2Mgd2l0aCBrbWFsbG9jIikNCj4+DQo+PiB0aGlzIGxh
c3QgY29tbWl0IHNob3VsZCBoYXZlIGJlZW4NCj4+IGNvbW1pdCBlMDk3ZWI3NDczZDkgKCJkbWFl
bmdpbmU6IGF0X2hkbWFjOiBhZGQgbWlzc2luZyBrZnJlZSgpIGNhbGwgaW4gYXRfZG1hX3hsYXRl
KCkiKQ0KPj4NCj4+IGJhZCBjb3B5IGFuZCBwYXN0ZSA6KQ0KPiANCj4gU28gYXJlIGFsbCAzIG9m
IHRob3NlIG5lZWRlZCBvbiBib3RoIDUuNC55IGFuZCA0LjE5LnkgdG8gcmVzb2x2ZSB0aGlzDQo+
IGlzc3VlPw0KPiANCg0KWWVzLiBJJ3ZlIGp1c3QgY2hlcnJ5LXBpY2tlZCBhbGwgdGhyZWUgY29t
bWl0cyBvbiBib3RoIHY1LjQuODYgYW5kIHY0LjE5LjE2NCwNCmV2ZXJ5dGhpbmcgbG9va3Mgb2su
IEkgYWxzbyBjb21waWxlZCB1c2luZyBzYW1hNV9kZWZjb25maWcsIGFsbCBnb29kLg0KDQpUaGUg
b3JkZXIgaW4gd2hpY2ggdGhleSBzaG91bGQgYmUgdGFrZW4gaXMgMS8gYTZlN2YxOWM5MTAwLCB0
aGVuIDIvIDM4MzJiNzhiM2VjMiwNCmFuZCAzLyBlMDk3ZWI3NDczZDkuDQoNCkNoZWVycywNCnRh
DQo=
