Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C262F6ED
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 15:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbiKROO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 09:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbiKROO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 09:14:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3800710C4
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 06:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780896; x=1700316896;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9APBTCchX2EH3QUzdax+v8htB/QeiFhkzAoW1Q0GBLI=;
  b=kFyklNPI7KZV1kXeY5NYDonASu2pzvvOSICaYjcipPDj4PaepEcXAnyC
   mExW6aBa5AMCMVz3zSPRXD/6Q4rGEb70qVjvPGFrSyGL+/nsCC4hRcsgn
   POCL7hQYKAof7I8h5ey++zAHlu6zvRBx847asfocP+vDBSQLDt5LxwMqy
   F0VrH6QRp7rDkvcKZarT4D5uuzH7RKUJVPd76ZUjNiRDpqSQaioYFsK1u
   x8zNwt9spR8h9TQbXzHedE9GKNFJWlwnA9GK1/Ti5LeBFXqAPl7H6WJ+z
   K7LJ5Crq/aklZdKPLUG0IvdriBX5IONF6haJVDvb7mPBnX7ztlJCKtQtA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="377409098"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="377409098"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:14:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="642523157"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="642523157"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2022 06:14:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:14:55 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 06:14:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 06:14:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IE5Ea6rmsr1wmfHDjZk4ot7Gy+w4Ku4M3RNLUWkW1JgvpQDwQKkzIRjH/y+Bd86MgZcrQ5jFgsc0WZIBvUumBEZlJFo2MDLotFzxN5jKBQU4CE2pUqQu4fY9xNSwTcG60qbfFmKD/G50hqyHfeuiZVVbvBcRT/5O2y9CuQ+adSGkd74ko02ssevocouGwHo8GeL1xs/vNdh4wdwFvsNIt92w/Bzj2FpUk2SrPNvF8Y/Q8h6CUyVLeuksAZbQM7NcAV+4uAatvAJTtayZ85Wey7m5K/3GnQ7CmIFwCw9RYucblL0yBBUpr5DEOP1XcEl/MtbIOS27C32DZZLF2Nk0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkRn+bZbSBuzyLURmAJuunRO7ULtz7vfj8S3KC9YlV8=;
 b=Muf5ZlmJFjd0Ngwf9jUZ+J9If7sv2aK7Jvfhon8JcIEYEhfRJt/P0+y4z03Eno46Pj0yOnHb/9xplxChS0T26kRDzsYlBu0b543raQsbVUOEq2FgYjEHtxa+8TEirUji0JOyY9BxudNYnsXNVPR9GdfG1KabD1gSQ6ILlN5GmmvNKaNYbPV2rJybZzRUKUWTpDY+qaNj1w93cJkCOGvb3Us3uErjlUlumZxcY4YAokGsUM+EpRR4U9QC2UBw7fSAIA0cT9kE5Jd6JcJ1b1anY4HdfRsbGQDu8aRAh1F/PACNzHG/nLN3FjNHIUJG+MHvvb0i/skc2Ilx5D+cc5Cmlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2961.namprd11.prod.outlook.com (2603:10b6:208:76::23)
 by CO6PR11MB5587.namprd11.prod.outlook.com (2603:10b6:303:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 14:14:53 +0000
Received: from BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::fe45:dd69:a763:6bec]) by BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::fe45:dd69:a763:6bec%6]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 14:14:52 +0000
Message-ID: <595e821b-258c-67fb-609b-9e618f1373ee@intel.com>
Date:   Fri, 18 Nov 2022 15:14:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] drm/i915/migrate: Account for the reserved_space
Content-Language: en-US
To:     Matthew Auld <matthew.auld@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     Chris Wilson <chris.p.wilson@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        <stable@vger.kernel.org>
References: <20221118124816.545034-1-matthew.auld@intel.com>
From:   "Das, Nirmoy" <nirmoy.das@intel.com>
In-Reply-To: <20221118124816.545034-1-matthew.auld@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To BL0PR11MB2961.namprd11.prod.outlook.com
 (2603:10b6:208:76::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2961:EE_|CO6PR11MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: ff489f85-a094-4082-70b0-08dac96f42c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Enff7Zl4oYiziiga3LZsb3tCLKLW2bLNoPuHFZXcLES9eiKhV/+PdDHXzIBFSm5YsIfFJQcsqREMUpWHxOwHyG7sa4i7Vg59YOPvoMa/WFWYMuLsPwH68YvxhkLmTRpHmX1EUeg2PSeqd92+ZLsziX73Lo5EXZR+Pq93Io/R6IdfPwuvOl9xoUpRK9TNqhZnEmWSIwx4zPVAICpBadMMOQxaqmcjLET5TpPppCP36pioXCT82YAlcraJqYn713Pu6y5ZG/xwTECBwJSUVFC9f/1zBowYj/RkcisuOTsFySPk+zpdp/gVh8Zw4qygv+vxn3p0jKtc3LPoVhTp2m04VLA/1CyaBx4mz9S7Xw44q1XKhzEfi0CmWvzl+EKiAPNdfKDFiITwUwWFWL/hufgQo0PwhjK0M50mSRCxzpEMWOphXCScS7P0ITEBFsPiDNHUwb9l+N2DVgsTNb4HrEs3pdzq9kh7n2MdpGHyT59Yi9LDFuSZOd3pOzTkksIB06kQK7pmCYyVVk/LMsS5/UbxG3b+Y8rhjomeIYqIsihl3wVRBmiMKrZbdt9WklHqXe6q6YkfzOxezfTBgATsmD4LuQ7GpssJf5hfz3bmCG+G4m+pXa1oF9BMc63dB3/EVPNuEo32EGvBIlzV2nOhybdrZPnJpVPskQB0OeJu9DGt7gYi4c4aVM2vO1n6Yicp9nwr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2961.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199015)(26005)(2906002)(53546011)(54906003)(316002)(8936002)(186003)(2616005)(36756003)(66946007)(6512007)(8676002)(4326008)(66556008)(66476007)(5660300002)(15650500001)(41300700001)(31696002)(82960400001)(31686004)(86362001)(6486002)(38100700002)(966005)(478600001)(6666004)(83380400001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjdrdGZ0QlVybGVpUkl5T1I4SjMzVXJ5UFlvWUhBTTZ2UTlkdHFyR2RSN0JF?=
 =?utf-8?B?MkFRdHN0Z3paYjlmRE1hNDdrVUZWYWFRMThDT1hyNE5ER2ZsWVVCTUdqR1F2?=
 =?utf-8?B?RmJsNFk5QXk4L2p3WHpDMmxRWW1MbGFLVzVwWnNQZTlBSGpuMXBqejIvdnRo?=
 =?utf-8?B?VHpDWHhldXdnMEhIM1JpVDRKOGNERmxEeXlPODN3V0ttdDlEQjVlQlZWdU84?=
 =?utf-8?B?SVc5MEMzKzdXQlRLUXlnVEFPaUdVOFVrWHJ4MHQvR3c0Ri9jS2tYZ0NzQ3dT?=
 =?utf-8?B?Zmp2Q3dZWG1sYmk1czRCS2U4YW1SalFYWVNvMFVpVnBSZ2tqZzI2YzE3MjBC?=
 =?utf-8?B?NXI5cnZDR0F4NFRwa1p6QmxZL0Fyc3lPQnJmNnhVNUtQLzlEME9HMXp0YkJW?=
 =?utf-8?B?OGIvczVSaFZ5WWJ3QnI3b0YwQkJ5SGtSYmQ3dnhCUjZmaEVBMkZLVWZmY2Nh?=
 =?utf-8?B?d2x1MURnN1gvVWtRUDBrNFhKdTJvVDRML2crVmQvMTNZcW5sWnMxNG9NRGx5?=
 =?utf-8?B?L21YdWRrOUhsck5keS9JVE1KanNGZTdHOGJzMFNScnI1QjBmSHk1Y1U2bUh2?=
 =?utf-8?B?RjRQSWgyU0pmSWowdGdiT2pDQmRWOWpGSEpCL1RYTXllUDZWZTN2MDVIVnQ2?=
 =?utf-8?B?L1hSUkxMUDMyQ0hEQStDOW5BaTYwVytLL1VDVkVRVjJIYXlncHd3T3BxN0tM?=
 =?utf-8?B?MzVva0FGdE13VmJWeHBWNGdjQU91NGdIMUtwNC9RQ3BKbzFXZFZzaWFTNFFT?=
 =?utf-8?B?VzJQaDA3RDcwbldVSnNLQUw3eG9hSEkvUFpwajJDelNYVUN3ekE2TktNYVkx?=
 =?utf-8?B?emNleXNDZzBYSzB1TnlzQmZpMUVocnpoWE9XaC85dUdxU2ZBdGZUVmhJRzlH?=
 =?utf-8?B?UktuMlVBU0lNYWtZQ0trZmgvenRtTlRJUUVXVXNGajU3WnlNdE5TNkRIb0wz?=
 =?utf-8?B?NmxNSVdjKzJteVNVYmNWT0lmK2ZhSyt3dEwxVUFqaWNieDlHWHFYSlVSRzlv?=
 =?utf-8?B?RnJDY2cxMTRmQlBwSlUwUjBYOWJ1T0V3RFowckxxM3hLUFhxWGV4dGNQWGR1?=
 =?utf-8?B?empHSkU2dHN4RXFlY0UyT2t1S09uRFJTSkR4djlTdHdqb1hobEs2K1MwUkxy?=
 =?utf-8?B?Z1AwZEJtZWdhYWJvL3o2ZExXS294NzloaUZyR1FNTXB2ZytXNitmTHlWdXJ6?=
 =?utf-8?B?bGFnMWpXQ0lpeXY4ZXhSU2lyOEJNa1U5eFMzWVdVVXVGNlNtVk55ajd5VkdH?=
 =?utf-8?B?MEV6MmNlTGdMY29WdElQMUlEc0phN3VMeDJYTUhxc3hXcHVmZzZGdXF4QTNt?=
 =?utf-8?B?bU95ZVYxL2ZrUVlRenlhN2VQb0xHM09IbnVrMWV1ZFcvVW41Uk5nODhDUmNG?=
 =?utf-8?B?MEJsQ3N6ZmJuYXVUMHhjSXMvSCtWZjZjOFA0U1RZRWgvcHEraHoxOEFGVkpa?=
 =?utf-8?B?cnJ1Q1MxeitudUVoVzd2Wk1VajlrVXhBUGszRE1IdFRLbmhJaEVFRE9HVVpC?=
 =?utf-8?B?RGd0eElKb3FHOWE2Q3FwV21LQldYUkY1QjBRYkhzTjZUSU1vU3RzVkcyZWM5?=
 =?utf-8?B?azhNVTNpUHdEenJLa21pNmt2ZEtLWVIwTEc2QXBMaG52Rk5VRGp2MUdDREMx?=
 =?utf-8?B?UUZ5MnAyLy9sb2xnVkgrRFdiR0s2R3lwbEFwcWNtaHBRZWdlNCtCV3hoZWJO?=
 =?utf-8?B?YVZoOFgxTDB1VEx3aXdMeVc3VFZxODR1OXdjSGxETVN5Sm1sTTQzcUVkRkZ3?=
 =?utf-8?B?dnVPaC9ZL0NHOUM0Q09PbUpybWtIa0JjSmpQYi8rU2tkME5SczJVU2FRK2tV?=
 =?utf-8?B?YzdkU2tIUVhTZW1jTXJ0M1F3ckNtS3pzYjl1UVN3U1BJdm9LK2JTRzlmM2ZC?=
 =?utf-8?B?SjR3UHE2ZUVHS3JFaGhpcHh0cGFhTTMzWEZRRktwTTR4YkpNenlrY2ZjYUZw?=
 =?utf-8?B?Y3hBdDl3TFNXRkFlRUhNelpYTXNyY3FValpqMk1LVVNiRXZkY0ZnM0M3Tmo1?=
 =?utf-8?B?ZzI4N29QUWluUnUyTG54SHg0MFVRbXBvMk45UVgrOXRtVnBYbU9qL1RWMXY1?=
 =?utf-8?B?emhqWXlMLzU5bWNJc04yYmREeWNNQWpqaC80Q0RkSFNuSXY2TnZRNU9mMlVE?=
 =?utf-8?Q?6oL3fltOxvi18P+U99+QloPrb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff489f85-a094-4082-70b0-08dac96f42c5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2961.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 14:14:52.7322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1ICrY7aV9BAQd8MkWLg41G0qa3/FuSDUTnCnGljUk0JyB8rY83/uBgQhfpTfGQIkGadHQ0OQx4ifaUd9StvuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5587
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


On 11/18/2022 1:48 PM, Matthew Auld wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
>
> If the ring is nearly full when calling into emit_pte(), we might
> incorrectly trample the reserved_space when constructing the packet to
> emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
> ring->space) when later submitting the request, since the request itself
> doesn't have enough space left in the ring to emit things like
> workarounds, breadcrumbs etc.
>
> Testcase: igt@i915_selftests@live_emit_pte_full_ring
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
> Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Nirmoy Das <nirmoy.das@intel.com>

Tested this on ATS-M.

Tested-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>

> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> index b405a04135ca..48c3b5168558 100644
> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> @@ -342,6 +342,16 @@ static int emit_no_arbitration(struct i915_request *rq)
>   	return 0;
>   }
>   
> +static int max_pte_pkt_size(struct i915_request *rq, int pkt)
> +{
> +       struct intel_ring *ring = rq->ring;
> +
> +       pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
> +       pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +
> +       return pkt;
> +}
> +
>   static int emit_pte(struct i915_request *rq,
>   		    struct sgt_dma *it,
>   		    enum i915_cache_level cache_level,
> @@ -388,8 +398,7 @@ static int emit_pte(struct i915_request *rq,
>   		return PTR_ERR(cs);
>   
>   	/* Pack as many PTE updates as possible into a single MI command */
> -	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
> -	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +	pkt = max_pte_pkt_size(rq, dword_length);
>   
>   	hdr = cs;
>   	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
> @@ -422,8 +431,7 @@ static int emit_pte(struct i915_request *rq,
>   				}
>   			}
>   
> -			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
> -			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +			pkt = max_pte_pkt_size(rq, dword_rem);
>   
>   			hdr = cs;
>   			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);
