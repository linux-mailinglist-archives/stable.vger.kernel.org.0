Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F66250E38A
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiDYOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240232AbiDYOq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 10:46:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F513DDF2;
        Mon, 25 Apr 2022 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650897832; x=1682433832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wsEv4dzxnJYTXfJmSfbdk11o9SJckGI2jKF0RIVBLLE=;
  b=F2Fd8NOlyh3GAhLqdz6ZtYUmuDHAhXmxTOz0jkUnThHeOUGONILZRr0N
   xTcXFSYVPrqop73pubYg5OSOrrc6OJXJoIkcxASG9sgvFlAKtcNVWQmdo
   nor24RBJbF8pTXvgOCNELvE1LvqX8BQMxI6Q+6jG58HJGcwFmTUIQLAZN
   1fHQUep2KYRMQ8XFdWUZtHfLQ9/80HjW+tqkFFXEDKbL80oiZ7I1HTrsd
   C8TNZ+LXkWvPpoo82uscyXQEY2/bdQ0tLqayhB484+sERMFPCsmh9kPJk
   jRVsajv9L1GgXQKi8jD9cDYZM/+1EyNAhbwUFXRxbxxdszA4r0h0JxFrT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="290404198"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="290404198"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 07:43:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="564115672"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 25 Apr 2022 07:43:51 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 07:43:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 07:43:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 07:43:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwlWNKAYZHjIuqcGV0VG9H0KLPP5n3IYzsacuUFNoMDqBrSq6/FRQyMAfsn5htr7QPlfyguLcx3D5lHJRdBdwbmJbepfOt6IjG9v5xIOiCgFtDLKZCdd/tGMCFfsUm1dKpagxXMr5oXtsGuEEIs0yVOCoxn+tAoCKS82igOrE+30+TWZAJ4EwlR5r2PEuND+2Fot3mXOkvZjSQH5f0L5G8nmu1q5ekhtZjxVUnuGywtqUExze56xOQV3OuqvnO0IntMqD93HsAiuziyVr8LvoMh6dP0eMi/nI/iJZzjl9yqlBog7Y2Da9ZagQRSspcWPog5Ad6yvnj5LstFd7f6VsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsEv4dzxnJYTXfJmSfbdk11o9SJckGI2jKF0RIVBLLE=;
 b=fmn/VapVKAgmUWtcmG0rXgHopRUMz8VTvMri8KU0EFoOwxethigSmLn+rWRwZmIxmIyHFi6H9YMep0IU8eLEbgVXp1ExqhKKRmzC4nq1qZMN+ayj9usgPr2ctn2M+7tqwcrVILyQ9PR0EdcI7DARga3KJiM9zA1U6jbuD1Dd5bNCU+Nz+AnSSSHF358EnS070VNzjfYSHicGWLG0j7Z1XvbmIEw/O1xqhCFe7Hqdd+jI77Kfe+ZpkHMXdbvOFWfyNQebAJCW81ip5WfNV3NjkD3nyTY7U6HjcuVFArVnFM1EXxQIOTiiYfkXeJwng+Maorg1NlDQlcxoO+4+7BHHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by MWHPR11MB1453.namprd11.prod.outlook.com (2603:10b6:301:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 14:43:48 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::f0ad:94c3:5f16:3c2f]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::f0ad:94c3:5f16:3c2f%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 14:43:48 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "Murphy, Paul J" <paul.j.murphy@intel.com>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "bryan.odonoghue@linaro.org" <bryan.odonoghue@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
CC:     "hfink@snap.com" <hfink@snap.com>,
        "robert.foss@linaro.org" <robert.foss@linaro.org>,
        "vladimir.zapolskiy@linaro.org" <vladimir.zapolskiy@linaro.org>,
        "dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jgrahsl@snap.com" <jgrahsl@snap.com>
Subject: Re: [PATCH v5 2/4] media: i2c: imx412: Fix power_off ordering
Thread-Topic: [PATCH v5 2/4] media: i2c: imx412: Fix power_off ordering
Thread-Index: AQHYUMBbSQh/AqTxXUCSEwAAnLsdXq0AxDsA
Date:   Mon, 25 Apr 2022 14:43:48 +0000
Message-ID: <4875c1f26d3978ad499b04bc08f9f8aebfcdc320.camel@intel.com>
References: <20220415115954.1649217-1-bryan.odonoghue@linaro.org>
         <20220415115954.1649217-3-bryan.odonoghue@linaro.org>
