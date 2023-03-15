Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A5A6BBA92
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjCORKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjCORKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:10:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13218C15B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 10:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678900235; x=1710436235;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nj0qfWJNJzVnYYnX6+KvchjqtPVP6HGjRN6zSKHmg5w=;
  b=ICZb/JbocQUewuO7+CDFNCxFCO9BIRChpp9+4kI8P3EH7niFmMeUZDt/
   TgDY8Mkc0/CYYfYHfbAVBnxeA04hRn6r6p8HzpNUDPdVn4+69wKiTUZY6
   8uca/6enEWjGTAeBcVd4eNqxi+RQm9twsalAOpcfLhm6MLnd8ImEn8O3F
   g3XSesjoq9FAhZNfvzZHTQns+W1UGmP7sOD36dVOFEEuwbHSyNLnwpHFD
   8iVDK6WX+Jn1SXJbfHHg/1/rDL/saq44Bs32hA9RVq5o/8M6p0mlP1dvz
   8RjD/ZmPl/IaUdaeJWFvsXop/Jer81JSjMGWNuBKV5RLQHrUEtZwEqOtH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="321612538"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321612538"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 10:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="768585469"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768585469"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2023 10:08:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 10:08:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 10:08:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 10:08:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/KUT954Dqy73HwEgwVE8hEkkiHOQBUnmJjyprub90nag0g65zDjF9ZuU8AKOtgAKFnxFx3pI8C9/U/fj6vxXF85vdYiq9CxLLM/Xa8z2NdGo7v19gcpzI5PdnMMdb3xH/QvevTwAsA59NpcG1QwGaD8m/XqJ8XuANhEIpWWzIp3sZh5bB1S+EhJGuXEKChv1I5gPs+wr+RuuNQpnb3IcdPQAjkcPOotlq3QxmmCF+IYYpnKjbyhOJGKAvDDO0TJnZtV0eM9NdZL3vMNZd9itatFbtCscQD/rJPG0+ngmidb0jGplBRuxxp93NysuAKSizgwC8DR7CL7jxH4ImaImw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGuHVMObywWnD7RsIBwxWcxeb8qFgPAQ+8LNgIQWBK8=;
 b=GAFMDD/yWTkMdieYkvvtdGV+dtlTsr23+j4EE1kC2BBsBYaUo39w0GK6iEZRtv1OIrBglPTSDr/DoE1vJSQo7DYeuE0KvD+tdydDEmJr0kP6F38IO7MJ28ZeSM08hdTvQUHnADCXPMpn72WQUx0y4/IKYC3QCsLJeNq2st8zTysqsxXIHggsy9ofs55TErDxK2fhjhRX0/uOY16QVjCGUHwEMIq/UCuL1p8u03y3ZChIhnyi6xDtGVup6AbZdyRSl5LRh6kmThuhnGv9H/6p8kN87kbaqqP60qgn8DUkdb041D7kEUTK0cgYJK93mK14t3DTJBLcrv7MBDSAiQA71Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by SN7PR11MB6970.namprd11.prod.outlook.com (2603:10b6:806:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 17:08:15 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab%6]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 17:08:15 +0000
Message-ID: <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
Date:   Wed, 15 Mar 2023 10:07:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Tvrtko Ursulin" <tvrtko.ursulin@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Jouni_H=c3=b6gander?= <jouni.hogander@intel.com>,
        "Daniele Ceraolo Spurio" <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com>
