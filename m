Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5FF654C72
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 07:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLWG0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 01:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiLWGZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 01:25:59 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100B75F98
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 22:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671776758; x=1703312758;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CEmMdLyU5f87WD80W/dkreHcZ9hU9TMClMkkD0q9h5Y=;
  b=i6AHH4zTQuuBWzGH8TE0kFmmWr1iiXc6/j3ElYVUE5jYLXGD9BUllfIG
   0SJtGV/8C0F/pU/qrNm7XkOXco2FCkbYLBMJTj/LgbRIemv0tMfPq4wjH
   Xp8oR4tNYwiY9JBrpGuyBqyXx6i/LHfwvIIEPWCs0rNJ3AHE3DYlmnM9k
   X9IjMmsLfj5eIRxqqWxjIpG8ag2tg1mgkVBKFGy3HAzGl80XOIEysLXvk
   AOJAVZc3U4di4HkQxake+lXqK/xKLux+G+5G15JgJ0WzUkSazs0ZG8UQ8
   n1xL2qPCRBq7i+ln2zgGKREuDfBlTIacJpX7mSNp8RqaSU+UlWwIfKZzM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="406521410"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="406521410"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 22:25:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="759260632"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="759260632"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 22 Dec 2022 22:25:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 22:25:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 22:25:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 22:25:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 22:25:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpb/uEcQsNS61EQamm0oF5We/LJEDy9M5jYhBI0oiYn+GmOi8k+dW/gYrmbRlmJQOFhHsGp463xD5VSEDDq9KMSjrTvvCFXKbGpPkEvvvoC3P104uJ0nRAPOA2lMmJqn/Qs+tgfzKPibAF9zCwd4iULHiSMdLOhppmw2/hdgMLSqOV35o5/Fq+DpRJTb2lc3hBwsxBOfqhTwXe70SpS9OkxJHsx2d375h++mkwVBuXveQb1TweOc4tg9chvFH0ZCABq1Jxc2P89HjoUwB5w1l+ydy3ylwC+JHwPZrVoVnNixHxO+zuC9HgzdScrGVU8HSiU0RURWONaXBKMAijYu6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVbjgzjS1asG7y3LLxRJ9h61+0uJl9/tphQ34SYvqfk=;
 b=Aen6BtbcvrtcZNAkud0aAF90gCVWfSP/RbSOQUXSoBhZsF4aG8zWWGTvDR2JO1T1N6eGfKrtWowwCkHvdVVsPy7z8bdmQnrw6wTV6N7PZp3lQgwrNLVq/EaK2n6qQRSvNWdwkJQnKMHpEr8ZQxA4Iwp6Bq+dUjwzRk9NDSIyS6HKUnCQXpPSTRaXUpg8WIBvAPD9y3WxAVnEG03gLpiglpFaqXTDL8Jm+S9kr8YEA22JORGzQ1PXy2V/VJkDg1IAM+j7YNuZU4BXtfABjAbVhg7YNYx6WuP5MagFU9q1+RrsVyUFz+du1dfGQYFJYEAhjnFfkgDvSJMm/UNmoU5CgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5424.namprd11.prod.outlook.com (2603:10b6:5:39c::8) by
 SA2PR11MB4906.namprd11.prod.outlook.com (2603:10b6:806:fa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Fri, 23 Dec 2022 06:25:54 +0000
Received: from DM4PR11MB5424.namprd11.prod.outlook.com
 ([fe80::bbf:3af3:42d8:49ce]) by DM4PR11MB5424.namprd11.prod.outlook.com
 ([fe80::bbf:3af3:42d8:49ce%9]) with mapi id 15.20.5944.012; Fri, 23 Dec 2022
 06:25:54 +0000
Message-ID: <a731f1af-1565-6fc3-41bc-3ded983e6127@intel.com>
Date:   Fri, 23 Dec 2022 08:24:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Reset twice
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>
CC:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
 <Y5dc7vhfh6yixFRo@intel.com> <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
 <51402d0d8cfdc319d0786ec03c5ada4d82757cf0.camel@intel.com>
 <Y5pQH+KGujkSJTvT@ashyti-mobl2.lan> <Y5t+gEMl/XFpAh4N@intel.com>
 <4a3f841d-e0ab-dfd9-a6c0-08e2e04c7b6f@intel.com>
 <Y6Rf4LvHlbeFy/iF@ashyti-mobl2.lan>
From:   Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
In-Reply-To: <Y6Rf4LvHlbeFy/iF@ashyti-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0119.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::6) To DM4PR11MB5424.namprd11.prod.outlook.com
 (2603:10b6:5:39c::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5424:EE_|SA2PR11MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: b1611b11-740e-4916-f1f8-08dae4ae8b2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeAx+6X/TOOMGNyDypnQ/ofiEGJw5PZ4HjtDHvCHcPebF3aEDqz97JbPJ0q6u1QDLMU+9gskjXT2Nbmki+y+tfxnFQcGZN4r+Tch1I8+0r5ynNZ9mJAv9Z4eN3mFa1GHjGJyHAmKkmVQPQdWfnDmREOWQ5eCNDDCR6mx7uV4XD2FBWuXTLezveSvASRhAmLmTqIUeYBW0j5thMPQuLVU1cGzJrin3hu6MZVTr6J4uvnrQKwmjrJO42QEVtzz8dldRj7kihVXNBYNIDGuimRR6hPr/gp/lXmkNkqHMx2uk0isL85GEsqxA7Rsaq6mZnYJcHHfYPvG1Pz3cWxe4VXO7jk2f3VWJ9aa0z/MMiM0LUTlfU0NGE2VJjfjPkbdCPoWEDBwKfjqHX5z1CvZX+zgTiawQGE6jMJ2NATtcLT8M7xKDBDHzcDPCEUP+7mAhKMT1egyZCV7QPoD2J54yxGhFM8AFKBS9o+0N8Mt1SSpnYy/laWFPLAU7TaaQMLkaSt8eYcMgzqUZCgDEuL6JC8L8+XVO8ouM1XvpHshNbqZw2n8xC7ig29LTKbdN3Y1OClfYdky2V9WZzz1Le0DfFCl8DEThnEjffKVNKHFPyENqUzLZ7QRQ+aVRirRNjYzlqIFM12iY+kP+N14BNcmzotu02/qCbg5CqnQfOLrNxXa5CI5/2a9TC5XJoTOIal3Xl0y93NFX5dXKV87uiVQ4xDZZcwZvPtPJh4HldfkZD0v45I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5424.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199015)(31686004)(82960400001)(2906002)(8936002)(2616005)(38100700002)(66556008)(8676002)(26005)(4326008)(5660300002)(6916009)(66946007)(186003)(66476007)(54906003)(316002)(83380400001)(6512007)(478600001)(31696002)(86362001)(36756003)(6486002)(53546011)(41300700001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE56ZUR0WGJLNHh6WGl6R0ZhRlZiTFNVZHlPc004S0N6QlBZZjUycWprNDRP?=
 =?utf-8?B?TjlCNlZXaFd1a1lBY0RNaGw0bHNxZ1l2ZlZ1cTZocERHNXBKQUx5bUVwaXR6?=
 =?utf-8?B?L2hWUkN0N081TXhPSjFOSmNvc3c1ZDNwcmk3NWJQOGZlR3AzMUJ2aVhvSWlE?=
 =?utf-8?B?N3Y3alVZSDl5ZUt3LzRMMEZuTnF3VnVZcm44clZGS3NUYldiOTV4Slh5RkNa?=
 =?utf-8?B?RGlGN2JxQklpS09oRzNtMnJLeFIwdFUrelhGQndJbFhveTQyUXZGZ0orZlZ6?=
 =?utf-8?B?UFBTOXl6VEhUcmdjNGtQRGxnZ2RkRXRZTkJmbDFPTzZnVUhPdjU3cE85OHhJ?=
 =?utf-8?B?ZEFhMTI3c0xrQW95a3cxRzFGeGFKUkc4N3hZaXllenVmZ29qVklvT2NlSW1w?=
 =?utf-8?B?NkhZSGJ5SXF4VnQwUDlnVDh5MHpyTmdwaXdPUTYxMW1WRElwTEEzWFJzTzZP?=
 =?utf-8?B?dU1kbnZ3TkxtbGZhNWxaKzY3YnVtRlBMcmJEVmR0SUd4ZjA5RU8zQTNjcng4?=
 =?utf-8?B?RWlHTUptQ3krdXpNWEVCNzFNTHU1aFBjcWhhSmFHT0x0dG9zSkJocys2MDV3?=
 =?utf-8?B?dU9SSnVWWXNCT3VsRFN1QzMxQTU4cFZDZkZlKys1dUwzZkpOOGFRYTZpTkRF?=
 =?utf-8?B?aGpzZjNGNzczajdDY0poVzJxTjFqUkY0ZG10cnlQemkrSkRveHNzL0ZHNmFN?=
 =?utf-8?B?bmNGZ2lKcEFtb3I3OGtVUzR2aGVWL0duaFo5N1dIQlFEUnk2b0s5bmJEdXpr?=
 =?utf-8?B?U3RSUlAwK0E4Z3diUXFYYmlqOWZWZ2l1bWY2bHZmUmM3S2ZRcGZ2NGdqRzF5?=
 =?utf-8?B?cGRnckpCMkt1dTNNajlKSk54ai9ValhxOHdScndIbjB5bk4xSEJYMmROeTRj?=
 =?utf-8?B?Q1lqUjNvcUEvcTRmdlo3Q1MzaFc2Q3pmNEN2OGZsdFZQTWRSUHZvbUpCak50?=
 =?utf-8?B?Y0ZMN2RMTUFQalBoWXRFQW9ic2dBSVo2cm9JUVR2djdXSUJjTE1ZQkk3QVZO?=
 =?utf-8?B?Q2VCdE5TeUxiU2JGMGY4VHdpNHdhUWtZZjFtRnJOU0FJejNjNFlJdXlEUGhv?=
 =?utf-8?B?dktFYlRhWXV2RE52SlIxazIwMkVnZU1FTkkvZEgwV1RpMjUwU05pUkJkRnZ1?=
 =?utf-8?B?bHkwTzl1TlMvRWZNOTM0dUpESlVMVG1BUTJFZm9IRlo1L0FmMC8vZ1l3YXU4?=
 =?utf-8?B?VjFMSjRURnhXbG9wTjZHV2RweUQ4MEFia1JzTWtSWVI0OGllZDJub3JpRFAx?=
 =?utf-8?B?VGY2aG9LMklXcnJDWjRvRWZoM0h0VWNYVGxKbWY2dG5yUDk2L0o1ZjlVdEhl?=
 =?utf-8?B?eWRyM0VIaVVScUlKOWQwZnpTNmZvbW9ndWhkd3RRMWFVL2VnQUhlSU1SZ3dv?=
 =?utf-8?B?cms4dlBINmt6WWVoVmZxR1FiekF0NzlsVEhHemFzcTkwOWU3cXVVVXh3Y1dE?=
 =?utf-8?B?UG1zRHovU3Y1SGZacmRURjhtbmMvM3ltd2YzRWFtb2grWStOR1k4Vi85R2FO?=
 =?utf-8?B?Z2RhRWN2S1FIa0hubFBwaFYxMmNmVXllc21SUkJmcVZFNUs4cEtpMEpkVk5v?=
 =?utf-8?B?TC9nakRyV2xITGhXUTRZcWtmS2NZTkQ1MkVUenYxNENBSzNaTnlzbk9WenFv?=
 =?utf-8?B?ckVZTXVtbWp0SUIxMUJoRDJjN1llR0x1MzhEaXJ4cmZLa1NZckNZMUxmSHVT?=
 =?utf-8?B?ZkNlNS9lOTdhNk9ZaVBKcTEwMXlndUZlY1dHbnNKQjY2VU1vZnhoVnNLbUFB?=
 =?utf-8?B?cEt6NlpudEdGNnh3YW93ai94Q3VoUDdTa0lhcVNiRlUzd3pGZWtrTm14K1d4?=
 =?utf-8?B?Q2pFTGVVcEhIK01aTmVXYzNnYXkyNzVoNFYxbkcxellxWDBmUThjYU4yYllE?=
 =?utf-8?B?bld0UGQyTjN5bGJYV2RjMnQ0aVllQUZpRW1sOFFsRmtUdFQ3YmJrMUdaRTFY?=
 =?utf-8?B?YlgvTTdCeWEybG9na2VYVXNRTlM1SWFHZnZ5ZHR3R0Rab2lpcFJuRTcxWWpI?=
 =?utf-8?B?ejZKOTVjK1BBTGVKc1p4MitVYUJQUUNvUGl2Rlg0QkhCbUNTSGxCZndZbnZ6?=
 =?utf-8?B?UFYyR0wySitvUUlFWHVSNzN6bnYvUDg1SWVyTkhKSXU3SEc3Y1ZLbHpzbEsr?=
 =?utf-8?B?andoWnc1OFRjM1hGSGozazZCcVRNMktUT3dJcnR4RHJtL1JsY0g2bjdBRGxY?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1611b11-740e-4916-f1f8-08dae4ae8b2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5424.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 06:25:54.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVkMa5x40R9tcKosERVlEw6YmxZJJ5frxbinNLGnlgT/wTPcKuR8YPGh3de0Fqt8dU0jloZv2bY1a1c6XBxSY+BpF5iDlX0RTMyG09j1LS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4906
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/22/22 3:47 PM, Andi Shyti wrote:
> Hi GG,
> 
>>>>>>>>    drivers/gpu/drm/i915/gt/intel_reset.c | 34
>>>>>>>> ++++++++++++++++++++++-----
>>>>>>>>    1 file changed, 28 insertions(+), 6 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>>>> b/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>>>> index ffde89c5835a4..88dfc0c5316ff 100644
>>>>>>>> --- a/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
>>>>>>>> @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt,
>>>>>>>> intel_engine_mask_t engine_mask,
>>>>>>>>    static int gen6_hw_domain_reset(struct intel_gt *gt, u32
>>>>>>>> hw_domain_mask)
>>>>>>>>    {
>>>>>>>>           struct intel_uncore *uncore = gt->uncore;
>>>>>>>> +       int loops = 2;
>>>>>>>>           int err;
>>>>>>>>           /*
>>>>>>>> @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct
>>>>>>>> intel_gt *gt, u32 hw_domain_mask)
>>>>>>>>            * for fifo space for the write or forcewake the chip for
>>>>>>>>            * the read
>>>>>>>>            */
>>>>>>>> -       intel_uncore_write_fw(uncore, GEN6_GDRST,
>>>>>>>> hw_domain_mask);
>>>>>>>> +       do {
>>>>>>>> +               intel_uncore_write_fw(uncore, GEN6_GDRST,
>>>>>>>> hw_domain_mask);
>>>>>>>> -       /* Wait for the device to ack the reset requests */
>>>>>>>> -       err = __intel_wait_for_register_fw(uncore,
>>>>>>>> -                                          GEN6_GDRST,
>>>>>>>> hw_domain_mask, 0,
>>>>>>>> -                                          500, 0,
>>>>>>>> -                                          NULL);
>>>>>>>> +               /*
>>>>>>>> +                * Wait for the device to ack the reset requests.
>>>>>>>> +                *
>>>>>>>> +                * On some platforms, e.g. Jasperlake, we see see
>>>>>>>> that the
>>>>>>>> +                * engine register state is not cleared until
>>>>>>>> shortly after
>>>>>>>> +                * GDRST reports completion, causing a failure as
>>>>>>>> we try
>>>>>>>> +                * to immediately resume while the internal state
>>>>>>>> is still
>>>>>>>> +                * in flux. If we immediately repeat the reset,
>>>>>>>> the second
>>>>>>>> +                * reset appears to serialise with the first, and
>>>>>>>> since
>>>>>>>> +                * it is a no-op, the registers should retain
>>>>>>>> their reset
>>>>>>>> +                * value. However, there is still a concern that
>>>>>>>> upon
>>>>>>>> +                * leaving the second reset, the internal engine
>>>>>>>> state
>>>>>>>> +                * is still in flux and not ready for resuming.
>>>>>>>> +                */
>>>>>>>> +               err = __intel_wait_for_register_fw(uncore,
>>>>>>>> GEN6_GDRST,
>>>>>>>> +
>>>>>>>> hw_domain_mask, 0,
>>>>>>>> +                                                  2000, 0,
>>>>>>>> +                                                  NULL);
> 
>> Andi, fast_timeout_us is increased from 500 to 2000, and if it fails, it
>> tries to reset it once more. How was this value of 2000 calculated?
> 
> No real reason, it's just an empiric choice to make the call a
> bit more robust and suffer less from delayed feedback.
> 
>>>>>>>> +       } while (err == 0 && --loops);
>>>>>>>>           if (err)
>>>>>>>>                   GT_TRACE(gt,
>>>>>>>>                            "Wait for 0x%08x engines reset
>>>>>>>> failed\n",
>>>>>>>>                            hw_domain_mask);
> 
>> Did GT_TRACE report an error in a situation where the problem was reported?
> 
> I guess so, in Jasperlake.
> 
>>>>>>>> +       /*
>>>>>>>> +        * As we have observed that the engine state is still
>>>>>>>> volatile
>>>>>>>> +        * after GDRST is acked, impose a small delay to let
>>>>>>>> everything settle.
>>>>>>>> +        */
>>>>>>>> +       udelay(50);
> 
>> udelay(50) affects all platforms that can call gen6_hw_domain_reset(), is
>> that intended?
> 
> Yes, that's intended as apparently we need to give it a bit more
> time for the engines to recover from the reset. We are here in
> atomic context and we need udelay to wait atomically, thus
> udelay().
> 
Hi Andi,

In scenarios/platforms where GSC Firmware is not used, reset through FLR 
is not possible and this reset function is used.
Therefore if this problem cannot be avoided by other WAs and this method 
is the only one, we might have to apply this patch as a temporal fix.
But we also ask the person who is in charge of this HW Platform 
(Jasperlake or all of GEN11?)to analyze the problem and you need to sure 
get proper WA guidance as a next step.

Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>

Br,
G.G.
> Thank you,
> Andi
