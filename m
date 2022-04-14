Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F7501E34
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiDNW0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiDNW0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:26:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B399D4A;
        Thu, 14 Apr 2022 15:24:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EMKSBc029074;
        Thu, 14 Apr 2022 22:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EU+CO2j2dSsxDYzl5K71qtw1OoIOK+PoxkDW42lbYfc=;
 b=wzLIz2km6EyKdCiZBny0sqEFrnS1wuM3Vo3pWj/hAcXcWK3u1Dur2tTm5qptb25kGZRu
 21JFdISUITcWSyc5Oh1kClMYedFp4jQke3YlqldLMLClUwT/Y50IL8qY7qi9GxykTxwR
 aR/6pcuTiQRjsR+2NO/YjdBQrE00GZ3qOzeF25oAd1g4cw1p4JVnvNWPUFRi2+snsW+P
 yt4wdeJ66ix1/n2HjTFvWIcuLsZusyJaxKX96LYRyICb1BW8iTJya7LBv1VDZQK3To3N
 0WP/Tawhvh3ClJ9fD+h4Y5xks/vmNf8+ANytj30CD4aV8+iV2CJpMze5fnuy3t7zUB5F rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse6pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:24:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGQaC008473;
        Thu, 14 Apr 2022 22:24:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6g34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:24:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aplidu+wbRQxeePsO7vI/UcI7SBjuvmvxV2sDR1Y7vD7eLXb8FB4tU7hUyvFH1ruyb3aTEzrd4IIMng/WfVklTOHA78G3M1vUNofNGe6UhD3hyEbbz8SflYvOg8qNPu42HhGIoU394FHLbs7ghNgK7MbeUnUfXGqdS/oyl0D4PiCGGW/NCuyLBhi/u/qQGaMzTZlaperFE0A64FNKhJTl+AI054IrtroEKDiz1+LAqzI9u8UF8AbskKrmT5xxWnTNkhgPWEMcprDVXho/xXl5VpLG8ar4ojdY8eh8q0At8DrNqflVH6YV1qdOdiRa6nxvOLc1hljuzezIJv2dhSyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EU+CO2j2dSsxDYzl5K71qtw1OoIOK+PoxkDW42lbYfc=;
 b=OuEgkdlpFKmZ29DbyvZjbOQE69Mkf9yTVjupyNrNCw6oXWsrMtfIihiNB/GF+BF7qs3cMpob77TuMRwcHQYGJo5nDYs7864mR4S8aj6qUqLpjFrH23w5mu7AZTXrf9QWniRjjURptA53K+/ImV9hTIXLy9aItLGXltdVrEtZaEqjR15eu/r51r+EL7hqCLinspyS5VM/I+FXVf4qi09l/3ZFVkp1VuYxPMVF3NWMdREOI1fo/6LIeuLjzdplwVpStijPmvCfuM3E/L7bTgpM4CEFFBVUqnGIsbNxiOcLupMHbpFBBQGnXJJyF5eumFGP7Mcus2KbNUcbylOVGOVnkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EU+CO2j2dSsxDYzl5K71qtw1OoIOK+PoxkDW42lbYfc=;
 b=zZqg1h1BTb2Hz75llV/PsYYKmQEdaqG9FuthZiqzzBl9XVd+l+LIZdPP4TlskKIFLzxeUd1rVKqiJPXM6syTwXQYR+gp+ESXAPzDLOdBMuPWg8qXtkMuJ8boRK2GIMaRTw/rYbvsv4WufIRZffSNw3qe2J0LVadywLdXFN2ftWs=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:24:15 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:24:15 +0000
