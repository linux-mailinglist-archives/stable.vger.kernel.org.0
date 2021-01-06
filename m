Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30F2EBBBF
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 10:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbhAFJgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 04:36:24 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42382 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbhAFJgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 04:36:23 -0500
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9ACA8C00AF;
        Wed,  6 Jan 2021 09:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609925722; bh=nbQGPWaalu3eal8UASkmsJLfXxh7nldJh6rjvXDzfjc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lMQ57A49JyWy7YU3/LanEfuAVzBiCY8mDmPwk42JpH808IsyTt2Mm711dqxHVs2Iz
         jkZvzuxbBUzBMCh5E4+4BRBIxqSgl8Cqiniwa+QFwoFgFDFKVAWIl+ltTAgawK3+yf
         j7+P8IvptsHxvpXdmuFqBIWbQ9rILXUO7RClfgO4cnupUeEOIFlUjc+9L5uESwIY0P
         ndD8cOrx2SHU0OVumMGaRBqBGKUff4CkNDdpV0UjMvcw7hM0cnpZ/p/FP3GzXs0J8e
         32cFBkz5Yl3LIh825JWzVjLZcBZEqPCRWWKU2c+ecSSB30MYnIYhA7Gd0oB2XfaqDd
         Xvmsyo9q36Hqg==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3552CA005F;
        Wed,  6 Jan 2021 09:35:21 +0000 (UTC)
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2052.outbound.protection.outlook.com [104.47.44.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 552DA400C6;
        Wed,  6 Jan 2021 09:35:21 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="LlYcImdq";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8ZAHcM7eiNNHLw/b01AB8/7iv/UlhrLoldC5mxx8Z2Qmo2WbxqTFi63FXKWRkFovOYU/cJl+4MURxga4NJ2f1KTsonqW9ErMDWk5y6QASvRLSi0FP1b+46LtmWe8GiJMFfQgXtR4Ivlxb5TEEmsJZ2PgSGHhX5rFaM0NmwxaceHzK2Pi8OvJU116DsZ6f9RvbO6gtkBNxHkfcK6qwlTJXzmMaxBich0O3srkDF/WPtenScSRixJkBuP00YCy0cyNqTmK85hVVAwcVKRgHw3SdLfwzkmE26P5kEaS56oJq9CaQxeYEJ9qU5fUMJc5JOO8ws/1MW9bXPCrSU6bHSPsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbQGPWaalu3eal8UASkmsJLfXxh7nldJh6rjvXDzfjc=;
 b=ZtMMQCd5KiRZNNsVisevi+xYZKBFZ11DcudBuhFctYGY8uD62vtKAF0LvBy0slEgvc6Q/tvU4bwv9OW3tLor4Vrf/OdqtGwikrHouQ3BUM+y6V3TeSrA5xSnRKPXs+bbt8cnocVp98oysBfmN3jiqJ5d5INRyMsVkuCsS5MH8NGf/snQjEjJOAsW8/xSA+nkB+ZjNK+Xz+1KFICl3vqM1WcUeeHJA+dWHBoqF54Ylh83Q8DowHd0SLcQKBNIFE/URhSZAokD08W3IuROS130ThofR1AzNOyfoFkCTzJoK231Mpvo6YP8vgxa9HKjB6gl7nKd8g+VQCShn697RisASw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbQGPWaalu3eal8UASkmsJLfXxh7nldJh6rjvXDzfjc=;
 b=LlYcImdqqnNHA/XHzcwuHUK60OklAGbNfxUiBcU4zwvu7dcjvOwmAn6bJ7cLUFZgg+3RBa5K3YdBp0Zj+U4w8YGlal8WfBTXiyO8/uZOgJsYQDBGshncj++xTdHw1R0D/VWaOUjH1zazVHYKsxMRONXx+7jhQCe+bA9wTkpGTM4=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 09:35:19 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::895b:620d:8f20:c4d6%6]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 09:35:18 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: gadget: Check if the gadget had started
Thread-Topic: [PATCH 1/2] usb: dwc3: gadget: Check if the gadget had started
Thread-Index: AQHW44O7K4z/WCI5OkK9vS9gFC4nSqoaOwOAgAAccgA=
Date:   Wed, 6 Jan 2021 09:35:18 +0000
Message-ID: <f4eab8b6-01d3-1f0c-f08e-311d7fee1f0e@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
 <92118292e053f3a1a9238facfec91630468ba752.1609865348.git.Thinh.Nguyen@synopsys.com>
 <87a6tmcxhi.fsf@kernel.org>
