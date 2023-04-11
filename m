Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A575C6DCF52
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 03:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDKBaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 21:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDKBaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 21:30:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D45230FC;
        Mon, 10 Apr 2023 18:29:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2FBJiK7OYJSlSYhPd/pZdYx2YwBjkjXCAJtDN9s1dVWPdq1M197TiFWJiHsL2lK9p1kOQa2ZlkXgHJO3cV6rUIo57Nr/C4rsfYpWg/BPCckaFNUa+sG4AbNjYpzbgdtWJ29P7xYMDcJOIQrTDfmoAE9PozybXglP1s6ONthQjUHwL73CwK0xG+P8RqWCsIU75JZk/1yvqf3Uelvqoe3oy3VVvAzm/epnKZ7dWgORLT/jnerIkI1NuCaTFLECNCu/ZmkcwGLGg+hBy64IEbe5cQgMp2oMlOe2nJm6v39vsLhdWbuWIY8lRsIUKMK8YflyB+60UYihEuoGBjy44jy5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMpb19sYuD2Zo323h/cDpGUFPTLYCTAQbVEBG9XUHL4=;
 b=MTK9DUJkHxL0ZA6wfrAcXdGfZ8DXOuV6kpnA3ILPq0IBN6he4JFdPOsC9sN0c+hXGMtg57w5GUt5QIH3SYssxh8mb5W4sUogow9TbzWi5ft7g/MExGTmIk3bNLXSAs9JWB15BYmCTHVminc9d55kiF+pQdgtIqxaom9hjYJxLKUTdohIlVbVCW6M6bJhv4mdXc2UAUi74zGMKWSTxsnZPKS8tnigyaeEJGE+3ZMLjQq4XNbcWOzGvajrxk/39KrnbN1EVYAr511LYj9oReczFe/4DHsz2+LmihfR9Ty0dd5DjycybXbOjuYz7LcIKVFhlm52Lo6kTzzLINmZpzfWSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMpb19sYuD2Zo323h/cDpGUFPTLYCTAQbVEBG9XUHL4=;
 b=U3gjgJ2svAeoDEHh7THquz0rBPk2mLIF5aNVF32tJoLSw3mXkTKOBFmD2IGzmHpiVG8CziMk0nHSy3kSDLoepdCKu3kpPtWrFMe9GMLQI3x+hsTsI5jgKvqQ02Wf9rm77IBxk+/ziFacS6SumeE4+djDIJuDgOPgAeVyQh7Frzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 01:29:50 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Tue, 11 Apr 2023
 01:29:50 +0000
