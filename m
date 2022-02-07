Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060D24AC7C9
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 18:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiBGRmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 12:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384405AbiBGRkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 12:40:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE79C0401D9;
        Mon,  7 Feb 2022 09:40:41 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217FZLAS020213;
        Mon, 7 Feb 2022 17:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NJxRHke/qyTl8W+YVEW0q2tvx5NXp9Qs8uL8SnGhFSQ=;
 b=CwzEKf/ZJ8BKv0inuYMRR/I4/QZrWRdhhg+TzswI44X1Pzamdd6W0rruXjHaoF9g+C0c
 FlMbQ5DJZabqLYoq1JUdmyA9YQ8s2cV2vezWmvG/X1dN10YSUbn7Pxl0imGvXW6Of6kx
 u8B7KIrmHhJXB+z65tsfKIXMWDsD/inVbPrXtUuPa5Kmif/89Kllrom2BqmO4ST/k4KI
 7b8lAvY/yFegLcScDOFJSCMG2lO93xEUUxL1syDgTpVGe1Hp8b77VmOWv/MweqCMmJPU
 wRvOQl0c8/meqK4/xB5uGvVf26et2PGwAf7ySQnVGsyWDf1RiTcDRs2QrrlkZkzeMiJj 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wrcat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 17:40:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 217Ha1oX108372;
        Mon, 7 Feb 2022 17:40:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3e1f9dqusr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 17:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnylckqN0A/Dq8t7x6r3C1yskZkWejEFz/cswGES/GqVzpXNuyXu6upeV1e9+rT5jnoBZf/VWEi/wB/wXdSNd11E77ygKG/z5yruqyZ2zJjiAlxWS1lBoL3RFVSv07pzeFBYpj4GXKYzpu1rnZLT5boj2i/oy3GtZ5Bo64zXglwIbsfl66Y1Sc5GEOxYzJnwd1EPy+m1nc5AxUHHRY9c1Socwj5PAeAHc84liCuWchmKLRjl/PYY1zXfMOW1Q7nFZR4a8laMIjzNsfvxTPyavHD7au/wf5yuSfBEWxLliLj8YG+UK+yEvBF3yCaA7ocIyzcFmjLlYiS/uwr8d6ZFPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJxRHke/qyTl8W+YVEW0q2tvx5NXp9Qs8uL8SnGhFSQ=;
 b=jZmcFGt5CB8y4RyqdyxwfzvqgCNLCoKhT2XuTHI2T4X3IWkyEGZg9bgZru/cnrZV7/qrA7P/jo/+Byv/xZ1TT6/OYQNya75jfI+lK4wzqYi2141O9Ti8V98Hl7haSfLHgoPH1434YV79xBmO+aeogauPDnhaOviyPthYEx7dqMQqfpWJWcmI/3Kkq3ATi73eKA6uYd9XC63uZqqnmnnQuq7WAWoba70Lac3YKywGrip5BmmQWWOEAMIv3OF9YnaflL/Mm0oX4xszObxvZL6oairG9vALJUV+g9kMlNtDIKcIcM6VpLtgk+7P7gbsHD89ZrGTVZuyvzyO1YKM4iKAXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJxRHke/qyTl8W+YVEW0q2tvx5NXp9Qs8uL8SnGhFSQ=;
 b=SkzkEizUKev3aTT8dfKGDim/pZG3AEFcjvtClpjbEq5GSOy0nbpSEUyfAQFMX5aOW/iBuzprxbiODjpDT412A8j3/MkoG+rk4wSdABflftAi/rSi1WNgzffP2aC3k9YOT2uLeu4gjxInjWdDkN+Gj/lkHaioRh6DvrnN1pU3Fco=
