Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63455A950F
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiIAKug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiIAKu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:50:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2796B15A;
        Thu,  1 Sep 2022 03:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662029423; x=1693565423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6snQsjQbu9poyhH3/bfNjKsEiNYhLMPkDUnb6cv69vM=;
  b=IwZbTTAR9CxldqzZZa5znao0SXMLZpFDYufj8BGeBp3DjB+N5Knm+GH3
   pDvEshCEhxQ9RsR/Gwi2hrODJT9+ASOWWwo7LKE+hZ70QxotP9A53SVus
   B+TcmUFynCTcKUg5IxOOwvmsUto1v3N8XUO+RMAq88dGASat5MIPAKfTx
   szb7u0nWM7YtY3DsXbGSrdkXEkxFcU+rMkPLbY0nklv/tICwYUaHQkilE
   DFYIZfNFLf8b+O6unR0VZHicsnQAxSs7ajiOqty+Gyp4y1k+sa9eHlwza
   Rx6K0V4xHzzlPCh4gQSAzgicKYi6rea1MH20adVex3Nhq6iQfwgLZQsnh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321829886"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321829886"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:50:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="563413003"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 01 Sep 2022 03:50:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 03:50:10 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 03:50:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 03:50:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 03:50:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bq5jdcU+l6dRqTFQp4iRtUmWz6pXyEKz2QBcDk9gDu+IL5AT8KGDjNp6Bjii7Xm042Z+6j/UxrvH6CZ/xwaqrYROcZYOD7GBiA87jPzZVtXxasu5yoaBnCndflspk+gc3gyujgfd7YhSeeJgg6Mbi42LOJJ2rEto4YAkyRY5cyehfU8tniJhowwwuAUNZl7UBr8xc3l5AnqcPm7evqxxMdk+izVtM0cpwPDa7NgpQOowA1/fRYOHfMgPr5Yf9aJS3pNagRjQ+d7B5Kbo1GUArXSY26pGDM63V6QevU9JFardWPxbB3PyJwxarzLpw5H6PdRWd1OqRcYrT4A7KMWffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6snQsjQbu9poyhH3/bfNjKsEiNYhLMPkDUnb6cv69vM=;
 b=SLHBhR1EzFnSTih8cD5jXdniMhqI29doHq8aLM9CDpQQBHZlx6jrc1cvysWGFi54Xt04y9J+A5rwgqemiL0IWQzGRaqyLixeEgCt+5J4e5cyKiLl7sqyHEBvAn0iZ4X1Gz1pxs38SNwIgIvWcmQoZYMpKSsVyPq5MiNw27LSeUeChci21gBAlF+sAB07bVD9AF3HVxA1J9sqEW3FdCHlJWVoj1yLyVygQ2Jb8TdyUWo7D5JuaR6GOIfVlgZa3VYsBJYxkqtAZr3iStcgzgL3Pfwt54NgqPMDefGxu1SPxOwbnTTpop+X31rP0nS69yFDDTtnrtJxxPDbkr4N5GG2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 1 Sep
 2022 10:50:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%8]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 10:50:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Thread-Topic: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Thread-Index: AQHYvWCSZRGjXPfio06e765nNYMkQK3JeOSAgADti4A=
Date:   Thu, 1 Sep 2022 10:50:07 +0000
Message-ID: <d6a3212aa11c2788d35094739abe40909373cd68.camel@intel.com>
References: <20220831173829.126661-1-jarkko@kernel.org>
         <20220831173829.126661-3-jarkko@kernel.org>
         <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