Message-ID: <0adc0b89-768e-0f8b-3fd3-4bb7cb3ac3c8@amd.com>
Date:   Mon, 10 Apr 2023 20:29:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
To:     =?UTF-8?Q?Kornel_Dul=c4=99ba?= <korneld@chromium.org>,
        "Gong, Richard" <richard.gong@amd.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@leemhuis.info,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <20230320093259.845178-1-korneld@chromium.org>
 <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
 <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com>
 <CAD=NsqxSDUu3wpfhUCDJgP2TaKb7dudB90snROQpPJPj3fdFgQ@mail.gmail.com>
 <CAD=NsqyAXK0z7XqVy=coSm40zOe0yS+h=oiDD8a-udDT5WKMdw@mail.gmail.com>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAD=NsqyAXK0z7XqVy=coSm40zOe0yS+h=oiDD8a-udDT5WKMdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:806:28::34) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eba212c-859e-47d9-4872-08db3a2c3e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgS6md4btCEGORiHt0mfLqscORYGtUEUvQD63P7oKsIYee5mA5VsIBB4mKtzW6JYdUXAOhjZHsGg1+ulCYg/ZLLGuT5W8ysy2f+ULmGsE0TV4FvpSyO7kfjvaDqdtA9BUC99NmYdoTunmYjwgZFuXZK0tLGuYlJG+0DzFv0gNtxoAVY3V3biBYGq3GBP4D9rqpIojmJHRB5b9IJ650hdGWGwV20J9nJjnQ8fsdSmZ2FvBcd6fpT5b096yvycYym8/7QXk+OJ9bx/qXxe7TH/uLuazhMEWX+AH+DWZzExTcr5jn+OX9Iao+kHRYsJhWBlLj1ed5O7wdd1wECwZncBqDueb8HQXk3I5OpP0oRpLD1h3U0V3OemF+eEeYewQGGnUmHg6Z9MUtvkTvwCiPxfdSSuWDh3zVDLk4XdCqjmFE/WTBzH2v2ZRAKAq/GqDRIkfqoNXU43q5tXfD45wM3gSGreAEX35S1ajjxAK+LCh5iVzrdCoODtSWiYXnWTPTs8AXSAYeaTUIfFTDA3mQQtAupWGJ2AZVgkd45fvc17unz0PhOsPYfoBFKwEQ1r28sJNmLXTXTJ/e8i001/cSWgoz+sb70RdJ05XGWaM7PVwyehI63HWweqVPUjnIuw1K/CTNRNlHxDPZRDi+FNQK5PJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(36756003)(31696002)(86362001)(41300700001)(316002)(110136005)(478600001)(8676002)(66946007)(66476007)(54906003)(6486002)(66556008)(4326008)(966005)(6636002)(5660300002)(7416002)(2906002)(8936002)(44832011)(66574015)(186003)(38100700002)(6666004)(6512007)(6506007)(2616005)(83380400001)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTU2SXNZR2s0T0lVbFJnUW4yQWd1ZmRzdk1XQlpyTGdRbVhhQW1iRzVXU0da?=
 =?utf-8?B?QTBJcTF4YzN3SjlaVGNHdGdYN1RaSEhNN1dCeXZsdXN3SUFwcVJNQVJWUGpI?=
 =?utf-8?B?ZVdZdEFkREcrRy9hTTZoVnd3Yi8yQkdQQ3NGYmRIWDVQT1hBcm1RdlRzNDhJ?=
 =?utf-8?B?RnA3M1Mya3NJTGI4UGdtZlZITGRpakx2NHMyOUsyVnBiZHRkcmRxa0JHVDJy?=
 =?utf-8?B?YTFDVGo4Z1E2OWphOWtRWGlUUmxSYlgvYzJ4TVg5WmdNSUtySXVKbEkrYVUx?=
 =?utf-8?B?M1Z5RGY5VWJ5UGlaY3FpcFFIN2hjYWxYeWpuR2xwb0gvVHR5cVdyU2VyZkxr?=
 =?utf-8?B?clBZRDdGd054YXpRL09KQUo4Z2dmOFUxK2pGMlRINlhiSGdyVFAycVhzeTUw?=
 =?utf-8?B?T1lvRWQzTkMzN3BiUVdmOWRDRHZjYzBoZVFZakdyMUZBNVphbWNxREtYc1NB?=
 =?utf-8?B?TERFNVZYWXBRT2lpMkVUK2ZJK3pNUERGSlgxcGtZRmVMQktGOGkwb0MrL3Jm?=
 =?utf-8?B?dVI0ekZHRUdyYWxxUW9CU1htcSt0NVhlZXljMVBuY2NCak1yWFltYlVNb0Z0?=
 =?utf-8?B?NWhuQVdpVEdoK0xWa3hrcFdrTmc2U1Y2bHljdDM1b1VqUlZibU12MzBpbG5s?=
 =?utf-8?B?UkRqYjVBQXNxemhjU2NtOVJlRUtUNnFWVDIzT3Q2NnR3bTBldlRyTXhvRnJD?=
 =?utf-8?B?S0tNZkhHbjVreklmZWt6SFdHc0YyMEdKbkpnaVowR3N6YkYyT3E0N2krUDh6?=
 =?utf-8?B?d2dyWERjZUg5UndsZk03WG1EaXBxRFhhRVJHTWFma0NPRmxKWjltdFo2ZkZH?=
 =?utf-8?B?bXZDUk9tMmF4d0dza2E3U3BMMWxQb2RQYUNpT1Z6WVZGMGUwTU5FSnhGaWtz?=
 =?utf-8?B?clhOdzV3b3Z5SGpESUZjMzVxOTcyMmN4YkFXSWY1VngydlpBL0F5YVVlQjQ0?=
 =?utf-8?B?WFZ0Z1hkZW1RMGNVRTBnRURzVXZUOUNxKzZEUXoxQkQyV1J1QTI3SlgwVzUv?=
 =?utf-8?B?VW5TclFTN0lxeHg4OGR0d0RieDFBQkljeGM2ZmE3cktXbkVtQkhnRWRhQ1NP?=
 =?utf-8?B?ajRkR0wzZUlmUng0b29GSzNXK0hacEZ0cjZ5NkhENkhzdkFONjVNTW1WT0ZH?=
 =?utf-8?B?S2ZFNWE0UTlndDE2bnFJeFZqVVR2djFJV21ETUtUdVN2aEZGT0VnaXRzd3hl?=
 =?utf-8?B?QzJHVHY0R1VDWnZBeFRWZTEwbjNYQ3dFeTZScjRoSjQrRVM2WEM2b3JBQ2Jy?=
 =?utf-8?B?bEFydUYrSjVpMzhtTlhmVy9MMXdqbWxEOHViTFQycnluMy9EOEh4MVF0MlZy?=
 =?utf-8?B?NlJDQmptaW9TVTB3OGxiVnNjMWFrT0JYMWd3MkE3cTgyM3EyMGhCSmxFS243?=
 =?utf-8?B?YVZOMVprZUVMSHVydEJDS2dJYUVEaWRRY3ZQTTQwVythZ0c5ekhPSVFFZENS?=
 =?utf-8?B?Z1V2eVE3enVJVExFWUVJaDdIajR3NWE0cmV5bmpYaHR6N3RDWVd5VHhWcW92?=
 =?utf-8?B?WXB3UU5IMmZ2NkxDY0k1UHBQYlZqb2lOKzdLRkR2NktMa2RzQ2UvWlJVeUJQ?=
 =?utf-8?B?T0J0N0xWZnJ4Y0RIa0xndGhLQWM4QVdEY3ZTRFBUdHVyTUQxOVFpRDIxeFRC?=
 =?utf-8?B?Ym1HSnlHVkRob1NDRk9DSURBTldtRnFzSnQ0b25Sa3VMMXZicTRtbDN2c2tQ?=
 =?utf-8?B?NnRadkF3K3dyTFlLQ1RTQ29iTDFHbVQ3bS8yd1BRamRxL2FmVkUvODE2d3pn?=
 =?utf-8?B?UndKMVdkTTU4RUVleEg2ZHNkSmcxMVBuYUxkWE5ROTVTU2V5bkxOYktKclAr?=
 =?utf-8?B?bHZUV1hUNGNYNkh3TmU1UUJkRlVaTFhvV29lWnF5RUd0ek9LeStxTUNvdHYy?=
 =?utf-8?B?R1VVVUxrV3pHUHFUbDN3bE9XRnFZaE15Qm4zZll0VnJtZFV6US9EWFpHTmUx?=
 =?utf-8?B?NTE1NWlFWC9iWjR3bmFLVlBVbG5jQVp0cWIvTUd6QzNzWTRVRUluc3hzQmJa?=
 =?utf-8?B?emJIYlVPRVY2M2MyYzZ1clY5bUl3Vkkvclhkb1RETVhabzYzQWJtZjZIU29p?=
 =?utf-8?B?YkVNY29YZGx4VHpoRnNZQVZiTXlJNWxVaW0yUk1VN21mMjNpZmdCMjdScElN?=
 =?utf-8?B?Q0NRRzBrYkl3WUhuOGZaM29CcTRmRzNlcndiSXRySFhDMmRxdVRZQkhkY1BP?=
 =?utf-8?Q?JV5vPeakTz71hvnDoXOH/XEyQpHzoWaVgVfj2zmUIEw9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eba212c-859e-47d9-4872-08db3a2c3e26
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 01:29:50.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCYP+uoRJzmkkxDan10b2l+r79rGYWYlDcm1kGAKH6n1HgJIP1iIUIy1prUMkeNieZGFsEuEu1T4x8HItWVqOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/10/23 11:32, Kornel Dulęba wrote:
> On Mon, Apr 10, 2023 at 6:17 PM Kornel Dulęba <korneld@chromium.org> wrote:
>> On Mon, Apr 10, 2023 at 5:29 PM Gong, Richard <richard.gong@amd.com> wrote:
>>> On 4/10/2023 12:03 AM, Mario Limonciello wrote:
>>>> On 3/20/23 04:32, Kornel Dulęba wrote:
>>>>
>>>>> This fixes a similar problem to the one observed in:
>>>>> commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on
>>>>> probe").
>>>>>
>>>>> On some systems, during suspend/resume cycle firmware leaves
>>>>> an interrupt enabled on a pin that is not used by the kernel.
>>>>> This confuses the AMD pinctrl driver and causes spurious interrupts.
>>>>>
>>>>> The driver already has logic to detect if a pin is used by the kernel.
>>>>> Leverage it to re-initialize interrupt fields of a pin only if it's not
>>>>> used by us.
>>>>>
>>>>> Signed-off-by: Kornel Dulęba <korneld@chromium.org>
>>>>> ---
>>>>>    drivers/pinctrl/pinctrl-amd.c | 36 +++++++++++++++++++----------------
>>>>>    1 file changed, 20 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/drivers/pinctrl/pinctrl-amd.c
>>>>> b/drivers/pinctrl/pinctrl-amd.c
>>>>> index 9236a132c7ba..609821b756c2 100644
>>>>> --- a/drivers/pinctrl/pinctrl-amd.c
>>>>> +++ b/drivers/pinctrl/pinctrl-amd.c
>>>>> @@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_ops
>>>>> = {
>>>>>        .pin_config_group_set = amd_pinconf_group_set,
>>>>>    };
>>>>>    -static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>>>>> +static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
>>>>>    {
>>>>> -    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>>>>> +    const struct pin_desc *pd;
>>>>>        unsigned long flags;
>>>>>        u32 pin_reg, mask;
>>>>> -    int i;
>>>>>          mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
>>>>>            BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
>>>>>            BIT(WAKE_CNTRL_OFF_S4);
>>>>>    -    for (i = 0; i < desc->npins; i++) {
>>>>> -        int pin = desc->pins[i].number;
>>>>> -        const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
>>>>> -
>>>>> -        if (!pd)
>>>>> -            continue;
>>>>> +    pd = pin_desc_get(gpio_dev->pctrl, pin);
>>>>> +    if (!pd)
>>>>> +        return;
>>>>>    -        raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>> +    raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>> +    pin_reg = readl(gpio_dev->base + pin * 4);
>>>>> +    pin_reg &= ~mask;
>>>>> +    writel(pin_reg, gpio_dev->base + pin * 4);
>>>>> +    raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>>>>> +}
>>>>>    -        pin_reg = readl(gpio_dev->base + i * 4);
>>>>> -        pin_reg &= ~mask;
>>>>> -        writel(pin_reg, gpio_dev->base + i * 4);
>>>>> +static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>>>>> +{
>>>>> +    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>>>>> +    int i;
>>>>>    -        raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>>>>> -    }
>>>>> +    for (i = 0; i < desc->npins; i++)
>>>>> +        amd_gpio_irq_init_pin(gpio_dev, i);
>>>>>    }
>>>>>      #ifdef CONFIG_PM_SLEEP
>>>>> @@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
>>>>>        for (i = 0; i < desc->npins; i++) {
>>>>>            int pin = desc->pins[i].number;
>>>>>    -        if (!amd_gpio_should_save(gpio_dev, pin))
>>>>> +        if (!amd_gpio_should_save(gpio_dev, pin)) {
>>>>> +            amd_gpio_irq_init_pin(gpio_dev, pin);
>>>>>                continue;
>>>>> +        }
>>>>>              raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>>>>            gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4)
>>>>> & PIN_IRQ_PENDING;
>>>> Hello Kornel,
>>>>
>>>> I've found that this commit which was included in 6.3-rc5 is causing a
>>>> regression waking up from lid on a Lenovo Z13.
>>> observed "unable to wake from power button" on AMD based Dell platform.
>>> Reverting "pinctrl: amd: Disable and mask interrupts on resume" on the
>>> top of 6.3-rc6 does fix the issue.
>> Whoops, sorry for the breakage.
>> Could you please share the output of "/sys/kernel/debug/gpio" before
>> and after the first suspend/resume cycle.
> Oh and also I'd need to compare the output from this with and without
> this patch reverted.

