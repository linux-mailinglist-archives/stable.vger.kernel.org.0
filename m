Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE548AE69
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 14:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbiAKN0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 08:26:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:63869 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbiAKN0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jan 2022 08:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641907610; x=1673443610;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dmBh2yMz2fFAC4D6xHFNXJQYSGftFfZqfMtxIRzcoyk=;
  b=mxkxcntg+wy3flufjMX/E36b9KCd2borp1vTmB/W7eTE/Dp/xeMa+UNN
   JPQV6hkPDw7hprMZYt1B9uMQYSZ+k8ynbK5aaOEnfZSaBaCfDk8mNXMDN
   UN320jaRqFilA2Vj92x3ZVNM0T+kMcECgAmqUyoNfITABAYkl/9TycjXQ
   sDS0zpABCE2X8LNc8aZ+aQiXpC3xYfHTgCeJALHLbMXdEHgGfWMQTup2g
   lQq9wlyzpFPm9GLOtJlvEgL2GvUKzKdSK2b5WEAeUyazWTkGgenbkm77+
   +4VUGHzzKcLe3Y5GABkfq58O1NhXM68l3IVZOshPECJc/JPYPjcBsosfG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="223465209"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="223465209"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 05:26:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="613216048"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jan 2022 05:26:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 05:26:47 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 05:26:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 11 Jan 2022 05:26:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 11 Jan 2022 05:26:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQAalR1icQMcH8WRloWa2lza6xw8q+8mR1wf/wiBW5jiOOhskO7s9lzZIRLpstD/s1btbZgXooncu7J01oLMdOiAnfRezJLGHFTEsvyE52CwT3YCLpkQPo6+uq1T+beUUcUeinILBtKCKaUIdaKn80QbNhzj01/CFYt/iCx7Xjabt1DoQc1yGNZGPvJVNR4WPWlpHTsskVLhVd4uowmbLxFDweAzBvrdgmbSNn35ofpHwGHlZ4ne91XCfkJpHACu8b/6ZKlOnCAgFhHuOyauVdPuuTNbS9WO0ipPTzrf4DnqY3PQ3+syD+wX01LcBgn467bgjHOrSKko1PwsTgGP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+3iBNT+fpdWzBMDqKhNxtBRTlR7A/ucmaN/tYvMUOs=;
 b=B+evTb3Wg5qzteqgQrPeGN9dHObc5zukPp/WUykiyiJ4Z3OeCVtf+oGKziFTEB1U26IRlV8yv5gg21S3hhT14Nyt7AC81BEN1ZNMisa38bK6nGndTn8fE3W8i2XbMF3wVfBI8Ks/9QynOjSQEH4oDgAsUVzBNYFqRIbimdLJjsdwnjj+deZC+Q2B53asqiEHipjueOgPXnB/QX1malSf81vUaweAn8bH73B1KJwA0/HXXZwhU6OMOHm0hhlFWdzIFPgDAP3kW+69kmBhbEgj4QxygYWua/KTy2Z2BYz1SBIRyyCsh+o/KJWypUcEX7sJ12DmTiWRXJWtaxR9k/igUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM5PR11MB1946.namprd11.prod.outlook.com (2603:10b6:3:10c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Tue, 11 Jan 2022 13:26:45 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::b47a:6157:f9b5:b01d]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::b47a:6157:f9b5:b01d%3]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 13:26:45 +0000
Message-ID: <cd453cd2-e23f-84b9-e7d3-667df2397c45@intel.com>
Date:   Tue, 11 Jan 2022 14:26:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for
 DP-AUX
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>
CC:     Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        <dri-devel@lists.freedesktop.org>,
        <linux-rockchip@lists.infradead.org>, <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Lyude Paul" <lyude@redhat.com>, Dave Airlie <airlied@redhat.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::18) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb0aa11a-58f2-4a22-43bd-08d9d5060385
