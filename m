Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441DC36EED6
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbhD2RZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:25:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhD2RZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:25:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13THNxFM111997;
        Thu, 29 Apr 2021 17:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OOJtVHQ1/jvIQWedMBNGlDZ9QDjjbi6QVYg5PB7ia/0=;
 b=BJ5yjw7zxdKPZKFdO1hS0tuPTAhnXqsycBkhKBo+ZM7U0XBTPvkP/3CHqUwF6jBJYSQd
 URXWqjRx2kWElX1KIGK0oAjOxORcSjmV+9Qphxg9njHevHdccboqx62Zj/4AEiB6Niq1
 z6sL00H/qGet3dYxzNyxB+8SJuLurZUM5gdUjgFfhlBVemOtejGDmicnzN1rmslFroV8
 UWwPVivY9IHy2NBEctK9mHYAAD/AeQENokID/9nLiYPnWbDofuQ6jNVpx6qwJg3LD2bI
 /fIiAMy05rORz6tlooRkPxX3nDrLMz43o+qDYvtijBqWLRLIsZoajFEpqcEGPy//8doo qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 385ahbw709-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 17:24:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13THKiaA013271;
        Thu, 29 Apr 2021 17:24:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 384w3wkfdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 17:24:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNPwmV3V5ibxlcGzP3rtwkD3HtSdhI5SDlzuWVcGq+28pxvs0SzIIihKMvZ+O+6WVZ/K/IGDVuigeAttLMtMRrECvGO6kQ34UNK2/RpgC0d5M7o3aUNGJcjWyKqGPhIheOf6HO1BoYx+Q35ZhydUOVly2dP5x7K2RKTmZ365fwg6fP4O4iRwrp+2hm3Vi9hPY1cQusQvcvsMtTnNJ0+HsIfnZhw+xKhcpqB2ciVd8vhwEQM2EavmW3qs+feY6GP2XBo8JTsgOHHdgHgbDh+ks5uMJb+ijXJPuxHYnZOxHrC81mXInLa8A9Muwm2UgoCUsp0G9KMVBL2bEWpU5IRcIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOJtVHQ1/jvIQWedMBNGlDZ9QDjjbi6QVYg5PB7ia/0=;
 b=EqMEsUfG8rm6ZQGz14/d+YdXVDphH9liufTvn6JSKRNEoxeBsko7/ewrYCqVLIUFrdyaCEQe/+lGJF7BYm2idSpACq5PAi16jGefOmEERyZ8cabiCaNaFeAcZVNm3HrTmhMlo5xE4cmCpPXI9AMl51A9TjD9g8RKe5si4tt25RZk3n34RFbNOSSy7uEPDqTODXXqBi6FkAHEpePnvnyf3l8cq9M8Gv4qUEIHnGZ3XvUN37LLGvb2eElvNoSvYn1xtgtdzU0eImIiF4oSSY78E3fmcDzBo/OiK8AJvSbdq3oNB2kZNB60I0NBMnPMYgKV3TIiMggnlZFxhuzPaK6gSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOJtVHQ1/jvIQWedMBNGlDZ9QDjjbi6QVYg5PB7ia/0=;
 b=qPdYSsB3x/LUJIFGde7nE91rDYTNHVOr3cpVlhJZThB5gQQBVCAKXec2oo+vdbr+RRuosb5KbuBGgcMNS/enuiQ0ISvfI+4RECURPtsysSM4yr/BCNMRCMV/t1xpnGK7CbJ3nItEqXaRPTRo/UnSq7Li7t7zDgcqlbXLzqqPCl4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4300.namprd10.prod.outlook.com (2603:10b6:5:221::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Thu, 29 Apr
 2021 17:24:09 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 17:24:09 +0000
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
From:   George Kennedy <george.kennedy@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com>
 <YIjrQdJtpJ0br5m9@kroah.com>
 <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com>
Organization: Oracle Corporation
Message-ID: <36779f96-2314-fd35-7c02-accd6da0be56@oracle.com>
Date:   Thu, 29 Apr 2021 13:24:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SN4PR0701CA0004.namprd07.prod.outlook.com
 (2603:10b6:803:28::14) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SN4PR0701CA0004.namprd07.prod.outlook.com (2603:10b6:803:28::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 17:24:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d51b947d-69de-4c4a-4951-08d90b339903
X-MS-TrafficTypeDiagnostic: DM6PR10MB4300:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB4300D173F36A0FB9B20DCA36E65F9@DM6PR10MB4300.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWS72M9aKDeQmg5jv6DtybUKQjDJUREc9SNdbtnNbl+91rCvUqiqetuvd+TEp2q9xFJCw8GtYV3hbbTrLg2E/v2Hs/JyyvDcVIX+NBtcGP2tAt7ZmE43VKXEIkEcGSEN484MY2aI2yWk4y8iJu5hDgSP+etZaOy/FgDLscWrRP9pHSkmgUZX3rkZoM1Y3Cw68eS/kvZ6nE+upM/yrW9PnPWfJlLco2DjTc2Px+o10NQlc0pGTSbfbl069y9LaxUTLxwb8L12KkSBg3wv5MnsW1DKw3LvtENLFP/z4v9YbY6nmp7CertIRO7q0+XGuiPdYu6PEDTcB6J2CQei0y4uX56muPklZd2VvLbZK8EaSCd4Nc3EJ/Dy4pIbpi95Ebs1H/m6vU9QIZyGDnNpAkfRk96XtCNz/Z+BxWj0qiD7AP93DLMID5TzKzzg056o+fJsyZNc2HP/64Gxg7tM3XgrsqNw9NmmTf0aJ/djyI7prVRR9ykIqjA6Y3K2dKRwXygfLC+tRNITq1EDBjJoxMDhCQodYBXupDAFl2j8J33hOv1BjF21xsjox+xXdyNk04faHQ+3uk++fC867te7JoE6h3jdeN2dZ0U4wjin+S7U0yGXe5kgHhzKVs5VZxl3GyQ+whRpEdddP+VWtYZJMee1a1X4elA1oo2SIDpE/vdyIByw8Fce/YSgPESF+IYwdbB7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(346002)(376002)(478600001)(8936002)(8676002)(83380400001)(86362001)(66556008)(66476007)(6486002)(31696002)(66946007)(956004)(44832011)(38100700002)(2906002)(5660300002)(36756003)(36916002)(16576012)(6916009)(2616005)(26005)(186003)(54906003)(16526019)(31686004)(316002)(53546011)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SDVPRjhZSEhYellFTmMzQkNRZWNZVVNBUXlRQ0YxdmNvYzNCTzI4akE1YnRx?=
 =?utf-8?B?QlBTdUM5WjIvZ3p4RlNBeXpMbG9tK08vd0UrcDBnUWRIdmUvS3JYOXdxT0dE?=
 =?utf-8?B?ckZlTlM0eWgwK0Vob0ZTVXhEZ2dlK0g2R1dyNHdMS3F1ZjVGNUlhVjNDL09K?=
 =?utf-8?B?Q0s5WHk4Wlh6QkhBM0REbzk2Vjl0M0NEUzdzQ2hBOU5RZDRKL2ZwKzZLamZV?=
 =?utf-8?B?aGdxRW5zbTA0bCtURndxMHZFdWlDTktVUTBGZnFaZ3NmdHZ3aXB5T291T2FS?=
 =?utf-8?B?T0cyb1pvSmt5bEtRaVlKb0M3TDB1Ty85Rk5YNDVPT2t4dWIwUlRmOUJHb2Zh?=
 =?utf-8?B?ZTRjRjJBRjE1cEY1Smk5QTBFc2FqN2RRUTAwZjVqbVpxVG1BZnQ1RURLRUk1?=
 =?utf-8?B?NitqSCtqZXlqZUF6SjF4U3RrQ0ZEVDFoSHNXWmdWWFJIUTRQTDdBTjdKalFk?=
 =?utf-8?B?YXlPSnc4NGdRdXhZai9NM0xHcEczNU1JN1Fld1RONzlGOUFWeGtlc1A5NWIr?=
 =?utf-8?B?WE51VGRKYTgvTXErY01ZWlprNk5kaXgvRkloS2VrcmpuUzdJblFMNEFWTXFM?=
 =?utf-8?B?emhzZHYvazhiYW5SbWxsUDRFdnpVSWlscklVYzdsQVp2dkx5eEpUZEl2c3Fy?=
 =?utf-8?B?RHg4V25Xb3BVTjJDWmFKb2pRTWRtOG5zaDVnVllhZUxZcmxCOXl2QXNNVkVB?=
 =?utf-8?B?RTI1UFNxUFd2MGRNWi9uL1UrMDMzd1Axc01NeUZMQWhicVVmcVduWW51SEZP?=
 =?utf-8?B?WHBjZ2VCMUYvcXpVcmFtWEJ3eU80dUZpR2VRakY3WU9pWlFoWXpGWUlNMlhE?=
 =?utf-8?B?NTVPQmxGbWY1NlNEbkpzYVhCdmZVcFJvVEw3Zng5ckgvVy9FZ0hVL1VZcGN2?=
 =?utf-8?B?SVRzaThGUlBkb2ZyL2h4TWVaOU0yN256aVhsRjkzOG11SmFJSTFBY2tLeE0v?=
 =?utf-8?B?cDFJb1h3YzJvbXZUZWhhZ1hGVVdLZ0FCeFRWeFMwK1VVaHpKWGdDYS9SSTlM?=
 =?utf-8?B?TnFYMjVROGYwMW9xSTdTbVdSUGNuZTc1aUVkQmx2Ulc1ZGhwMXpRVHNNNDM0?=
 =?utf-8?B?SC9kMzFIeHkrR3JDUXZPalRydE05N1VOYXgwcnkvUmNVaTROa2czeER4N0xF?=
 =?utf-8?B?VUNrR3VaZVZIc3JVeXBYY3JGYWhweVBaUEdIZ2pLMFFMV2llZ2xGR1JGTGRE?=
 =?utf-8?B?TmY4Z0x0STdlU2hQZGlUWTdOU3RZSFBiVUNuZ2FOWkVpSzJEVG5mOUhyL3NT?=
 =?utf-8?B?Q0xiMG9IakhFRThySnBKVCtOVy9STTZyeEhpaHhPZlQ2ZFNYTHI1OEJ2eXlZ?=
 =?utf-8?B?U29oa0RxbHNtdWFCU1UzVXlIUDZwTDNZYjR1WElsNTZEZmZNcmVmNnBldUVp?=
 =?utf-8?B?VGZOWW9Tc1JUeXpCMThhYUpNY1J5THhQNjVSc2UxMjNOenRQRWxkM01VbVRz?=
 =?utf-8?B?RDBxamFVMGpHVmNVR0JjaHBCTmZkN1dlUjlkSlh6UUFJSkVWa3J1R2ZScG4x?=
 =?utf-8?B?T0lnZkxGYjQ3RGVVZnd1eERXVjBzNTRpcWFRZXo1eVBYK2JwOGxuMlhaOXFq?=
 =?utf-8?B?Y0tjR1R0cTJBRXpIMEJFZmpIK0czek9jVjdPWFcxNUlLbFQ4NC9uekUvd1c0?=
 =?utf-8?B?RHp1K0NyOEtNQ3BmUldwTmswTnkyaWd1cDNDalhHL0hvbHJxU1l0KzhsYlFu?=
 =?utf-8?B?aUhHR2VZRHova2E0bFhScHUyeEgxYWJIQ0ZNeDN5aG1ZYjhabVMwd0ZjQW5v?=
 =?utf-8?Q?Su+oUXFtb3rin0xTwCV7pn7ZRwSKfRsAZgiFYq2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51b947d-69de-4c4a-4951-08d90b339903
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 17:24:09.1470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8y3UHqSHYXF6H35mXQodWITRwQMhcOjcbc6r3ypI+mwZK8u2RksaA/2eTPUgNOf2tM6sm2+gvMp+kauSfT8eZlkPiJnuyM9cIJu1Y9hc0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4300
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290109
X-Proofpoint-GUID: FPaQbxIgM9Yby3DCaHO2J-rKWaUlSqnK
X-Proofpoint-ORIG-GUID: FPaQbxIgM9Yby3DCaHO2J-rKWaUlSqnK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290110
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/28/2021 8:52 AM, George Kennedy wrote:
>
>
> On 4/28/2021 12:57 AM, Greg Kroah-Hartman wrote:
>> On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
>>> CC+ stable@vger.kernel.org
>>>
>>> On 4/27/2021 6:17 PM, George Kennedy wrote:
>>>> Hello Greg,
>>>>
>>>> We need the following 2 upstream commits applied to 5.4.y to fix an 
>>>> iBFT
>>>> boot failure:
>>>>
>>>> 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
>>>> Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
>>>> 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
>>>> Wysocki ACPI: x86: Call acpi_boot_table_init() after
>>>> acpi_table_upgrade()
>>>>
>>>> Currently, only the first commit (1a1c130a) is destined for 5.10 & 
>>>> 5.11.
>>>>
>>>> The 2nd commit (6998a88) is needed as well and both commits are needed
>>>> in 5.4.y.
>> Is this a regression (i.e. did this hardware work on older kernels?),
>> and if so, what commit caused the problem?
>>
>> These commits are already in 5.10.y, what changed in older kernels to
>> require this to be backported?

Hello Greg,

Can the same 2 patches also be applied to 4.14.y, which one of distros 
is based on?

4.14.y crashes during ibft boot with KASAN enabled without the 2 patches.

Thank you,
George
>
> Not sure. With KASAN enabled the bug is exposed, but only during boot 
> as the ACPI tables are freed and their memory re-alloc'd. Silent data 
> corruption occurs if KASAN not enabled.
>
> This is a latent bug that in upstream was more readily exposed with 
> the following commit:
>
> commit 7fef431be9c9ac255838a9578331567b9dba4477
> Author: David Hildenbrand <david@redhat.com>
> Date:   Thu Oct 15 20:09:35 2020 -0700     mm/page_alloc: place pages 
> to tail in __free_pages_core()
>
>
>
> This is the failure with latest upstream stable and KASAN enabled:
>
> [   22.986842] OPA Virtual Network Driver - v1.0
> [   22.988565] iBFT detected.
> [   22.989244] 
> ==================================================================
> [   22.990233] BUG: KASAN: use-after-free in ibft_init+0x134/0xb8b
> [   22.990233] Read of size 4 at addr ffff8880be451004 by task 
> swapper/0/1
> [   22.990233]
> [   22.990233] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 
> 5.4.115-rc1.syzk #1
> [   22.990233] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 0.0.0 02/06/2015
> [   22.990233] Call Trace:
> [   22.990233]  dump_stack+0xd4/0x119
> [   22.990233]  ? ibft_init+0x134/0xb8b
> [   22.990233]  print_address_description.constprop.6+0x20/0x220
> [   22.990233]  ? ibft_init+0x134/0xb8b
> [   22.990233]  ? ibft_init+0x134/0xb8b
> [   22.990233]  __kasan_report.cold.9+0x37/0x77
> [   22.990233]  ? ibft_init+0x134/0xb8b
> [   22.990233]  kasan_report+0x14/0x20
> [   22.990233]  __asan_report_load_n_noabort+0xf/0x20
> [   22.990233]  ibft_init+0x134/0xb8b
> [   22.990233]  ? dmi_sysfs_init+0x1a5/0x1a5
> [   22.990233]  ? dmi_walk+0x72/0x90
> [   22.990233]  ? ibft_check_initiator_for+0x159/0x159
> [   22.990233]  ? rvt_init_port+0x110/0x110
> [   22.990233]  ? ibft_check_initiator_for+0x159/0x159
> [   22.990233]  do_one_initcall+0xc3/0x480
> [   22.990233]  ? perf_trace_initcall_level+0x410/0x410
> [   22.990233]  kernel_init_freeable+0x54c/0x66e
> [   22.990233]  ? start_kernel+0x94b/0x94b
> [   22.990233]  ? __switch_to_asm+0x34/0x70
> [   22.990233]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
> [   22.990233]  ? __kasan_check_write+0x14/0x20
> [   22.990233]  ? rest_init+0xe6/0xe6
> [   22.990233]  kernel_init+0x16/0x1ca
> [   22.990233]  ? rest_init+0xe6/0xe6
> [   22.990233]  ret_from_fork+0x35/0x40
> [   22.990233]
> [   22.990233] The buggy address belongs to the page:
> [   22.990233] page:ffffea0002f91440 refcount:0 mapcount:0 
> mapping:0000000000000000 index:0x1
> [   22.990233] flags: 0xfffffc0000000()
> [   22.990233] raw: 000fffffc0000000 ffffea0002f914c8 ffffea0002fa4708 
> 0000000000000000
> [   22.990233] raw: 0000000000000001 0000000000000000 00000000ffffffff 
> 0000000000000000
> [   22.990233] page dumped because: kasan: bad access detected
> [   22.990233]
> [   22.990233] Memory state around the buggy address:
> [   22.990233]  ffff8880be450f00: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [   22.990233]  ffff8880be450f80: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [   22.990233] >ffff8880be451000: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [   22.990233]                    ^
> [   22.990233]  ffff8880be451080: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [   22.990233]  ffff8880be451100: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [   22.990233] 
> ==================================================================
> [   22.990233] Disabling lock debugging due to kernel taint
> [   23.047129] Kernel panic - not syncing: panic_on_warn set ...
> [   23.048110] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G B             
> 5.4.115-rc1v5.4.114-21-gf9824ac.syzk #1
> [   23.048110] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 0.0.0 02/06/2015
> [   23.048110] Call Trace:
> [   23.048110]  dump_stack+0xd4/0x119
> [   23.048110]  ? ibft_init+0xc3/0xb8b
> [   23.048110]  panic+0x28f/0x6ad
> [   23.048110]  ? add_taint.cold.9+0x16/0x16
> [   23.048110]  ? ibft_init+0x134/0xb8b
> [   23.048110]  ? add_taint+0x47/0x90
> [   23.048110]  ? add_taint+0x47/0x90
> [   23.048110]  ? ibft_init+0x134/0xb8b
> [   23.048110]  ? ibft_init+0x134/0xb8b
> [   23.048110]  end_report+0x4c/0x54
> [   23.048110]  __kasan_report.cold.9+0x55/0x77
> [   23.048110]  ? ibft_init+0x134/0xb8b
> [   23.048110]  kasan_report+0x14/0x20
> [   23.048110]  __asan_report_load_n_noabort+0xf/0x20
> [   23.048110]  ibft_init+0x134/0xb8b
> [   23.048110]  ? dmi_sysfs_init+0x1a5/0x1a5
> [   23.048110]  ? dmi_walk+0x72/0x90
> [   23.048110]  ? ibft_check_initiator_for+0x159/0x159
> [   23.048110]  ? rvt_init_port+0x110/0x110
> [   23.048110]  ? ibft_check_initiator_for+0x159/0x159
> [   23.048110]  do_one_initcall+0xc3/0x480
> [   23.048110]  ? perf_trace_initcall_level+0x410/0x410
> [   23.048110]  kernel_init_freeable+0x54c/0x66e
> [   23.048110]  ? start_kernel+0x94b/0x94b
> [   23.048110]  ? __switch_to_asm+0x34/0x70
> [   23.048110]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
> [   23.048110]  ? __kasan_check_write+0x14/0x20
> [   23.048110]  ? rest_init+0xe6/0xe6
> [   23.048110]  kernel_init+0x16/0x1ca
> [   23.048110]  ? rest_init+0xe6/0xe6
> [   23.048110]  ret_from_fork+0x35/0x40
> [   23.048110] Dumping ftrace buffer:
> [   23.048110] ---------------------------------
> [   23.048110] rb_produ-210       3.... 7555323us : 
> ring_buffer_producer_thread: Starting ring buffer hammer
> [   23.048110] rb_produ-210       3.... 17555348us : 
> ring_buffer_producer_thread: End ring buffer hammer
> [   23.048110] rb_produ-210       3.... 17640105us : 
> ring_buffer_producer_thread: Running Consumer at nice: 19
> [   23.048110] rb_produ-210       3.... 17640111us : 
> ring_buffer_producer_thread: Running Producer at nice: 19
> [   23.048110] rb_produ-210       3.... 17640113us : 
> ring_buffer_producer_thread: WARNING!!! This test is running at lowest 
> priority.
> [   23.048110] rb_produ-210       3.... 17640118us : 
> ring_buffer_producer_thread: Time:     10000017 (usecs)
> [   23.048110] rb_produ-210       3.... 17640122us : 
> ring_buffer_producer_thread: Overruns: 4460970
> [   23.048110] rb_produ-210       3.... 17640129us : 
> ring_buffer_producer_thread: Read:     3807780  (by events)
> [   23.048110] rb_produ-210       3.... 17640134us : 
> ring_buffer_producer_thread: Entries:  0
> [   23.048110] rb_produ-210       3.... 17640137us : 
> ring_buffer_producer_thread: Total:    8268750
> [   23.048110] rb_produ-210       3.... 17640142us : 
> ring_buffer_producer_thread: Missed:   0
> [   23.048110] rb_produ-210       3.... 17640146us : 
> ring_buffer_producer_thread: Hit:      8268750
> [   23.048110] rb_produ-210       3.... 17640150us : 
> ring_buffer_producer_thread: Entries per millisec: 826
> [   23.048110] rb_produ-210       3.... 17640154us : 
> ring_buffer_producer_thread: 1210 ns per entry
> [   23.048110] rb_produ-210       3.... 17640157us : 
> ring_buffer_producer_thread: Sleeping for 10 secs
> [   23.048110] ---------------------------------
>
> 2021-04-26 gregkh@linuxfoundation.org - f9824ac 2021-04-26 Greg 
> Kroah-Hartman Linux 5.4.115-rc1
>
> Because the failure occurs during boot, syzkaller did not expose this 
> bug.
>
> George
>
>>
>> thanks,
>>
>> greg k-h
>

