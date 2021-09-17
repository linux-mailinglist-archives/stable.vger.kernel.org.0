Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE6A40FF52
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbhIQS0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 14:26:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:29000 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344396AbhIQSZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 14:25:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="202347102"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="202347102"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 11:24:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="434930767"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 17 Sep 2021 11:24:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 17 Sep 2021 11:24:35 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 17 Sep 2021 11:24:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 17 Sep 2021 11:24:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 17 Sep 2021 11:24:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrL2OUTRG3ycldiWsgUnjRyoxa+RERGOr2HXFpMzguAeW6JI/HzN0u5xC026AJcv7z8AOA0r98oDDMH2QVqT48xblDh0Xe7sW2GDAFVbgZzfLt2RpYHSm9C2/1xycYp6i/gGuFrYreDzcmv5mRXQlRc9TGL85xx4+RGaf/mjap7NXI+zKPvbF28rhOiTIr2dugL4bZxw9qct3Q6ccfOuW0AnyXDKVJoAikqZjfH9cGAe67Vo85I1vDjdq51+yBfhCbFV0DpkHrqAlAzHKNw2147Up8zmbPNHL42yPkQ7Jlhz8KwDk06AtWuX0hpW7wAeExMFcPM08+y9DvmlKg05Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZsNxXWGq0KDC/KmqWFe3rim8cXHw/sDc4hNndhPCFeM=;
 b=BtC8bYjlNPo2V9DwLhv8/UoQj3gf+gAz7VISCUqZEqpTlDfPx3eYuULyEVOxlK4+BodXVC9dUyMk4czdEqe1yxLYzybpCAbUNHcF3dKb65KaHht8zaGCl2UlQgaurXHAmplE4VNEE1UzMJ0wdtEauCk23iA8hYlYnD2fr4TsgSsZKxF7bGe9cyM9/MlfS2gZLRUFQ6FkfBNNSW5Cit/BymOmaFG2J9cx448tkLuUUH2OBG1ff9aAn41TPvppFzKC7P+7pzkuw4CZZ08CngWeSBqynW8OlHqsuuyI2fHjtVpN1dXzSxGKsBuQgZl3CStivEbl0qC1ACt8uyGDIcvUMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsNxXWGq0KDC/KmqWFe3rim8cXHw/sDc4hNndhPCFeM=;
 b=KxXGZVOmAOT8Pu1K15OAZD6ZDGLdBpwx4j8cNBVGkoyHen3zExFcqV+IhGjScbbXVoFkcurvtC6q0KsHRil/wtcZekV4RZZF8YiGchVat6zhzJ/1LKSCz50lsBXLp17Bf0PgXBhfge4IuFto1/5iz/bQ+Yasu+pFZIZhFeB8dj4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20)
 by SN6PR11MB3088.namprd11.prod.outlook.com (2603:10b6:805:ce::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 18:24:31 +0000
Received: from SA2PR11MB5163.namprd11.prod.outlook.com
 ([fe80::90de:46c1:4d23:5c8c]) by SA2PR11MB5163.namprd11.prod.outlook.com
 ([fe80::90de:46c1:4d23:5c8c%5]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 18:24:31 +0000
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
To:     Moritz Fischer <mdf@kernel.org>
CC:     <linux-fpga@vger.kernel.org>, <trix@redhat.com>,
        <lgoncalv@redhat.com>, <yilun.xu@intel.com>, <hao.wu@intel.com>,
        <matthew.gerlach@intel.com>, <rc@silicom.dk>,
        <stable@vger.kernel.org>
References: <20210916210733.153388-1-russell.h.weight@intel.com>
 <YUPEIDk7jMc/WpAQ@epycbox.lan>
 <e070cf0f-76d4-5bd8-2e7f-67499351e449@intel.com>
 <YUPKPxrgkLaqEZRr@epycbox.lan>
From:   Russ Weight <russell.h.weight@intel.com>
Message-ID: <d3ac3e97-43c8-c983-9814-1a9ce976a47a@intel.com>
Date:   Fri, 17 Sep 2021 11:24:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
In-Reply-To: <YUPKPxrgkLaqEZRr@epycbox.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:303:85::20) To SA2PR11MB5163.namprd11.prod.outlook.com
 (2603:10b6:806:113::20)
MIME-Version: 1.0
Received: from [10.0.2.4] (50.43.42.212) by MW4PR04CA0165.namprd04.prod.outlook.com (2603:10b6:303:85::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 18:24:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d8823db-bf1a-460f-5833-08d97a08643a
X-MS-TrafficTypeDiagnostic: SN6PR11MB3088:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3088F3CD944BA39CA89B9D25C5DD9@SN6PR11MB3088.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: onoAigY65f2LhYOdolijDA8FFApxsXmfTV2d9Z10IYax3xLx1Imj01FzpHAUQQyW+8AXxBssRFg5RvYsuINjB8D19bT8b1r9Y/k4CKF7FoI+3tXhU5jlsxDRla7qsLELLY0vTK1Pkg+PvHxk9mBHgCTHGw8rW5ftVCOPmu8zvadUhUaHghA0pDshwB5tgLo9gMagL7jLarXlOvXaBFgcGfZCzWu+jM25xKs4Px7PgCRW7OG/hlp72KDe5FMB7sZmOYQGwQQnEF9Ru8zDkD2XFIFPo338Q5Lu/4j23a17ZbquTh1oKBO4QSconyPCsxOE3vC3JY1Aut83dJ1O8Ed2QNRoy6LYWz+XHO/usPKy6mgc0HNFo3zJV/xU/MvdPJ54ZR01DcGNwOEDkgaWmr3Y9NW4tfCJ5yUpFMFU/g+WDbjx/CO4APKY0k266wEBUOU5xuCPIifrI++L2VHIjbJsITK2Uarm56ARzx1oFTbb1SdRnQQOzz3gaPTK0yceAM08Nxj+xRerCSfU5g1nqo/hQKjH6bNcTfRusQq0qSNaTQ3fKF84lNASViAq/shWjkLKuKJvdemret1auXC9vTBtYXK5E1Q+TuI7wbGDMi0gz5ugPm5P5a1aXJAf3KWjANUvxgQ4iTJ9r5t3ZoeZx7LrnFlINPgZyUq42SbTmyG7EOY3yvcXFWomnzDmVTl1Gt5xzAw0rLHkVLh3hjrmNY0RD2wmxcGX1mas24Lyc/MZG2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5163.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(16576012)(86362001)(36756003)(31686004)(4326008)(508600001)(53546011)(6916009)(6486002)(66476007)(5660300002)(2616005)(956004)(8676002)(83380400001)(66556008)(66946007)(31696002)(8936002)(2906002)(6666004)(26005)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1hEaVBEQld0dSs3OEZ2cjhjVlVPOUhJWW1OTVM2N09Jc0Z2OUcrZDE5Qmpi?=
 =?utf-8?B?eGNRMVptRHNISkhveGpCRmdGZmozdFFJa0ZTb1RQaFFoVmdoNTBidzc2M3VF?=
 =?utf-8?B?MmdRd3ZwdWh3eGMzSDFObm5mN3VjbktqTzhsTEpiSEdHVlpDM2R1djU5cDNw?=
 =?utf-8?B?d0hHYUZ0RzA5TTJJekNaTGVvVWpCanlKY01MWVJVU09FMFcwVXh0UzVmYmNo?=
 =?utf-8?B?amIybGpMeDNiVFRRSWpWR1lxOWJBV3V0c0FIWDFRL0J1cy9xTjlSWlphNktx?=
 =?utf-8?B?WFdGREI5SlQ1ZjZCdTg4SE9ReVdFNmx6akJZWmFGaHF2K295N2FoQTgwT3lB?=
 =?utf-8?B?YjRpY05MTGkrQ25BSlorS2lqdXN3WEZFbFpTOCt6QUtYNHA0Zmw0ZFczNEM3?=
 =?utf-8?B?di9najE1M2I1VUE3QjN4WVZURWc4cnFVYVZ1SzYxQjZaMVJ3YkFLazVBWU0r?=
 =?utf-8?B?ZHZhY1FLSEFQLzVnUVNXYU1sMmk3T3FWV0lRSkNqSnEzTzRJQzViYXAyM2V0?=
 =?utf-8?B?M0VxdnMxM2graUdJMy85U2phTk5kUnFtN0Z6RXE0ZXQzcFp1Z3lhSitlK2NO?=
 =?utf-8?B?R1crVTYzdUhwMFI2YkZmU1lnOGpESHVFTFI2dVcwdE1LNlJNeHFQWFRNVTBt?=
 =?utf-8?B?OXVRTnJWd3dJWG5tL2xZU1pIam9SNHMxMi9qTzlHR1lZNS9mOGZkeXBVQXJi?=
 =?utf-8?B?OVowUy95cG9rY0t0SWpHc3ZmU3k0bFJSL3doMjNnUVV6bnI5bmc1QXNQZWND?=
 =?utf-8?B?Ynh5cUhzQVArOUk1bEZIQXRhVVoyeUxNYkJpSVhHbWhqeDhjSEdkM09uQVZG?=
 =?utf-8?B?R0RRSFZ3UWpYdnBPaStlRWU4aDdEalhaRjZhNzFiMTRLNTFxbFRBL1duRHBZ?=
 =?utf-8?B?enZxTkoxZWtHdEVUbTZudXFBWjVrNTRiT3Z0Vm1KaE1YNjRLNkRtOUYxWG9h?=
 =?utf-8?B?M0JnMjd0YUtHc2g1UEFvU3hhUEdCb0ZQWWJTdGoydE83K0V3Vk0wanphUDVM?=
 =?utf-8?B?eklFLzJ3bW9hU2VGL1ZKNFQ0c3FrdkIyUXNhYVVrWFU5WU44Q0JUQ2NkMHNu?=
 =?utf-8?B?NmNZQmxlR1BOOWlpM1dIUG9yQjd0Z0k3Wk1Kd2pMNnBVQkx6eVRqYVJtME4x?=
 =?utf-8?B?Y0dWZU9aNkRtV21QR3BzcEdJOU9KUmZ2NTFmMVh3bFQvYlV5YzBLdmc4VElP?=
 =?utf-8?B?YjhhYUlnYzNMc1gzM1UzclpjSi9JaGdBSkVPZXFRaVpMM3lmcnlyc0JwMUl2?=
 =?utf-8?B?bVVudU1taGRWbkNMbzM1dnFKeEo2T2o3czA0QWRBTUZmZHB5VlB5SjhQTzhG?=
 =?utf-8?B?TjUybC80ZU1HLzNyTlNXYitacGF2U0pyWjJSaFAxQXhLa1VmblhwWGYzS3lP?=
 =?utf-8?B?YWI1N2tsTWFPd3hNOXBGNkp6Wko5MUFHSjVpK2xER1U0SnVxQ3Q5UWR6Q3Uw?=
 =?utf-8?B?eG5LN1ljdWt6SXRGZWtaT1pucUNIRHZ1QmN4a1o0dEFNZ2tIUFFUMnUvNDlV?=
 =?utf-8?B?VmZaNWtUSEkwTm1pQ1VmSWZPbmVYVVFFeU5sYTFlamQyY3h5RzcrYUh2UGdE?=
 =?utf-8?B?S0QyblM4WDJoWTNQR3pLemdqUkJVUVMrVS9aSjVLeDhPbCtLeEM1M0wyd3lN?=
 =?utf-8?B?YUJvU01DU05PZ082Y1FvYXNCRVlCR2VJTTF4OGdsOGJETjJmQkZJbllCaURP?=
 =?utf-8?B?YzdZR2NlVUdzNWFPQ0NDVVA2US9nSXJXYkVMWngzdVdmVE50cDNWRktEbDNk?=
 =?utf-8?Q?nxCXrHh+1dzt36WoGEmupnob2GJ8kcrRy6CV0Ct?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8823db-bf1a-460f-5833-08d97a08643a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5163.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 18:24:31.1489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPHyM5GWXVYezeN3MswlbX2Aub7Nk+NfCKk8vRkbS8U9qdJRGOgb6w3D/BocdcHYhB+Oc7LAR6o6v4TVsIcR2kWJRFIksxzk5z3Ht8Q8v4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3088
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/21 3:50 PM, Moritz Fischer wrote:
> On Thu, Sep 16, 2021 at 03:34:39PM -0700, Russ Weight wrote:
>> On 9/16/21 3:24 PM, Moritz Fischer wrote:
>>> On Thu, Sep 16, 2021 at 02:07:33PM -0700, Russ Weight wrote:
>>>> CSR address space for Accelerator Functional Units (AFU) is not available
>>>> during the early Device Feature List (DFL) enumeration. Early access
>>>> to this space results in invalid data and port errors. This change adds
>>>> a condition to prevent an early read from the AFU CSR space.
>>>>
>>>> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
>>>>
>>>> Fixes: 23bcda750558 ("fpga: dfl: expose feature revision from struct
>>>> dfl_device")
>>> Did you mean:
>>>
>>> Fixes: 1604986c3e6b ("fpga: dfl: expose feature revision from struct dfl_device")
>> Oops - I must have been looking at the wrong branch. Yes - you have the
>> correct commit ID
>>> And for future please don't line break those, or we'll get yelled at :)
>> Got it.
>>
>> Thanks!
>> - Russ
>>> I can locally fix it up, no need to resubmit
>>>
>>> - Moritz
> Applied w/changes to fixes,

Can a signed-off tag still be added?

Signed-off-by: Roger Christensen <rc@silicom.dk>

There was also a suggestion the the variable v could be declared within
the scope of the "if" statement instead of being declared at function
scope. I haven't seen that done much (at all?) in kernel code.

- Russ
>
> - Moritz

