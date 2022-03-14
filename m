Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7B4D8709
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 15:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbiCNOig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 10:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCNOif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 10:38:35 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCF63D48B;
        Mon, 14 Mar 2022 07:37:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONV/hgon803Fm21IGsE7Kud2RCGuNb8j0WWmziPxORnTCQ2jzx/7INxVBCo6N1SLoBAaif+KFsp0f3PwXvNv24LU5WhdfvCRtMQzsc42+upJMXkLyVvlJX2gyYMug8vA8ODhQBY/2b7K8eEfZACX45PvsksdfiymQ06lvdohpUapy5tzPzre0n/W2xCsd0J26ll9Px9mRCaLLC3UhnkKoILvaezCQVK42G6nHeCIU+uc5YgCh/rIGXvRgwb5hwvXOc9atlyesY57wscFGO+iKxg/EC4YxVDnlvVXHMnUh+1ClMUgIsVCzbH1JjCulDa3xC9o3/cBNBAUmu2QBXdfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioERRQABwUeHrwAUwAcowK5Ly/RvXpAmiupHOWmplUY=;
 b=Lnrct+/VRXFjKUknsV2achvYdGPtlJXPObhyeDo3jhqGCSOcnt8MhyUKN2iM1apVOvYGPCgr95pQiHsiv3dIOHcriB/GhO3nlwKSlNCuuiYoilsD0fX7UU2KpukbSLeNPGF101v3+HKmbRx3XiBodm7aAxxompb+T+Et6C8jvuJMu43lTYxI9XPBYXgqixkn9xqSewPimem8thknqLzOHh4TlYwSR5ry8jFT2lhfL9WbJFKotZ8RrBUM3sfk0R59rK0B6xhrzAxdrvL25ZUqqpXgUrt0g7yBXazaR7GA1m1mLGUSfsuxesfAofa4Y6g+h5OzQMWrFZQPuEuExOBGvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioERRQABwUeHrwAUwAcowK5Ly/RvXpAmiupHOWmplUY=;
 b=QqPlaYNdfSVui9/HyfA4L1kpMo+Srn8cXnuAz9bZR7uPABfQK0EG3sKxmrD7GsTYTSxTu9HQ5fbhv18ZvYZ4cLBSlwAHlPaHIr4m2X9so3cGqeX4qEEr8G7qiR4ujtek5EVh7bNbeYY83PXTx0cmM6CMqcmMrL1sPH3PaR/NpSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM5PR12MB1388.namprd12.prod.outlook.com (2603:10b6:3:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Mon, 14 Mar 2022 14:37:22 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::692d:9532:906b:2b08%5]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 14:37:22 +0000
Message-ID: <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
Date:   Mon, 14 Mar 2022 09:37:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Content-Language: en-US
To:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
 <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
 <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:23a::19) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78956477-ac4a-433c-cb59-08da05c82699