In-Reply-To: <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36058f63-ae39-450f-0f4c-08da8c07bc6b
x-ms-traffictypediagnostic: DM4PR11MB6042:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +9clLmwov6E6xkm6VURK+hsLK4gZ+oDbqGC9x7HsanDWvF6AIuUebYwontx6oGW1GyT1LCAonNtpPstJxlks6b5KQRsAaTkaqZLAP7Jajzb0attDPjb7OU1eLaSH9SiHEy8hlleXVRkktHx/1Vols1m4qo8rx/mgAeYjdJbXE3ZijCxz7mrDhdFrgdxnUUOo3z96Zes/3Qxl/6qM8y7+3nSROxC0CPeWVnEjfxD+FA1897dNfgEbLKfiHAv5FxL0PZrtotfnKPnui1Ca8VXE7CeBlm6Cya7GS7hLoDh24NTy4JGBqtaTJDCdEd7Oc4nv1qXnyftV/T4PWGiCkkA46cVHfX6iiwsMHXAtlpGOHZPySDl5ShscJair2eYK742yrPlE3JUi49+Q9milOLnrV9MHUOGPfvI646MGvzZ17l6c3RYVRzc0ezuOeEzpcPhdhffD1ARcXfJ+VeHHt4kEJDWJlHMNujD8gvI2VCPzDpbwJpdNbJNwqRS3/BDH15CwYhIyLzdxMJekXPdKjP9E3uXvObI4SZG/1I2xPtw638fOEO/+cI+4wtgqNZBR//HkIDtgViOdJspUOVbBZrag7hGLlnOK4lTQcTujjEQhC5AAUcziqaVFRshVOHeK9I1sOuKs9tfjKnl17AH17PNGAx0OGUE0jt1w2MeWlcJTbmw92f+ToHFZPOHX6GRRjPirUfeArnkBPmHd0FoZvcTLFfo02icplMXRdDsQ8jXwQxvxfuimDLVUKxJOuO11I0oKt7nM4z8j7F1B5aT3OscPrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(376002)(366004)(39860400002)(71200400001)(41300700001)(6506007)(6512007)(26005)(478600001)(6486002)(66946007)(110136005)(54906003)(4326008)(5660300002)(186003)(316002)(2616005)(66446008)(91956017)(66556008)(64756008)(66476007)(8676002)(83380400001)(76116006)(86362001)(8936002)(7416002)(2906002)(38100700002)(122000001)(36756003)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzA4bFlFZ0RRNUlTTUladEZxT1pCU2p5OE1OUjJiNi9mSVlFb1U2VVpJMWdY?=
 =?utf-8?B?K0Z4OTI2S1RmeGJSR0FOTEVtOGZyNTJ3K2dTRFB4dDV5d1dMWTNqanQ5UEZI?=
 =?utf-8?B?V3RGV1FERDZuZUp2TTk5WVZ6SG5BeGd4QU1sYkRhaDBzbVoyRk8vRUtablY2?=
 =?utf-8?B?NlhTWXNtMThjUEltWkpGclJJWXE0ajJXVDNFTGVKbHJQKzRmUTREM3dSUDZG?=
 =?utf-8?B?V1dNbFZsRW9wVkl4V0VBRGtEZmNKQjNabGFIWGlJc0poQ3RqZjNGN1F2TzJp?=
 =?utf-8?B?Mi94N296ckl4SUNmMjZUQkxmdWN0eEVXQVl3ZitiTEtPcG5YLzVwOUlkaHkv?=
 =?utf-8?B?M3NjOVk3bkZSZmFjT1NhR200Nzgwc01DaHgrWnBWbi82cVVRN0ZNTWZkaWVv?=
 =?utf-8?B?cjZJbGZNNDVzZE1pOTU4SVk2UlhiRzArZkZDOGYrQnU5TkZBWEFMYzErbmFX?=
 =?utf-8?B?YTVmY0ZkYURNbDJBbEoySitQZ2tuMEIvdUFHT0pOKzB5blNvdnd2bnBrMFpj?=
 =?utf-8?B?UG40L0xucmU2MmNOOEJvZEhqeFY3SVBZRk81WGVnSGlLRGoxQ1ZDU0tueElC?=
 =?utf-8?B?dEYvUUJpeSsyVVN4aDE2MkZMamIxMmxXZmZCalFxdkpEc1VKeTVFRFZvLzh4?=
 =?utf-8?B?Vkp6SXErVC9nZk9MMjJHYnNKdVZMMlExVUt6eU5hUnNMa0ZDb0VONkVwTWJP?=
 =?utf-8?B?ZmdXb1ZOaXFHcXRmMUhOa29ESmRQaDdQWnU2YzQ1U21QenBxMmF3THI3bHFy?=
 =?utf-8?B?VDAxVGRNcVdSTWhvd3dnbElHcjdSWWNvamNKZTRzSXYwaXNzb1lGakljZ0F2?=
 =?utf-8?B?alczaGVCT09MUVBrOEdzRXc0Q1ZSb1cxYTc0ZCtJSlMvRDcwQzNjcW15djdD?=
 =?utf-8?B?LzNXSkQ0eVp2YUFZOCtXdWJYV0F0RmtHcDZjVGtwSFoxSHc5eC9sL2cvYjcr?=
 =?utf-8?B?ZFpsbVdMRERuOC9Cd1k1SjJkR1dsMkhXOTUwSnE5YlBKS2gzQkNjVE9qKy9H?=
 =?utf-8?B?U0xXTE1HMzh5QXo1RW44ZTA1VWtVVmRWbWl0bEdHSG9tOG9ORTk0Z1pjY0Jk?=
 =?utf-8?B?WWt1R1VPbHROWmZxVzhZMDVYekpucld2WFMzUTAra1ZiNWlXUVBZVURVSXkw?=
 =?utf-8?B?VjZtUXRZcE1vOXFhUytpRVlUdlRKTTVNYWNUZ0ZUT0lldllWV2Y5NGlNbmp3?=
 =?utf-8?B?Vm5TQkpCbFpkT2E5dXQ2QlorUzltR3g4MjMwa09zbFRKRVMxM3hKMVVrNU9v?=
 =?utf-8?B?U3pMQjNJRFI4VkQrNEhXYkYvMGhTS2EreVdkSUloQ25rZGVkWkdZSm1IVHl0?=
 =?utf-8?B?RkIvQ1p5VW84UC9sM1NHczAvQld6R21leFVwWkk4TmRQRmkxTlFsMjR0SVBQ?=
 =?utf-8?B?elNrUUJXMVFPMkdyT3ZpQ1luQ3BRMnFaaHRMSjNWVWg0bjQ4cGFKeFpiYlNz?=
 =?utf-8?B?TTJ4WHBidFRPOEgveW9TZEtaMWRwMHg0Wk5aWXFheUQ5U1o0M2hoN2JmSUZy?=
 =?utf-8?B?YmZvMWxGcDZib3F6OUVHK05Wbmx5YjFZQUQ0L2RHZCtxcnRJL2VSa1BGV2R5?=
 =?utf-8?B?TllkWlRyYi9VSXJkaHNFUDUwYTYxNG1Bd2JzZG1FaHhKVi9veWxxcVhHUzFz?=
 =?utf-8?B?TFRkekpuSWhXQ0tyaTBoSjdLcXp1MGgreWk2OUFOVDBwZ3lHd3E4Zzl2WmNn?=
 =?utf-8?B?bVZyNjR2WHYzaGpGOGQrNUt0bGo1Wm81bkVOQWViWjhsQ2gxS0szMnorV1cv?=
 =?utf-8?B?UFF6WGhhNmhQZVdJUWkrTDM0VkJlekhrS2xGYXBYdVA2eVJ2cWUvbU84RmFF?=
 =?utf-8?B?M2hkMUFkY3lncUpmYms0YVl5NWp6b09EZkt6d0ZuNE52a3grOEV4Mm85aWhS?=
 =?utf-8?B?emF0YmhsS2hJRzdjcWZJZ1doeXI2dDZ0WGg0UEw0aHIwcmJOemkzMXp0V1RK?=
 =?utf-8?B?eVVQVEpXcjgrNjh0OFd2amhRZVhXUm9lU2hRd1ROTFVvUlptMmJndVM1ejAw?=
 =?utf-8?B?dzhaOEpNVi91aGIxUStGb3dBMDN0Q1JPcENGK091Z2xsQldVUEozdHUxOVN2?=
 =?utf-8?B?MXU2UG5lN2wyUnBYdDZoOWpnOEZGSmtSQTF0K2tEVUo5N3QzWjNBWm9LWWNh?=
 =?utf-8?B?YU01eXk3V1RiZGtBZncxaXdqenNieGdQWE5xNFZoT29pblFCT1lERnpiaFVz?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3375B88F8074C345B827AAD3BAC65544@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36058f63-ae39-450f-0f4c-08da8c07bc6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 10:50:07.9670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nrdm4lrvTd+Y6evGD2O/cHgHCtBPMGRS7Ro13xiITeBCt6DTbbYWwoOnXlFrOlEMKPqaBohPgAwHVbpvjW8xrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTMxIGF0IDEzOjM5IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+ID4gwqAgc3RhdGljIGludCBrc2d4ZCh2b2lkICpwKQ0KPiA+IMKgIHsNCj4gPiArCWxvbmcg
