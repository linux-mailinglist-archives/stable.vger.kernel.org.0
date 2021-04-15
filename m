Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84B2361356
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhDOUMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 16:12:13 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:35308 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234654AbhDOUMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 16:12:13 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 64152C015B;
        Thu, 15 Apr 2021 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618517509; bh=q1AfEVhsHaUAttsZ8IosiuscbFuBI19+nky8fUyqYao=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=htii8gBvERIA3t5o9WhToxmwebTvKh+iSEu2FeTVYzBH9khhalOQ3FmwZiR/URnsF
         S59ITtklBcsrOA/KdNh1VDj8pxt6NHT72o0ZeDZ1/PDIZtBJB5fDFdR5x0W2KnqdYL
         Coapiroidd1j38//PJ60m55g8GaIkb+fkupAdiVznm1m/MdFIB/e7doUj0YNp4o3+D
         0LX1SGJ8Glv2U3rRo7RHQ5sIvdDVOO5BrXYXHg8oS4keLukPg5R8HgEmRfmDG9UIsk
         wBIdZ7ZnLMWz/oUsBWgY7FLze4C90BDcfuhzuaZaTMZ7aSOVpxqARkwl5V5xnmajDa
         zlGRo+qVSTXJw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 489FCA0070;
        Thu, 15 Apr 2021 20:11:48 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 8FFEB40132;
        Thu, 15 Apr 2021 20:11:47 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="txI6GNm7";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLlGiBNqMB1NQjwjNKWSGn3gvdSh2Qu8SBPECDEGZ/m8YAQ8WDhYjK0Y2xDJVEw2GobA3xyEqXnjr5vlV4q+WKc1FVm6WX9fXAA8SQCcVcUG7Rl4CIEVy0wdLGKVXUZkmTuYkx50xE+urCvibL/u9JkYrQ2O7EtguKWFO7N3zIreq21mI4ANFL2s6qqonMyoZ5/Kkgl0JcCfsygDhHI8A2hRaq2IrZ3iVjXmMxcGDj2fWI+5jbDk/Hb/PR06czeKhhK6Krn5skZIvAMsRAwXakZD071PGFNyHNppN7npzUAWMKIG19eYJPkc644e0nUvYWUYGg0Fgq+Lpgitw/EUrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1AfEVhsHaUAttsZ8IosiuscbFuBI19+nky8fUyqYao=;
 b=AWKj1+edoFg4kk2hP/JB1QP8A9bUVMbFKPvAebORavXbPTkwZCLGY9IqVIh/N4iFzTBbj0LLM/MeITR1Oiospw6jP32PG7iuMAzVCl/CxY5cB6hLlPKyb8Xi3pdjr0NTArFlU5d+8mF2OV49/bFTwV3o2o519qpyAXKEEe0cfokC3/3pPXqoCXVjqXNMRjztnIt+D13BLqor67gIOe1SIcbHvTpeUgbE2LE00lCtOIvzpg1xQ2fZAX8/kEf2yNquI1HSuE46lj0ChEAwwlM5cSdovf+wzM37do46KFoJH2RqL/Rxn1Az1Iotid3F0scPm8+wQC/4INuwB2GDZTSCRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1AfEVhsHaUAttsZ8IosiuscbFuBI19+nky8fUyqYao=;
 b=txI6GNm7ufzFxbAQO/028oScbu6YN3RNzHGsvXnPDJyWWdMS2IG3+Uz78/vMw7zeJORyFuEvwddl4ZgcRHKXWpcvV9M1k9jdgWEdLfsFowtjuO2ajKk8Y4MB5cBKvPpm6LCQPzk3dw3aN/376S3fu5N9F8/uqrGQcaR3J4AIyOs=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4919.namprd12.prod.outlook.com (2603:10b6:a03:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 20:11:45 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 20:11:45 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     John Stultz <john.stultz@linaro.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH v2] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v2] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMhSefPfcoEcr/U239n3BQNK7maq1/iqAgAAEyQA=
