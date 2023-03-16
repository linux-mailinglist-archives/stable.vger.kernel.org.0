Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EED76BDA7C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 21:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCPU6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 16:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCPU6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 16:58:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F3D6A42D
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 13:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679000321; x=1710536321;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rydI6o7V+IYvZbbzy224QtzmzrK+nNXGUfqQuRZIzP4=;
  b=G21QWQXOza2V/jRieiKo7KoHMOjci+mflqnv7VXry1rS3HkcgfnAti8q
   yTcpExVcuogAE2LMVH4famUuYOhg9T13WOtrHD3Hhue8n1WuCq7686pBc
   jDpJO4UDkInBLinpVQaSoyL9G5Li4FmaneH+x6/xY+to80WXNew1rRDWA
   42XUJlE9wU/c0kp7eI/Y42UahPs2SfsPKlIMdMyY7HWAHVBpbVdcL15ra
   NkwsDo5pH/K4OaUD9kMUu+0i6PftfIxLUNSKnrO23SH6MpjJvpSKVi51T
   tAOzIiS05WeuyPiRbKSx1/8PxpuQStEEJbo1qpMzuydb4dH2txwQftnxV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="400696509"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="400696509"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 13:58:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823414365"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823414365"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 13:58:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 13:58:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 13:58:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 13:58:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAFuue0O2HcYQU0ft2HXhyt/gjbAyVzk6kglKr6z6sfFmWB6X94dd0L4WkT7bumUyraENI+L6rH338sAfv8Ym7Covt63k4aQrmW1hHoDp2tGxkSD9bHwO7iR6ycgd5eUdolHcTyxvUyF40Qk6KtX5GAiWoeCObP0b57u1vKruGcQs9Qgg+pxP7FsuHJPMlGaH+YuXg3TUOjdpOBEbg8Gg2gIMx+zFvWgnhjFvMiXD112W97C3jdm2U6hg+9XJOXFeDn8rUwZcLaPTtwDhX+wP13iYZYxIiuRevhimkmWglCwnvsHgF+kSQloplYC8wexVDDowl8m1ZY0uEwyczZk9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8a/tHEdwE+tW44M3McDd+z2L0oLrJdGKArvHi0k7ck=;
 b=lWCtSQvoqGryhXTj8+Ov+26UBBVLhybYWlMjUJ/bqUGAe31QugAoPdsdN+vI9CjkltmyJaFXTOeaaNON/oqfZ7QlYi3A9gY3Jvg2nR7NPcrENLCQJQZZYt2mkaT32e2gC+d4d4QpBhjlycRQ9wVchoQ32Lru2IJSFwQWlZWrhrjF84/aQqGNtcwTTKO+XXKX7B5ZV1iUicH74lRm0Gbk42R1mHy5jjDcb49f2eshCOpMzSvoAnl9onxYEs1sQ8CyF+bLMQYi7BWEL0jblyXE1WurCw2iGmBIhVepjerhDYH/8wDH08pXPpUCqej1Lp6OJd/31PnWEeNBJH5GfeIFVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by CY8PR11MB6915.namprd11.prod.outlook.com (2603:10b6:930:59::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 20:58:38 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab%6]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 20:58:38 +0000
