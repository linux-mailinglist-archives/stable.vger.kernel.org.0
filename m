Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB1340ED67
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbhIPWgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:36:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:41678 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234419AbhIPWgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 18:36:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="202834655"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="202834655"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 15:34:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="610841323"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 16 Sep 2021 15:34:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 15:34:47 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 15:34:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 16 Sep 2021 15:34:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 16 Sep 2021 15:34:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrjMgltBYE5fYWM+bBvMc5P+c57XnHsIrrTKmR1NB9tQZYo0mQv1/S8DMS02tReyWdQu+Rg/8b9g24gcyNn1s9qe/bnS6EwTfsU4kuu0jXhkXBWpH5VcM0A3m8Gje1ljWH2JpH2sgex3xtIP1r2QzImC9e92v0bii6mET7eXJSrUfIa+Id2CHxuA915YCdar0HwUHq72VnEGFH9DWTesWxjBMreQtGrrVBsMxDMZaKipN6CMJAy9talLVdURfdJAtnXwUz3o6UgaudXRG6GOYDbJuetWWY6XnXx2VeD54WrPe9Y5d5jsSVQM+SoFNABHIG6GqXz94r5Jq82mgxvRew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kOn4htdR/ebiBA+yUvMaIJUosMVXBS4CbgeeGka9YGM=;
 b=MJc/uSdsxl899ZE5yt8WILGrbEzzpNai3maYttxcgSUDg6SKeroy/VS2ynrTcZbcLkHjRKpp6s1zpdAKl7nil866fxInonZ/oMYS00U5iJ8+A9QVNr0O1uwN9FqzrzZ1Hu/g4Ty7/wxplXZ1lKva/gaLyNSpkrJzOtqojUqNbCSqIuCzTRGX7txz1DGr1VLaJDW9axabR2dSkgzJVLqhCBKIzPF18SsQ4pM5kx94CunyzZP5QtGRo3EY2Vx2DJ7TVIMxTbOoTW+dOCo1aCTd7yf/KgxM9ZgodahzA55tvLXEqB+48/g9nQziv2uw8c51Srk7gzBKAW2GgOuOzLpsGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOn4htdR/ebiBA+yUvMaIJUosMVXBS4CbgeeGka9YGM=;
 b=AHpGR2HV8HICO+KyvkZvtmcthKV+h5o3zxlVNv5QCbOjKvDbJ73qjjsJmytZuI+aMt+usl5aIlx1WPOYG0+LBloOoVbgcN72w0VeRarOaEEOtmKYhdDyst710E9L5b61Yc0lKY/wvjWchptEFy2RK93vmQK1hKe7qp/VZzMnZYY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 16 Sep
 2021 22:34:43 +0000