X-MS-TrafficTypeDiagnostic: DM5PR11MB1946:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB1946AD7F682F037413AF8B52EB519@DM5PR11MB1946.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPTI+9eAiJeqc4HdFAeU1e14Kjsx7maHbryh2HwN0hqHh3j5xryROB3V0zCL12Ad6wB945jtBNzKEu7hI0bQlG+XjIXErXRktZJZ7Qny8EUf9IjQ0BAyWjrMq6d6XgygZpISx/Go5kpz7sQOFWt/tccNl9Ki8oIEXDLdQ9PiZZ5L83d9YLTdZp36LJQaDzE9KfZwuFzymdQmfrL1cSAkkKYFNEK95tPc7X256dLKwV42jVORqvmV9sDBgoNHLoqijrEesbif9mqlR76eyO224xvJQWc/h2DEM6csZTPLN+ejE5/+AFouqQFLhaEr94fqq1S2bTxz4gPjGLclj4fj+tDTc0YZXh37f/JfEuUBLKCK5Lh7Bq8PVqrq08YgRsuMozAGMD6zYQZNnoXcbRJd1Ps+2aaggsDKs5BROnGqVvA/w7OqLd6XtJZdWw7WMQXyBwdWe/EwZkwfMDAS1VQQdLXJGibpCFyOdM3LbTBjfGEga9/Y7J9YE5+muW3p3Xg4Z2JBnxxLkvlN+zbTCfmzOTZx6740AAEKrK0DsfWYDciLXb0Q6auJZrDkG9YV3uu4qe8jQNdkV3cXm1X0+KngOsPObvwufqFpMU6h2Zf5RjgTPomUFxS4/TwHnXmTlTxPXpYuPs/qcZBU1E+h6NcDP72lGlTSO6fPvRHm67XvxWpZXUfyYZTmdAlKxHjx7h+4cs3Op9w1Z7+ieWauoVjHbs78YaQI8pcS+FZ6EzWY2vY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(2906002)(66476007)(54906003)(110136005)(66946007)(66556008)(2616005)(5660300002)(44832011)(4326008)(83380400001)(6506007)(31696002)(36916002)(53546011)(8936002)(26005)(316002)(8676002)(38100700002)(6666004)(508600001)(31686004)(186003)(7416002)(6512007)(6486002)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHJWKzJ4Tk5WSWc2ZU1MQmZFVlBrZm5hK0VDRVA4QjhWMXprSzVBaFdGOWZK?=
 =?utf-8?B?Yld6VlUwQ2txY1c0WmQvdi94WEt1ZVRqMlhNaExCQlBicnV6ZmxaY1N1M0gx?=
 =?utf-8?B?WkJZN1ZkWnBlM2Zva1B0anZZVTZrdXNKN3NSTStRTDMzcmdjRWVJU1hVcXBT?=
 =?utf-8?B?RlNOMGNhTXVEdmIzaXRBTThyMkNzQmFHc3FLby9MWXJRR3pkS2I3SWU4VkQ0?=
 =?utf-8?B?UjVndEpNU2lKY2ZxemFnSFFtRTQvbHJyeGYxSUhsZ0hyVUMzSGplZmNWamxL?=
 =?utf-8?B?akw2WDM0eEJ4anl3UE8vVlNzME1Ta1dBYVpXUlU0Qnp3Z05WTDMzc1lkcENJ?=
 =?utf-8?B?TE56amNWZ0xYdC9iK3BYeGtQVVUzZDdoZ2RyNU4wSVNwcXZpQXNrQVhHZHlB?=
 =?utf-8?B?aTlTSW1icjU1Y3EvL3RBQklSL3V4SU5SUFMrQzdYQ25MUVA2V1JjMzZnMlJI?=
 =?utf-8?B?Q2lJTFJMSHNCTm1mYW50UTJWWWJ0Ti9sbTVnR1lHd2tEMTA4SjlUNjlWUXhZ?=
 =?utf-8?B?RThwdmJaYmlUZllJT3AwdlZEYTlrMm1OaS9RTitqVThBRlBzeGxhR1I2cHlk?=
 =?utf-8?B?Tnh5QUlCMGVtR0pJN3F1WjE0clhIbmJob0VjSk1iUzcyYndaemxkbUdIWE5I?=
 =?utf-8?B?OU9tSjJlU3dpc2tzeXFncExtL1dQWjhOS01MRXRCdzVPQ0lJYVRnQ2Jnemtu?=
 =?utf-8?B?dHRUM2JPOGpLTE9mZkJSWi9BRFk0QWZSYXczSlMxbmhRbkkxa0IyRHRLNWds?=
 =?utf-8?B?bG9XVFJKSGNqRFhhNVVKd0FWTllqWEJoNS9xdThQOWFnZ0I4dG9iQzhFNWI2?=
 =?utf-8?B?T1hZWG10M1BPb0VMRlpQVFdRU216WlB4ZDRCMVg4aFlNcjlIR3lrcUM2OWQ4?=
 =?utf-8?B?S2xleHVaS2s5dUFEMEs1d1JpbE01TWpnWHRFQmJUZ2M3TVZvL1VWTlQ4a09p?=
 =?utf-8?B?aFJmWTdhUXlraVNSa0pPZzlhQnNDbHNkVkFTVXl4NVN0OHljc1dSTCt1UnVD?=
 =?utf-8?B?WS9sM2lDZTFPU0xFT0RRQ3hZbjduYjBkNXBQblh1VmdSMnVwM3dtSTVVODE5?=
 =?utf-8?B?aWRUMis4M2pXNzFWSndjd3dJUVJsTWtSc3RZbVE5Z1pTTHd5THZRQzJkcW5V?=
 =?utf-8?B?Um9IRWNKQ05UZWlKMFJIQllHL3VHQkdCdnIvTmN4ZXhVR3RwMmxMRGEwcmdL?=
 =?utf-8?B?S0xjRVdnMmlXWEJJbFJEeTVKN0lnUGlKNVRtaUNjSjFidzZZVjlEVXp5bURB?=
 =?utf-8?B?U1hsaGwrV2N5R2pXK3dvOUVrUmRaODdSWWRuZE9LbkFHdE93aHc5K3B5RHd3?=
 =?utf-8?B?bUdDYnMvV0F4ZTc5bDRlS2NtaXZmYmszYmg4cHBVazZSQ0gxRW9nbStyVlow?=
 =?utf-8?B?WlFLTDVBYnVhZUlIWmV1dnplS3E1REw2TTcxcFpsU0U5TDl2R094Y0Q5c3Uw?=
 =?utf-8?B?MDVtOHpjdW1ZVC83dDRjMmpuWk54cnQ2SHRaTkg4ZW05ZjY1NzgzUll1d05T?=
 =?utf-8?B?bHpucUJ3d3hqeVIxL0dJcCtvSmt4SzN1Zzg4V1o3U0ovZndaMzZLZzdMejk5?=
 =?utf-8?B?aUgyZVlGWHBJVmNiNlJoVXkrbldRNEtKY05ScEJqNy9YY2w5TkFrbGQ2S3B1?=
 =?utf-8?B?Z1FodElUMnY5L1crSXN1SkVlU2w0dUtYNFFSSkxEK2d4WndGM1Vnd25jazN2?=
 =?utf-8?B?cCtITE5vSTJld21Ibjg2Znc5cTF6blVLOTJBNWZRbjJhZUx3cU55L1lPY2or?=
 =?utf-8?B?NkUvdHBka3lITVFZNlFrdjJudWVGRHVWRDNtbFNEaTYvNjhuVzB3N3J1UStM?=
 =?utf-8?B?U0o4Q0FjN0JHZm8rTDhSbTZvanoyQTVzeHpiZlVIM1RMM0NvRGJZTXRpTjZ4?=
 =?utf-8?B?Y3hDTFdzK2d4ZFZGNm5ZeUR1M0xTVUZRMTZ0dGhIUk5nTTNHZjFwVzAyVVlk?=
 =?utf-8?B?eGx5dGl0MW9keGExcDFyQTVvS29sTnZMQzQ0SGxXTjh3RStiM2JNMG8vYnBi?=
 =?utf-8?B?amJ0N0tyTytJTE5qZkw4M1JKdlBDU0J1V2JIejRRZEFHWW1mbTVOaG5QZTA2?=
 =?utf-8?B?eVF4cCtDaDZ4MGk4a0l6eGxZUThGOFJpQzJoTHFHa1pjbWRJVEkzVGFBaG4x?=
 =?utf-8?B?WWFRemo2eUdsVTJSWXZWVmowZWk4aVFIOUxaUkhzcFBqd3pWQzRodSs4cXNN?=
 =?utf-8?Q?uvEnlgFF/2CWuBUVLyGXFKI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0aa11a-58f2-4a22-43bd-08d9d5060385
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 13:26:45.8033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlFDh/GUC7q6zqlY7IWhhZeyIk112EN04mBQanHW7TiLHtZUgFUcFZ+1mk8vQdlxa5XPoQieGZ8+E9jMDhafJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1946
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,


