Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F965EFB2
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjAEPJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 10:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbjAEPJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 10:09:40 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB415D40D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 07:09:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0ybheJiJmeEQFRL5UaR/NPXhW1naWDbwYAP+Wshc1GKUpQaXYKuGllVjk0Og7u1JCdwDCzlyg/oRat+ZJ0YEC0sAG2L5bIeiPFBriuH8KnQgXYkpdT8mRCpFuI+d6coivO8yXdSQEKKp+bugeAlyBt3mkAUegxlsBOAMxpYOpd0mNppyYgp2LT0f+7pdQBoFtyKhabc6jzkJfEJAaN9yu0g8oJGG3HlTq9hDZrybX5pcDXa8QCo13WLaX8LsgPjEI4z6HV+J/iyQeIMivrInYBT4Y1VpXjJ4Peu6aLKKbVU+04xs+gazlptcabqV1asptnQ24bkkSnjsE0aKt6ogQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avLjJXc4JnhU4guI90cyysjJbTaCtaYzQUYwU6oqTn4=;
 b=DJVz4C09oNp9HwewfxdL/IyDCJE0TovJlTJ1bjoVNMuYUM/NPQyj5W6eZ6LXbd+56fsiFjbIGicm1PoT2GN48xRvFU2mrSHBkhn/zCObdVO96dcMA6+JM4i9Rv/6T9IgMohjZv+DUQiGwDSTpROBOgZXezRQE73Qs7YS/1irPSAue3G22L69MS465IXxhMFXV/hKOqkmMVSqkIWglGxzcZ3i2Po6C37+31JZQn/yOvFVSyrWd9mq/ZXotNvpjOupBoXasNlfVkPiz32IJdXUSZ6Dk2rzJYF3IOjZHducVEgBrV/VZdtSWeB4esv2lPEF+4k7NhqM7Agn3ZrQE+LXsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avLjJXc4JnhU4guI90cyysjJbTaCtaYzQUYwU6oqTn4=;
 b=gTreL1wFQBxZJToGfdPnQAhH0ukLnv1yc9tbMonVcEOug2TN7HXHiQ5R85B6IEXhsZZQ/59Qop02zKHeathUpMPdzz3ZoSPPLxVT/A7zbGpY88PudZIye8ermQhYV3puaGAfDJBnE0cYpPt08yQxM8eIAExaAuZ+LgwIHNBcIbc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 15:09:12 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 15:09:12 +0000
