Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC284EF8DF
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbiDAR0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbiDAR0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 13:26:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDD4103BAF;
        Fri,  1 Apr 2022 10:24:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231FwYO6026800;
        Fri, 1 Apr 2022 17:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Kljto9Ou/wunm2AmLiMXWHnSQniklNSvuQdhcz63UnM=;
 b=vxyu6MliQ0cbnfKHDymsL0kvOZAaP8f1rkZqrEPqw7UUN8frC0J6n4MtKjFOUTz1qT1x
 lciduK4XRYLJWri5rbRXmi73tRgZO8mtIokXFar8+sH4e/lvEZPQOLtOKxjeS9dOxVDu
 5ZxelkkjXgQgfWOwz4cEF/CsYCd3e6R4NGlqgAm6mtjGIhR6X4UFeFkEX7Quz0ptlN4t
 guSs+lPxQh4Wp7qMegC3GGWtdWmpQtRzmB9mcnmjxetqe6+WzzzueQcLKvkhYQ+zBWxq
 0K85BtetLHZ+BzrtxsVuRr/95zWG3AGAPF1TQB1sHB7Lwm0I77FJf1Ak5CrWsIv0/YF0 0w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqbfb7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 17:23:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 231HAeHl016384;
        Fri, 1 Apr 2022 17:23:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s960b09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 17:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9uiStSjums2ZarRWGw9dnWpmYPkLNqCmRMChQLpjHcG24nyNODdxTaj+1AqcYS60DHV47UBrhdfJWNVCUkECuZU2080OfJivooaBn1rhuCd/tqA6ZWkpi0i1e7w7SCkLWMBu/eUGw/CL/l/zBLbZLTRf9odIHTBtXGOzUmZa7Lz7aVWL2F52I8Acq5KPTqGuTFD8aOQlO+9mhNcm1jzxbktu2Z98edjPpsrBvqot52OI7/wg/eC6jaAFFLmrdr7VkYb/GwkaiD/lGF88OraLfnLneeogIN0yB84o8ejmuAXedrImOfUwqMp65CZukiiUskEvJuFtrCP3IvzQ5/2JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kljto9Ou/wunm2AmLiMXWHnSQniklNSvuQdhcz63UnM=;
 b=TAdkoS6Bt5QHD0/9LFOSWEyKggK49NQLhZnQAkWuXaodT982i8VHZ3F5MZWwx4TzUrbc6JZWOvwlfz25WWIYao1yJTWbLh8O3qYXcwIGhiUL88u4cFDqW+1M66WhByTuJXEk7LvOInTDgyboBHckkuc65ayVhc/useByUt2z9E1zHncrpEwAOvXSy8YAJ/7Ms6+Y2TdWxGK4w+TsSHE/xFkgcN3sUJ8tIsGuWky7mgvmlm7WuTo6kahJhiPmCQppfMxyur8fjoCGZpwdL8TFT/xlYDL/JB4YwLhUxfIJ502yhaVcXkXNM5hOpok6mUZcM1JkLnKb8ixCP54phbclvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kljto9Ou/wunm2AmLiMXWHnSQniklNSvuQdhcz63UnM=;
 b=jbJ/0CwIxrNWdpguTK6XMjkSAADnhc9hagm7TmXu8ZjY8JaCn14C7Hs52dGmK2hDM5bMGxrXkBCruvsIjPEk173gmv4HmS3BhSzzj1CsSWyC2xxHprbUxmEOwDcPqW6/fABiwW/UkUMVM4fjz5FqM++3VfOHjYpeciLMRiUyETs=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BN8PR10MB3716.namprd10.prod.outlook.com (2603:10b6:408:b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Fri, 1 Apr
 2022 17:23:54 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::245f:e3b1:35fd:43c5]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::245f:e3b1:35fd:43c5%9]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 17:23:54 +0000
Message-ID: <508fd247-b809-27d7-6bc8-a08c4c73cbb5@oracle.com>
Date:   Fri, 1 Apr 2022 10:23:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] hugetlb: Fix hugepages_setup when deal with
 pernode
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Peng Liu <liupeng256@huawei.com>, akpm@linux-foundation.org,
        yaozhenguo1@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220401101232.2790280-1-liupeng256@huawei.com>
 <20220401101232.2790280-2-liupeng256@huawei.com>
 <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0261.namprd04.prod.outlook.com
 (2603:10b6:303:88::26) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9300db9c-f715-437d-ed44-08da1404657b
