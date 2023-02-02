Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD236873AE
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBBDKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 22:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjBBDKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 22:10:09 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA864FAFF;
        Wed,  1 Feb 2023 19:10:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPH6Bm3lNlSLYn/cdHUB8S0Mu3hypoLxeG4swmfVfYl3IMIiAJBsf0iDCUrKorqGNB1pHKOPlbodRfkTtkoMMpZkP0IGwATYqTi+pHk0T2XE+wDmjuRB0Js0CzrzoE9qphFo4U0BzXVB63jUyZuUfRXa9lm0SrCceQ+IKOQK34YyD9N3SQzRqmhJmzZbFDL5TJ3oMDe9Npo5jy7Rv0puvRwGac+gB9oMA0wpik7SDz1JSCQnL56ANt5ufLcFiq4R+S+cyoAMZhe30S4VqMxJlc8ZE7Yjhow5PfTqHBJLJXzRFlMCECgTfWmrcUh5nw6LMLIpPsSEQQXoOf1DdTewOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNR9yLUU9ja6aQyPmiPDlw7G+Wq+BgHxeXen6f0uYB8=;
 b=iPGT8ewPqOw7BvkRkTmZ47Estup8lyGUj4cWTFkG7faUAvc+lr8kYnMiPRkbHfw1UZhdYb8phrkjZ7PDaHMOSsZkI+1jkiOKolRfs8/W7aOE5kW0Dpe2yGFJllCkWau6LEUNKGHgPt//Q5k8gda2v1Kd9cCoBUQOHFMV7TpQPB9AUzSRulC/lgmPwEvg2e+8lUIIKyl9JuYDIfPOFTNZK9YzgfenjZw8kZyapWpXKhtMpAWQZkSDC3yMMQwXf28cg8s/0gz5SBU9LDBe44+UVppk5Q9bt+xZBsqAl3XM8pCp6vPE4l7q1zBsBv1m0c/PH0+Ivs5oz9F6XiPRicZLFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNR9yLUU9ja6aQyPmiPDlw7G+Wq+BgHxeXen6f0uYB8=;
 b=h4r3L0mOBYGJZAP6oYdN/qLACDt+VeHoWcpPOPboq2vzujI7emaZjcFzVvKs4a3NzaNRQAh558SkYGdXqrlEfzLuV0XDc0XJuMtmOVcc+xf3yVEeJYW3I5CTGBc1bJeoOkSxIo+SkawoVJ1fkRgdpIL3A8FOh3viq5XR5k38wq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Thu, 2 Feb
 2023 03:10:04 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6043.036; Thu, 2 Feb 2023
 03:10:04 +0000
