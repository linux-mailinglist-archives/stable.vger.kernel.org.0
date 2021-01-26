Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78F304A52
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbhAZFIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:08:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34272 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbhAZEc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 23:32:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q4TAtg047271;
        Tue, 26 Jan 2021 04:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=R3KFzdL6KoE7Pm2F5C6SiXaiVhhr+fzJhKGVpnPIP2w=;
 b=uKbu6VY4DGrzzvhAkXJSIp71RgsLOyjJRXpt3m3i3twe0B+6jrrTReoviozExmkmxjuu
 6cQFF/8l0YiU+ZnUH1vSuNyTmq4KlBrjuIG3K4hM4uIB62l14IBj0Nqa7rnaIFLqDIZw
 S9XOueIAfVWl48fpylFI1E2KxKnc4iliBGw5VKBvxbvwNA2dwpoDZwuc2S0IzsoBoHMF
 Da8iM6sSo2nbqpXSWKVGIDUchH5OOew/Fr6O2eu7FPzc8QyPCAC6hSu3o19SxYJRbdg8
 7J7IZlzwpeKAMkUvVlu8YHLKcavaSF901qEjCfFnz/zV3GIEPi7dE1sWX924TpSOPZxn hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aagjdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 04:31:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10Q4P0Fc162369;
        Tue, 26 Jan 2021 04:31:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 368wcmfqxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jan 2021 04:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoqZPawIj059xvE+J4Np07ED0qM1zFzbsk0h1ESrVDDBvp4qRjQgvvuvgIgoJWnw7sKIJufSzGgyUKi7o1RguetqOnAJu4tlRGqC7SdsBp9ytYr2hKSVuCqOlByOVwXC9ZRRbytGMG/Kd0KCJwnbEkp4oTacKHukwIVKIJ9O8CZmneqyPur1YdiH7ITbeZEpPtE6EGyl9xew+GT+bTCFpPigmYjGwu1qDRNR5OwN6OLkBHdP5GhplzMxslTi9iR3JCwFK5VHBUMNPLKObZA5PzEhjOIhWMMAd54MXQiaErooIZSpJvQcAbPsxjZzRRs5jHUoVR2C7K5Ps+XAbSIxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3KFzdL6KoE7Pm2F5C6SiXaiVhhr+fzJhKGVpnPIP2w=;
 b=dVY/02f3iR7LyqwozxTMZ03gU5kfilMj3Lc5kcwgDJKHAzeW9RK8/HIxoQBf05876fMxURA8MVJ/ng6C5co6pYEGJq9meAeC69lCfOCyAiuEsW/VAH+XRtjCBNGPbvyDwDfS9F0GaAw5Rgn9ZzBpnx9LLcDcVz++uUhbh1B1mS2MN+dxkFcxluFCg2bpoqOxfwjqxZ7b+0orCaYkrstToik58GGJcy/20S8zvrmgPcu8/8j1I7CdmdLh6UG97R/BSD2BOY4xKcbNFXPQXX4lxyI1j9bI2ctSAHO4uRbOhhjoTgpmWC+WZQY+9c0C/jTKSEgdl+4jDRMMq52hiY+Y1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3KFzdL6KoE7Pm2F5C6SiXaiVhhr+fzJhKGVpnPIP2w=;
 b=MhxT1fu6uuFeQJ1YY4c2HcRh2jc5sEgVGr57+C7jbNYqbPkN8Uv8a66+bn+D2ugAlHMs8RyXTs1rnfhmHxLIOwpuzsCK9lyG0iw8LeyoMEqonemoi5i+KoIn/IazN6ZyQKNJvXkT2HpZ0e6MAQlI/PgiV/3EOAowhoJBJYYC2bU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1389.namprd10.prod.outlook.com (2603:10b6:300:21::22)
 by MWHPR10MB2046.namprd10.prod.outlook.com (2603:10b6:300:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Tue, 26 Jan
 2021 04:31:10 +0000
Received: from MWHPR10MB1389.namprd10.prod.outlook.com
 ([fe80::897d:a360:92db:3074]) by MWHPR10MB1389.namprd10.prod.outlook.com
 ([fe80::897d:a360:92db:3074%5]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 04:31:10 +0000
Subject: Re: [PATCH] mm: hugetlb: fix missing put_page in
 gather_surplus_pages()
To:     Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc:     sh_def@163.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210126031009.96266-1-songmuchun@bytedance.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <f0388d4e-c72a-947f-6f12-8ae52d588543@oracle.com>
Date:   Mon, 25 Jan 2021 20:31:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210126031009.96266-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0407.namprd03.prod.outlook.com
 (2603:10b6:303:115::22) To MWHPR10MB1389.namprd10.prod.outlook.com
 (2603:10b6:300:21::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR03CA0407.namprd03.prod.outlook.com (2603:10b6:303:115::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 04:31:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7662fd5a-fd32-4e38-a198-08d8c1b334d8
X-MS-TrafficTypeDiagnostic: MWHPR10MB2046:
X-Microsoft-Antispam-PRVS: <MWHPR10MB204656734D7D170E8192722EE2BC9@MWHPR10MB2046.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LABIc0r5Drl+WesiS9aaMZJ5xsefSsOh+igi/BjmVXZGOIdhJ7EC+DE90jkyaxP2BjDpoLxlwrTAqeLY+xgqtM0cQoTBTkLRnoynBXJB9StDrVRsxKUOQL7GJviWiKW9wa/PPuj8ovEgtKbKg6oeoh37hGaRPfIc8pq6JfwsrI2wNmQ11LcQhPVuXrQi0BBTWZBhBIraDfnsj/Tmrp2iEtkxzC4+ITl1ON8Vie3pMm+d9NHFMPCoZChzaH0jdufZfV+h3bnaa31GOHnl0x+cvKDe2s0EB6Q0yRP4eKPHgUsYns4E2ZKdxFL5p5Bp8Q6Yok4iPjSXRU2A2l7kf2tw58gLjcHkQN98wlxGolQLBk6VM6BIy1kODPsttZi2MHAzaRkmAjFsOKSkgk7adleoP8v9M1+JW5VbhD148dhcL3geNbIFLDSw/IPdH3KA47FEsuMBmc6H7aff+rBn0t+P7Cp08CVdj24y4NOrY0aJB3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(478600001)(2616005)(8676002)(53546011)(956004)(66946007)(4326008)(83380400001)(44832011)(26005)(316002)(31686004)(86362001)(66476007)(66556008)(6486002)(5660300002)(36756003)(186003)(2906002)(16526019)(8936002)(31696002)(16576012)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGdMQThHcVc4Ukd4UUVjL0RkbjJqNHR6Zm9WbDBlem9uZUkyc05lZDA4T01B?=
 =?utf-8?B?Q0lZekN4cnRBZHJIVlFYVXRuNUNnV0lBdDQ0dGcxOUtUYTR3OHZ2YWF2QVJh?=
 =?utf-8?B?N1JrcWVYdzVvb2FacHNGUFc1d25KRENFMWUrNmhQTXV1bXdTTEs3cWpxbU1p?=
 =?utf-8?B?cEozMU1CQWh1SjB1eEVmQjE5R21qTmo0cEErTTMvZ00wK3ozN2FZVUJ3VHlO?=
 =?utf-8?B?UFdVVk95Z1BlKzRXOUJ4REdjQzFWaVA3LzBrVjNWMVRWSVBWT0R6TXVhVnlT?=
 =?utf-8?B?VkM2U3M3UkVvWVdPYmhsemczc0duVWJQOUhmcGZoUmlQRnVoaG1UcWVKdlI1?=
 =?utf-8?B?dWQyS3E0TSthQ2FiQzNXejNJUEZQQitWRFV2a1ZQQThEcEI1aTBhVFU5SmdM?=
 =?utf-8?B?NVNGOXRKWUV5bDNLSVh2eVRFZUJpMnp2MHhVRWdKTEJkTXdWR2xtQTB5RU90?=
 =?utf-8?B?bzM3QlF0czJCS2h2WEViWi8rSGpTOEFsNWJzOWs5VEtQSk1NeE5yRjltYnQ4?=
 =?utf-8?B?czR1UzVUNFJ3bjhaYWhZZmhCTU5GSUZmTGZvcFdWRUpWNWZDOThUMTBjSnRP?=
 =?utf-8?B?NFVrTmdiZG1LaUdjOHRvUksxU3JheWJlZStzdTJwbExWWHhEL09iQmlpeHJ2?=
 =?utf-8?B?U3p0cSs3R0FtSnQ1OWpVaktzd1B6ZU9vbFlDU3JoaFhUSXVmOUo4OHlZdmZl?=
 =?utf-8?B?LzhIaXFLRUgzUG9XdG9CMWk1aWI5N2J0WlJRck13N1YrTDBCNm1pSk5ENGVF?=
 =?utf-8?B?SjBzL3Z5dmNmNnNaWnBwNW4rMWM0Y29BZDdHSFBNb2VZanllaDMxQW9qNVVk?=
 =?utf-8?B?UTR1QmtaQ3dYMzRiRnZzUVNwbkxFc3YwMXB6QTVyYkxsaVd0LzdtTVVkbUVi?=
 =?utf-8?B?T0hXU0w1SjN2WExWODhRQlpnNE5RWVBUWnpYOUVYTlQxeEFraldLL2FmdmxS?=
 =?utf-8?B?d0RoZW1PY2IxTHpUV2FxQTlUNWN0TzhBazB0UHA2cFQxMjRPdGJPTDZUTDRp?=
 =?utf-8?B?SDFycHVrdzJKRHpvUGNsb0FSUVRpazdpWUdRQ2J3UjhkSDlaRlZvZWxXZVZY?=
 =?utf-8?B?L2hwODdxbzJHSXJGSHV0VS9SSy9TWkVpKytVaURtaEVzR1ZBRzhnWDkwMHp0?=
 =?utf-8?B?NVZzOWNIOW81eGhRSUc1bVBoeDJkUFpSNFhKNmxlQTZmZmVkY0xmeWorQzBT?=
 =?utf-8?B?bTJiOG0xY3JxZ3ZlT2QxV2hMUjZZei8vaTRVQmlVM1JzTmhSc0l6ejhkTnVH?=
 =?utf-8?B?dmVhVzMxdGI3cUJUVXpmM0VXQkZKTU51eXJPQkI3MVBLUjZwL3NzbU9MdnBn?=
 =?utf-8?B?Q3lLSWZaY0wwbzQ4amxDMXVtNVBQV2NrOHFFMzJkVEJNTlhSamtmN0tHWXNu?=
 =?utf-8?B?QVNGYWtDaktLT1o5ekQ3dTNnNDRYclRNZFBLSDhqRzR6dmUwaWJzWGo1Mm12?=
 =?utf-8?Q?b0SaxLHu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7662fd5a-fd32-4e38-a198-08d8c1b334d8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 04:31:10.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJd0GKlYAWa9AtOkLzeYobbsHfURbva4DrCUfeTavfHmrOUhoRzrS5zglHSNtGcjTiAoAH3DrBdQTSLavZLcUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101260020
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/21 7:10 PM, Muchun Song wrote:
> The VM_BUG_ON_PAGE avoids the generation of any code, even if that
> expression has side-effects when !CONFIG_DEBUG_VM.
> 
> Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Thanks for finding and fixing this!  My bad for not noticing when the bug
was introduced.

> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a6bad1f686c5..082ed643020b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2047,13 +2047,16 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  
>  	/* Free the needed pages to the hugetlb pool */
>  	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> +		int zeroed;
> +
>  		if ((--needed) < 0)
>  			break;
>  		/*
>  		 * This page is now managed by the hugetlb allocator and has
>  		 * no users -- drop the buddy allocator's reference.
>  		 */
> -		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
> +		zeroed = put_page_testzero(page);
> +		VM_BUG_ON_PAGE(!zeroed, page);
>  		enqueue_huge_page(h, page);

I was wondering why this was not causing any problems.  We are putting the
hugetlb page on the free list with a count of 1.  There is no check in the
enqueue code.  When we dequeue the page, set_page_refcounted() is used to
set the count to 1 without looking at the current value.  And, all the other
VM_DEBUG macros are off so we mostly do not notice the bug.

Thanks again,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz

>  	}
>  free:
> 