In-Reply-To: <87a6tmcxhi.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 609a8908-0f83-4efb-03a8-08d8b22661a6
x-ms-traffictypediagnostic: BY5PR12MB4099:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4099F6F4CC7D2F40195C1649AAD00@BY5PR12MB4099.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xLAot+agmAEDJ7KuaEOHQuijAE75xGhVRBnHhklZvDCP7MGTxlOL3wLrQLnHmTuEup6aDMVSEA/WgjyyWCepqh52Dt8gvkJVsz5Bp9W3XvJszixugMzk/GH6/K2pYV2isYURY9i/tjZFu4iDzFiBD4zn9/Cbx8rEc2X8yKGkpEr5DeyZ+6OuwA8TYZjmDiq5RYEwLck3tqAVmv0jNPnf1MmHp8snj9rn7TlBkfeC4CFGFPuOH+5JQR/UqXtXXuvT4XdaD9ZHoM6KwtCv+38Z9/jj/J3HhV3X9D3NP2wuSGcb9K5XtlqVs8lDAPDRH+gFRWt3ezAqCDLD0xBszbcx7MfKky/2Ll42S5XCsN2QWbGvWMFp5dDhPVOf4xY/4N/1VmKAT6ERJ1tflYy5RxmFgg1aqd7OpEP6P9Tm1Rg3O/7fUwlCEZhGyEeJFrld/K96Db5TTV+y1sHIcSFWzkm0i4PgPiXypUoEh5WCoaFD/ds=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(64756008)(66476007)(66446008)(31696002)(86362001)(66946007)(66556008)(6486002)(76116006)(5660300002)(6512007)(4744005)(8676002)(2616005)(71200400001)(26005)(2906002)(8936002)(186003)(36756003)(478600001)(6506007)(31686004)(83380400001)(54906003)(4326008)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cUNKcHNVdWFzSFZURUNnSzZiZDJsM25Ceis1cHlhNFBHNHgxbXJTNitGcXY1?=
 =?utf-8?B?RnRXTC9qdlZFcDdsYjJTUDhLajFsSHQyOE8vdUlNVFloUGc3TGdwejBGRGhT?=
 =?utf-8?B?anZDc05zTjd2Q3RmZ1d2OUVQRHYzTGhpdjJHdGh6Q004c0s1QnErc3ZtckpQ?=
 =?utf-8?B?eXhVMGx5b0tTK0VaNHpwRkRBYllPbFFJdmNuendVSlpQSGRha21SMnJDVHJ2?=
 =?utf-8?B?T29nRHpkdnNUbVc1eDY2cmxDc2FKZWZJakZGbmZhTUtYU3J0cytmd0VIRHQ4?=
 =?utf-8?B?VklyRmNwc1pxWmNQUThCdTZReDNCU3ovZGVObDk4L0xud1VxaVlCN2dXUFAz?=
 =?utf-8?B?cDdOaUVRMW1aTWtxa00zODZZWUxVMlMxZ0VFYzFWS2kybUVuNGZFVzhNL0cx?=
 =?utf-8?B?U3V2bnZJcDZTUTBZbm9qblRvdHpHZzBQNkE1UGtXUFpEc09nazlPRTJKbU1O?=
 =?utf-8?B?a2g3U3VPdkNSdjNzTFhTM1dSNi9WYnhSRzlLMnh1M2lPOUY4RWUyZ3VHanlZ?=
 =?utf-8?B?RlVSWFdBVlk4WG1BZ2E3a25VYzVqQlhxMUpLcFp5REhycTJuV2M3QTBDT1J6?=
 =?utf-8?B?b2RmcHlnWkE2Mkoya1ZYalFibDREbUszQ0JzZnVBVjlBUW84eHBUMGErTjVR?=
 =?utf-8?B?RXgzNGNHNlQzemlmQy96WGZyNERIMmtHaHo3elFCY084VFQ5SnBjbXlOckVD?=
 =?utf-8?B?anFHM0RmVDBTLzNEYTFmVnZpcWREbStvYUtFNmhUWWdLampJNTVWSVZYeHEz?=
 =?utf-8?B?NmQ0ckhxRC9nTmxDSUZDSVlwSjI4eDM4dmwrY2JubjlUUDlWU1dGZmNSVDdy?=
 =?utf-8?B?aW5vV0dSdSsyZVB5dmRlNlVsdVdrWGh3SnZZU2JmUEljQ1VDMW1tamJadGx3?=
 =?utf-8?B?UW9wUnRUM0xvZ2UvNnQ2dkIwSEV3NjZMdEJLNzhHaUJnZ3owZDFMSjF0SklB?=
 =?utf-8?B?ZmdqSWJVUFZtK3A4TWM4a1ZGQmRzVXhrcEpaMzN4QWFmK2N0ZGNHdXRUNnBV?=
 =?utf-8?B?S1I2RWVENUI2bThFaXNIZmlLbFZvQVdOUUVua0tYQ0krWEtnaUNvZ3c1NUdW?=
 =?utf-8?B?MG8zazliTklzUThDOVVXVnhJY05hVzIxakRDVmt0UjJPVDk5L09QS2JHNTFz?=
 =?utf-8?B?ZzdSTHZJa3Z0YVBTQjFhSUxla1BhYnRJWGZZR3JkdlZYeEV1UlpJRXFDRUVG?=
 =?utf-8?B?TEJMTFpjZ21BUmZOQy9HWmlOQnJFSkRRbjRIUCtFVFlMLy9yblRxenlyOFly?=
 =?utf-8?B?U1djV3U0L0dMY0o5RDNSS0pqOUpWaG1WN0FHTXJGNWZqQ0JKUkh2YzgyV2FZ?=
 =?utf-8?Q?gVkqK7iIBEiMw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F7217D3F40B604E91A8A18DDC1D922E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609a8908-0f83-4efb-03a8-08d8b22661a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 09:35:18.8427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GJhLMII2QuxxBzejMErA6hUOoRYeePTreEee3eRb3A0cmH5VX2L9Vrhkz3I42saED+HhoHv2BX2O01927OSy/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkZlbGlwZSBCYWxiaSB3cm90ZToNCj4gSGksDQo+DQo+IFRoaW5oIE5ndXllbiA8VGhp
