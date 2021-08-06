Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2633E28F7
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 12:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbhHFK6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 06:58:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53026 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231700AbhHFK6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 06:58:07 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176Avh1h003923;
        Fri, 6 Aug 2021 10:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=S9nFF1giuivOBBJ2J7z6YNCSgp6kZIMrWwprzMfOLZM=;
 b=CPCD0twKl8UGyJsYJbXu3VP/tTW36hgRO6N3kOvw31oJLMuw76v2HWeW4IwsfhySdA8M
 Rr1r4/HM+g0GREXBCEAfWzjwtCSc/6syLASyF9MxzcPp03vm21uPQHG9lEBLH61jUzWv
 SHyCkM9BU7AKjoHDWN97UGU2yv4K9TlL9jh97jUakHLPlcGa+H/aqv+ex2es3D5NHsDM
 Pby1Tn5uRiNuetPjlZ1jIsXBpKe4N2hikd51rHSQ9NRCitrLpqXckTZgajpo9klbxkaG
 PPVBcf3gJcCrLxN91H3srGmjgp9W71kSNkt/Eftlp3AzNq8qECDe4zROysb2aBQ/BXMW TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=S9nFF1giuivOBBJ2J7z6YNCSgp6kZIMrWwprzMfOLZM=;
 b=W7uD1kKiHszDwTNOpQl3cF0LjB27afUFHYS86ba/kmzK3PncDezH6bUrk1u9kqnb4VcV
 ExAiS+u+Q/yRVsOInfIfiNmHLw8ndoz0HGNlLpj2NMGIkFAOnFv2Z2sfDWkcDuBPkNoQ
 BHXg/hkXmsG5DREj/hdIADUmmlEeQ73AzArwO+zGl+rmpH8aDI/t+QcUJaSghvKtnkW+
 CRuxaVxT1nJr70LGL58uX4dceapAotZ3jEk9a+aRI82u6KeOsfd6kPoxifghOf3ukgWn
 X/DuYIRZ7BzQnm1cNUQ/EIWdvKW+bJXZBm0A73ZnFmKYS2NjukFoXCq0JpZK0yGcELcg 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqv4mxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 10:57:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 176AuGgp195109;
        Fri, 6 Aug 2021 10:57:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3a78daatav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 10:57:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1lB28URtCdQZi6cqbfxOasGJ8aO3cmbI2Rw/j2o5YmKyDWbA4bUiWZxVZav5ZysrokdH50E2VkKXKwAFwpGv+umqU11zuaoJ4T6n4fmsxyWw+W1HI4J0Pf1Y4YHcS59Kp9z6Te2hLnUlAVOs5vbGwSpEd5rOkZVCagEjBVBhl5/UyDFeMW05+ve/ml2mjPZ6Kg9/TuJvu43z2uHiP5HbD+mSMEikRoG2uaneimptO8je/qYpDE8vAbKo4Z1hFjfNqlGRclBa+HTmYcMBk/KFHRsdSUItkIWcII/kzj4C27FVBK4fpNzf75GfvZzuRseerYjRULukzFC11/oL49KNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9nFF1giuivOBBJ2J7z6YNCSgp6kZIMrWwprzMfOLZM=;
 b=ZG0TiZUV7wFCWbfN7I4EFDCMNymGf+GYEqPV42ZNGrAIv6eGGm1aNNphBAK7BfyKNE89SEuMqKzTXNlo2Tr6g1Gy8pjw6qDMCB8YnQSESmDEnlbirbAwUwNffdQpFi6ESXcfGOf3BSjUjz7bsY6PgLtb5aN9T7Na0zirth7BlSPR9MNMKiOpdlOu5wJKaqC+8mRZzzUBKGbbbD3myNTkFE4KHYSccl3hXj1KmYrA4tUkIwtxBYRPZ+m0wdSkfMeflMPADmGZsrbnaue2QpZB5AiRpPqplpPyyEoLk+FCeuHtzvPE5epNwmNJxJi0od8Yi1EpBwSimqkKPu3/zb5rPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9nFF1giuivOBBJ2J7z6YNCSgp6kZIMrWwprzMfOLZM=;
 b=Uug892HNRfXSwxHv3LhNOy4U4iONqV54uaNbTPPZZINP7ndUr/Si+GA6vHFgpa2h+ugI8896MB7fJTtt96b5dsPeW/6bzpGygz8GRPFULFkgXp29GOPXp4x0ZziZJL/QcyewhKhvMiIydbz57H5WyAsDkCniVX07Lh9u+oXgG/c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2930.namprd10.prod.outlook.com (2603:10b6:208:7b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 10:57:44 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981%4]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 10:57:44 +0000
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210805105423.412878-1-pbonzini@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
Date:   Fri, 6 Aug 2021 11:57:38 +0100
In-Reply-To: <20210805105423.412878-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0075.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by AM0PR01CA0075.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 10:57:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f2a5439-2812-40c2-1ff0-08d958c90490
X-MS-TrafficTypeDiagnostic: BL0PR10MB2930:
X-Microsoft-Antispam-PRVS: <BL0PR10MB293030C9A0BF735280EA2A2BBBF39@BL0PR10MB2930.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBwg4aTdu+oWqvLuHYJgIw0j2DlNC7G3Jl2e9g4SLa9Kz4fld9dKIejearKNFmdqKqkh1SNccnKiv5kiqxz3nv72l0v+q+5fYAFXVvOD4R4e/56puixYIrm4atIQ5V11F+2ftMN3iYb1R1XdeeCgjyn/fBvrLyD5jqszseDJTG1zx010eAZFSRc+u6LjAW8VIMqQr24azuHPO3dmbeuMIb4AGjnNB2HkjSMXESmC4TIpG4TzjGXKIaPuCMFP+O0aoz1F2ZIKQYZnj20qc7XqCKoDpy/T9zannXqgbhoQISmZPBQieaHKBzISeW9T/WVf1z1POQ29zlNEJVjFopAYQ4SdLJ7UwNfETkFiy5i0QgpNWF45WOPQy+iRzjcw8iws5/3/MQ9GV/8Yx2I8TtNAtdumJJb1ec+SGNKVNr+csREN6fB4A89VUJaDoka+ZIupZLAq9Y+Ph4PMqYQwIfXnHfwDVI6u9Jj9+wy7xkHjKQfZ1nFthffScJ4twJy4XmQbl239lGYI35xgrghnymZlqNxLAnQUHhNSFWNPBxd16scTyzszqFQvv4Pii+EyG/UfJ/6LrrV19kUMrcfa5XtPtH2f8DNSu7jIOEI//nsUS9voPgI2GHQ0idYGFAD5EkAQafe2Z39e9a2cF+UciCkPIhsCTXQwclpc+uIg1CuGIdx9iHxUxPHvWnFyJtI9L6TVOlIuWIMS0GKPRoAvERgsXq0qMNNWrQW221CWWI63l8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(5660300002)(2616005)(966005)(508600001)(956004)(4326008)(86362001)(66476007)(66556008)(66946007)(38100700002)(83380400001)(53546011)(26005)(16576012)(316002)(6916009)(2906002)(186003)(31686004)(6666004)(36756003)(8936002)(54906003)(6486002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU9HcmdZU1k5RkpDSU5hUlV1SnVSUW9nUk1TYTZPeU9SVUhuK0IwSHhSMGNO?=
 =?utf-8?B?c2NlSGVIeHdCbWN0ZUE0RWdxeE9PQVdzT200SThSeHlJUW9YYzlyS2NwRDMx?=
 =?utf-8?B?N3c2Nm1LYWRNdWdzc2Y5dVZ1a2FKRHdrTXA4L2EzNTRZT210UTJQWnRNaWsy?=
 =?utf-8?B?T0hMeERxd0x5RnpuOE5rZ1o2NmN1bTUwczlHTE53N2RmQWx6dlM0cXVjUmh0?=
 =?utf-8?B?R0NkcUF1bU1HNFIrSUc0QXI3bUNKMFBwNEhPR0xYTkl3Wkp3dHhhT3ljWm1m?=
 =?utf-8?B?ZlNZcGFiT3JJSDR4WVp2K0xqYlJZTzZRNWJUSmU1OUY0cnNFK3hBUDhkME90?=
 =?utf-8?B?RzYzbDNwZ1FFUi8vb24wUGxvN2srakU1VEthbzkzTWNvUFB5RitCVG5rYmxR?=
 =?utf-8?B?U3czbHgwLzVPYkVxcCs4WmRWczZ1b2JwRFZ2dmpMdmNCVG5WeldyWTgvVTZX?=
 =?utf-8?B?MEhyaWo4Q3hrSnlPRnd6QjFrMGRYVTNLV2xWZlRUL080WDBvdHFSNVp4TEZm?=
 =?utf-8?B?OUg0UjhDcDlZUllSL2FSVTdQanZZQnZ2Rm1INEJzV1U5MXNKcStpbmJSVkVU?=
 =?utf-8?B?Nmd6bXJYbzJ5ME5WcjQzV1kxZDJwMHl1eStZcC9nbzRHSHU4NWE4RWYvRCtD?=
 =?utf-8?B?MHd2Ym9ZdzdxNGp3dnVNaEk0eEhPSGxkRWE4K2lmTEZlMVVqb0xiVlFLMGds?=
 =?utf-8?B?cnppVW5welpNVTFVaEFZZVZqTE1OdDRmcyt2RTNQQ2FReGx6TUg3TVQ5bHEz?=
 =?utf-8?B?dHdiKzFuQXdjZWM3RW5IUmFSeXd4bUQ3TDVrb1FORzR5VytGRDVILzRobHow?=
 =?utf-8?B?YzE4MThUdTl3N2xTamJkUXpVZ0hmL1R2YTJyZktOcE5zajJ5QWtDNDEzNmRO?=
 =?utf-8?B?TzVvTVFOV1FrcjhLbjJKaEZlTlFPOE9tTmQwTUpIYy90d21PT2VmajV4MjlE?=
 =?utf-8?B?ZjlIbE1iOFprRTRIUUxOdUxnWFh0OW5PTStHZDhKcThGb3h4b0ZhN09KVk5V?=
 =?utf-8?B?UWFpZFJFOEw0UFRkRnYyN1o3dzdlMzFtZDdjMGlITERLT29wdTRTbG1zeDA0?=
 =?utf-8?B?cVR6cmlIWnZBV3ZoZFhLYmRwQjJURVBqbjdWbFRaa2s1bXMyZHIrd3RlZDN5?=
 =?utf-8?B?U0RIa0NVdkxWVXhxVzB2ZlNDRWM5cWp0R3lpalFOUzNhR1lOSU1WVW1pcDZp?=
 =?utf-8?B?ZkUvZ1JvZ00zN3JzYVF2amZ4L0U4MGwvRnhRM0ZzdmRTeDc5eWdUZlY2d3px?=
 =?utf-8?B?bmQ3d3VuQ1JIUnI4bS8yUG1OWDFLQmFCUU52TWIwL0VieFBobDl6U29odEN6?=
 =?utf-8?B?M1RUQUwvUTlaMGFwd0R4MnRSd0tsOEpLc2UzWm43UGVVUmRVcWZrU3cvTVpk?=
 =?utf-8?B?ZlhLSmZBUFpWSWpkZkRNSGJQR2JpWDJEL3daZTVFRlp1WWZjZDZRcENiVlQv?=
 =?utf-8?B?bWFhVnYzNSt3QWpMZHpoWGxucTBTdC9FRDUyUUhJODFwSHhxVzRtYW1CZUtw?=
 =?utf-8?B?UHluNGduS09PVDNDdDNlNkR4bHZyTUFjbDN3ZVpBZWlYWVZTUklLWXhxeFdP?=
 =?utf-8?B?dXR1TFZaUW9BSzdFUkUwZzY1MGx2QUt0WDVXVElLdlh0TDZGWnpzS2FHOUpa?=
 =?utf-8?B?MFlPY2t2WnlFNE40ajRZMlVOajdLdk5wRzJRTUVDSDQzeFJSNTR3WlBnaEVE?=
 =?utf-8?B?SXZZV1JoYmpmU3B5SC81WEtaRnF0U2FSSjZnYi9HWHpKMUs2cWJjUEpYRlUy?=
 =?utf-8?Q?hM7G+mfKHgpBLOz0TSFVpsATL0nJd5JW3XlXuGt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2a5439-2812-40c2-1ff0-08d958c90490
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 10:57:43.8647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VtFzqXj9iXHkY9wQcMP5a0qpavI/5WK5Sokxw1spaiZ/3A/j+HOj78ReZVvb7H7IxjLgKOY5x3JBjfg+aat9czShCEPZSmpfAZbixILDxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2930
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060078
X-Proofpoint-GUID: 7dMN0P79KYAbbdVHSaqX-DZFJOyFpSBk
X-Proofpoint-ORIG-GUID: 7dMN0P79KYAbbdVHSaqX-DZFJOyFpSBk
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/5/21 11:54 AM, Paolo Bonzini wrote:
> Accessing guest physical addresses at 0xFFFD_0000_0000 and above causes
> a failure on AMD processors because those addresses are reserved by
> HyperTransport (this is not documented).  

