Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE933E437B
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhHIKBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:01:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5138 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234048AbhHIKBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 06:01:00 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1799kClr027667;
        Mon, 9 Aug 2021 10:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DGkMABzXZz4qUnDGSCWlcuaOiFexN+W/cfQw9/rL7MA=;
 b=J079aAZJhuRlWJFuTk2wLUkpCh/uHn6CJJ9EobT7GHDjmicqpvvZP/y6/dsS8be+kWrQ
 4iqE/tun4XapObN+JHi71t8PPEAAm6v2mYQH1MnIvv+Bu+d3nvTrZ9fQ6umeDMInM9zR
 ISIgMe84nffvWc4P9TjRkmMTQfB7HQ1lOesyDD7YYqTfybyGn4+XCvnf3s/D7T7nPxrI
 /MlD68luKG8eS+DsM72wbyG9LtelOPXl/vOzWx4HZPn8+x4zHJSDCGgLy/6dkdDaGyes
 mwDA7rTtMob+TzrxQBDtZlpYkfFWCFm3Epvff1FfhbHaFomthXHHpqQ7AlI/7sC5s0BK Rw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DGkMABzXZz4qUnDGSCWlcuaOiFexN+W/cfQw9/rL7MA=;
 b=Fo7NpuHQqcLhKlNZeKQTOPo/suYih5CO+dBcfP8QfAydp52BZNkOzLCCt9n54ArFG8DS
 xCPELKom0GueKInMqWXKChb1J4bo85ZEEj/gRTqRHbIRcpEyO0A36vy5kZEuuVHY7f/e
 1/jHeLP6uX6enhfxuRSLcuA6870/bKwbMdrWic5vWZDcckvCU6+V2+zuvwnDceMNo3Xc
 AhbwcE4ZSsXuvNvwP2B4Og0fVxKEqBiy94iekSmjFDZY40J5qiLkbizKvN7+eb3TUULN
 5X3HT8K4dM5cWDPFE0bydmfvNIAy2IzOiXebjxvMIR7ZjV09aVHuArLvHTtbEIqEFj/5 rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaq8a8wqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 10:00:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179A01gp170305;
        Mon, 9 Aug 2021 10:00:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3aa3xr1n2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 10:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqntdGseQ/1FBi5aGccb0i/joFKY/oscSc1d5qP8SSZC1SsqRoLsisAI/7w0+zSBV43+OmxhVcBYVySI3o+McO6SWRwRvvqofBhY7YccqrfF8JqJdgw9USnmcd927l3T0zZzzT2pgpTfmX8niuoBVVpoD7dAbRQmG8sdsjoGFisXr1kI+bwCIiZ1aNdQrVHVfS+ifx2SlljWdiaPastnx/izdyWyPs1uDHaZ/ZoVouGRNGc0HkiIvjXThh3gLHY/dLJ1fFUHjsQVUpsjGoJVabeeQZdrfvo0bvCxPVYhwqBg9A5vSIcqIjII/c6/zzqKaHS5QgL4CtHSU8aa5f9VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGkMABzXZz4qUnDGSCWlcuaOiFexN+W/cfQw9/rL7MA=;
 b=fuofkdz56DylMXqlGBvix6SnAQkaukTfcP+Ow4Y/7WglX3jUILX9wv1dpSUP/e6X9ghjDllOaBA7JKCZC+JHQ+6GeO9rAvJrJ5g+wIHbDkI5leMycPsvQlVpm6F4l3Iaw762K3Gsp8unRmAGk4liD41oqZJeWr7M3O0zfY/9PLl2Wac2/fadUzxo+dCNKwnCjycDKkbFTMEYOzYGcjT452fSeA4BA9PlgwH3UtgZ80t8uU2uG9rYWHSXUpYoiEWRuqpq6eGe3H3yk8IXs7V3r38W+5NC/hEGzu4dikog68VoMeYRfrk3Aaj9psbMfckdZ9/24yEgoWVadci6uAKOvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGkMABzXZz4qUnDGSCWlcuaOiFexN+W/cfQw9/rL7MA=;
 b=eDWuT+at4XVB5S+C8GgDAhU+GJkLWFlZoAHlH15Q0ugOwMTOGyLS9BEzPrmNgx2lUzVtieFi8b8AKPGNjDqtszmQsWlfxHfLiO3r7ipmu9Cdu8WHoWx8JbW+lPMzhoMvgptsUWhuk18H+w6C4ufdKcpHHRhYyvhyxB+GJjmXswo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 10:00:30 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::31f7:93c3:6886:1981%4]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 10:00:30 +0000
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210805105423.412878-1-pbonzini@redhat.com>
 <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
 <5f3c13be-f65d-1793-bd91-7491d3e149b0@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <bab67d1c-f9b7-0a91-2d4f-9881e3f47218@oracle.com>
