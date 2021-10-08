Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD43F4267C1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbhJHK33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 06:29:29 -0400
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:19777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236118AbhJHK32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 06:29:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=admCth41dEBS4mkqaxdDQdwb/MPL1xzjLqD4PG2eh1vp47EcKNK8IuevcXANzsxapm/sTI3SCM/GXfuH16chxo+h4im2zP6GAqO9vlzvOqIcwMH93DnMTbup8ShVmA2mUk8ttjWBvreG/JfFzed+jglZ/jBMg5i+gDQRkeg/xelxbOE0ge/s4pNFfk5AFsugXS3GwkcEyZOESMFoGye3WtvlfutxuKETTTTYAboMVe7GpPPPaFlRUi0aFTmqQ03r1/9vwr2UBYsJKa10StB6VnrvirHjtDlUfAkHejorzvZXaOUX7QJOF+ItztJ4zcJ9tX49/VYD8La/CGVKBZpUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkqp3Vt4YfNwM9s7ORqAUE+wiq+EuQfCiWKyJLxJ1HM=;
 b=nGau9lWF19EkN9fcMy5IPBhEbOJkYPP3Gi20/d1WmHQ2wVgJCy7PF6U5iU3DmJU0epwbQbehQC2twnWaz9CHe8jJePkpvmoJ4rRq39oGU34QBklXQGSO53evE7jhz9UaqfqXeAVMh0XhUxD0ohYdR7prPois7qXCdIvTQRWsZxkqmu/CTdQbVzvdynPMlNahCVzJt3QzhZSsxoPlGjzg/FzcRYBpuCWKuFJN8kqHlcNI76P+ocCyY03u2sbPXkzjmkDcQaqokWXFYx31ZTue77K2ZfOpt4tboyJrnQcTgPDUxsyHMAl9q/k6Rd5p6GxQ8U/aDVyn/ZpZG/CRH28BYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkqp3Vt4YfNwM9s7ORqAUE+wiq+EuQfCiWKyJLxJ1HM=;
 b=D+IxGQjDSKCc+tz6hS4MzYbM2jM2zFUvy3xUII6yhRA2cG/zyDxrSqL8pgQI0jeaUiZJR4cqlYtstqL+uf+zoZVK/Mhim9bp5StsmrroBtV68XSNcYaaQnVsIhinxebpnFHEOaWAfVWBqCZnfWIx4CadAWdyIhgKF7Cv78U9lK0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by BL1PR12MB5109.namprd12.prod.outlook.com (2603:10b6:208:309::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 10:27:29 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::f849:56fa:4eaf:85dc]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::f849:56fa:4eaf:85dc%7]) with mapi id 15.20.4587.023; Fri, 8 Oct 2021
 10:27:29 +0000
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for
 PMC controller
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
        Sachi King <nakato@nakato.io>, hdegoede@redhat.com,
        mgross@linux.intel.com, rafael@kernel.org, lenb@kernel.org,
        Sanket.Goswami@amd.com
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
 <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
 <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Message-ID: <609f5254-4527-38b8-3d1d-5cb06791e103@amd.com>
