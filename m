Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED146361581
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhDOWcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:32:19 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:39590 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234764AbhDOWcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:32:19 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EC79E40E38;
        Thu, 15 Apr 2021 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618525915; bh=5IOGEqxX7LfrQsiz8Nykp2SsFUFQwdsmXbODglG2fOQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HE5Vu97doU9NpjJVdrlyL1iEcg5Kb1M6muxLFn9QWrrcqfAW08XUIxxwdUpcTaPFA
         0aobsCRY/j0KqzCr4dYrzoJzX/UHk4UWTQvTWJw4hbAz2pqd02qmscdRH+qraGH8Hw
         CmMJnXKJLvFGNdkC3WND0d2ZQDHB6snLeNOEbB8uqnu/HJ7ProCzGmZqoXaNYYiuyv
         uxVkUQ0splQADBCux05KNidiP6Qa/pS2Z68E1G4PZZWNMWpJS2PY8WgmZxdwp5QJUO
         m+/LV+BEdDRIPDJl/JQJp7INb95OtOtxaxvRPLx2Z/SbJePgEWvULlqAwHQX5fWk9t
         fcJU8sT7oOd8w==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 552FAA0070;
        Thu, 15 Apr 2021 22:31:54 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id CA9FA80129;
        Thu, 15 Apr 2021 22:31:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="LI/UPAkY";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lynIjk7kInBkBTYCg+3qKh6K5XaVHYwoTaLz/uaY2h5gYxjZIBS8fMlAOcyX8/cgAsP1qE6XQpcbe31HIgAYX7lrQNNIOemQULbtJCMWpbMgPOakHH/nIS8pJq2KpB6/dT7Nx+ylgsvXuUB4PnF0Hqayj7fN9AUBUduU8SZx20+tiENfuvbw6bCUnCs0Z82pAHaX3AIaFroGrDd6Km6aXrXwz7eebyhjXyyiN7qHzokdzrXS3Z5v78EyM6r3jJLqLZiAo2oLNjlHuOBBKWFBY3qhZ5Nm8naLL19e7LhjyiiqwBO4uBAQsr76OvSIx4gT4RFMsRdVGlJAop6frn/tFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IOGEqxX7LfrQsiz8Nykp2SsFUFQwdsmXbODglG2fOQ=;
 b=mhqlzjLJnNoJnxccM974RL5Lbiw+2X/fNlA1kPmxFKTuPR27bQs512+rmJS+jaxfWfURBg4cL+IrFOnRshtLnwAHEaQ9ZS0NiCrpe6WR5sPLUKFGpR9uZjiEoWS7TN2iqbDMj5qBL6GQLrvoVtu0qxb89eWgRafiAW28tJ5VdmtDpU1TGgPbgX84NFrqpagKZx/SdLXm5f3ZgP/4rx6+8tRIZ2HLBJHXSo9zOy1nUHczOLXqPzyqsN9orK+djpU1gPpUKX0ljHr05FZRbRea1c4d6IL3Kbi14fW95lQ3LR6s/DnP9Rmotib4zkhb2CvIpR8foL5QdI/BZEAL1vQKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IOGEqxX7LfrQsiz8Nykp2SsFUFQwdsmXbODglG2fOQ=;
 b=LI/UPAkYKikIeUlEAludfg65j2i/fz4TZKa1F/kL/HNilB6wSZi/KOXascxVzcR8d5r1p9n0r38EebaBHjQtiYJG1fT1FHjSDkg1u1YLb4y18pFR1L/DTyb1FUaJ9wO3EhIYOixo4hKYB+DA6M7nnXspmCA/noVhDpaPUU/Vukc=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB3637.namprd12.prod.outlook.com (2603:10b6:a03:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 15 Apr
 2021 22:31:51 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 22:31:51 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMZ5ZpPhhG1Y+NESFNK78+41CJ6q1HFYAgAANRoCAADv3AIAARpmAgAB+2AA=
Date:   Thu, 15 Apr 2021 22:31:51 +0000
Message-ID: <d762d529-5861-40b0-66f4-e44a704557c5@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
 <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
 <87h7k7omh5.fsf@kernel.org>
 <c0d385b8-a86a-f75b-00a0-7ce55738d99e@synopsys.com>
In-Reply-To: <c0d385b8-a86a-f75b-00a0-7ce55738d99e@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adda3061-a43d-41b3-3029-08d9005e4408
x-ms-traffictypediagnostic: BYAPR12MB3637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3637824D00B7AC7703D83446AA4D9@BYAPR12MB3637.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yFGkoZmKGYUFQ+yCgW0me3ySo582ZKUqoCf7ddBnErX3ubJyuR8GBV9WbAIyDQI/u7/MpXS/C/5w484tvtbrMC/d8UmfDN/mVEmblJ/7pmZNUoDRkRYg71vFjd2gFq9V7aDzBuAX+tTgF+TMNRBVB9JkTeg1jV1MRBNxFCI+4wxSm5hXuyxUV7qJkZPSunldDStiAYPI0Zslt8x8UaiihD1e8U4hMQAVTLvzQPFzYuZJtvWDTAbcAsUOsivVrFdwKed8HQ53Equ7gYnDlP0eO3UYpdg22HCUUL26DY+mDiufkA4hohId52gc75ciAsKk3P2Psc2ycrKQRvp5WyASCcbizAufHLrvc5wRsbpbKsfQvha8j6k3eYMv9tAEhwnCU3qyq69QeoVrd4ETdXCTepE5UI8ZSv2JFC1MKvR9kwjBBw4Ez6JhDC91FWkNHvP7+2MHQXGjVZJm+tgIEpT+CuDwfnGEp3tw6zWwKK3UC7obQv/axCABnkiYLzPNZRt4U5K9rudJwsj9TxXt13Jts00+JKfTF4vJ9R22HEfyQUpsxDPX1IjN6Qn1FhQpU143dj12Uaq/gc8un/2VogE98SXWW9Z1kAr08BnvYF6l+EF5U7T3wMrOYOWStKT6IGA3lbEYxgA0QeFYupF7WlKmXM1KxuW/h6mFj3e5XG/l3WlBd3LfjvnnsXwxIBcvmHSd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(39860400002)(366004)(5660300002)(76116006)(38100700002)(8676002)(4326008)(64756008)(7416002)(54906003)(6506007)(83380400001)(6486002)(71200400001)(31686004)(66946007)(8936002)(66556008)(31696002)(2906002)(36756003)(316002)(66476007)(110136005)(66446008)(6512007)(186003)(2616005)(478600001)(26005)(122000001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bFZyOWVUNXYwQTdkTzFoQ3J1MzNCc3VzdnJIdkhzU280YVNvQWFQRXZoOGp2?=
 =?utf-8?B?ZUZJS05MYUN5bkc4bUhDNHFJcHpXcWFFN1B6UTd6RHhRTUt6NTJQbjdWc09x?=
 =?utf-8?B?Z1pWLzVNcHh0eDdjZ1RnZXVaK0wwVTFNMkwzM1R3eExCNDlYYUtJRmhFL3Nr?=
 =?utf-8?B?dkNPbXpZWFprSUtUOEdoRXJMVnZwSFpreEhNckZSWlgwam9jc2pqL1lvWTFW?=
 =?utf-8?B?S2ZqVEsycTBzaUsrbFBod28zTFVhTWl4UnNEdlBScHNPdG1xMkRnemlPcEVS?=
 =?utf-8?B?VDltZDdwUGlqcUtpMmlETVBWUnhlRDFUY2xOcFJqN3RaRWswZGRaSmVzdkxR?=
 =?utf-8?B?bjVnUFRQZlpUU0M3eTlMcm9YTGRMM3lwcTdaVVk3QmptVGxFcUp1cUs0TjRR?=
 =?utf-8?B?Y0VseW9LaGZQNTJjeFZ0dGYxa0Z1d3JTOGUza2pOSFNQY0Q3K1JYNzRmNHBW?=
 =?utf-8?B?Uk1mbDlmY042KzJ5cUgxSW9KRkhEdFNtZ2FJZnRWVEk1WDRmZ0xMQUdWMUFL?=
 =?utf-8?B?OVIrMHBhakhFV3JFTzhiRVkrTHhnRXN6VVdnQTRnWmdYTUlhQUhodXQwWkhq?=
 =?utf-8?B?N0cyWUdxQ0x5ajVqampCYkZ0MDJCTUV2VFdzcVl4dUtqdEZQU0pYNGVXUUpo?=
 =?utf-8?B?T29xcTA4UWlGelFzTUpvSGtQQTdrdHBCd3dFTWlLcHdTc21vS28ycUt1OTM5?=
 =?utf-8?B?d1pMZGg1TmoyT3NaUTlVdlRXa0R5cWNyVTVlTVRUWFNHOGtTcXRZWUFKTWFt?=
 =?utf-8?B?WDJ6cXNrdldnemZvdGQ2enREMnpqeDRZVUduR0pTOW42UEI0YlM3Y3VlVmxU?=
 =?utf-8?B?WnozRzJuRmpuNElMRGtnL0lTL1M3NkZxRmhGNWN1K3pWSUFzd1B3alV2ZkRt?=
 =?utf-8?B?aTlxYlZDRlRwVzJKL0JYVmc3NCtaQUJaZmtOcmJNendmbzNHWWVtTVNVSzFo?=
 =?utf-8?B?K2ttMmZ2OFlwNzAwZThJbFY0TXBqU3Y3T0NLb1BhblhkblpWSmZTR3diSnFl?=
 =?utf-8?B?RzJxYitlZ3IxOWRPamNjakR0aDBjZEltS3NQL1gzOE0xSWtXeXZ4ZHlVT3hi?=
 =?utf-8?B?dzZDVitmS09kYVdEQ3A2V3lNWW1pOE02V2tPd1oxK0FBMnFGSnlveEZvc25t?=
 =?utf-8?B?M2RmU1dKcmgyc2Y2Z1JzbFFkM1U4LzByRG9tTGcrZURXUERmSHpyNTRjSE9I?=
 =?utf-8?B?UDJYVVlFT3FPS3E4SCthczBEZWdHNmVvbWMzMGhSN3JrWVI5SHZZK0U4WG5T?=
 =?utf-8?B?M0NVRFY5L2l0VFdOVEFTMlhvT1RvT1dhVEwrVk5NcDRiQU5PM0JRMXhwZExj?=
 =?utf-8?B?NmowYm43cmxLenNqbHA5TzExNmV0aEg1alJiSXVNVGdTZWJYcFRYYlVpN3VZ?=
 =?utf-8?B?ZC93dGU2dW5CZHd4aXZDSDdTZklLLy83MVBmcjZ3NEozeXJyR2NNcHZkTG55?=
 =?utf-8?B?V3BSbWZLc0FKZWJtLzRNeG9acWlIWUNCQTFMK0t3MkVIQWthNElqZCtENWYx?=
 =?utf-8?B?UTR4Mkh3cXZBQU40SEF2aGF2Z2hFdnVOTmtKVDBLaEt1TFAxa0NVN2tPekF0?=
 =?utf-8?B?UmZxWHFMMXhvdVMydEozOHNZb1JSWTBPZ2RUNTlrQVdVOUpnVHlvcmtybFJi?=
 =?utf-8?B?MWkyWk5TTE0wRHJxUW9vNUI0c2dManJsbDhSdEVvYVEyeXF1MDJGRnY0WVBq?=
 =?utf-8?B?VThGd1EwUUMwbUFkU2pKWXNMb0NFN1FrdER6dWhub21Ma1lhck9QR1Vobk1q?=
 =?utf-8?Q?ceHHMXIldFd4jv/ihNDSZRqr8Epf17wY9Oi+7Du?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B48401518AC2345B0F5AFDE1861BC08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adda3061-a43d-41b3-3029-08d9005e4408
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 22:31:51.6169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDPujVmXKZ7RqMPRLt3zStxlarCcDnYsZSNOHEc1CfjyIgEChSquQzckQkJNEgp17o0MjlSL7aPJg0kXIUN3cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3637
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+IEZlbGlwZSBCYWxiaSB3cm90ZToN
Cj4+DQo+PiBIaSwNCj4+DQo+PiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5j
b20+IHdyaXRlczoNCj4+Pj4gVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29t
PiB3cml0ZXM6DQo+Pj4+PiBGcm9tOiBZdSBDaGVuIDxjaGVueXU1NkBodWF3ZWkuY29tPg0KPj4+
Pj4gRnJvbTogSm9obiBTdHVsdHogPGpvaG4uc3R1bHR6QGxpbmFyby5vcmc+DQo+Pj4+Pg0KPj4+
Pj4gQWNjb3JkaW5nIHRvIHRoZSBwcm9ncmFtbWluZyBndWlkZSwgdG8gc3dpdGNoIG1vZGUgZm9y
IERSRCBjb250cm9sbGVyLA0KPj4+Pj4gdGhlIGRyaXZlciBuZWVkcyB0byBkbyB0aGUgZm9sbG93
aW5nLg0KPj4+Pj4NCj4+Pj4+IFRvIHN3aXRjaCBmcm9tIGRldmljZSB0byBob3N0Og0KPj4+Pj4g
MS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwuQ29yZVNvZnRSZXNldA0KPj4+Pj4gMi4gU2V0
IEdDVEwuUHJ0Q2FwRGlyKGhvc3QgbW9kZSkNCj4+Pj4+IDMuIFJlc2V0IHRoZSBob3N0IHdpdGgg
VVNCQ01ELkhDUkVTRVQNCj4+Pj4+IDQuIFRoZW4gZm9sbG93IHVwIHdpdGggdGhlIGluaXRpYWxp
emluZyBob3N0IHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4+Pj4NCj4+Pj4+IFRvIHN3aXRjaCBmcm9t
IGhvc3QgdG8gZGV2aWNlOg0KPj4+Pj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwuQ29y
ZVNvZnRSZXNldA0KPj4+Pj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGRldmljZSBtb2RlKQ0KPj4+
Pj4gMy4gUmVzZXQgdGhlIGRldmljZSB3aXRoIERDVEwuQ1NmdFJzdA0KPj4+Pj4gNC4gVGhlbiBm
b2xsb3cgdXAgd2l0aCB0aGUgaW5pdGlhbGl6aW5nIHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4+Pj4N
Cj4+Pj4+IEN1cnJlbnRseSB3ZSdyZSBtaXNzaW5nIHN0ZXAgMSkgdG8gZG8gR0NUTC5Db3JlU29m
dFJlc2V0IGFuZCBzdGVwIDMpIG9mDQo+Pj4+DQo+Pj4+IHdlJ3JlIG5vdCByZWFsbHkgbWlzc2lu
ZywgaXQgd2FzIGEgZGVsaWJlcmF0ZSBjaG9pY2UgOi0pIFRoZSBvbmx5IHJlYXNvbg0KPj4+PiB3
aHkgd2UgbmVlZCB0aGUgc29mdCByZXNldCBpcyBiZWNhdXNlIGhvc3QgYW5kIGdhZGdldCByZWdp
c3RlcnMgbWFwIHRvDQo+Pj4+IHRoZSBzYW1lIHBoeXNpY2FsIHNwYWNlIHdpdGhpbiBkd2MzIGNv
cmUuIElmIHdlIGNhY2hlIGFuZCByZXN0b3JlIHRoZQ0KPj4+PiBhZmZlY3RlZCByZWdpc3RlcnMs
IHdlJ3JlIGdvb2QgOy0pDQo+Pj4NCj4+PiBJdCdzIHBhcnQgb2YgdGhlIHByb2dyYW1taW5nIG1v
ZGVsLiBJJ3ZlIGFscmVhZHkgZGlzY3Vzc2VkIHdpdGggaW50ZXJuYWwNCj4+PiBSVEwgZGVzaWdu
ZXJzLiBUaGlzIGlzIG5lZWRlZCwgYW5kIEkndmUgcHJvdmlkZWQgdGhlIGRpc2N1c3Npb24gd2Ug
aGFkDQo+Pj4gcHJpb3IgYWxzby4gV2UgaGF2ZSBzZXZlcmFsIGRpZmZlcmVudCBkZXZpY2VzIGlu
IHRoZSB3aWxkIHRoYXQgbmVlZA0KPj4+IHRoaXMuIFdoYXQgaXMgdGhlIGNvbmNlcm4/DQo+Pg0K
Pj4gVGltaW5nIDotKSBJZiBhbnlvbmUgd2FudHMgdG8gc3VwcG9ydCBPVEcgc3BlYywgaXQnbGwg
YmUgc3VwZXIgaGFyZCB0bw0KPj4gZ3VhcmFudGVlIHRoZSB0aW1pbmcgbWFuZGF0ZWQgYnkgdGhl
IHNwZWMgaWYgd2UgaGF2ZSB0byBnbyB0aHJvdWdoIGZ1bGwNCj4+IHJlc2V0Lg0KPiANCj4gVGhp
cyBpcyBmb3IgRFJEIG9ubHkuIEl0IHNob3VsZCBub3QgaW1wYWN0IHRoZSBvbGQgT1RHIGZsb3cu
IFdlIGFscmVhZHkNCj4gaGF2ZSB0aGUgY2hlY2sgaW4gcGxhY2UuDQo+IA0KSSB0aG91Z2h0IEkg
Y2hlY2tlZCBmb3IgT1RHLCBidXQgSSBtaXNzZWQgaXQuIEkgdGhpbmsgdjMgc2hvdWxkIGNvdmVy
IGl0Lg0KDQpUaGFua3MsDQpUaGluaA0K
