Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C585F5E607D
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIVLKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiIVLKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:10:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD992497D
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 04:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845000; x=1695381000;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l+09ao9vHKwTFiY/kHCf8FkusBF4+xHzHoBfKGX7CYc=;
  b=N65kqjduSBWPiMSv8uku5WZxz4Al/7MDGWBT4v4TWU5qVYMoQoQWdBcT
   OqP2Ojhqyqr67QWJPK7z6oFmnp0YtaXGINVJcvczdpOWoKL4WfiE1WoQO
   qHesRw9L2uL7+Nv9uQTd9jTuYRat5Di2kcQG/UuxMnTxjswN8D2HFm8xS
   y0dppJUA9wwoMFs4xpljQiGmXLUTxLDneg43WQP7fvJ047CR4ys7G7rWy
   wN+mcnPfQtfUdGySNtiAg4k6Mef/3tlftTZhn50ZkVnvKhIBvdctVCF71
   B8y5fqEXhJQb4MbKgQfd1NbuaHwyiN9Iu/ZFDRn3qmVPBDmFRloEotuzB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301114384"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301114384"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="682171501"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 22 Sep 2022 04:09:59 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 04:09:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 04:09:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 04:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN9F8cHgOBl4Kq7BfdSuNfn5TDRD3jgf/jQwEuJlFJGDgXdMkyHfmnaEVxrj0SfL+iE9x0TR+U8ZzJQCICgQ0T6JOmao8gBd4Ikas+DZKXh8oyF1hbPVGbN8U+Sk/QpCAX8BzZJHCg2L6iYiODjaiMdyL1yNJYoi4UKmGjbWmMEfT5odwQW/ooe+LRwfCV+D6zzJE1fxsdXLQTRCot5DoUHN2O17XQBP8USKWdoxz8Zfp2yRpAHjBudVop34kdKrkWVOVg+oIoz2IpfJ55YjNqfiWCi0bkCeEUZwuD3I95+ZS26kVETMqRas6Uu97i/szGoWmWcek4ivFp3hmCgkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYc9HQxrCtZVAfs3fzoGK9V1BKyGWfJSY9F4JNuiF84=;
 b=ACO+S/c8uNxvM8Zcsjd/46/egsM7Dp9yOJi5tllygdJO5lRNkjUQ4MLKuyLFXwmI6PIOlMf34ASreM6V5JYcvnEl1s4GMRXwqRkHlQgjzhQXpbFEdos9FkD1yIQZLKaZzSebD+sbReVtCF5eSOz4VqsreJIzDjw1J6se5i8oy7kxh6zLpyFBbvB1xoT3diLvUAb+A/pKzpjVqA/q9rc75MXH3BZOI58yhNfuiDhI1xzg18Gpe9/6hKTm8iWofvv1GW1hjZB9CYJzvfdh+dR98kDPDN6ZooS96vnrQ+rMYJBjFjw723u9wxfiGa5SRZDCScBhutinYEUby0EIZnfKaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6211.namprd11.prod.outlook.com (2603:10b6:930:25::6)
 by MN2PR11MB4613.namprd11.prod.outlook.com (2603:10b6:208:26d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 11:09:56 +0000
Received: from CY5PR11MB6211.namprd11.prod.outlook.com
 ([fe80::c144:218:70eb:9cbe]) by CY5PR11MB6211.namprd11.prod.outlook.com
 ([fe80::c144:218:70eb:9cbe%4]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 11:09:56 +0000
Message-ID: <d2a3a63e-597a-6423-3660-f16717dc85e2@intel.com>
Date:   Thu, 22 Sep 2022 16:39:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
CC:     "Nikula, Jani" <jani.nikula@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Daniel J Blueman <daniel@quora.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
 <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
 <YywuKoAg35X1Pclh@intel.com>
From:   "Gupta, Anshuman" <anshuman.gupta@intel.com>
In-Reply-To: <YywuKoAg35X1Pclh@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0005.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::10) To CY5PR11MB6211.namprd11.prod.outlook.com
 (2603:10b6:930:25::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6211:EE_|MN2PR11MB4613:EE_
X-MS-Office365-Filtering-Correlation-Id: d2277d7c-e63a-4d37-a240-08da9c8afb32
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tN7+7ERhHkeWIrbNLJFbRrCM8P+4+MWwtrNaRjzLCMJfJpQwvPl2OhXI6PtFRq5XV8hV5MA3oarETDGO9eBEoCx6br35MdBmcmFdtMYkpqvPbFoCJzuxuoj/AgS8oRGdmNpS/mXLzW76695B8faVj1kFDOIR5RdPcjRTboUiO9G+YgB1puz+/lBHIRPrEjOFbBA5LDQwfHrvcxndf4S0N2OMbrW72I29Svh0xJMPkYxRUXRo3k+/RWaZOECaV99pIBOvmGukV4+F+StXaSapiZ5IHM9/wZNwZk1ChsTuTQQ8csYa10x1cZ4JI3Ed+Ww5TN/l1uxqxgXHl01uxeiEEqyy8bLkhpa7i/bl58dushm6SpHAI2q0Y3ObdATfeEOTNabQwK3dhIoEFmnCvGQUE4aVMP/wCNtdPT8IAsjzvhgm7CiWqh51IDrcVTOyaMTURuW3d9Fecd8Atflh/WR4Sgi7mPbvY7yY9KsAqiyCxRXzkOx/RgX52VC54nlpDfh3AgpaXAIwki2lTadgIzD0sFaEHdSlAbX1JS2BHesR4Y96sT5/dg2MMTfzHXmJoKEyJaGUdKj2SNVCi/ZNM+5D1yHfPku/pNhYRJFJ47FEGGjhw3n+v1WXURwcotHST/tLiEWJEy3eo+AXvmUTfR8tsmkhmG6nTh0hEH9mKpTST2WArKSLd/SZGTSnQVAP5Pcs6VM1dX695eA5nTrtQI7G5Iiy+N+o2JRiEmvXwtsUP2yCJc8TTK7G/4bKvTKeEZnoyqsuHElDpDk35+JbTFSpnthzQqGHGwxA5FTO3ACIf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6211.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199015)(6486002)(36756003)(478600001)(4326008)(66476007)(66556008)(86362001)(66946007)(8676002)(316002)(38100700002)(31696002)(54906003)(110136005)(83380400001)(55236004)(186003)(41300700001)(6666004)(6506007)(53546011)(82960400001)(2616005)(26005)(6512007)(5660300002)(8936002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXNZNElmTkNyV3RES0dVRzZTWlZ3emhSOTRvSGx2T2lBNmQzOGx3eExteUdR?=
 =?utf-8?B?cWVjUmkyUlFvQ1VyV1FQbXhtNkR1d3Z1TStRaVd6MmR4R2o1UzhLNlVYaHkr?=
 =?utf-8?B?dGg0UWdWZjZlMHJkdlZSOExpUHlMNFBpRHJKZmlSY1JsK05GZk9ZYWcyMmtK?=
 =?utf-8?B?Y2VmeXRuT1BYbU9CbXYvU1F5MmhrcXUzdE9GRGJOTmZwZDhROEY0d21tdXlj?=
 =?utf-8?B?RGZheWdpbjlBTExzREdURzhCM1VOR1FZVXpCMlBtRTRwUGVMWVJQcGd3Ym1o?=
 =?utf-8?B?emVId1dKdTlkMlFkTm9zMVdEMkw2SHB4aXp2bEhNeVhxcU56YTluQkxPTjVn?=
 =?utf-8?B?dXROZkxsdXNGUW5iSFJLNitENUJ4dHJWUlFodmZLKzliNWcyNVNKR0ZsVEVG?=
 =?utf-8?B?cSszVFRCbmlZbjM5TXZJZDZnZHJtTFF3K2t2MjAvMmNlRlZ4SHYzUlJtVzE1?=
 =?utf-8?B?dmg3ZEtPeVMzSW5BVGVJMEV1YlRsVFdWZ2xMNk5CcFBOTlBqRFJTQnlBYVMz?=
 =?utf-8?B?M29SQVRyRHY3ZHNIZmxjOVh6ekpqRFEySGdzaS9DY3JwMitzTHZNSi8zcUlZ?=
 =?utf-8?B?T2dCOXR0L2NZaHRiNjc1MzhzcFQySW5xbjJTTkRQMGthOWR6dWZBK2doZkJr?=
 =?utf-8?B?OWhkVHZOWGpKcXhYNUZnY2U5Q0NYelFWaDBhYldQN0VwY0J5b3kvUDFjVS9F?=
 =?utf-8?B?ZHJDYkoxQk9QSDFhNWlBWGlhMWloOE9lQ2VIV1dxeUo4TVJ2Z1BpZkdVelVX?=
 =?utf-8?B?NnljVk02WnUxSGdWWGxOTnZ3WHBlZjRlZW1pbUkvUWE5SFozU21sQk1NRXRW?=
 =?utf-8?B?SlAveGIzU2dnVGc4SnhOcnB2cjZIMktJQ1o5V0NSZmo1V2pNRmJ5UW1DNEdP?=
 =?utf-8?B?cEdzS2Q4TUZmMWZ6ZGl3SmtncUxSb0xLbnFNdGpQZkU2aHhDalFJZ0FlcmI3?=
 =?utf-8?B?V0xTVDBmQmVmVGpFUkwxdi9Vc3VDNjdJVW9YUVZzUTAzVDc0blQ0b3hNZk1X?=
 =?utf-8?B?dGZIb1dOZkZoR0ZTODBDdXlhek9KdmxlWVkxNVBYVjY3N1QyNlNSc01ORjNF?=
 =?utf-8?B?SUJmRG80aHQ2Wkhaak1ZeGQ1ZUtUV0VZVjBZUkhwbTBkV2g2TlRxSE42bEl2?=
 =?utf-8?B?NldvRFNXemxlekxMMXhkaGdObEUwakdnL3hyeFpqNUdiSVNGM0V2MWswOGxS?=
 =?utf-8?B?dmprODVTL1AyYk96NS9oa0o0WUhWcXVUdGZNbFBQNnNGenhLdE5ieWVNODBl?=
 =?utf-8?B?eGgxQWRjZ3VTQmc4UnNTTUZ1UGxqZXl4Zlg1ZmhTTy9WNE02ZGk0RnlqNEx5?=
 =?utf-8?B?eWo3U1l0RHJzVitjdnFCc01iL2VFaUowbTkrQUY3NVhCaWV4ejcwWGZpUkR2?=
 =?utf-8?B?bzdjODJiMDJzZzZmY0RNY2dNaFEzR1NOR3Y1b25aLzVFdkc0WHBBVEhXRkw0?=
 =?utf-8?B?N0dXRC9ES0g0cWpRb0ZDUmFNcWtySkZ4dVJDa3NkQ2ppekdCTVFERFB4c2Zk?=
 =?utf-8?B?L1ZTMWhjdTcxZFlreXdzQjZYS0g4Z240NW5RQUZPZUNCMVNYbXJMVFlPblVa?=
 =?utf-8?B?bWQvdG1xWHpmVmloK0dscFA2V0VpYlZoSEpMcDJQUDd1b3BXRW5JbFU5RTAy?=
 =?utf-8?B?UzFtdm85T2VJT0VFSHFLeVNEcklFcnJONHI0cGFFMnZ0NVpoeWFuaUdVaDlB?=
 =?utf-8?B?THlqSGdacytkaThPQVIzZll5aWdMNXJ5L0RDQ1ZvT3pEd1lDYVB3cm9WL0dz?=
 =?utf-8?B?cndjVjd2T1pTUWVGTlZpc244bkowNUZCaVlLMlM4cENqSkJHVjd1RkROcEVO?=
 =?utf-8?B?bERYekI1NUVxb1RxTzY5TktQSUtyVEtGN0FoeXY1bDVIV2VLWnhhdGo5c2Z0?=
 =?utf-8?B?RWRPWE94WmxKenJlWHVIVkhUZENEOWphdllRR0tQRWFOQWVxUGo4VXpwU1pI?=
 =?utf-8?B?WVBhU29Fdm9wV3ZVaEkxZUZpSkYzM3lTeU1OdlRBdFJNbE9ra1I2N0lTdDFR?=
 =?utf-8?B?cGRVWE03cnk5WG1GYzMzN1lyOFhGd2RNSzR3UzFxazVvSFU0Y3FwN0RvUFg3?=
 =?utf-8?B?ZnBwTVNrTVNkc25kQU1yN01kVkpvTU85QURDQlY4QktQeWM0aTdIaDJIeWlm?=
 =?utf-8?B?WndFQ3c5R0VwbGQ4ckVTaUk3dE5WcUVZSWZ4aS8wNGljUHNJU2RIOUtTcnNO?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2277d7c-e63a-4d37-a240-08da9c8afb32
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6211.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 11:09:56.3770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /U4oNtlIip6S36cIlhdPUJFYRzDlXobYpMkPo9KXx4YVRIt9rm8ATjfwHcYuI9Zkh1FtxSYjhz67GHWx6RbPWC+1VX5SIt05ILxPLmvdJv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4613
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/22/2022 3:13 PM, Rodrigo Vivi wrote:
> On Thu, Sep 22, 2022 at 08:56:00AM +0100, Tvrtko Ursulin wrote:
>>
>> On 21/09/2022 18:39, Rodrigo Vivi wrote:
>>> The force_probe protection actively avoids the probe of i915 to
>>> manage a device that is currently under development. It is a nice
>>> protection for future users when getting a new platform but using
>>> some older kernel.
>>>
>>> However, when we avoid the probe we don't take back the registration
>>> of the device. We cannot give up the registration anyway since we can
>>> have multiple devices present. For instance an integrated and a discrete
>>> one.
>>>
>>> When this scenario occurs, the user will not be able to change any
>>> of the runtime pm configuration of the unmanaged device. So, it will
>>> be blocked in D0 state wasting power. This is specially bad in the
>>> case where we have a discrete platform attached, but the user is
>>> able to fully use the integrated one for everything else.
>>>
>>> So, let's put the protected and unmanaged device in D3. So we can
>>> save some power.
>>>
>>> Reported-by: Daniel J Blueman <daniel@quora.org>
>>> Cc: stable@vger.kernel.org
>>> Cc: Daniel J Blueman <daniel@quora.org>
>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>> Cc: Anshuman Gupta <anshuman.gupta@intel.com>
>>> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>> ---
>>>    drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
>>> index 77e7df21f539..fc3e7c69af2a 100644
>>> --- a/drivers/gpu/drm/i915/i915_pci.c
>>> +++ b/drivers/gpu/drm/i915/i915_pci.c
>>> @@ -25,6 +25,7 @@
>>>    #include <drm/drm_color_mgmt.h>
>>>    #include <drm/drm_drv.h>
>>>    #include <drm/i915_pciids.h>
>>> +#include <linux/pm_runtime.h>
>>>    #include "gt/intel_gt_regs.h"
>>>    #include "gt/intel_sa_media.h"
>>> @@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>    {
>>>    	struct intel_device_info *intel_info =
>>>    		(struct intel_device_info *) ent->driver_data;
>>> +	struct device *kdev = &pdev->dev;
>>>    	int err;
>>>    	if (intel_info->require_force_probe &&
>>> @@ -1314,6 +1316,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>    			 "module parameter or CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
>>>    			 "or (recommended) check for kernel updates.\n",
>>>    			 pdev->device, pdev->device, pdev->device);
>>> +
>>> +		/* Let's not waste power if we are not managing the device */
>>> +		pm_runtime_use_autosuspend(kdev);
>>> +		pm_runtime_allow(kdev);
>>> +		pm_runtime_put_autosuspend(kdev);
AFAIK we don't need to enable autosuspend here, 
pm_runtime_put_autosuspend() will cause a NULL pointer de-reference as 
it will immediately call the intel_runtime_suspend()(because we haven't 
called the pm_runtime_mark_last_busy) without initializing i915.

Having said that we only need below, in order to let pci core keep the 
pci dev in D3.

pm_runtime_put_noidle()

Br,
Anshuman Gupta


>>
>> This sequence is black magic to me so can't really comment on the specifics. But in general, what I think I've figured out is, that the PCI core calls our runtime resume callback before probe:
>>
>> local_pci_probe:
>> ...
>>          /*
>>           * Unbound PCI devices are always put in D0, regardless of
>>           * runtime PM status.  During probe, the device is set to
>>           * active and the usage count is incremented.  If the driver
>>           * supports runtime PM, it should call pm_runtime_put_noidle(),
>>           * or any other runtime PM helper function decrementing the usage
>>           * count, in its probe routine and pm_runtime_get_noresume() in
>>           * its remove routine.
>>           */
>>          pm_runtime_get_sync(dev);
>>          pci_dev->driver = pci_drv;
>>          rc = pci_drv->probe(pci_dev, ddi->id);
>>          if (!rc)
>>                  return rc;
>>          if (rc < 0) {
>>                  pci_dev->driver = NULL;
>>                  pm_runtime_put_sync(dev);
>>                  return rc;
>>          }
>>
> 
> Yes, in Linux the default is D0 for any unmanaged device. But then the
> user can go there in the sysfs and change the power/control to 'auto'
> and get the device to D3.
> 
>> And if probe fails it calls pm_runtime_put_sync which presumably does not provide the symmetry we need?
> 
> The main problem I see is that when the probe fail in our case we don't
> unregister and i915 is still listed as controlling that device as we could
> see with lspci --nnv.
> 
> And any attempt to change the control to 'auto' fails. So we are forever
> stuck in D0.
> 
> So, I really believe it is better to bring the device to D3 then leaving
> it there blocked in D0 forever.
> 
> Or forcing users to use another parameter to entirely avoid i915 to get
> this device at first place.
> 
>>
>> Anyway since I can't provide meaningful review I'll copy Imre since I think he worked in the area in the past. Just so more eyes is better.
>>
>> Regards,
>>
>> Tvrtko
>>
>>
>>> +
>>>    		return -ENODEV;
>>>    	}
