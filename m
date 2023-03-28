Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826A56CCDAA
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjC1Wtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC1Wtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:49:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D2B139
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680043789; x=1711579789;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Cc8B7Do5RG5xbHXgUiT9rgj2ncaqZAuW6zYdnRiYTHc=;
  b=gVAHjU5HkMCailfhx1sNjQmNYkdbV8tUDnVM3/69Eke01CXDjMsLvX4z
   lLbMWcdKLMcOBOnii+jk6gkw2z5lyh0U3hGvtBUDFuzEHBbkBISU5mD4M
   rZUxHbeaJZJHmRuhQEQK+jezRBi0SZxGXpislRTI5qAkteQiiwfs224wb
   PGUzb/5Ig58Y/ts2wF6IcjGjVClPKcpf5QAJQvgpAiTf/xc00muUKOwxy
   69AS+JvfsBb66/QWM27eU7ALBxu3R/YNZfB2iQ96g5HQQsG/aemu5IvrQ
   TAHjX7SzCrpG2Pl8fe+u6YMSY+UbI6EYdodxNDN4XjU/4T9+XkA4nGr8G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="343128835"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="343128835"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 15:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="684055667"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="684055667"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 28 Mar 2023 15:49:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 15:49:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 15:49:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 15:49:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGUY88PYSys+MgzQSlxFHAJD/TkiAdk1l6qn5HW8axXTdyvKjlT9MZURhTxQqd1a/2bRWz5Mm2u796zNSz5g9Vi6w2duw3yV7qW06C9UB6Lbs0X/TLd8cDTrOhK7LSjXS+lvtemAHI3ym4I1J4MMMcsFPfsKy/75WiydzHuUx+hEIa8WZBVyFEthqE31oCBCFZUWB8Aw5G7LvrgxKGq+QDFZ/yCfGvOSDha28fefPgHu+E2yWjq23JY9/Br4boJUlbm4F5oVdJw+nwPtnXYXOIJX5tE0VOYPWV+kTocLayPa4XFIe7o4P+oVeORPd8KEsftj0K2Bimzvh63euuBZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVP521jwvY5PIQAX+Qru5mbbIr7n67kCUhXWiOPLbxY=;
 b=WpyMNvLxELNRv3WLNBRUBV4eNAvr1NnRmlh2hE+my0LVtRc3JXiKUle/yTg57tRjcQqGXfGs66YTXx3/Ao/Z3CgTyIPiXUvS+cLyph39tl9L1Et0lgbt2qF1vpNb+k6mlE7J7+1tQ+duPgIUnDxxXx1L58QPoz0Um345h0KWojkAgB14AzLh+6D5NsMS5I/tTEd0h0r6/wPzjNDy+Y4p1SJicFCVHVn+2e0JbNMrOvLwUOfu05CUAiMDvhGMbmmSMDl4ht1gK9LASANHeDCU7CyW0y4HieLm1OLbDi0S8iEk92Y8k5hHY+FawHKdx/Y4r9vD4Wh9xWwx+GEWhLi8gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB4239.namprd11.prod.outlook.com (2603:10b6:208:192::20)
 by DS0PR11MB7530.namprd11.prod.outlook.com (2603:10b6:8:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Tue, 28 Mar
 2023 22:49:46 +0000
Received: from MN2PR11MB4239.namprd11.prod.outlook.com
 ([fe80::4c7:f160:a73c:86d7]) by MN2PR11MB4239.namprd11.prod.outlook.com
 ([fe80::4c7:f160:a73c:86d7%6]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 22:49:46 +0000
Date:   Tue, 28 Mar 2023 15:49:36 -0700
From:   Matt Atwood <matthew.s.atwood@intel.com>
To:     "Kalvala, Haridhar" <haridhar.kalvala@intel.com>,
        <lionel.g.landwerlin@intel.com>, <intel-gfx@lists.freedesktop.org>
CC:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
Message-ID: <ZCNvAOM7AuvpsRsL@msatwood-mobl>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
X-ClientProxiedBy: SJ0PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::20) To MN2PR11MB4239.namprd11.prod.outlook.com
 (2603:10b6:208:192::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB4239:EE_|DS0PR11MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 890355ea-553d-4f96-26fc-08db2fdeb9fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBGrXyLJoFLtRcCZkkS+FH2nqzscmfpk8EVGxhR3HpQkJfycJPTKPgQKosLIoPBuL2vi29MMDmFC/kbo9RCTNs0eNG9k7LDtRfub4pDRwu2J6utht/7rWYs53/0eT0DFEoIkqatIEGJhk71hmB7YWNGs1zcX+BfiBraVEuWVM7EjOjtKTu7X3dAwLrMhUCZ/72ae9LYvZwGGDr21v3sIom2S1LNUweuYMmzGqq5SAv3cXB2S7YnHVCN4IUork/qGlRNoJ5clfRHzU/RzJDjdFJ0pf/A+KzPjXvIKMfb9Fje93zzMqFcaRtlNRsBXE4D3sl0HrySY5Td4RjFLxVA7IfkFd2zH6zU7rjFJjtHm3caC/4P0EgxOmqNggyCHz+SPTe5PqVUdaPg+cOa3HGMeNkPxUGzB8ZRzfarB6XL4cTYT6+M2fXO7XQ1NDkkpn2vAOuhlFmomRhKUU7PJbgkRqz+GhhV3TOMpxWl9uwGqgDmBQoPsItRRIadjF5lu2E05za9X204UCizFASlvwmSO3bzlk+FuAu1uuKloWxsFzLFrGEqnQb/DlSbP529Cutc2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4239.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199021)(2906002)(83380400001)(8676002)(66946007)(66556008)(6512007)(4326008)(66476007)(478600001)(316002)(9686003)(53546011)(6506007)(186003)(6666004)(33716001)(38100700002)(86362001)(41300700001)(82960400001)(6486002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEo0dmJ2clI5VnorcEJwUnZZSVhzV3N5QWtzWUFGWVhKZHZQOUJsUjdwVnpo?=
 =?utf-8?B?eGhZY2JtTGZBMjdkaTlCV25kek0rK1JJb3NETU9KQVZuMWY3WGxOeEpZcTM2?=
 =?utf-8?B?aUZPbzhJV3RndXdZMkRRRWVON0lOaWE5b2dyVTJ0TkpUMUFoNDc1YjhBUkxz?=
 =?utf-8?B?YUVaWCtOdHp1NzAyUktVdys4MVgvM09kUFhLU2hVc3VqdXU1a0MwaXJNZVVn?=
 =?utf-8?B?dlhtSUJUU2puN0NKZS9IWTVIbGgzNmpldGk1UEVyK3RvOWkzWW45VnJPNUpn?=
 =?utf-8?B?WEpsdnVneUY1VWdsYjQxZWRDY0dZc05JNU9YVzhxMHdXem9uVnJ3VUFUMTZZ?=
 =?utf-8?B?SGlaL2VIb1FpVm5BQ1dyWFQ3dXZ1c2hwMGdvekNjUFRGRzZPc2JkY3ppUU1J?=
 =?utf-8?B?VS9EY2c5T0swR1A2TkpQeDluakEzcUhNMVVWblU2R29NQUduOFVMRFdoUXMx?=
 =?utf-8?B?V3B4VVMzVWdTazgzaWhVa1dRUk5xd0N4d3A5dWwxTDdaKzV4bGVYTXlOK25y?=
 =?utf-8?B?ODlBM0xXc29wL3RyMkhCZ1k3ckV0U2ltNmR1aCt0UFNBVERiUVB0Z3NKb3Vz?=
 =?utf-8?B?Q1FqYUszUkZ1VC9UdTFtUzljQ1l5bllWcmxnenFEYjQwNExqZEN6VXYzOVho?=
 =?utf-8?B?eXYvRmVFWDFaK0dnMlFnN1p5eFo0RVp6MjBqZjNqOFJnajRmbEdPN1FnVzho?=
 =?utf-8?B?U1ZIZk4xQUh5dDZZRFlkei9GbVZlUFJiZzJEbHlXS1h2cEdGb05FZFpZVHA5?=
 =?utf-8?B?UGs2eTdIekRnUGxpRlVUL3c5RnlSbzNhZEhuTFRPVnkxMXM1VlZtWXJ4MEh5?=
 =?utf-8?B?WndzL2xsTEFMei8zSDNKOGFndTEwNTNDN2pVNDVLelIyTm52MXZ6RW03cHJa?=
 =?utf-8?B?Y05Ga3NyNUZoTUxXazdzWlFDWWVPKy9lWWkwV05LQWxhWmRnVXo5SFhsWXdK?=
 =?utf-8?B?Unl4UDNQVXlNajV3VHFYZzZpTXFaRkxicm8xM214MHBrV0JQTDJyWEFtVDEy?=
 =?utf-8?B?cS9jUGlBcnRpT0MzMWNxYU5RYmlZMDN3VG1TbURDMFRPelB4TVR6YmsxejB4?=
 =?utf-8?B?U1czYkNrbFRRZ01jS0N4dFFyRXVwS2lrRERKNmNhN3prbTFURG1FVmg4TmtI?=
 =?utf-8?B?OUhQRFVHUkFqaGw3Y2FweFdMajRicVNEelIxSE45Wkp6d01RM0hnZVMvKzkx?=
 =?utf-8?B?WG1qZlFNR2NJUHptemJpTUxXUzJvN0o4Tm0wcitva29tWDJ3UzhWUmRzNzFG?=
 =?utf-8?B?bHpyWW9aU25GN2REWlJESXJVQzFJMnVvOGJDWTdzb2ZZU21vLys3RTZhWWlu?=
 =?utf-8?B?RndrVTE2djQ0SHJTWitXUndOZXk5c2NjbUJrRS9aOVU2R0hWMHN2UUtpNFRV?=
 =?utf-8?B?NVNPaW5tWlBPOHkvNGd0M0h4L1ZNQnZzd2VBNEtVR3NGSkJXZlZ3bFQrdzBW?=
 =?utf-8?B?RlJScUNKOHFrWk9NZldFZzg4eCsyODRUSkthbGp3SUlqNlptNXUyRExJZmVF?=
 =?utf-8?B?d3FIeSs5bHV4OEtuR2N3cGtzV2oyRlJLZ3JXb2twcmRmMmFEaHJaMEFZVFJT?=
 =?utf-8?B?Sm9ZYlhGRVdyVWtrS3lPdFJONkRXV0pPYUJITkI3Y0RxTGlIVlZBWU51Rkta?=
 =?utf-8?B?eFdhRGlEZE1mcHVWbFVibHZHaXpRNnh1aVZWbjlSeUp1N2I0MjUrRmhpQnE2?=
 =?utf-8?B?SGtWcmRtZFg1Y2R0M0lWRUt4WVJEOVVYaHBxaG90YVQ4NDBab3VJN2s3MXBE?=
 =?utf-8?B?VFNLRUZhYVhrUFFmWS9rM1pGcmo4WnEwMEU3ZFFjV29pRjRyVngvWjBVV2cr?=
 =?utf-8?B?dEM1SXNKUVJVOG1sQ1VBRXpUVW9mdWtXSG1LVEdmZndwQUZqYndEWkJvSXhI?=
 =?utf-8?B?V0FZWk5hQm4ySFNUOEtxYlZXc0ZKR3p2bVIrclk4S0hGSmdpM2YyQnZKZStY?=
 =?utf-8?B?WWR5MWJIcW84N0xORisrYVVsUFJyUUFLa0hYNnZGRkdITUpZMjdjRTExTUEr?=
 =?utf-8?B?clpEMkNKdHlHUVVEYXg3SGtMeTRVcFRJaEVVWG5mM3lkdURobGJiUVJaVzlr?=
 =?utf-8?B?WHc1UnRHRk1JdWQvenNXZlpZcDhYMzF3WXpOSG90NGRHYzN6S0JKYnBISThS?=
 =?utf-8?B?T0Z1Sko1bkRBNDJhRUhoMVBYMFREU3pPTWtoM09SMUk0RUo0dHpJUTBSbGY1?=
 =?utf-8?Q?dMoszYqHivY/yzwI1Mtj0+s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 890355ea-553d-4f96-26fc-08db2fdeb9fb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4239.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 22:49:46.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJV21qLmGCkVxKrvoh7+xLfpY9ZXUhshIFJef+yiYHRevPUeglNKn0ENq28qECSvkYS6DsEPbOE1p9QyYftylwLk6fqq04PyA7XENZdheco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7530
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:14:33PM +0530, Kalvala, Haridhar wrote:
> 
> On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
> > By default the indirect state sampler data (border colors) are stored
> > in the same heap as the SAMPLER_STATE structure. For userspace drivers
> > that can be 2 different heaps (dynamic state heap & bindless sampler
> > state heap). This means that border colors have to copied in 2
> > different places so that the same SAMPLER_STATE structure find the
> > right data.
> > 
> > This change is forcing the indirect state sampler data to only be in
> > the dynamic state pool (more convinient for userspace drivers, they
> > only have to have one copy of the border colors). This is reproducing
> > the behavior of the Windows drivers.
> > 
Bspec:46052
> > Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
> >   drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
> >   2 files changed, 18 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > index 08d76aa06974c..1aaa471d08c56 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > @@ -1141,6 +1141,7 @@
> >   #define   ENABLE_SMALLPL			REG_BIT(15)
> >   #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
> >   #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
> > +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
> >   #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
> >   #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> > diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > index 32aa1647721ae..734b64e714647 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
> >   				 ENABLE_SMALLPL);
> >   	}
> > +	if (GRAPHICS_VER(i915) >= 11) {
> 
> Hi Lionel,
> 
> Not sure should this implementation be part of "rcs_engine_wa_init" or
> "general_render_compute_wa_init".
> 
> > +		/* This is not a Wa (although referred to as
> > +		 * WaSetInidrectStateOverride in places), this allows
> > +		 * applications that reference sampler states through
> > +		 * the BindlessSamplerStateBaseAddress to have their
> > +		 * border color relative to DynamicStateBaseAddress
> > +		 * rather than BindlessSamplerStateBaseAddress.
> > +		 *
> > +		 * Otherwise SAMPLER_STATE border colors have to be
> > +		 * copied in multiple heaps (DynamicStateBaseAddress &
> > +		 * BindlessSamplerStateBaseAddress)
> > +		 */
> > +		wa_mcr_masked_en(wal,
> > +				 GEN10_SAMPLER_MODE,
> 
>  since we checking the condition for GEN11 or above, can this register be
> defined as GEN11_SAMPLER_MODE
We use the name of the first time the register was introduced, gen 10 is
fine here.
> > +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> > +	}
> > +
> >   	if (GRAPHICS_VER(i915) == 11) {
> >   		/* This is not an Wa. Enable for better image quality */
> >   		wa_masked_en(wal,
> 
> -- 
> Regards,
> Haridhar Kalvala
>
Regards,
MattA