Message-ID: <a17e9061-82a9-e803-acd0-f480a3712a4a@amd.com>
Date:   Thu, 5 Jan 2023 09:09:12 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Backport using Microsoft GUID for s2idle on AMD
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y7aADAZ07+f/97Xn@kroah.com>
Content-Language: en-US
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <Y7aADAZ07+f/97Xn@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:805:f2::45) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DM4PR12MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: a7476c93-38a2-420a-b4fb-08daef2ecd6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGZn9Fdik1kg0Cs4ChWeQmQecGRzt3YaAvXraTZO2GaGutqxhgOfICAYSj9Glhh5Ip37mW7ao7GK/jv8J8vD4VRmTZcoSe3frCSsKcAxyF2PTNrl6IbeAIEXXzRbeUgfmcO955cLASByxXuUMQ/Y6S8yn+4OhWGbG/BUVA4M08+kzqdOvbIueao88ElQabmBM+Ks9t3OXfqRfvzbxvk7FocrM8zhUoeL7RKFSapbOSPr6i+pSxMe1Q793FZ5ji5cJuwjIQtM7Y1aV57Ct1bNf1ZWZjffDQOLUDDYPSVNtkquUuOv5OFvV1shVFAYrnuHt+q8Pi+g6wa39dU8uY2+LboH9muBk9oRxf636I53ST4d8VTJRbuJbmNO+nyUefvENOBUgJZlmaLXS9sn0Q0+AS+ptMgIbEIsGrDseIkc5w1lxSW4IAWhxIZG7OdZhpdPWHkd7Ev8e84sa921ObdBPmYALbDw7Rh31p/OIS1bpEye9SlMAH5ytkqrT3ytTtEpeWgZyYuI84C/53GB48E84lrWp6G8JkMneTopBP/MkA8VlPFleTkMy0NMBWK8eMUuegFsnhhpdoj3v6Ai/I5tc/BQtNwuLutfB3GbZwWoA50oclCF3xPy7y03EvZi9XV++au4wONBbu17wgGrdgMKdq9AWnnXpKbGYlSTul9T8hzN+4UVKHX/96JHkZsU2yXIoc207vOdMX7vsDLidkw6hRKe9eFJ5KWh9yWHGd/I3bc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(47530400004)(451199015)(83380400001)(52230400001)(6512007)(26005)(6506007)(86362001)(36756003)(31696002)(2616005)(53546011)(38100700002)(186003)(316002)(4326008)(478600001)(41300700001)(8676002)(2906002)(5660300002)(8936002)(45080400002)(6486002)(31686004)(66476007)(66556008)(66946007)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWVjRGc5Z21ENVhmeTYxOHZyQlFxblhMOTNxdmFxd2g0Rmh4V010aWswd3FF?=
 =?utf-8?B?My9oR2toMXZqZG4rQXBIeEtwWlE3SEk3WW9FckQ4aksvVFJSSWZPa3ZDbk56?=
 =?utf-8?B?NGg3TjQ5d2dJMnU4VFJNNzE0YWZKWitiZlB4ZXpvTHZxSk5aR0hMMjlIWCtH?=
 =?utf-8?B?UnFTYWtpUXJralc4SFJGY0tLM0pONWgwWGhvYTVic2E1WW1jd1lzcFJWSUFn?=
 =?utf-8?B?eFBqU0Q2N0I3cEVRMXhZNHl2cjU1akg4ZUFUOEpLVFdxK3BDc21XNUZjQlph?=
 =?utf-8?B?Y0htQ0Q1OFR1WTVyOWFHeGszQXFYeUlacHpUSzY2aG1UaXB1dlFwR2VlRHRi?=
 =?utf-8?B?bGVrZ2w3cnQ3VS91enl3TXVUbkpCWTdGTTJlc213am93aFlqemU0TkZGdm5X?=
 =?utf-8?B?QWZXc0lGcDdwR1VmRXg2U0NWWUp4Z3pjdlZlSjRoakRMMTI3Z0FCVE8yWkFF?=
 =?utf-8?B?NnRKdk1SbTNtRDhqNStqaHl3Tzc4dERIb1JpeHg0aFBmOVBCNU9yWmtTdFpF?=
 =?utf-8?B?Q2tSUmtkNERPaHJMZTgvaUtVTGxlS2VOZFZOcGg2RVBLY3hRWnNFcmlIaHZJ?=
 =?utf-8?B?Yk4yQkZHbHZoNisvMHZBVlJRN0w0VVJ2dUFSVGhTWjlZczMwK0ZRQVJWaHJ6?=
 =?utf-8?B?bHVwYmJFRFNwenZ5Vm1OMXVoSWI5VVBwRktpdElmZzNXWUZiWEFwR29qS0N4?=
 =?utf-8?B?K0pwSFFLdm9xeGRkT1laMGNtVU8vd2dWcnNaQ25FdVRVOEM4V2d5dWJ6Y09w?=
 =?utf-8?B?czFScmtxWmFhSmNGVVNFVmsrRnM2WHBHZFgzTGVJNHBIVkpvZE1KN0JTQ0lR?=
 =?utf-8?B?TmpXa0Z0WWZocGQzTkxLYVRZTVdjVnlFYlZVbEl6Z1pLTTB0UmQzbXNoak9X?=
 =?utf-8?B?Wm5UbEZzLy9UNUxIZWkvOTc5YWFKTmZvR09vK3V2dDMvMXRxVndkdHZucEVB?=
 =?utf-8?B?b3hBNVBGV0VwTHA4aE1HNUZGcXdWeDRoYURQT2tBc1ArSVoweXVyeTFzSGNV?=
 =?utf-8?B?S3FYQkVWd0FmOVhFSVhIUEk5UWxESjdUQ1loUURXWXJiaFFlb0dPUVZWV0M5?=
 =?utf-8?B?R041SGhVQzNqWHBLUk9wdWFLUVhuWG9OTjAwRjZWREd3M0phWWM2WG9ibnJJ?=
 =?utf-8?B?c25RdElhSSt3YWRva0pZbTlhc1A5eU1QRWJTMFQyajQ3ZVJLTzNIM0VGczJB?=
 =?utf-8?B?SGFhbG9wUzJPcEVveXd5TUNmOFp1T3kxSkh1cEpXSlhDdTVTWGdCNjlHYTlu?=
 =?utf-8?B?M1Z1bmNFc25NS0plemRzc3l6dk9OaXYwdWUzcXZwRkk3bVBGMitEZk8vZVlu?=
 =?utf-8?B?cjJDYUJtSlBLZkQwdlhhUEJQU1pxaGNyei9UT3FwWE1VQXhYSml2RVZHejl0?=
 =?utf-8?B?OXRONUtVRTlsU3FOMlNraHFCSnJzNEdLZUJWRVFab1V3eHlzVHo0ZHZJcVpY?=
 =?utf-8?B?RVhBeGJTVXN6eXFaOW9rZVcyNW1KcWNLdVhvMGVlRWZJMERJZFdHcURzQ3VL?=
 =?utf-8?B?N3EwY3ZjSGZXKzZxR3lSSlRSNTBrUXNRL0hhMHlTZWZ3Uy9MNGNQbjVrN3Vl?=
 =?utf-8?B?WTl1RlQ2U2daVWlBUzJWcmlNekxCblkxcmNmaU9ROFVZV1lWSHFjQnBIcUpn?=
 =?utf-8?B?eGY3ZWRIcytXa2FBdXlTNmFvT1dhRGNFT0Q1RzBoNWdKblpITFhLQ0pCcmsz?=
 =?utf-8?B?MHZDMyt6V3hQOEo5bjNaQmdub2piMWg4NElpMmdMa1RDdXF2Wno1VExIZG9k?=
 =?utf-8?B?Nm9MSkhaTWUxMTFjdkhveEhvNnZmRHQ2cHBodWpsKysvSi9nd3VnOTVzTmhj?=
 =?utf-8?B?L1ZmMGRGU3JkSE01MWdBSEVlLy9rVkI2RmlYQUgyUWl3aytrdklIam5jMUJs?=
 =?utf-8?B?eHhCS2ZMM3FoUVkxUEc1NEk2K0FPd2lYRmxOYXQ1STNyRFgwQllHckZobSt3?=
 =?utf-8?B?WEJNbm92MjViSFk4QU9BS0FnSk9JcDdab2xvOG03bmtBUGs4WGI4OXMveUJ4?=
 =?utf-8?B?OTBRKzJQOVcxbC9NSEE1NFZJb1pRTUZid0RZVkJ4SG5mV1BwWWhxY1dzYytX?=
 =?utf-8?B?d0cvWGtFMloydWZzb2dmSEpWanpIUGNBZWl4anVERjI3REJXZ2kvYkI3NTdV?=
 =?utf-8?Q?rxOeNMWRzbEgKAopMi3vPOPoD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7476c93-38a2-420a-b4fb-08daef2ecd6d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 15:09:12.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHjR8bKPux1rywoJfZZOJL6STs6ALnKFz/LgOQQ6OPs3tbvBaZ5ye5+ankqIf0VCw4xyDtdOt/mBXaRMGOgIFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7742
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/2023 01:45, Greg KH wrote:
> On Wed, Jan 04, 2023 at 07:46:58PM +0000, Limonciello, Mario wrote:
>> [Public]
>>
>> Hi,
>>
>> At *least* 9 models of laptops across manufacturers have problems with suspend that are root caused
>> to the firmware not properly implementing an AMD specific codepath, but that did implement a
>> Microsoft specific one properly. To fix the suspend issues on Linux, a number of commits have been
>> worked out over the last few kernel releases.
>>
>> We have eventually landed at we're going to just use the Microsoft codepath in Linux.
> 
> That is the correct solution as that is the only codepath that vendors
> test.  And it's what we do for the rest of ACPI, and have done, for
> decades now.  Odd that it wasn't the way this was done originally.

