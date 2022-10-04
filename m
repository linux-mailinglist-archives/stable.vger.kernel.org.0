Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1E5F4643
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJDPOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 11:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJDPOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 11:14:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0365F5C9DA
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664896447; x=1696432447;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xsca9zHdkVJneKupEbk1p6pr9QJuxZid3ga6O+b1EUc=;
  b=FgKCH051KbmEJL7jJ4+hCjBd7McUxJS68wgrlxyGDX1tDTm3JsZQ3l5/
   Z3/80FzXP3KRkqkvbpF+NCJab6bbtBe+C2ewO4iLy15UFccYWhAgoVWOl
   KLv1vrgZBDN1Y3dfwLZBNy+siqt4djKpW89OxNpLr6eBq2SoHYVnXEJhM
   t6/gvUqmJd3aAILxEMgrWhW2mKPMunvhDmNTvTRM6ij4YBFxtuUobFMop
   0Ej0wJMEskuEEqXEst/oHVXHzn+UuEBUH+KkkpnNcgfBSTdIw9KvOsdQD
   OP/u3wRLegWNp3U5curJLAs21J0dMUIbKM5QykP5BemfUvERZAHX00A6z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="367031021"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="367031021"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 08:14:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="686577317"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="686577317"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 04 Oct 2022 08:14:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 08:14:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 08:14:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 4 Oct 2022 08:14:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 4 Oct 2022 08:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P16TSUiEich6t/IBw9527Yrk6KgZ5kvWmSz3oisb0yi4F62mxVxtdcJLcg79gZRrqMOGwKz06D+jtgFpwKI7HoE0WPh7k+VOB2UKpANeryrt7DgvpfNIPiLWtTcOlMYPnA3ICPo9ggIjj2XmevKXea5XV9d0mJVvtvnNl7W6eWqcF3qBCklbKG7/jnTdYPbcN3fr4skgcb8AII/e9PjjmZtJ2YF7Y/49r2arvrtcGnYbnRueVMHV9l7Iol7iC1DVpP0GN6wx5TRXm97ecsiasfJzEOCblA95P3o+CEtcl6yx8jrG0R54zeLL6ImluBnO+jDoZtvUl0/g12xfatTFIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYqCgNb9PLkdgUpBfkObfm0xXQde12eajx0E9I7BGuU=;
 b=OmxLmZBE22UIaN+t/LfhXID+s3d9sDVJs2tdaINVBzxtWb4K6FKSYG+LiqG4WzIkvRbcCNU5QIO0XTGw06ietKLnoX8ureLjbGyPmtot9dq9goncJMO1yoApId3/zoBlgTnVVeNIIUs8FTXxy3msmT2imfkrRDr9ghokChjLUKI3te50xbK6EWcnnEYgknEmFg6cHnmf2/VouqZHId4ILk7o7xWmZAaEAyRQI1MA4idnNzH1YAHIxAwje5NR/QcIvmM1xtkysEDYIXxMSloXoECCuKivtEr+CN/6Xb7KCD258JSCjt0/9FbUhsFZfT0jdxr+Wh/HSAvs/T5BV9TTUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5475.namprd11.prod.outlook.com (2603:10b6:610:d6::21)
 by MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 15:13:57 +0000
