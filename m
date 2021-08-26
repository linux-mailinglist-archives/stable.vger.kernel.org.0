Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53723F8BAD
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbhHZQUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 12:20:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10724 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233834AbhHZQUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 12:20:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QExlwn004829;
        Thu, 26 Aug 2021 16:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lT8rsPieq4rKG+cH3nXXUD+brYrzfrxq+D1F6Vt2rQ4=;
 b=rNb4muahLICbaZPHbtv202OFuuKUNXbcj00C+FII/YnJ7BNpzaHyPt6Q2gCPluEIpSck
 rNJNm4j6AF0WxqMndUVIuHquJlhxJilcne4mT4m+rHikek6Sx4xVJY7U3X2ex04ep8GD
 sPl2dAR+ZAh1AVK3dOHMbmWf80A56PgiZgOh5OIuyklt+nodeMMH/V/FS6TQH54HfF93
 S3Yf1XV/KwgoELKbP3+T4MH0FRY6ObacuWIZ7+kRMieRv+2HNr5xrCTJtlNMLXHBStz9
 ncFiom51uhBQx7mLPtz9oeopd1Wi0gKzWXrXl75jhMiu+zwDTuhpCjTfmBi1UVVo2G1X nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lT8rsPieq4rKG+cH3nXXUD+brYrzfrxq+D1F6Vt2rQ4=;
 b=y7aqzA4Xnx/+q6ETyuTe79WqeBen8w/FAI+mz1BFSXlSQ+32e0eldlMajwAFbIddQN9a
 CDeIXFaO7tU6jWvomQZynnYJfh27ixAAXTp1smNntsF4+NuZDN6bKrT3smE8ZB529DXk
 FrOnsEDqo+QCLYy0YSS5d8pxc300deVNEbOkv418QKxuzqBqa1d7cMsxqFU/k6oGx5GH
 xWp92Xl/41vzu53miy7D6vCHAcVCMZKYOFeMcIrNGpa/lkeJnnruwQGqxM8YTcgaEjVh
 ynimBH/E54+FnmQ9Nco0LP0pAlvWdYv7ppwns1b+fxvwhgzP0cRoHFN6Bf1P0ZY/mb9R 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ap3easkkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 16:19:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17QGFlAQ147264;
        Thu, 26 Aug 2021 16:19:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3ajqhjv5bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 16:19:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXwMwRMjpYxCMAae+dqeO40Rp7+xRSksZn16WRUPYw0tl5ldL/KVPy2oAKobMy27niKPj/JxyHUSIXLIq4DMNJJcYcmK+dJotvMDpjtAp/UZVc19lDK3ANQovERze5p58zngeRBpao06kehCddPNb47S8xb/CYXiWwZ6tTpUl3UzJdwFvGN+/E1VAKKVn+18FkEnqsBSgaFT650qu0TyHVxyCLsVFhYWcupScGGV9B3FzLfxGpilg9itR/POnV2YXDvg4nUfXXlIE3Qjly82D0TQSiv0Qb1XemuFQNKsNoN5oHHvfTx0diIdRvjfpgNHfKdA+HxnbSbyP1TmoOZpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT8rsPieq4rKG+cH3nXXUD+brYrzfrxq+D1F6Vt2rQ4=;
 b=UKlRi3tBG2YuCBevzarAlDuo/WSw7PKo3eeXtpqxDTrwq3UBNIk9vFhx4TTGNkI+0aDY6zpKldvEJtnRcMugqrFGpuqujhIkksA16qXl72yzOtPyRBaA5TEojjoW978AyAA2UKRRodYKy0FYOZ9/gxxtb++LCH2oocR8KPZnwb7UllNV/pAgiAaQ8uTwU0fOgByx1/TARn6aUnWchRubdxCmFv8Nu/Mf02UKG+O1Ywzsy3Evvoray6cQmDNyKcqqk2WurEtZBbopl23oOhghQ1xb3ZVheKamVEfGQUo2AFpwa/mxWEPSNdq96knScy6vASUPcNrD4ze8S25skSeiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT8rsPieq4rKG+cH3nXXUD+brYrzfrxq+D1F6Vt2rQ4=;
 b=rIRGFTLwVSrkdcOfDnreY05leUXfoHJPPLUZWnajooRF/il5yNG9qNdAW5ki7BCBA4I/vH55IdCeKkZqwQRXAY9HcdTHfg4RE8V+iTDMFOEu/I8d05xTaLDJcm9AVzUeQG4ZnqHh6AaM2UvfGsopFqvozkje8Wj1McnzxurPESo=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4113.namprd10.prod.outlook.com (2603:10b6:a03:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Thu, 26 Aug
 2021 16:19:17 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%7]) with mapi id 15.20.4415.023; Thu, 26 Aug 2021
 16:19:17 +0000
