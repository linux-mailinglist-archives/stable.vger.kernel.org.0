Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1BC53ABB6
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 19:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352593AbiFARUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 13:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354245AbiFART4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 13:19:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1B86CAA2;
        Wed,  1 Jun 2022 10:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654103994; x=1685639994;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yNVaWlsgLdM5z52CMQv4GTDN34VGUOYwK05t0cR5PW0=;
  b=Isesdrk8RRUoycm92Y+KMP55TMili0yUKMzgkACkgv4RrxXPPs0xDCMY
   4ECkGgVnKzyP86hbpeym/vSJkj2gELZjk3A8LxSqXIM23KMFi3N3SJrQI
   zNmtHKkaHAdOrQQr4e6i9p9RE2bPMWSozB6scYQZoswRoQFlv24EWhNp+
   UGRuDRwYbu9vuT3QisWGwGLOKZ8E89W/YMHxJfOKbvnBvzRCWRbzwAwur
   VJuKlDyI+cMQG+dfZfRhqTBXFRYuTQ25FP9ZMv2aDdTY9ZuNcFMXD2Wqt
   KQ4+h7hqp/V/cX6v/taS97w6Ux6NS0p+XIq3Nd8FZ3XAJt3GJg8PNNQXH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="274465414"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="274465414"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 10:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="562896526"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2022 10:19:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 1 Jun 2022 10:19:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 1 Jun 2022 10:19:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 1 Jun 2022 10:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtQqk2Nv5KVM1xZrZV4g3H4I4h3TiPF1K8Zeu8mWrczwqVx1r7iS39y/qiN5nuKUZE+3GXbwAzXZL0yRdvgvEYuL982R2ff3cgjl7sm45WQgsiuUDO+k2DhMSpe+seeRwchVEsAUU+kGL5L/IIe8DluAk10P9/WFWfg6vKO4vDb6dBP3mLPpRv4WCpp0mQA8QDQNaUCkeByHnv06nTDLU1CPBDhLtX7C5xHhnOzUvPCtnKbzfCTfVPA7Q+v+uK+0yB1Pke+eXartJ2Q4LXK8y1hix6tbpOHm4PK+aGidPylB/3+jLROsvvzGJZ8kcscNk8QnpWAkseypEIl+U/h/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyfWZXKGXopI0ker35mkyfovPqO+vw+ToXqdXRMny5I=;
 b=MA6eiXuDnqdKnje1blQ1E0ioVRFLTA/TnSPKYhG1phwxCgY0SNRWcO53F2tpLvbFM9er7UxOXt8KIXVUqbsNQFcG8SCuRBG7VenN/hEJo7vfrG3ypwVJfTrEHG1lMh+f2uMEVQV5dyFT6+ZiS894a99o1M2XomiahimAjSDyyAkfv7AlOJ3sFbgGBVT0rrS8MNUWuAF2Vka2nCAAQma+oc/kwVZZwCVlDjzXE99gfmgw1NXdyhqndWUDaVUgxdtVB4PoFUJ1s8NtzUY6ifWatdI8P3IO3r9uMzzNNo9JBzTYz01wr18FgqQnai04rMxuBMSCqrQnFhUtvuwxmbKv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BY5PR11MB3942.namprd11.prod.outlook.com (2603:10b6:a03:188::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Wed, 1 Jun
 2022 17:19:49 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 17:19:49 +0000
Message-ID: <55ef4461-75b5-4c1b-90b5-17909ec58f25@intel.com>
Date:   Wed, 1 Jun 2022 10:19:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 4.9 03/11] selftests/resctrl: Change the default
 limited time to 120 seconds
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>, <shuah@kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20220601140100.2005469-1-sashal@kernel.org>
 <20220601140100.2005469-3-sashal@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20220601140100.2005469-3-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::25) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0c3d47e-eb41-4eb4-3c24-08da43f2eedf