bmguTmd1eWVuQHN5bm9wc3lzLmNvbT4gd3JpdGVzOg0KPj4gSWYgdGhlIGdhZGdldCBoYWQgYWxy
ZWFkeSBzdGFydGVkLCBkb24ndCB0cnkgdG8gc3RhcnQgYWdhaW4uIE90aGVyd2lzZSwNCj4+IHdl
IG1heSByZXF1ZXN0IHRoZSBzYW1lIHRocmVhZGVkIGlycSB3aXRoIHRoZSBzYW1lIGRldl9pZCwg
aXQgd2lsbCBtZXNzDQo+PiB1cCB0aGUgaW50ZXJydXB0IGZyZWVpbmcgbG9naWMuIFRoaXMgY2Fu
IGhhcHBlbiBpZiBhIHVzZXIgdHJpZXMgdG8NCj4+IHRyaWdnZXIgYSBzb2Z0LWNvbm5lY3QgZnJv
bSBzb2Z0X2Nvbm5lY3Qgc3lzZnMgbXVsdGlwbGUgdGltZXMuIENoZWNrIHRvDQo+PiBtYWtlIHN1
cmUgdGhhdCB0aGUgZ2FkZ2V0IGhhZCBzdGFydGVkIGJlZm9yZSBwcm9jZWVkaW5nIHRvIHJlcXVl
c3QNCj4+IHRocmVhZGVkIGlycS4gRml4IHRoaXMgYnkgY2hlY2tpbmcgaWYgdGhlcmUncyBib3Vu
ZGVkIGdhZGdldCBkcml2ZXIuDQo+IExvb2tzIGxpa2UgdGhpcyBzaG91bGQgYmUgZml4ZWQgYXQg
dGhlIGZyYW1ld29yayBsZXZlbCwgb3RoZXJ3aXNlIHdlDQo+IHdpbGwgaGF2ZSB0byBwYXRjaCBl
dmVyeSBzaW5nbGUgVURDLiBBZnRlciB0aGF0IGlzIGRvbmUsIHdlIGNhbiByZW1vdmUNCj4gdGhl
IGR3Yy0+Z2FkZ2V0X2RyaXZlciBjaGVjayBmcm9tIGhlcmUuDQo+DQoNClN1cmUuIFdlIGNhbiBk
byB0aGF0Lg0KDQpUaGFua3MsDQpUaGluaA0K
