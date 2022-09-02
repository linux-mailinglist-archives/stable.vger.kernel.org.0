Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D595AAE0F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiIBMEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiIBMEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:04:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629DC0BD3
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 05:04:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7MZHutWA2Cfw1v7EF/6byYtUBj0Yva6MzvbSkK0Rj6PeVibw4WrQtz5Rwc2LUI1WXG6KVDq+jGeuPocDjNVCgRXrwHJQ1Bz3QXll24R4Z+SQL2qR0hlDOo7FLbmMTDpuJgm1XCXrDcwVo19fBSsEojCpiqixcMA4UCim7oNhHla2vIJgLurQ4S7HYkkvKG9nSvtmlmqAmnKN4Bd/FGFwflmlOfaXP1HvWMR+kDyD34x90iGeut/j3smtfzfiHBvkBhDhxbv8SiDkpq8Pr+J8Pti/GotyrrwMIO5391IOML0Np9y5jzXVzSi+hPqGRoUhn+/xDn7PqNFeLXRcyV3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/jBE1weq3Tp7QZGzk30NV+L0PI2gbvzWZ750b2skfA=;
 b=mQ5u4tYlucYDGdBiskjVhXXkQjClixwK2FbbDv1Z8P13Z0shVLWtna/FZpa6nHDtXBmNfT/tIuAJH30bvUlimTFPZGqbQ+GiFUHEVa5msz1oBOgq13CJbV+jjhcb6bXe8Qg+evjQvxKib82WYvFplfAS95fN4x/9+Oiju4N56wPksSuCMCRzJtmxU8dzI23M5O3r057G11qOZ1Hcc3E4EkqxPslqYjNc+qgx72Lun7D4AhbXMIqdnEglus6jcpzqc+c+UJmowskNBDfXI03XyqvzjC74rREdafgh48tBjS2WV6Wq7zqwCkUtEruE+KWwua5ysHq9/PH3jst1MI/Nww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/jBE1weq3Tp7QZGzk30NV+L0PI2gbvzWZ750b2skfA=;
 b=TG8lyB3T3G0hDvyykMO50ZX3s7kI9BubTRl4QexdZqXatv/eJufegeAVDbGJ9bWmLzPofpZjWGELuJGlEd8k1PlpSSNo3a0nn1UZ1sMB6Lt37jwjCCtM/bETqiTS1jilyOKc2kQvssWudqQrlnO8M5IeH4I/V9RBDHumMD5sW8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 12:04:15 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3%5]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 12:04:15 +0000
Message-ID: <16ba0dd3-b500-e75c-fdb6-a5c024212105@amd.com>
Date:   Fri, 2 Sep 2022 07:04:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Properly reflect IOMMU DMA Protection in 5.15.y+
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YxGUnAjojULtdhfL@kroah.com> <2f525452-fbe8-6780-b552-9ba7c16047e7@amd.com>
 <YxG2VIMFLXX9k+nx@kroah.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <YxG2VIMFLXX9k+nx@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0012.namprd05.prod.outlook.com
 (2603:10b6:803:40::25) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64260793-5044-49e6-e45a-08da8cdb41b8
