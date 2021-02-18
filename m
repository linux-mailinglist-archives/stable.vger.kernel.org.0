Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1931EDF9
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhBRSFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:05:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50846 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbhBRRxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:53:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IHp5TC190348;
        Thu, 18 Feb 2021 17:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=K/RRv+u2j6sN98+BPKWf1PeVf4VC1p0IPqWSAnGgthQ=;
 b=RCxG4nqUPmehP9DjR+FHqDQNsSzy7eGWg9GczF/xydEnrk8eREnhU4fHpJrhZpCUQBi4
 cqGUEEswSnHk3tvTR0IPOVTRWMRcGePE7fo+4prwNBmuL1FxFzZSgqIvIvUjJ5jyQUvm
 YI6g9Ca5CrczUsyy1oBcXwurK0BjlCFbxtHBN46BiYCQ6tISbdXib2U33QpIo1zhBiTy
 3vVKwKi5FHJqkgBggpbPoj8mszCETrV3KQPkXoNvp8ISRZLZlOW/qsXcyjjp75CAWMfp
 psz+Dsl5FhmctFabexZaT4I+7N4He8b85H+gyln/o7uUhexzxd2vmoexfAGR4HuREusj SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bf0x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:51:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IHkH6t029302;
        Thu, 18 Feb 2021 17:51:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 36prp1tvn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:51:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVnCQ4CkxT++CsH10EzlzRf2RZ3ixZRTwTRdtGPdbA52rBajGmvIgr37oVkkJNr4XYoDCovfl6Suv4m7rQ6tGSy20fvPO458OqIu1I7hI6U77VClwL4eQ+9+uvjaPGVrnKofX6+COjS03PEwJIcsqPyYh3BB3FWqNsqj1V4M/hk6mNAYhxJfKvBozoV8UPWfKfnTsejuUrT7CjYku5Z0yjYqQ3pbk11pAvtWn3rnxDT/8RLhMLN3Wnx947Lq93NAjf9HD4riZ/G/NLARTJ98+GZZ5+DprGB0uyweeliYaHwqYzS9YEX4skeMcMa/QvUJCGuZJccQi9RH8Z8IiaVpBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/RRv+u2j6sN98+BPKWf1PeVf4VC1p0IPqWSAnGgthQ=;
 b=c9fnye1AL7EBex+4ZT/Dx7A3Ff7+3ORjAd+PikKjyjZi9tI1NYR8kAMtlb2eb+nhfmPAO5BSPz5cQ3x4X/I6X4KCRggVvTYpeu1NLRJ340cuc/BaUrJ9graFdZGu/t16n+YCY4n1beXtezlrfMIEMpxA01Hig03AhmnikW1v7/LmrHW2g2QHS4qBq2vdcNKnun0llAl6VIUNVwdMFoZScmHuytdkuK0exT5gi+yWnzYBCciEWzDeZxQ9tnY00rPqHS7LLv9JpxdzoOIpyyN2PXV3sceVjmA6NpqCV0gsgxrYR5OACg5K/mfjS6olYAxnrZVAaHReZ5ia7mLUNg18rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/RRv+u2j6sN98+BPKWf1PeVf4VC1p0IPqWSAnGgthQ=;
 b=C4B4aMxdVrLOtM7H/XL3whGrwSX+RyyWrAMd6Glg7zWwHv+1Y6OrXm0b7+Q2yihEOZge5KB3smw1dzcuyG2swZo24d05KXjj9g2s+UE9kfgbJpQ0FuyfSIhH2G5cnnY42pCLljJlEHxpyKJnW+JjVwerMXWiOOlBxvjgzQbW9EM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4356.namprd10.prod.outlook.com (2603:10b6:a03:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Thu, 18 Feb
 2021 17:51:43 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Thu, 18 Feb 2021
 17:51:43 +0000
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
To:     Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
 <19612088-4856-4BE9-A731-BB903511F352@nvidia.com>
 <20210218173200.GA2643399@ziepe.ca>
 <DD0DAFA7-DFD7-4AB7-B89D-CE09F82B04A5@nvidia.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <8722e295-43b1-95e9-9420-025e552e37f4@oracle.com>
Date:   Thu, 18 Feb 2021 09:51:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <DD0DAFA7-DFD7-4AB7-B89D-CE09F82B04A5@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR10CA0010.namprd10.prod.outlook.com (2603:10b6:301::20)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR10CA0010.namprd10.prod.outlook.com (2603:10b6:301::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 17:51:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7266fa86-52f5-4e0f-a9f4-08d8d435da09
X-MS-TrafficTypeDiagnostic: BY5PR10MB4356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4356491D978A29E1DF63F538E2859@BY5PR10MB4356.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZ6MU6qxeHoR69ERFo/G9Aj9folo3RD41HYyAdWucVy0LId0xupLIf4mhYxywHcLKDbYZ2k2e29SOR37znhObYu9ohJO2mz5sBGVou+Bw5Em21KEPw1vCjeHdDslw/hCO7ooruJ4gTgLvLLSMoTiX/zbT0dgcYLcjxpcojfWWwfy81Dsyuz0UYU59JwYurQhu4JoC0J0SpRUnY5aEuime7cm+18+Mpt7dPNADP8KilJeMWeUeBlVgBypoRw3KVBNfD4nrYerjEvLnG/VGj6YQOOqfKH8YONf9hVWcXlZx53DkVhAroBdwlVum3eSq0+GmtShlajsVGr/b8+D/3JOffTFEIYaAQdVGYAbjaUxUmY97d+s1ZkgDAMyze0an7U0ogCRPvy9NsR3o6B0WmABiYMZhE75wePAf4uN31r+L239JxrxXhIJDKi8ZEyNlBuGJW+jxVtsCwhoN6CWkhNo6SSu8lsgsq7HhZ+2qpgI/macf3X2+vetrfWUIjFLhm2jwBE2OjDQGKx7wi2qlymo81hoWQXVvhFvxtJWnThvVRluBotMN3aAxzrOnFS979O98LxcUFg8jsJtubtm64NKVN/uGEKjzaLSNcq/GsO1InM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(136003)(366004)(346002)(186003)(44832011)(16526019)(26005)(54906003)(956004)(4326008)(8676002)(2906002)(2616005)(478600001)(53546011)(8936002)(31686004)(66476007)(66946007)(83380400001)(66556008)(36756003)(110136005)(86362001)(16576012)(5660300002)(316002)(6486002)(31696002)(7416002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OE50MUR4em56RzlNTGNQOHRCZ2xtR2I2Z1ZyNXRSdlRDeUtTcjJ2d3p3ZUQ1?=
 =?utf-8?B?c1FDL3FBeENCMHJOZlhtMzZHV3pDcUNHTEdRZGRaZHNzNE1xTXRPeHJRZHA5?=
 =?utf-8?B?SU9LcUJ6M2lOeVhSTFhMaGlEUkJXOGdPRGdmc3JkRURKbE05eDNBcEVQVE96?=
 =?utf-8?B?MnFlSk0yTTM3dDRubnlUVlR2dElFQTlrVi92SFVoOFhmdW1TeWJDbUtHaERs?=
 =?utf-8?B?S3ljNDFZaThXS2hEdlRTNUdSOTV3enV5NndtQ2xRU3o1MzZUOVhHMm1vQTV3?=
 =?utf-8?B?bFF6U1FSUFA5Q3lxdGFzTm9rZHNFUk1RamVQYzBFcHhWdXliZXhyeWxZQzBI?=
 =?utf-8?B?THJyTFlqdTQ4ZDZQQnd3NmlOVXA3MkhVQTlwT2hxTSszN0hCYVJlV3N0T1l3?=
 =?utf-8?B?QkNTWHp2NU5qaTdkZnNxaE5SemlSYU40Z3JXU3VJS2hSLzBDdmpRTmdFQk83?=
 =?utf-8?B?SjZRSDBReGJsdGxKTVMzMExNU0pIK1pJMzRyRkY3ZEZQZ1puenpZbFRLcG5U?=
 =?utf-8?B?OWNzT2N2Vm9GT2pZcnlMT1FDMjZDeDZFS2dxRW1uVEx0bkRSWHV0ZUZlWStV?=
 =?utf-8?B?TzZEWmVpTEdJSEdFMi9tcEYwOHNaZG15eUh1cU9RalZWeGQ4YWNvdFJ1MHh5?=
 =?utf-8?B?ZFAwY080UjhuMzl4Z2VPcG1QZU1kZ3gzS3VzSHovdEcxVU96TkZYOXJWM2JT?=
 =?utf-8?B?dERaZytxdzhXSjhMaU9tZnd5U243SmF3RUt2WldRZFR4U29rYkVqSXgxQzI5?=
 =?utf-8?B?dGMySDhCQ3VsckhpbVJWMXFJWm9ZcEpBRXR6L2hmU0hTN1FsUTNiSVVzSXln?=
 =?utf-8?B?S2h2UTJhdjVWUmtydURyaEZ1clQwY3lSMk8zWnVMVHRIWmFWRmRtL21NdW1i?=
 =?utf-8?B?TU12QVBGd25kUGFGamdGZWp6cTN1ODZ1TU53bURMVmhacDM2ekVWZnJlMzU3?=
 =?utf-8?B?T0phVWhNYWhaZjVqbzFCUXFtVDdoNW5PeHA5NmYzKzYxbGd4V3FBRU5wR3o0?=
 =?utf-8?B?TVNNWHFBcytZOHFDVUQ0dlBCUmZ0Z2ZaaVFURjdJb2RGWGQwRDJ4WWR2NC9D?=
 =?utf-8?B?UHhZT3ljTE9VSGVNeDl6N01TaEx4Z1dSaUs3cm9YdWZNVVlzNzd6OEVTL0lD?=
 =?utf-8?B?alFzQzRYS3BhNUZBTWFjbWtDUzJibWl2SHFlK3NOLytNNmVUajhnZSs0Mkc5?=
 =?utf-8?B?VHcyalpsYjRJeDdhRjcwRzBpeUliTUg3TmVTRjA3bFpYb0Q3VlRCQWgxYmZj?=
 =?utf-8?B?YlNMVVZmd21KbTRyVTdxL3lZd3NSQnprc2xmT3dOdXp5dkJMTWhrZmRZUUVG?=
 =?utf-8?B?WGF6c3RrOXVCL3pmOGIvZmtqN0dpOHlBN2VaRXp1TmxXb1VNM3VvdEU2akpR?=
 =?utf-8?B?Z1V4d2ZyWFpZMDNCK2cvakxNRExOMEdSWDB5YjV3THdIMVNnZXg5eDhIRFFo?=
 =?utf-8?B?dS9lUnp6WTlOVDRON1puOTVzTVQyY1pxYUkxSkNyanpadFVEWEVvaXpRMnFx?=
 =?utf-8?B?SFZxVmIzSnU1TG9qaFFUVEZwVHU0YmxaaDNNMDIxelFxa1BkUnA4Q0lNSEp0?=
 =?utf-8?B?SUx4aFlEdUxCeVRqaThuejVlOGtIL296TG9QbEJNeEF3TW12akpGMVlVRENk?=
 =?utf-8?B?Q0hhOWV3Mlo5azlyWjEwa0tjVURNa3I0Y2hVUVkxaU0yTXV4L1BWR1Fma25P?=
 =?utf-8?B?cFh6K3RCWGx6TU52S3RhemNvcjhXVlh6eU1TY2Y3VFN3ZVRiTnF4NngzYTRz?=
 =?utf-8?Q?fjYuN11HSzwyfyhDz/jKCGIjlN5F9NJ0fdaDCXT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7266fa86-52f5-4e0f-a9f4-08d8d435da09
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 17:51:43.1268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahvo+6cm5C96jODT/eIj+dhsFyAWDUb59GaYrl/hvnvaK9Lv3EYi9eq0eErOR+lBRovxRQKX/C56xArOrhgX6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4356
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180148
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/21 9:40 AM, Zi Yan wrote:
> On 18 Feb 2021, at 12:32, Jason Gunthorpe wrote:
> 
>> On Thu, Feb 18, 2021 at 12:27:58PM -0500, Zi Yan wrote:
>>> On 18 Feb 2021, at 12:25, Jason Gunthorpe wrote:
>>>
>>>> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>>>>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>>>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>>>>>> page structs are not guaranteed to be contiguous for gigantic pages.  The
>>>>>>
>>>>>> June 2014.  That's a long lurk time for a bug.  I wonder if some later
>>>>>> commit revealed it.
>>>>>
>>>>> I would suggest that gigantic pages have not seen much use.  Certainly
>>>>> performance with Intel CPUs on benchmarks that I've been involved with
>>>>> showed lower performance with 1GB pages than with 2MB pages until quite
>>>>> recently.
>>>>
>>>> I suggested in another thread that maybe it is time to consider
>>>> dropping this "feature"
>>>
>>> You mean dropping gigantic page support in hugetlb?
>>
>> No, I mean dropping support for arches that want to do:
>>
>>    tail_page != head_page + tail_page_nr
>>
>> because they can't allocate the required page array either virtually
>> or physically contiguously.
>>
>> It seems like quite a burden on the core mm for a very niche, and
>> maybe even non-existant, case.
>>
>> It was originally done for PPC, can these PPC systems use VMEMMAP now?
>>
>>>> The cost to fix GUP to be compatible with this will hurt normal
>>>> GUP performance - and again, that nobody has hit this bug in GUP
>>>> further suggests the feature isn't used..
>>>
>>> A easy fix might be to make gigantic hugetlb page depends on
>>> CONFIG_SPARSEMEM_VMEMMAP, which guarantee all struct pages are contiguous.
>>
>> Yes, exactly.
> 
> I actually have a question on CONFIG_SPARSEMEM_VMEMMAP. Can we assume
> PFN_A - PFN_B == struct_page_A - struct_page_B, meaning all struct pages
> are ordered based on physical addresses? I just wonder for two PFN ranges,
> e.g., [0 - 128MB], [128MB - 256MB], if it is possible to first online
> [128MB - 256MB] then [0 - 128MB] and the struct pages of [128MB - 256MB]
> are in front of [0 - 128MB] in the vmemmap due to online ordering.

I have not looked at the code which does the onlining and vmemmap setup.
But, these definitions make me believe it is true:

#elif defined(CONFIG_SPARSEMEM_VMEMMAP)

/* memmap is virtually contiguous.  */
#define __pfn_to_page(pfn)      (vmemmap + (pfn))
#define __page_to_pfn(page)     (unsigned long)((page) - vmemmap)

-- 
Mike Kravetz