Oh, but it's actually documented in the AMD IOMMU manual [0] (and AMD IOMMU in linux do
mark it as a reserved IOVA region i.e. HT_RANGE_START..HT_RANGE_END). And it's usually
marked as a reserved type in E820. At least on the machines I've seen.

See manual section '2.1.2 IOMMU Logical Topology':

"Special address controls in Table 3 are interpreted against untranslated guest physical
addressess (GPA) that lack a PASID TLP prefix."

 Base Address   Top Address   Use

  FD_0000_0000h FD_F7FF_FFFFh Reserved interrupt address space
  FD_F800_0000h FD_F8FF_FFFFh Interrupt/EOI IntCtl
  FD_F900_0000h FD_F90F_FFFFh Legacy PIC IACK
  FD_F910_0000h FD_F91F_FFFFh System Management
  FD_F920_0000h FD_FAFF_FFFFh Reserved Page Tables
  FD_FB00_0000h FD_FBFF_FFFFh Address Translation
  FD_FC00_0000h FD_FDFF_FFFFh I/O Space
  FD_FE00_0000h FD_FFFF_FFFFh Configuration
  FE_0000_0000h FE_1FFF_FFFFh Extended Configuration/Device Messages
  FE_2000_0000h FF_FFFF_FFFFh Reserved

