Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515C4454EB2
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhKQUr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:47:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62174 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhKQUr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:47:27 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHKfGVI031342;
        Wed, 17 Nov 2021 20:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+mcNhwfyAw92esT3fGPCuWi1AjFFGq95c/Z0MtEtAPE=;
 b=0evAcA4B5+NY8LibvhgDi+/YMd9JoEAHDbkoQ3UGD2pNIO+71l7gkITYN3W/iqr2Zhmy
 x16yrX7tgnLlReJctXEztTlE0SVlkvBAM5OiZCvIpb4D/K6e9e+h300WdBs7t24eah9i
 TBbFE24tsoZzzuN7q4cEhVYgnnHSR64WZbLnIj/lzFo3x/K0I5vZ2zmVE6vy1R8asIV+
 Al6lczkls8ak/jyGWUJGDLDabT4NBVPc9a/js6xCXEZyrGbr2sV71UMeVqWHEwCd53Lz
 xnAWz3lahejyh+QJftxqKO1oODSQafphtIu/QMvsfgCRrmt0wEAgyFQ6aOtEpx5hhJ5C 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyht58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 20:44:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHKf6Wm101990;
        Wed, 17 Nov 2021 20:44:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 3caq4uuqx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 20:44:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qi1hND2DYgZnDkpn+Y9yU2ToAliKaNbxVQ4quyA85aeA/P12kadooBqly33QPioITTa0IbF5hpXGmHrcQTYHBCLkrA1s8TpcbHSh7PKZ7xiB84DswmMO1Z/J4FY8c8voTKDZovn4vlEpX8Tgy/SpWw56IJ78lL1biNSTMUEThc2LSWmbv5cJl4AtC47vM4cH1wtpsku0Gh6e7+WaBBYU8FMMxa08jvv9Ou5+JNBavzjQv9B52SnBeEOQrPsQxejvnI0SYNK2b0EAkJXdbIakLws1C3hD0NVdXedjq/4WyCir/MLY/MDFS19geKNDWj2BNASYmh/4afUgM+lWVhMsJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mcNhwfyAw92esT3fGPCuWi1AjFFGq95c/Z0MtEtAPE=;
 b=LArn11k+cdsd0j0gbtJThWgbzA2Geku+Taf5dGlVM8jivgbPAinifLIhqSzJqmnKycPCP/t4eJVZl293xmt/Qkb7FL9Nc6fGpfrJYcotDy49+oAsPPs6Cb2EtgpH/HRU5IcuVNIGg8J8TAn6Mrf+5MNOGfulzfjy00RK9lh9zfA5MOwoPXYjBVQoNz/fzRS3NQsmDrSoG+GJwDC7QDjkmT8vo3GPKdAkEXGa2632zT5i60PezDumnbyLO3GDagh5BdJTNx/N8ytIg9t5FjBMLzhtOKV/ixG/rmC2McitiZtDpFSg/rxlIJaTG+93+HK7U28UXtMm6VXipxkuF8LAcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mcNhwfyAw92esT3fGPCuWi1AjFFGq95c/Z0MtEtAPE=;
 b=zwqrcVXrL1hynZ1cdPFd3Lpd5UbIrf9MkjTIO7Rl8AFpP/Wazq2/LGocdBEiuINYhOMfzUEOFHsJ+5dS9KxEolU8h5oQR81rFLynIGyPSvj6+SiE/iuwdw+aIHewSqJ9VKc8+4Wrob1WW+OJ/OepXXzGbENBr4N96U7+usKhvr8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3687.namprd10.prod.outlook.com (2603:10b6:a03:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 20:44:15 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::b5bc:c29f:1c2d:afd7]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::b5bc:c29f:1c2d:afd7%9]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 20:44:15 +0000
Message-ID: <a51f7e4c-674d-a282-e3dd-c03a199ef5d6@oracle.com>
Date:   Wed, 17 Nov 2021 12:44:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] hugetlb, userfaultfd: Fix reservation restore on
 userfaultfd error
Content-Language: en-US
To:     Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Wei Xu <weixugc@google.com>, stable@vger.kernel.org,
        James Houghton <jthoughton@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20211117193825.378528-1-almasrymina@google.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20211117193825.378528-1-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:303:b7::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
