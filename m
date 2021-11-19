Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A74578D5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 23:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhKSWfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 17:35:34 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24918 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229962AbhKSWfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 17:35:33 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJLZaJX027683;
        Fri, 19 Nov 2021 22:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0mGO6sDq46Dad6LWRdq9afD/taMjgZUxDP273TaC1q4=;
 b=yLlaExdage+bN+tmkQ8XON4SIdb3d75WcSIBQl6qHd7EMGv8TDXFYlxQaTwkAcxi9sJv
 KDQFcJw+LHMBZ9+Q3NaeCg3yjHYgNTJG0Jz5+l0qELOoztNrs9ke4Lap5Y0gscUyJTFB
 0V0G8YQQDZPyIKnceoqxI0kcxoYkN7ReWgN+jwqwDaIQZTHjnTZR7BZqa9EAaQ3iFnoP
 iY46LGEoVk60132JdjHuh2CDs337z6DMDWxs7rWg4y3Ch5vyHtyaXBfNARhRd9p9et0z
 ItQO121I/yNYcvcNLEX43hzzBW/xNE9yk7dOv9hq6I7KiEIXIoPKZ2RPj19a+hZHoUUt Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cefpbhuny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 22:32:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJMGPkq011117;
        Fri, 19 Nov 2021 22:32:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 3ca2g2yxxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 22:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b960uU9c/B5BgAV8IXJFxmIMxx9URzYsKEBp1p85qL+2E9hXln4N6E737jrPpPHYG59R8Prxk+9HKrZXr+R+9ezn05gZxjMXyybROcsvQ12SjKCF/TRKT+ciuP36ZBc1YyYNpZny4wmlZicfv3gEWVr6KW484izBv3dMdxnWlUX39r7PkAli40Qyt6UTgwesnRT01REz3J8EYuskxWM1ml4SI1OOZsehpW1F/vpz5HOzJU33cEbHR2uK2vKb76DaRZy3egB79yMTIjfQlGvgLVbE+n7TSay9V/YCB2FW6qgD5P7m+BBCguZ6OLEQ5ZMX8+BtrKjK6zD4TYa2KKon+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mGO6sDq46Dad6LWRdq9afD/taMjgZUxDP273TaC1q4=;
 b=Q92SYGfkk5J319fEUKrK2f2CYDRINNIyJ5M7YROmKEk7ktSLIqqjB1AopzPpecLI41kXsfYbUdH20DBaottbEUd4yxSp8SAQ2W6SZc74mZi95VAL8uO78JiWAkU49m4VXH6c0ZsVRIMtQ12EQUt099rzdtJvO+mNoNzNzmrcGftTEp4M6vqPp9mFrsMvuK9RGK++Ch6Z3teQ6MFb95oZbyVo8+hwkRHs/oKUGCEHJj0osC1y22xEc0w7ZlKRt8Hjp0p4vSMSKmx74sfGy8Z03xj+1/HqqgGzPiFgUteq4LL97miK/HWr8ChyN1eDyUwjkIgSDB51riV+5uBBl/FXXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mGO6sDq46Dad6LWRdq9afD/taMjgZUxDP273TaC1q4=;
 b=Xiez+KelmFgJmx8IcliWiOUbTm+NJFdmcxHhqn411g0wkBT0h3m9Y4kvsRzEAQR+elQvh7P2LlJnPyMl5QG2Vtbl2oP28lkq7wcLtsQSDpp+TGU2EGa+24APW7tYuqXyrPL1xctk2zewH7xN/XhrzAM7Gvi655RcLmy23ZA0xpY=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4399.namprd10.prod.outlook.com (2603:10b6:208:1d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 22:32:22 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::8d84:1f40:881:7b12%4]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 22:32:22 +0000