I am not DP specialist so CC-ed people working with DP

On 01.10.2021 23:42, Brian Norris wrote:
> If the display is not enable()d, then we aren't holding a runtime PM
> reference here. Thus, it's easy to accidentally cause a hang, if user
> space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
>
> Let's get the panel and PM state right before trying to talk AUX.
>
> Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
> Cc: <stable@vger.kernel.org>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>


Few questions/issues here:

1. If it is just to avoid accidental 'hangs' it would be better to just 
check if the panel is working before transfer, if not, return error 
code. If there is better reason for this pm dance, please provide it  in 
description.

2. Again I see an assumption that panel-prepare enables power for 
something different than video transmission, accidentally it is true for 
most devices, but devices having more fine grained power management will 
break, or at least will be used inefficiently - but maybe in case of dp 
it is OK ???

3. More general issue - I am not sure if this should not be handled 
uniformly for all drm_dp devices.


Regards

Andrzej


> ---
>
> Changes in v2:
> - Fix spelling in Subject
> - DRM_DEV_ERROR() -> drm_err()
> - Propagate errors from un-analogix_dp_prepare_panel()
>
>   .../drm/bridge/analogix/analogix_dp_core.c    | 21 ++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> index b7d2e4449cfa..6fc46ac93ef8 100644
> --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> @@ -1632,8 +1632,27 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
>   				       struct drm_dp_aux_msg *msg)
>   {
>   	struct analogix_dp_device *dp = to_dp(aux);
> +	int ret, ret2;
>   
> -	return analogix_dp_transfer(dp, msg);
> +	ret = analogix_dp_prepare_panel(dp, true, false);
> +	if (ret) {
> +		drm_err(dp->drm_dev, "Failed to prepare panel (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	pm_runtime_get_sync(dp->dev);
> +	ret = analogix_dp_transfer(dp, msg);
> +	pm_runtime_put(dp->dev);
> +
> +	ret2 = analogix_dp_prepare_panel(dp, false, false);
> +	if (ret2) {
> +		drm_err(dp->drm_dev, "Failed to unprepare panel (%d)\n", ret2);
> +		/* Prefer the analogix_dp_transfer() error, if it exists. */
> +		if (!ret)
> +			ret = ret2;
> +	}
> +
> +	return ret;
>   }
>   
>   struct analogix_dp_device *