Message-ID: <cecb3839-c935-df9b-deea-486dde9d540b@oracle.com>
Date:   Fri, 15 Apr 2022 06:24:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/18 stable-5.15.y] Fix mmap + page fault deadlocks
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <cover.1649733186.git.anand.jain@oracle.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 079d53a8-e5ca-45cc-14dd-08da1e658221
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5409F13DC11FE4A5CCDD6575E5EF9@CO6PR10MB5409.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HF5Jzwbg6mLQeIcU09/etSDaIDk/rbfPOnrnAYJvegNs0ye9Ekw7EzFcwPlynqRpxIvMUZsIACrvy7dS0MyArUufNukQQUv0H0ICkMjLBayHRig6CQF7/35cqzepgFtNc2A1wdQBsQUvZMPK45CRaPfEu2VEDcGzYfupdRu7NDrlmxFRpJWU0CprsJn1pA6B2OsOiV+EeRXuYqugXwWvM9yBNatVMKpyWONBTuCnnm1pvXY4Cz/F4EOMIMlFqDHz1CfN4vqXVNz3R7zN5q/PhVVOnCl1QNGePMAsjFZSMmXFZdFCdR5HvTJ9r5xE8Qy2P0hLcoD3Z3ScU/0v5ReY9u0dIgBmYyFhJnbQDpeEq8rPlaC2EFKaQs2IV0SyMSX+Tl4ZABjLe2PpwHTnVGDQGHVYdZKekb2GJXSCHz6EwtbzShJ7gCvl+I2o5KgfxUnHApG3zsE452dbkatD0CJvr50gqYy9y2pbPFI5oN8vHO4yBNS0YdBcpj23Jgx4FuhW95zc19XPJ7Y3O4d3OlL0CrKiT0K0Cd2IIoO8uveDsRZdtEFiHzOMtqRMuupVE1t3UdTlA1rzY7R1VkjJkxaHU81mWW6uo6hxjlZHZuH7qG6l2OxYstauTPRE/H0UWoPvlfC/KRGmtD4l8BCLM4HMma64Nbm4TVbsEozCwbkfo/MTrfIHtRTnOy5xLIZZzZLbaDCuZArGEXTSvvLWaY0rppUfxarVuUPZyfDSjeLlOSk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(86362001)(8936002)(5660300002)(6506007)(450100002)(8676002)(4326008)(66476007)(66946007)(6916009)(6666004)(6486002)(38100700002)(44832011)(31696002)(508600001)(186003)(66556008)(2616005)(83380400001)(36756003)(6512007)(2906002)(316002)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmRHRDY0Y3NGdXZteDFkcWpJeDhHUUs0WDV4Z3g1eEMzM1lLeGtlWG9XTHJh?=
 =?utf-8?B?aGRQYUdqRlVWMDhPbCtHay9LMHU0ZnNhblRLR3lyamUxNlcwcmoycXU0VFp1?=
 =?utf-8?B?UXovLzNOcGFHbGRzM1MvOUpiaWFnZm92TnQyMGc0bGU3Mlp6eUtJdVVCQW1s?=
 =?utf-8?B?TjdrQnJ5dUFtaUlEMFZLOGtNdE00bU5qM0FEUVQrUVJpTjJkNW91M2xnRHJC?=
 =?utf-8?B?eXNJcWhvckpzOWZnR0FIQURBS2d4MGxVZTAxZ2lhbCtNei9sdnE2YXQyMkhS?=
 =?utf-8?B?UHF5bEhmdVVKVkxYd3p2eWUzSURxdHdLQ1c3cUdDdTJhN1R2UGhnbFhMc2x6?=
 =?utf-8?B?bzV4eEVGb1pZNUd1Sm5TallGdWxkMUFHRndJMDB0R0VBTHV6UmtFem5FTDF1?=
 =?utf-8?B?MWdMK3l3Z05BRXU3bmJyNk1lbkREU3ZPRlAzOXE5Z3RGSEQwaWF4aU4vcmxY?=
 =?utf-8?B?S0dLc3pLRlU0MjJ5RmNBdWUrV3ZvcHdidUhxMXo0THl4WDRDZmpqbEZjMHVI?=
 =?utf-8?B?VW0rd0M5N1ZRa08vd3dHTHp1V0h0bHlmdllwaGxmQ2tmenZjRW5BZjZxZ0g3?=
 =?utf-8?B?M2dLbUprazNiSFJHRnFoMDc3MllrNi8vQ1F4d3Niek54WHlkajRlL0xvc3Bz?=
 =?utf-8?B?THJVRnN1dm1wdy9kb0lQMzlCQ0dmQ0hZRDlEbW9LaDJTUTl0QkJLaGM0WndC?=
 =?utf-8?B?Ny9KUDEwOUY3OVJpekZTeDhRNXMrMkpNcXJtL1hrOGZYazhvdE9oOU5tQ1hR?=
 =?utf-8?B?ZE1jZVRod1V0eURyWlFKRU9GOXpoOUxGUkVhMFlVSm9YYXVla3dnWUNyMTVl?=
 =?utf-8?B?SjhodDhlL3ZPZGRIMGFoV1VuYit1MGJDRnY4QWlML0h4cldPVkpNeFRRRkor?=
 =?utf-8?B?TDZsdzFPcm11WjZWbzNsNXJiK2h3SGttRHpzNGdvWEdyTUYvYWpFTVZVeklW?=
 =?utf-8?B?QVhyS05aVE5ubVByd1FQSTBaZ0NmU2hOL1pMM1V1UmZQWGwxQ0hNaFRIMy92?=
 =?utf-8?B?UDJmWjZNeFQzci9TelNCVkE5cW9OQkc3bmVJa3BYRXBucTF1NFVqbzBZalhz?=
 =?utf-8?B?Qi8yU2FDSXU0NnBlRkxNelZ4NE50cW4zMjNvNEs0R09KRzJiL2k2b0tiWjRp?=
 =?utf-8?B?TDRUbXliWHVTMGhDUlU4cVdnV2IvOXEyTng5eFIyNzNrTDVjQU16WTVySlgz?=
 =?utf-8?B?UW5UWnNXa2hRRC9WUEFQVy9ISTNoZzlvdW5RR2lZR0ZGT3BjeVVPVEZZVnV1?=
 =?utf-8?B?YVVmR0hOanRaTGhJWWdneVpSYUFnL1czR1FPclVvZ0tOQkJYWmFyWEw0enpY?=
 =?utf-8?B?elcwN0llSlNJOG02K0ZqUkZvNzlTd2pIOHJ2QkdjU3E5Z3BCNlM3ZmhEbDdH?=
 =?utf-8?B?Ly83S1FVVHRnS25pRUdrRTQ2dHFOUzhhUExDNWg4ZnJlZDRIL2NpK1hsZjNp?=
 =?utf-8?B?ZnVLcDcyQmZadnJKcmRsS2NxQ3FpZG9KVGc4R2U1NTdQcE5uSmNnWC8yVU9B?=
 =?utf-8?B?Q3djWTZpSjFTdXc3aTBPb0t2N3FXRzIrSnp4aUNmVUJPcUl4NjVTaS9mZGRB?=
 =?utf-8?B?cXZTcG5aRUxhNHFoaHBaeU9kVERvRWxQekNtMmdRRDZGRlFhRXQvQXRtVDhG?=
 =?utf-8?B?aXkxd1NneUw5YWJUOEJnU3A2bnduQS9pRlFPTklENHdVS0VaOXVwaUc0bFZL?=
 =?utf-8?B?N2hwVVlxTzBGc1laZUVNaVNucXhDZklvQnRTWWFSaWE5ZXdtNEwyYjZUMGxB?=
 =?utf-8?B?Mk9LeTJlc0NpbkxGWVZPa2FlNThjZWdyTHBTWlRManF3TTRsMG9jc2RiTTRt?=
 =?utf-8?B?TVhGdGhPZ282T1NIa2MrY2EwejM4VzQzQWhVSDJiWmNSSGM5UURVRUcvd2Qr?=
 =?utf-8?B?cEFmcXhZQytqYXU1czRjb05WVTVaeUlVbElvamlmYlN3SCtwdDJjYTVnLzB5?=
 =?utf-8?B?cGErY3d6TWlBK3drZW5NTnhvdTRqM2E2Z3daVWU5OW1BN21GQ2xUN245SjJ5?=
 =?utf-8?B?djQzRjhPNEVYd0tIMGpwL082U2JMeXROSXRySVdiMFQ5elc0SHdGVmc1d2Ez?=
 =?utf-8?B?R2wxWVlwK1ZOZTJxbTI0TXhnUzJtYjB2WEVPM3pVZE9ZSjNLbWxuQzFHQkU4?=
 =?utf-8?B?Sk9CWUZEcmxmdnZ3Smd4UG1kTEgzd0JXK2NsOExLYm45ZWtLbTZOb3lUd3Fy?=
 =?utf-8?B?U0ZER21OTHVTd3lLVHR6SzVDRDhvU0k4QjJIRENtVktSbnZGeEw2K2VxTkw1?=
 =?utf-8?B?N1BNVVdYZXVjQjd3NHo1K2ZadzcvWUdjZkxLL0p5S2pveUZmcFQ3K2ttY250?=
 =?utf-8?B?MHRYTkhxVU0xOFhVL0FDeGVEdi9MUUtHWkFyVWlLZnltcUxHcWE2UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079d53a8-e5ca-45cc-14dd-08da1e658221
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:24:15.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xuBv6B1Nub26xZlTs+dQvJX96W+qHLYUJ66e2DuFFJHpI6aJ2PQTzDaDM0/Ul0RyBIGh7W+IIuUQbGByN4ftQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5409
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=954
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: slabo-a_xI2IzFDxOEFJn59d9PoxA6Nx
X-Proofpoint-GUID: slabo-a_xI2IzFDxOEFJn59d9PoxA6Nx
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch order is incorrect, I am fixing this in v3. Sorry for the 
noise. Pls , ignore this.

