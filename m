Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0814167FA3C
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 19:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjA1Ski (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 13:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjA1Skg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 13:40:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6AC1CF4C;
        Sat, 28 Jan 2023 10:40:34 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30SDGipl021723;
        Sat, 28 Jan 2023 18:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=y/KrU6D9WJrbP6Ok8Mb3I7+CjNhei1gmT6JzIvLgZgM=;
 b=UAlxWmojHMURVm2+2b8qZ4rlszwSdiYovhdKTWMesUrcg7pv61Hu6o3lrW2EYVnRjNym
 mJugbXSoX3+wzXe1oJD4vJvt4OguEoWCodsWv+doa1sZi3pc3xe70yJnaLvmuSNaf4YA
 XCArMl4NdhaU7toC1dUOWK1eZI8UzGCMJSSFq74CNNSpi3PNeJVygiGPtkuI/+X1j6CU
 YfqeZiKIAxrf2jfRDQ3eqd7E0pZl4KzSLsY/PtPYb9DTLNC46YNNA/ugOESowd5BV/i2
 Aoog2BkBOfLYcfXa49UJKsXBeijayWle+cR7KN3Yw663nLug7wtt9maQuOWzxNUtk86P QA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvp10nvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 18:40:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30SFZIv2019136;
        Sat, 28 Jan 2023 18:40:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct52t6nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 18:40:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGD1gcIXYXZwoR+/Th+L0zCnL68MxABDe58M7LulYnVMqHrrP9Aa4pSPO7k8UuDehBA6AUCQ5JUYaITwYjTdxt756kYmi3L+eMpcCNRwhGZzOaXe1GmZSTxXL5j+MEpOWaj4rpAXRqgKVSWfAk1e9wLhBs5TfL0tGIOIzH9MAHu2wIPznqaLM5VX73afn/Is7+h0j/4PTtD2OVw2z/Pd3F7WPHoKQdCQzBMiRm0+NpUT5rsOwyn039L3smNr2FH70h0CaXsGDA/zOj6a3j7SxUVGiBmPA5J1RxR+CIkeQLQ3MrQxq4xw4RYZOpj9gKBN2DGGhs+NlkAXkS3upUt8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/KrU6D9WJrbP6Ok8Mb3I7+CjNhei1gmT6JzIvLgZgM=;
 b=TfWgcdVBCZdy84lRRIQBYoH9KJ6xO3Jjio4PERIWtUxmWG8JqFuA52CR1qJO67PTYV2orAIELePBKzvEQDOSQ9UbSiblh6WHzr/sA0+EsCNqhJmklghEPlPuv0D57SX7o/FfsRD0T7VwSMYNz1x+oMxZZNggYTgW/hpu+0B/od/t+S898ZA7auDV5pJRYd9vhXOqGh/ssA9D0p0eWhcoebAIecFtK62MwExkNot74uHbYBOAYAfyvBZWb3NWkVAombSarPOoRkKFTCUdXb/+c1AHFYbJYq9XkWZbRi9o1NmHhc3xpY+GSq8h9rdS412YE/S5kGBWBprc01y9LppAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/KrU6D9WJrbP6Ok8Mb3I7+CjNhei1gmT6JzIvLgZgM=;
 b=tcHPtuNgH9S8yfkJ8hPdY84R0EiDvgR5FC5beHayobxmD8xHP101sM/Xh4ztyPvciLeNl0UShjvuXbQKyug1hjuBnz4xQMv0qb58ic4C4xLXgnjO/dEdl7dWeyPmnxauwR/MEj+uHk92Evtp3g+S55eayiESug/51hszg8rXCDU=
Received: from DM8PR10MB5430.namprd10.prod.outlook.com (2603:10b6:8:24::10) by
 CY8PR10MB6755.namprd10.prod.outlook.com (2603:10b6:930:96::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17; Sat, 28 Jan 2023 18:40:21 +0000
Received: from DM8PR10MB5430.namprd10.prod.outlook.com
 ([fe80::e8ed:ea67:7866:af4c]) by DM8PR10MB5430.namprd10.prod.outlook.com
 ([fe80::e8ed:ea67:7866:af4c%3]) with mapi id 15.20.6002.024; Sat, 28 Jan 2023
 18:40:21 +0000
Message-ID: <1bb8de35-16ba-6c7c-0ef6-67a7226a0a2d@oracle.com>
Date:   Sat, 28 Jan 2023 19:40:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20230128000409.never.976-kees@kernel.org>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <20230128000409.never.976-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0150.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:377::9) To DM8PR10MB5430.namprd10.prod.outlook.com
 (2603:10b6:8:24::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5430:EE_|CY8PR10MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f5708b4-1ae1-4cc2-7832-08db015f1b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LL0ObsuuOF9aCZ6BSCaKCSj2g5wXHage0KL98AXj68Vl5c/hyfqDka/O1hPnm7AFGUZrM0ljmYrZPHFVLQsT02M+QDTIIaDc3jxaMdh7WQzp4AjYLn52V041vaes2TSg7ESKHI19HGUO+FD2KFnIBk/UukcaLXRH7T0uCY9RXxVswzMCLpRbny8NNnu4an/lpFfBUDPYAqBjx1+tU4baZ7HPaCMTtuR7A0ndCr/LJfN+HWaSByU/Qg2gmCBRDxTJgW/LJWyQFEz6OKtDJ2pV6ccMpZ1Pm16cdbFNlw8neRHqT2ylHOcoNlGZ1Fb5g+vgnOrVPtk/UcgPf0V5Q7L6itStU5prbHx90mN5hSu1/MN620XG0sExQhdVWWkrG3zEdYIcOmn5VQaE9KR2OCkW9nLOToKiCWLfk7dAK5F4RXDMC/GV3eZ4poGODAPU3IfXKdRCB+3IwTUg+OvCdyWiL/u6t/4jy3RE0yLM/iSRF/ca7yKma2btxx/19n+oAbYC7jKmtD+GQ679av//Gl9wP/hQPXW2UwzvNM4UL874A5GQn4B9TtlyX841m55peTHDftB992LlKk6367pXgSkaIrnxJE3e87Y2BFaflIwyQe5DodBYGjG2uOTd9XKx+DqkVHUXrvnVAe9iCIlT4qqbNMnbQUU7lOCYrHzkW+MxpgJGaczFDA77kTDfhXVJpa+/S2kUXZ4kHFCqZqEc6VF4M5nJMTh9iSlURPU6cYg9s6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5430.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199018)(6486002)(478600001)(83380400001)(86362001)(31696002)(38100700002)(26005)(186003)(6512007)(36756003)(2616005)(6666004)(53546011)(6506007)(4326008)(8676002)(66476007)(66946007)(66556008)(54906003)(110136005)(5660300002)(316002)(8936002)(31686004)(41300700001)(44832011)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXhaL2tkMFFiLzhDOVp1ZDRHMko4aEFJalJjbUl0WTRndGl0TUhkTWtlZlRa?=
 =?utf-8?B?VDlsSFFiQjhPMmNZOWUyZFNvcDhIVmsyV0lkT2kxd1p2SVM2THNKb2lRdkVr?=
 =?utf-8?B?cUlGTmQ0L1ZmSEpGS1IxU2paZklybDRCRmFIcWdPZXhJSlZWVnVZR08zd3ZQ?=
 =?utf-8?B?QWxBclBsakFCU24xT2VOTHhCN2xCVG9KcVBWV1VFSktVdm5ua3drTUFqeGxS?=
 =?utf-8?B?bm9icEMrR3VnWnJIc3FoeDR4S25aZU1TWHRwZ3d0ZWNsVlhsOWN3aEYwbU9w?=
 =?utf-8?B?UFUwdHd3aTdZakdLNkVpeWhBWUJqbjA0am9uNmc3S3M0dTJMaEZ1YWRVSStZ?=
 =?utf-8?B?OUZGTXlwRlp1b3RsMHdadkZNWVR5cFByN1Z5eStaU3pmQjBlZHJYZ2dUNWth?=
 =?utf-8?B?QUZ1QzNYbjhXWG9NcEZJV2FiVnQyL2JaSXBCUGNtNTRBOCtVN0d3OG1pdWFr?=
 =?utf-8?B?VGlqZ0RqOE9Rbys4MnNTZDlBeWNHZm9jRUxFcFZJQmxHRk9GSUpiRE1IQmpz?=
 =?utf-8?B?dnRDMnJMMkxTYW9jZGRNWGRoN1JSazJWZ2JoUkhuMldaSXBHbWpqcGtoUzVD?=
 =?utf-8?B?enlGeXJQZUt0czBCUEZleHdzV0cxMGxrT1U1clNWK2tqcFAwNGt0cXhjYTRi?=
 =?utf-8?B?NXNQaEJNZ0VkSkV1VWFLaWJyQU1KYmZEYmJjUmN1V25vTVBtdkNNM0dyajlZ?=
 =?utf-8?B?dXZnOFVZRHkrZVRuZ1MxRW9mQk9lVEZnSldSVGx5ZTl5ZmQ3c1dIUlBQeVVB?=
 =?utf-8?B?YkZML1J5UlVhY1JwUWhzdUZhNW1KS2FrUmJiU3E3UUZ6VjloOS9HNjU5WUhV?=
 =?utf-8?B?ajl6OFhkZzQ4WTNaVU9ac1QzOTZybWg1LzFpaFVrd01zUFZ1MkIzZWVhd0Nu?=
 =?utf-8?B?bWtOY0J5dm9KcUM4WHpkcXE3RStDTWgxZzlYMUp4TUpEd0k5Wm5aL0t1YUFM?=
 =?utf-8?B?aWtJbTJnRW1WWldkMWNJVnM3OFB3QUNYdldmRmJWV29pa200U1ZZeWlmWUFM?=
 =?utf-8?B?UXBQWmZiTlhSWW1McU1DWVJUNGpuZDRTM3ErTitKVEVBQ042WnN5TEFmNy9m?=
 =?utf-8?B?RVgwSGJHOFcvMExUMmJUV2RraEtNQWMxSjV4aUZrWVdTd2xEeEdwU3lZYW9X?=
 =?utf-8?B?aDc2dzl5N280aW9lMmgwYWpienAvbWxTb2I1dXYzZmZLdHRvNHVjd0dXelg5?=
 =?utf-8?B?TFFoNGJtVHNzSmtYUGI4YmRNNldBL2cxNEVoNFFZTGJzV0ZDenVmVmZlOVpS?=
 =?utf-8?B?dE53M242cFdRMFB6QzNuTUpWTUZUQnVsSk15RXBNK3hyNzQxUS83WFNBWFgw?=
 =?utf-8?B?ckp5SDNnUU4vd3VnS05aMWU0Rkc5VXh1TUV1S3UyVGVrQkhEVWRZL2ZjeUVB?=
 =?utf-8?B?QzU1cnRYOEpDSTAyZldVWVVtMmw5UklpQ1R4VTZQZ21iajB3Z2xtOVcycTRG?=
 =?utf-8?B?Z1JGMXgvZEpzTnRzNzlYZDNiTUdhekNRc0R6ejJuazBiaUF0WGlONklnNFFi?=
 =?utf-8?B?Ym1kcm0ycmJtQ1gyc3M4QktmbXF0R2R3NVFFbFZqY0d5Y29TcUhQS0hHS2lz?=
 =?utf-8?B?OUlWaEFzVEQ5WVU3QjZaTERPOWV5MVJYOFlHTUhKUFBkeFBxZFRtT3ZlY2pl?=
 =?utf-8?B?U25peVo4UUlPNzZNR3JyY2hFMFV6NEpTNjl5aXQwYUd3UlRZZVBLQisvU2hX?=
 =?utf-8?B?T2o2WGZkbXhQNmsydXRlVVNqM1ozOXVIRWNnWnZ5bW4wNDZ3TklnbmNpbDNa?=
 =?utf-8?B?L1o4THF5YXd0eTFNOHRRQU8vYU84YURjTE1GTm4xeHRTd20wOWhSd0ZINm1p?=
 =?utf-8?B?dCtzSGdDeXhrSERPcnhudFZ3dGkxY2tKcWEvWjh0ekp1elpsRHNvVVBEL2cw?=
 =?utf-8?B?c1pQaXJWdmNmVGV4UTk2ZVh5RDN3ZGMyZGhLUGxxMGF4L0dHdVA0WUZJamxl?=
 =?utf-8?B?czAxbjRMQ2k0QXlYK1BmTUdOczVPWUEraFREOWlpeWdmN1VLOEJEVG4wanZY?=
 =?utf-8?B?Z09MMFNxNE45UzE3Q3cyc1JaanUyRDFkOGg1dFRxWGVFOGl5Tk9CU0lIQzRa?=
 =?utf-8?B?V0dIV0RYMTh6ZmFMdW81UHUxSjB0eDlKNFNGVFMxN09KN3FKRSswMlRjVXNI?=
 =?utf-8?B?Q2xaT1pmdXNHaXgxNWNCQ0JycVZrVmtXWExrSDNpU1lNU2VCUjB3ODNyaVRQ?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FMN9ZBeNaEqmq/Gi+Lo2qmp+Xm29OiXaMgVa1tpavCRMlp9THQDyBnywrAEWEI7tT1TMlHzi1MaS7ssoeQcLbvmWnHRt70vAbgSZTlSJWFnZWDZvlEWRJq43xY9HOIBXr5jo/htt6SXTW5kpzc8SZbgEYslgQB79gFPG488BAkKlAkKcuUfHLfONgrcTWhdVpldw4IPnMaVhbSpQHiBLaWF+dARGtMSPVJwTG/Qd/de+5OsAInzrurHd3j+tyS0m4XMKyAxg4JuJs+aTO16JF/CHopAAT4p2WCdW36Aq5jP5kaKcJ5ulPrIdaUIrKRbi+lQR6E3Usom+pyBYwnxSsxw6+e/n/r/hs6gG1ha/RQhAUviW6mnyqf6Pr8ddkTlD2ycVUzYfFnWm6+Ig1LJVHIsoc/7Jks+Fbh/l6C4W87/CI0g80NPMWEGqv8vb3obL5haVWRSNfXdhUQURF8UIcC4N8Y3A4JPqwqU6298G3TTy3IfGRxmWUtyAmNGRN/hzJcfCzAREFIZp1+59skfe6D38f7iB5ywkZdUuwBSZtgVmghl8ADGtZcvGyMME5LY2LddtVXR2Aa0gxmXyX5Oa8qf4TFF9RLYkqCnc+ykcgNQEfLiscxWS5/L3VVTnt6WYoXmE/k6Uu5CEV3Dz4KVMT7Dbb/C3pxN5mpmqi0EmZIvysHYCGEsKq2ibeduEBgW/YD+0RpgQGGbh1A6hGnFQ37Dka9wfb+wrlrECOgj2YvhzovNAkKTyaAjVNEccB7G/7mvMoD4AA3sX5qz3XwqxoKZgRuISmXCw1mTU1nQd/CYdr9GJJvRv3wmqyM5yeKlkIOIncooJY+eHnx9saXnVTg9ZASF26gPb5cuJGqpj3clnL5NbQmCsppZRUQUGPZfcD804xYdYbctzHj96aeRq8MVAI0N/Y5eeKvQrTCpa4+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5708b4-1ae1-4cc2-7832-08db015f1b39
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5430.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 18:40:21.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UD12OMYtaIb8MECK5pnzCbbP5U8XzxohTyLAZyFEBJSQOrqRXGGygrihi3Tgf56meo2k2rFELgYuBpUMGXEinPknEgpWGcUfq11KjuXoDh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_10,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280182
X-Proofpoint-GUID: VX7_d-zKEthmJhO9z7gOJ7HSKmfdOZvO
X-Proofpoint-ORIG-GUID: VX7_d-zKEthmJhO9z7gOJ7HSKmfdOZvO
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just a couple of observations.

On 1/28/23 01:04, Kees Cook wrote:
> The aac_priv() helper assumes that the private cmd area immediately
> follows struct scsi_cmnd. Allocate this space as part of scsicmd,
> else there is a risk of heap overflow. Seen with GCC 13:
> 
> ../drivers/scsi/aacraid/aachba.c: In function 'aac_probe_container':
> ../drivers/scsi/aacraid/aachba.c:841:26: warning: array subscript 16 is outside array bounds of 'void[392]' [-Warray-bounds=]

An object of size 392 would get allocated with size 512 (at least by
SLUB, AFAICT), so the risk of something going terribly wrong is probably
fairly small. Not that it shouldn't be fixed, of course...

KASAN should have caught this too, right? Does this mean nobody's tried
this driver with KASAN, or is this some kind of rare code path? (Just
asking for my own understanding.)

>   int aac_probe_container(struct aac_dev *dev, int cid)
>   {
> -	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
> -	struct aac_cmd_priv *cmd_priv = aac_priv(scsicmd);
> +	struct aac_cmd_priv *cmd_priv;
> +	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd) + sizeof(*cmd_priv), GFP_KERNEL);
>   	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
>   	int status;
>   
> @@ -838,6 +838,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>   		while (scsicmd->device == scsidev)
>   			schedule();
>   	kfree(scsidev);
> +	cmd_priv = aac_priv(scsicmd);
>   	status = cmd_priv->status;
>   	kfree(scsicmd);
>   	return status;

aac_priv() uses scsi_cmd_priv() which has the comment:

/*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
  */

This is set for this driver:

static struct scsi_host_template aac_driver_template = {
[...]
    .cmd_size                       = sizeof(struct aac_cmd_priv),

I looked around to see if there was some kind of "allocate cmd" helper,
but couldn't find it -- scsi_ioctl_reset() allocates one (together with
struct request) and there are a few uses of ->cmd_size in
drivers/scsi/scsi_lib.c but there doesn't seem to be a common code path
for this.

I guess you could use dev->host->hostt->cmd_size or something, but that
doesn't seem worth it since this is driver specific and we already know
what the correct value should be.

FWIW:

Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>


Vegard
