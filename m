Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE755220BFB
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgGOLhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:37:53 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:14564 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729216AbgGOLhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594813072; x=1626349072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QtxFCgnDB8pDPlwHKx0tmTokXIslgG44XrutFyfxO8k=;
  b=OvsO0uamhXhzKI7l6qcfdAcZu+gmqO8h+JZKpugRe+X9sOpoBAukH6mr
   d10W+6O5P2iKGBqxuj5qmM6r9ccRXE9TxCM3jTvGl5naJIX9ipzn5f3MM
   AM7v3c6bimd2WsBTcT+pdXBL0rslR2m437BICGq0Nxba6X/3PTVjkPBTz
   KSFf98JqWHjnk5jkpe2BU+IT4It/bKvl9ShpznEyrM9tCAnuRqGfh0m1w
   cwFTQb8c7Poe3blHr4yFLkDXJRMNUbrw7KLLtjfj1gmUk5fs0NEQKBEEd
   Mr2Q5P6g1bHkfNQ+3tibmqDzb3G9j86se1vlM1K2ye9wPeNGYIlzELvQ8
   Q==;
IronPort-SDR: QZtvLUbCarJV3mgIG5FtIDfqRH4C8xfNjVbpEVOk1Zt/s5Dbj4Mwy1ohUBWPerkkHc4UVwvApe
 LL6VjTP4YxRZa08a5ov5KtDAPlxQBakr32l5/fhe4aV4W5vGTryVQtnwFML7DP/43FLW3Xxiy+
 /Lk1W+SkRifQ5TljSb4pK+QZ4c1J6R74O9UN8LaJtClPJKkHdSEuJbelO+jn34BVeKKKGprTec
 kfcNBugHyIJGtWb4KkrFVyc9hg+C6IYgFXEWS2Iea84owJeNW6JPW0Jqn+w5z+QG/yyRqXZbDA
 EKA=
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="83229431"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2020 04:37:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 04:37:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 15 Jul 2020 04:37:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Frpj3NaAaRQrqOk8Z1VbG21l+h0Y1SWQLv/Q6NYc6p/8fyLDReBWkSLdvRQt82QRAijC0Z2d2MGLnB0ZhA8yMuTLiBjRjQA2ICIwYHtLyvmwbSrnhUgBp0tdAZCZ4aBUJc8S8psIgqmaoEpIhmtKXrP6DP6JCWDmFijHzMvDtydjV5Ybkq8niYbqsZGhUUuuCdGt3stYrv3hbxvEfsZynrOpTrAOgpyzu8Ftw94HeT/DROPQOXeUAQkEg49dBJwX9Fq/5L07jQFH9DyBVBVtFv250YVlWarCA7hXr7Q7l/EsBQS5YpfwNeo3E/1AXMaUahCQDfDeC+hz57q8BhVuoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtxFCgnDB8pDPlwHKx0tmTokXIslgG44XrutFyfxO8k=;
 b=HzJTXV2aiZViqYaxN333C3ILYRE3EC1WidGZI2Ky0zsj8QzN/d24TvfJn9kp3eGKQIB7yNi0y0TZI11ymkRWsB58ksqh9OAaCVnVc2ATs9YzAZaS/7wfYpz7K9b66/wGuZBVGY/q5toPu8KI+2qRWJXvfj/hC8nvp/WhERxjd+Hnd4d7vHi8xu04X1VrtmrEhCg+s1Krxx9/XryVT7gaf5QsNMnZozn5X299MJfxtmQZ6FU2VllbkneJAbxceMYbx5hyvKYNGcbulngIcT/SC1Bp8E7Azj2Z/aBjpKMpK9VreyBMuFWaeMbHtkYMef/o30OMQEgz7fnzuI2yCoyQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtxFCgnDB8pDPlwHKx0tmTokXIslgG44XrutFyfxO8k=;
 b=q1n4V43lrXEt8zFf/dvf8rm4o4I2aLFT+o9TpjTDBLWKBz6qGJegRyiL77fMIGudgZkxj8RVg0t15h15R1c/mwrpz5UcullqUi+VZAB6ScqulFbH7RmRbL/Gx+YIjiSAwWeZr5eCzuvcENSodljfW6jD0ae2TpC+T6S5+VeJgeE=
Received: from DM6PR11MB2858.namprd11.prod.outlook.com (2603:10b6:5:bd::19) by
 DM6PR11MB3068.namprd11.prod.outlook.com (2603:10b6:5:6b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Wed, 15 Jul 2020 11:37:47 +0000
Received: from DM6PR11MB2858.namprd11.prod.outlook.com
 ([fe80::5103:7e0:4953:2aa0]) by DM6PR11MB2858.namprd11.prod.outlook.com
 ([fe80::5103:7e0:4953:2aa0%7]) with mapi id 15.20.3195.017; Wed, 15 Jul 2020
 11:37:47 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <gregkh@linuxfoundation.org>
CC:     <alexander.levin@microsoft.com>, <stable@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <hulkci@huawei.com>,
        <lkp@intel.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH 5.4] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Thread-Topic: [PATCH 5.4] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Thread-Index: AQHWWoNL06FGi8eWMUeyhKZmj6U6IakIXT0AgAAmdYA=
Date:   Wed, 15 Jul 2020 11:37:47 +0000
Message-ID: <d8246e0c-2948-c9d8-e4b0-fb3581ec5983@microchip.com>
References: <20200715083802.460760-1-tudor.ambarus@microchip.com>
 <20200715092008.GC2722864@kroah.com>