Date:   Thu, 15 Apr 2021 20:11:45 +0000
Message-ID: <b2a4f698-5363-6552-f1e9-71d015311665@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <CALAqxLWkumSzfq1uOTbHdpiYfKOyJoyOosChBb25iyS4RYWP3w@mail.gmail.com>
In-Reply-To: <CALAqxLWkumSzfq1uOTbHdpiYfKOyJoyOosChBb25iyS4RYWP3w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abd07d87-23c9-461d-fc01-08d9004ab18e
x-ms-traffictypediagnostic: BY5PR12MB4919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49197B3457A4F87EA3B50B89AA4D9@BY5PR12MB4919.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDew5XCIKwJp4jzP58YeXmGRnbDxwfIb15AMyS2ZV2wx0Hxy6afhmsp881AVz1z1fQxtozcIvs4zAPbrYxC8Lu5FohP/bTDKveXY8CzpEgKuFPxa4FMNXab75MQTE1QN/DLqzC1a8X0goOFf7waaN7DDlTzam+zvOHOGe+HhZ16r5KyNZryb1IQGy+NIm3cIuNB/OKftPeFnl29Ac3BfsFqLNR6MNwk68vSJLY720eCa8/FuJvQ9SO4zbavGCA/liwoBd+RQJb8G3PLBxymhEGgjbSTUEE8RgybJKRhh6n3jeTzaoWdK4MeSQvzS9fK0qvZvYp/UYxm6jF8PFKDNSN/LsOqMcj98uDpoULxvuYTQzE0HJzjIoTLXrPh0KdhDvUwumacihVbR4W/RHAkOgr4fy2ZCudPS9PtMN2e461lkPZ283zwe7BOMT/ssyBWAt5rJMd0eKnAHRtzTJumDpWI+4JHlViAKZ7NXCQl8UcgAAkASjNLX9RJrnGw+mLPNOw7paMdp83jT4oqmsF8flyFpTyh4YEdvLBEZy0j09C9XHMJgNrADr1RCgaeixYw/yJaXKnC1/inGu4To+2wS30NOY62OGUkrJ66Lu0OiWsn4zdAiCef6mpZd/gnYI1OWbLa/aFO/q1RTKN6PUGRAXPo4hbbmeO58HS0U/BEkqNs432nGagSErKLFl84zHJudPWNykwue+DR5GUbOr7a8MDbmDbXSz+5sh59ECCCxiq6gEB0UXIN9N1i/s8FmQg2bvZYxINir6TIDDxyJx3lmFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(316002)(122000001)(38100700002)(110136005)(54906003)(2616005)(7416002)(8676002)(36756003)(31686004)(4326008)(966005)(2906002)(6512007)(478600001)(8936002)(71200400001)(86362001)(6506007)(76116006)(6486002)(66476007)(64756008)(5660300002)(66556008)(66446008)(66946007)(31696002)(26005)(83380400001)(53546011)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eGpvMXp1UUI4K0ZhRTg4MXo4dHRBL0NJZXBMYkNHQk8vdVgyN09uS2hQVU9j?=
 =?utf-8?B?aG1iNko3WHBSc1Y1TWdodEJ1c0IrNVU4WVpDZlRKRWNaSUhuNHh6aFQ4MHkr?=
 =?utf-8?B?L0hScGpOUjM3cmRrclhMNjg3dTlzVmlWUmwyYlY2QnNZT1MrUkdaeDFQayth?=
 =?utf-8?B?N1p4M05ZYnRhUjl5SUExZUFPNDcvRVhLVjZickZnVDZOY2FCallhSmJwSTZw?=
 =?utf-8?B?WHBOL0R4bjE0cTNHWFdsb0ZlcjFSWUYyaXZvRnhDbzFyUmpHVzdsYWsraE5N?=
 =?utf-8?B?WjBHaWJLSVZpSFhsS0FSMkNaeGFTWXNVWFV6NDErdVNBYUIycjNXUWd5K1Q4?=
 =?utf-8?B?enpERFhuRm9YczFwdTI2OEN2Z0NuWERFTi9yOGh1empVNjJxVVVTZHpTR2ZG?=
 =?utf-8?B?Ry9GYW1rdE1QVVp2YzdlN2tQZWd2SStSRlRNSkNOSXlNbE83L3hZeGtUVFVB?=
 =?utf-8?B?VlZnKzVmZ3RaekpnMy9tWVh1TGg2Vm5YRExwUjdjelpTMDZKS3EvOVN4bENh?=
 =?utf-8?B?SUxIQjdxYU1McGZLZmRaeWxTa2pFNlJjMFR1djAzRW1rSDdRQ0tSZWJMMkh2?=
 =?utf-8?B?UWpDK2JReDl4bGFya1hWNUJmMFlPaFp6WEg3bDh2OElVNDVyUyt3eDJwb3k0?=
 =?utf-8?B?bTMxN2I4blk4dFhZMTA3bjVJdWdxb3FxVmlOcjhlSHh3UVU5RnUwdDJlelk3?=
 =?utf-8?B?S0RlR3I4Yi84a250Zk5sRE05cG55eHdER0ZhcW85MjBsRkxXNEMzWkpUVmVi?=
 =?utf-8?B?UUhWalVnUGVoSWpZR3pDZE9pMm1SdkFiNGZ0ZFhuY3JsOVMzYXRzVzNZWUtH?=
 =?utf-8?B?Y0lSdDV3UXVpZm1PT3Nja0xpak9pSHB0amp3ZzkrUUFnWXN1RU04VGxwcHJz?=
 =?utf-8?B?TTFQc3ZqamtlMmJPTUREVVB0NUFwNGFZb2tWVGZWc2pDbXVleWhYUE9RUzVZ?=
 =?utf-8?B?NjA4cHVYZkczVklEVGxkTC9MQTZLT1BrSEJrM2pTaGE4bHByajdhaDNCeVNm?=
 =?utf-8?B?cHdqU3ZoLzVPZUowRU1la3pkc0NVWmpNWjJFZTdTN0NXaEhCbFVHcHE4cmgz?=
 =?utf-8?B?MkhPUmNLMGZSL1BBa0ZmMjQwbnJualFhYkF6WTVncWJROVg1UE1HaExLcTBU?=
 =?utf-8?B?TkZWdy8rNHRWL2V1WWJmcWdSODk3UjB0UFh0Rzc4ZVY3MGtsY1BNV2tBVzlC?=
 =?utf-8?B?b1RPRjl0cVppbjdBUnFzclJsbHJLbmRXaTVhL0hsS0JkNlBvSmR3VmtBRFRt?=
 =?utf-8?B?V1VIS1pGc1NmMkVIN3A1cG1zQzF5VFVNM1F0TnNhb0JjYUdmODQrVWUvdzI2?=
 =?utf-8?B?RHB2bzhscXFNT1A0aW9lZFJGL1I2YVp0bFc5eVBqRVV5aEoyZll4QlAralA5?=
 =?utf-8?B?bHhFSlE4YUg3U1NWS3pveXRBZ25HTzQ4SkhKb05wNndXUURETFJEQmlzRjhF?=
 =?utf-8?B?VldEM3ZwYVZCbE1QYWI0ckZ6YXlIeEZvSlpzU2ZuQWR5alA2bEdqaW05ZG1n?=
 =?utf-8?B?WWRGYXNFNHcvb1pHSUo3VUQydk9XZmRadlJiZ0NuU0dhTmJXazZwR2Z1OWJz?=
 =?utf-8?B?U1M1WTJ2azk1TjM4bCtuQ3RlRGdaZm5aT1FmcUlJRnZUZlk3YjMvY24rdG96?=
 =?utf-8?B?RXFhUkFJbHVaZUpaczE3cTk1MkFTRk5ZY0RHdTdCTitPK3YwOWp1Qmg2WkJG?=
 =?utf-8?B?K0dDN2crdEk4eDNFbzd6eUlwekl6RzEwbnpLWEhHamdFMjBaSHRuRXpCVVN1?=
 =?utf-8?Q?YPN2AErQmXdF6LxjTq8MHyscQRcDJQylcShD1vr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16E27B3833EC474A8F8C2DB7E69F817C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd07d87-23c9-461d-fc01-08d9004ab18e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 20:11:45.4374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeqNatQIJ8ucCw9iPgeSIvTB0clbsnXQf2/S/pjRcHdBP8r8XqFtoRzCFKyXwYzuI8tO37a26DyD8lEs4IfR9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4919
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sm9obiBTdHVsdHogd3JvdGU6DQo+IE9uIFRodSwgQXByIDE1LCAyMDIxIGF0IDk6MjkgQU0gVGhp
bmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPiB3cm90ZToNCj4+DQo+PiBGcm9t
OiBZdSBDaGVuIDxjaGVueXU1NkBodWF3ZWkuY29tPg0KPj4gRnJvbTogSm9obiBTdHVsdHogPGpv
aG4uc3R1bHR6QGxpbmFyby5vcmc+DQo+Pg0KPj4gQWNjb3JkaW5nIHRvIHRoZSBwcm9ncmFtbWlu
ZyBndWlkZSwgdG8gc3dpdGNoIG1vZGUgZm9yIERSRCBjb250cm9sbGVyLA0KPj4gdGhlIGRyaXZl
ciBuZWVkcyB0byBkbyB0aGUgZm9sbG93aW5nLg0KPj4NCj4+IFRvIHN3aXRjaCBmcm9tIGRldmlj
ZSB0byBob3N0Og0KPj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwuQ29yZVNvZnRSZXNl
dA0KPj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGhvc3QgbW9kZSkNCj4+IDMuIFJlc2V0IHRoZSBo
b3N0IHdpdGggVVNCQ01ELkhDUkVTRVQNCj4+IDQuIFRoZW4gZm9sbG93IHVwIHdpdGggdGhlIGlu
aXRpYWxpemluZyBob3N0IHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4NCj4+IFRvIHN3aXRjaCBmcm9t
IGhvc3QgdG8gZGV2aWNlOg0KPj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwuQ29yZVNv
ZnRSZXNldA0KPj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGRldmljZSBtb2RlKQ0KPj4gMy4gUmVz
ZXQgdGhlIGRldmljZSB3aXRoIERDVEwuQ1NmdFJzdA0KPj4gNC4gVGhlbiBmb2xsb3cgdXAgd2l0
aCB0aGUgaW5pdGlhbGl6aW5nIHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4NCj4+IEN1cnJlbnRseSB3
ZSdyZSBtaXNzaW5nIHN0ZXAgMSkgdG8gZG8gR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBzdGVwIDMp
IG9mDQo+PiBzd2l0Y2hpbmcgZnJvbSBob3N0IHRvIGRldmljZS4gSm9obiBTdHVsdCByZXBvcnRl
ZCBhIGxvY2t1cCBpc3N1ZSBzZWVuDQo+PiB3aXRoIEhpS2V5OTYwIHBsYXRmb3JtIHdpdGhvdXQg
dGhlc2Ugc3RlcHNbMV0uIFNpbWlsYXIgaXNzdWUgaXMgb2JzZXJ2ZWQNCj4+IHdpdGggRmVycnkn
cyB0ZXN0aW5nIHBsYXRmb3JtWzJdLg0KPj4NCj4+IFNvLCBhcHBseSB0aGUgcmVxdWlyZWQgc3Rl
cHMgYWxvbmcgd2l0aCBzb21lIGZpeGVzIHRvIFl1IENoZW4ncyBhbmQgSm9obg0KPj4gU3R1bHR6
J3MgdmVyc2lvbi4gVGhlIG1haW4gZml4ZXMgdG8gdGhlaXIgdmVyc2lvbnMgYXJlIHRoZSBtaXNz
aW5nIHdhaXQNCj4+IGZvciBjbG9ja3Mgc3luY2hyb25pemF0aW9uIGJlZm9yZSBjbGVhcmluZyBH
Q1RMLkNvcmVTb2Z0UmVzZXQgYW5kIG9ubHkNCj4+IGFwcGx5IERDVEwuQ1NmdFJzdCB3aGVuIHN3
aXRjaGluZyBmcm9tIGhvc3QgdG8gZGV2aWNlLg0KPj4NCj4+IFsxXSBodHRwczovL3VybGRlZmVu
c2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzIwMjEwMTA4MDE1
MTE1LjI3OTIwLTEtam9obi5zdHVsdHpAbGluYXJvLm9yZy9fXzshIUE0RjJSOUdfcGchSlF4ODRZ
M1U5S0d5M2RWcFc3MmNRQ0dnX1VNYlJ3T2JjQ0J0cUJoMFNXcGJ5UTJuenoxT0YyM0lrZktrTUtS
WjNYbHEkIA0KPj4gWzJdIGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC11c2IvMGJhN2E2YmEtZTZhNy05Y2Q0LTA2OTUtNjRmYzkyN2UwMWYx
QGdtYWlsLmNvbS9fXzshIUE0RjJSOUdfcGchSlF4ODRZM1U5S0d5M2RWcFc3MmNRQ0dnX1VNYlJ3
T2JjQ0J0cUJoMFNXcGJ5UTJuenoxT0YyM0lrZktrTU0xSnlfOTkkIA0KPj4NCj4+IENjOiBBbmR5
IFNoZXZjaGVua28gPGFuZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+DQo+PiBDYzogRmVycnkgVG90
aCA8Zm50b3RoQGdtYWlsLmNvbT4NCj4+IENjOiBXZXNsZXkgQ2hlbmcgPHdjaGVuZ0Bjb2RlYXVy
b3JhLm9yZz4NCj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4+IEZpeGVzOiA0MWNl
MTQ1NmUxZGIgKCJ1c2I6IGR3YzM6IGNvcmU6IG1ha2UgZHdjM19zZXRfbW9kZSgpIHdvcmsgcHJv
cGVybHkiKQ0KPj4gU2lnbmVkLW9mZi1ieTogWXUgQ2hlbiA8Y2hlbnl1NTZAaHVhd2VpLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEpvaG4gU3R1bHR6IDxqb2huLnN0dWx0ekBsaW5hcm8ub3JnPg0K
Pj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29t
Pg0KPj4gLS0tDQo+PiBDaGFuZ2VzIGluIHYyOg0KPj4gLSBJbml0aWFsaXplIG11dGV4IHBlciBk
ZXZpY2UgYW5kIG5vdCBhcyBnbG9iYWwgbXV0ZXguDQo+PiAtIEFkZCBhZGRpdGlvbmFsIGNoZWNr
cyBmb3IgRFJEIG9ubHkgbW9kZQ0KPiANCj4gDQo+IEhleSBUaGluaCENCj4gDQo+ICAgVGhhbmtz
IHNvIG11Y2ggZm9yIHlvdXIgcGVyc2lzdGluZyBlZmZvcnQgb24gdGhpcyBpc3N1ZSEgSXRzDQo+
IHNvbWV0aGluZyBJJ2QgbG92ZSB0byBzZWUgZmluYWxseSByZXNvbHZlZCENCj4gDQo+ICA+ICBz
dGF0aWMgdm9pZCBfX2R3YzNfc2V0X21vZGUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPj4g
IHsNCj4+ICAgICAgICAgc3RydWN0IGR3YzMgKmR3YyA9IHdvcmtfdG9fZHdjKHdvcmspOw0KPj4g
ICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPj4gKyAgICAgICB1bnNpZ25lZCBpbnQgaHdf
bW9kZTsNCj4+ICsgICAgICAgYm9vbCBvdGdfZW5hYmxlZCA9IGZhbHNlOw0KPj4gICAgICAgICBp
bnQgcmV0Ow0KPj4gICAgICAgICB1MzIgcmVnOw0KPj4NCj4+ICsgICAgICAgbXV0ZXhfbG9jaygm
ZHdjLT5tdXRleCk7DQo+PiArDQo+PiArICAgICAgIGh3X21vZGUgPSBEV0MzX0dIV1BBUkFNUzBf
TU9ERShkd2MtPmh3cGFyYW1zLmh3cGFyYW1zMCk7DQo+PiArICAgICAgIGlmIChEV0MzX1ZFUl9J
U19QUklPUihEV0MzLCAzMzBBKSAmJg0KPj4gKyAgICAgICAgICAgKGR3Yy0+aHdwYXJhbXMuaHdw
YXJhbXM2ICYgRFdDM19HSFdQQVJBTVM2X1NSUFNVUFBPUlQpKQ0KPj4gKyAgICAgICAgICAgICAg
IG90Z19lbmFibGVkID0gdHJ1ZTsNCj4gDQo+IFVuZm9ydHVuYXRlbHkgb24gSGlLZXk5NjAsIHRo
aXMgY2hlY2sgZW5kcyB1cCBiZWluZyB0cnVlLCBhbmQgdGhhdA0KPiBiYXNpY2FsbHkgZGlzYWJs
ZXMgdGhlIG5lZWRlZCAob24gSGlLZXk5NjAgYXQgbGVhc3QpIHNvZnQgcmVzZXQgbG9naWMNCj4g
YmVsb3csIHNvIHdlIHN0aWxsIGVuZCB1cCBoaXR0aW5nIHRoZSBpc3N1ZS4NCj4gDQo+IFRoZSBy
ZXZpc2lvbi9od3BhcmFtczYgdmFsdWVzIG9uIHRoZSBib2FyZCBhcmU6DQo+ICAgcmV2aXNpb246
IDB4NTUzMzMwMGEgaHdwYXJhbXM2OiAweGZlYWVjMjANCj4gDQo+IEp1c3QgdG8gbWFrZSBzdXJl
LCBJIGRpZCB0ZXN0IGRpc2FibGluZyB0aGUgY2hlY2sgaGVyZSwgYW5kIGl0IGRvZXMNCj4gc2Vl
bSB0byBhdm9pZCB0aGUgIUNPUkVJRExFIHN0dWNrIHByb2JsZW0gc2VlbiBmcmVxdWVudGx5IG9u
IHRoZQ0KPiBib2FyZC4NCj4gDQoNCkhpIEpvaG4sDQoNClRoYXQgZXh0cmEgY2hlY2sgZm9yIE9U
RyBzdXBwb3J0IGlzIHVubmVjZXNzYXJ5IChhbmQgSSBiZWxpZXZlIGlzDQppbmNvcnJlY3QpLCBi
dXQgSSB3YW50ZWQgdG8gY29tcGxldGVseSBhbGxldmlhdGUgRmVsaXBlJ3MgY29uY2Vybi4gV2l0
aA0Kc3RhdGljIGhvc3Qtb25seS9kZXZpY2Utb25seSBEUkQgbW9kZSwgd2UgZG9uJ3QgY2FyZSBh
Ym91dCBPVEcgc2luY2UNClBydENhcERpciBpcyBub3Qgc2V0IHRvIE9URy4NCg0KVGhhbmtzIGZv
ciB0aGUgdGVzdC4gSSdsbCBtYWtlIHRoZSBmaXggYW5kIGRpc2N1c3MgZnVydGhlciB3aXRoIEZl
bGlwZQ0KaWYgbmVjZXNzYXJ5Lg0KDQpUaGFua3MsDQpUaGluaA0KDQo=