X-MS-TrafficTypeDiagnostic: BY5PR11MB3942:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR11MB39426C6B5E3244992373C8BCF8DF9@BY5PR11MB3942.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXhgQGHb3x8qL6ucrLSbeozOFlbv01B9SPjesTFCojdHWK6tqFJ5y+Dq00fHhHURGiHGL9h6hj1EiDGzJM2oTwdgoPPBAtN/vzXFHrbU0bqX5//ggP/PJ2RI5iWco9zi2Tjp8NYATYPJSr7ubjwMWRp4iTQ5J2sasWnQcFdsMEWL8BCyHmJJFaJeWo18h5aGFRD4SrxF+mHgHqgDdyH7TOsDYbpcFplTpDEtYpK/mhpH61dGTyIb1/5Zr0x6/fqiI0pJWHOKAHkpDkoSiI+70hX9Jb9z1d8qY0rTbsEcillsWyUpAAREG5HKUrDqLxm3c/o44cZWHa6KMW0hvF8ZrE33Iulp3WwdIg7a3kifnMIGrgKeh/ISv4RO+k8sKIKqNbkc/XL/BM4+BSd4GdZYGarxFYqSUVuAyGMNxnps7jRG0HnuZL7Hrvhf2PZ8yGPcKL3da7ViwPKL6Zxsa6xp4tH6xsygfSmL3cXw6l0ZhjEiyWVlxZfpEd2z8tiWMpg19z/k04eP6y2UzRiBfuyzjyvlyTxzEb06QL2390B+6eb/eq19cZwGpvzqs9vg8lRVnnXrzvMR27ixzE5GskTJbISkkHWSqkwQeHB0aOmP+xHE5B+0bPxgKiA5sG13/dGueWvJJqpS+yYgY2t1JCy75MYyfPM3uVuYsuW5wFYTieG7deNpNzAVer72rsgjD++57ZJo9EdqR8Q0sgzVREM0vPCKyj7EW64Ki1a3byWg0JhOt1UuQa/5rYHN4zPOUI1gzbjKwuY17CnmVGXnZT4XyjjI2wbYkyKmW2l3tuaZ+0Drf2T4CsL83ydzM1pzhuqR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(66476007)(83380400001)(36756003)(54906003)(66946007)(31696002)(82960400001)(2906002)(186003)(2616005)(66556008)(38100700002)(8936002)(4326008)(6512007)(26005)(53546011)(6666004)(86362001)(8676002)(966005)(508600001)(316002)(6486002)(5660300002)(44832011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3pWNGpmWUVvcE1pWFRRS3JlNHhnUURxS1JhRFUrK1Jtc2sxVmR0ZzNkaGx2?=
 =?utf-8?B?b2YrUnBMK24wY3A2dlp2WEhHT1FkRjdibzA3bkFMSTBDZnFPenRva0NtVTR0?=
 =?utf-8?B?N3d1K2VQWllNVGZUdlozUTY0V3ExV1FzejBPdU5DWnF6QUZuYmUrUG5OR3Z3?=
 =?utf-8?B?ZS9CaW1wYmVsekkzaTZ4QzlTd25mQW9OQnhDcUdHTWdPZkVaNkV4bGYzRXRy?=
 =?utf-8?B?RW04bFI5bnNzazkvVHFBLzJiTXlESTJQVmFKRnF3Nm1WQktOMHc2REUrOUxi?=
 =?utf-8?B?STVtNXFxQW44eVowTytJUTk3NFpnNWhhNVF6UktWeEZJWlZGM2NaZTNVQWJa?=
 =?utf-8?B?RWNLNUtyMWlRdCtFVTJtVS8zR2NNK3BUMks4OWlSTlh0dGhicXRkUVN1ellm?=
 =?utf-8?B?eERxOXRDVE8wOGx5NXJEdlZrbXBXTzhWY1pCYXhYaHVZVkRUSXgyYXhMaU9Q?=
 =?utf-8?B?MURMQVoyZjFCbndkak5FRDQzOG1aNzAvQWE1QnlpZGQzaU1ZdEJXaCtNK3Zz?=
 =?utf-8?B?NDdvNHV4T29Kbi9CeE5OUmZpcDkyd2NRQjc1RStHUTRXK1FwUzJ3NWd1RmhR?=
 =?utf-8?B?ektuc0FFeFFsYzZSdnhsV2NrQ3BxWldiOEhmY3luWnFUOW40dENmZnBXeTYw?=
 =?utf-8?B?dGxwOXVqNXhyOW00SFlRSkdGRGpSQXhFTU1wbjJYRXpqSlpUYUJwcWt6SmlG?=
 =?utf-8?B?cmFDOE43am1jSDRZb0VYRTdpYm0yV2xnRmZnVjh3S0ZMTGwvT3NYd0xGZHVy?=
 =?utf-8?B?MDlDQ3NuUnA4MWtweUgwMG5tV1paUWM3eE9pSnVXUFVUazdsdStMMWsvcHRs?=
 =?utf-8?B?a3UwTkRBb2pYcUQ1Z1dhMllKRW5iUUpmWnFmYkM1cWpJa3UvNnY5dUE1aWdj?=
 =?utf-8?B?SUo1NWJmWGtwVmlnc1BjUmcvdHIrUTkrMk5jWGxrdnFwaUpSa2NycDR6cDB0?=
 =?utf-8?B?bnVZNldCdCtia29wVVR1ZWNJY01rR2FpTU80eXE0cmJqazB3RHpjeWgrTk5k?=
 =?utf-8?B?YzIzSWFXTkVBUUFnL25LMCtOUmlVakxWRGFNSzcyMmJqWW1SOSt1dDY0MDI1?=
 =?utf-8?B?SWtsYTR1YS9kRFpIbmZNL052elJ3TWZOVk44RnNScldranVRTVB4WDJlcTJq?=
 =?utf-8?B?YmhvbGUxMUZ2aWNSVTJBY2F3dWNXbGxtQmk0MjF6TG1sWVY3TVlTbDA3Q1Nw?=
 =?utf-8?B?enhER2dCaTZaKzl6TGNPN3RlMWpwQjNRK2lsdG52MzQybFdYZUVIaHZ1OFVO?=
 =?utf-8?B?VWp0eDNDNjFPTkdxM1lHRWt1andqK3dVaEtLb0VPSEQyZFJ4ZndTZ0FaWFZE?=
 =?utf-8?B?SzFvOHlaWkVrSldyQmVuZ1lndUlzRGwrb3QveG5uWk9oWjAzVHI0MWlraEFS?=
 =?utf-8?B?ZzYyTkhBMEU3SThqbGJucjZtWWtlb3Z4eFdSSEg2aFdhdUNNbTRKNzlDY2JK?=
 =?utf-8?B?SW92N3ZwMkNQQjNrcXpEdFBqUzBVN2xjZjFmbTg3dE9FenppT29DWUFGYUVm?=
 =?utf-8?B?cGZUS3o4MVI0RGFhYUNTd2NId1VTNVBMUmVKSytibW0vYVJpTnMwM0lodVhy?=
 =?utf-8?B?YUlzd3RvNTFsSCtzZFRBUmdRSmczQ0lKbytZVHBUTW9lOC9xVjRCWmR3cExT?=
 =?utf-8?B?SWNOQzlrSGZPOTdNUkNFSXg1YktrNWUrOTdZUUZRVitJRVp2T0FIYTBRVU9U?=
 =?utf-8?B?YTZkaTMwcnlNSmhBWXFCUzVqdC9FTWtaLys1a1dlQnJrT1JybWsvK2lyQjZM?=
 =?utf-8?B?QnlkM1B2WXg0dWZBRTBDcWdybE5CVUpjT1JXbjFDUlFXRXlqeFVZenA5dDdC?=
 =?utf-8?B?Qy9ib25xYmlRYVlKK3dFWnJCMmJpdGpYaFp4dEJMMUxiZUhoTXZONFJVK294?=
 =?utf-8?B?Zkd6bmNLT09oZEU3MFR1QllUK3A5cTc1TnNTSTlyekpvQisxN1dRMS8zNjJy?=
 =?utf-8?B?cXRQQmRCUEFsL0NHODN4K1pIRWlIMWE0dE9TZVhsVE40UzAwZFFYbDFiY3RT?=
 =?utf-8?B?cjYxQ0tnRG5PVEo2b2lUaW9WQis5YVdBM3JvcGdrQmkxSzBGYlFFVEpwMkcz?=
 =?utf-8?B?ckVJbGgrOExvR2JnSThFM0pKS1VZM3BlM205UlBmdDFzSHFDTjJNQUVpNWZE?=
 =?utf-8?B?RHZFa3ZlcXJnMEhnRmd4SUdYYkhsd1NONDdOMWUzeC9kZytnU0FNU1dvcXlh?=
 =?utf-8?B?T1pva0syNkFlc2hYNDNyQmlXcWx6ekg3TFBMeFpFK3AvRkhIdzJPNTVsRHY4?=
 =?utf-8?B?QTJTVW9WOE1COUxKajRZSGR2YWh0RCszL3ZQSmQzM0tTNElRd1FqaUVYeFZV?=
 =?utf-8?B?aGVLZVdpRzlzM2haZHpGSi9rNHJKMG1QcnU4K0ZGaElESHpOSHRqaW55MnZT?=
 =?utf-8?Q?D0GAO3gi9TK5Tk3U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c3d47e-eb41-4eb4-3c24-08da43f2eedf
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 17:19:49.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF6yfTTfem3Ukq/MiRpvm4KZAP56d6w3qfuTbQrI5gk6MxIa661vgXtLaTbskGZYudBjpZQHaDefGuNCvSyzMLzfXPuekJG/dnhlCwLmfOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3942
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable Team,