Date:   Fri, 8 Oct 2021 15:57:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:820:d::16) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
Received: from [10.252.77.6] (165.204.80.7) by KL1PR02CA0029.apcprd02.prod.outlook.com (2603:1096:820:d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18 via Frontend Transport; Fri, 8 Oct 2021 10:27:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1025beba-57ee-4ca7-3713-08d98a463aed
X-MS-TrafficTypeDiagnostic: BL1PR12MB5109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB510942E9FC050E80368646C79AB29@BL1PR12MB5109.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwlZUjUXR+X2gHW1UMXrJp8S3n4KuDwsmIVFmrE7BMMH7v7EWZXessds0Ewiz9PJbdcpcHmIAN+r0KSzPz59sUJgYuTWyvmsXxmlcbhBG7dwJAwrl4r53iCrRdwhacJW+jJWP4e1NIVRISqE3S8d4o5NiLGEidNvtYXYXt0Cru7zvMn/HwCbADpWb9ySq14pGuHoi0dVDD//8Zq27z2tw0gcdwylcFTO1TLby06llBwUcR7NyKy9uiWvhMRlS30h+ccgRnQQvjECeLKANK7Oaw5kBh5zMgR7tGjU3bSW7LYyR1p2lan1BaLCTMdI1ogKhtv9VlLHvHkWsbccln3TJQXpdAoWho1HDPd5qxZBl3128xszlHFWFXJrN7cfqcSIfVB/1KHGdJZA8p5txKfYLLAoQY+OM1hxsTKPxtvIGNboPjVwCnKYNVtfzNOdiEJvYNLEjV9oEt+9v0fJP2SmKIDvI+lCpWmvqWrAqAenekz840nBBepARZ5UJztwQA9unGgkOvL880iRY23+ms62yp/bC0qfOADy8Bvlll51/vReAqi1ANBKbijIUY9lP5H8wDjFzZ6RmY29korpj3VhTJ/pOnnh0oEDneEg5reByHqc8qacXnGnvybD0xCzjcoN+W/JhCz0wrH3WFYfWxd6lV8aiDQ4TzfXEy4JC1aR8+dydaP+uAIrU6elkwpgMrb5bmY/RjGbMu9G4V9mT2/dUwh4jT8nySDDlmeJuMHf+XtA4iA/R6S16YufKdJH7YESznq2avkUEh1uF72my1+UQqkt7LIUhLkKpexfrBUHD7sqXxgsG2+LGD4+nL8sOfgX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(956004)(186003)(8676002)(53546011)(2616005)(66476007)(36756003)(8936002)(966005)(83380400001)(31686004)(38100700002)(4326008)(66556008)(86362001)(2906002)(6666004)(66946007)(508600001)(316002)(5660300002)(110136005)(16576012)(6486002)(31696002)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STBUaGdhNHdXYkdSeWZ4d2pVVDhxL2lWais5SmJPUjJwc0xnc3g5QlUzSFNx?=
 =?utf-8?B?blozK1VMS1Q5RmpETTFwVHRLZk0zODVZcmxaOHY2cS9CcGQzTWV1ZXZGTDJx?=
 =?utf-8?B?NW9QeDJmcmJ2QVNlTXA1ZEpKNnFqT1V1S3ZXS3BTNG1lbTFiSlVHeUFVZDV4?=
 =?utf-8?B?Um10NEpvcUZFSHQraDh5Qmo0Vm1mbFFRSXhtZjNWVm8yYTZNNDBybFk4U2Zs?=
 =?utf-8?B?akJwZGo3MXpONlVaQXFGZml4NDVCWGlnekJFeXA1Q2c4STlIcTdJdkRpT05W?=
 =?utf-8?B?dlFDWkdvaWZwamhzZ25ENE4xTGphVzBuY1ZhelhBVFQvZDdCMWswblB3c3cw?=
 =?utf-8?B?b2NwMzNUVUlvNDNXU3NMWHh6bldxTklyUzM5QXZSamdBWmVYM0djaVN3WDNr?=
 =?utf-8?B?ZmVlR21Qek1CNjNLTGdqenZjRlhMV1pFdEpYbGVIaVRZZjRpcDhQanlxUHJK?=
 =?utf-8?B?bU5xMUJGSllGYmhKdjJ5WTYzaEMzSWtmbVh5WTZuN2czd1Q4Q001Z1haRUU0?=
 =?utf-8?B?L2NHNmsyTENWZGRqN25xdllvcFNLNkllTU1DNTh6eXZwMWZ6ZHhIN2dlWEJv?=
 =?utf-8?B?YzIrSFhvRkNyWlRjYlE1azgvakhyTm4zN2YzejBwZHFqVGdONW1hM0VnVDJ5?=
 =?utf-8?B?Qm1TMEZ4OHQ5bWprQkdYZ3NQNVVRc1Rob3NNWWZIMjdxT3BHT3hEZHF3NVNE?=
 =?utf-8?B?ZFJuOTh2SVhiTzc3SkRGTTJ0Rmxyd0E2cnlmaHJJdG4yN2lJZzkwclNqMkZt?=
 =?utf-8?B?YWkvTnB0Q1l2SjAwWXVQaG1ycWVsZnM3TUZqSk53dHVnVkx4dFFIU3hBbXpL?=
 =?utf-8?B?RVd6NTJ3TlFqVU95Y2ptMTZhMEdJN09hc2lVMTlicVVjQjhTQUZRTmQ3Lytq?=
 =?utf-8?B?QUozRGk4TjQ3STlPM09ITjdGKzJrWTk1aEVmaHdEQldySXV2OTNhRldrL1Jm?=
 =?utf-8?B?Z3o5MTkzbzQ1bnYza3JSbDVkM2Nmek8yTms0UEhTZENEL1owbHJ1ZnVRZGtl?=
 =?utf-8?B?REZlZW1vT3h6Nms0R0xWWlpzcXdjMGlITWttNUdHUW1XajNWUTRldHhkRGI1?=
 =?utf-8?B?elpMT0J1K0ZTTjFFSG5lOExVVUJXbkQxejYwV1o3MS95Y3pXR3lRTi9ub2t5?=
 =?utf-8?B?RFY3VGdLV21jTkM3MUdPQTZlRGUyRmpXWU40WWVPMDdGeE51cnJzdW9BbXFT?=
 =?utf-8?B?M00wcEtCaUIvc2lycGFaUzd4bjArZUsxZDdrRURsMjFWek8wSGxkT2wyVnVu?=
 =?utf-8?B?dTNYZ1k3UlpCLzhBU2VVQldyS01LcWFuVDJualROR3RQUExwamFDS0N6alVO?=
 =?utf-8?B?bDdQbFF3R09kVkRsSlJRV1RaamhhRHhLTEhJR29QUHJFWmlwUExlYjdjVjNu?=
 =?utf-8?B?Vk5qQnFmMEdUcm9EcjVncFBJYm44K0xDTi94N0VtRklvaTFuWGl3VmFhenJv?=
 =?utf-8?B?Z2M5YitZYzBLelFvNWQxTnZ4ZHl2SmsyVHcwZ1JvMnBQcURuZGU1azAyRnZ1?=
 =?utf-8?B?NFR5eklHMEFHbWhydEl4UzR4MWtFNzlGMDBmUWl0SVphRUZZSEJGbjIweXND?=
 =?utf-8?B?M0xqeEpJRTc4RDhHMDlSNVk1WG51NTdnVTVKd2RLeFNmZ0hRSGc0Y2dHb21O?=
 =?utf-8?B?UDdhb2YwWjlCaWw5NzRUbjcrVk96WjlVRERsRzlFSDllV3FDMm80TjFhandH?=
 =?utf-8?B?eHd6OHNwSC8zamdidTJnT2RmU1pibi9FU2VlaVhvbWZPZVNQZXlMNSsyS3A0?=
 =?utf-8?Q?869SPjzBWRcwWpPH8Gp3aAjuKXmnbBDL4dRBIR9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1025beba-57ee-4ca7-3713-08d98a463aed
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 10:27:29.2306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwQ9RcKaCr/K2ISOzf1ZOGlE95dvri8xVMqmeE7sppP8AT13d1TAvJKGp0Uc762m/MlUE6HFqkkT9IwXoedhHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5109
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/8/2021 1:30 AM, Limonciello, Mario wrote:
> +Sanket Goswami
> 
> On 10/5/2021 00:16, Shyam Sundar S K wrote:
>>
>>
>> On 10/2/2021 9:48 AM, Sachi King wrote:
>>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
>>> controller instead of using the appropriate ACPI ID AMDI0005.  Include
>>> AMD0005 in the acpi id list.
>>
>> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
>>
>> Thanks,
>> Shyam
>>
> 
> I had a look through the acpidump listed there and it seems like the PEP
> device is filled with a lot of NO-OP type of code.  This means the LPS0
> patch really isn't "needed", but still may be a good idea to include for
> completeness in case there ends up being a design based upon this that
> does need it.
> 
> As for this one (the amd-pmc patch) how are things working with it? Have
> you checked power consumption and verified that the amd_pmc debugfs
> statistics are increasing?  Is the system able to resume from s2idle?

Echo-ing to what Mario said, I am also equally interested in knowing the
the surface devices are able to reach S2Idle.

Spefically can you check if your tree has this commit?
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/commit/?h=for-next&id=9cfe02023cf67a36c2dfb05d1ea3eb79811a8720

this would tell the last s0i3 status, whether it was successful or not.

cat /sys/kernel/debug/amd_pmc/smu_fw_info

> 
> Does pinctrl-amd load on this system?  It seems to me that the power
> button GPIO doesn't get used like normally on "regular" UEFI based AMD
> systems.  I do see MSHW0040 so this is probably supported by
> surfacepro3-button and that will probably service all the important events.
