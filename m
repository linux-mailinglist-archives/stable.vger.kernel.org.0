Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F108360D55
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhDOPBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:36 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48936 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234324AbhDOO6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 10:58:21 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C68A940CB9;
        Thu, 15 Apr 2021 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618498677; bh=PqeeToDwlzjHYel+chGRCLwUacY+xs3K+Ha3PIuoLUE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kUBT0YuZTWdLG6bkmiuLr3cJNrsmYwJcQ+xBhaK8703IbBVSfWjTsZ+uwPrhQec2d
         q6LlbnECYE9beeyMWsjYPclAu8yWG8srfiP/yJfH1BHsTb1koaVMRtuO6WTKQZBAFV
         AYochkf40Q/O9vr1k6nRxRvGS2lqUFFQOUy+exLYrPmULWrtia9tQyd71ZiCjkKH3/
         dmoBvKZ6EReRnOAEPNRtFY25bVYm/UPoJe2ukmAKkwnp8PC7O17VgbHD1EqWYVqK22
         LYpMc45XVIkVE3QoPr3XrOXqmLArWph66WQX84b6iByVr3byTqP5+za3gUWaQf2Pk5
         A/DgNftXE/JDw==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E36B4A005E;
        Thu, 15 Apr 2021 14:57:55 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id D82C2800C1;
        Thu, 15 Apr 2021 14:57:54 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="lZeqMTb8";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nW9Ci0mn4QLx1ghQdYusxZBBjxJ66V1kWKBlOh9oxSWcEcBl0bsSBtzhdevI2qfR2Ot0guHbJ0TdQdd5LTnbYsiaCvJqJJwHeztpku/hg4r7mznDIsq+1BSpOzLwQEM6IylReC79BqnLZnhi7G6JSQfBo06Kqf+EBofaxm5gp47kj9Sjp2okPHCrgRDpSh07QB0uDnc/vadWw+ACm1UDRS4JIGvURMqXNVWgdM3S3XU8qBABH4i1U30eZq9itXsSVqjtnwJNlpgHuj2Xd0SNKWwqRq66aKmE8CNJ20PFNbhIhcdSk5qxbGApVZXD4pDTDXDsPO2jCSmm6TPJmO+ueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqeeToDwlzjHYel+chGRCLwUacY+xs3K+Ha3PIuoLUE=;
 b=mL2kJMveD15CHe3FzyLU9ucOd6OKXe2oOviTaiqCcYZ+E6i0fthM7VFR+K0fkQLtvEnVaDmK3pO22orCYFxFFLmsMAHjcpvNwTVuJIexDxqjtqoQ74ToccrQcWr+TnURJTfiSFYZ+qRQFnNgS0V9CD1gc52NrhotrWBwGv9sj/r2QCp/Q3ybHaQa+0YDAdhgDD7opKJfutdC+LbaQxSldnGv/cbnhTgxFrXp5OkGPEtygsfrWnazit71A7UCikgukxzxzboufXgBjiAXFnbw7YpZ0JSmr24EPaginy05gs7xQaSLz+/n/aMlnDEJIlZ8Ds93vEiZVqwxQz5VX9Vbsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqeeToDwlzjHYel+chGRCLwUacY+xs3K+Ha3PIuoLUE=;
 b=lZeqMTb8b+j2OtM8m/tmHLzxaHQQWp84uVTrx8u8W7Hk4SiNhqDNBZEA4kskvUaoe59Oab7YCkWEPh8Jp67lF3YlkuDaDOuSrp19qUlaX456GAV27AtTJ6Q/31Zl6LnshfT8oxSMLQYlSoZtUTHcAJu+XreZtGfrqaFZ2wNOGME=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB3857.namprd12.prod.outlook.com (2603:10b6:a03:196::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 14:57:52 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 14:57:52 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
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
Thread-Index: AQHXMZ5ZpPhhG1Y+NESFNK78+41CJ6q1HFYAgAANRoCAADv3AIAARpmA
Date:   Thu, 15 Apr 2021 14:57:52 +0000
Message-ID: <c0d385b8-a86a-f75b-00a0-7ce55738d99e@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
 <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
 <87h7k7omh5.fsf@kernel.org>
In-Reply-To: <87h7k7omh5.fsf@kernel.org>
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
x-ms-office365-filtering-correlation-id: ceff46a7-22a3-4739-409c-08d9001ed838
x-ms-traffictypediagnostic: BY5PR12MB3857:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB38579BBF10CC82FD1521CE5BAA4D9@BY5PR12MB3857.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O35+/lwS2DKfhBPw3qubLjdPfe8O4gB6UqcR5ObLuc8IKnIkIvy7V+JUM5UT5gQ1a7Q2ldnEQ7OVJ7h9EpbN/hxtHtXq2dlSSlDwpKpXt6zXr6az2Qm8gIJXaNvKn5PMoEeHlLeiPilQQs2pzjmslCT4m0vT6erdZ8cCLtS++wV6VB/YldqMtxvQlOi2FKz4Rjz3YI3qfqlMr2iQkeGLQFi0xSOvLy3tn43/uyDSa8XpoTWmbCyom2KMKeV6H8DJzltAvGm/xRom4rzRzFjF08sx6aGNKqfUKdekRv0piZo1Mjbr4VcfqHn+210kcX6p/nMAiJSb4M9Pyeo9Ez7Vb7NlK3km9OybZg6SQD9RrtIdYKtUayjtRXFYI7y8xBZDwKq2pt7jVp2P3ZG9nQ3sa8wusIe4lhMhJps9JfkSPvlQ6IPc3K57pHSRkmCp8E8t8NoELBxJBjLRUBHCP7TjULSTex3vRiYSfQNxWpffsDUsAEOVloz3OK3ZsLDAn9w6H6GLy9g2mpB5/eDzwQqF6sLzEIDNer91z1PQOZTJyR81va2tI+M5VzSxTFsLnY80PKr9Qmg2x6ihO05RcGFBsKlRi4OwbqLlW9s4ZMx4BYhrVeKdIbHsoysmNkPCw6tgzCh2otcia6HHHGrlEa+KZxWR8C/3vaFsTM61fTzfWmyyBrp4HYvTC6wMQ140OPqs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39850400004)(136003)(366004)(346002)(5660300002)(122000001)(186003)(2906002)(31686004)(86362001)(110136005)(8936002)(8676002)(36756003)(76116006)(7416002)(66446008)(54906003)(38100700002)(2616005)(66556008)(26005)(64756008)(6486002)(6512007)(478600001)(316002)(6506007)(66946007)(83380400001)(66476007)(4326008)(71200400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cTNxTld5SU8xWHJYRUpSODYrN3VmTUlHbEw2dFh1KzFGRDZ5aGgzYWNBZ0U4?=
 =?utf-8?B?MDY4ZVpNVUQ5UmpFWTQ5N2g2MkhKVXlHdm54eEpoaTdhQWpDNDczQitZc1BW?=
 =?utf-8?B?bkpuNDAyZG9vaDBaSjRFdUhMYTdsMjAxSjAxdWRzdUFLYWtlWjRSZHRSK3Fq?=
 =?utf-8?B?L3gzNzAzbmxkMmxZY2lHUTBmWFNJcG1FVVRHMS8rR256YUZGejdndE1lRnMv?=
 =?utf-8?B?akt0U2p6RzZSbTVsZjlubjhHVi9ZRHBUY2hSL3owYm54R1p0N0ZxeHRaTENt?=
 =?utf-8?B?dFpqZDV0TTdIeGR6eG9xT2p5TVdGRFYyVXJ6c0lLZDMvZWdocURmb01vRHNl?=
 =?utf-8?B?MWlnNFp6ME8vY2lnMEtvd1RwanZZTWJkdVVkZDFjQnZQU1Z4S2M3SHUzZjY4?=
 =?utf-8?B?Q3hRUmNuempaL3F0Vnk2NFZqOGcwNmxqWVhEVzRDQ1NVdHpMK25LeHA4QWNa?=
 =?utf-8?B?bmpobERNcFQ4UHU2UTlwaUNBRFZsV3hlVXZ4R2Z0bEdWdGxOZEpzOXlTSXR0?=
 =?utf-8?B?N2poUm9ERElyZ3prbVppK3VJdGltRXA2OWNONS8zR05QSTJsby93TFlxMi9y?=
 =?utf-8?B?QUZ6Tkd4cm94bkZ0REhCL1RIdEhvQnhIU2JYWmNsTWVXNUdrTW0wZEdHalA4?=
 =?utf-8?B?SlQ4ek9aalhva05oSjQ4cUlxTGUxZjVQcGpGcjdseDdkbEwxZU1QQTlBam1x?=
 =?utf-8?B?ZzcrRGFIZFN2bjRtWitydUVWZzBqSHpuNlpQUCsxL0hXT0psb1NncjNmNUlo?=
 =?utf-8?B?bTlOVFVqd0xNdHAwdkhnNXZPYkJkOUFGSnpoQTBBdW93aEp0MG9rNUNJZ1Nu?=
 =?utf-8?B?TjNhZE8yZUh2dG9XYnU2SXZENXdMR3Yxb1VTZTh3NlFQbExTeFBLRmoxYUJl?=
 =?utf-8?B?WGJBa2YxelRIdzZGcVFVajVMUnBXT3ZsSkcrWmU5WGFBVnBnT21YTURtWEJx?=
 =?utf-8?B?djgxbjJxd21CWVNLUVY3cGRRKzBhS3NaSjdzaWhjcUZSTzR2WHpvNzdDejVn?=
 =?utf-8?B?dGZIT0tmQS83dExNdk9XcURSSXZCY0dUa0NBSkY3eU92OVY1SHYwcUhVRnk5?=
 =?utf-8?B?UWFZT2RNWTBaZG8yR1VucVNveEdXakl4OVl4VFBaVW56MEVmUWVua2V6Qjcr?=
 =?utf-8?B?dCtNSG1hajBCemtNUVJHUzZXc3o2Zkk1NURGaTRVTEN1Q3dlQ0lrcmp4TG15?=
 =?utf-8?B?bjdKQ0U1c3cveWlWNEh3bVZxNmVmV3M1cjk0elRaL2ViYzNZM05hTWZTK2dN?=
 =?utf-8?B?b3ZBZ3Vjb1UxRzR5bUIxSktIMXprc1ZCWXNiR0tjVG54QnJxTG1JbFRqdVZD?=
 =?utf-8?B?b2FLcmRwRzdITTlGcDNWTWNEN3FLdGxhbmpUbDF5NGpZalE5ZDJ5cVhoalF2?=
 =?utf-8?B?c3k4VWw5aHJ1NWw2OFpQcW03YlJPWTZHZ0ExNDF0YmFPa0d0aG5UelFKTU9B?=
 =?utf-8?B?MDdmVERETkRFeUdncU8zK29Vd3RVa2dkVlhlN2MyZnM2ZUZIaVBCOXNNUUVr?=
 =?utf-8?B?RjhDRXdhS3pMSld1bzg0UWFGUVJ4VjdjVW40clJnNzVZZ0V3Wkp1T2pEb003?=
 =?utf-8?B?Snh1MWRIUElUNUtidWhGMzFGV2ZyUkJTWU5RVlovaHdxd3N2WUlqeEtqTU9V?=
 =?utf-8?B?N1ZvM1Z2Ri9TbzBFOWo0RWh6aC9IcjVsa0NJdDRuOGE1Y1o0dHY5eDV0NGVv?=
 =?utf-8?B?UWhrZFJmNEFpRXdudFpNNEQ4ckFoZklRUU9rTUxKVHI5VXFPREhHd0MzeWNI?=
 =?utf-8?Q?2rDbPG4P55UPFoh+EQ2kctSFllvKRi0+YaWP07t?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CE6A965750018419DC511AA5DBADC32@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceff46a7-22a3-4739-409c-08d9001ed838
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 14:57:52.3541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YuSKcPbI51lxin8xPT/wKxTndBjh2wjuxGZ8/BQPB3+EcYxZfnQYPzzHjXDeHmggpCcWs9ufnFLrhM49NcCq6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3857
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBUaGluaCBOZ3V5ZW4gPFRoaW5o
Lk5ndXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+PiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5n
dXllbkBzeW5vcHN5cy5jb20+IHdyaXRlczoNCj4+Pj4gRnJvbTogWXUgQ2hlbiA8Y2hlbnl1NTZA
aHVhd2VpLmNvbT4NCj4+Pj4gRnJvbTogSm9obiBTdHVsdHogPGpvaG4uc3R1bHR6QGxpbmFyby5v
cmc+DQo+Pj4+DQo+Pj4+IEFjY29yZGluZyB0byB0aGUgcHJvZ3JhbW1pbmcgZ3VpZGUsIHRvIHN3
aXRjaCBtb2RlIGZvciBEUkQgY29udHJvbGxlciwNCj4+Pj4gdGhlIGRyaXZlciBuZWVkcyB0byBk
byB0aGUgZm9sbG93aW5nLg0KPj4+Pg0KPj4+PiBUbyBzd2l0Y2ggZnJvbSBkZXZpY2UgdG8gaG9z
dDoNCj4+Pj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwuQ29yZVNvZnRSZXNldA0KPj4+
PiAyLiBTZXQgR0NUTC5QcnRDYXBEaXIoaG9zdCBtb2RlKQ0KPj4+PiAzLiBSZXNldCB0aGUgaG9z
dCB3aXRoIFVTQkNNRC5IQ1JFU0VUDQo+Pj4+IDQuIFRoZW4gZm9sbG93IHVwIHdpdGggdGhlIGlu
aXRpYWxpemluZyBob3N0IHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4+Pg0KPj4+PiBUbyBzd2l0Y2gg
ZnJvbSBob3N0IHRvIGRldmljZToNCj4+Pj4gMS4gUmVzZXQgY29udHJvbGxlciB3aXRoIEdDVEwu
Q29yZVNvZnRSZXNldA0KPj4+PiAyLiBTZXQgR0NUTC5QcnRDYXBEaXIoZGV2aWNlIG1vZGUpDQo+
Pj4+IDMuIFJlc2V0IHRoZSBkZXZpY2Ugd2l0aCBEQ1RMLkNTZnRSc3QNCj4+Pj4gNC4gVGhlbiBm
b2xsb3cgdXAgd2l0aCB0aGUgaW5pdGlhbGl6aW5nIHJlZ2lzdGVycyBzZXF1ZW5jZQ0KPj4+Pg0K
Pj4+PiBDdXJyZW50bHkgd2UncmUgbWlzc2luZyBzdGVwIDEpIHRvIGRvIEdDVEwuQ29yZVNvZnRS
ZXNldCBhbmQgc3RlcCAzKSBvZg0KPj4+DQo+Pj4gd2UncmUgbm90IHJlYWxseSBtaXNzaW5nLCBp
dCB3YXMgYSBkZWxpYmVyYXRlIGNob2ljZSA6LSkgVGhlIG9ubHkgcmVhc29uDQo+Pj4gd2h5IHdl
IG5lZWQgdGhlIHNvZnQgcmVzZXQgaXMgYmVjYXVzZSBob3N0IGFuZCBnYWRnZXQgcmVnaXN0ZXJz
IG1hcCB0bw0KPj4+IHRoZSBzYW1lIHBoeXNpY2FsIHNwYWNlIHdpdGhpbiBkd2MzIGNvcmUuIElm
IHdlIGNhY2hlIGFuZCByZXN0b3JlIHRoZQ0KPj4+IGFmZmVjdGVkIHJlZ2lzdGVycywgd2UncmUg
Z29vZCA7LSkNCj4+DQo+PiBJdCdzIHBhcnQgb2YgdGhlIHByb2dyYW1taW5nIG1vZGVsLiBJJ3Zl
IGFscmVhZHkgZGlzY3Vzc2VkIHdpdGggaW50ZXJuYWwNCj4+IFJUTCBkZXNpZ25lcnMuIFRoaXMg
aXMgbmVlZGVkLCBhbmQgSSd2ZSBwcm92aWRlZCB0aGUgZGlzY3Vzc2lvbiB3ZSBoYWQNCj4+IHBy
aW9yIGFsc28uIFdlIGhhdmUgc2V2ZXJhbCBkaWZmZXJlbnQgZGV2aWNlcyBpbiB0aGUgd2lsZCB0
aGF0IG5lZWQNCj4+IHRoaXMuIFdoYXQgaXMgdGhlIGNvbmNlcm4/DQo+IA0KPiBUaW1pbmcgOi0p
IElmIGFueW9uZSB3YW50cyB0byBzdXBwb3J0IE9URyBzcGVjLCBpdCdsbCBiZSBzdXBlciBoYXJk
IHRvDQo+IGd1YXJhbnRlZSB0aGUgdGltaW5nIG1hbmRhdGVkIGJ5IHRoZSBzcGVjIGlmIHdlIGhh
dmUgdG8gZ28gdGhyb3VnaCBmdWxsDQo+IHJlc2V0Lg0KDQpUaGlzIGlzIGZvciBEUkQgb25seS4g
SXQgc2hvdWxkIG5vdCBpbXBhY3QgdGhlIG9sZCBPVEcgZmxvdy4gV2UgYWxyZWFkeQ0KaGF2ZSB0
aGUgY2hlY2sgaW4gcGxhY2UuDQoNCj4gDQo+Pj4gSU1ITywgdGhhdCdzIGEgYmV0dGVyIGNvbXBy
b21pc2UgdGhhbiBkb2luZyBhIGZ1bGwgc29mdCByZXNldC4NCj4+Pg0KPj4+PiBAQCAtNDAsNiAr
NDEsOCBAQA0KPj4+PiAgDQo+Pj4+ICAjZGVmaW5lIERXQzNfREVGQVVMVF9BVVRPU1VTUEVORF9E
RUxBWQk1MDAwIC8qIG1zICovDQo+Pj4+ICANCj4+Pj4gK3N0YXRpYyBERUZJTkVfTVVURVgobW9k
ZV9zd2l0Y2hfbG9jayk7DQo+Pj4NCj4+PiB0aGVyZSBhcmUgc2V2ZXJhbCBwbGF0Zm9ybXMgd2hp
Y2ggbW9yZSB0aGFuIG9uZSBEV0MzIGluc3RhbmNlLiBTdXJlIHRoaXMNCj4+PiB3b24ndCBicmVh
ayBvbiBzdWNoIHN5c3RlbXM/DQo+Pj4NCj4+DQo+PiBIb3c/IEFtIEkgbWlzc2luZyBzb21ldGhp
bmc/IFBsZWFzZSBsZXQgbWUga25vdyBzbyBJIGNhbiBtYWtlIHRoZSBjaGFuZ2UuDQo+IA0KPiBB
Z2FpbiB0aW1pbmcgOi0pDQo+IA0KPiBJbnN0YW5jZSAwIHN3YXBzIHJvbGUgYW5kIGluc3RhbmNl
IDEgc3dhcHMgcmlnaHQgYWZ0ZXIuIEluc3RhbmNlIDEgd2lsbA0KPiBiZSB3YWl0aW5nIGZvciB0
aGUgbXV0ZXggaGVsZCBieSBpbnN0YW5jZSAwLg0KPiANCg0KSXQgc2hvdWxkIG5vdCBicmVhayBE
UkQgZGV2aWNlcywgYW5kIHVubGVzcyB3ZSBoYXZlIDEwKyBpbnN0YW5jZXMNCnN3YXBwaW5nIGF0
IG9uY2UsIGl0IHNob3VsZG4ndCBiZSBhIG5vdGljZWFibGUgaW1wYWN0LiBSZWdhcmRsZXNzLCBJ
DQp1bmRlcnN0YW5kIHRoZSBjb25jZXJuIGFuZCBJJ2xsIG1ha2UgYSBjaGFuZ2UgYXMgbWVudGlv
bmVkIGluIG15IHJlcGx5DQp0byBHcmVnLg0KDQpUaGFua3MsDQpUaGluaA0KDQo=