Content-Language: en-GB
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <ZBF48kVhFmXIsR+K@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0138.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::23) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_|SN7PR11MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b5762aa-d9d6-4a2c-a405-08db2577d23d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9pIwXnPmpxBgSUHSpGWg4OuRM6ToT54g1fUzHFa+FehZ90S71tox263pnf9P4R8edEOAFMWc5Zmbz58hn4GrckHeIM2YQ6vyA0hqBxMqo8bKnVaiiIOGJGYR+ADKEjwreHQubbofktpk5TlAyKFAU4yQ5Sth6BhERAjUx7TBo1OBjmsRTaS/FTd6lFMfjiM4/Mj6yuFq9t6mqy5CHhmbB5mQd8EDwceBk+f+VTUCIfcIOX6XkiFqPOLwajIUwu34x9RbmgB12JuJZSymVUlwMsayTqYsWiTmqrfU0MDppzwlndev/EYwbBmGr+IXzM/d1cdV5s8aUYRP2TEcY+BrmxxboS/ARLZh51L8GzEqjUmcQ0nA7kGn6Ml/Mx/aTMue2b7wbtEgKnUvQc6YekNaH0fvvs0vyt26a3Oxe0iW9D8moLwCOl05s7H+e1GqWVV2a5VUUfv4P8AJWhxEQdLFqbpXVvu5r9T+RE+Hrpai2blOvH0oAVBKB/eXWGUxZ5+HwHzgx11MzbvKzDOOieZX/ZZ88VlROzs+qIXt/9h1gyhn2zQNHceerMyr7uDzpjyRQB/Q8dYyxB+IxOk1VHK3TdgxblNkjSNrTr3d54H788lUY5r6Z+aQqDmCDWPvw7Okzn2juYqIo4vdmM85uQH5W2x/0moz865xCGj2aZN/skDiDZgkOcigb4bhQXbKtoV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199018)(31686004)(6486002)(66574015)(2616005)(83380400001)(478600001)(966005)(54906003)(26005)(6506007)(53546011)(186003)(6666004)(5660300002)(86362001)(8676002)(31696002)(38100700002)(2906002)(8936002)(66476007)(36756003)(6512007)(82960400001)(316002)(66556008)(41300700001)(6916009)(4326008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUlEQ25qUlRXU3lMMWZKSzRTRjdtWW9xTzRDODhPOVRMdEJrTDM5aXk5aG9z?=
 =?utf-8?B?dGwxclBhbE03YjU1Vk5uM2thckxHUjE3cFVRdmVPbFpRa0xReFFjZEtjRElR?=
 =?utf-8?B?aGtlY0s3M3d5TzJQd3lZNVBieFNDNngxQWtkWlg1bzdOemRoS1VrWHIxeGVh?=
 =?utf-8?B?Q0tBcmZraUpBRnArNU1KcDQ4YWV5S2RLN1FqWUJsZVE3WHdSeHowOVFKUkpH?=
 =?utf-8?B?NExaUFI1bm5aK0VDRStpNG1zRjVJckdmSmgxbE1rS2lZQmxZclhCOThYRjc4?=
 =?utf-8?B?aDR0RU0zVmdjMGVqRzJYY3FKNGQxK3VnN0RzSUNCUGtocktCR1grNzhYMDdC?=
 =?utf-8?B?YzRTN21YL1RtYW9hcjNOL1pqNy94WmdCSWNQZFNZUUNUWTQwNHlRWlRubFl1?=
 =?utf-8?B?eHVlMTZUYlJIQTg3SzF1T1ZnZ1BFcEFzZ0xHQTdrOEVxcFNIOUxMUTM5MmVn?=
 =?utf-8?B?ZjlKTlRTQm1LRUJIZ1FObWFWSEZiclBxeUdMRVo2Z09DMVQyU1JuUUtwRXA1?=
 =?utf-8?B?L200Q0JuS0dkM3dsZkVkdHBQSzlFS3Z2dXRSdDFIQytTU1JwY0FQZUowNW9x?=
 =?utf-8?B?a3ZNeGZlNEdjQ0xKYWE4ZlBDZXoyb0RpYTVSanNlOUVPVW9kNi9mRXFWTGhO?=
 =?utf-8?B?cXQ3bXc4aWVmYXFkQlFkMnZRU1VMMjI0dkhPTzcxVWx1by9PbEdxaWN4MUsz?=
 =?utf-8?B?U3lHQ2QzS3cwMkwrQ0pMeVJETzc1L1p2RysrYW1aaEFPMVJTc2tEck5rMGxk?=
 =?utf-8?B?dklqNjl2blVjNHZ0ek1DKzZkY2pONVF0SExJZ2xxRHVqZlRRdGJJNWpLNCtt?=
 =?utf-8?B?TFR5Rkk5eU9SeWhjWHJRS09uTDlsMmVjZ0hQTmd3ZWo0ajFSek1XNmN6cGFP?=
 =?utf-8?B?Q1FOT2JYcDVIOTZpM2R0ZEpQV254ZjJyUXlxNXlsSmxNbVVhZDRvK0FWYUZh?=
 =?utf-8?B?T0JIWWpwaDh3MVRLQWxOdFZhY1VwcXZjSWtZRHhtSWpwbzduL3RPR2p1Rnh0?=
 =?utf-8?B?cXExdHVUVnExMVBvOHpSc1laVW9oTUFDZDZUU0tJQ0dEdnZ1TzhWd3NYWDV6?=
 =?utf-8?B?N2x0cDd1c2xnUSt0RldUc0NhdVRUMFJ2b1dkeGNteWZkSlhMYStKNElSUkJW?=
 =?utf-8?B?QXVQWlNvZkVrQ2h3MEtoOXVWOVY5NTIzK3c0ai9qU0hGVUZ3NUhuT0hqcEE4?=
 =?utf-8?B?cHhVK0hMVTBlbzd2elNmUkhRSm5BWnRoUkN5R0hLRG5tZ3JtNkp2WDZYZStD?=
 =?utf-8?B?cmhJR0JkTUtPZGZmSVloSS84Mjh0OGRHVkQ2enpqbnp5RS9uSGZMUmtsOXpy?=
 =?utf-8?B?eDQxTE1mcEV3YXg0QjRQeExBQUwzaWt4RWVlaTJwMzhxZGZVT2IxcmpsTzUx?=
 =?utf-8?B?UkZ3Vm5UNXYyeS9tQVA4aE5ZQ1M1dTQ3MGJZcjgrR0k4UGlnb2RCS28vSXg5?=
 =?utf-8?B?SVpXYlorVDF1SmNXM20rSGhFcUNtUDd3U2paeEx5bjV5MkcvL1c4ZStKOXBE?=
 =?utf-8?B?MjdTOTN1WXA3SjV0UC9leEUxSjExKzZrQmRQKzZvRXhpTnQrRzhIdXUvWm9s?=
 =?utf-8?B?UTQ4b1FBZG9yY0diSmQzbTNmbmRzenpmd3c5MXpkUUQ1WUlEeG1FVmVnUS9W?=
 =?utf-8?B?S1dDVUVIKzkrK0FtUzlxdE1KWjdJWnBMczFCc0kxOWQ1Y1NCTm4vRklBZHVy?=
 =?utf-8?B?UW11U3RRRDR1M3FEVG1uOEVwT0lnOERiRWhRaFBmTW1nU081VWVDMFF4Y1Ex?=
 =?utf-8?B?UUYyZzlxUGVBVVRaeUVIcFlJQUo3MWYxRDR2b3NyRC9wcmxVbS81cUZmTmdX?=
 =?utf-8?B?VWhKcDdRTUp5ZHROSUlrQzc0ZFZwbmZubEtVYXhIL2pubm9jeTI2Wm0rK0FU?=
 =?utf-8?B?UUJyYW9yOUYrUGZPUnc2Q3BwUGNCSFBHZW9iSjVhNDhENUt5aCt1YWsybXAy?=
 =?utf-8?B?cVAwVVRnT0kzcDNkNzNFZEZpalJjWVM1WFVnZU81LzlWYzJ3Tlh0bXVNVm1w?=
 =?utf-8?B?cE5tQmFKMkFOUUsrcHp2ZnFvQXhaYit1RjRuQnF2cXlKK3p4aGJOMlhuMlJ4?=
 =?utf-8?B?N2V3SmM4bStFYlc5NWZCbUxpMGZEbTV4eG5tVGZDSWpHNFk1TUU4alZ1QUp5?=
 =?utf-8?B?alV1aUljeUFkTjJCc1lrWWUzQldkMDBLaEo5NW5pY2gzQ3RwbFRkeFJSNUtM?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5762aa-d9d6-4a2c-a405-08db2577d23d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:07:56.3523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgWDZ7rRWod6G23G1oyOsVS4MwkhoV1VP4bUG9mwvG1JvGwWdMFZeX7GM5ShFaSmbu59n1P59rkHJyg9k7cSgD5uWZ0af86uiPRKhyvpieU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6970
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/2023 00:51, Greg KH wrote:
> On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
>> From: John Harrison <John.C.Harrison@Intel.com>
>>
>> Direction from hardware is that ring buffers should never be mapped
>> via the BAR on systems with LLC. There are too many caching pitfalls
>> due to the way BAR accesses are routed. So it is safest to just not
>> use it.
>>
>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>> Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v4.9+
>> Tested-by: Jouni Högander <jouni.hogander@intel.com>
>> Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>> Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
>> (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>> ---
>>   drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> Also queued up for 5.10.y, you forgot that one :)
I'm still working through the backlog of them.

Note that these patches must all be applied as a pair. The 'don't use 
stolen' can be applied in isolation but won't totally fix the problem. 
However, applying 'don't use BAR mappings' without applying the stolen 
patch first will results in problems such as the failure to boot that 
was recently reported and resulted in a revert in one of the trees.

John.

>
> thanks,
>
> greg k-h