Message-ID: <bc927cb2-0d61-c38c-3e6f-a43ee3bec2c9@amd.com>
Date:   Wed, 1 Feb 2023 21:10:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Patch "gpiolib: acpi: Allow ignoring wake capability on pins that
 aren't in _AEI" has been added to the 6.1-stable tree
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>
Cc:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
References: <20230201164307.1305059-1-sashal@kernel.org>
 <MN0PR12MB6101CA1D078964276862BBAAE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y9sozVJN7/7ltSCq@sashalap>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <Y9sozVJN7/7ltSCq@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:806:130::14) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|PH7PR12MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: f79cea86-30ff-422c-3e24-08db04cafac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnMgBS8AFPsy8/NXqJT0q71eBFR8x10jny8bEz20ML+48j6bCLAXurufdD6kdHn92jAu90l8Ikou431N4700VbULnw4fStQW9Z2Q5Mk53PbkrvexQJg6MQ1UwmY2zq1nsDYjQslQvqEWkIYKyJqJGroi5v6Of7n9ldJF9Bit3+edvFTOK+OOl5car7p3Fq1Lu+8oHd5U911rljr758shEtvcj1kpnoeudvN7BN5zlBA24OJK9y9mJmNtCpamceK3uCz59SRBVK4u/y3MddEZ3BBJ5bEnvq7fCrvK2HVkfqw45C7ZKTJX/2YfDNQnjDJ8zQZfeIElBNFaZNX7vvmlqDM0rwCXAJZ0HS5/yvK0sD7PDqwH9F9j8WdXf/ym2y34z+UnsksVw9KFc3i5mr8236CeW+grMsIOlcKMcPFPOA7fgUlyO7QYry9+Vw14sj9b5Qlw1DksBCnYVc99vBl9QIhxhdXVAPpFCIAExJFIkRTZv4HC4Nn9qYFFEq1JwA4i4s3MmTrHqwZpWJ4a9aOkyhIhJUxblqovD+IivmJvHwpR+ERvPjNMjMl9X2Au0wUE3KMFSeQM2cD0f488u1G4G4vEyCvAeLqBjCAunJ8wdV7PNK4DyOJNP+XYlrlCXffxVSchBWPXk8bZVWDBVVwGS8ah1Mm96M7SHnJVoDqlWIy11AxCT5j3ev7z7GZxEtITo+Y7bGKkbVzkyjXEdj1OIQCa4Gg+lpfEIOLFO9CCXPJi918QnBABPnEfiJYHWnVBcWEstxlYGOTX9CLzfc/gPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199018)(54906003)(5660300002)(31696002)(186003)(6512007)(53546011)(2906002)(6486002)(36756003)(966005)(44832011)(6506007)(478600001)(6666004)(86362001)(2616005)(66946007)(6916009)(66556008)(66476007)(8676002)(4326008)(38100700002)(316002)(8936002)(31686004)(41300700001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eklPQnIrYU82NE1aeDl1eHZpWDltSnlUaTN5MDNjQzJacGdUNDd2cmszWG16?=
 =?utf-8?B?SmlKclNFTkJUaklFaUoyME0xNUxyKzFkV1NsLzYzdTlxUkI1S1dKSDU0cmZi?=
 =?utf-8?B?NjdkUU53aWFDNGJ5bjlINmxWQmZmVkhwVGduNmNhV0JQR2tNYzBBT0I5ZDI0?=
 =?utf-8?B?SXZvWm5OMjdaTjQ4V1J6VUJjOS9neE5zRDd6blp0djJpYUhCNng4WFFydGgy?=
 =?utf-8?B?Qk44R0FOQzByQXp0Ymh3U3gvZlRndzdwTmRzdGg4SnhhYTRCS0hyQ214am5s?=
 =?utf-8?B?ZWRRdmdrTGZkZnppY3p0bStxVGh2WVlwQS9UTmRHWTQybVIxV0tZWmFJUU1S?=
 =?utf-8?B?a1VlTG5qMUdwakM3ME9URnZGMXFrS1d5dHgydEp3aUtsMzAyZHBteGc1SFd6?=
 =?utf-8?B?RldKQ1JmbVEzUTlYZzNkQXVVV21DQnVNZzE5c3h4U3hXOGdEZWdnU3c1MWNQ?=
 =?utf-8?B?ODBjNWU1ZHVjVlBQcmpCZW9Sc1BLakFoUkRnUkFUVjlCdlAxVHcrNDJ3bWgv?=
 =?utf-8?B?S1pHVlVGcmRjMlJmZC9mWnNVZkI2SkVDaXpBdzlzS0ladTF2MXpqUVNOTmU3?=
 =?utf-8?B?MlNTaGZPZzhkSmN1Y3JBV3pRODhqcU4vWFRoc29FTGdienpwb2pwa1hEZTIr?=
 =?utf-8?B?enU5M3FqLzBjc3hRbzNFV3FTelE0S0diS1pmVXlHcE1OQkYxY1pqQVhYalJx?=
 =?utf-8?B?ZVdIVncxQlZOampJdURxS3lJQmI1bThUVU5OQVYrcmtwT1AyeEJ3cDlnVWlP?=
 =?utf-8?B?OW5RNGhTSnZ0V0wvcTJzOEJZcm05UmcvdEs0SitJQ3NuelRxYzZXNHcwUlND?=
 =?utf-8?B?OTdzNm5ONzZmT1BBcm5KbGN6NmF4TEZVbElTL1F2dkNRUEZjM2NLL0ViR0lU?=
 =?utf-8?B?Tk9OOEtuak5oUFQ1SWV0YmJtWUJGUGxCTDQxazdFV002bStLejdIMTh6d0x6?=
 =?utf-8?B?TGcwemJjUXN5NzYxTjZPWkNTRkhCOWJZTmtJMThZRVRwRm9CdEdiamZZU1pj?=
 =?utf-8?B?bXViMjRsYW01SGtmMllUcy9pb0JtWFNjbGtTVnV3RHpUaUt2S3lUNjFSbEpn?=
 =?utf-8?B?WFFMUEtxcGlHV3E2TDVrSjNyeWxYNnVWTFo1VHp5RkNEdXlkRHp0QUdNMUk2?=
 =?utf-8?B?MVBDelBrTWZqZk5EamtOQ2syQkxCZUN0dVlOWC9UbzB3T3VZN25DMWJLM2No?=
 =?utf-8?B?M3FSdjZZcmxDTVZENVliVTBObGhOQXhOeGFsUjJGcmVVQWFWM0VWanRMck96?=
 =?utf-8?B?QmFtMmF6MVZ0anZjS2NvOGYyVDhZbVY3ejd0Z0dxWnk3LzNqUlFiSEllM0Fn?=
 =?utf-8?B?RFk0ME9vaGtkdFVsOVhnbGVzYjdUL3VBV0lBVHJ6V3IxcExLa28xeEYxQmpz?=
 =?utf-8?B?ZWNRQTJMVDBQbkZHbEZZTXRWaTlZeG13dEN6Nm9adDFaVmpid1RqUmJBZzlh?=
 =?utf-8?B?VXh3dVRmMDRVRU51RGpKOU9tYWdoS2lLQjRkQ3lLY2JOeVpneWlsNGtadlcv?=
 =?utf-8?B?TENVeXJvVTlkb1BWV1dnaXZ5R2RjL0FJMkFPSUxLeEVQdDM3VTFDbWplVVpV?=
 =?utf-8?B?dlFHK2EzOG5uWGRxSEU0SUsydkppc1RzM3FvME1ZYWVOSFY4Q2w2TEhoVDBF?=
 =?utf-8?B?cjBEVy85RUhFRUZjUGZlYndmS1QrLzh3T0JPRFZqTnBIN0ZIS2YxMldpNkRa?=
 =?utf-8?B?bUI2R2tudzJhcllxY01NUG1xcHMrZkJmMHBuWlQwWllTLzhGbm1jakRYNkpr?=
 =?utf-8?B?VnJsSFNjL3c3M2djYVkyblB2SS9jZG1oZEVod2V3M0lET3JiVHltMDJRZWNw?=
 =?utf-8?B?YTY3RTFNOTFURnRQWHNnd0IxaXIwMUV6dzBPQUxyTS93Z1ZuUUpUcnZrRmJv?=
 =?utf-8?B?Tm9Lc1Uxblc0b2hYMEpsc09POUNMczlZd3hXRVNUQ0VUYmF2M2lwaXZlQUVT?=
 =?utf-8?B?RzJEZW5MTXpLNmV2RW0xemxCRXFwSE1nUDdGbnFUYUowZDlMcnpscGlwL001?=
 =?utf-8?B?Rk45eitFOCtDaVNEYVdKcGNGNDBTK1ptUWdsZHUxZnpwY1hIaXZqczFNWUxt?=
 =?utf-8?B?Wlg3WXpzZ1E4dVdyS0NXK204TW1FMHk4MUxWam9VUDhRSTFaQUU5WHlxcERX?=
 =?utf-8?B?b1phakJ5QldGWTFnWTl6Y0QvUUE2RjdPZ1ovdEZyTjRMLzVZdlp4VXJ5NWpT?=
 =?utf-8?Q?C8XVbiL/j7NlGTxL24cjJYHc6Dk7yEHorDvMO6JjFUUl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79cea86-30ff-422c-3e24-08db04cafac5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 03:10:04.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCyz07KsTuTLAx3eYTz+7rCsTSD2FRe0bHMNVxnFNZ+2hEI6h+btny+YOQ5WFT2exsiO48s5khvJdpodcFgB0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/1/23 21:06, Sasha Levin wrote:
> On Wed, Feb 01, 2023 at 07:39:29PM +0000, Limonciello, Mario wrote:
>> [Public]
>>
>>
>>
>>> -----Original Message-----
>>> From: Sasha Levin <sashal@kernel.org>
>>> Sent: Wednesday, February 1, 2023 10:43
>>> To: stable-commits@vger.kernel.org; Limonciello, Mario
>>> <Mario.Limonciello@amd.com>
>>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>; Andy Shevchenko
>>> <andriy.shevchenko@linux.intel.com>; Linus Walleij
>>> <linus.walleij@linaro.org>; Bartosz Golaszewski <brgl@bgdev.pl>
>>> Subject: Patch "gpiolib: acpi: Allow ignoring wake capability on pins 
>>> that aren't
>>> in _AEI" has been added to the 6.1-stable tree
>>>
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     gpiolib: acpi: Allow ignoring wake capability on pins that aren't 
>>> in _AEI
>>>
>>> to the 6.1-stable tree which can be found at:
>>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-
>>> queue.git;a=summary
>>>
>>> The filename of the patch is:
>>>      gpiolib-acpi-allow-ignoring-wake-capability-on-pins-.patch
>>> and it can be found in the queue-6.1 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>
>> Hi Sasha,
>>
>> I suggest you also pick up two other fixes to go with this one.
>>
>> 1) this fix which was in the same series:
>>
>> 4cb786180dfb ("gpiolib: acpi: Add a ignore wakeup quirk for Clevo 
>> NL5xRU")
> 
> This commit has a fixes tag which points to a commit we don't have in
> the 6.1 tree: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting
> wakeup_capable"), could you confirm?

Yes; technically it's already problematic in 6.1 but the default policy 
doesn't set it for enabled.  If a user manually set it to enabled the 
problem happens.

6.2 it happens automatically because policy changed from that commit.

So I think this one makes sense.

> 
>> 2) This fix which is tangentially related (fixes something from the 
>> same original
>> series that exposed the regressions).
>>
>> d63f11c02b8d ("gpiolib-acpi: Don't set GPIOs for wakeup in S3 mode")
> 
> Same as above.

This has two fixes tags, one of them is in 6.1.  It makes sense to take 
back to 6.1, the reporters first noticed it in 6.1.