X-MS-TrafficTypeDiagnostic: DM5PR12MB1388:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB138861502CF9C0A3E4022419E20F9@DM5PR12MB1388.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abJNM2uo+CH1QnMO0B9la43zbttHVAZe43VIGlCA97Vj27i+/2ggcbfLmcm8vaS2BXOrSjrzmo4trUbaMdBv4Qt+iaEkuR6Ei3XVZCqdSE6BDIfkr34bgB8I4IX6pPuiVFQRbo8oFVUMIaEUrYE0E7Dg82hNc9NrUhfxyteAv3g5Jco7pm8shKYToHjG3PG83w8gT42qCdXeqAmi9X34x4rR2CMkBkggF6HQsTx7COj0LfOi7ZC7boft8BDb+W5eEx+gQ1Sfc4Uo+raH0/F8u7hwizs8zXt1ST1WhDzaxFAS9SW4YXOcxPexxDitTrImLkpiEODJTZWsKxzm5geIhQ/ADYRKq83EesM0wjSNoZE823rYzMJ1HI+6bMMiwWFnEf63GArbIP6hQ//Iv/wKjSLE9PsghW6c2IfpYUxAcn2Dzk4TuFaxo/h0p5whqvEfsDnOhO4EqiJwQOrFPMoOeE2Mh5WkwOrfNWZWhrZVjrv9qJ3Z5X2nxDNl4Xh4L7jSgpTyAU+rmShKTqYqrO5WkBAV7schX88EB8lpalQJVcSFA8xoPdb4tQBl3xfCMQErFM801B7318694GbP+jTzKH5aEkoUtzWgrxlM/DRFcqKkCdn4wxCkmoF/nvnL56pd566nNau2NWTRn6fcAak1fTc2ANqiDiYlWRAyXV5z6FRiZ4UPKQV4IvqyIoJbYVhY9YDw+2kauOVWalgRLq7jpglErHLwXZmnXIZPUF+0iRlM/F9cJhK26VuIg47AHsoU2o2sZE2Qrc6lkav/GDfdfA1Bb2ris6MfTEQTD01SfT+UMRKbrxvc3AAuxKNkVY6n8lId/7A6TLDQIaFBl2BMMcqjcSvrHpz4fGif2DQJUSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(36756003)(66946007)(66476007)(66556008)(4326008)(8676002)(5660300002)(54906003)(83380400001)(110136005)(316002)(8936002)(966005)(2616005)(6512007)(86362001)(6666004)(26005)(186003)(15650500001)(508600001)(16799955002)(31696002)(53546011)(6486002)(6506007)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTRZd0VFVXBIcDlVcks2RE1tSndNeVZ5UWt2anY4TTgrcEJMdUFtamNwNEsv?=
 =?utf-8?B?cUxwUVhob1I4WmNQcERrNHo2Z1NmYmU3L1JwSTRzNVU2cG1sOGMvay9wVTU3?=
 =?utf-8?B?UkE3NGN6Nk54bzQ0VkRzOXg3NzUwZEdJSVpmWUdHMURwekdPdTRCMERGYU5U?=
 =?utf-8?B?alhZTUpxV2FzWjVXN0tKUmQ4ZG1qRXpTQ09FVFVJdDVpdTNIOTk4am0zS3dY?=
 =?utf-8?B?bzVPaEdXaUc2RmlpWVczREtxRm9vQzFSdDRwMVJOUzJIN0w3TERxbjVTMUo4?=
 =?utf-8?B?WFhhekZuL3pZUnd5T0FscnFLY3ljVHlBa29yZHhVVFBnMW1DSTAvRU1rYmtM?=
 =?utf-8?B?Z1pUa3UrTDViUUllaGpnSFBodGRjQ284VWZRL0Q4VDA3NnJidnNiTnNHWnpv?=
 =?utf-8?B?WUtPMDV5RHhpeFNIRTJHNFM3aFlmZk5wc2JpUUdQdU1TNVIrM0Z4K1hoazUz?=
 =?utf-8?B?WVhDYkp3bi9sZWx4eFA2bzNJWVpmQUZ4WDRWTisramgrbXdHc3ZXZGVrM3Bj?=
 =?utf-8?B?c05JNGZiOGxHYVBPYXpmeXcwT1BHZEN1WDdZZkRNam9LNGltT1ZOUFp1eXZi?=
 =?utf-8?B?amIyeXd5REpMYm42WXNvaWY1OFZpYnVTVDZuc1NwY3RRUlBHVmlxeERDVHhy?=
 =?utf-8?B?OVU5SEVoTDgvdW5CK2p2dWt0ZndmZ3ZiZGFkVGszUWc3cUFvSTRLdVF5SElY?=
 =?utf-8?B?Qkk4eTFRZjJLVGRaWVRuRHZEcWpZSWtzOU5ZbVFBdlg4WXBJaTBSSTdlVGJm?=
 =?utf-8?B?OGxBaWpmM0ZTZUU2U1BWUXRNSWkxNkIwN0pJR3IvY2tiOEVIU1BRcnFxZjI5?=
 =?utf-8?B?TXZFNFR0aGM5aFR2MDZ3ODVtQ1ZlR3pZdXZVcTBrNWtlNVlhV0VXby94ODR0?=
 =?utf-8?B?YUxJU1VMd1ppS2d4RUpzdjI0a0E2dUE4QytxY3Zid1dyWGEreS9Qb096dWlu?=
 =?utf-8?B?ZW5seHl4NVNZWENvZkxBM3FneHhoNG1RNzY5QlRoR1RDMHRjMDB0aElJZXh2?=
 =?utf-8?B?QmJUTW41NWozMlBQV0hzWTFPZXlsaTVsYnh5K0Q1bnhoYVhPSTA1dFNwK2hn?=
 =?utf-8?B?MWNxd0RSWEk5TEhyY2QvVzdsTXpZUHUvd3NZdjRaaGJLYWIzZWlUTVY3T2NL?=
 =?utf-8?B?bTlYMUowaE9FTnh0SkRNUERQSWNucS9ic0NYVmdsU0c2NXRjMGNvWWJrTVVh?=
 =?utf-8?B?SDhndEVUYVdQRURYTGU4VjNkK1pXT041TE5Idk5WS1lRaDJFWVdGeFJqdzVY?=
 =?utf-8?B?VVM2Z0xKSi9NNkg4Q1g2OTRqZEhydGFJcDk4VGRVdHRwZk9telRobGZoTzIz?=
 =?utf-8?B?TGtYeUVqN1ExTXJVUU11UkJ0K2dIdFV5YWw0WFNWandWbkJFQUU1WXE1SG4r?=
 =?utf-8?B?ZmVqWnhyMDNZWCsyenY1b1NiWkd1WGxkT1h3aEhtcXE1cUFoMTVhNmFQQW1V?=
 =?utf-8?B?ZFFwekpDMDY4VEdTWm9Nay9FSWo1ODJ0REp3OEI4SUgvR3F1d1V3LzFPczJK?=
 =?utf-8?B?NVZOOXh1ZlNTVmt2U1JIRTIwL3oxSVl4akowWloveWZwTFNvN3lXRDVKQlFG?=
 =?utf-8?B?MnlqNjVqV1RidWc5dHdaeXlOTk5BcEFia3BuUVoxN0NXdi9QVDJoMStRUkNF?=
 =?utf-8?B?WXV3aHVGc04vak9UQSs2WGVGaHEvOU1TRGUzWmJPQUE1QjFjdGhNb1pBNzMy?=
 =?utf-8?B?VjE0Y1VZVWhKMk9QQVE0S3ZJOS9lMm5ZRXUydit3ZTNjSWJJL1FoZlB1T0ph?=
 =?utf-8?B?NW95VjJPakpiVVhNYndZRXBqaTlEejdNY2Zkc1kvUThycDZNQmVjY0Rab0JU?=
 =?utf-8?B?c2tMSjYwbndmckE3UG9XQTdreG00ajJoaXY4SEJKdHVqcWcvOVlGY20yQU9l?=
 =?utf-8?B?NVVHVzlSVGNST2txTGY0amxXWGgyejVQaDVvZVlyY0dXYnY1R3VmVWFieDVH?=
 =?utf-8?Q?v0OgJp4fiv5vK4UkigjumVMYrzMMvBFj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78956477-ac4a-433c-cb59-08da05c82699
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:37:22.8369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drSzTFxYrM+OPKyVh0ZZPvUKYkoJnGodD//MkI3OA7JRbxtz4bM/Jc4wxaC8KDfRuXmGfHJmp8gLBp+xenmwmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1388
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ KH

