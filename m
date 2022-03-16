Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452EF4DBAAF
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 23:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiCPWdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 18:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiCPWdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 18:33:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1272E116E;
        Wed, 16 Mar 2022 15:32:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GLECkD018264;
        Wed, 16 Mar 2022 22:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iPCbY0rerZZEhbE+sEDwVtL2JUH4x3cvW8tE7t+ADjI=;
 b=sGy6sb22Rfi9agtplvDwH0B3Tqtt7BhCizX/Q1WeNX6NCYrVhv/3G/meamAvtdvcyM7o
 pyGhNE/4L5FkoxJkdxDLulrgqBSr7tnyb2ZbBMkHDysRkoBUgYmUUcjhr9rdpnV/fAP/
 pxy/9MLewPcLC3R+EF2KMMNGNxuoaq4L9QWpJ3SyOHs0Q3vLsdmaDhyO1pIvhEJqvaok
 HoZSCqX/XVTTAEzqh8+RZEONig72ACOCgNq7hrtRhmqLXsE5GhTQpnqWFJths4yfAqX4
 4Y1qrl/Yd9uQbXiPYy9IQj68cyT+QKWh657ZkAxwnF88Zw7gziYZoan9Ktfh/TafaY+9 dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rqq9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 22:32:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GMVCdn055486;
        Wed, 16 Mar 2022 22:32:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 3et65q142u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 22:32:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9KcdrMpofFpqt6pcafe2pIIVC96dGmwh36TtshmEPbgxtlll2V7WK51BK8//XjKxeBLBM+Shxz8R7rZiKRqV/gV4fEF9ESYsIEBWXdOBH8i382ucKo80/FAtNVj6r63YivBPtkUdQ4S9fp/F8rVX5XRUnbW16bVXoRFapsQOLyP0FzqjYt3KhNMju7aYLM0hPho+q49PoH6iDH9J+S7tT8fVexRjHGETyw2+OYk+nXVskEKUjZbLYmXl2Ns5z/eZuMEyL6tKGWefHBCfToj5d16M4MZAeuH9vnnghiDnJtIq/IQDNNy5m8cvNj1GlYYoPQhOmypRFvOP913JIQwWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPCbY0rerZZEhbE+sEDwVtL2JUH4x3cvW8tE7t+ADjI=;
 b=SsickPbKTldMh1AXojBiqafTfexPs9w2IF5vLV8kZYaIkmXvLfOM4JBBzmrcSGvOp7Tk3b9YtdsPeZMNLyubbBADIPWv1XyPBqKe2wsHc+Z4z+ZZI9q7wwnkCCd8I77iEDfsIUpy5JIBkqctCS/TPEsjIOHEt/oqe5tiF0fVFlOAA8EjKnJlmxWniyHTK4RCZXctgh5g1mtg1UG7WxhkOrQ27r3TMsi6QfE+b7c9wop+NiDkWPZjYTsH3nc4ZmRkam8k9UKGi4f1NXhaLf/tXLklfKVdN4tbvFTUwL8ByXlnB1UzVU93s/N8pSlw9tAj9Ki8bTPX68suM9+MCdYqZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPCbY0rerZZEhbE+sEDwVtL2JUH4x3cvW8tE7t+ADjI=;
 b=E1hcEuIgnWCzeXMoTq83Kp49GdqpNAbeOLmbjiGDbyEpSzhX2f10RqQ/B35fYinIaFBerCVgL7GyUEU+s6YFC5eehaSn3jLhziNW3VQmbaBdxqz1uqUt5vPXvDdbD3Vw0ZH5cgMuKpJfv1rsw+ZS3wksm8B5GTdui27xyT3Sdsk=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3174.namprd10.prod.outlook.com (2603:10b6:a03:159::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 22:32:01 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::51f1:9cb7:a497:f0f7]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::51f1:9cb7:a497:f0f7%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 22:32:00 +0000