X-MS-TrafficTypeDiagnostic: CH3PR12MB7617:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4B36gIWw3mLb6lg9FfqrD8LJ9YfwC5MU3xExJwx/CV6RO0tdZaqBL7XS3jxAkoz41QIQPHDngdprTsHbY7GyepOq0CXevr9B7cFyAH4bItMermJBeuy86EIg+ohkp898SE/fTp6XrBbAb6bo8CMqPnmveB5psbKislWgMIaMDR6c7qZubnq1VJXFMT2OkM8IMWSHIKyIDQhscL8L/iNqjKUgJGNkTYbZPbx45W5mk9+dlEL3TkdnIQv8SNYnujdv3EfnsCMcCdaGRonDAU16bh6D0oY2Ia6rYV7ZLwlmf3cek8QfyQgYe+xfYBYImZ/gNPWT2TjuWOf80yx9R5ecfwuCqCbvcj9JWcNp3DAS5dJWDm8DkEKFYrxCt+qHwKcrn0dBko49g5qnem0/SyLgs6JDr+hZsI9KrN+4vD8o0cvg8L4USFYxfOTNnKRPUqa3lQflUMwT2zFAODMzVjcM87DSj3Fw0zwmDEZT3dryUqryNH0kqRxGczbE5nCdE9T51bOzv9wYYGGB4l6zdEQ36WHRs5EbIMXxh8SM9NPlBgrkQMu1PM7u4F4Ts4Dh7gEBbCNTU6Dey5n0/kOjOzwA5z0X8WRHIAKqu9QiBd4RMCMQ6KpG/y4gI3CTZDBlDgWLhSBm88if4RsVBmmKIeHP3sLimKPEnMPwo6+ALURccEIWPHqgD1najO7oUjweZY8i0e6whV4LB6Og+xywV5EasmOleQIiNaWIuYiZeA24ORxRIGRYx4DSkjoMUFP/7sXN2xFlsBGZeUABgR8Hl9VhXSEYCsXIz2rZwb6kXXQBe7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(186003)(478600001)(53546011)(6666004)(6512007)(6486002)(41300700001)(83380400001)(6506007)(26005)(2616005)(8936002)(2906002)(44832011)(6916009)(5660300002)(316002)(86362001)(4326008)(66946007)(66476007)(8676002)(31696002)(66556008)(38100700002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmEyNDRVMFZ6M3F1NmI5em5WVFdrZjBxQVpWSlgxLzFoQXBhOHZHcDJKeXo5?=
 =?utf-8?B?VDN5WjR2OU01QXBwN2xhc05xa0RKSnNyUGRkOXM0M0F2cG9FaEJKOXJER0xY?=
 =?utf-8?B?NlR4QWJjTkk0d3NUVnI2aDIzVCtDVnhIaWgwY01VQ1kwQnkyZDhvYzJiTVdO?=
 =?utf-8?B?eTljWHY3bDFPUGd5ZEkrSU4wNW54TmRuUGd4emxMZkdROFl6YUxJNHRsNHo3?=
 =?utf-8?B?bDBvY2pVTkpSVzN3dGdZYUR5Q1NZRjdZdXNzUFNmMGNzTk5GU0YwN3RDYll6?=
 =?utf-8?B?UHBBTkVUTkdEYWRkMVRCRHRNQllaTHhETE5BN2dJb1JxTzdUa3FYa0xWeXFI?=
 =?utf-8?B?ZEdSMGttUmJNN21CWmZibHlaNE1PandhYkpwTXRpZnJKQ1pndDQ5RFRQWitD?=
 =?utf-8?B?cEwvSVBNcU9QUzZyQURiWE1QLytuYUFKZWN4dm43cFJ1ZmNqbkFtZ0U3eW9M?=
 =?utf-8?B?OURMR25jUGl1cE85d0dNMjZKM0ZCVWpNcGZKYVNCMHpHdnJPMEpJbW1lRzFN?=
 =?utf-8?B?eTVtTWFhakJZT0hpWkNZUHlEcTFDSmJuRDhDcDBEeW11OW1VbUJGei9OWUw2?=
 =?utf-8?B?N3VxNGpyTkVSbmthbGEvT2pOdytBbGZGWDUyV1ZKbHlOMHByVkJJVzE0dEZq?=
 =?utf-8?B?R1MwYUppY1R5ekNyQnhGL1JBZW1UazVHeFVyRjZDclJzRlZINWQ1YXVGOUhy?=
 =?utf-8?B?VVE5ZUludlJZUnlxUisvWEVBaVkzai9nNUE1SThLSUJoTURNSEdSRytHZkxu?=
 =?utf-8?B?M3JNeTNqc01VSzZwbUFCazhaRmMrU3RZQWxqMnR5eFF1YkhreEk5L2VRbTRW?=
 =?utf-8?B?ZU1lUy82RmZlZGorUUxTUTh3ZkV2NFkxRVpndWRBMW5rRTVBTGNxb1Vtckxo?=
 =?utf-8?B?WGJYckNjMDZWa2c4M0YybWEwT3FrbnM5RStDZThjQXBYU3drVWhCdkVrNzBO?=
 =?utf-8?B?REdTNzJzSm5ZOEVMTDhabVpINUppbGt4K3JGQzZ1cWF5aFU3NCsxamdsaFIx?=
 =?utf-8?B?TkhiMFZLTnYzVGRPZUtKT3k0RkhkMUZ4Z3BwaFFYSXRqelZFUDVKbmhOQ0tS?=
 =?utf-8?B?SFk4MjVERW5wVnNkYlBvVnd5THNqbTVJWk9Va1lRUTJTaFkrL3BkaEgzclNz?=
 =?utf-8?B?SDlhN09tQ2pORzF1MG1OcWlpdU9Xc0FSSHpFU0UzSkxHNFd0Ui9iOVVobkkv?=
 =?utf-8?B?NmF1SHdBbnZNWGhscVJzdmcvQlZtdkRoUjQ3MWduVTRhVG1vQm1oeXJWOU9I?=
 =?utf-8?B?ajIrRzA0a2NQR1lSUzRJbDBiTXhUeE5UeW1aRmpRVjJxSllzTWVkM3FRNXJL?=
 =?utf-8?B?ckdHakhuYmErOVlsMUdNNDlnVGZEQ2VWODRlWFFpMk54SnI0eVhOYjV2eHpi?=
 =?utf-8?B?Q0dRZEg2M3RWcDB1U1BzOWs0MDZHazBTa3ZqZXJySzJvdFBmTVhjZ3AzTXVY?=
 =?utf-8?B?cE1BSGMrdWtVNUhSNkVCMm4zZXFHN0ZuN2JRMktuUGNXdm1KV3FjNW1xRnJ6?=
 =?utf-8?B?U0lwUWpDTFRoVU1XM3p1aTZULzF5RHlqTC9xZlRRSW9iQjZ2cjJzbkx6anlG?=
 =?utf-8?B?eG5jNkJoTVBhRUorU1R5WStTL2NURHYxMXFvV1JKSUlBZFNtbGFrbklmMGFW?=
 =?utf-8?B?dTNqcGJpWi9sSXAxMENvWllwRFh6WGNFZFFKRElpd3NhbGFpMWpjWG15UGdu?=
 =?utf-8?B?L1Q5TlE5T2ZQNWRFMm4zQTdkSWdhQllBMWgzU2kyS01oQXV4Y0ltMWg4MHEv?=
 =?utf-8?B?cW4yclNkRTQ5alV3M0JRSDdpWG1UbEtFbDlGZUJmU1NDZGF6OUl4UEhZbVd1?=
 =?utf-8?B?dnQ4dDZ4YVdJMEtQQ25XemdaVFRtZ2pvdGU5ekplSHJSUnAyVnM4VXV4UGMw?=
 =?utf-8?B?dThDN3NDbWxDeHZ3VVVmS2lGNHd2MmZOQjVFakJ6OWZ1bGVUcFlZcnBBbUh3?=
 =?utf-8?B?V1gyTGNIcjc4ZkVPRFEvUDlQVE5pWnhMMXNCWUl0VlZzQjZZaEd3RGdrVWt4?=
 =?utf-8?B?azcyK2E4ekdJbkJrOUR1ck1rMEJ3ZDZTNmRhUWhBSFVFNDllUWRvbVo1akZP?=
 =?utf-8?B?YktjL2VCQUh6N0RRdmo4Tjl3NzZycEMxamxBNVJZM3QyM1UwNDdEVlNXemdu?=
 =?utf-8?Q?A6rVT4G2ApDBn+8v2aNnh6t+k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64260793-5044-49e6-e45a-08da8cdb41b8
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 12:04:15.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOX548XbeSaauWdt8aeRZRaBghj4IcT6NgwI2JHgA/vKjBftizprxnsjF1S7FNX9xMpuEcKtarLZboiJ9dQYgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 02:52, Greg KH wrote:
> On Fri, Sep 02, 2022 at 12:37:15AM -0500, Mario Limonciello wrote:
>> On 9/2/22 00:29, Greg KH wrote:
>>> On Fri, Sep 02, 2022 at 03:00:26AM +0000, Limonciello, Mario wrote:
>>>> [Public]
>>>>
>>>> Hi,
>>>>
>>>> A sysfs file /sys/bus/thunderbolt/devices/domainX/iommu_dma_protection is exported from the kernel and used by userspace to make judgments on whether to automatically authorize PCIe tunnels for USB4 devices.
>>>> Before kernel 5.19 this file was only populated on Intel USB4 and TBT3 controllers, but starting with 5.19 it also populates for non-Intel as well.
>>>
>>> So that's a new kernel feature?
>>
>> The sysfs file was there all along, but it always showed "0" for anything
>> but Intel systems.  This makes it work properly on everyone else.
>>
>>>
>>>> This is accomplished by an assertion from the IOMMU subsystem that it's safe to do so by a combination of firmware and hardware.
>>>>
>>>> Here is the patch series on top of 5.15.64:
>>>>
>>>> 3f6634d997dba8140b3a7cba01776b9638d70dff
>>>> ed36d04e8f8d7b00db451b0fa56a54e8e02ec43e
>>>> d0be55fbeb6ac694d15af5d1aad19cdec8cd64e5
>>>> f316ba0a8814f4c91e80a435da3421baf0ddd24c
>>>> f1ca70717bcb4525e29da422f3d280acbddb36fe
>>>> bfb3ba32061da1a9217ef6d02fbcffb528e4c8df
>>>> 418e0a3551bbef5b221705b0e5b8412cdc0afd39
>>>> acdb89b6c87a2d7b5c48a82756e6f5c6f599f60a
>>>> ea4692c75e1c63926e4fb0728f5775ef0d733888
>>>> 86eaf4a5b4312bea8676fb79399d9e08b53d8e71
>>>>
>>>> Can you please consider backporting them to 5.15.y+?
>>>
>>> I don't understand why all of the string helpers are needed just for the
>>> last commit, are you sure this is all necessary?
>>>
>> The last commit (thunderbolt commit) uses one of them.  That commit for the
>> one of them doesn't come back cleanly, but catching all of them up does.
>>
>> So I could potentially change the thunderbolt commit to not use the string
>> helper, but figured this was cleaner.
>>
>>> And again, this feels like new features are being added that are much
>>> more than just a "new device id added".  Why not just use 5.19 for this
>>> hardware?
>>
>> Stuff like this is targeted towards businesses that would want to be using
>> LTS kernels.  In fact I heard "But on Intel we just plug in the dock and it
>> just works" is what prompted the series in the first place.
>>
>> It improves usability quite a bit because without it you need to know to
>> manually change the sysfs file for your dock to work or you need to have
>> GNOME installed and go and find the panel to change it.
>>
>> With this sysfs file is showing the right value you get all that happening
>> automatically.
> 
> I understand the wish to have hardware work on older kernel versions,
> but in looking over the full patch series here, it's not just a trivial
> addition.  This is adding lots of things that were never in 5.15 to
> start with for AMD hardware (and touching other platform's code at the
> same time), which is fine for newer kernels, but not to backport to
> older ones.
> 
> Here's the overall diffstat of what you are asking for:
> 
>   drivers/iommu/amd/amd_iommu_types.h |  4 ++++
>   drivers/iommu/amd/init.c            |  3 +++
>   drivers/iommu/amd/iommu.c           |  2 ++
>   drivers/iommu/dma-iommu.c           |  5 +++++
>   drivers/iommu/intel/iommu.c         |  2 ++
>   drivers/iommu/iommu.c               | 73 ++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
>   drivers/thunderbolt/domain.c        | 12 +++---------
>   drivers/thunderbolt/nhi.c           | 44 ++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/iommu.h               | 19 +++++++++++++++++++
>   include/linux/string_helpers.h      | 25 +++++++++++++++++++++++++
>   include/linux/thunderbolt.h         |  2 ++
>   lib/string_helpers.c                | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   12 files changed, 221 insertions(+), 34 deletions(-)
> 
> The string helpers are trivial, but those iommu changes were not.
> 
> As proof of that, you missed some fixes in the kernel tree for the above
> requested commits that would have caused problems.  Heck, even the
> string helpers needed a fix that you missed, so I was wrong in saying
> they were trivial!
> 
> So if I would have taken these commits as asked for, they might not have
> even worked properly and caused problems for people.  So for that reason
> alone I would have had to reject this request.
> 
> Remember, stable kernels are not for "new hardware enablement", unlike
> how some distro kernels work.  If you wanted this hardware to be
> supported for last year's stable kernel release, you all would have done
> the work back then to get it accepted as obviously you all had the
> hardware back then and knew it was going to be an issue.
> 
> Just point any user of this hardware to the latest kernel release, and
> all will be fine.  And work on getting your new hardware supported
> upstream quicker please.  That will prevent this issue from happening
> again in the future.
> 
> thanks,
> 
> greg k-h

Got it, thanks for your review and guidance.