In-Reply-To: <20220415115954.1649217-3-bryan.odonoghue@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-3.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b4b934c-7b06-4899-f204-08da26ca01fe
x-ms-traffictypediagnostic: MWHPR11MB1453:EE_
x-microsoft-antispam-prvs: <MWHPR11MB145384AC26D1566D15EE1D1BF2F89@MWHPR11MB1453.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFoM1SphT1sgYYn1thHmxq28YvlN1x84pFrfJhVvOssafZL+I+D+G6FvrwdiCyHqiUgZWJLCZ7a2mc/uj8HQhOp1DFRGjOiLawlDfOYGowxH5xxwFajbcU8tUIsIS8/jUJmFVaF/fsEye5A31drhzIi/w9tZNrIFq++wrzQMWeEhRArYAqg0E7kwA7pRX/0nwzpQSTIZEC35infKhKhUNNEzJSNBVReIUvv/2DyXe8kUUcaiNBmrBVylGwSc9KNvYVLN+W/Ry3X740D14dgHjB+qUEx7mrIr+cuJFmiTmlYSQ4rebRkCeqACnY1GvNvuq0RUzjSFrB1mPVLE1gJ+xI2Y/VJgQW4Ao1/1BbrC5OHqE+oe8ODambhkct2jXAT9bajy5TzPJMWAojbYasI1OKmatm97Ri6RxqgyEUL+0mJXIu1cpQoibCN320+vWHH6dK3zaWPo/9aUhReV1r3Edsx/LB4BtoCM04cH55usxeRTZqoL75/vmkeiZnTrOq99KbSfoApl8W9xtVs7Y/7ArZqiSVgzUCT3K/oHvUYzuElCKDR4H5Y5QvooQoND2mDYudjEW/qKmWaZwcCXRX8IvHL/N/r5WF/NJwY52NmEjqJeneT8bFyqYY3+qFbCCS+/ZrXvDHoBdV4H8cjATtSQJqANMBJqkdCSO3HkUlvqZ43AVyQyht7d14EIDFAAJIst+IVkSb5byG/ItB8kGqFpVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(86362001)(26005)(7416002)(6506007)(71200400001)(38070700005)(38100700002)(82960400001)(54906003)(110136005)(316002)(91956017)(8676002)(76116006)(66946007)(66476007)(66556008)(4326008)(66446008)(508600001)(2906002)(64756008)(8936002)(36756003)(6486002)(5660300002)(2616005)(186003)(83380400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1FLWmdDbTZ4RnhtNUliYk9zM203U3ovbGtkR044WkxxTmk5d2RtR2tJUWRn?=
 =?utf-8?B?VVo2UjF0ODAxOTVZOFdkWW5UT05tbStEZFhQSFg4SHkxTFovbU02VXhVNFkz?=
 =?utf-8?B?WGl6MmpQWlBQb2JjV3d1YTQwWkdERjF0aXNaYi8xZ0xPVkd3SUpoWWRuamI0?=
 =?utf-8?B?ZHV5OTZsdGFaT2pqN2s0a1NVQzFVdEdXS0ErYmo1cjJEaDlJcndWS09sSFdM?=
 =?utf-8?B?QUpVYU1jV245QU0wU3p0bnB4ZzNoUExCYlZ4SDJaQW1VR3J0cEJkWHNtMjZ6?=
 =?utf-8?B?c05oNUZ1SDlXRUYvVjM0RmVEd3VPd0pUZ3pMMmFMTXBlaFlkTGgzaGxLUDl6?=
 =?utf-8?B?L2xseFJnOXoyNllGTW9FSG9WZTRmaTRwRURYOEhOSlQxakJKSWNZdkRjemY4?=
 =?utf-8?B?N1haSUwzUEpFOWtDckRLWWV3SGRWNmZLK25UZEVuK2JmWlcwT25xc1ZMVEll?=
 =?utf-8?B?NG9oTXdSMytWVXBCcFNzTmZWOGtacmVhZ2NzeXh1RlBGclE3TTcvNlVPcGhC?=
 =?utf-8?B?b2RjUk04eEZDemMyYnlBS0RIMzZQaEEwVEQ4dGdNQjRjTldWZXA1c2drNmVh?=
 =?utf-8?B?VXltMTNPRnNNQXQxMUlFMEp2Z1ArWGRQbVlNakx4UmFIazZibktxVENkbE40?=
 =?utf-8?B?QTJ2WkdrakZmUE1yV1oxTGMyd21YZXlpVU45RUJGbTVPbVAvbml6Tlg2SHR2?=
 =?utf-8?B?a1FXaDIyNDNiNHFjS29RcCtrdlRxL0hXZGd1Y2c5RU9aN1A5UlFYRDE5cXpI?=
 =?utf-8?B?SDZ3ZUMyTlhBeUxkWS82aEdTQW53ZDVBUTllRzBwTDB6QWhoek9mNkRqN2dW?=
 =?utf-8?B?c0g0ZEYzekgzRWxDM0NacElpWTJFakFzeDJLQlQyZWwzcmlhSmZMR2E5VmVk?=
 =?utf-8?B?OExTOTQydHJXM1diTHhtQ2lCVUtRR3JhbnVBMS9rQWwrREJBTW5sajJxM3pq?=
 =?utf-8?B?VEJIeEl4ZGY3SG9HMGlQWkdMaTVXM09MeXZVcCtsR3BwMVl1Q0ZpUzdSckNt?=
 =?utf-8?B?SlAwT2p0RXRlYkNzc2hSYmpkVW8vOXU1VDh6VG9PYWVkKytad2tsbkRycWkz?=
 =?utf-8?B?M0tNeUJYLzNIU290OFppY3VFbTdYRVNWSEs4SjNWRDgzZjJkZGswZkJIdG03?=
 =?utf-8?B?S29vUDdkOTAxcEJFak8wTTlEdnFzWlc5cS9VckVmV2tGcXpTQ2Z4bEYra2d0?=
 =?utf-8?B?Y2I0eXllaU1XU1JNK0tZVGlFd1RhejA4VWFhK1RIN042UWJJU1BnVVd0aUl0?=
 =?utf-8?B?ek5nelhzVzdrenJDV0duQXRxRXppMk9DakU3KzVVZHpVQXRWQ1NRUWx5VkNa?=
 =?utf-8?B?bjNpaytsTXpJSGxFRkJEZjNKVTN2SXBSbnRza3d6eGM3NTNPMFRQY09aR21x?=
 =?utf-8?B?UjlrMllHb2wzZEZmVFNUdmE1QWR4SkZHdVpMZ0VFZ1VTdnIwVUxscTBZakww?=
 =?utf-8?B?Rk1RMU1QUjVXRkpHUk5NNEE3dlNjN3Fac3NmZnVqYjAzUHdEWHU2ZytpbnQv?=
 =?utf-8?B?V2VnenJXL0tDU2JwWXU2czYwNUdLdktUR1VTL2I3RVpmYmI0SlZPakNBSVJC?=
 =?utf-8?B?RFU2VHJJZ0oxbDlLZStXeXhRZlNwQ2JsUStiOFc0eHllNDFOMjB6NlNIVWJD?=
 =?utf-8?B?K3l1WHppZGo2MHloekRJQUxMLzhtdlR3YitUbDVZRmZzcWNCUlNsZGRHT1JU?=
 =?utf-8?B?dlVGYVU3ckhqcjNUdUxsZVZWMERQUnhkcnJwMnowTnhoZi94Mmg5Zi9ERmhO?=
 =?utf-8?B?N0RWeC95ODU3RHA1VG1iUEJtL3FPWitMbkVPLytrWjIrY0drVTVEYUxFemJx?=
 =?utf-8?B?VkdPT2lMdjczTVF5QXd0MEFLZGRWU21kS1M0aGd2SHBtTHhzbGxWWmtRRHVJ?=
 =?utf-8?B?WHc1MXRQdmZrNTJhRndpWHg2YXl1N1FRQmlaYlhyZ3ZHbXdsNWxCRXpwc2Nr?=
 =?utf-8?B?NWpVNTN2WHIwZjIrV1lVc3FJMGozNjZIaHVXZ212eUhNZE03ckYrRTgveXBL?=
 =?utf-8?B?RTFWcXVhYUdhVlppOHB0aGtlKzZQSTRpcTEzYURjUVUrSVRaWG1pMExmSER4?=
 =?utf-8?B?alZZM3A3b3lDUUpaN2pKWDhlUURYQm04YTVCNGhFbk1CYUJPQjVmWmVBTmZM?=
 =?utf-8?B?MEhaL2o5MGRSeUVJMWo0U1V6WG5DR1k2Ly9QbXdQR3R0Smg3NmJmM1NlaGF2?=
 =?utf-8?B?ZzhNOVNLSFZxRy9rN2g2NE9OVGZjNWp4ZG8yODdteG9adHB3SXBGcTgzQ2h6?=
 =?utf-8?B?dkZ4WjlPODJ0U254Qk1PNDhZSThlL1Q5R2JLcDh5SFlTOThDMkhUeXFkOFF3?=
 =?utf-8?B?alpmRFJrajhjNm9ZOEVXRXlmVFpIYVgwdkdhVHFzNzd5QmlMeFF2YmdUeFNv?=
 =?utf-8?Q?uUqJr3cpg02VJG9Dl+ImttmHPnGqJLRRwNV2C?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D2CFAB7C629ED42A3D093AD899F04CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4b934c-7b06-4899-f204-08da26ca01fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 14:43:48.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSQnrspF/6FiJUBP1pOpUmICPhNg8T9PjGbjm/I0L+r4zlO6RJjJi/7u2+CeR6pZHNJByygaKC7L6MiLDfWgN9tY8YHeJBNLq4rq4lfOnO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1453
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIyLTA0LTE1IGF0IDEyOjU5ICswMTAwLCBCcnlhbiBPJ0Rvbm9naHVlIHdyb3Rl
Og0KPiBUaGUgZW5hYmxlIHBhdGggZG9lcw0KPiAtIGdwaW8NCj4gLSBjbG9jaw0KPiANCj4gVGhl
IGRpc2FibGUgcGF0aCBkb2VzDQo+IC0gZ3Bpbw0KPiAtIGNsb2NrDQo+IA0KPiBGaXggdGhlIG9y
ZGVyIG9uIHRoZSBwb3dlci1vZmYgcGF0aCBzbyB0aGF0IHBvd2VyLW9mZiBhbmQgcG93ZXItb24g
aGF2ZQ0KPiB0aGUNCj4gc2FtZSBvcmRlcmluZyBmb3IgY2xvY2sgYW5kIGdwaW8uDQo+IA0KPiBG
aXhlczogOTIxNGU4NmMwY2MxICgibWVkaWE6IGkyYzogQWRkIGlteDQxMiBjYW1lcmEgc2Vuc29y
IGRyaXZlciIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6
IEJyeWFuIE8nRG9ub2dodWUgPGJyeWFuLm9kb25vZ2h1ZUBsaW5hcm8ub3JnPg0KPiAtLS0NCj4g
wqBkcml2ZXJzL21lZGlhL2kyYy9pbXg0MTIuYyB8IDQgKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZWRpYS9pMmMvaW14NDEyLmMgYi9kcml2ZXJzL21lZGlhL2kyYy9pbXg0MTIuYw0KPiBp
bmRleCBlNmJlNmI0MjUwZjUuLjg0Mjc5YTY4MDg3MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9t
ZWRpYS9pMmMvaW14NDEyLmMNCj4gKysrIGIvZHJpdmVycy9tZWRpYS9pMmMvaW14NDEyLmMNCj4g
QEAgLTEwNDAsMTAgKzEwNDAsMTAgQEAgc3RhdGljIGludCBpbXg0MTJfcG93ZXJfb2ZmKHN0cnVj
dCBkZXZpY2UgKmRldikNCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB2NGwyX3N1YmRldiAqc2Qg
PSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbXg0MTIg
KmlteDQxMiA9IHRvX2lteDQxMihzZCk7DQo+IMKgDQo+IC3CoMKgwqDCoMKgwqDCoGdwaW9kX3Nl
dF92YWx1ZV9jYW5zbGVlcChpbXg0MTItPnJlc2V0X2dwaW8sIDEpOw0KPiAtDQo+IMKgwqDCoMKg
wqDCoMKgwqBjbGtfZGlzYWJsZV91bnByZXBhcmUoaW14NDEyLT5pbmNsayk7DQo+IMKgDQo+ICvC
oMKgwqDCoMKgwqDCoGdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChpbXg0MTItPnJlc2V0X2dwaW8s
IDEpOw0KPiArDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gwqB9DQo+IMKgDQoNCkxH
VE0sIHRoYW5rcyBmb3IgdGhlIHBhdGNoIQ0KDQpSZXZpZXdlZC1ieTogRGFuaWVsZSBBbGVzc2Fu
ZHJlbGxpIDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29tPg0K