Yup :/

> 
>> All the patches to accomplish this are now landed in 6.2-rc1, and also in 6.1.3.
>>
>> Now that have this all working satisfactorily I'd like to bring those fixes into 6.0.y and 5.15.y as well.
>>
>> Here is the series of commits for 6.0.y:
>>
>> 100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into structures
>> fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt
>> a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GUID
>> d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
>> ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
>> 888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
>> 631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG Flow X13
>> 39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
>> 54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
>> 577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
>> e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
> 
> 6.0 is about to go end-of-life in a few days, so this isn't needed.

Got it; thanks.

> 
>> Here is the series of commits for 5.15.y:
>>
>> ed470febf837 ACPI: PM: s2idle: Add support for upcoming AMD uPEP HID AMDI008
>> 1a2dcab517cb ACPI: PM: s2idle: Use LPS0 idle if ACPI_FADT_LOW_POWER_S0 is unset
>> 100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into structures
>> fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt
>> a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GUID
>> d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
>> ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
>> 888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
>> 631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG Flow X13
>> 39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
>> 54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
>> 577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
>> e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
>>
>> Can you please backport these for a future stable release?
> 
> That's adding new features for an old kernel, what's keeping people with
> this hardware from using the 6.1 kernel instead?  What distros are
> insisting that this needs to be in 5.15.y?
> 
> thanks,
> 
> greg k-h

I don't believe it's a new feature..

The Microsoft GUID was already available and usable in 5.15.y, but the 
policy was set for AMDI0007 (which is used for Rembrandt) to pick the 
AMD GUID.  This helps Rembrandt laptops that otherwise work well with 
5.15.y.

Ubuntu 22.04 and Ubuntu 20.04 both track 5.15.y still.

But you prompted me to realize a MUCH easier solution for 5.15.y.
Just revert this commit:

f0c6225531e4 ("ACPI: PM: Add support for upcoming AMD uPEP HID AMDI007")

That will effectively line up Rembrandt with what is in 6.1.y and 6.2 
already without needing that bigger list of patches.