Received: from CH0PR11MB5475.namprd11.prod.outlook.com
 ([fe80::4061:3db5:84b8:8f77]) by CH0PR11MB5475.namprd11.prod.outlook.com
 ([fe80::4061:3db5:84b8:8f77%7]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 15:13:57 +0000
Message-ID: <e2140d7a-b084-4298-d92a-649d0672fcc7@intel.com>
Date:   Tue, 4 Oct 2022 08:13:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915/guc: Fix revocation of
 non-persistent contexts
Content-Language: en-US
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        <Intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>
References: <20220930094716.430937-1-tvrtko.ursulin@linux.intel.com>
 <20221003121630.694249-1-tvrtko.ursulin@linux.intel.com>
 <36096340-aac7-7072-688a-bbef4e7d7d7f@linux.intel.com>
From:   "Ceraolo Spurio, Daniele" <daniele.ceraolospurio@intel.com>
In-Reply-To: <36096340-aac7-7072-688a-bbef4e7d7d7f@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::34) To CH0PR11MB5475.namprd11.prod.outlook.com
 (2603:10b6:610:d6::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5475:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c6c691b-1ee3-4ef4-43c8-08daa61b0f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZ3GfcZKlcilqCTymK4AT7tK/xiiR+RVc4ulg62scsjcoOX47oGgj7x+S1XSK0mzvnFwbJf7KVb00WBHONZCNXhp+6yh63xxpqIouGhP+eCf1S7rZpEd/vSWJDnGIzuqvf91KZoAEOtqCbUhjS1pO2BYmDl4eerpEW8jroD0nJht+9ILDCMW6R7HZTE7Mz+EpGIggSdl8FVjlIl4z2A2lNzGH2Ew5a47ubLyY4yDB78M+01XU3u/q4ke78bejvY8rcOhC7cKHQdHUqyuTI+gxVKMS5UhRokbQ1jvN+9RW+rjgEhzOopAYcczkHMbj0heFKCy3GpohbaZ0svWb59vCjddzqUGHZ6pSQziHYqztGe3BkPWjSNnSP4JqfoowO7rPQNwpXldfQ5M5IQfrhgz0dB2UWbzTvz/M+A3lwKKiYmMiHjmjAhxTCdD9qgcAt78AQDsx/bDxXkV0gPruyHBhMYwzCd4OWr8yp/9BsKKf6XXYwPVnod9oHXKGrkUxEx+1IiCUFAl3WAxWJJbEGfKElABZedn7edeb2BjYRwvUfVNRhlzyuRNQgo+LtEeIJ+JyGHKvA7Ink2lwSFf5Rv78YRHae3PhhMJexWLkSstnkzVp5Eghbh9tCIoFjscwNEIGwcBI1nPVSi/HgfEIFP7hCLulOPwjIpLjDI7eLZ+TvZJvceyJvnQTlqbX5SoJyT8LNkpIzjiQZzOnC10z8UHrINHBV5T1fWQodeLuSOMkTVX0ew2DleyVUE38AbldIeeWvHElMLYxzMjVcU8Y+UJNSWA09BUHtyoG/C+fM2CLik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5475.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(31686004)(36756003)(66899015)(86362001)(2906002)(31696002)(53546011)(6512007)(26005)(82960400001)(38100700002)(66946007)(8936002)(41300700001)(66476007)(5660300002)(66556008)(4326008)(186003)(8676002)(2616005)(6666004)(83380400001)(316002)(478600001)(6486002)(54906003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk5xRTRhQXhuM0JueDF3L2J6NzVGdU5ER2xBSEpYc09SZzNWRm1IVnI1Zi91?=
 =?utf-8?B?SCtHM2pjRlBrL3JFLytJV00wYlptTGgzRElXSW9rSzl4THpsbWpHRStRR1V5?=
 =?utf-8?B?ZUQ3c0FpekdVbHIwWTN4QTcvT1dydU1qVE8yRXgybnd5eUowV1RJeDByV3o1?=
 =?utf-8?B?aXJ5Sml1UzRXcWxwOTlmY0VnSGpaVGQzdnhPM2IyQjRsdGVwOWZCWkUxZzYv?=
 =?utf-8?B?ZmlwL1cveTJqblhBWXlnUEtsZnhoZXlSaHc3YVJYY3p5aXdFSFdSQXNlQjNL?=
 =?utf-8?B?WXFkankrUTk0dUVFN3JueXhJMVhCZE1iUDR2eFBhcW1FcWcyamFONjlnbkNZ?=
 =?utf-8?B?VzhPVktRS0R6VFJJYmpGMXYxM2MxVFpTbkJiNGd6clVWZFVEQ09yVDB6OGE4?=
 =?utf-8?B?RjJsSUJRd0F4cTFhUWtvNHBIaGNqbjBTN0F0bDR2aWJpcmg3U2I4QXQ3Vi90?=
 =?utf-8?B?d1h4bGFBcmFzRGVvOTA1emg5K0hFRTROR3lHaytBQXQyQ0kwRTBwQjRSaCtU?=
 =?utf-8?B?am1MVGhlcnFaTDFVZGNnUDM1SXRYa2dNR1RIYVJUaXBGcWkwNy9QWlNPNmpN?=
 =?utf-8?B?UTZCYkVsUzNjSGtUNWcrK2NWeE1ZNjZoVXhsOStVU0I4THdyaWZPWGhFVlI1?=
 =?utf-8?B?MlFaZVAxREtxaWhvdWpxb1h2bFJYcm1NcllOVnhpOUVDNjBMT29oN0Rtczcx?=
 =?utf-8?B?Y21Ocy9mNWVWcjhpcVlKeE1PM0x2Ykl2Y2lqU1h0TEo3ZkdkUU9pZ2hNMWdG?=
 =?utf-8?B?cTZSL0Q3QUxUaHBTY2EweVhGanpsTDFVRXFkN1ppRzYybDlOOEYzaHZqTVN0?=
 =?utf-8?B?K1ptWUtBbmdIcXNEN0VzNFRnK2RyajNBOENnVFBLS1VqNDdPcmkzcEZKWDJw?=
 =?utf-8?B?NUgxRGNWZzdrRHUzUzQ5WXYxUFlqOWJ4cUdMVjFLbmt6MVZBLzBqdmY1bktM?=
 =?utf-8?B?MXVBWTZ3emRRODY4cTFBMkNVdk1VcTFoYTVjWURZa3QranYvRUxERkY4M21y?=
 =?utf-8?B?eStuR2JFeDFtYTkwa3p3ZXJDWGQzM2luUG1RenhadVZGcEFpM2tpMElhQXBr?=
 =?utf-8?B?cTA2bTNTY1pBZUN5Yk1zampFMXBNdWEwQWhHU1pMOU1HU3ZWUElRZ21HVkxu?=
 =?utf-8?B?dlRuNzZHd0VhYVJJcGpTaXh3YmtPTDhRdWNNNGwxeGVNUGZPbTArbkJxS25V?=
 =?utf-8?B?TmpzT3pwUEhDcFBDVWJUNTE4VFlzMHRYZVhMOGVOMVRRamNRZm9vcFdjMHdz?=
 =?utf-8?B?c0tTby9GQ2Z1bitmRFNyQ01iREtFR1ZXckp2cmpTWFVLQTRFM3JyZCtmM3E4?=
 =?utf-8?B?ZnYvb3YyZ1NkTHUwNFNidnRyV1R3YUpZdVRteCswSDF2eUp0am5pZXRYNUVN?=
 =?utf-8?B?OVFsS1pkUllRMktjamM2UWhLajJEd0l2ZCtia1VsUi9xV3Zhb2o0Mnp2NzNv?=
 =?utf-8?B?dWlZNm9QMG9icHNUT29UYXRFamlKZFhnaVNhV3MrcDFiQkJCeEV4M1ZMc0R3?=
 =?utf-8?B?YjgvOXQwTXpMRXNkNUZqd1dTZXozL1dSdFlZN2NRUUtQcm5qUVErTTBKcUds?=
 =?utf-8?B?WlFMQzlrV0JkWnRBSm9IbGNpL2VjcHQ4Z1gyTnZyaVl1VVZPVEZkSFU5SG5v?=
 =?utf-8?B?RlZqUWJTbkRrYWJGbFl4S2tWL29nZWRvMzl1ZXNqRTFhMHJ0R094bGNyQ3pp?=
 =?utf-8?B?MDdHZnVNNDNRNG1ZK2FwYlpQSS96QjBxNHNXUDNBWDd5MUFGWjhDbDlnMTd3?=
 =?utf-8?B?R0gyMjZBR3V2Y0l2cEg0YlJQVnlCKzY5eTNtU3hMUGhETHd4VXN6RU9qb1NV?=
 =?utf-8?B?QTNwM1BRWGFMNHA0WVVuK2lOZit0MURIQTk0MVErSTV1TVJuMHl0Y0huOSsz?=
 =?utf-8?B?ZTNWMUVtU1BDTE9HOHhGdS80bG9iMmdYY2RPZitkZnhWd09VWlN0MUg2QTBS?=
 =?utf-8?B?VlNzNHpubkxYWlRPT0svRTF0UEJITk1XMjdXcUhKQi9HUXMwdVJocWNVQjBJ?=
 =?utf-8?B?eTNNSnFiU1RLOWY4SUY5Y2xBbDgwVTdCOEZ6TGhXNnVwejZ3ZUVudGNIOXdr?=
 =?utf-8?B?VWFGM0l1OEN1TGtRRmJEQ1BGaTZtNCtKYTlId0U1aUZrU0tzUnk3Rys4TVpv?=
 =?utf-8?B?ODdhMFQvQk9ZOWIvbENwTE5ORFFjM2NPMGk3QWNGSzN2SWtaQm1NTGg1QmtX?=
 =?utf-8?Q?DP69h5xCZY3QBxhuAKN+Fr4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6c691b-1ee3-4ef4-43c8-08daa61b0f1b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5475.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 15:13:57.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mwsrqSevMVkS+sZ4RPvVDy+91Teqlb8o5q00pu/QZ4Wr1cTgMoDQ012CSxhs0ruO8jm78yMkgngYVe1qZzOd4Xp9+WdMTiHCq2HLyiu/tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/4/2022 4:14 AM, Tvrtko Ursulin wrote:
>
> On 03/10/2022 13:16, Tvrtko Ursulin wrote:
>> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>
>> Patch which added graceful exit for non-persistent contexts missed the
>> fact it is not enough to set the exiting flag on a context and let the
>> backend handle it from there.
>>
>> GuC backend cannot handle it because it runs independently in the
>> firmware and driver might not see the requests ever again. Patch also
>> missed the fact some usages of intel_context_is_banned in the GuC 
>> backend
>> needed replacing with newly introduced intel_context_is_schedulable.
>>
>> Fix the first issue by calling into backend revoke when we know this is
>> the last chance to do it. Fix the second issue by replacing
>> intel_context_is_banned with intel_context_is_schedulable, which should
>> always be safe since latter is a superset of the former.
>>
>> v2:
>>   * Just call ce->ops->revoke unconditionally. (Andrzej)
>
> CI is happy - could I get some acks for the GuC backend changes please?

I think we still need to have a longer conversation on the revoking 
times, but in the meantime this fixes the immediate concerns, so:

Acked-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

Daniele

>
> Regards,
>
> Tvrtko
>
>> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>> Fixes: 45c64ecf97ee ("drm/i915: Improve user experience and driver 
>> robustness under SIGINT or similar")
>> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
>> Cc: John Harrison <John.C.Harrison@Intel.com>
>> Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>> Cc: <stable@vger.kernel.org> # v6.0+
>> Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gem/i915_gem_context.c   |  8 +-----
>>   drivers/gpu/drm/i915/gt/intel_context.c       |  5 ++--
>>   drivers/gpu/drm/i915/gt/intel_context.h       |  3 +--
>>   .../gpu/drm/i915/gt/uc/intel_guc_submission.c | 26 +++++++++----------
>>   4 files changed, 17 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c 
>> b/drivers/gpu/drm/i915/gem/i915_gem_context.c
>> index 0bcde53c50c6..1e29b1e6d186 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
>> @@ -1387,14 +1387,8 @@ kill_engines(struct i915_gem_engines *engines, 
>> bool exit, bool persistent)
>>        */
>>       for_each_gem_engine(ce, engines, it) {
>>           struct intel_engine_cs *engine;
>> -        bool skip = false;
>>   -        if (exit)
>> -            skip = intel_context_set_exiting(ce);
>> -        else if (!persistent)
>> -            skip = intel_context_exit_nonpersistent(ce, NULL);
>> -
>> -        if (skip)
>> +        if ((exit || !persistent) && intel_context_revoke(ce))
>>               continue; /* Already marked. */
>>             /*
>> diff --git a/drivers/gpu/drm/i915/gt/intel_context.c 
>> b/drivers/gpu/drm/i915/gt/intel_context.c
>> index 654a092ed3d6..e94365b08f1e 100644
>> --- a/drivers/gpu/drm/i915/gt/intel_context.c
>> +++ b/drivers/gpu/drm/i915/gt/intel_context.c
>> @@ -614,13 +614,12 @@ bool intel_context_ban(struct intel_context 
>> *ce, struct i915_request *rq)
>>       return ret;
>>   }
>>   -bool intel_context_exit_nonpersistent(struct intel_context *ce,
>> -                      struct i915_request *rq)
>> +bool intel_context_revoke(struct intel_context *ce)
>>   {
>>       bool ret = intel_context_set_exiting(ce);
>>         if (ce->ops->revoke)
>> -        ce->ops->revoke(ce, rq, ce->engine->props.preempt_timeout_ms);
>> +        ce->ops->revoke(ce, NULL, 
>> ce->engine->props.preempt_timeout_ms);
>>         return ret;
>>   }
>> diff --git a/drivers/gpu/drm/i915/gt/intel_context.h 
>> b/drivers/gpu/drm/i915/gt/intel_context.h
>> index 8e2d70630c49..be09fb2e883a 100644
>> --- a/drivers/gpu/drm/i915/gt/intel_context.h
>> +++ b/drivers/gpu/drm/i915/gt/intel_context.h
>> @@ -329,8 +329,7 @@ static inline bool 
>> intel_context_set_exiting(struct intel_context *ce)
>>       return test_and_set_bit(CONTEXT_EXITING, &ce->flags);
>>   }
>>   -bool intel_context_exit_nonpersistent(struct intel_context *ce,
>> -                      struct i915_request *rq);
>> +bool intel_context_revoke(struct intel_context *ce);
>>     static inline bool
>>   intel_context_force_single_submission(const struct intel_context *ce)
>> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c 
>> b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> index 0ef295a94060..88a4476b8e92 100644
>> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
>> @@ -685,7 +685,7 @@ static int __guc_add_request(struct intel_guc 
>> *guc, struct i915_request *rq)
>>        * Corner case where requests were sitting in the priority list 
>> or a
>>        * request resubmitted after the context was banned.
>>        */
>> -    if (unlikely(intel_context_is_banned(ce))) {
>> +    if (unlikely(!intel_context_is_schedulable(ce))) {
>>           i915_request_put(i915_request_mark_eio(rq));
>>           intel_engine_signal_breadcrumbs(ce->engine);
>>           return 0;
>> @@ -871,15 +871,15 @@ static int guc_wq_item_append(struct intel_guc 
>> *guc,
>>                     struct i915_request *rq)
>>   {
>>       struct intel_context *ce = request_to_scheduling_context(rq);
>> -    int ret = 0;
>> +    int ret;
>>   -    if (likely(!intel_context_is_banned(ce))) {
>> -        ret = __guc_wq_item_append(rq);
>> +    if (unlikely(!intel_context_is_schedulable(ce)))
>> +        return 0;
>>   -        if (unlikely(ret == -EBUSY)) {
>> -            guc->stalled_request = rq;
>> -            guc->submission_stall_reason = STALL_MOVE_LRC_TAIL;
>> -        }
>> +    ret = __guc_wq_item_append(rq);
>> +    if (unlikely(ret == -EBUSY)) {
>> +        guc->stalled_request = rq;
>> +        guc->submission_stall_reason = STALL_MOVE_LRC_TAIL;
>>       }
>>         return ret;
>> @@ -898,7 +898,7 @@ static bool multi_lrc_submit(struct i915_request 
>> *rq)
>>        * submitting all the requests generated in parallel.
>>        */
>>       return test_bit(I915_FENCE_FLAG_SUBMIT_PARALLEL, 
>> &rq->fence.flags) ||
>> -        intel_context_is_banned(ce);
>> +           !intel_context_is_schedulable(ce);
>>   }
>>     static int guc_dequeue_one_context(struct intel_guc *guc)
>> @@ -967,7 +967,7 @@ static int guc_dequeue_one_context(struct 
>> intel_guc *guc)
>>           struct intel_context *ce = 
>> request_to_scheduling_context(last);
>>             if (unlikely(!ctx_id_mapped(guc, ce->guc_id.id) &&
>> -                 !intel_context_is_banned(ce))) {
>> +                 intel_context_is_schedulable(ce))) {
>>               ret = try_context_registration(ce, false);
>>               if (unlikely(ret == -EPIPE)) {
>>                   goto deadlk;
>> @@ -1577,7 +1577,7 @@ static void guc_reset_state(struct 
>> intel_context *ce, u32 head, bool scrub)
>>   {
>>       struct intel_engine_cs *engine = __context_to_physical_engine(ce);
>>   -    if (intel_context_is_banned(ce))
>> +    if (!intel_context_is_schedulable(ce))
>>           return;
>>         GEM_BUG_ON(!intel_context_is_pinned(ce));
>> @@ -4518,12 +4518,12 @@ static void guc_handle_context_reset(struct 
>> intel_guc *guc,
>>   {
>>       trace_intel_context_reset(ce);
>>   -    if (likely(!intel_context_is_banned(ce))) {
>> +    if (likely(intel_context_is_schedulable(ce))) {
>>           capture_error_state(guc, ce);
>>           guc_context_replay(ce);
>>       } else {
>>           drm_info(&guc_to_gt(guc)->i915->drm,
>> -             "Ignoring context reset notification of banned context 
>> 0x%04X on %s",
>> +             "Ignoring context reset notification of exiting context 
>> 0x%04X on %s",
>>                ce->guc_id.id, ce->engine->name);
>>       }
>>   }

