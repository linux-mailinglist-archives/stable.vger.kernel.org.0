Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDC15AD1A0
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 13:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiIELcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiIELcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 07:32:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4880E59247;
        Mon,  5 Sep 2022 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662377563; x=1693913563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h8zW+XoTk13QZukBKky+ahyCHsvb11yHBGmzNKo/30w=;
  b=ABOqdZzrmAF7tE4IT4uRCn9/5oFwC16Q9ND6CeXTiSfle4pKkYrw8Tm6
   6bJYrPsagtOljkzbgw2huUFuf48GuQkKcIz9XhD1xHaLXJrLrcyk/UeDn
   8WbnOc5xWHRhFRKivhfX+pNgjqIDSXm+RbHjzTlOB9J1eWlZH6V+fzE3x
   NO6TcfltoaGmpweLSNWCnDHFdpZI93blxHMPQ65AAX1Ac/Z6jKtgyRKCa
   eW43DF51B06zkLrh8QmYeKsrxoImP6ti4/la8MTuiyvby3FsiG/VYw3+T
   gpgycczN2QXD3eaELIr33UNVpuwvaizbaAvLTTl83MaT6OR4spz7DuRC7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="283364674"
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="283364674"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 04:32:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,291,1654585200"; 
   d="scan'208";a="643778903"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 05 Sep 2022 04:32:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 04:32:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 04:32:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 04:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjqdqUIvmLww+MTLU2IE2VQ4wcMLvLa+QWg1HzMmCj/7oqN8ucy7TEPdy6WGUGHbDs+FbzwaeVT713f5r0zZFkDWlFfOKVH3wghzpmoZd1+8Bb1tvsv9ay8Pkvinnq6g9CQgDL70MRo51Flulx11f51AEdnVGH3noAB6EHNSeIBsdDCT4nuSH6Zq2SVP89czUzBRbb4kdKsdZsVArufi6berSn45N/rNcH4TrnpPbe7Y9OyDJuAD7s8G/ZxGROrz5HhkCthYqnH3S+eZx+bE73hxfdAMjmYxVFkk8cuKwp08QdhcJyTUTVEDhCTUDez3fYuK2DRUEabgGoqswjiavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8zW+XoTk13QZukBKky+ahyCHsvb11yHBGmzNKo/30w=;
 b=Sjl+hcmVlO7b+6ZLBBBV8YRcZ68hkAHykRSap4xJJjBfpTuDfjpvKHMcGp3m6MLf3HRUMekryjIMwd+Dk+tVcXiy23KkQOfBbwdP3SxrH3GGU7UKCZYx/sz9siH3+xjBPB8gS7OrxAApXhdlYxQGzd5XxX6B3NvizllRJeeVMcDFamX76jJqCgcmKBmqIn2f33ZQQ5NrB8dWPrKMeb/ZUivsTxKXAiWHwhzdaxSG8yK/Sm6YuEoPoLTdUufoY0MIfi3pft5OVIdAr6lNXw52OEodqyZYQqbJtjNkTcjQkK3HfIK+uTUYhQqfLGVhlXWhcnyi2JpiCeYTwkzmLPmwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH2PR11MB4389.namprd11.prod.outlook.com (2603:10b6:610:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 11:32:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 11:32:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Thread-Topic: [PATCH 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Thread-Index: AQHYv1qxZ7TsJ3OH1Um94+aMAhZwvq3NgKoAgAL4+QCAAB/3AIAAHhSA
Date:   Mon, 5 Sep 2022 11:32:40 +0000
Message-ID: <f2d51953686293d23fe1b0782f57b5e51ea84d5b.camel@intel.com>
References: <20220903060108.1709739-1-jarkko@kernel.org>
         <20220903060108.1709739-2-jarkko@kernel.org> <YxMr7hIXsNcWAiN5@kernel.org>
         <a5fa56bdc57d6472a306bd8d795afc674b724538.camel@intel.com>
         <YxXFGLSmRri2T1yb@kernel.org>
In-Reply-To: <YxXFGLSmRri2T1yb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6ac2110-2119-46a1-956b-08da8f32574f
x-ms-traffictypediagnostic: CH2PR11MB4389:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XOlLRPjbke8NgzRVUVa5faMmwbkkuFeEJETc6lE33rk/UNtDXAvxCGVT1JZYlVnKWxbj0l8umk1biZSGJtbhSvcusgIqVwrEdeLXz8QlVgT2FokNMzmvxhAyUd77hXdcrc+8mv9lr/EgEyPHBGUXFllhCWR0hTeMlh/CitPcRD+HS2Z2i9LMdRFtYq/ebTSxm79dNjBS0HE39OMFKJXBQ5lnrdBs4yXuj8GpcYyUUdWTsiC3/bYVvH4kxYmDnYLQDkMFfR4MrWbvdKrI9jkg7ghJhMcu9yrDdZKBGTbcNLYuuzjggoja7/P9Fp8u+0tR5riJVIWiJsZBNYRkvrgAXdeKCiQLwjx3zqXD1IvMlKVYUALfrT8hV3699yxSx48//puFPih2clkuQDfqmJmmG8fJ/QztVJRY8FZeZCP67IOAlb7DjhDsaF9CA+6cj1N5JUr8WaKEBmQF58z4YqN8UZXIAro7dYFP3OC2SoOp+sqWj5U3jyJ4qFyTnOCePxbYoLTdLPyUiF27H6SZNAuFNSJ5i1f6IKYwyNQATpyu2IftT1Sr7/Gq3yf9l9T+urIMiSdbmQ2U68pfFVxCNJHCw6EThdoXiJbDr9XB0OmXt+ZzeQTDPb3JK4ZZr0ZW7RX12Rc9Zxc6Da4CUxqIncZTbY5o57GEM7cWrpaGsJo1AW8sWBsdQ7+lPzL/KZ3WYIuZBqhcB01JJCjA7RpQDZJrwyxB+MPtKN7O11/5IIS35vk4V6FwI4zKimjf8Nv5HrItbeJWVA2A9kK3M5ElC6fpfnEPLTj5UsO8CoxCYrXeE18=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(346002)(376002)(39860400002)(6916009)(316002)(83380400001)(6512007)(26005)(6506007)(54906003)(478600001)(8936002)(38070700005)(36756003)(7416002)(86362001)(2906002)(5660300002)(122000001)(4326008)(64756008)(76116006)(91956017)(66556008)(66476007)(66446008)(8676002)(82960400001)(66946007)(71200400001)(186003)(41300700001)(2616005)(6486002)(38100700002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUc2QnJMTDFtNjFGM3dYMEErYWdSbHZ3bUFrNExCdjJWZzBQb3l5UDVWNmF0?=
 =?utf-8?B?Ty9uTnAxU1Q0alhUZk9sSWVLN3BaeDZBaWlzRkdyT1JSbWRvZWl1b0tXNkhE?=
 =?utf-8?B?UnVjM1Y4MFA4SFI2VSt6ZGxXb1ZITi9Bc1VUc2VsbllBbzlwTlZKWjdNSk1v?=
 =?utf-8?B?WWcxMXQwM0FOWkIrYzlZeGFYSG1IQ2xPTzFJaGNKaDdzUnNmRG1BTjNLZnFT?=
 =?utf-8?B?YUY0cnRkNDJDMTNPbk9ZSmNWYWNBaTlKMTRFbnNiOXkzQlBCQTJUWkRJWGJt?=
 =?utf-8?B?eDJrZFRZTmpaTWRxQmd3TXV3Q2N1RXdyTmNMWFRMMFRST2JveW5vV3RMcWo0?=
 =?utf-8?B?bjJMK2Z2eHVLZGhWODlvd3dEZ2RPbWRYY2VGWVkzTG1WRXUxL1BQSHk2UU8y?=
 =?utf-8?B?a0lxMWxRSitYSWgxNDU0NTU4STRWMjJ1RkVNU2UrbFM4MWlLZVh5cWZvS0tZ?=
 =?utf-8?B?Y3hTTkV4RVhaWkFqaktPOW8zYUl0WHE1c1lKYlpQZkFieTFoc3VyZ2xyOWc3?=
 =?utf-8?B?OW42VUNYeWFNOVNVdUlqWlJwQi9nZ2JUdHBZdzdzN3JtNGZnYjlVS2RLQmda?=
 =?utf-8?B?MzN6TEs0Tlpxb3hpRXlsSUZlM21tQ1RFdjQ4b1R0bThRd1NLeDhFaEdtUlpH?=
 =?utf-8?B?cSswMDVZUG5EMjdEWktaQ0pMZzQ5Wkd2WEZsWG9LVWtKT0hHajdWN2ZpMzM5?=
 =?utf-8?B?ZmlrNUFMS3d4eFloRnNpa3E5ZWR3SHJZbkdLVmMvcEFsdGdiV3h6YTZTM3hG?=
 =?utf-8?B?SmMrT0tzdm9rZEpBVXVGYW9yVm8yV01xYklRc0NMQWEwWDkzNGxqdWtkYVBN?=
 =?utf-8?B?S050QnR6ME1oYlF0ajNuZmFPdzhpSlhlQmtESTRpL2crUXR2RHhqOHh6S0VK?=
 =?utf-8?B?TUtQQlRRV2lzYnR1cFpxakNhRHlLU0diRDVrUFE5UGlJT21Wb1BNMFViZkZx?=
 =?utf-8?B?VVlSd2duUnJZN2xJV3oyajY4QTJHNnp1YWI0bU5BYlF6dDErYjNnT2R3Nmtz?=
 =?utf-8?B?OWVxdzRoOWJaVDJNS2RmR0NDdlkrZUVhTlN2eE1uR3Rmd3pxVCsySG9pOXVv?=
 =?utf-8?B?anI0TFJEVUpsWjJIRDR3QjBHVnl5QmZza2ZlZ3pLRTA0U2N1SG9HRkFUZzVo?=
 =?utf-8?B?Q1p3cndBdkpoNmJ5K2dERUZ4NlVSNlViWXlPV2xndCtJeDc1b251LzV6alMx?=
 =?utf-8?B?Z2daelFKZjZQTGFrTWR1UFg2OFFiY2ZsOU5yUjFmUWlGNU9CaFhXd2U0bEM0?=
 =?utf-8?B?MENlcXE4TWM0MldLT05SNmdKRndrS2xsRlBxOVdxditPUE5rc2ZlUEQxa0Zl?=
 =?utf-8?B?cmFFR1FSNStIMVdXV3VNam9FVkJhT0NlZ01waWQ3eGVuZDFNa3dXQ3BIdFdG?=
 =?utf-8?B?S29icnljTEc4OUdMRERHZkpKK1oyR3gwVVJGRWRDRW8rYklhOERmREZ2L0pQ?=
 =?utf-8?B?STk4UG9jUHFxajVjMExKTnlraU9kOXl0aTh4dW9qU0tSZDExSnc3VW9rdEFD?=
 =?utf-8?B?NDA2eUZaVXVqNktkOUR3RGVRWWhjdjBDQzlGc1pKU3E0SGtydjl0RlBST1NR?=
 =?utf-8?B?RGMyN1ZFZk5mWWNkcDN3Q0M5TGYxdys3dlVwOHhOb0h6TVNYeDR2T1VQbzNo?=
 =?utf-8?B?c2pqclRkVm5RdjAyY1ZXQ0szQkM4c1hRMk9IdU8yLzcrVDlpSG5HcXlnNEpD?=
 =?utf-8?B?VHljallrVi90N1RqQVVQQS9XNXZRQkk5cFRzZkx1VWlUS3FxclFuQ1Z3M2dF?=
 =?utf-8?B?Zkhka21CR0ZOWjhxRTFzS0cxVm9mRERwbDhQa2VGQ2tCcGFWZXpTMC9IUTAr?=
 =?utf-8?B?amYwWUpwbE1mZDVEdCs4M2hCbUdNU1VISzdvcExuZFVtcGNqTDRGNVAvOWsz?=
 =?utf-8?B?N20weUNNL0p1OFY0VTBERTBMM1NjWWszeE5XNG13RXFHeGFhZGVianYrb0Rp?=
 =?utf-8?B?aG5tZGF4Slg1a0pXbFJWTzBUa3V5TFFaRDZHYkVEVmdvMzVJYi9PMEQzRktW?=
 =?utf-8?B?V2gvTjZvSHhJRzJKbmtrRkFrUGx5b2VoanRQSTJHanVFWm93Q0xqcjVPTjhk?=
 =?utf-8?B?MG5CUFkyTWpjR1NVUUdPeGlVd0hiZWVVcmFIZXZvTDcwTVhIYXBrZjdjdW9j?=
 =?utf-8?B?NmYzdTlSYXNBNnZGT3dtdUR1SUJxQmZmUjMzRitvUGdtNFpuNEc1M1ZHL0Np?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69487B01A0AA9C4DB8761FF6D3967CC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ac2110-2119-46a1-956b-08da8f32574f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 11:32:40.2004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oKUgJHRkr1NQ7VxVoe6/RW1JPCVmO9s+wq0oOmR7s2ni/ayxeCF6H46dK/pMMLuu+48vNQlVX5cE7T0vmZscuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4389
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIyLTA5LTA1IGF0IDEyOjQ0ICswMzAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gT24gTW9uLCBTZXAgMDUsIDIwMjIgYXQgMDc6NTA6MzNBTSArMDAwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiBPbiBTYXQsIDIwMjItMDktMDMgYXQgMTM6MjYgKzAzMDAsIEphcmtrbyBT
YWtraW5lbiB3cm90ZToNCj4gPiA+ID4gwqAgc3RhdGljIGludCBrc2d4ZCh2b2lkICpwKQ0KPiA+
ID4gPiDCoCB7DQo+ID4gPiA+ICsJdW5zaWduZWQgbG9uZyBsZWZ0X2RpcnR5Ow0KPiA+ID4gPiAr
DQo+ID4gPiA+IMKgwqAJc2V0X2ZyZWV6YWJsZSgpOw0KPiA+ID4gPiDCoCANCj4gPiA+ID4gwqDC
oAkvKg0KPiA+ID4gPiDCoMKgCSAqIFNhbml0aXplIHBhZ2VzIGluIG9yZGVyIHRvIHJlY292ZXIg
ZnJvbSBrZXhlYygpLiBUaGUgMm5kIHBhc3MgaXMNCj4gPiA+ID4gwqDCoAkgKiByZXF1aXJlZCBm
b3IgU0VDUyBwYWdlcywgd2hvc2UgY2hpbGQgcGFnZXMgYmxvY2tlZCBFUkVNT1ZFLg0KPiA+ID4g
PiDCoMKgCSAqLw0KPiA+ID4gPiAtCV9fc2d4X3Nhbml0aXplX3BhZ2VzKCZzZ3hfZGlydHlfcGFn
ZV9saXN0KTsNCj4gPiA+ID4gLQlfX3NneF9zYW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5X3BhZ2Vf
bGlzdCk7DQo+ID4gPiA+ICsJbGVmdF9kaXJ0eSA9IF9fc2d4X3Nhbml0aXplX3BhZ2VzKCZzZ3hf
ZGlydHlfcGFnZV9saXN0KTsNCj4gPiA+ID4gKwlwcl9kZWJ1ZygiJWxkIHVuc2FuaXRpemVkIHBh
Z2VzXG4iLCBsZWZ0X2RpcnR5KTsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgJWx1DQo+ID4gPiANCj4gPiANCj4gPiBJIGFzc3VtZSB0aGUgaW50ZW50aW9uIGlzIHRv
IHByaW50IG91dCB0aGUgdW5zYW5pdGl6ZWQgU0VDUyBwYWdlcywgYnV0IHdoYXQgaXMNCj4gPiB0
aGUgdmFsdWUgb2YgcHJpbnRpbmcgaXQ/IFRvIG1lIGl0IGRvZXNuJ3QgcHJvdmlkZSBhbnkgdXNl
ZnVsIGluZm9ybWF0aW9uLCBldmVuDQo+ID4gZm9yIGRlYnVnLg0KPiANCj4gSG93IGRvIHlvdSBt
ZWFzdXJlICJ1c2VmdWwiPw0KPiANCj4gSWYgZm9yIHNvbWUgcmVhc29uIHRoZXJlIHdlcmUgdW5z
YW5pdGl6ZWQgcGFnZXMsIEkgd291bGQgYXQgbGVhc3QNCj4gd2FudCB0byBrbm93IHdoZXJlIGl0
IGVuZGVkIG9uIHRoZSBmaXJzdCB2YWx1ZS4NCg0KVXNpbmcgcHJfZGVidWcoKSBtZWFucyBpdCdz
IGZvciBkZWJ1Z2dpbmcgdGhlIGRyaXZlciwgYnV0IHRvIG1lIGl0IGRvZXNuJ3QgaGVscA0Kb24g
ZGVidWdnaW5nIHRoZSBkcml2ZXIsIHNvIGl0IGlzIG5vdCB1c2VmdWwuDQoNCkFueXdheSwgSSB3
aWxsIHN0b3AgYXJndWUgaGVyZS4NCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K