X-MS-TrafficTypeDiagnostic: BN8PR10MB3716:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB37161A18C796AD92EE389C32E2E09@BN8PR10MB3716.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oryRYpID1FptKP8xekxqts0glwQ2RIGDzl97UkcQlOh4ICzYaMkp35wVlYHBOends5QJEgO7hvNs+HKXxZnYD1lC8thupzvRZjKaljrzRIUn28I8rPprax6KdxE9Tj3aECIUGxefhxFzQfB+k/OZ8t+KKHyBK3NsMLtLJoCEN5kAT1SB34h0BtKbGL/eVEB3f4Fn7mFCb1dclIMpZKw93EXkpARIjFWqmq4qOzHSlpAsY7qO+qeBJ6wR38JBYD09eammGRTqV/N8+I171bsYQKNG95bs329nXUuPOKPrDXcckH0NQMbjCrBppFSlh0Cn47xuVUEUcPuxwGycEJ8oksDuFOyZUr1wNggVEqXz5vXymIQPXY3NzakIGi5GnZgJedS735+LeEzpStP1s0dIGQ00gs0G51FmSttPA10/wMKTJ7heXdHbYcc9AlTEdT1NfRObpU14P/o35TZDC0aNbdnuhox/Y3asmNJD82VfA4K9jpq8zOPIFNGExXziY8/j2Vyos5W+B83ms7D+2jKlPji8MLclI2pf31BYPgxp/P/4+8vzmLahW+Mu84pZ11I8ltOgFFtNjXCjNaDNo4ULrW8q+WaH9k/XaaaeUYyy5aIbfUILvJGBMzzW1bUz+0sZbmb9/WvZgvruRmfRpIFK6MyGw39E3dayrct/8OUM38udgwNDJ95B1JGT/Mp+vo1b+SUI+ICd7HPDlfMZ7Fz5lQOCPNePTHPWJmdaoBCeTCh5LA41swp9AVxZWR4i8Eaxs/w274B28MrV/Jk9IIf8KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(36756003)(6506007)(53546011)(186003)(52116002)(83380400001)(2616005)(31686004)(6666004)(6486002)(5660300002)(44832011)(31696002)(66556008)(8676002)(2906002)(38100700002)(8936002)(508600001)(316002)(38350700002)(66946007)(66476007)(86362001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yno3VEJmbFhqdW9vZFNDS1pmVVJ3aGsvN1Ayb3lodXZFdTk3dEllbkRHOEJL?=
 =?utf-8?B?aGpQRkRYQVhETDAyVDErN0NGa2ZmNHJtdXJBWStNVXpBa1ljSEh0Tm85ZWcv?=
 =?utf-8?B?TlJpenRtNy9WWGZScFh1Zm9DbUFTMTk5RENHdEFKSnlpU1MwcUZtZVdqc3dM?=
 =?utf-8?B?MDNDdWpkUXdLVCsyS2x1Z0lzRUg5NW5odkxTU3A4VDRrN3NQR3N4RHdBdTd4?=
 =?utf-8?B?TFY3NVZFZGJjSXVqdEVkQitWaXVDOVB5UVF6anhtR1VIR3l4R2ZJSWJxa1FJ?=
 =?utf-8?B?VFFDUFhrQXZxUlFkU281SVBWNHgxd1FFa1ZIRWZLaEpuUnpHZWxWWUtMWGxK?=
 =?utf-8?B?NlFzTFQ3Z2VkV2ZJTjJKNit1MklCZzlrcExJZzl1c2pEdUhicks0bDliY0k1?=
 =?utf-8?B?UDl2SHdacTR5bW53UkxyNVJ5Z1E3Uy9ZM1JVbkdsZUtqelRJVUxpVWdyeVBz?=
 =?utf-8?B?RWNCU2pUekpZb3BqdDNVKzhrUG9hWDVOZHVrYXdwZi94aHBBYnFKK2greHE5?=
 =?utf-8?B?S2RxRW8xTDcrTllOdUJ3bVNucEgxQVQyY0s5S0J3c3c1anpCcEo5R0s5THN2?=
 =?utf-8?B?Z2ZtOUg2VmFrQmVBKzNGOHZDSjFGTVRqdmNvN2hNOHk1UGMwaWUxdGVJNWpF?=
 =?utf-8?B?bGdtM3RJemwrdmp5SkF1KzBnZUVockhKcTl0ek9tazdVWGJzYVgvQzVzNThx?=
 =?utf-8?B?eUJxaUtkbmhYSWFlcHJaR3hpVmRqbzFtUWtUYWR0Sm12cEVVd2I1NVhwRVNh?=
 =?utf-8?B?SEtGN2xTVzVJb3VDeWhGTVRjQ0hrcks4YXR4NVFZWXBBeUZZWk4xZUx4T0JG?=
 =?utf-8?B?b0Q4S3ovZmFLM2lpZlRhMEsvc1BuUC93eUpsNFMrSGt5eVp5cUdmd2NRZnUr?=
 =?utf-8?B?R2V0clJnYkRrMjZ6SUh1V2RESUlWVnNLNHFlV3VCMnFGemRnaCtSRjdGZTZa?=
 =?utf-8?B?V2YrL3B6SzkvUzBVKys3TWNoS3dRUzNLVGJxY0RFMW9hUmZJRVN0dUtmZ1RC?=
 =?utf-8?B?L0JuU0p2YUxIM0FKQmNCZWEyakJpa1NLcTFhc1ptbTF6bTNydmdXQ0Qxbisv?=
 =?utf-8?B?ZnBwTG85N0NtTHFSUXJaMlBVcmVyWFM3UzVHNkdONnpRR0VNWjZuYUViZDFo?=
 =?utf-8?B?VjhYM2FLeWhTOUY3NzRrRUxleDBZVGMyNmRuN3U0R1ZNWVpvL3NwRVdueUJ0?=
 =?utf-8?B?Mkd2R3F1eHdpcE5EdkpaajBTaXM2UHVTaDladk4xbTh0QU02UWkxTmludEZJ?=
 =?utf-8?B?WjRrajBCT2hQN2NncnhVZkp5TmtEai9Iby84UytxeEtwVFpycENsTDM2NlJ0?=
 =?utf-8?B?YXBEQnZVM0VlaDVIUVZBdlhSWDExbjEvc3l5Y0E4ckRPTkV4ZDQwZWhDT053?=
 =?utf-8?B?WmJxTTNmaUU4R1lWTEpiWGNoSmoxN3EyT0x5eG5MejFPbjhhVTdMQi9UeUhq?=
 =?utf-8?B?RGJ5d1JSQmlvOU15Zmdhem83eU9JR1ljQ2VUZTJPblp4WVBMRWdNYkZnNmhp?=
 =?utf-8?B?WlJFVHZxNU5NUHlQL0wyenBKU2dYR2VtK2xiMEJnNDhKNTJqZEdZM21iSGla?=
 =?utf-8?B?T25wV3pSTk5jVEhqZGhlUEZ2czB1TXh3bUxpMVlnTEVlTjBMQlFwSUhRSE9Y?=
 =?utf-8?B?OWxjZHJHSzVsaWRCbENsMTZYNnA4VEV3WVNFL3BIV1RWaHZibXJZWkFYNkNK?=
 =?utf-8?B?R3hIOE0zd2pPWDNpVnpYV3NDS3MzQzIrUEZLd3ZyVUV3MTh6RXBFMjBwN2lq?=
 =?utf-8?B?RlNpcFUrTUdjNzFlNFdWUGcya0M5dlRyWTFWekdQeGlsVnNRTmxQTUY5WkNx?=
 =?utf-8?B?NEpkdzdnL1hvTWY3aHpMSGZNdk1LdDd4R3o4UEp3YkhaL0tRZzVJSWcydjdr?=
 =?utf-8?B?eWpvR3F4V2ovdjdRMWw2V0JWZUVPckNwRzJSTVZFb1Q5Sm1qQ1VkWlZQSTgw?=
 =?utf-8?B?aXdzdVJZdm5aNUJrSHpuU21jZkdQOE52SUxFMnRTS2tkWXBzZFJCN0JiMXQ5?=
 =?utf-8?B?TlJiSlByOVdyenl6cG8vWXZ0bXNGbit3V2w1ci9QVzh0bk15NXo0WVM3UEpT?=
 =?utf-8?B?VFlTbFh0RzNjY0JXUGt0NTJNRlhtb2hKWnlUcDFuaDBrdkVCMW1ucHB4Wmsv?=
 =?utf-8?B?RU9MYk8rVDg2STNkNWFwa1c5cERRc0MrbXEzbWU2TFlPUTZiSXhjdEk5UERl?=
 =?utf-8?B?RCs2OG9NRGRVMDRTR0hzcm5YVnh0TDIvc3dJYnpITUdVQnJYVmhCdDRVekJY?=
 =?utf-8?B?NWxLVWc3UHlZcERoOEpsdGlwZ3NHd2Y0YjJXczRZQ0NVUHdCTHVzUGJqQ1dx?=
 =?utf-8?B?RHpyM2wwdTBmc3pFRktPOFBlZ2c4bFkycjM1V3J3SExCT0lhK3M3YU5KQlE3?=
 =?utf-8?Q?nnpfbhm5T2IL99tU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9300db9c-f715-437d-ed44-08da1404657b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 17:23:54.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoghz7eS1V/fOFkQvKozlg4/LxEVuXfsNwkGskQjRTaVy2Y/plt6Opid9T8aucfq/9xJcWz/PHxVqExbgDoBlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3716
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-01_05:2022-03-30,2022-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010083
X-Proofpoint-GUID: SXQTF702LUQCqsSuuiX8ccF5kT6syCnU
X-Proofpoint-ORIG-GUID: SXQTF702LUQCqsSuuiX8ccF5kT6syCnU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/22 03:43, David Hildenbrand wrote:
> On 01.04.22 12:12, Peng Liu wrote:
>> Hugepages can be specified to pernode since "hugetlbfs: extend
>> the definition of hugepages parameter to support node allocation",
>> but the following problem is observed.
>>
>> Confusing behavior is observed when both 1G and 2M hugepage is set
>> after "numa=off".
>>  cmdline hugepage settings:
>>   hugepagesz=1G hugepages=0:3,1:3
>>   hugepagesz=2M hugepages=0:1024,1:1024
>>  results:
>>   HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
>>   HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages
>>
>> Furthermore, confusing behavior can be also observed when invalid
>> node behind valid node.
>>
>> To fix this, hugetlb_hstate_alloc_pages should be called even when
>> hugepages_setup going to invalid.
> 
> Shouldn't we bail out if someone requests node-specific allocations but
> we are not running with NUMA?

I thought about this as well, and could not come up with a good answer.
Certainly, nobody SHOULD specify both 'numa=off' and ask for node specific
allocations on the same command line.  I would have no problem bailing out
in such situations.  But, I think that would also require the hugetlb command
line processing to look for such situations.

One could also argue that if there is only a single node (not numa=off on
command line) and someone specifies node local allocations we should bail.

I was 'thinking' about a situation where we had multiple nodes and node
local allocations were 'hard coded' via grub or something.  Then, for some
reason one node fails to come up on a reboot.  Should we bail on all the
hugetlb allocations, or should we try to allocate on the still available
nodes?

When I went back and reread the reason for this change, I see that it is
primarily for 'some debugging and test cases'.

> 
> What's the result after your change?
> 
>>
>> Cc: <stable@vger.kernel.org>
> 
> I am not sure if this is really stable material.

Right now, we partially and inconsistently process node specific allocations
if there are missing nodes.  We allocate 'regular' hugetlb pages on existing
nodes.  But, we do not allocate gigantic hugetlb pages on existing nodes.

I believe this is worth fixing in stable.

Since the behavior for missing nodes was not really spelled out when node
specific allocations were introduced, I think an acceptable stable fix could
be to bail.

In any case, I think we need to do something.

> 
>> Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
>> Signed-off-by: Peng Liu <liupeng256@huawei.com>
> 

-- 
Mike Kravetz