Received: from [192.168.1.107] (50.38.35.18) by MW4PR03CA0099.namprd03.prod.outlook.com (2603:10b6:303:b7::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 20:44:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3e8204f-dae8-48e6-808e-08d9aa0b0488
X-MS-TrafficTypeDiagnostic: BYAPR10MB3687:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3687C3283725F71D130F02B2E29A9@BYAPR10MB3687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0QL4TQ+aiG2Epsya/EvJar4Kr7pUFLAvRs1qqXNhU7x4rKpNlhJ1dTnHatyYbwFNPy9bS58IVwMiHebeN3WvUmhJhseH8waPBdT4uIKAl/UtE2iNuZgDyOxT/3m5ly+JRkZOm6lJU9TZ8lO//YsqmLqbfeuwoF2u1kiCB8x6tLSBMDyGV8tQ2q+t/e3ISHrShXrUyzRHvZM+wAg1KANkITWr1/LFIOng9IDXuU1kQLvkr43yba+zgSAfeKDrV5YGwkrLNUsykn5CLB5CWUynfy2lvI93/6BqNsXRNVMEpwDHjx0w92b0eUAs/m4zNjt8PuCdlVv+4KvOPYgOSqqBvITPKTxPObV6cap/G7z5GDKpweNXSRLj94Y700Eh3ykt+bXy7o19MxNhIxE6UDvW7bomTFJhRfjSw3i3WIGYtKfbQu0ThErpJPU6W31WB25qruvM7KMOkzf/E8jeHep0Za/LA+k66UZR7uefesqiroqNDMzDW1Kc7W2VcbFE9kRRsfNS/aN2Oir0JOaqFIyZ6Q4gD2RqYcLkkwGwhi4KM4wnEPoAJiRxzAq3KIryVD09KWzyD5J6KvLlgbelo08/26Y7yOu970FVgXAslGhFNYMI7HyDmH0QXRYoTyC3/kKWeeF5uYj52Mzo4lGdhjqXaBI7wN9vZW0e0OAYZfPaoS53pg7U2DgMMX1BokKIyWdT5Pp7iHiMnmPedtPZj0sFzCWxcl1kBN1WHfCJkXXPlt8ClRaDkuI4aDNyxTXY5xQJtM2sR5VY/hZcS5EEeCOLaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(52116002)(31696002)(2906002)(44832011)(5660300002)(508600001)(38350700002)(66946007)(8936002)(4326008)(66556008)(110136005)(2616005)(38100700002)(66476007)(54906003)(316002)(956004)(16576012)(26005)(53546011)(8676002)(31686004)(186003)(86362001)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckluVFFGQTBhRStRRUdLbWszbnlyUVBkNU9IUW5XUmwzcm1QWjl0R1l1bzRG?=
 =?utf-8?B?WGRaVEZpZUo5bzZMVm50VVk2a2wxZ1hnSnlLK1lwN1FieFdDc2tmc0pjdWQz?=
 =?utf-8?B?VGhzZHAwZXN5ZW5oV1hXQk9RUVFVbUhrNUZxb05CQTBEWW16RFJnNExxME5M?=
 =?utf-8?B?MWtTOS94aTNWUVNwVE1Xd1F3eTlsRlVKcGJUVmdOL041b2pvbkVRdks1N0hn?=
 =?utf-8?B?NlZaWmptYlVQRDdDQjNkbXpzK0o2QmhHZU41VVh6Ykt3cjNrTDJwejBsUit1?=
 =?utf-8?B?K3ByeE5Hd01QbHNzZklPZGFFcW9zZkVNSGplLzRQMVRSWWtjaGhURExDeE5s?=
 =?utf-8?B?VTkybVNEQXZMRkRYQVcyeUJVTHVLeUhub0VzdjVxMVI2UUs0Mmkrc2VLYWtL?=
 =?utf-8?B?akEvZlhKUUZrZDRMMS9sSkJ5Y2tEeW9VOTllelJjbWkvVDhKOTN3TXE1djNa?=
 =?utf-8?B?cXdKZnE4RmJSOHc4djZIRXpWd2gza2dGNFZjcElFMTYxKzc0VHh1a2hGcUds?=
 =?utf-8?B?Y1dUamtHQzhvSlk3QU1tWXJMRi9ZaTNSbEh0ZU1CTFV2bjh1MmhoT3RMcWs5?=
 =?utf-8?B?cHM3V2o3TDN4bnlVODMxMDZEb21IOG9zL255Q0h2eXU0c2FZcTQ0VWdGWGZV?=
 =?utf-8?B?STRhbCs4WDRVNEt3bWMzbnZGOUxKcFIwM3RIRjFERmVzNmlzOHhscFZrclF5?=
 =?utf-8?B?VFpWdVF1OEhKV2ZuRUVIVVRIVVh6YmdWV2owSURwaCtqczFNVHlmeGZYNi8x?=
 =?utf-8?B?dEcxNEhWTEQwMlZUejZMR1hQaTVaK1prazIxUkoyWThXdXFhdzl4RFc5UUg2?=
 =?utf-8?B?RU1nbDd5UHpIVkFMc0ZRVm9rSlppMEVoakRTOTd3bmd6UUIrajRTd2lnZnEy?=
 =?utf-8?B?Um14K1BScVdPMHhDSU5RY3ZwVzhZanJjSjRReU9uc3d1YnBZSlYvQ1FuYXh6?=
 =?utf-8?B?bldFa2NIMFpuRmFkVGhscmF3NDVoaURNV2xFeFVxRWNhUTdCL2ozV05PaWJI?=
 =?utf-8?B?MERubGFldm5TNGxzcElEbTJLcmF0aDcyYkhzdERrUEdOMUhNblR5VGVkZ01a?=
 =?utf-8?B?RUFwUlVmSVZtVTVYVGVudzhXQjA4K29XMURuSC9oNHBtc010bmViTjFvT3Nh?=
 =?utf-8?B?TjlIdEZjcHJYZzdGWGxpQzM5dVhaWGFraDAxVnpjREdVWkVUa3VMZTlXVHlM?=
 =?utf-8?B?azQrRjZMMU1hK1Rqd2tKOVdCRkxMWW9VOTNPVTJUSjRaQ00yZE40Q2FwMzlR?=
 =?utf-8?B?MU44MUpEUy9lNEJaS2ZqcTV2Z3FIU2xYb2ZvQ1JHNGFma2dLeVJFcitNR3lS?=
 =?utf-8?B?VlpLWWNSWnlwSnRoRC92bktRcktEaXljQWZ6WkpZNHRMMlpwYyt3MmVyOThN?=
 =?utf-8?B?aG1USXZxa0JXOWtkd0E1SVEyaTJhM0JQVmlXSnZvcWNRajFUcWFhakx2VjZ2?=
 =?utf-8?B?Nnl4aFp0U3d1cmVjWFNaTEJvOHNjeUZZMlg3UmNMV2h2SXh4ZG40VnRTTDU2?=
 =?utf-8?B?SG5JUTF5R2FsaWw1Mi9EaElWZXdrOWo4bnBDU2ZKczgvSnk1Qjg1V0tHQ3RT?=
 =?utf-8?B?dnE1WFpXR1JWYWlYSnhZcktVYWZMci9OVi9kU0F3VUpVeHpDRFdhemxkSTRQ?=
 =?utf-8?B?MThuRVVaU0pkc3NWMlF4aU1oMDBST2QwaUlBSnQ3RFZsNk9jQk5SUC9Kcndn?=
 =?utf-8?B?TmNkbFg0L1JWa0Fzbk4wNVJ3clo1dDRjaVZRRFRtdElUVUpDR3dDZnBWUkc1?=
 =?utf-8?B?SDdQdldNTE1ZT2VZWkMzK0RBUE9NSncrUEd6a0FRZFZKOFE1VkFNSE9QbCtO?=
 =?utf-8?B?UTNCUWtYR2dkL0c0Sm44UXF3TTVxZ1BJSkNnMUpsUjJWZ2t5bGZ0anh0bVN1?=
 =?utf-8?B?bHAvVUlyOCs1UzZnSllNSXZNUUEwN2dSbHVyMXAyRVdZOWQvVjZ3Mk5yMzNx?=
 =?utf-8?B?blJrc3R4RXRqQlRSaUx5ODcwQ05CMWRvMEZjZFRGNy9SdG1EbW1yVE1Lamwr?=
 =?utf-8?B?ejZVRkcwVllMZFJGYjhUU1dRUndhTzRiTFYrek1nNkdVQ1ZmcHp1QzBIQy9W?=
 =?utf-8?B?SXBya2NiNkw1elc1eTF0a3ZUdnBwQTJobUtxQWRIQzA3ckNyQkkyVUhqdHl1?=
 =?utf-8?B?cjdpUUg1cUhvV0d1S2RXTXZVRUpzZEFQODZuQitiWGVOUnVXRG5iNE95TWFN?=
 =?utf-8?Q?2Zmicto0pqLna1M4oynRefM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e8204f-dae8-48e6-808e-08d9aa0b0488
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 20:44:15.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6Jt9zCX5rMrmLfPFkTGHgPn+VFBgyxloRaxqfKcqN6mTXO2g3vP/0LCfXbmbnRDKS2vNE7KNf3lDMrSY6VmEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3687
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=984 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170092
X-Proofpoint-ORIG-GUID: Dho3TGoFLn89HpYgEsNCIoUH3acVWvX3
X-Proofpoint-GUID: Dho3TGoFLn89HpYgEsNCIoUH3acVWvX3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 11:38, Mina Almasry wrote:
> Currently in the is_continue case in hugetlb_mcopy_atomic_pte(), if we
> bail out using "goto out_release_unlock;" in the cases where idx >=
> size, or !huge_pte_none(), the code will detect that new_pagecache_page
> == false, and so call restore_reserve_on_error().
> In this case I see restore_reserve_on_error() delete the reservation,
> and the following call to remove_inode_hugepages() will increment
> h->resv_hugepages causing a 100% reproducible leak.
> 
> We should treat the is_continue case similar to adding a page into the
> pagecache and set new_pagecache_page to true, to indicate that there is
> no reservation to restore on the error path, and we need not call
> restore_reserve_on_error().  Rename new_pagecache_page to
> page_in_pagecache to make that clear.
> 
> Cc: Wei Xu <weixugc@google.com>
> 
> Cc: stable@vger.kernel.org
> 
> Fixes: c7b1850dfb41 ("hugetlb: don't pass page cache pages to restore_reserve_on_error")
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Reported-by: James Houghton <jthoughton@google.com>
> 
> 
> ---
> 
> Changes in v2:
> - Renamed new_pagecache_page to page_in_pagecache
> - Removed unnecessary comment after the name update.
> - Cc: stable

Thanks for making the changes!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
