Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481B86D0EC9
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjC3T2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjC3T2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:28:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C90959EA
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680204476; x=1711740476;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ddXCE8LGKk0rdJVdFCqhg3CmhLCcJNYP1jqgLrI8tn4=;
  b=Uaq80DBEMYoKjRJHFE8+nt3OfnpuvexhZdu3DFriVnozCkz+799e8NOj
   gpewZYq9l3vlOI/Z1DQYVkKvEfHc75zund45Y7dxtlfPjvtKDyOi/S+Yl
   87Fg09akWY0GTnyNnwwxhXvKU5+ZkfjoOtNO4kVG2Z0W7KB4/JS+sqFut
   GD68UGezYFvmbeFU1ecw/z0xUAKt7smNqRwuUdGze7TcgXSFrESmhDcYU
   pGKkQ92wYp5/zakfjaW4uw+X76J3BtpKyx0lDSsLL0v4wzWxY45k6i4UM
   3qOFTlEPAXpqyNbbD8diq+dmxUpTCrTQ8eB8/wRpTecLCTuJ4Srj7RHu8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="339992595"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="339992595"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 12:27:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="678311603"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="678311603"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2023 12:27:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 12:27:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 12:27:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 12:27:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQT3WcMmQxbkYjolpHiCtUYhfXKXlOKXTp72j58lcwLEHex/CcMEsKHFP63g/jOvF1zDVzDrFlI3wSZS1mHE6xmcQYOK/Tnt/AzIQtr8CDMbw+69yfQfJPK+tZMRblEqWUMb/jUgTVZXOdotWBZm5eVhiFlG1DKQ1xHqfv4Ry/L3aHDWKOjEvzynV928vgz14UYTvFWnV7/heACvHEcvivjzelamcMUuT/jRmML36ItfFRCNksXRxKPWLEaZJFhs5RLetvzBvtk0BfQdzm6Gp5hxE6dNQpC9H4WcQiVm3aY8i7Q0mjqMbkudd5utP3sEu7gxdQOu/hXZ6517+Te01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPFKFUHbun0a4H801zPFg4A5SwrAClM4z4EzQIn8w84=;
 b=c9QyAV8GcRfoHIR0MOeLqOU+N96kDMRZ6SnrsM0fGFomoV1w6otgVcKl3OJeYJ5Ls7mPXbd3Op374JJnWPKVakhxIqd4yKKovxo5MbcciIcbPiqreBCab7CDkaIK4l7RTSx9oOSx3M0O7PVGfIgwJGGTVAAqxf4IZx8VvC2lglAI+DwbwyhD2oavbmxPY/nQVJ574w7pBaiQUnSGq3m9NVMa4Ah7IQVIxLJ2KVhDDB+9qBaLZFtzirHDHyGWoNz1EXOhXKW3eKAHasEeGgI/nxJpPDU8j930qJ64UsJqGJKLBbyvbOiBm+38VJXXFsiKqB6Mk8TX5e4R3HveGX5adA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4226.namprd11.prod.outlook.com (2603:10b6:a03:1bf::12)
 by PH8PR11MB7967.namprd11.prod.outlook.com (2603:10b6:510:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 19:27:37 +0000
Received: from BY5PR11MB4226.namprd11.prod.outlook.com
 ([fe80::6cce:2fa:c480:8bf0]) by BY5PR11MB4226.namprd11.prod.outlook.com
 ([fe80::6cce:2fa:c480:8bf0%6]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 19:27:37 +0000
Date:   Thu, 30 Mar 2023 12:27:33 -0700
From:   Matt Atwood <matthew.s.atwood@intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [v2] drm/i915: disable sampler indirect state in
 bindless heap
Message-ID: <ZCXipYU8ULR6eEPc@msatwood-mobl>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <20230330174740.2775776-1-lionel.g.landwerlin@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230330174740.2775776-1-lionel.g.landwerlin@intel.com>
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To BY5PR11MB4226.namprd11.prod.outlook.com
 (2603:10b6:a03:1bf::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4226:EE_|PH8PR11MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: e322c195-2977-460f-8890-08db3154d187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xxx5FHx1lV+FLWnyyADHXE4Qo6NYjymhXBdWbD97GfJDSK2FQg53tQ8h6qiQp6Szn2WbDxTHwAfiopon9k1YIZMIbtCNA7XixTE7EelXq4W6JY3RaxdY7hw/+MR1BneR55L9bl6rFwIZCCgVjxsuB/3mp+wkNdDrTLOCJdL0Ha3kiSh06TzNKqR6jzcHOl7vGYWjspn8Sv0VvqbZO2FZZnCHoSdqPJdA/xUy4RXLFDVDKCfpHM3laX79KVJj5Hi1YM/WpJDvRG5l+5SEYOwto4utt2VPLlkdLlIMD4ZV6vVnpIWqR1uwsalrLmj3zHfYBntMNNip7/TKfJtmgGfS35CO9UR0Sg0F7+weZvx6Y9cUyS5EqfSewfnKJaCulr2G4I4iTnn+nIgLTLT+ldBuPvGHaQpYMVo1VAtVZ4mkaDz0tgyW/pmiBgeU/edyHv1eZF6ZptRZ5BHgw+zOqUVU+xlFaF9OyGmYTEetALnIaFiJF7BkkwwGDnvycWo9WJTZYZ0/mpxIUW3Fp24MUs6OKgawC8XDVw7QgbOuok0PYIKLxdJzQVKJcqtdZJArjejR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4226.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(6666004)(66476007)(6512007)(26005)(6506007)(6486002)(9686003)(478600001)(316002)(186003)(66556008)(83380400001)(8676002)(66946007)(41300700001)(2906002)(8936002)(4326008)(5660300002)(38100700002)(82960400001)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjRzUU9NTFdOSXhIdEhIai81ZDAyVG1ySDJPZDEzS2p6VktFMkJHUUJMdFRz?=
 =?utf-8?B?a014aXZDdmh1KzJKMFMvbmlEWDl1eVJ0VjcwZGZUamhPSEJnODBBdjZPcHVj?=
 =?utf-8?B?cUVKUUFhVkhLS1FXZ0xTRWg1QmViYnJjcGQ5RE42S1E1ck01dzgxTW0xYVla?=
 =?utf-8?B?bjlsY01lU0x2ZFUybG5vaXNPOHVhM055ZU9RRktEVWZoaDd6SXM4Zmt2c3A5?=
 =?utf-8?B?V0hQSzRaeTVRdEg0ZUNka3lleVRBRDFlV0JQL1J5OFc4ZzUxQ1B0VCtwM2lC?=
 =?utf-8?B?ZWdBUmx5eUtmeExrbk5rUUQvNXZjWUZ1TG9EODRrQmpWQ01mS3p0NmVmVEdh?=
 =?utf-8?B?TzR3cnEzeFhySU1vVkJYd290VkN5ays1VEJxdStiQXpuajVFVEFVcjZIN1Ba?=
 =?utf-8?B?OThqRUxKQ0xwWWJjdGp3QThZVmc3emk0RjhtdFljdytjMktrRXhaQWRCNzBx?=
 =?utf-8?B?RFl2aXB2Q1hYMUJOb1pzd0lKNGhxZjY5S2ZmWGpKWkdoSy96RGh4eUFNWWQz?=
 =?utf-8?B?YmNteTVpcExEUnJnYnV4U0kvVElySUxTQzZaa2RzaGkrNlB4TmRBNzFnYk5X?=
 =?utf-8?B?ZTBBQzluYXMzTElHc1J6WjVpdzVnRHJkbys5cGpxUmI3KzNBTVZMV0RrSEln?=
 =?utf-8?B?bytwZGh1cVZnZ3BPdWwvTE1BVVBwZzd0VEFULytDdnNnV1VwRW4xb2RGR0dS?=
 =?utf-8?B?cWFJZ0RVR3R1KzBUSmtZamZyeGNDZUN4QWN5QmduekdpYjcrK0dadVp5dUov?=
 =?utf-8?B?NXJZTWFPcHkwZTJlbW5hd2JYSUtRbTIvUGoxRFh0ZjBvaXlCdDJ1UHZheXJt?=
 =?utf-8?B?NGhuSlBBa3hMWXBXNllWbGZnYldLZ21jS2cyUnZoRkFOZ1k3UFd6Vk1hUFJM?=
 =?utf-8?B?VmlXRGp6K0ZGR0VKSzdjZVRtTUxxc3MyS1VlS2xtMnh4RDBhR2JLbWZHVFVT?=
 =?utf-8?B?WDZHUXBicUtsVzdXSkdkc3Znd29tbkttZ3pPWWMvTUhnTkNmY3dTQTR2cmtk?=
 =?utf-8?B?c1BoaWlUeHVUVGhDdGV3djA2a1d3N05TSmFhMUZGY2p4VFdSdXg2OEJvRis0?=
 =?utf-8?B?dHJlUmlmU05seTB5cWJkVjZyYUZMV0JySmlPZVhPekxWcE43Tk9MREFSMDgy?=
 =?utf-8?B?NktQbndScVBjcGlVNTdiNnZtc1kzbk5IUEs0SjZKYUJlbDVKcWl4YjZPaVYy?=
 =?utf-8?B?elhzUVNQajlUUk5nSVBEN0gwS2hObDlMWitBSWZjRWwrTTIxd2FNc1VqK0hE?=
 =?utf-8?B?d3ZjaXMwdSt6S3hTNENCRXcvYWlKMVM1d05PWjFPcDF6WEhORjhhMGFUMS9N?=
 =?utf-8?B?ZHNFTGtIZW4vV3ZwVU80c1AxQmFXSk5OZGJYUG9rTlRIT1c3ZStPNmgxaVFN?=
 =?utf-8?B?VENmSHRmcTNFb3BSa3hDZWNTNG9ZSUxYeDdRTndKbVpxdjI3NmZ4ZTBSa1B5?=
 =?utf-8?B?cm85djhxVERYbko5eG8vNE8vc2xUN2dpamdscE9XeHBNaW5zWk5jY0FXbFdY?=
 =?utf-8?B?RUx2SEZ1RW9sd3ZBaVVsMGtqMHNzTnJSQXM3SllWRFY0cXV1OFBhR1JZWkZW?=
 =?utf-8?B?TmxZTHZZV3ZXNW1iRkkwd0pDejVUZUZzTXNvV1BaU0ZXV2krWWk0cTRlaTZX?=
 =?utf-8?B?YzVVVDMzMDhKYjljTzFTWWF6Zzh4eS9LOWtHSDk1dWpCb0RJWks2a0xQVDhP?=
 =?utf-8?B?WWgyZ1M0bWZibUN3UUZTUTJDeUR1V3RvRjJTMlIzRHdzbVJPQXpVRGVYTWgz?=
 =?utf-8?B?eUZlTnlCTktwWnNib25TTWN2aDdvS05VYlc5cWVlcnU0bXpGbXZGMW9GTVla?=
 =?utf-8?B?eFQyZStXaXZxaUZPYzJYaEdXM1B1bTZkYkhqazRna3NOd2RWLzQzVGxxRDl3?=
 =?utf-8?B?NExHeklRS0p1TDAxeTRPRUpXQXo5OHJ4ZWxTVUk5cEJzeXdTc2FSM3ExY29t?=
 =?utf-8?B?eU1GclRVNU80ckplb0lLQWpVeVZHYjZFU3NQZ3UzUkgxWTFmZnhFYnJQK2NH?=
 =?utf-8?B?TFk1Z0RDdmhIMklsdS92WkxVZUthWlk5aUppbzhMSFhwQlhOUEt3NkNTU0dU?=
 =?utf-8?B?SXBRaDFmZ0l4Ly8xYm4yckVZb2ZING1nMmZxaFdPOXRSZkZHc05GN3F4aHYy?=
 =?utf-8?B?RmN5YkFMTitXbVBGMXJrWUVJbHVUM1pzeUVJL0FVcjNxRzRYSnkrYXJBUzlT?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e322c195-2977-460f-8890-08db3154d187
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4226.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:27:36.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fcr/iEvn6CgO7GPGc2r2VT4p+OdKqht9NQrkMBHabewb2KAScNJ6q0Z9KsZaQz54s/Mza+aHxKrP+2h+EKW+fLk3J2RwOS+COtnlDcQzUbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7967
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 08:47:40PM +0300, Lionel Landwerlin wrote:
> By default the indirect state sampler data (border colors) are stored
> in the same heap as the SAMPLER_STATE structure. For userspace drivers
> that can be 2 different heaps (dynamic state heap & bindless sampler
> state heap). This means that border colors have to copied in 2
> different places so that the same SAMPLER_STATE structure find the
> right data.
> 
> This change is forcing the indirect state sampler data to only be in
> the dynamic state pool (more convinient for userspace drivers, they
			       convenient 
> only have to have one copy of the border colors). This is reproducing
> the behavior of the Windows drivers.
> 
> BSpec: 46052
> 
Assuming still good CI results..
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> index 4aecb5a7b6318..f298dc461a72f 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> @@ -1144,6 +1144,7 @@
>  #define   ENABLE_SMALLPL			REG_BIT(15)
>  #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>  #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>  
>  #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>  #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index e7ee24bcad893..0ce1c8c23c631 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -2535,6 +2535,25 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>  				 ENABLE_SMALLPL);
>  	}
>  
> +	if (GRAPHICS_VER(i915) >= 11) {
> +		/* This is not a Wa (although referred to as
> +		 * WaSetInidrectStateOverride in places), this allows
> +		 * applications that reference sampler states through
> +		 * the BindlessSamplerStateBaseAddress to have their
> +		 * border color relative to DynamicStateBaseAddress
> +		 * rather than BindlessSamplerStateBaseAddress.
> +		 *
> +		 * Otherwise SAMPLER_STATE border colors have to be
> +		 * copied in multiple heaps (DynamicStateBaseAddress &
> +		 * BindlessSamplerStateBaseAddress)
> +		 *
> +		 * BSpec: 46052
> +		 */
> +		wa_mcr_masked_en(wal,
> +				 GEN10_SAMPLER_MODE,
> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> +	}
> +
>  	if (GRAPHICS_VER(i915) == 11) {
>  		/* This is not an Wa. Enable for better image quality */
>  		wa_masked_en(wal,
> -- 
> 2.34.1
> 
