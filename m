Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D053DF026
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhHCOVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:21:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:46842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236550AbhHCOVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:21:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="213735432"
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="213735432"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 07:21:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="511260496"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2021 07:21:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 07:21:06 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 07:21:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 3 Aug 2021 07:21:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 3 Aug 2021 07:21:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ4fl9x8uA6ffBXT8lTa/6DX87jpdtnZX9KzcoKxK31QjkyiM4otm9l0c4O9X0ewePmEYJjqhuGgw5x3yoR5ACuHiABto/CB429XiGMYe4FArsMY8YzpCR9RAuha30OcJhmtVnRGzOcaHVqbL45GEYCg6ZEYl+TcZa9jq5Tpjasup4OKZLVWxl/6vc7zStoCRlyFzhjs4Riqa4MWr94PMei0jzYr30/KbBWlurZkl9eOxsY5kEl6/0tO0xeYC0OrDYpOvLJFeoOoPPYgFNGdWLmOWexZ54rAesAMSCiRq1/ihPIb6i5J8TmjrZZI6IY35oiyMiJ2FvxeYb6kwRRtdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4SvTOpzscmtcEwiIF95CNFKzyto4llH+QjUz3Lsa4A=;
 b=R253qvcC6HCoe5MKJqqrx+URotz3sVMzp4Wa1kRviTYDpnJOs0oU3jA2jb8ci31Hkq4pu5J9pYMu73PkiaWMf6Ayg7irkeCquwdVmwnzTRG8wXT0v00slqCwDHqs0T95cMISmmoZOGA8IW6U/8dn9CxU9mu8YTpj4763hfUSM19Y7i+gN6+mC6K3ulv/I95HFAzcc/vbGh9CC/gPoWqv/23r8RHORLuf/cj71aPbf0uYQ9fZ8AX5GBbE6U+EMIQl85pJCQXn+QhCQMjRbRoVcw3nOd/DNi0h2yU1hQPWIrYOXuY14LTG4Ryiq4B+eKMa2tFwihPY9uuLKnUSV+v1Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4SvTOpzscmtcEwiIF95CNFKzyto4llH+QjUz3Lsa4A=;
 b=SJ8ajsKAyKDGUmsH93vZWm7HkR1AC59poegNkiSUNqmRuERaxPUftxcjo3wNAZygH5aohj9LxtLo43RyTReQrM7bHRku0Jp7zEVuNG0664/loB4F8T/3GdORSh8lDVdjXCH+MjxmW7H9jNJsUbGjP2+Jt/Nj0aumwhqtULvIz4E=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM5PR11MB1977.namprd11.prod.outlook.com (2603:10b6:3:108::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.25; Tue, 3 Aug 2021 14:21:04 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::405a:afd:fd5e:5430]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::405a:afd:fd5e:5430%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 14:21:04 +0000
Subject: Re: Tr: Unable to boot on multiple kernel with acpi
To:     Greg KH <gregkh@linuxfoundation.org>,
        Adrien Precigout <dev@asdrip.fr>,
        Shawn Guo <shawn.guo@linaro.org>,
        Bob Moore <robert.moore@intel.com>
CC:     <stable@vger.kernel.org>, <regressions@lists.linux.dev>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Erik Kaneda <erik.kaneda@gmail.com>
References: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr>
 <eb9250ed-2ae9-07d5-e966-9063fffa34f8@asdrip.fr> <YQY5rsWFhk5Okt0Y@kroah.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <2da0ad34-bd01-47b2-29fc-c2e8210e3697@intel.com>