I've attached the requested output to the bug for all 3 cases for the Z13.

6.3-rc6 (broken lid resume)

6.3-rc6 + patch below (broken lid resume)

6.3-rc6 + revert (works from lid)

https://bugzilla.kernel.org/show_bug.cgi?id=217315

>> I've looked at the patch again and found a rather silly mistake.
>> Please try the following.
>> Note that I don't have access to hardware with this controller at the
>> moment, so I've only compile tested it.
>>
>> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
>> index 609821b756c2..7e7770152ca8 100644
>> --- a/drivers/pinctrl/pinctrl-amd.c
>> +++ b/drivers/pinctrl/pinctrl-amd.c
>> @@ -899,7 +899,7 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>>          int i;
>>
>>          for (i = 0; i < desc->npins; i++)
>> -               amd_gpio_irq_init_pin(gpio_dev, i);
>> +               amd_gpio_irq_init_pin(gpio_dev, desc->pins[i].number);
>>   }
>>
This unfortunately doesn't help the behavior at all.
>>>> Reverting it on top of 6.3-rc6 resolves the problem.
>>>>
>>>> I've collected what I can into this bug report:
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=217315
>>>>
>>>> Linus Walleij,
>>>>
>>>> It looks like this was CC to stable.  If we can't get a quick solution
>>>> we might want to pull this from stable.
>>> this commit landed into 6.1.23 as well
>>>
>>>           d9c63daa576b2 pinctrl: amd: Disable and mask interrupts on resume
>>>
>>>> Thanks,
>>>>
>>>>
>>> Regards,
>>>
>>> Richard
>>>