Date:   Mon, 9 Aug 2021 11:00:23 +0100
In-Reply-To: <5f3c13be-f65d-1793-bd91-7491d3e149b0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO3P265CA0010.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 10:00:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48fd944d-83ba-4439-eda1-08d95b1c852f
X-MS-TrafficTypeDiagnostic: MN2PR10MB4128:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4128F62426401DC652AD6ED0BBF69@MN2PR10MB4128.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5kc17lq4U61iadbTKH8jJZXKfSR/SSfNAAHpFB7pLf3aXTJ0s3KPEyyOwAutnbEEt+HKDBBKYj3AzdJ3J2nnG01/SM1R8B9wgNIbFmc72yZRhSocYk0eAs/Oy+9Iof4CfgzlmmoS+VYGewudA5VEmNjtGNthqyZeT/ROm9T54wMoYcO6gi2NCcdWwqyZoIuIZmLnalYoh22w22BuJvA/G5pI6wTJl5SJL19zOprfIW6n+c7cqAcF2wEJZUr4U95mGS9jjovkWVCIEVN/n48lOFSMebdlTCbQRsCJFqJdzvYHW0l8OXgZGweIUym3HRQs5wBBVpe9+zAmxR0wCVkX89t5Cj2rT/i+1DwgNV93D1+FyPwPygNXfh42RQowtkp6YQO/fzgZ1vjBpzbt32cS0MLT7ibNE/C8P6V8JPqEeQGUVZQZ4VE7PyTM0P0+30qplKXt8C2OP9L4Ye+UxVFSiCV3FQ4vhCcyk+8MbLc8PqVbR9VDS6mprPdbqH/hVc7txo4OKTsq0+NgzMz5ljUirydbZeriUJdxTCFZLqEtBL7b69pYK27BjfrjT86Pkrsx2MrH8O41otmnwp9c/Z9O4S7EVaJDLQfTFyBDVrn/3W2URafn3NTt8l4bgas8x477U/EO6M6rOAKpG9Nw8euPqDRIpp8ahgOENrGSWFtTQM1zGEF2aVhoRDkOhey75qEoNLMasEOFtMEFNrZTfL8Ngnyxoz0Vv9B9lkg3M+33DGsbUe026P8KmgLDOKXGfgSmcbIdSTAEhf2wnIeL1dCAhf4kwbuGZtBq5PlAWo0EZHbXMQekM3+WBBaE73/rnSF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(8676002)(4326008)(186003)(956004)(2616005)(38100700002)(66946007)(66556008)(66476007)(5660300002)(966005)(6666004)(36756003)(6486002)(478600001)(31686004)(316002)(83380400001)(8936002)(86362001)(110136005)(31696002)(53546011)(16576012)(2906002)(26005)(43620500001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1MwdkdJZThXdnJKWEN1SSs5UFlxbXJoSHJCT1hGSHhJemx6dGdoQnRpTk1Q?=
 =?utf-8?B?OFBidjRSNHRub29zZmp5eDdWNENEd3pjV0ZnQWlHVDVoYzBvMjlVWkM4NkFu?=
 =?utf-8?B?TVZORHRmT0o5a1BkNjdLVFVFK3FhWmMyVGlManBheHVFZlNwZWl6cmt6TDF5?=
 =?utf-8?B?WjFWbG15S0EzMVFaZEk0c1hnVE9LeTBOY08rTjNyYm9JNDVSaE13ZnVhVnBq?=
 =?utf-8?B?N3RxZDFYRDdyYWU0OTNUYTV0OFFmbEptVWtSaXlla0pVZTcyNVhXYmlBb0hw?=
 =?utf-8?B?Y05Rc3Y1WkF6S0txRFdoNVNSUFpZZVgza24yMFZPanpCa0UwTmlkY0ZXemdz?=
 =?utf-8?B?aXdIWEd4RnlzMGR1bVdtM08rZ3FsVFV6UE9ycG9HNlh5aXFVMWdRM0kwVVov?=
 =?utf-8?B?YmJjd0N0aTM0TlNuODl3Z28rM21GRUY0V3lsQU42N09HSVhMN1lXanUzOThS?=
 =?utf-8?B?MS9EeXNhRDZOV2lGcjN4UndtVWE0VGlSa2g2d3d4OTdsMGVpQkVtNEJZL0U1?=
 =?utf-8?B?SGlPcTZOQzhQeXduNEwwc3pSWnd4cGhKTXVvSzFsWVRBblN0TUFHOE1PZTdY?=
 =?utf-8?B?bU9MOGkvMTBrK2x4eDdaMFdjRzBERlNsQW9ycUJxbnBta1Rab2Y2UFNvMHpx?=
 =?utf-8?B?VGMzSmt0MlhNcXBQWTM0aEZOK09odWRQUzdwOE83VVozYXRmQ0xDN0xQVlho?=
 =?utf-8?B?ZXF5d3pndEdVSmNEV0RBYllkMzhXdzJpeFRnSmdvTmVBM2RBUnp0TFVEVFBZ?=
 =?utf-8?B?N0tzai9wblJzTWE3SjVOMDZHRm8zOElvS3NzUzFxa1FPUEhGTlJnTWg4R0xm?=
 =?utf-8?B?VVRDZFkwUG14NHEreTduV1V3dW9kSHYvVU1CTU1DMkV3dXA1RHRuaHU2OVVk?=
 =?utf-8?B?RUNqRFdRUzJqTGgwalJOKzROei9XdCs4NzM4VWtMTGFrZGJyanpCSTVFMFBi?=
 =?utf-8?B?Wk1PTVVXVnpvMXpXUXhsbkg2ZzJyaGp6R2lqY09LMkNoME9WRzJZMDB3eEZJ?=
 =?utf-8?B?ZVUyUkN4dEdUNXRCVXZ3OGtlTTgxa01ITFcwWEt5cDVIVklvb1NDTUpmSnd0?=
 =?utf-8?B?WDgyakpudGROZUVtSkp5OTMxa282RHBtYVJWNVpsWlpWNzV2YzVSOThKTWlm?=
 =?utf-8?B?cCtCbURhV2ZyKzl4dGo5L3p1SWIrSEpEUGhPRXh2ZmU1ZFdxNjgzMVJyVW5S?=
 =?utf-8?B?S0NTNVdQVGYvSjQrcDBtWU5uSG9zbGJxNExHZXIyQ3h5Szc4Rmx0d3J0YTdZ?=
 =?utf-8?B?dHpHT0QrWUUwQjJESEN3bTYrNU1OSHVNOHVCanB4NmREeEhPQXJoWWVzNmdR?=
 =?utf-8?B?Z1REN2RoL0NHbVhFU3VwQmx6bVNsTnc3N0FUZXVuL0J3TzJTdndHNmJSa2tQ?=
 =?utf-8?B?RDVSZzhBbDQ5TWRWeW50VUl6TW9XVU9YcFczaG1nTGZKU1FHK1FsV1FUd0ZC?=
 =?utf-8?B?YUJSWFdSamZ3blJURUt5bHJCVjQwdXVwekxBYnRxZ2plWExYUzlVQjJncFZB?=
 =?utf-8?B?SHRaRzZmb05iWkxUU2l5cGhWSk1UdU9qRDZvb2VJOTEzSXR1R3hlcnhlaHR4?=
 =?utf-8?B?dlpEeURNQWpNdWxsbUYwM1dBVDRUa0dDd0F2THl3MGtDTFJqTXFSYWdGd2h4?=
 =?utf-8?B?NHJ1OVJ3NmFDTXVZbTVxUDduS3BxSEp1cWtvVjRqWnBVZUZ2QjRUaXdvTTN5?=
 =?utf-8?B?YjhEbEU1TWxVS2diT2FsVEU0bll3K2lmVThzNk91ZXY0U0o5LzNkL3dMc21J?=
 =?utf-8?Q?ud2DcRQGPeGId6aZKKMyK7fX7fgZH6klzQnBb+Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fd944d-83ba-4439-eda1-08d95b1c852f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 10:00:30.3070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NxHtMDKglR5Dl6EFz/+MbKPiHEiJF0jgG1S0uw2eYNsYusN9iWaC21PbLjiO2+m6y9xCqxy91zbvbgkBZ1tc4LOVTFI+njJVBmz1uAFdFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10070 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090079
X-Proofpoint-ORIG-GUID: QcpYXBVnIb8tpJmIfaYiyYOR3CT5n_Bs
X-Proofpoint-GUID: QcpYXBVnIb8tpJmIfaYiyYOR3CT5n_Bs
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/21 10:03 AM, Paolo Bonzini wrote:
> On 06/08/21 12:57, Joao Martins wrote:
>>   Base Address   Top Address   Use
>>
>>    FD_0000_0000h FD_F7FF_FFFFh Reserved interrupt address space
>>    FD_F800_0000h FD_F8FF_FFFFh Interrupt/EOI IntCtl
>>    FD_F900_0000h FD_F90F_FFFFh Legacy PIC IACK
>>    FD_F910_0000h FD_F91F_FFFFh System Management
>>    FD_F920_0000h FD_FAFF_FFFFh Reserved Page Tables
>>    FD_FB00_0000h FD_FBFF_FFFFh Address Translation
>>    FD_FC00_0000h FD_FDFF_FFFFh I/O Space
>>    FD_FE00_0000h FD_FFFF_FFFFh Configuration
>>    FE_0000_0000h FE_1FFF_FFFFh Extended Configuration/Device Messages
>>    FE_2000_0000h FF_FFFF_FFFFh Reserved
> 
> The problems we're seeing are with FFFD_0000_0000h.  How does the IOMMU 
> interpret bits 40-47 of the address?

The IOMMU supposedly makes an invalid device request iommu fault event when touching the
reserved interrupt address space. But that presumes performing DMA from/to device with
said IOVA=fdXXXXXXXX (doesn't matter if it's guest or baremetal).

Oh wait. You asked fffd******** not 00fd******** which then the spec quote I gave doesn't
document what you're aiming for. Ugh, sorry if I mislead you and Maxim. My mind eliminated
the starting 0xff when reading the address given the similarity.

But I've seen that address range somewhere. This errata might help [0]? But anyways, it
doesn't explain why how this is interpreted, just that it is 'reserved'. It doesn't look
to be HyperTransport address range either as that would be the 1010..1023G range (close to
1T) as documented by the IOMMU manual, not the 256T boundary (fffd********). It's
interesting that fn8000_000A EDX[28] is part of the reserved bits from that CPUID leaf.

[0] https://developer.amd.com/wp-content/resources/56323-PUB_0.78.pdf

1286 Spurious #GP May Occur When Hypervisor Running on
Another Hypervisor

Description

The processor may incorrectly generate a #GP fault if a hypervisor running on a hypervisor
attempts to access the following secure memory areas:

• The reserved memory address region starting at FFFD_0000_0000h and extending up to
FFFF_FFFF_FFFFh.
• ASEG and TSEG memory regions for SMM (System Management Mode)
• MMIO APIC Space

Potential Effect on System

Software running a hypervisor on a hypervisor may encounter an unexpected #GP fault.

Suggested Workaround

If CPUID bit fn8000_000A EDX[28] = 0b, then:
• Hypervisor software can trap #GP faults that potentially have this issue and ignore #GP
faults that were
erroneously generated.
If CPUID bit fn8000_000A EDX[28] = 1b, then the issue has been fixed and no workaround is
necessary.
Fix Planned
No fix planned