Date:   Tue, 3 Aug 2021 16:20:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <YQY5rsWFhk5Okt0Y@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0154.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::21) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.217] (89.64.81.181) by AM0PR02CA0154.eurprd02.prod.outlook.com (2603:10a6:20b:28d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:21:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad2da176-7cc9-4c22-1a3b-08d95689ed4b
X-MS-TrafficTypeDiagnostic: DM5PR11MB1977:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR11MB19777089C7EE486CABD7C072CBF09@DM5PR11MB1977.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JzF/UBZl0iPyrwIY0pULsjCSbKSAsQ2mVepth691ND0oCCZw4yf12AdXt0zdz+aUKc/k1v4fzlSAtvdolTWUroEGOfmKPqFK55hvyt5LnvLHuMHfRvJ4hVOKVyAxapJeZ37t/Upm/IEku16aQUSUq/wWn0etEis1wfyMZz9io6eOF2RJhQUa9mdKTwBhKNhdI3Z9IisVBJJWcIMvw/ULDWgpwaQijgQCXCaV/FgOpsek4xUwnH2pwj+WN39hklN9I4TfNdLv3RKdjUPZvO/2F2h5A52xh9dCL7yuUxxAnj5Ua2kA/usywrr+nw8gcQ3M2yAMJThxsFpRX6nRl9Z1VMOk1S3ArfAiSN/g8KHDtIJzUkbTG3ACplOoUgPYX11s1HuolU1G3uz24gWQx8dqAjJMknjFNGgEZNiocJRaQGH7J37/GE/V8yZlKSSyLC5v+nV9U8q/7P1FSY80GH8DusJHGphYAYf5seoSIdvNHHOt6FSxmsfm1yGfndXl4dl8VgVYD6XJwbIxF1jJ95Um1TiHdyu0z6hjzlz24pOHiLaujTZFBbf3MX/IJmM7Pb+LDZJAJxKTxI9QhJmhq9uaNEn96E7jA3pCQ2ckga601o6vX8wWvD/fWLwO5iTRUtB5VGSyw0a4Qde4Dw3ObtQQqyMWHSSbNpm2aNbdZ9sceBsX13jnsco5TR1ksK5WDkRNS6+chCl9Qmij5vgvB7aeGRsdY+Tap5pDBvsB67fricjWlFUq/e96LKHoncqIzcSPoVDEWeNzCYsqZ0uP/AYRnyESCR7J8zKYNP/Ge1TmOPvUnyJPwJeIP0t+K92iq6Gn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(53546011)(5660300002)(66556008)(66476007)(186003)(6666004)(2906002)(31696002)(2616005)(86362001)(956004)(4326008)(8936002)(6486002)(36756003)(26005)(36916002)(8676002)(6636002)(478600001)(110136005)(38100700002)(83380400001)(66946007)(31686004)(316002)(54906003)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVRVSWJPWWFEdG0wbDl6VERHc01leVd5RVNXQmdkbjJhT0dDMi95OTlCa2Z4?=
 =?utf-8?B?TzVicmVnS0w0N3hKbElBQTM0Zkl2TXFCU3U4RFlTNGdEejB1VkNWU0V0VDFi?=
 =?utf-8?B?aGNVNEpDTlkwdzd4SDhhVTJxYnJiUmxTaEo1V1JCaGdoWE8yZnhvZExnT01J?=
 =?utf-8?B?bVpPYk8xZVhIa1lDSjNqN3lickc2NVNZU3BpQ3MzT1hWaVF5bmR2RTF0QW5B?=
 =?utf-8?B?c0tCRlYwRUFKaTk4VHJkVVFNckxjUGpNU1RpVzg5aFNJWkgxQm1BUEQ2UWxD?=
 =?utf-8?B?ZW0rYm1QWlhXeHJBUDZmWXAyMStCTUU2MlViUmFsT0RYVkRMR1p5NER3ODZR?=
 =?utf-8?B?WDdBVXBJaEFsVkVMLytpZGxaV2VUWFA0TFZmdUE4NTVJNWZHVm84VSs5NUZt?=
 =?utf-8?B?bmRvYzJOcVF1YWdPUHlYaVdSVDJad1FKTWtrZFkyYXRlQmN1dUdjV3V4OFVz?=
 =?utf-8?B?Rko2emxvanZjRDhoMTgrckxYendnKzFrYitiU25LeW54bzVOdngyYTgzZncv?=
 =?utf-8?B?UGM5M0JGWGZKaWZFZW1xRmJLWElaSkJuNEhKb0RTbE40OFRMc3FIMzBQZEFk?=
 =?utf-8?B?cHJ6NTVLOWMyU3MyQ2ttZm1PVGo5MUxIUW51ekpOcTRmREljb2FyYzN4c0Q0?=
 =?utf-8?B?TUV4TDV6RC9BWHREOXQ3V2prS0NkOTIvZGhVdzFTUWdmTzJuQWxWK3owbVVw?=
 =?utf-8?B?a3NGeUl1ajNyKzFZazgxZGJIcXFURk1EUkNDYmFLZGJISWduTzlmbk8xend5?=
 =?utf-8?B?Sm16OS90VmpoaytQS0U0Q2ZSZEo4N05RS2FnZmlZWVRPVjI1bDYxb3pLYlpL?=
 =?utf-8?B?WVZHMWdvYXh3NUMzRy9RSnpOTG1ubDV2QWN6c3dxYzJnSFNDb0M0RWZyc04r?=
 =?utf-8?B?N3cxOERNaTVvU25ibm5pVFl6d21tdzk2WEw4WnhkaWYySCsrNStQM0VKY1By?=
 =?utf-8?B?NWY0Y3RqdFgyUVVRTjRtTExLRjZCV3VEdFZtZEJyUGpkT01lSXJKUGNmTGlS?=
 =?utf-8?B?L0gvOXphaENhQ3hTOUNhNnFTekd5Uy9tMjJHQUcyeWgwWGNsTFA1Tjk1ei9y?=
 =?utf-8?B?V09wdlM0bDI5YTk3WVl6MVQycVhjdTE2aXhFaTUweTIxdW5ZMERZeDUrMGRL?=
 =?utf-8?B?K0Jhc2IzSVltUnZQTE1rTkpGSmFFTUFHdG9EbjR5eVhOOVdPZStJT2tKWjdu?=
 =?utf-8?B?STAvNGFHTGp3WFpxK1VobDdZVk5JR3RCVU8rb1loa3FnM3lybjJWTVdEeVQ4?=
 =?utf-8?B?b3ZYWVU4N3U2RS9tVGlFRFJQWlJveU9zM3JuN1NmQUNMeXJqa1FFUjZHU1My?=
 =?utf-8?B?TlJxTXU1eXFWcVlzWUNvYkd5QkxPOWpoY1kxNXR5bmZ5K3g1bkRFUXJwaUJJ?=
 =?utf-8?B?NGRGNlJLMW00eWgvN2dvcFFLcldFQXgweTZGdDdzcjA3SXlxb1B4R290bnVx?=
 =?utf-8?B?eGErdlM5cmRvRXVsa2VST2hiTU5mVFgwcUNEVzE2SGwzTmVtdERxRTI4cFJR?=
 =?utf-8?B?cE5pK2t1bmxhR0pZcU9wUERyMHU0N29tamkyb3lhdjBaVGJ0bHpaNjhIQWFN?=
 =?utf-8?B?TmE4VkdCY1FCTXhtOFpQRjMzaXErSW9yWDRaSlRTTldBdTlKUmkxSGhnVzlN?=
 =?utf-8?B?cjBJYi8vQU82R2tFUktJelEzWFcrMTRudlQwOHhVdXlPMjNIQjhFYUhwYTJa?=
 =?utf-8?B?YUhCV243TEk4WFZhaEZ4bk8rN0NSR3lDY2t3STMyMDdSRHpCTUZzWjhvajJv?=
 =?utf-8?Q?P698u1xx5TRUwgDXfVwXGiIUDanavKh/91pAl8S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2da176-7cc9-4c22-1a3b-08d95689ed4b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:21:04.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1REOPRGgZ9UNOovVfu4gtVX0icgTOxxtEcHxZTof1NLABB9lnQ4SeYqLfCmEtM0QwMX4kSBhnzqh5Jkk6WocKxKQ2qt3RlL7kLZ5RhTCwM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1977
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/2021 8:05 AM, Greg KH wrote:
> On Sat, Jul 31, 2021 at 05:27:39PM +0200, Adrien Precigout wrote:
>>> Hi,
>>>
>>> On my acer swift 3 (SF314-51), I can't boot on my device since 4.19.198
>>> (no issue with 4.19.197) without adding "acpi=off" in the parameters.
>>> Same thing happens on 5.12.19 (didn't happened in 5.12.16), 5.13.4 and
>>> .5 and 5.10.52.
>>>
>>> If acpi is not off issue is :
>>> -black screen after grub,
>>> -no errors, no activity (tested by leaving the pc 10 hours), no tty, no
>>> logs whatsoever in journalctl as if the kernel didn't start. Even adding
>>> 'debug' or 'initcall_debug' doesn't show anything.
>>>
>>> If I add acpi=off, the screen blinks one time and boots normally but
>>> after kernel 5.10 (5.12 and 5.13) I loose usage of keyboard and
>>> touchpad.
>>>
>>> Notes:
>>> - I'm using Manjaro KDE
>>> - I have tested with 4.19.198 Vanilla (config file attached) and same
>>> thing happened
>>> - setting nomodeset doesn't change anything
>>> - tried every acpi parameters, only =off worked
>>> - Bios was not updated, but the bug persisted after upgrading it
>>> - Acpi issue is recurrent with this pc it seems below 4.11
>>> (https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem
>>> <https://askubuntu.com/questions/929904/cant-pass-the-acpi-off-problem>)
>>>
>>> Thank you for your help,
>>> Adrien
>>>
>> Hi again,
>>
>> I've done a bisect on the 4.19.y branch and I've found that it is the commit
>> 2bf1f848ca0af4e3d49624df49cbbd5511ec49a3 [ACPICA: Fix memory leak caused by
>> _CID repair function] that introduced the bug. By doing a git revert and
>> building the kernel I can boot normally but as long as this commit exist I
>> just get a black screen as explained above.
> Thanks for helping to narrow this down.
>
> Rafael and EriK, this is commit c27bac031413 ("ACPICA: Fix memory leak
> caused by _CID repair function") in Linus's tree, that showed up in
> 5.14-rc1.  Any chance you all can revert this, or provide a fix?

I'm thinking let's revert and revisit in the next cycle.

I'll queue up a revert of this.

Cheers,

Rafael