Received: from SA2PR11MB5163.namprd11.prod.outlook.com
 ([fe80::90de:46c1:4d23:5c8c]) by SA2PR11MB5163.namprd11.prod.outlook.com
 ([fe80::90de:46c1:4d23:5c8c%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 22:34:43 +0000
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
To:     Moritz Fischer <mdf@kernel.org>
CC:     <linux-fpga@vger.kernel.org>, <trix@redhat.com>,
        <lgoncalv@redhat.com>, <yilun.xu@intel.com>, <hao.wu@intel.com>,
        <matthew.gerlach@intel.com>, <rc@silicom.dk>,
        <stable@vger.kernel.org>
References: <20210916210733.153388-1-russell.h.weight@intel.com>
 <YUPEIDk7jMc/WpAQ@epycbox.lan>
From:   Russ Weight <russell.h.weight@intel.com>
Message-ID: <e070cf0f-76d4-5bd8-2e7f-67499351e449@intel.com>
Date:   Thu, 16 Sep 2021 15:34:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
In-Reply-To: <YUPEIDk7jMc/WpAQ@epycbox.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: CO2PR04CA0154.namprd04.prod.outlook.com (2603:10b6:104::32)
 To SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20)
MIME-Version: 1.0
Received: from [10.0.2.4] (50.43.42.212) by CO2PR04CA0154.namprd04.prod.outlook.com (2603:10b6:104::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 22:34:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e08a0b0b-432d-445b-c90f-08d979622dc4
X-MS-TrafficTypeDiagnostic: SA2PR11MB5050:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50504E1B8077BE745136AE0CC5DC9@SA2PR11MB5050.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2Xt6qfk4fi2fGh2MdghSGCpptbeDZrSGz7bg0ArGvMAGW/giY/1xdbWoEV4Tq8D0fYODsHuYyeC+FwuqydVU9u0bLdIywe6lTpmHedZJ3nXv03XBIFEv4gqQE6nz9pZ+UyVhixS8FAb2Nl526XSK8q3XYc3vdunEVXnPWjZa+JVF3QoEBTSanNnAkQR4eO3fkMV5KqLuSs9j4H2gCnleavOeTNZ2rZQytWMLHXk0BTMD1iqRSXpdLidJSGF81f7LHbWo72mMyR/Lju8CEVDLOLLnhyo9O9WirYmGltJImPqLDha2nBbBQHS1KDUmT0E3nDPEy9fXICxZiPye5uJhKHkLgg/11mTsklI89ERS+bHaj+pcQA8nivixkdHhaQfZ1k8vCPO0jlm6ajc/7qnembffTQZeSH9l+LwJoZbthZwt0FzZzgp2WSTLZonoCWYAGbXCIM/8J4QSJLpIrAyOvaox/xQR7ZM7kTb8NL8WEIcuh7N7rArFoscUN519K9nZlkassxRoJ0myqmoXvbYldMZOl2tupnmd7JjDI4qzlAvMRsk9fVL78ohmAC9yd9AAn1DH3PmMe3jxjrq3xxX4XosWYkZh9bqJ+YR+B1kxS01rfIruH19RDK/98HvDlwY7cDKwf1TjO8T8kHuDfrfEYxdW6m+hV8fUq0UJenxY00j7gSydSUXg2u1zd4ERHEvV+3FEl+s0EJzVSK1UJuCLNoGzUDHPqUuUk0jtOpswBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5163.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(31686004)(186003)(83380400001)(6666004)(6486002)(66946007)(66476007)(2616005)(8676002)(6916009)(956004)(86362001)(5660300002)(38100700002)(26005)(66556008)(8936002)(478600001)(16576012)(36756003)(4326008)(2906002)(4744005)(53546011)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0F0SjNSUURxTWVHWmZVei9ETFU5TUZUdHE1QkZrTSs1dlJ4MlVhVC8waTJ3?=
 =?utf-8?B?bFg5QWEydnNyOVl4Nkx4dDF4N0EzNldGMnNoYmRoS3RFNVQ1Ny9TZmFOUk50?=
 =?utf-8?B?SGZadklNQXFUS0FBQUtBTlhPUmZ2ZU5nSnBORVRrNWdiQWlkWUFZS0VXV1k1?=
 =?utf-8?B?bENoNEJRT3Vuekh1MmhrcGlYUCtCOWRwK0drYjQyc2M5eE9ObVFzTk5HdHlO?=
 =?utf-8?B?Sit5ZjE0dFg1OVR1c3RkRERuVitHTDBuU2NLaEJ2UEs2N3Fhc1BndWhCZjBF?=
 =?utf-8?B?TUczUHdMMXJFQ25ZbGU5Mk1tb2RQRktzeXZTaStxMnczdWsyWDV0NmZMQ3la?=
 =?utf-8?B?clpJVmU3MFg3clpWT0xnZXR2UFY0RjIyTUFUUVlKenBqNGZRSEdOMkdiaUU0?=
 =?utf-8?B?NGlRa29PcG9Od01LOHdjNlowY0QwNFBNWmZMYnZaeDA0UEtCRGEyV0U4QUpK?=
 =?utf-8?B?OTJLaDR4L2VQVGh0cDFHdzBrNHg1K0REWFRyWWVXVDR6Qkt4Ri9pWURLYWlh?=
 =?utf-8?B?NW1td0k3dnpkZi9rSGRhMWdiQTREYWxEdjZ2SklvWk9VR1ZXWGF1MkZJWHJB?=
 =?utf-8?B?ZmQ0dm94Rng0Ty9idGk1VFVKRlQzTGc2T0ZiUXl3MjNzNkJUVGR4TVJkaE9z?=
 =?utf-8?B?U2pQcFczNEdaTXV0NHFzcUF4Qk5hdEJ0b1BYZjRvVUhmWktUdnBNTnhEbkdZ?=
 =?utf-8?B?d21VZk1BWnBaNmJYR3VzUVRJSU1YNGlsOWZkWnUzRHRhblBhSU00aUpWYzNU?=
 =?utf-8?B?MktOZDBrZ09ETDdYYURUUm03bWJRakZUYTZpeHNDR242RG9KY3RFUEdCRVk1?=
 =?utf-8?B?amtxcFpDd1g5Qno3OFpUNG14QVBVSEFndktTemgwNndXVzJUS21GZnpQN3o3?=
 =?utf-8?B?aDFENkd3TnhvS0NIUzA3dGxKU0NJOTNrVnJRMXNPYWVUS3pBQlovWmt0NGJZ?=
 =?utf-8?B?dllVMmU2THIrRElDNmlZU1BWRzRGWElpdWtzOSt5TGNqWlVhUDNOS2RkQzZX?=
 =?utf-8?B?dmk3alN3aDBOOSt5REQwcFdwZ2JzbFlUc0tjOU9mU01aMnhOeWk2ampWNS9o?=
 =?utf-8?B?blJueG5FZW1VRDd6M21MUVBWenIvbysveGZWV0tLUkttYnFDaTVRdVExcWQy?=
 =?utf-8?B?R052YzZ5S1h1dU1CRk1ZOFBreFIzcVZ2cUNvOUFaMDFsQ1FXcjFBSGphZUpq?=
 =?utf-8?B?a3FrSlI1TlQ3UE02Y2ZVNE9kTGtoaVRwQSswbVJFY3ltQ3FDV0cyV2NISlN4?=
 =?utf-8?B?bjlTUTI5T0ZhMzN5b1hCeDJScWVGMTg2YSsxUWMwSWdYY2k1UWVqTTFNenho?=
 =?utf-8?B?NzFPaXROM2lrMEU3eTVXTVY5NkljWWkxZFRaWVBVOFhCNlBqZU5iTitGbEdw?=
 =?utf-8?B?dTZBS05lZDFIbzdwc1A3anZqTlFrNmZON2FvenRhT0FGTGh2NjlJU0lSRzlQ?=
 =?utf-8?B?NFE3SnVFQjJseDlVZ1RXcU5nVUU3aGxXeWs4aVdXcUI1Y3U0cTZ5TnBjL2Jh?=
 =?utf-8?B?bXlJN0Vwb0lHanREMzE2K0lpUUlYdHQ2aThhNVhUVFArQmVyQlRNNk1YdllQ?=
 =?utf-8?B?Nmp2YUYrdC9lV0hyQ3hEU2ZVOVcyVXVjYUliMDNsdVErWHdibEpsdklXUU1s?=
 =?utf-8?B?L0dlVVNuY1l5Ujc2dSs2SkhHRTZ2dm1vVDN6RHg1N25YT0tVWVl1MXdNMVhw?=
 =?utf-8?B?TU1oczNjaXFuZG1XVm05RXpLVS9ucmwzd2ltZFlldSsrZlFBSUdKejluR1lm?=
 =?utf-8?Q?5TBpnO6olpDafYVGFRvLcBJlUvonMnMVRHI/HvN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e08a0b0b-432d-445b-c90f-08d979622dc4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5163.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 22:34:43.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akuQEWFrWAuAx5n2esdhSVNuSlfC++ujNDVwKJ8PmlxdrKl2Lw0DRpj5vw9ljgQU8PIiktXCZd3kuda9fafjP+RfPLwA7y2vjUOpaaGAkHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/16/21 3:24 PM, Moritz Fischer wrote:
> On Thu, Sep 16, 2021 at 02:07:33PM -0700, Russ Weight wrote:
>> CSR address space for Accelerator Functional Units (AFU) is not available
>> during the early Device Feature List (DFL) enumeration. Early access
>> to this space results in invalid data and port errors. This change adds
>> a condition to prevent an early read from the AFU CSR space.
>>
>> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
>>
>> Fixes: 23bcda750558 ("fpga: dfl: expose feature revision from struct
>> dfl_device")
> Did you mean:
>
> Fixes: 1604986c3e6b ("fpga: dfl: expose feature revision from struct dfl_device")
Oops - I must have been looking at the wrong branch. Yes - you have the
correct commit ID
>
> And for future please don't line break those, or we'll get yelled at :)
Got it.

Thanks!
- Russ
>
> I can locally fix it up, no need to resubmit
>
> - Moritz