On 3/10/2022 06:22, Hans de Goede wrote:
> Hi,
> 
> On 3/10/22 11:56, Rafael J. Wysocki wrote:
>> On Thu, Mar 10, 2022 at 10:07 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>>
>>> Hi,
>>>
>>> On 3/9/22 19:27, Rafael J. Wysocki wrote:
>>>> On Wed, Mar 9, 2022 at 5:34 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>>>>>
>>>>> On Wed, Mar 9, 2022 at 5:33 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On 3/9/22 14:57, Rafael J. Wysocki wrote:
>>>>>>> On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>>>>>>
>>>>>>>> Hi Rafael,
>>>>>>>>
>>>>>>>> We (Fedora) have been receiving a whole bunch of bug reports about
>>>>>>>> laptops getting hot/toasty while suspended with kernels >= 5.16.10
>>>>>>>> and this seems to still happen with 5.17-rc7 too.
>>>>>>>>
>>>>>>>> The following are all bugzilla.redhat.com bug numbers:
>>>>>>>>
>>>>>>>>     1750910 - Laptop failed to suspend and completely drained the battery
>>>>>>>>     2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
>>>>>>>>     2053957 - Package c-states never go below C2
>>>>>>>>     2056729 - No lid events when closing lid / laptop does not suspend
>>>>>>>>     2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
>>>>>>>>     2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
>>>>>>>>     2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>>>>>>>>
>>>>>>>> And one of the bugs has also been mirrored at bugzilla.kernel.org by
>>>>>>>> the reporter:
>>>>>>>>
>>>>>>>>   bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>>>>>>>>
>>>>>>>> The common denominator here (besides the kernel version) seems to
>>>>>>>> be that these are all Ice or Tiger Lake systems (I did not do
>>>>>>>> check this applies 100% to all bugs, but it does see, to be a pattern).
>>>>>>>>
>>>>>>>> A similar arch-linux report:
>>>>>>>>
>>>>>>>> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
>>>>>>>>
>>>>>>>> Suggest that reverting
>>>>>>>> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
>>>>>>>>
>>>>>>>> which was cherry-picked into 5.16.10 fixes things.
>>>>>>>
>>>>>>> Thanks for letting me know!
>>>>>>>
>>>>>>>> If you want I can create Fedora kernel test-rpms of a recent
>>>>>>>> 5.16.y with just that one commit reverted and ask users to
>>>>>>>> confirm if that helps. Please let me know if doing that woulkd
>>>>>>>> be useful ?
>>>>>>>
>>>>>>> Yes, it would.
>>>>>>>
>>>>>>> However, it follows from the arch-linux report linked above that
>>>>>>> 5.17-rc is fine, so it would be good to also check if reverting that
>>>>>>> commit from 5.17-rc helps.
>>>>>>
>>>>>> Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
>>>>>> the patch reverted and asked the bug-reporters to test both.
>>>>>
>>>>> Thanks!
>>>>
>>>> Also, in the cases where people have not tested 5.17-rc7 without any
>>>> reverts, it would be good to ask them to do so.
>>>
>>> Ok, done.
>>>
>>>> I have received another report related to this issue where the problem
>>>> is not present in 5.17-rc7 (see
>>>> https://lore.kernel.org/linux-pm/CAJZ5v0hKXyTtb1Jk=wqNV9_mZKdf3mmwF4bPOcmADyNnTkpMbQ@mail.gmail.com/).
>>>
>>> The first results from the Fedora test kernel builds are in:
>>>
>>> "HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case gets very hot and requires a power button hold to restart"
>>> https://bugzilla.redhat.com/show_bug.cgi?id=2059668
>>>
>>> 5.16.9: good
>>> 5.16.10+: bad
>>> 5.16.13 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
>>> 5.17-rc7 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
>>> 5.17-rc7 (plain): good
>>>
>>> So this seems to match the arch-linux report and the email report
>>> you linked. There is a problem with the backport in 5.16.10+,
>>> while 5.17-rc7 is fine.
>>>
>>>> It is likely that the commit in question actually depends on some
>>>> other commits that were not backported into 5.16.y.
>>> I was thinking the same thing, but I've no idea which commits
>>> that would be.
>>
>> I do have an idea, but regardless of this, IMO the least risky way
>> forward would be to request "stable" to drop "ACPI: PM: s2idle: Cancel
>> wakeup before dispatching EC GPE" which has been backported, because
>> it carried a Fixes tag and not because it was marked for "stable".
>>
>> Let me do that.
> 
> Ok, that sounds good, thank you.
> 

Just FWIW this fix that was backported to stable also fixed keyboard 
wakeup from s2idle on a number of HP laptops too.  I know for sure that 
it fixed it on the AMD versions of them, and Kai Heng Feng suspected it 
will also fix it for the Intel versions.  So if there is another commit 
that can be backported from 5.17 to make it safer for the other systems, 
I think we should consider doing that to solve it too.