In-Reply-To: <20200715092008.GC2722864@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [86.122.210.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d89388bf-03ed-47ca-1fba-08d828b37f94
x-ms-traffictypediagnostic: DM6PR11MB3068:
x-microsoft-antispam-prvs: <DM6PR11MB3068C9FC6709CA43946FDFCFF07E0@DM6PR11MB3068.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Ke3Bg3fod9E1umBrRsEmpxlbbxvnBnulApVJM0UYMlQUnEv8KZa6sjzLMy7tNMcGQJZCSsI7eV88p2mv2Zm7YpiEzJCw61t7HgZTWUv+vFyitH1xBJL/LrJqO6wdGUua5f+WLUOXxln5bZRBB7220cap/wnUdsbAfkMUeaK7H1L23m2lxx2AVNZeCaGjTybRjg4ylgpE5yGBBaaqNImU53awkJ+uDIstndxMfBbYx12GJL070+qy+dJLOUQTt1RNHct4bkdSj3uTX/xsADLQuohPNv6BdMU7yG2s/aUkZlSQIO8SpyspbAHpWONOMQkHqZ94tLHAHN8085dc+5Qm8fEU+5L4xHA4ChlU5O8CTfzc5DMH5/adqNyLzefmVR3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2858.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(346002)(396003)(136003)(366004)(6486002)(2906002)(478600001)(54906003)(76116006)(4744005)(6506007)(91956017)(53546011)(31696002)(8676002)(86362001)(66556008)(64756008)(6512007)(186003)(316002)(5660300002)(31686004)(6916009)(4326008)(66946007)(66476007)(71200400001)(26005)(66446008)(2616005)(8936002)(36756003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hadQn/U7fDrBbuQdFznrxWMtbdL0hP51iq9ZTkC7eu+6b2peejc8pg83LUhuYI7hqW52SuJWkvN8eG+1TcZzZnE8rkPcyuETGsEoxYXBxByXdAbw4HfXbZJYv2ND7Xy6p2HWv5raenVldTAfpdwCnZWmKsq/fNZwSxZD3upjpZad3Xwvyr70je4s+Ycr597rerPvRRwOp94giBUZuQ5eVS+fK2B8PmbxTvW3dvJCUR+c/U6Krl69hU5A+7kI1chQJnUbWKMY3Mbfkauh+n4JIZEwZ08xnvXtf8ZW5cHYGHwtWF7FTKGRXNmh4Wdz+kLZ+L43nMv2p4/ihqxlSqxnNTWglQblUHEuvGG0gLgWt/8voxu5IaeUXLTqJQQ6DDYoMkNXfa5Z5r0GeSq5aUfCStJiDo9jq+9WUsLSZsvOnDUUDNZz6C83H1qEICAvViKoVYQmQrBUgiwcgA1J9SehLBuliiifjcE/50f0975b7BRJVYGxILnqMtGEdzFe6vQx
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <23E1E84DB35F9D4EBA083C0588A48647@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2858.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89388bf-03ed-47ca-1fba-08d828b37f94
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 11:37:47.6426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECXaDHPSI7McKhtGFGoR8k4lGGb3GGnrQcAu0AXdPSV9utRyZaJKxZoOGf0AnhzJzIYsyBcM6pWzZzqunYgxoPPHYUodLiWdo6SQdA+H61k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3068
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8xNS8yMCAxMjoyMCBQTSwgR3JlZyBLSCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUg
Y29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBXZWQsIEp1bCAxNSwgMjAyMCBhdCAxMTozODowMkFN
ICswMzAwLCBUdWRvciBBbWJhcnVzIHdyb3RlOg0KPj4gQmFja3BvcnQgdG8gNS40LjUyLXJjMSB0
aGUgZm9sbG93aW5nIGNvbW1pdHMgaW4gdXBzdHJlYW06DQo+PiBjb21taXQgYWVlMWY5ZjNjMzBl
MWUyMGU3Zjc0NzI5Y2VkNjFlYWM3ZDc0Y2E2OCB1cHN0cmVhbS4NCj4+IGNvbW1pdCBkMTU4MzY3
NjgyY2Q4MjJhY2E4MTE5NzFlOTg4YmU2YThkOGY2NzlmIHVwc3RyZWFtLg0KPiANCj4gUGxlYXNl
IGJhY2twb3J0IHRoZSBpbmRpdmlkdWFsIGNvbW1pdHMsIGRvIG5vdCBzcXVhc2ggdGhlbSB0b2dl
dGhlci4NCj4gVGhhdCB3YXkgbGllcyBwcm9ibGVtcyBhcyBpdCBpcyBoYXJkIHRvIHRyYWNrIGFu
ZCBhbG1vc3QgYWx3YXlzDQo+IGluY29ycmVjdC4NCj4gDQoNCmQxNTgzNjc2ODJjZDgyMmFjYTgx
MTk3MWU5ODhiZTZhOGQ4ZjY3OWYgYXR0ZW1wdGVkIHRvIGZpeCB0aGUgcHJvYmxlbSwNCmJ1dCBp
dCB3YXMganVzdCBwYXBlcmluZyBpdC4gVGhlIHJlYWwgZml4IGlzIGluDQphZWUxZjlmM2MzMGUx
ZTIwZTdmNzQ3MjljZWQ2MWVhYzdkNzRjYTY4LiBJIGtlcHQgcmVmZXJlbmNlcyB0byBib3RoDQpj
b21taXRzIGZvciB0cmFja2luZyByZWFzb25zLg0KDQpQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91
IHN0aWxsIHdhbnQgbWUgdG8gYmFja3BvcnQgYm90aCBpbiBkZWRpY2F0ZWQNCnBhdGNoZXMsIG9y
IG1heWJlIHRvIGp1c3QgZHJvcCB0aGUgcmVmZXJlbmNlIHRvDQpkMTU4MzY3NjgyY2Q4MjJhY2E4
MTE5NzFlOTg4YmU2YThkOGY2NzlmDQoNCkNoZWVycywNCnRhDQo=