Received: from SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17)
 by DS7PR10MB4880.namprd10.prod.outlook.com (2603:10b6:5:3ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 17:40:25 +0000
Received: from SA2PR10MB4665.namprd10.prod.outlook.com
 ([fe80::5c:9564:93b9:5654]) by SA2PR10MB4665.namprd10.prod.outlook.com
 ([fe80::5c:9564:93b9:5654%8]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 17:40:25 +0000
Message-ID: <cda221fd-6481-598f-03ba-29d0b79af8b7@oracle.com>
Date:   Mon, 7 Feb 2022 11:40:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] KEYS: trusted: Avoid calling null function
 trusted_key_exit
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
References: <20220126184155.220814-1-dave.kleikamp@oracle.com>
 <YfGtVk/HQjgl1zSS@iki.fi>
From:   Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <YfGtVk/HQjgl1zSS@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:806:22::28) To SA2PR10MB4665.namprd10.prod.outlook.com
 (2603:10b6:806:fb::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7e8401-ee1a-4d30-51ad-08d9ea60ec45
X-MS-TrafficTypeDiagnostic: DS7PR10MB4880:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB4880615E290081632527D726872C9@DS7PR10MB4880.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wgyi20aEEauz1GUvCkMRLIsmIf/pM3V3yiTxtRyHpZDz3RAV8U+b+DqjHoaAWytYPSwYQ02Knu9+xyBxQorS3q4YRTE/WwJ+2TxXG1+2QHoqLuxtCvjq7WP3hCeL2U64skdcIOo8cmYcJKKwJqgW1BVc3f2L6yC4W6NOf48kbViQWUSgtD/K7mSLvkNFxlM4b/i6HewP5bm7oDHMsiId0lGXDC4QbmJVfRrcKRaxvDHgW/TeubazvjfxNUdao8MBu37I/5w5X7vs+gaelrFooeP+xNXLGzBDZ5p3n4E0emw+iIBrUpeFfGZRKfPBq30+xIRJKkwf3fibExxAlchseLmkfD0iOCUUo9MOo2M3tCtWqsh92/g4Hic0ci+lrxjeQh3/9S/nW8BU35aF7v7pERr/nBpchLSOK95CRL+UGJDG4Y5jWh3jYm11d6zbJriXnhMTLoxcnRynE32AwFIgwg44gt7BxaAPBruAuu37DTYrGPdd7XOlWkQxPPMnwta8jfJfDVOCtw8Zw0lwWEI9QwEgN494jKZ3W5MgdzN9zrZG+whBEGReWNYqw+a+VD09L6UGUBvfHgPV6dv812fzfC7+iAdwQEHaRgOnQkBD5YnoYYE+UiFFJaQmfAVg9hXOg/bFrPsp7oi//Rw8yHGRQosaUejQHnZDfGxF7gm8YCikTYlqchYiBZ9tSqNKJAObq80Wj7V2YxZlINfsc76QI2z8JsnU/bRCc2mUv0rzd24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4665.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(6506007)(508600001)(4744005)(7416002)(5660300002)(44832011)(2906002)(316002)(6916009)(54906003)(8676002)(4326008)(66476007)(66946007)(8936002)(66556008)(31686004)(38100700002)(31696002)(36756003)(86362001)(2616005)(26005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0tCV3JoNUlLakthU0kzZE14cnJrTU43WnV0RGhEZ0NPdEM4dTE3RkxBeVpm?=
 =?utf-8?B?OWIzdWxLRktzRW5wbkNBNE02cUFHUzdYbThCZUNOVnI4L1h1b0tsTGhmTmtK?=
 =?utf-8?B?enpYNUk5QlJsUmdmeFdYSDMrOVdZUHFLTzBMVEZCaWVEQTdWZ09iWnJxY2x3?=
 =?utf-8?B?dnVKUXNGd3VOZlkzaytUd3BNc0lGNVNLUTRzbko0elZ3RDluaXVIMDQyK3JD?=
 =?utf-8?B?MnUwQ2xkeTI1SEJCMGVqNnU2L1BUa3lYR25NT2JGWC9vYWFFV1NGdlF6MlN1?=
 =?utf-8?B?dndCMzl3dW4ybmJwVmFmSjV3NmlzSklNK3IxRFhiTU81VGJSWVc1TndpUEhV?=
 =?utf-8?B?ejQzN2NJbnBINFF6M3pZYkFoZ2dJMEJIbG1XdVhKdS9Ob3ljeGhXT3Z4cWZF?=
 =?utf-8?B?S3k4NmNQay9BK2RzUS9SOUd4eU9xdzJTNnpuTGI3cThhd1kvemk4UHZSRnE2?=
 =?utf-8?B?Z01lU29nWkxRYjFFc3A2RzM2WGtQZkxVR0xINWJBS1dMNW0wbDQ5RmVENmVv?=
 =?utf-8?B?VUJhQzlPaUZ3Vk83SmYvYlpHZ1llcG1ML3B5ZmNyckZ6dmZ2NTRjTnZKTVQ5?=
 =?utf-8?B?YlUrYTJBOHpjbW8wRE9ZMjU2SXBVSmVONFc3VW95NDlNVGxmRmxUWTA3d3h5?=
 =?utf-8?B?RE5lT3l6L1BsOUVlNURQWjgyN2swWnZTbTVMZWswajhUMzNqb1JJS2YyR3d2?=
 =?utf-8?B?dmYrUm1leWhoZnBRazNmVFU4cWswZXBtZUxXV2p3NjN1NXRJWkdRNHduUDBG?=
 =?utf-8?B?aTNKaGVUR2FEUnJ2K04xSnhQT1ZJSXBFWDdEdXBSUlJjZ3crMCtOWTUvdWMz?=
 =?utf-8?B?Q3lWQ2t0UGhZZ2JIQjkzcEtoa3pkWXRrdmpKU2ZTRzg1b2wzSWszaUpPdHNm?=
 =?utf-8?B?YkFWU3lqTGs5Y3g3STZLU2d2RTVNV2EyYzk0c1l0OXNJQ1JvUloreERBV3hX?=
 =?utf-8?B?UWlRYWVPZmRVY3dqMlNKNkZFa3JYcjJ0aVhJRnhBT1BtcittNlplSUxJM3dR?=
 =?utf-8?B?Zkljdy9JOVQ5N2podXJBWWI0cXhGYTVxQTRZMTZhYnhrQk5OVFBYaFAxRWVn?=
 =?utf-8?B?RUFiSjllbFE2cGM2L2k4blhkd0taaVhxZjhFNm9PbXBvWTRScjZQdTZMR05X?=
 =?utf-8?B?WXVmOHFmMHdUK2NaQWtxNmtDUkcwa3JGdE5ZWFlsY1FCd3hGS1dCc0xCWEpC?=
 =?utf-8?B?M3ByMWIvZHhPYS9qNHJ2a0o4aVM5VHg5UWxEMEtOTEZxbVdRVG96ZkM5WHVt?=
 =?utf-8?B?Tmh2YmplZmtmR0sySGZzbFBWemZ4ME5GdkxlUmVsSGlIKzJyTVowUE4zQ0hw?=
 =?utf-8?B?UmhEcDE2aG5aMkhYakFCZTdKTjN6YTE4eG9JQkJwaFRFRm44bnJldzVocjMw?=
 =?utf-8?B?UGZtQnUzUHdySGQrODliUXIwWWlLVE5xTXF1WlY0MFRQbEVUbGpwdTNkNUZF?=
 =?utf-8?B?SmpmNisxb0pXQlRlWjZqUEFETjBVQUsydHhyb00za2NEZmRpc2VveUNpT0t1?=
 =?utf-8?B?MjZRT2M0VnBMYWRHUmdPVldpQWo1WmdyNzZPVjUzSkNjQ2lJQzRpTEdGRVFX?=
 =?utf-8?B?bnVyMXNQTndTREkwOWh6b3NLVEQ3S21panZYeXdNbFpCZVNBcHI1VHA3MjhY?=
 =?utf-8?B?enZPckNEVFdqQ0U0cUNlK2k2d0ozLzdwTXRxY0dtdS9YY0lDQks0WklXUVRU?=
 =?utf-8?B?NkdNR1B4aXZLMiszT2t0ay9wUXdvTWdmcTU3a2xpTzFPb3FDNGc2SWZCRFo1?=
 =?utf-8?B?ODYra3U1L29mR2FzSllUWVdROEZPUWRHVHFKdmhFVGhOa21FMTh6MlVRR1l4?=
 =?utf-8?B?SExVK3M2YklZUHdQTlZvRXNEdXBFdllLT0hOdGVkV1pyYkRWZTMrUWRpc0hR?=
 =?utf-8?B?dGhsaE56RStVbHJNUTRNUm93emlMTnNyc2t0ZXlBMmpXNTNHQWYwQ2JzZnNa?=
 =?utf-8?B?cWJZMDk0c2RjZ0NqN00wSUFxSzNEcExRUytkVncxWEhXOExqTGhoV29RSnc5?=
 =?utf-8?B?cndyRytIRjZjWkE0U2dUVWxOeUNxRVpXMU1aQnNOVGpUM2o2ZW5LU1E1eG5X?=
 =?utf-8?B?QXkzMFdpa3FmVERla01wUk1sbEVBT0R2OSszNDFwMkZ3b01Jc0N1STQ4MVhp?=
 =?utf-8?B?bmVrcng5RnQ5SUkyTlVYM1JsMkkwNlRzNktlNVAzdlN3cXFIWFJBWXBnY3Fj?=
 =?utf-8?B?eGdmWEFKYVNiMjRudnIyMHdsWXR1TUsrQjl3N2wvcDRQL2xXMVdSYkUwS1d4?=
 =?utf-8?B?V1pMcHR4bFRJSkM3Snl6cXZGV2lnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7e8401-ee1a-4d30-51ad-08d9ea60ec45
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4665.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:40:25.2767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqjFOOilUc6yJ5TGQvrSLoeB/yZBqMt3CBMs6+w6o0xdsIVKIYcZN88s1apQCw/anm4Z3VJJKAiG5WX4/zdj02XMUvJt53nyzoHwrueHDHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4880
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070109
X-Proofpoint-GUID: CIqGmtd4dp8OEfo7Q7ZJUgnRPTgKMDHh
X-Proofpoint-ORIG-GUID: CIqGmtd4dp8OEfo7Q7ZJUgnRPTgKMDHh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/22 2:21PM, Jarkko Sakkinen wrote:
> On Wed, Jan 26, 2022 at 12:41:55PM -0600, Dave Kleikamp wrote:
>> If one loads and unloads the trusted module, trusted_key_exit can be
>> NULL. Call it through static_call_cond() to avoid a kernel trap.
>>
>> Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
>>
>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> 
> Please re-send with cc stable and the empty line removed and I'll pick it.

I re-sent a v2, but haven't seen any response from you.

I can send it again, or feel free to clean up those lines yourself.

Thanks,
Shaggy

> 
> BR, Jarkko
