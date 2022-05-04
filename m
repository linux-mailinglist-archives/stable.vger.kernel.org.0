Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA8951B3A5
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 01:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381964AbiEDXml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244242AbiEDXg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 19:36:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8911150
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651707169; x=1683243169;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wYQQT967KfGTcglcWqH1dNAK+FtpDeOVQvePBxDbhzE=;
  b=X1ge1uaodVpJfbl+1nTBFPp5PYvizFV4cdaMU5k72DmPmHM4QK4awc00
   d6GGp8T4cq8Z5XTpCcoIO7MjfwcIAzyVRpMcnWgeEnGoVCYnst3k9J+tK
   PJ2PCvfQie3Sa6dmL3ameQaUpZ7t8iE3/Or3jzPHDhjQZSP9nP2HLcf7A
   W+3JAel53ES/+9eFwzImAxrX+uBVWkMX0HQvRPwbU95XXmYocAaARrFP1
   cSPChLlG1Yz8c2VHAKSdeh2UYGY1UaIXEZ3r/DNulYQLyAtq0FOsN6zSQ
   9szRkApdYwy8VJmZBlMR266J4o/OGXNNhLakm0Aup3tF3tlGcsQTICRPO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="249913904"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="249913904"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:32:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="708689570"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 04 May 2022 16:32:49 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 16:32:48 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 16:32:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 16:32:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 16:32:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEXaTk45bAeP7YBPH/Pt2ZZwLdoXXv0yTcRzJbSSNq0nwweSaQPg05NWBHt88IiJ+uiyXrGVG1nQ8v7FVIPdE9atdz9/G7jB/JsBYXCEAe7tM5FC+bCUuBDNFc1sFapsoGNPPQiZN0iUHJ7F6+M7Zmf1GyH1CytCWFRs6JHTO8kP+r13tRFD1mFr9DE3kPf0haNRXTf5i3XdPhEcd+MD9DWsuQlJqSpZkyExeyoY6teoc3FPQ5HE6OpRHdkCLOZvR6dRP84oFtTACo81fUVagAlKv6RRliUyIxwtHlEwJQnYQtybEK/9FrnZa3vMaNkqUovjRu4aJriNF2ntHLZBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QHMRrXjk0TfdBLsC3Vqkv4ihKMyD0uDX9SSe3+mtxE=;
 b=kQRzGwbT+A+LE4KtDHsjKlAwQ59vCOrdkumsGwzUUsUG93M3mQIEMUtDEVjH1xAr3Ia8wxLEAyZPuqYa3EQP1UWg4ZlFM7gWzvJe5rHOmwvE0JUUPy4HCZQY+z7eZyEiZb8vxq/rGe+I4p+nCxgWu0P8IuwP7WQK44OPIFrtkXOZt4S89RiU7/GMQAHl1M8nA+nVIMUvE2/PK5+HKpJ4LdSPTkY8TZ+bJon334aNvR8aoUdlARcb0/UM8b/ifTkp8tAoGLnLTLGw6J7ctrNwA5BJF2WKfDhCSBHK3Hq7nUz5r74B2i8m1nO7NSkhRHrighnqTygmBV73gldvT6xDbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by DM6PR11MB4315.namprd11.prod.outlook.com (2603:10b6:5:201::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 23:32:46 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::ac18:95e3:c184:f976]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::ac18:95e3:c184:f976%6]) with mapi id 15.20.5186.028; Wed, 4 May 2022
 23:32:44 +0000
Message-ID: <c1ff80ae-465b-b54d-a62c-43673145a038@intel.com>
Date:   Wed, 4 May 2022 16:32:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [gfx-internal-devel] [PATCH 1/2] Revert "drm/i915: Propagate
 errors on awaiting already signaled fences"