cmV0Ow0KPiA+ICsNCj4gPiDCoMKgCXNldF9mcmVlemFibGUoKTsNCj4gPiDCoCANCj4gPiDCoMKg
CS8qDQo+ID4gwqDCoAkgKiBTYW5pdGl6ZSBwYWdlcyBpbiBvcmRlciB0byByZWNvdmVyIGZyb20g
a2V4ZWMoKS4gVGhlIDJuZCBwYXNzIGlzDQo+ID4gwqDCoAkgKiByZXF1aXJlZCBmb3IgU0VDUyBw
YWdlcywgd2hvc2UgY2hpbGQgcGFnZXMgYmxvY2tlZCBFUkVNT1ZFLg0KPiA+IMKgwqAJICovDQo+
ID4gLQlfX3NneF9zYW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5X3BhZ2VfbGlzdCk7DQo+ID4gLQlf
X3NneF9zYW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5X3BhZ2VfbGlzdCk7DQo+ID4gKwlyZXQgPSBf
X3NneF9zYW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5X3BhZ2VfbGlzdCk7DQo+ID4gKwlpZiAocmV0
ID09IC1FQ0FOQ0VMRUQpDQo+ID4gKwkJLyoga3RocmVhZCBzdG9wcGVkICovDQo+ID4gKwkJcmV0
dXJuIDA7DQo+ID4gwqAgDQo+ID4gLQkvKiBzYW5pdHkgY2hlY2s6ICovDQo+ID4gLQlXQVJOX09O
KCFsaXN0X2VtcHR5KCZzZ3hfZGlydHlfcGFnZV9saXN0KSk7DQo+ID4gKwlyZXQgPSBfX3NneF9z
YW5pdGl6ZV9wYWdlcygmc2d4X2RpcnR5X3BhZ2VfbGlzdCk7DQo+ID4gKwlzd2l0Y2ggKHJldCkg
ew0KPiA+ICsJY2FzZSAwOg0KPiA+ICsJCS8qIHN1Y2Nlc3MsIG5vIHVuc2FuaXRpemVkIHBhZ2Vz
ICovDQo+ID4gKwkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJY2FzZSAtRUNBTkNFTEVEOg0KPiA+ICsJ
CS8qIGt0aHJlYWQgc3RvcHBlZCAqLw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCWRl
ZmF1bHQ6DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBOZXZlciBleHBlY3RlZCB0byBoYXBwZW4gaW4g
YSB3b3JraW5nIGRyaXZlci4gSWYgaXQNCj4gPiBoYXBwZW5zDQo+ID4gKwkJICogdGhlIGJ1ZyBp
cyBleHBlY3RlZCB0byBiZSBpbiB0aGUgc2FuaXRpemF0aW9uIHByb2Nlc3MsDQo+ID4gYnV0DQo+
ID4gKwkJICogc3VjY2Vzc2Z1bGx5IHNhbml0aXplZCBwYWdlcyBhcmUgc3RpbGwgdmFsaWQgYW5k
IGRyaXZlcg0KPiA+IGNhbg0KPiA+ICsJCSAqIGJlIHVzZWQgYW5kIG1vc3QgaW1wb3J0YW50bHkg
ZGVidWdnZWQgd2l0aG91dCBpc3N1ZXMuIFRvDQo+ID4gcHV0DQo+ID4gKwkJICogc2hvcnQsIHRo
ZSBnbG9iYWwgc3RhdGUgb2Yga2VybmVsIGlzIG5vdCBjb3JydXB0ZWQgc28gbm8NCj4gPiArCQkg
KiByZWFzb24gdG8gZG8gYW55IG1vcmUgY29tcGxpY2F0ZWQgcm9sbGJhY2suDQo+ID4gKwkJICov
DQo+ID4gKwkJcHJfZXJyKCIlbGQgdW5zYW5pdGl6ZWQgcGFnZXNcbiIsIHJldCk7DQo+ID4gKwl9
DQo+ID4gwqAgDQo+ID4gwqDCoAl3aGlsZSAoIWt0aHJlYWRfc2hvdWxkX3N0b3AoKSkgew0KPiA+
IMKgwqAJCWlmICh0cnlfdG9fZnJlZXplKCkpDQo+IA0KPiANCj4gSSB0aGluayBJIGFtIG1pc3Np
bmcgc29tZXRoaW5nIGhlcmUuIEEgbG90IG9mIGxvZ2ljIGlzIGFkZGVkIGhlcmUgYnV0IEkNCj4g
ZG8gbm90IHNlZSB3aHkgaXQgaXMgbmVjZXNzYXJ5LsKgIGtzZ3hkKCkga25vd3MgdmlhIGt0aHJl
YWRfc2hvdWxkX3N0b3AoKSBpZg0KPiB0aGUgcmVjbGFpbWVyIHdhcyBjYW5jZWxlZC4gSSBhbSB0
aHVzIHdvbmRlcmluZywgY291bGQgdGhlIGFib3ZlIG5vdCBiZQ0KPiBzaW1wbGlmaWVkIHRvIHNv
bWV0aGluZyBzaW1pbGFyIHRvIFYxOg0KPiANCj4gQEAgLTM4OCw2ICszOTMsOCBAQCB2b2lkIHNn
eF9yZWNsYWltX2RpcmVjdCh2b2lkKQ0KPiDCoA0KPiDCoHN0YXRpYyBpbnQga3NneGQodm9pZCAq
cCkNCj4gwqB7DQo+ICsJdW5zaWduZWQgbG9uZyBsZWZ0X2RpcnR5Ow0KPiArDQo+IMKgCXNldF9m
cmVlemFibGUoKTsNCj4gwqANCj4gwqAJLyoNCj4gQEAgLTM5NSwxMCArNDAyLDEwIEBAIHN0YXRp
YyBpbnQga3NneGQodm9pZCAqcCkNCj4gwqAJICogcmVxdWlyZWQgZm9yIFNFQ1MgcGFnZXMsIHdo
b3NlIGNoaWxkIHBhZ2VzIGJsb2NrZWQgRVJFTU9WRS4NCj4gwqAJICovDQo+IMKgCV9fc2d4X3Nh
bml0aXplX3BhZ2VzKCZzZ3hfZGlydHlfcGFnZV9saXN0KTsNCj4gLQlfX3NneF9zYW5pdGl6ZV9w
YWdlcygmc2d4X2RpcnR5X3BhZ2VfbGlzdCk7DQo+IMKgDQo+IC0JLyogc2FuaXR5IGNoZWNrOiAq
Lw0KPiAtCVdBUk5fT04oIWxpc3RfZW1wdHkoJnNneF9kaXJ0eV9wYWdlX2xpc3QpKTsNCj4gKwls
ZWZ0X2RpcnR5ID0gX19zZ3hfc2FuaXRpemVfcGFnZXMoJnNneF9kaXJ0eV9wYWdlX2xpc3QpOw0K
PiArCWlmIChsZWZ0X2RpcnR5ICYmICFrdGhyZWFkX3Nob3VsZF9zdG9wKCkpDQo+ICsJCXByX2Vy
cigiJWx1IHVuc2FuaXRpemVkIHBhZ2VzXG4iLCBsZWZ0X2RpcnR5KTsNCj4gwqANCg0KVGhpcyBi
YXNpY2FsbHkgbWVhbnMgZHJpdmVyIGJ1ZyBpZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5LiAgVG8g
YmUgY29uc2lzdGVudA0Kd2l0aCB0aGUgYmVoYXZpb3VyIG9mIGV4aXN0aW5nIGNvZGUsIGhvdyBh
Ym91dCBqdXN0IFdBUk4oKT8NCgkNCgkuLi4NCglsZWZ0X2RpcnR5ID0gX19zZ3hfc2FuaXRpemVf
cGFnZXMoJnNneF9kaXJ0eV9wYWdlX2xpc3QpOw0KCVdBUk5fT04obGVmdF9kaXJ0eSAmJiAha3Ro
cmVhZF9zaG91bGRfc3RvcCgpKTsNCg0KSXQgc2VlbXMgdGhlcmUncyBsaXR0bGUgdmFsdWUgdG8g
cHJpbnQgb3V0IHRoZSB1bnNhbml0aXplZCBwYWdlcyBoZXJlLiAgVGhlDQpleGlzdGluZyBjb2Rl
IGRvZXNuJ3QgcHJpbnQgaXQgYW55d2F5Lg0KDQotLSANClRoYW5rcywNCi1LYWkNCg0KDQo=