Message-ID: <6141d292-692d-9828-48c1-2d00e0285903@oracle.com>
Date:   Fri, 19 Nov 2021 17:32:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>, jgross@suse.com
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211119202951.403525-1-sstabellini@kernel.org>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211119202951.403525-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0011.prod.exchangelabs.com (2603:10b6:805:b6::24)
 To BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.108.53] (138.3.200.53) by SN6PR01CA0011.prod.exchangelabs.com (2603:10b6:805:b6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Fri, 19 Nov 2021 22:32:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f930b4c8-76f2-4324-47e0-08d9abac7428
X-MS-TrafficTypeDiagnostic: MN2PR10MB4399:
X-Microsoft-Antispam-PRVS: <MN2PR10MB439980F931811ACECE8D04BC8A9C9@MN2PR10MB4399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKzm2dhk9GeL2wAjjLyk9zGtnreWHQz4FYPLrLY0HGq1mMwx4ZC5hqjqqLnqnidWiMYXBz3WAv0wh8/oqedSZDKDOnW7JcjTbYPGDZIENowZIWty3gvN6iFRo799RPGSCLSUha4kQBX8+tD2ynXYvPYtygF5kN8bcGjgNMRp+4FCdR8HIdG+6iPlk22ewDdpu/gQGzMvi9caDO4+GHFwAmyU2x7lnO56Lpk1mAc55QhFzvj46sAV2G2+iIE/zhjA+OYpDGWTuZcKwgcXvl/WwV2YW/6cKymgZ7DIqDtN7fIDCULiGbW6WGmWvsLJkkRt+DTaMHYAt6XNNanJ987HD9UVVxXRCh5R4pPnVXSePhmUchAEv4GVpwA8iRdGRev513Y59bR9mfUsQxU84JohfbUH8mQAIHaR2F7nOZxsEt5aZ41M1IhP3I5ZHou7BMpvW2UmKSSXmdChS+9NzAEgdKsaUQtBgp/RaZ1jgMREtdlZN0QC0RroWaDHdcM1wXNcgYBlOawVd87KM/uCy7dARefA3YiX9dxYUJDKjG+QE25hvKXRoyTvwqEQdjEBE6H4G3258cyXvDsU3B3g95Azr5YOnBJAHVByJBVgTeUl2gF23ped/KuosvXiZ1hs71LYyDbja0TijTxlFCqrpOmZPovH+u7OCQ9SeInWTpJsQloM+nLZo/0chXGkQyM0zTIiJZn7M7LleABa14YqvMzFqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(186003)(66946007)(508600001)(66476007)(16576012)(66556008)(31696002)(316002)(6486002)(2616005)(38100700002)(53546011)(31686004)(2906002)(5660300002)(26005)(8936002)(8676002)(956004)(6666004)(44832011)(83380400001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVJFbnNiTGEyRkFlQlQ0Q09tQ3hHa3RmbitOYmsva2J2NUJRS2Nqc0xuWVdq?=
 =?utf-8?B?Y3RnbkJGQ29xT2pmL3NMMDhrbk8vdnBCUzNON29kaGs5amZIL2NhQnBTMm4r?=
 =?utf-8?B?YW1oWmNUbjRNQVExT1N6VkRZUkZMUy9WT3ZjQklyNzVlRE4xTmlLc1ovTnJ1?=
 =?utf-8?B?VlJEcVhIM25ZSEZKbjU4Slo0aWV2cWVZVG05NFJmaC9lMkNBblVCTldnRjZJ?=
 =?utf-8?B?ZVMxbG1jai9Fc0JEeUJOcUFKc3pHY1A0Vk9zSW1vdThocEFjbmRQd0c3bzUx?=
 =?utf-8?B?R0R1RGozNmQ4Q2JreWEzRUxuMitDZE5hOU5GeXk5dnZBNElkN3ZNZk1LQkFK?=
 =?utf-8?B?MURvbm1SMk1Mc0JGWmJSVW84bEVjN0RybG4wWnRyTzBJZ0RpTVk5a3MydE9a?=
 =?utf-8?B?K2xQSnlCVzlQMThLS29aOFd0NEZBWDI3M3BxTE40MVNieFArVVV2aGc1S0or?=
 =?utf-8?B?UHFDT1N0TmwvUnJxUEVEZU0zK3JLS1FQeWZaWjJuR1BsaHdNUWVZOE5VVFdY?=
 =?utf-8?B?MXdQVHBobDYreGc0bWJxRUFsbG9SSG8yckVpaXoxZTBPcFVCU0tUUXJSejAv?=
 =?utf-8?B?VzBDV1I0YzAweHFlMUcrenJ5UW8zdWo4WGdHeng0NStOQjB4V1hJWG9rRnRB?=
 =?utf-8?B?WFlSOG1iaHpiWkxNcllkNXRRaUd0MHkxTTJFTzA3bE96YVNpbEpZOHMwQXVl?=
 =?utf-8?B?UFdGMFJaV3BaRWtxVDFsejl3Y1VXS2ZXQ2FWT2J0NHNKWU1DMUhKbzNFY3pQ?=
 =?utf-8?B?RkRIU0VGUHN0WHB2NG10Ni9ydDJhRWJDMXJsTnJNR2djZk1UdWRRWk1RN3Vw?=
 =?utf-8?B?dXA4b2ZjYnZZK2dsUCthYjlGczJ5WWFBQVQ2THJWZDcyUjd5ejdIU2I4QjA0?=
 =?utf-8?B?VENTUjdxQ3B2T2QvbWZzeDlxWFZLNDQ2NG5XMGVjS0RuNklPVFVtU2hvSUps?=
 =?utf-8?B?eDM1VVpxcng2Vlg2dEdQaEx5a2JaWVVGU0lHL2RoWVNpeVFEcjFMZ0ZOZktN?=
 =?utf-8?B?VDR1WVNyK3UzcVZ4UHRGbmpPY0xiRHRXMEw5YzAzWG5sR3pLWjdJTlpldFFM?=
 =?utf-8?B?RlBUVnFxRDZrNUNXS3lzYnlDTjk5TFFIYnNWUXFUMU9SSVhycENzejljeklj?=
 =?utf-8?B?V3hjR0luNGpvRnRsZmdVUDFxaGpST1ZoYXFneUYzc2I5QmNxNDdDaGRWcVBq?=
 =?utf-8?B?amVCVHc3UDNaWkpwYlZrR1VoaWpnS2FPRnY0N3BKc0NxOHl0ZkpaUEpQaXMv?=
 =?utf-8?B?QS9TRVFiSXNmY3FkL25sd3Q5azdzampXZUdPZ0ZTWU1sYzNybm1SZ2R3RHdh?=
 =?utf-8?B?UTYvNlFpVVRhSVgvQUVacm5wMFdoby9HNnRTY3pVeGxIUFhNMG5LMHJISHV1?=
 =?utf-8?B?a21ka1RTZ250aFExNWlWSytPWlRCU3dnN1FZS0c0NWtrWXE0UGtZTytqK1Qy?=
 =?utf-8?B?TVhpNktWWitSNlhnUHYrZGVRcTZ6SmlBWFc1Ym81NW1BNy8xNXRwcVVRWUsv?=
 =?utf-8?B?YkpMalVhWm9rVm01Y0RYdC9XL0l2VjhJMjhYY3ppSW5WaDUvSTdBMnY5NUpp?=
 =?utf-8?B?dUQza2s2Q3Mvdm83UWZma0k1TFRPVnFMQTBySW1vQ0ZoYld3RC9URHMxK2dE?=
 =?utf-8?B?QzNFVjRSSjl3OWNYdkN0OERaZTZqSk1LRnZScFB3dFhIQkxJSnp0SlFpTE1Z?=
 =?utf-8?B?YnFoc005TXJkYXZoNEUwbFF2Q1RxRGN4b2dBeXZpL0JEbjh6MjdDcFVJQ2VQ?=
 =?utf-8?B?dDdZVHNPV2ljdUpJTWptTS8yOThzUzJhNVlKR3h2THFzdDhZWjN5UHp2d1lG?=
 =?utf-8?B?QVNjUG54alNXTXMwSUV5RGVScy8ybldKeUlRWHhpWFZWcG9leC8xS3cvRTM4?=
 =?utf-8?B?T0VCcDJmMGxPQnpmeVB5WmxjbWd0VmtvRUtYUUhwdnNQUGhpc2Z2c2trc3Iv?=
 =?utf-8?B?dU4zaHpPNFVISXEySXA3MkU1dTA3Z2pLazRldDI4MDJTdHV5RjZHRHVvdXUz?=
 =?utf-8?B?dERkOEVHa01HdUQ4cEtiUnRvazYySmRrc25peFExRitDY3gyQkVzNXk2Tnlw?=
 =?utf-8?B?Y3pZMC9DWVQ1MWtXSmJwcEh4ZUhIYTROUk9lVnJxU0JraHpXMmZzZ2xYM2hY?=
 =?utf-8?B?WG81NEpkSHE1aFovRzFkU1M3QWJFWGxIWDRadXExT0tlZTc0Ym9FUVRKd3J3?=
 =?utf-8?B?QjR1MURMai9sLzM1R0RueWQ5TlMwM2VuUGtoQkFqZWhRMkhTOXpCRHgzT25W?=
 =?utf-8?B?ZEhqeW5oUll4UVY3Mk9VZnYzdGtRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f930b4c8-76f2-4324-47e0-08d9abac7428
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:32:22.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeXXvCc0EWOIXhHo8rLxiyJipPG3DvNhsOtvyMD9nqrto5fEzgFre2hjSe+NY5QYcgtKp++/C+ksZ/LEbT8t5wvSwECCz6l6nlDSJUeFIP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4399
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190119
X-Proofpoint-ORIG-GUID: ySfO73lM1gujfqNh1XFZt3-0hrEXCg9u
X-Proofpoint-GUID: ySfO73lM1gujfqNh1XFZt3-0hrEXCg9u
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/19/21 3:29 PM, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
>
> If the xenstore page hasn't been allocated properly, reading the value
> of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
> error. Instead, it will succeed and return zero. Instead of attempting
> to xen_remap a bad guest physical address, detect this condition and
> return early.
>
> Note that although a guest physical address of zero for
> HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
> and zero has never been validly used in that capacity.
>
> Also recognize the invalid value of INVALID_PFN which is ULLONG_MAX.
>
> For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
> above ULONG_MAX should never be passed by the Xen tools to HVM guests
> anyway, so check for this condition and return early.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>


Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>


