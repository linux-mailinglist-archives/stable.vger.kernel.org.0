Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4294F4072
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiDEMdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383189AbiDEMZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:25:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB529FDD;
        Tue,  5 Apr 2022 04:32:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235AYApH014716;
        Tue, 5 Apr 2022 11:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uHdHZmr5Er3WleOHmNjZNB2NT//wfIu64AwMcz+SGiI=;
 b=QCbvyA1vACO4JGcOrY/Es2ExgB2InCxhQg7ag8rhi8hJFYLXh7duR5iKJM/B8965hbq3
 2DFBTpIQXWsVviW3MDm8NpAOM1F1GFeB00hcBtygEKNOuRf5OmR/tFN6Hlx4YgavZepE
 Y9FJ+abhPPED7CdwrPYsXTkqGEGtdvcAmnCKa0/2d8qScn+cdV+FqJeZwSR2Rlmp76cn
 JPSvkONZikzMbHqj7vnLNQiPDhThqEwjXZiSLoxYDoctEze8ZU69Rax+0BoHIEhz5+Z3
 kSyvcizhfWq5gkGwwRfFOpiqRIfE1Cwlqj0+rFGQZ4XvvrI4ZvhUEuz0iRKJegJntLup mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9nnmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:32:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235BVbua039246;
        Tue, 5 Apr 2022 11:32:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3mkd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:32:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gY/u5zkMTvLcDkiu0WBCETvkkErNTJuZEWxADds6vHBtliDNpteV+TFmoDRzjqFeA8kIj5YfXp59fCcAlcwHw+rBhHkw9zh0SldlRxiAy8MdTvv745VSozTNVFS2Dl9yA0Iz7N0XHWJiXIhmgoyGct+BNiCMgW1GH+5R5IlmyuTstEHospQz2yelbubHQAybwXNBElA39pYNBajYiBxaK4FDkA3YDN21sIjVrsYYQqVAead28iaJrRaTw9myW/r37k5TO3WMxwhgMUFRZrAUL5AmkW6krfc5roOq+5uQTLMeqjPdA7Ja2/ivwc917Z6YbzEoI4SnlUiu+QxwHacoBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHdHZmr5Er3WleOHmNjZNB2NT//wfIu64AwMcz+SGiI=;
 b=JDwdAeMakvWS83l9mieSFXd2w5Oda3dqt56EyUY1jtyy4do7pUJ1VU2fruMDw5B01V6i1CGd4CNg09AdoZ6Lut2qBNi8GTZnO8riWrsBFULuqWhZaSxdPn6YwqBXWqnkw1iuVLhfOBvCPjjsaRrC7YcuYOoVpowV/iZ+M0XPHnlXSSY7tN7+MVax0JYE7BcoHtGl7kYi2vL21AtQcwXkc7fWvIoG2YvEwyC1SFr6uoqR6u6gAgmCB3aBe8hn+GokFpXt+iAPgGuoNb72s3RZ5Q5wk4AJfIuzpss11uDGskbu14hQ/+o9AV9v04fl029JIoMGfO2bPobAUmlWlfJjpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHdHZmr5Er3WleOHmNjZNB2NT//wfIu64AwMcz+SGiI=;
 b=nKXrZktUMF5sGfeaG0CGkoDugaujSYE9S5fnGrcsvmcsAHmdhkXdQwG/FTn37EGuXw+egCkcyl/b8uPBTRsXQMPCN657XVb7j70HnDigLc2R4AI7Wb6yms88HBsh8alP9P/iiSy2dxUTrGBSz2Zfnw7KWJgs2KcJOwShfRYZl68=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN2PR10MB3952.namprd10.prod.outlook.com (2603:10b6:208:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 11:32:20 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 11:32:20 +0000
Message-ID: <e9805474-f672-3c29-a294-0fce060037b5@oracle.com>
Date:   Tue, 5 Apr 2022 19:32:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/17 stable-5.15.y] Fix mmap + page fault deadlocks
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        agruenba@redhat.com
References: <cover.1648636044.git.anand.jain@oracle.com>
 <Ykq9UXXZLTZOJ6N+@debian9.Home>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <Ykq9UXXZLTZOJ6N+@debian9.Home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::15) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b91f2f5-f59b-459b-f931-08da16f7f20a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3952:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3952412AD715C383B8F53EA1E5E49@MN2PR10MB3952.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dn4z32uhSIlUSg7FI46wXvhJAAeUF1DZZA+e/xl1+YhIQjIxtzGW8/CqtCwyWI/MmYgwXhWnHhRsoCUJFrVeB0NlB9oYLm/AjVWu63TQzNN/KLzLWHNbDplH8/AP5WwHl9Q7jx1Ps+e7tlI/z9sxNuha6ccFW698sgA7W7gA3JzqGTsi+x+D35/hMTCEXc3rvokV7cG+v7ws5to+rJqnjMwGG8RvBr72CGOgckrAZvt+moKq+T568wPj387SQ82wC5Xh3URRyapB/h3Hw7NwNDdmZ35T+t1XJVnFrH6md3J3skoKWPwXJQehyoU0kn+aiFnCiY8ezgwAJsHI7z+gZSzEZEV8uOK53ArEiM4JdvB1DcB1AXL8zBqnwO+4sKQowhnxTsZnO6p8XSM6shkzEC3NukY5k3Cb6/Q9l1JxOqJpi7paAFWQjcsw6HoeOm80TAno1LHez9sEGIXmHd1F7erpmz1fe3gKOE1hJQ98AabK73ozT+X8x+LfNh+3KpGB5qRo4hpUR52sHWt3QhIJyinpF2NS2qhxfSTA7MaOzyODXoUVpfEBvL/3IfxXg2M5bt9kYf47FlevFZPK3AM9kecSb9Wnk7REG1nbyVfeQg/OWhFgXhAAhDIcqMN7uk49xRc87maNttGJEb//RqSsKfiRf9c4kPSKtUDVa49h02bdnmoauViU/NinSA1tdFpaog9tV+x8io5x2EdGjYcxwyc2bQbQpvVVdLm3Jt3sbEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(66476007)(508600001)(4326008)(316002)(53546011)(6486002)(6506007)(86362001)(31696002)(66946007)(66556008)(6512007)(6666004)(8676002)(6916009)(2616005)(186003)(31686004)(44832011)(36756003)(26005)(2906002)(8936002)(5660300002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlFEOGRQcWJtb0d1d0pTY2E0bk9XNS96clVkMDNQaHJQV2dyRHNUeUwzdmlJ?=
 =?utf-8?B?bU9iMUdLUitNM2VxQ01NRGpRaXBERW5sMWl6VTFZeHJCeUgxVGJCcWMyVjRU?=
 =?utf-8?B?OGlzTnBTL3h1TWZDSEZpY1ltOGFCQ2ZCZG1hSHdXTDF1dERTUVV4R21NLy9Z?=
 =?utf-8?B?WlVtRTBtODJnWTNvSTVqV011SmZVNTlRejdnOC92c2ZZYkUrYVNiUjNtQWh4?=
 =?utf-8?B?L2ZYaDhiUG5ZZGRYemNKa2QzVmZNa1pwUzJKcTdmek4wd1JuSElTLzFidHcx?=
 =?utf-8?B?bUo2RDJnTjl3cTB5SnBuTzVYam9OWWlNenBkYUxSYkNEV1hPMml4eHNWVGlN?=
 =?utf-8?B?TnFPaHBPYkpBdExhQmFMb0x3bklxYVhFOWlXMC9wZmdjMFNDR3IxYlFtZVFp?=
 =?utf-8?B?Tm1SWnlSTGVqeGM4SmtNNWFYOHdRbWphNWloZ3hMRzRkeEhYdE1rbmROa0RE?=
 =?utf-8?B?MlBYWDUvbGZyVlVRWjFLV0VhM0VvVFI2b2NtcDBBZmpJZWJVbk5US1Q0dk5L?=
 =?utf-8?B?NU9kay9iNWRSQ09JbWlQQngwWDlaL01pMjBrL3pVcnVOZEFsYmJNcTZHZkI5?=
 =?utf-8?B?bTBQR3JuTmVlZ3VKcEMyZllqeUsycldOckNaK3VER3MxejB4bHJDenlhTTYx?=
 =?utf-8?B?bEtYdTE5N1M3UmhxcERONmlCTGRsVFhsWm5RSVRsdmNuM0YwS090UVhiNkg3?=
 =?utf-8?B?MmRWTnIvbU5XbU5wT3poT1Y1SXRXT0Z3VkJrU2hZYytxdW5ybzJqSmovd0Nq?=
 =?utf-8?B?amYvZ3UzMlFmd0pINW5sa0ZnSHRMdFRtcDIrWDZOWHB2SVVsYzB2WHdlaWJn?=
 =?utf-8?B?R2ZBTlNSRnd1V2JpeDBmUVNxUFd4SGpZUmZ6YU1CT0JRQXFMenU2UHF2WDdk?=
 =?utf-8?B?WE5rWm1MTkpsSS9ORU1ITXdBdC9yb0Q3TUwycWxzTDhjejIzZnBLQU9JaTcx?=
 =?utf-8?B?R0RQTVVBNHdkS28vZmxVSzR4UE9qeUJxRXdBM092dTl4elJnOWg2WXA3dGVU?=
 =?utf-8?B?eHVQcHRpVlEwMHpnMzNxcVJ2VnkxQ1JINjhQdEkvWFRBRXhZOFZKNlRnTTlS?=
 =?utf-8?B?WkZYZ243L2lSL2JqRERlT2FUby8xanErZEw3RjFKdy9ldWhRL2Q1V1p6Q3NP?=
 =?utf-8?B?VFBxa2pqSWFhUzNtZFU4TjZoSUVpelc0VkVVVXh4dTNuR3JxeDcyYlo3S1VQ?=
 =?utf-8?B?Y01ObzFwa3IzcmJCdGo0MUltWUd3Q0xpaC9pamhEWmVwSGI1bjZQSjFrNUhh?=
 =?utf-8?B?a0VGS2JlQ2E4VGphTXRRMDlDYjBUWVV4NlAxalA5UUpnZWg5N3RvYm96Q0NP?=
 =?utf-8?B?Vkg3N1R5TnVzVDB4SFNjcnZINWMweXpaSTBrREVWYXV3c05rcENkbFlQeWVv?=
 =?utf-8?B?TC91OGF4bklVejIrbk43WFN2WUNEMWlGSzczbGVwZ3hpb012OWlQdEhwSkJZ?=
 =?utf-8?B?dXQ5eis5Yk04V0NXWUhNUHdKU1d4QmhSSVp0NGdmUDlOYk1HTnVKTnI3eTFZ?=
 =?utf-8?B?NkxpVHFFWExTMUNSUTlUd3d6U3QwaWxtMnlRNmIrZ3JMYmtSNUZYVnZHZmkv?=
 =?utf-8?B?SlJMUUdLVXloVjZzVnc3TW1LVk9YWDJhWGR1c0c1Y3BNZ2dmUFJ2UXRhVVBB?=
 =?utf-8?B?TU1hVlB0RkRkWGFObndTTjdLUmxsNU5McE1qdzByd3hPOW8zK28wWUZEaVdW?=
 =?utf-8?B?ZUdoOWMzczBNVzBab3AwVXhxOXBUbmtTWlJwdkNzcDZqbHBYYmdIbUxYOW01?=
 =?utf-8?B?eno4SGVrWDRIR2lQOTN0S3V0bGVFL05mVDFVSGNtTUxNZnVMZnRQTVZycVRp?=
 =?utf-8?B?YWtNQTR6Umx5S1NMR3RYZ2tTZ1FyQ2pjaTFWVEVFKzBpNUVOVjZwOUd6ai9C?=
 =?utf-8?B?c0NvMVBwUnZjSnBtUWtBcXc1N1R1R3Ivano4T1FJbzR2Y3MwbkJPa3VTYUE2?=
 =?utf-8?B?b2tOWWdEZ2RkVUVzWlNQbGk5OUh4M25yZ2dYZWJ0L0RVcHhkUFdJMUJYbHpH?=
 =?utf-8?B?T3BlQU51bW9VY2JuR1REcGFEUS9oMTNHYXRXY1FveHordHArVGpxMEpuRWJY?=
 =?utf-8?B?Y0hKVUFEQ3dkamVoYkl2cjd0TGdDUXNwZ2RWTVcvdkNxSytIbnZKVmprRTRV?=
 =?utf-8?B?Qmh6VmlxUXlqTUNRdjYzV1oxMnNwaGlKL1dUdUlaZ2NvcFRYa21xa2VsY0tV?=
 =?utf-8?B?WVNxUlZKeWtBa0NlYmh5N2wvYVpGWWgzbTNTbDlUQklpU1ppOW43R2lOT0c2?=
 =?utf-8?B?ZWI1ZG1iZGpiTnQ1TTFBbmR3VEJYaUxiNmVtY2tyNVB5N1ZsNWh0NU53MWUx?=
 =?utf-8?B?a0JsV2dhY2taS2dQbndUeHNQRTBtREVXU3BiWjltenpFSTNYN3Zwdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b91f2f5-f59b-459b-f931-08da16f7f20a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 11:32:20.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04p7v4afJd5Z/PnNeh1TKeJYAErmzI+I7uquJ3MR5Rn/JIPMIns1JznZheB81OhS+2RiECM8hmFC75AzxS6MLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3952
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_02:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050068
X-Proofpoint-GUID: YltpZoXVS_bbjEOVmUiXeWzhInEYUPyZ
X-Proofpoint-ORIG-GUID: YltpZoXVS_bbjEOVmUiXeWzhInEYUPyZ
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 04/04/2022 17:41, Filipe Manana wrote:
> On Sat, Apr 02, 2022 at 06:25:37PM +0800, Anand Jain wrote:
>> This set fixes a process hang issue in btrfs and gf2 filesystems. When we
>> do a direct IO read or write when the buffer given by the user is
>> memory-mapped to the file range we are going to do IO, we end up ending
>> in a deadlock. This is triggered by the test case generic/647 from
>> fstests.
>>
>> This fix depends on the iov_iter and iomap changes introduced in the
>> commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
>> are part of this set for stable-5.15.y.
>>
>> Please note that patch 3/17 in this patchset changes the prototype and
>> renames an exported symbol as below. All its references are updated as
>> well.
>>
>> -EXPORT_SYMBOL(iov_iter_fault_in_readable);
>> +EXPORT_SYMBOL(fault_in_iov_iter_readable);
>>
>> Andreas Gruenbacher (15):
>>    powerpc/kvm: Fix kvm_use_magic_page
>>    gup: Turn fault_in_pages_{readable,writeable} into
>>      fault_in_{readable,writeable}
>>    iov_iter: Turn iov_iter_fault_in_readable into
>>      fault_in_iov_iter_readable
>>    iov_iter: Introduce fault_in_iov_iter_writeable
>>    gfs2: Add wrapper for iomap_file_buffered_write
>>    gfs2: Clean up function may_grant
>>    gfs2: Move the inode glock locking to gfs2_file_buffered_write
>>    gfs2: Eliminate ip->i_gh
>>    gfs2: Fix mmap + page fault deadlocks for buffered I/O
>>    iomap: Fix iomap_dio_rw return value for user copies
>>    iomap: Support partial direct I/O on user copy failures
>>    iomap: Add done_before argument to iomap_dio_rw
>>    gup: Introduce FOLL_NOFAULT flag to disable page faults
>>    iov_iter: Introduce nofault flag to disable page faults
>>    gfs2: Fix mmap + page fault deadlocks for direct I/O
>>
>> Bob Peterson (1):
>>    gfs2: Introduce flag for glock holder auto-demotion
>>
>> Filipe Manana (1):
>>    btrfs: fix deadlock due to page faults during direct IO reads and
>>      writes
> 
> If this patchset is backported, then at least the following two commits
> must also be backported:
> 
> commit fe673d3f5bf1fc50cdc4b754831db91a2ec10126
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Mar 8 11:55:48 2022 -0800
> 
>      mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
> 
> commit ca93e44bfb5fd7996b76f0f544999171f647f93b
> Author: Filipe Manana <fdmanana@suse.com>
> Date:   Wed Mar 2 11:48:39 2022 +0000
> 
>      btrfs: fallback to blocking mode when doing async dio over multiple extents