Message-ID: <8b40c33f-1bdf-2cda-5948-cf433302514e@oracle.com>
Date:   Wed, 16 Mar 2022 15:31:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] hugetlb: do not demote poisoned hugetlb pages
Content-Language: en-US
To:     Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     HORIGUCHI NAOYA <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220307215707.50916-1-mike.kravetz@oracle.com>
 <6ba788b3-901e-d740-2575-bc652461187b@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <6ba788b3-901e-d740-2575-bc652461187b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:300:39::12) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3511fa28-5bb7-4886-7267-08da079cc9b9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3174:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3174F57B59883BB75C1D9D97E2119@BYAPR10MB3174.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47GLT/xD465a+vUcy3wci5+QouS1WNyVX/3ShWqNm9Zlv5K3PzqojqNeD4jPpcQ0G36UR/nr1VxmBjpvxFyUgACcKTM4DZMcQx38ntTBd/IjruZCg8pwxoPv5oTB5UW/oXbHuwGoXCsrm8y14Z8K1VRXw+QHh0+hpYiX2z/8XeoGw0uoS3Xjkz6CyZNE2D9bliAQJEzb4Hk4Y7DPB5EVByTk+gAT6oOn7vQ+iWNb9IEk4/oXkoHwGcHB1EYWi5OUPdIuT2sZeVg5jE9qpNV9x7pOgWZdIYeRPz/F5ueMwATNqgJAJbLrnuKV8Gbnuf5i/B98WcXH+P2OApdSkPQ1CBbMGvewX3EXgqGnh41exVw8oet7ToZDRCCsO8u9e6mQNhC78zXnCp02l6QK7x7yLsntW7mBSMpTV8pg/ZRG6DhBgU1BuGTw9x2Jfi3bxoB2giHMA+kELVaI4Jr4Q8mQYDh/ZSgB3GBX0qkfIWo4apc36jtj3dhuU/BG93pVY5mr01+hbK2POUZLsn+IhWCIv3bRKHfjZ6el9U/dK7KDmBtNm0BJWANv3N7odPXOmz+1V3kvjAD7kaRG1nx3v3geqFMVUM3XTnyBrSOMGJXCSEPA9dQIYZH2UODB1511g1PFxbULnQZ1b01EF1bPOW1wacEcushFkBQuxQaOYSmU2Lev2oARfZN4oAQNowtUXFxLFaHkZJioBLuz85U0ZtT1XOs7e0c9QVwwWX64/2k91CnfVvInw0/7ayfEVHmGMFh8Y+DhP2KcbCUxEbij5B21Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6486002)(36756003)(4326008)(66946007)(66476007)(66556008)(53546011)(6666004)(508600001)(8676002)(52116002)(6506007)(31686004)(2906002)(31696002)(8936002)(5660300002)(44832011)(2616005)(54906003)(316002)(83380400001)(26005)(38100700002)(38350700002)(186003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDZDbFFtek9NVFZjVm5WbHlLWVg5Vk13aHFIenVvelFhcFZXM284RSsxdnJx?=
 =?utf-8?B?SHRzUEx0Q2hDT3E2dzk4SnIrYjJiUHJ3UXV6dGlsaXFQRTVxYmRTZGs2SkZW?=
 =?utf-8?B?ZjVwdDIrdEczL3VwQVpNZjhkdlY5czFVSFE2WmhxYmtrUmRwd2JPWDNYOWha?=
 =?utf-8?B?M1lHVm9mWWFGYUNUU0VCeUlkOUlpYktPeHg2U3AvajZTRlVVZG1tdGhZWXJB?=
 =?utf-8?B?WjN6UUltOHJaQ0llcWx5N09uNUY5SWNGS1Z1NXc3T2pyN3kyZzIwTHFWN0xR?=
 =?utf-8?B?STdnWFBoYk50a0pOT2hyajJWTWNtaHp5K3RBZnpRd3Q0NUdaL0JjNlNGdkxC?=
 =?utf-8?B?WkxtM0oyVmlLRnlZaUp4QVFsTXRibGE0SDIzdlFJVjIzYUppMURDc3FsT0RV?=
 =?utf-8?B?TENQSUZWc0FVN3BiR2tMOFNXNk5LYlBCTk5KT0tRVCtHL3p4UEVsck1mU0RP?=
 =?utf-8?B?cnF6N1dKTDU3ci9MSUg1WFc2a0hCdExPdG9RZmFzamtSWGEzVTIrV0xuZGpO?=
 =?utf-8?B?dHRISEpsQ2k1YzZHTVc0clBhRjY5d1hrcEJ5Y3NkNjBHRUloY3BkRGEyem8y?=
 =?utf-8?B?Z3A2NGM1V1VLR3pzTEpKK25wQmtUblhzNUVwREMydlJNNlZjdlp3NHh4VS9F?=
 =?utf-8?B?SEJYOGhQV2tLcDM4dXgrVUF3eHo3ZWlSMEhiWFJpYnJUdS82QTVKYXc1alpS?=
 =?utf-8?B?cm9CU21oa1Vxc2w4bFY4NnM1bUExdWNYSFVpM2RoTnc5VUFHbEh5Q00zMVR0?=
 =?utf-8?B?cis2L0hsUFZZRkVHT0JjTTdmOUpPaytsb3FUTXJzOEs1ajRJNEhWc0JxZXls?=
 =?utf-8?B?d1N2Yk9rL2pPL1ZXVzZlOUVVMm11bXY4bEI0MkU1YTdQZEZGWWNTV3lYU0tC?=
 =?utf-8?B?d1AyQ0kyVGpzQVIyMUlDS05hWGZLZ2VVdE9DYjFXSmhMQW5HZjdkUkxUM21Q?=
 =?utf-8?B?QjIvTkI3dE9ENkxFWTl6a0pTV3ZaWlcyU09XcGZPRXRIbW8rV3ZDdGRIZjVq?=
 =?utf-8?B?MmRHQkNBaDEzc2psT2pxNUZjb0wyaVVHd3VUc3ZDUUdRTXJiY2dna3puZU1G?=
 =?utf-8?B?Uk5rNlF5NWNRbzBqNmJoSlBrbFk3UWdldlBhdzlnWFhuYmpwZExWMzdKZmpS?=
 =?utf-8?B?WXpheWxZcExaTVlrYmJXZUVrMEN4TDdzd3lWZjdObDZQNmJja2lRZWVuaDFF?=
 =?utf-8?B?WmZXSTQxT212TkgxOWJrY3pqQllBTVlXRXFRZDRFU24vWis1Nk9jZ2lHd3Mz?=
 =?utf-8?B?ZWY5dllkUmxLZ2RQUnk1KzdDN08xZllBWDl6MEE4c3gzN3RNQ1lRWEdwbGk3?=
 =?utf-8?B?WVNWQ3NqTEgxNGhWRS9PK1B2RDdhT2FhNmNGN3dqakZRWVpZcTFJRHBZRnQr?=
 =?utf-8?B?NWtoNE5BVTExSEZKaUdkbG80UXVlWm4xOElGV3R5d2hlL0lyMkp5RWlYVHZN?=
 =?utf-8?B?YURCc2ZoT1VWZ2VKb2dNelpzS0pIb0FnL3NOYXRlUXVveVFvcXRjWTV3YzVV?=
 =?utf-8?B?bFVwaVNxZ3VES0t0WXpDVDJqaS9jVjlXbjZaL2ZJVWZoN0Y1eEVweStac3pm?=
 =?utf-8?B?bWMwbTU0SjcwdkxPVWhZTzhEc1hqR1dlMU1LZzE4SUQzVm0vUlIvNUZoSU5U?=
 =?utf-8?B?UjFBcnA5RE9QYUpKekYzd3cvZXVYcldhS1EvWDY0QnZXc3RjSU5EeFp0cnMy?=
 =?utf-8?B?QzZuczVnZnFlMDQ4ZFhOWnVsVEtCRG9zK29MR1p4NmY2RmpqS1ZJNnFNdHRD?=
 =?utf-8?B?NEh1eGFsLzBnSUQxRTQ0Ti85VDZlOWIwL0l1QUZUZG5ueWdxd0duVFliNTZR?=
 =?utf-8?B?MGN3RWVVWFEwQ1JpbG1yaUxNKzhaQTY1SDZzREtudDRidlBvcEhibS9Manhi?=
 =?utf-8?B?Mjl6MW5IQnFzc1FicTRKaGpqVVdtRTRsVUxyOVZIZkpEY0pybTI0V0V6cElu?=
 =?utf-8?B?MldPSXIwcUZ0RHJCZERERW5XRFF0NFRkL2VGd3pLUVJJMW9rNmJCcDJGdXU4?=
 =?utf-8?B?K2o0VGZIRzhnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3511fa28-5bb7-4886-7267-08da079cc9b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 22:32:00.9370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxcociEXFMogjPGYJO/KeYJelaUgSjhuu65j2ytKASosBbg9gXUCVPLKU2oLbTD0EMbpKTBrTSRcXbGAp+mUiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3174
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160135
X-Proofpoint-ORIG-GUID: RpM4V14dKh1KpHPix8gHp--Imzy7UsUz
X-Proofpoint-GUID: RpM4V14dKh1KpHPix8gHp--Imzy7UsUz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/22 05:43, Miaohe Lin wrote:
> On 2022/3/8 5:57, Mike Kravetz wrote:
>> It is possible for poisoned hugetlb pages to reside on the free lists.
>> The huge page allocation routines which dequeue entries from the free
>> lists make a point of avoiding poisoned pages.  There is no such check
>> and avoidance in the demote code path.
>>
>> If a hugetlb page on the is on a free list, poison will only be set in
>> the head page rather then the page with the actual error.  If such a
>> page is demoted, then the poison flag may follow the wrong page.  A page
>> without error could have poison set, and a page with poison could not
>> have the flag set.
>>
>> Check for poison before attempting to demote a hugetlb page.  Also,
>> return -EBUSY to the caller if only poisoned pages are on the free list.
>>
>> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
>> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/hugetlb.c | 17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index b34f50156f7e..f8ca7cca3c1a 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3475,7 +3475,6 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
>>  {
>>  	int nr_nodes, node;
>>  	struct page *page;
>> -	int rc = 0;
>>  
>>  	lockdep_assert_held(&hugetlb_lock);
>>  
>> @@ -3486,15 +3485,19 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
>>  	}
>>  
>>  	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
>> -		if (!list_empty(&h->hugepage_freelists[node])) {
>> -			page = list_entry(h->hugepage_freelists[node].next,
>> -					struct page, lru);
>> -			rc = demote_free_huge_page(h, page);
>> -			break;
>> +		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
>> +			if (PageHWPoison(page))
>> +				continue;
>> +
>> +			return demote_free_huge_page(h, page);
> 
> It seems this patch is not ideal. Memory failure can hit the hugetlb page anytime without
> holding the hugetlb_lock. So the page might become HWPoison just after the check. But this
> patch should have handled the common case. Many thanks for your work. :)
> 

Correct, this patch handles the common case of not demoting a hugetlb
page if HWPoison is set.  This is similar to code in the dequeue path
used when allocating a huge page for allocation use.

As you point out, work still needs to be done to better coordinate
memory failure with demote as well as huge page freeing.  As you know
Naoya is working on this now.  It is unclear if that work will be limited
to memory error handling code, or if greater coordination with hugetlb
code will be required.

Unless you have objections, I believe this patch should move forward and
be backported to stable trees.  If we determine that more coordination
between memory error and hugetlb code is needed, that can be added later. 
-- 
Mike Kravetz