Content-Language: en-GB
To:     <gfx-internal-devel@eclists.intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>
CC:     Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        <stable@vger.kernel.org>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Jon Bloomfield" <jon.bloomfield@intel.com>
References: <20220504183410.1283944-1-alan.previn.teres.alexis@intel.com>
 <20220504183410.1283944-2-alan.previn.teres.alexis@intel.com>
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <20220504183410.1283944-2-alan.previn.teres.alexis@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:a03:100::44) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a116191-65d4-4b8c-bc25-08da2e2663ba
X-MS-TrafficTypeDiagnostic: DM6PR11MB4315:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR11MB4315B7FBB3311CE049803323BDC39@DM6PR11MB4315.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxtK2F6PS0O0CR3arLjDgG6PQ8yCnUhmKvReKRmBtIB2VkK0jlS1eMw6d2w0jfdsoFZlhJvmDeiZAoW5KsyIsEqJklYNxRuXUX2fyZip/v5ekEQlA1d+svrL0fB8Ijjcw2OmxPFoyX0NVreiKBbO1WanolYsnKg5eYSn7nObmJJMfQgSYmH44cskFySIK84exsyUvS3aTiRdTSmYEVHcjUTGgHU3ib800f8HiL9pnViYJ+RU5X4sB9UuiK6YHYc2rXMpbzvx/x+aZxBivdSGEk3DhKriYr4T65xbpB67Vxo+4dttCWk9jGifHiN7o6jYQpwHagcCElG3wd+l5ajyqmHw0+2TADgEZHdfDKljbg/uKGj5rSesphiSkG4cOB1No2/NpBWMnX5sz3atOUvUETPhOLn2X3nTMu7niB7hZMPYn271Cc6OyCSBXAQRC2CBM9K2sWqZssUCJ8dqtI7FUJ/2RcRLZPkbBr0gyo893XA5wlKPC+cYcTyO80u26xSyUIe1X8tfWbzibadrkp3rQmXOnhcxKok2SfMK8SxqdLMMVd4n7X31r5JAuWzNfTNnjL4GJhP/kxAXJEbUeT54I2UmaLehIf6E4gKFmCbUi3aUo/+YT8eWXEgTMVVfPS3dCnMCGgLxoRmS5V5YtE77SI1kqGnb3JnB6kCgnl9PfYcDutKL5xQJXuseQcDKz5HV3qv8OncZHyAppFyHobtm4J5+HqvoWM8AWRBETyUX4cCFqziVXL1Utr+vZ6SfrsVJ5M1YJEbYRR6rpxj+6BDvyRTLumAsXZgPzjBldu/U7W6zkvGpoaZ2LVSXGl+aKYw9lnzn+Bw5MFplZTfyYszGkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(4326008)(6862004)(8936002)(31686004)(966005)(2616005)(5660300002)(6486002)(2906002)(6636002)(8676002)(37006003)(66476007)(508600001)(66946007)(66556008)(54906003)(53546011)(31696002)(38100700002)(26005)(6512007)(83380400001)(6506007)(186003)(86362001)(82960400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dllZMFVXT1RBM0QrNmJrMno3UDhodGlldlNXMVBKVCtKek0rVEhIUHdmbkhV?=
 =?utf-8?B?RlpWTFNacDBaZmYxN3ZQM1NyMGtORitLN1FoLzUrQlY4Mm0vNW8zT3ZsTHBm?=
 =?utf-8?B?WDJZWkt4ZE5NRjEwRWJaeVV2VHk2bXZNRGpEcnR2eERjQkIvRVBvc1gvdktI?=
 =?utf-8?B?ZGQweGhLR0tWOUlCcmF4ZTRuR1Z6c1VhTExjNmsxRU9KbjBDS2hDMFlSMnJi?=
 =?utf-8?B?U1Z2UDFsYWF3Y0JtNFNJb0ZhclJPN0pSZ1VvVEwreHFUaXgraHBKeWN5WXZV?=
 =?utf-8?B?L1NBbTE1cSsza2NlK1pRcVZBWFdYVVIzZkZxcmJXai9YTGdjU2JOQUQvazAz?=
 =?utf-8?B?ekt0S1FGcGdEUUt0YkR0cU1RNGdybTREOEgvTXhjVUFKSnhyN1lvbEVLSUt5?=
 =?utf-8?B?d1oyNnRrQmd0RFFOcThLa1d5dWl4OFJBUmpzendNcXJWaGlYb2lMd29xSjFt?=
 =?utf-8?B?QmZ0QzMrQUZ4Ny80ZjJIc0dxNnYyZmlsNk81S1NRVDBuYjN5SjFKNXQ0Slpn?=
 =?utf-8?B?dE9QRGlNRDBGdjhreml5RG12NWlvUEdCZGVWWTlNb1FqcmRHNzU3dGJhbG1B?=
 =?utf-8?B?aDBmMDlHRzZEc3ArOHdWVUtZUHZlMHV5L1JjUm4vTWhJYkJFSDZIakx4QzI0?=
 =?utf-8?B?akM3Wmk4aXp4bFNEVDFzSjNMRDdRQmJuMjFOU2owc0cwZ2pudm5pZmdLN1hQ?=
 =?utf-8?B?SUY1VEZEVFgxdHRkY29iTjE2TWZpYWFVQlQzVDdvQXZiem1Nais2QTVwRmpj?=
 =?utf-8?B?MG1uNjY2ZVdYY1ZFdHNxWWJGNjRIOVdiVG9PRzdmSW4zQzY1aFlTUWZwTmEr?=
 =?utf-8?B?ekptMFpCNng2dDVVTWxOUEtWeWJRcW5tNkt4NmNpVW9Gam85WXpyMjhpdFJJ?=
 =?utf-8?B?aXpZMDFlSHJkQllvdDM4cHdoTXZrQTR2NGx4T2RQbjBpQ2hzaFpxbUUwS2Rx?=
 =?utf-8?B?ZXRJZFF3UTB6dGo3ZEQ3c3NRTEpWMVJ0c2hCMUhoN3VFTXpTbGNWUVpmZFRM?=
 =?utf-8?B?cldqVThlNjdMeUVIZngvekpqelhPeVM3aUhocTQzaUpNd0IvcjNDQzRjcGY2?=
 =?utf-8?B?TzNObEtsZ0ZTUEN2WVVJM3hPK3hGcXlva2NLNERaeUJyTzhSRmswR3Z4WlJS?=
 =?utf-8?B?ajN6ZXRZUWhFQy9OMTFoWERqc21rWlFYSUIrRDVVa3lNTXlNT0JmcC91TnpS?=
 =?utf-8?B?eW1xUU14SStDZi9FTWxobnlxNUt1c0xlQTMvTk0wdHVOT0l2VmkzRGNBOHJk?=
 =?utf-8?B?QVZBTW9MMVp2N2wwVlVQY3kvam4rOHJZZUtCNWg1N2NCSXltdDRwNmZzVGRF?=
 =?utf-8?B?Ly8wcUpQUytrNFJDWUVuY0JHcEQzTGhQU09PeENWb3FkK3RGRGNCS0VFNlQ5?=
 =?utf-8?B?ZmxZWWVmMUlMb0ZRQ3NDYnllZk1DNFQ4T0ZRZ1duLzhjZ290T0pVdjJlVGdh?=
 =?utf-8?B?VEZMOFZSd3lxS05sTnNXQ1dHY3VNeDNiaitUb2VWNjlCWm1ER1NTSERlVFZw?=
 =?utf-8?B?dWd4RXptUG5KcUo0UXZVbFNOakM5d3Z3OGpaNGJZRjJ6dmt5Qm8vUXlqN3cz?=
 =?utf-8?B?ZUtocjZqUUZFd1dSV0RpbG1EamI3RnZmNy80WWJUQTMrVmlWK0tiSEIxS3Rh?=
 =?utf-8?B?OFBGUUhjWkI5NTlLU3B6M1RicS9YNi9XcmZiRTB0bE9vNHVDbm9ocTBtUWlX?=
 =?utf-8?B?SVNvSUhvYmZoZXUxS2NhMytLYlE3K3ZuODI4ZXh1QXl5OGJUUEhGR0VDakhw?=
 =?utf-8?B?RVhuc0pYTkRhVm4yeTZacEROL1l0eE1jbTAzRDkraDB1T1NVb3R2KzRGNzRV?=
 =?utf-8?B?Z1RJT0VZNlhXNVErY0hIOHp3NGlDV2dFaXZhb2NMRlVMc28ySGRKTjAzNC9h?=
 =?utf-8?B?c1huTjdyeVJ2WUczMjNjaHZWS2c1UVRJTVBtam5OM0UrSHNaM2M4cmk2b2lJ?=
 =?utf-8?B?aGxHbjJCOXpsWmtkOHI5K1BQZW1wL0dTdjk1SW5JOFpUVWVKNWcvc2x6OUhG?=
 =?utf-8?B?Wk9WMmlqTWh1M0N4RXF2TXdRY3EraGxLZmdrQlJ5V3VFVUoydWc2SHc5b3RV?=
 =?utf-8?B?UlpTd0hMSzgwOFU5VDVqd3lXdHR4TFA1TTRPL1I3cW5CdmRFQ3JpNS9kMFdX?=
 =?utf-8?B?TTF3ZStSLzNHYkI4amF2Y1I3RlRneWM4b0FTc0pMWk5hYnhRS2R3NTExazlu?=
 =?utf-8?B?VENRMFREekhHS3gwTWxFanBnMFBkTGh0QTUwZmxkTERMdVBUaHdBT0NVaVU3?=
 =?utf-8?B?MmNDYWJVbmZRaXNuUGE3akttR1dWM3JDWWNWdjdXVE81Nmtsdm0yeSs4bmhx?=
 =?utf-8?B?MDZVZzQ2TGFidlpILzc4UVBqRmxZTWlpQlpKTThvcFVIbGUvck0zWGlWazlE?=
 =?utf-8?Q?8xGHZjSh82iEF+ik=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a116191-65d4-4b8c-bc25-08da2e2663ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:32:44.5507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIRA2NjXERTQoIEN3N+8CqsYZXLMny85qL4co8gZw9lreo8q90LvjvMW+meO/zDFizrX/tQ5YTqJvAfLX9P+6/i+UMwaL3TwTnB+0NRfpv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4315
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/2022 11:34, Alan Previn wrote:
> From: Jason Ekstrand <jason@jlekstrand.net>
>
> This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> since that commit, we've been having issues where a hang in one client
> can propagate to another.  In particular, a hang in an app can propagate
> to the X server which causes the whole desktop to lock up.
>
> Error propagation along fences sound like a good idea, but as your bug
> shows, surprising consequences, since propagating errors across security
> boundaries is not a good thing.
>
> What we do have is track the hangs on the ctx, and report information to
> userspace using RESET_STATS. That's how arb_robustness works. Also, if my
> understanding is still correct, the EIO from execbuf is when your context
> is banned (because not recoverable or too many hangs). And in all these
> cases it's up to userspace to figure out what is all impacted and should
> be reported to the application, that's not on the kernel to guess and
> automatically propagate.
>
> What's more, we're also building more features on top of ctx error
> reporting with RESET_STATS ioctl: Encrypted buffers use the same, and the
> userspace fence wait also relies on that mechanism. So it is the path
> going forward for reporting gpu hangs and resets to userspace.
>
> So all together that's why I think we should just bury this idea again as
> not quite the direction we want to go to, hence why I think the revert is
> the right option here.
>
> For backporters: Please note that you _must_ have a backport of
> https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
> for otherwise backporting just this patch opens up a security bug.
I'm not seeing that required patch in DII.

John.

>
> v2: Augment commit message. Also restore Jason's sob that I
> accidentally lost.
>
> v3: Add a note for backporters
>
> Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
> Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210714193419.1459723-3-jason@jlekstrand.net
> (cherry picked from commit 93a2711cddd5760e2f0f901817d71c93183c3b87)
> ---
>   drivers/gpu/drm/i915/i915_request.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 8e310b8dd91c..6a5070399c04 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1297,10 +1297,8 @@ i915_request_await_execution(struct i915_request *rq,
>   
>   	do {
>   		fence = *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>   			continue;
> -		}
>   
>   		if (fence->context == rq->fence.context)
>   			continue;
> @@ -1398,10 +1396,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
>   
>   	do {
>   		fence = *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>   			continue;
> -		}
>   
>   		/*
>   		 * Requests on the same timeline are explicitly ordered, along