I received the below notice about this commit being considered for
4.9 as well as other notices for it being considered for 4.14, 4.19,
5.4, 5.10, 5.15, 5.17, and 5.18.

I do not believe this commit is appropriate for stable because:
- It forms part of a series and without the other accompanying patches
  from that series it does not do anything. Series is at:
  https://lore.kernel.org/lkml/20220323081227.1603991-1-tan.shaopeng@jp.fujitsu.com/
- The original series was not not submitted for inclusion to stable and
  none of its patches have a Fixes: tag.
- The series this patch forms part of aims to port resctrl_tests to the
  kselftest framework and I do not believe such a change matches stable
  criteria.

Reinette

On 6/1/2022 7:00 AM, Sasha Levin wrote:
> From: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> 
> [ Upstream commit e2e3fb6ef0d6548defbe0be6e092397aaa92f3a1 ]
> 
> When testing on a Intel(R) Xeon(R) Gold 6254 CPU @ 3.10GHz the resctrl
> selftests fail due to timeout after exceeding the default time limit of
> 45 seconds. On this system the test takes about 68 seconds.
> Since the failing test by default accesses a fixed size of memory, the
> execution time should not vary significantly between different environment.
> A new default of 120 seconds should be sufficient yet easy to customize
> with the introduction of the "settings" file for reference.
> 
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/resctrl/settings | 3 +++
>  1 file changed, 3 insertions(+)
>  create mode 100644 tools/testing/selftests/resctrl/settings
> 
> diff --git a/tools/testing/selftests/resctrl/settings b/tools/testing/selftests/resctrl/settings
> new file mode 100644
> index 000000000000..a383f3d4565b
> --- /dev/null
> +++ b/tools/testing/selftests/resctrl/settings
> @@ -0,0 +1,3 @@
> +# If running time is longer than 120 seconds when new tests are added in
> +# the future, increase timeout here.
> +timeout=120