Thanks for pointing it out.

> Maybe there's more that need to be backported. So cc'ing Andreas in
> case he's aware of any such other commits.

I have scanned through the commits. I didn't find any further Fixes
for this series.

I am sending these two patches in a new patch set as part2. Instead,
if it is better, I am ok to include these and send v2.

Thanks, Anand

>>   arch/powerpc/kernel/kvm.c           |   3 +-
>>   arch/powerpc/kernel/signal_32.c     |   4 +-
>>   arch/powerpc/kernel/signal_64.c     |   2 +-
>>   arch/x86/kernel/fpu/signal.c        |   7 +-
>>   drivers/gpu/drm/armada/armada_gem.c |   7 +-
>>   fs/btrfs/file.c                     | 142 ++++++++++--
>>   fs/btrfs/ioctl.c                    |   5 +-
>>   fs/erofs/data.c                     |   2 +-
>>   fs/ext4/file.c                      |   5 +-
>>   fs/f2fs/file.c                      |   2 +-
>>   fs/fuse/file.c                      |   2 +-
>>   fs/gfs2/bmap.c                      |  60 +----
>>   fs/gfs2/file.c                      | 252 +++++++++++++++++++--
>>   fs/gfs2/glock.c                     | 330 +++++++++++++++++++++-------
>>   fs/gfs2/glock.h                     |  20 ++
>>   fs/gfs2/incore.h                    |   4 +-
>>   fs/iomap/buffered-io.c              |   2 +-
>>   fs/iomap/direct-io.c                |  29 ++-
>>   fs/ntfs/file.c                      |   2 +-
>>   fs/ntfs3/file.c                     |   2 +-
>>   fs/xfs/xfs_file.c                   |   6 +-
>>   fs/zonefs/super.c                   |   4 +-
>>   include/linux/iomap.h               |  11 +-
>>   include/linux/mm.h                  |   3 +-
>>   include/linux/pagemap.h             |  58 +----
>>   include/linux/uio.h                 |   4 +-
>>   lib/iov_iter.c                      |  98 +++++++--
>>   mm/filemap.c                        |   4 +-
>>   mm/gup.c                            | 139 +++++++++++-
>>   29 files changed, 911 insertions(+), 298 deletions(-)
>>
>> -- 
>> 2.33.1
>>