Subject: Re: [PATCH v2] mm/hugetlb: initialize hugetlb_usage in mm_init
To:     Liu Zixian <liuzixian4@huawei.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     naoya.horiguchi@nec.com, stable@vger.kernel.org, wuxu.wu@huawei.com
References: <20210826071742.877-1-liuzixian4@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <80f1b2e4-9aa3-931a-7470-fd129639ea7b@oracle.com>
Date:   Thu, 26 Aug 2021 09:19:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210826071742.877-1-liuzixian4@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:300:4b::16) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.123] (50.38.35.18) by MWHPR02CA0006.namprd02.prod.outlook.com (2603:10b6:300:4b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 16:19:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3fd8b52-5890-4efc-d341-08d968ad4039
X-MS-TrafficTypeDiagnostic: BY5PR10MB4113:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4113567A43135FFF0E462C31E2C79@BY5PR10MB4113.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M7gMttmmyec9WlawEXveaJb6ElQkqUX5abSa4PQ5lTIu/iY1VRuOaWCSuHoZYr1uC1XseSjiGsAe025hNy5YhL4H5oCIWlFnrggJXN51iMpIWkpmeTFpVDrDZbM6vGGUG8kn7hM+WNP2xEwWOse5O9F7SnSBE25cfPXSHezptaJErHlMkvkcCbFcJ55wnf4u9IUUILaid1hn4lPKtWuEJWyIhlTqiXhpKhYOS3rW9CdfmPggoQ/SK/DFI6ru88CUHM5HFfM6/G/g+dF/+XXnJ60chOBgBphPuAtuZou88g3+LCE4OQR/jk+eGjkRJZhz3ebdXlPnAtVCm+E15CtlEdy5UVhg6+5lpMJDUwrG7BfASrD2KHfXg4/yB/zIoJzFya8NBnNvpJv4o0d+Iiu/VPzy0SEhn2ygJ8zszY1ErnmXiAHXtl56jNwGmz1/dzwKqTn8iLsjtI9d6ZBZdzuD0QESUJyG4CRK9F0djkDT7EMNI1KO6OmkLr/kVNLNaWqmEM1fBgvrdcLWke1jcgUB3tEcF+b12oJTYq4/UrUlJ9QygOteHUPKzcYSjIEdvX2ReBUPjBWxyE7841SRbyQZgIG2pKP+JD+BlOLHKVBWFCIGjjw2FYe/61A0bm1hQucNYjqEyxnwTF76n6szKW4Ao1u9DzuIwTF9DiJxjl6VAYxgJkb1N0BEahImzy+wisNPugBUOG0dpz2f6GcCRbVLYBL2DmLiOQHGJpZrH9MY/lqGcCm8XESgcdH/aMHZAjYj5faLUO5TfOQEHtxuY2afQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(136003)(366004)(4326008)(86362001)(5660300002)(26005)(956004)(31696002)(8936002)(6486002)(38100700002)(38350700002)(186003)(44832011)(16576012)(31686004)(316002)(2906002)(36756003)(66946007)(66476007)(478600001)(66556008)(52116002)(2616005)(8676002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MklydFZ4QWNtTHZiSlNibDd6UmU1S1VqdDBKZ3l4NzJuQVRIMm84YW1pMTJs?=
 =?utf-8?B?RkJDU0Uwdlc3NXhiT2gzZWI4bWcvSTkzVWVKcHVEMmZVcFRIR3NtaXpuTUxw?=
 =?utf-8?B?d3BoQ2hCZjgycGU3MVIxVkQ2RmMybEJEMGg2MjRDcjA2NWVieXJWY0hIOERC?=
 =?utf-8?B?bW1sbTVtQjREdXl1WG5lZzlFdzFjWWFpSXBINmVheDdjUk96MDc1SWUxc0Yz?=
 =?utf-8?B?WWZoM3BXZkM1dnVzelVraDZDVGtmVzQrTEdEYzJVNENCa1BZam9GUk5MVEJl?=
 =?utf-8?B?TTZETXk3Nk9Oa1l5ZjBIZ21rN3dDQ2w2dGtmV3Rxc1RjQ3NiV1cwczNRMkxX?=
 =?utf-8?B?Y2xDTThLaVQybDN1d0orcmhWVVlhTm5IUnJhcmdJQVNaT3BleDFaU0M3cmZI?=
 =?utf-8?B?WlR6YlJTTGN1S3R6V094eGtUSSsyZzMwODV1Qm5EeFRGbGw2NW01K0gwempo?=
 =?utf-8?B?VEFjT29nQnVlaU9BVWwzazJIVk1pZHN2VlRMUXZhU2lzVjF3WE1oL2FCVGFo?=
 =?utf-8?B?Z05QbmlQWHZtTGZrL0F1ZkcwaDArV3hrS0xITUdyV0F5dnAvOFNHcG5Ia2dZ?=
 =?utf-8?B?ay95OFY1NC9XL2x1eXpEczh3MEpGd1BGVlhmOTQ0Q2plZHhRcy93VndQUHhn?=
 =?utf-8?B?QXZoSDB4MXZFM3VYZWJZcXg1NFNoYzA0VExRMmQ5RWJ2bEdQcWFqNG53QWVw?=
 =?utf-8?B?SjE5VkJhbG1keEcyNWk1TEdKd0l4QW5EUEZVbWR1Z3R5SDZkL2xKM29zVVNE?=
 =?utf-8?B?OUg1bjJFNXdHUFJ3K2g1eVpMMGRkV3kzaCswNjZHSFAyZjJRQ2dJcW5oL3Fw?=
 =?utf-8?B?ZGFYbDdncmQrMVBISUM2a3VFdDYyUjkwdHlDMnVqOHUyUkptNlJxb041TU1v?=
 =?utf-8?B?SlFHb0JEODBQMjZFWTBzMGVRTlF3bWNvanFzUVY5ck1oYXp1R0M5SG5rdndi?=
 =?utf-8?B?dGRXMHI0ZHVXQmVGNzlmM1BseXRwUXhJS24xQndqM25VNCt2cUNEODNYUzA0?=
 =?utf-8?B?aDRINTkzSFQvV2xOM3RKNVVpS1ZLaGZpNGdYNGc1UHdMSnpZczIvNjJha1NT?=
 =?utf-8?B?dUN4aHd3eXU4UUtKTDMxWHJKUXdKVU1LSzF6S0VqUnhVZDZ6MW9rQkp6OGVF?=
 =?utf-8?B?QWU1Y1VEbDYvTHRWb1VnK000TVNkYWpWY1Zqa3hTdFIxNk03N1NvaHFaL2pN?=
 =?utf-8?B?QnEyby8wMnhiNjNiUUZQWGJ0NTRGQTVtQWg0TDJHMVM3UFlPdlVWWmdZYk8y?=
 =?utf-8?B?bis3VFB4RElCQ3J2Yzl1aXljVHkvWnJTaVFtMW53Rm1BV0ZRNHhWam9SWC9D?=
 =?utf-8?B?VjB3SnhrSVZidnN1c0dZY3RHZE03Ym5TanZhS0hRVmNCVUNYS3FjbVNvbmVy?=
 =?utf-8?B?K2l2aUJiZmtYV1hoN0sxbzhJaUZvc3BMUXlQT01sNW5WaU1WeFYyaDE1TEhF?=
 =?utf-8?B?ajd4Zm9xOUVwcFQyMElZRGI2RTNMT29JcjE5L3ZabVNWUVJxczhjUXVnYjFR?=
 =?utf-8?B?d0tuUHlqZXN1R1M5Qks3MlMzMklmRElYMmY3dFBuSFZDc2Q5QmpMRmFla2tE?=
 =?utf-8?B?QkQrcDZiTkttUlRXMThXMGlDY3ZaQnBmL0lRL2M1clVoemwweGUyREh5MzI0?=
 =?utf-8?B?ajJqY3ZER3ovVkxoS1l2dnhpdWh6cFBiU25KYUcxNlVDQUF0elBrVjdhYnR5?=
 =?utf-8?B?LzgzVHpmRVRZSk94SjVhZHVIUXdyVWxlY3ZqWEd0dG5lTEg3WVNqU1UrT29t?=
 =?utf-8?Q?Gfy/YPOHw7A5tSa+kcfiIoHYym+wvOREno5KdPo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fd8b52-5890-4efc-d341-08d968ad4039
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 16:19:17.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPNCnv48At2ldwHDlEbyuIu/yevv0Md2EykU1LEAc5hlLXXt1xOHXQE9vgBYimHyjK6e18+YMwg1pzLgWWxmkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4113
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260090
X-Proofpoint-ORIG-GUID: 8ahNxWiecAWcUi7iBDYq42567Pk8kGzO
X-Proofpoint-GUID: 8ahNxWiecAWcUi7iBDYq42567Pk8kGzO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/21 12:17 AM, Liu Zixian wrote:
> After fork, the child process will get incorrect (2x) hugetlb_usage.
> If a process uses 5 2MB hugetlb pages in an anonymous mapping,
> 	HugetlbPages:	   10240 kB
> and then forks, the child will show,
> 	HugetlbPages:	   20480 kB
> The reason for double the amount is because hugetlb_usage will be
> copied from the parent and then increased when we copy page tables
> from parent to child. Child will have 2x actual usage.
> 
> Fix this by adding hugetlb_count_init in mm_init.
> 
> Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to
> /proc/PID/status")
> Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
> ---
> v2:
> 1. Create two hugetlb_count_init in hugetlb.h instead of using #ifdef
>   in fork.c
> 2. Add an example to clearify this issue.
> ---
>  include/linux/hugetlb.h | 9 +++++++++
>  kernel/fork.c           | 1 +
>  2 files changed, 10 insertions(+)

Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

Andrew, can you add a CC stable?
-- 
Mike Kravetz