Thx, Anand

On 12/04/2022 13:14, Anand Jain wrote:
> v2:
> Rebase on the latest stable-5.15.33.
> Adds the following commits to the v1 patchset as they fix issues in the
> merged commit.
> 
>    ca93e44bfb5f btrfs: fallback to blocking mode when doing async dio over multiple extents
>    fe673d3f5bf1 mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
> 
> And this set drops the following patch as it is already in the
> stable-5.15.y.
> 
>    [PATCH 01/17 stable-5.15.y] powerpc/kvm: Fix kvm_use_magic_page
> 
> ------- original cover letter --------
> This set fixes a process hang issue in btrfs and gf2 filesystems. When we
> do a direct IO read or write when the buffer given by the user is
> memory-mapped to the file range we are going to do IO, we end up ending
> in a deadlock. This is triggered by the test case generic/647 from
> fstests.
> 
> This fix depends on the iov_iter and iomap changes introduced in the
> commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
> are part of this set for stable-5.15.y.
> 
> Please note that patch 2/18 (in v2) (was 3/17 in v1) in the patchset
> changes the prototype and renames an exported symbol as below. All its
> references are updated as well.
> 
> -EXPORT_SYMBOL(iov_iter_fault_in_readable);
> +EXPORT_SYMBOL(fault_in_iov_iter_readable);
> 
> Andreas Gruenbacher (14):
>    gup: Turn fault_in_pages_{readable,writeable} into
>      fault_in_{readable,writeable}
>    iov_iter: Turn iov_iter_fault_in_readable into
>      fault_in_iov_iter_readable
>    iov_iter: Introduce fault_in_iov_iter_writeable
>    gfs2: Add wrapper for iomap_file_buffered_write
>    gfs2: Clean up function may_grant
>    gfs2: Move the inode glock locking to gfs2_file_buffered_write
>    gfs2: Eliminate ip->i_gh
>    gfs2: Fix mmap + page fault deadlocks for buffered I/O
>    iomap: Fix iomap_dio_rw return value for user copies
>    iomap: Support partial direct I/O on user copy failures
>    iomap: Add done_before argument to iomap_dio_rw
>    gup: Introduce FOLL_NOFAULT flag to disable page faults
>    iov_iter: Introduce nofault flag to disable page faults
>    gfs2: Fix mmap + page fault deadlocks for direct I/O
> 
> Bob Peterson (1):
>    gfs2: Introduce flag for glock holder auto-demotion
> 
> Filipe Manana (2):
>    btrfs: fix deadlock due to page faults during direct IO reads and
>      writes
>    btrfs: fallback to blocking mode when doing async dio over multiple
>      extents
> 
> Linus Torvalds (1):
>    mm: gup: make fault_in_safe_writeable() use fixup_user_fault()
> 
>   arch/powerpc/kernel/kvm.c           |   3 +-
>   arch/powerpc/kernel/signal_32.c     |   4 +-
>   arch/powerpc/kernel/signal_64.c     |   2 +-
>   arch/x86/kernel/fpu/signal.c        |   7 +-
>   drivers/gpu/drm/armada/armada_gem.c |   7 +-
>   fs/btrfs/file.c                     | 142 ++++++++++--
>   fs/btrfs/inode.c                    |  28 +++
>   fs/btrfs/ioctl.c                    |   5 +-
>   fs/erofs/data.c                     |   2 +-
>   fs/ext4/file.c                      |   5 +-
>   fs/f2fs/file.c                      |   2 +-
>   fs/fuse/file.c                      |   2 +-
>   fs/gfs2/bmap.c                      |  60 +----
>   fs/gfs2/file.c                      | 252 +++++++++++++++++++--
>   fs/gfs2/glock.c                     | 330 +++++++++++++++++++++-------
>   fs/gfs2/glock.h                     |  20 ++
>   fs/gfs2/incore.h                    |   4 +-
>   fs/iomap/buffered-io.c              |   2 +-
>   fs/iomap/direct-io.c                |  29 ++-
>   fs/ntfs/file.c                      |   2 +-
>   fs/ntfs3/file.c                     |   2 +-
>   fs/xfs/xfs_file.c                   |   6 +-
>   fs/zonefs/super.c                   |   4 +-
>   include/linux/iomap.h               |  11 +-
>   include/linux/mm.h                  |   3 +-
>   include/linux/pagemap.h             |  58 +----
>   include/linux/uio.h                 |   4 +-
>   lib/iov_iter.c                      |  98 +++++++--
>   mm/filemap.c                        |   4 +-
>   mm/gup.c                            | 120 +++++++++-
>   30 files changed, 920 insertions(+), 298 deletions(-)
> 