Message-ID: <5ed286b7-c2df-9e63-d85a-be9994f93eec@intel.com>
Date:   Thu, 16 Mar 2023 13:58:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
Content-Language: en-GB
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Jouni_H=c3=b6gander?= <jouni.hogander@intel.com>,
        "Daniele Ceraolo Spurio" <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com> <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
 <ZBIHJD5FkxiammjB@kroah.com>
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <ZBIHJD5FkxiammjB@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::43) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_|CY8PR11MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4f8705-cd50-48e3-6af6-08db266136c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awFtvOOwJaIgy04/LjQEntvWl22SAow5inWXqtkRaaifJZZgL/JRhVM0Fm52D1K6cfvg6q+QfGlYEqbqy4YcIk/NOfCb0E+/raoTQOHbpwQNYBIZS6AvAcV8SWwIvjhYKDADtOBk/YQaLRtx9zD642q2bhfJwAWV2Uo8YCfWygLjO7UMSENKknMbhEvUFlPLB86IhS1gPUY1hSHB4zM3G1AQ81CHNo6Xf727TOZOb2V4itcJtwS7Hjteke+g8Do+5MEO9VYg+RBLR3XHK+cOFUppsliWFPkCP+PogNhstC88DHqZGTroUfcvIOc7oopLW4YYpp5yF8doPwWEovGDFj9jYApxgzeo86RDhCeR5kbWMzmZa6MZj2BOTXTwkY1icQnFTcgR/8rBkBQLr1lbOBYHYDdffYsGM5lonoT9wquNBDouio4es6GmHOO1/59o5PY80HooBySc31IC+2uFp6ZkP6DQdKwlmmx1cX/cKr5xDYKsOFXMhmiCHGS6/dbXJlDd3S0tTu/4QVP8v3sGIQASK7HLnNaldfIkIpxDwBv4U6GcCFbwnDUvpBYWZqitBt06JnMtmTFSexbPldI+PCeC62OqSdBmZkpoQ6ologNqXisY9sDltWMU6obN6w8Dz3crygw9L/uQArqwC2A3QuBVrmE22oHHo10P3WuZTk3V/gCCcoFrs379TC3XAAm8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199018)(36756003)(6916009)(83380400001)(66574015)(478600001)(53546011)(6666004)(26005)(6512007)(5660300002)(966005)(2616005)(6506007)(31696002)(66946007)(66476007)(8936002)(66556008)(8676002)(86362001)(4326008)(41300700001)(54906003)(316002)(82960400001)(186003)(38100700002)(6486002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDJpU2ZtbWoyVTdibnlFbm1KeEhkZVI2MWpiYjVNSmhySG9hOWFwUUxJSVFW?=
 =?utf-8?B?bHlaQ0NVdlVadnhLbmFKVGFlMXlGRUNzREk2VUJPd1FaSFlqdGhpNUdSa2hu?=
 =?utf-8?B?b3RFZFlVR0RVeUtaOW1EekpiQXlTVzVKMGRMVFhXMTczVE0rT1ptaU5tTzZE?=
 =?utf-8?B?YXFoSjJnNDkyaXJqRTZLV2JndjB1MWlQSjBkSzAyaldCTVg0RmVNZTFuSlVJ?=
 =?utf-8?B?Y3pST2t5cUI4Rzl0bXlzdE9zYlhuSGNsSFRQT0t5ZkJsM1hhMmtZdVhhUExw?=
 =?utf-8?B?ZTlFMnBRcEJZTnM1Z1RZL09Nb3J5aHk3UHUwUG9IYmJOU2ZCd2V0dllnOVBI?=
 =?utf-8?B?aHJ3VmUxd1pRSjdJeWM1V3BxajIydXMrZUxkQU1LUjJwbVh1MkNBbm81Vjdz?=
 =?utf-8?B?Y3dWT1ZoSnBDUENGNm5zc0g1T3VrU2pTci9tRmZycXdrRjFUajBWZWpvZlN5?=
 =?utf-8?B?Vk5HdTkxWkJyMkpjeHVtdUFXejg1WElibmF3ZHg5UkF3YWlGTVYzY3dIbDR2?=
 =?utf-8?B?RkFnVk5sZTVIQWpLdWZJQnlSc0NTNmRsOGg0QjRRTUh0OFZTekd1OFhkYlVs?=
 =?utf-8?B?bEdSVFRMS3FLRkJvQ2JvRXA0ZjF5SElLSnZIbTRUV3VuRmtjOWpCRmhZUk1j?=
 =?utf-8?B?UjZkY1BBNCswSnExNFFEdU8zS0trck03M3hLWjlCSVJiLyt3VFZHSllQc3dM?=
 =?utf-8?B?Ung3bUQrUHlDZjlHVHdRMitQWnA2MzJCbi91RHhSMXFQTnZ2UXh1NXp5bytp?=
 =?utf-8?B?aUZCeGdsRWpkdGJIZDJSWnBNNHBHdUxvMlR2YVhzTXVxMGRucFo1Y1gxWVU3?=
 =?utf-8?B?ZW4vQVdwUnJhL1JLNjNZNGZQL1hGTXhsblBqQ1d4TnJDMDkvdWJCekVvbFdw?=
 =?utf-8?B?Zy9GUndCSzF0a1B4NWk0ZFVtVGFTOCtRNUFObitscVQvWTB1QU5uM2Z6WUlx?=
 =?utf-8?B?bW5FTUpmRjA1NHZqK3NhdU1CQkRNN3NwZVdJdTlIbEpuWXg1WUNlWW9QTjdI?=
 =?utf-8?B?L2lNVEtqUjc2Vk9JSTJzTnptNjI4aG5qUWpPR3ZyMm5qN0JNaE42SHJKeFh4?=
 =?utf-8?B?dmhVWExkd3JNci95YXViTGtZVkNienBZb1ovWlhrcHlCbk1zVENBeE0za3I4?=
 =?utf-8?B?ZmdlYjRNeGpISGVyYTkwSFUvdVREYkI2cmR0bjgvMDB1SzJ5c0dXdUo0SSsz?=
 =?utf-8?B?VnNvZ29NTW1EM1d2eWV3RCszU2hBN1FGalMwUjNzQ3QreWFPSEpSai9kNEsw?=
 =?utf-8?B?VTFFYTFSMHh6dVVEWjZoY1ZlR3dTRnZkUm5EcFpNN1luZmRxUUxKMXBrU2dI?=
 =?utf-8?B?b1RGaWZjcytIaGNSeEI3N0xnTHgyR1V5VWM3S0NCREcxVDUxbkNzbmlWSXFR?=
 =?utf-8?B?UFpScXpadnM4cTRUVXZxTTV5ajhPdWswSExocHdpeU9nWVRpQjQzeWdHNjl0?=
 =?utf-8?B?b3pjTE8raDlSQkVoeGhqUjNFR0pUYWgzZ2o3WXd4Z1lKb3ZJdWczWG1UNjBX?=
 =?utf-8?B?NVcxamhHcTNNaFhuOHJaT21TZmp6ZEJZeEp0dUR3VkNiK2xqSW10NmR2Njlh?=
 =?utf-8?B?WFk5VnpUWXVsdXE4MTBnU3g4cTg2VmF2SXYvN0ZLdVh4WE9BWU13TmRqbFBR?=
 =?utf-8?B?MkVvbnRZNEtKa1lHMTl3b2VkcUp6VHBmQTltYXRKRUZQTndWN2xlVGpvWFFa?=
 =?utf-8?B?ZkdUa1BqME9jYSsvTXNJUWhmRTVpZXFaZzMvWXhjbW5BNklQWHc1REhia0ZW?=
 =?utf-8?B?NkZJamFxVEpIYi9RblN6c0lyT284L0huR1k4WjF3ekxXQnhlUXE3TXdVeDhX?=
 =?utf-8?B?UFRxL3NWMnF5RkJSenF5Z3NqUkRrNW8yNmY2TU9vL1JyNS9wT1lUSkFKWTho?=
 =?utf-8?B?blZwR2t2MFJsRWpOUnYzekZ0bG11UVdJMFVpQUlIR1BwMXFoSTYzamtreUEw?=
 =?utf-8?B?S1hoeXpLRmRQYjAyemVkNlh5b2U2Mk1jdERWSldyY0t2aWxKZW5RS2I1RkxQ?=
 =?utf-8?B?Y0JFYTlVQjRBcVpBbEVQbEJ4UDVKajI3TTZpM0NaV0pZM1NBRjU0Z2ZhaTNv?=
 =?utf-8?B?bUVjbUhUNTNvVlNqRjBjMEIyZ1ZEOXlpNzhUcFRnOEZCM2FRa0FZMGhFcUZk?=
 =?utf-8?B?aTlkd3Nwek9sQURqdWhyUktlc2YrVnh2RXBYcngwaTBYUWRscEdEM3h3Tmw4?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4f8705-cd50-48e3-6af6-08db266136c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 20:58:37.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rV2+O7zL2wohARm/m2hYJnTj6JVdsh3cL+wfVZky7nfVNJoDWyjAbW/fMEU/H0huV4jQCgRSfNr0WDpb3Zj/Io/zPPz1xt14vEX9HFAoFSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6915
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/2023 10:57, Greg KH wrote:
> On Wed, Mar 15, 2023 at 10:07:53AM -0700, John Harrison wrote:
>> On 3/15/2023 00:51, Greg KH wrote:
>>> On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
>>>> From: John Harrison <John.C.Harrison@Intel.com>
>>>>
>>>> Direction from hardware is that ring buffers should never be mapped
>>>> via the BAR on systems with LLC. There are too many caching pitfalls
>>>> due to the way BAR accesses are routed. So it is safest to just not
>>>> use it.
>>>>
>>>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>>>> Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
>>>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>>>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>>>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>>>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>>>> Cc: intel-gfx@lists.freedesktop.org
>>>> Cc: <stable@vger.kernel.org> # v4.9+
>>>> Tested-by: Jouni Högander <jouni.hogander@intel.com>
>>>> Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>>>> Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
>>>> (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
>>>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>>> (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
>>>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>>>> ---
>>>>    drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>> Also queued up for 5.10.y, you forgot that one :)
>> I'm still working through the backlog of them.
>>
>> Note that these patches must all be applied as a pair. The 'don't use
>> stolen' can be applied in isolation but won't totally fix the problem.
>> However, applying 'don't use BAR mappings' without applying the stolen patch
>> first will results in problems such as the failure to boot that was recently
>> reported and resulted in a revert in one of the trees.
> I do not understand, you only submitted 1 patch here, what is the
> "pair"?
The original patch series was two patches - 
https://patchwork.freedesktop.org/series/114080/. One to not use stolen 
memory and the other to not use BAR mappings. If the anti-BAR patch is 
applied without the anti-stolen patch then the i915 driver will attempt 
to access stolen memory directly which will fail. So both patches must 
be applied and in the correct order to fix the problem of cache aliasing 
when using BAR accesses on LLC systems.

As above, I am working my way through the bunch of 'FAILED patch' 
emails. The what-to-do instructions in those emails explicitly say to 
send the patch individually in reply to the 'FAILED' message rather than 
as part of any original series.

John.