It covers the range starting that address you fixed up ... up to 1Tb, fwiw.

You mark it ~1010G as max gfn so shouldn't be a problem.

[0] https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf

> Avoid selftests failures
> by reserving those guest physical addresses.
> 
> Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..d995cc9836ee 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -309,6 +309,12 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	/* Limit physical addresses to PA-bits. */
>  	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
>  
> +#ifdef __x86_64__
> +	/* Avoid reserved HyperTransport region on AMD processors.  */
> +	if (vm->pa_bits == 48)
> +		vm->max_gfn = 0xfffcfffff;
> +#endif
> +

Not sure if it's worth the trouble having a macro with the same name as AMD iommu like:

#define HT_RANGE_START                (0xfd00000000ULL)
#define MAX_GFN			      (HT_RANGE_START - 1ULL)

#ifdef __x86_64__
	/* Avoid reserved HyperTransport region on AMD processors.  */
	if (vm->pa_bits == 48)
		vm->max_gfn = MAX_GFN;
#endif

It's a detail, but *perhaps* would help people grepping around it.

Also, not sure if checking against AMD cpuid vendor is worth, considering this is
a limitation only on AMD.


>  	/* Allocate and setup memory for guest. */
>  	vm->vpages_mapped = sparsebit_alloc();
>  	if (phy_pages != 0)
> 
