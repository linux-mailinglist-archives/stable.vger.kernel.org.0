Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3034F6DC87E
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDJP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDJP3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:29:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151A32724;
        Mon, 10 Apr 2023 08:29:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih8//yjXg8/w+b2IUYcL6OaXoc8cGHpsmZtLWDyM1NdEs7RI4Ik2mC6jl5ZKlMmy7H3s7aVdjK9Rtxj9jQY9OOlEA/cEvpFJiV8phvW5iAVDNNslN8ga6y2m/ZmI9XfmlJ7SfFAgtIQ3KnS4GRsNuKT/DQv8c0CfsD9kVyeLwq6zG5PLErR7UxaQaQ2OcFg6IWEaQdHoJYoXcDU1ORLUSuLuP8TNMxsomiB+TJ7ssH82Y52hieaU+SVAIziXTZGXht8z7wmZq2RwE5ltaF4xPFC5qNPVBF+mTGKhnmC1BaW4nKNqwqFp5sxQm85VYS4p5eQUG7O0P1zzJnJOxXgEgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lv4ooD3MZVsYtMC+qXZik7QPJqqnbZK0ZxnR7q0oxtw=;
 b=ATd6nrVuB6ug2QnqhNZ6OSx4mn43qwCugOEru5BXXw/W6GrN16noqQpwOCZWD+BYr5FjcGXgcG06vgJANeL0rPyve8ypQ6Ncp80qR3orsoIxeW15TxSDIO+AEu3ATLrnEO9a/nzPFZG9mOyA+TDmJVGchReYu9Ly+2/Q8JrbcbQHRrHu0VTyhFyvOR8cyfJPLRdbY0XfoHkunOC9bAXbwvTD7z9sEhzPzETV2K72nZ9WNXVi32RdLH/AuklzAVUzfvfSvBKEHGx9naDAsdxVqfhh92cn7Vdh3Y50sZbOIYLLvBUfAFFvEZPG60deQXV91CqrSuMt9xnsLczE+23AEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lv4ooD3MZVsYtMC+qXZik7QPJqqnbZK0ZxnR7q0oxtw=;
 b=0/QkyAZl/zZj9SGp3A1UUMSjSd9CH9AILGgQ5PDWoAkEByUaKd5dIN9hbsut9qaAoYVXui5kqWnqitPIvgtqwj4lfomhLmURPNTSv3ShwjlUeTdwkSjoyecd3vIifDN8U7vxm5huTCSh3qVZstrK5sfhcb0IwHxbIy62su89S1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6253.namprd12.prod.outlook.com (2603:10b6:8:a6::12) by
 CY5PR12MB6324.namprd12.prod.outlook.com (2603:10b6:930:f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Mon, 10 Apr 2023 15:29:27 +0000
Received: from DM4PR12MB6253.namprd12.prod.outlook.com
 ([fe80::1e94:d88f:5829:627f]) by DM4PR12MB6253.namprd12.prod.outlook.com
 ([fe80::1e94:d88f:5829:627f%7]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 15:29:27 +0000
Message-ID: <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com>
Date:   Mon, 10 Apr 2023 10:29:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        =?UTF-8?Q?Kornel_Dul=c4=99ba?= <korneld@chromium.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@leemhuis.info
Cc:     Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        richard.gong@amd.com
References: <20230320093259.845178-1-korneld@chromium.org>
 <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
From:   "Gong, Richard" <richard.gong@amd.com>
In-Reply-To: <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:610:4e::29) To DM4PR12MB6253.namprd12.prod.outlook.com
 (2603:10b6:8:a6::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6253:EE_|CY5PR12MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: 6304a197-7742-4213-4d6c-08db39d85ef3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKfXdEUKR3AhPY4GXImXzmUoGwUIeaI4TUnfOkWa/5t6XRxFIH/vxjOAGQwwk1l2t3mVdvMTEvQFjUyxgiVtAJ2yEvQuX/G796vl6YK40nbZrKR+bW5sYaKwznjyTQuaYucsSpExcpxXGyvP2CDUNab8vcXob5eRj6atoXgelGajNyw6JVv/N0Zeutbfog0/hSUFhF3YoLraHuM/yH6c+vyCPVEPJ+hAnGlESm4ZjwKj1ogjBIR9aQiu0tjQNq4+rFONMorxonpQ2TuS9En4jd/AljCrvpj1TnKMPvUAh5tvBY+9Qaq33COWFrhtyAP01lTm9PikV7PVeG1kIVZIgrUNit2vZ2tMOOZ6cWGsb8ZROMbCEVzMc+0S0qMY1+tZyh9579kZrRLD+WNdVPsgR8EBVtsWHlLiy0NWZhGOB+Vq/R1FRvQbPm/Mae0wD7qd6M16USM+6Xv5viFzz02AHQhXMj5nr6wC2wh5F1aHhZpxTc84Odh6hFa4EKuaw0WBwuQv9HBvM9fu4dP8b+h8pN+ylvWM7x0I7Nq9U7ctH0ooliTkh5nnpfQldoQHkZ58f3IH73LF6lm3n9T6V5It7UqoWAGENGScH+HVPNvJOBMEF9H3Bcv6Ma97ePl8CuQo0JQZli4y6HaIAj2LgU6jgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6253.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(478600001)(6666004)(54906003)(316002)(110136005)(6512007)(6506007)(26005)(53546011)(186003)(6486002)(966005)(2906002)(66476007)(5660300002)(66946007)(66556008)(41300700001)(8936002)(8676002)(4326008)(7416002)(38100700002)(86362001)(31696002)(66574015)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG1QeDRoU1k2VWZhdmJDc0kwOExzbHZHY2VRNWpnQTdpTld6QmNySDFFWXdM?=
 =?utf-8?B?b0hPbTNDOE1Zc3dyMnV5N2pHOW9oV01sQWRwTHJGa3dFVW9tazF2SlJEY2pB?=
 =?utf-8?B?dC9jdEl0VE9oekJNZkI5TFdXaWtuZ3RyZHEvd2pmUVMrWUpDRkFjRnl4NDlp?=
 =?utf-8?B?Sy8wZnMyN25wUVpMTEhWdzZMaUxHenpEeWNxSDdyNzdtWUtkdlJzVkoxcWgx?=
 =?utf-8?B?UTlBbnloWkpvV0FNdklJdGQ5aVBHQ0Z1UXFjMTM1SVdLZnFQVGNjbFFYUDJs?=
 =?utf-8?B?YW9PMmE3NHRBVzBINkxCMFFjYnRHejNac0p5aGRrbVh6RHlBdjZmdHNPTkl5?=
 =?utf-8?B?NWlHS2lPdXZrT0huaE43dHdWWCt2OEJXbGNpZFJXODhzSjdYamc3Q0NGcGVz?=
 =?utf-8?B?UFUxYWdTSW1FMXJsQ1ZPWE9Gd1EzWHZrMWltNDZMOEptK2VscHpBMXo3bG4r?=
 =?utf-8?B?a1BxbkpzZEdZVVVXRUk5Snplalp0SFpZRXNMVGpVK3AycXJIRUJCRkl0eFpM?=
 =?utf-8?B?Tk1SL3RuRm5NSEdEY3dmSFZ0T053M3F1RHJtYXJoR2F4OEFXZXROQ1EzZ0NQ?=
 =?utf-8?B?c0JBUVlBanF5T3Ryc3N4VXhLcjdEemo5R3Ivb1pGTDJySHlmaUVGcjQzTWd0?=
 =?utf-8?B?WS9WOUlDV3FqZFhaeFU0RG1iMlkvaVl5bnJiNHV6NlhGQjVFNWtpZ29teERm?=
 =?utf-8?B?SlVZVXJzMHkyUk0zR1NIbk56NGNGLzFXYnJaV2RDY0hEZ3pZeW43QXM4VGh5?=
 =?utf-8?B?M1EzMTFNRFBRRURzRTlqVlJHLzhrekF1U0ljM0FyU1VJdWJNNFRsNVA5dE1R?=
 =?utf-8?B?dGxjd2k2VkdwRzhmSjRIMFNpWnhRRTRHblVYdUIremhkWjYzakZDd0dBZzM5?=
 =?utf-8?B?VFFzSERIMkVBWnhCT2gxTVJDdEgwK0VGdjhZY1NXUVRnem1iUDFEMURkbGpC?=
 =?utf-8?B?cXRCSHZJZnB1ODRyQUErNjl2enlZWTkwQ3NEODRpREdkMXo0QUNMYkxVakc5?=
 =?utf-8?B?ZThoT05qSlNHdlZJMGl2NnYvRHlJM3UxeW40MkdnUkNUdlh0MDNqS1g2Yi9r?=
 =?utf-8?B?elJCNzhITEd0eDRDNDlzenlXUEV2WE9BQlJqVnA3VmNZV3Fxc2x4SmdGdi9i?=
 =?utf-8?B?M1lkcXJWLzAybWMwazJ5TDUrQXJYek1VUDRtczlTTUs2R0hBZ3RPc3dQNmpy?=
 =?utf-8?B?emloc3JRdHl4Z0x6NnNzUU05TkgwcWZMTUxvMmtRdHdMd1NsT01tTlc3aTkv?=
 =?utf-8?B?WEZrT0VPZjhTMUVGQ0RzZjk3VWFONnFZOWJ2K2VYQTBnV2tLZDNtRndWOFdk?=
 =?utf-8?B?cGJKVk5hbTlmcE5rWnJ5UldJZWJHU3JHcEZlek16WSs0TG1ybk1zM0xoL3Mr?=
 =?utf-8?B?SUdyb1AwcHhEc2pIbm9JNWpIeWRxbm9RN3NhQ1JESUwxeUgrSDFabTVJVFdS?=
 =?utf-8?B?aVRQbmxhUmU5bmxnVzgwWnZWN2s1QldhRkhOTUlveWtoTlJLOHhLU2hRbEgv?=
 =?utf-8?B?SW8xeUdXdWRTVk12Sm5yU3pPa0l4eDUzK0ljODNWT0RsRVJ0Q091Zk82Mllo?=
 =?utf-8?B?Uk9jQzVieitvUjJvU3RoNE1ZcStEWDA1R1FoV0FxSlRPcFVXRHlYU3NQeFZJ?=
 =?utf-8?B?d2c5eHFlUEZoeDNSMVNzTU1QWjlDUncxOUJMdHUzeVhqWWJVU1p3Tk80VnQy?=
 =?utf-8?B?OFZUbVRaVzNMWitTUlVwZGJPYk16TUh6U1NCV2dyc0ttVE9Id3BVQ295OUIw?=
 =?utf-8?B?MXBiNmNXRkJtZmk3Ly9UZkRJM2IzYm0zRzZDVHZoZjhud04yN2s2emo1SHhD?=
 =?utf-8?B?U085QStyME9kUFpGeHR3L21SQ09LSlpzdVUxKytCSy9tc1M2RW5UZGMxU3FX?=
 =?utf-8?B?cmNOWXpRUFFpRzBzTnN4OVk3OEMrU3JZQTg0R2ZLSUtXQkJNZUdXOGRpZVBp?=
 =?utf-8?B?Q3p1c0NTTi9ONFhaQU5zaEQyUjEwSU0rM2tQdmhqZlZGaExPS2tnZzlGNmtS?=
 =?utf-8?B?TUF6ZFNoMktaNkNYbmswclFlcnNGMy82NndyWnc4Q3NEWklNV2Z2K1BvQXQ3?=
 =?utf-8?B?ZW10OU5iclhpM1JYY3lLUHBtdklFZU1ERVJNY1ZYZjFqOEcxYVozeU1yUHVS?=
 =?utf-8?Q?5MqVHi8mzz167npquPqzNqMFi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6304a197-7742-4213-4d6c-08db39d85ef3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6253.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:29:27.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZ1d1Wjof4LqakQl9EsagRGybPrN/dnE3mZP4phM1uuaom3oP6H/bAw49ZbMOSc+XZxNR1BY1RMkD7hOK3wenw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6324
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/10/2023 12:03 AM, Mario Limonciello wrote:
> On 3/20/23 04:32, Kornel Dulęba wrote:
>
>> This fixes a similar problem to the one observed in:
>> commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on 
>> probe").
>>
>> On some systems, during suspend/resume cycle firmware leaves
>> an interrupt enabled on a pin that is not used by the kernel.
>> This confuses the AMD pinctrl driver and causes spurious interrupts.
>>
>> The driver already has logic to detect if a pin is used by the kernel.
>> Leverage it to re-initialize interrupt fields of a pin only if it's not
>> used by us.
>>
>> Signed-off-by: Kornel Dulęba <korneld@chromium.org>
>> ---
>>   drivers/pinctrl/pinctrl-amd.c | 36 +++++++++++++++++++----------------
>>   1 file changed, 20 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-amd.c 
>> b/drivers/pinctrl/pinctrl-amd.c
>> index 9236a132c7ba..609821b756c2 100644
>> --- a/drivers/pinctrl/pinctrl-amd.c
>> +++ b/drivers/pinctrl/pinctrl-amd.c
>> @@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_ops 
>> = {
>>       .pin_config_group_set = amd_pinconf_group_set,
>>   };
>>   -static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>> +static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
>>   {
>> -    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>> +    const struct pin_desc *pd;
>>       unsigned long flags;
>>       u32 pin_reg, mask;
>> -    int i;
>>         mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
>>           BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
>>           BIT(WAKE_CNTRL_OFF_S4);
>>   -    for (i = 0; i < desc->npins; i++) {
>> -        int pin = desc->pins[i].number;
>> -        const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
>> -
>> -        if (!pd)
>> -            continue;
>> +    pd = pin_desc_get(gpio_dev->pctrl, pin);
>> +    if (!pd)
>> +        return;
>>   -        raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>> +    raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>> +    pin_reg = readl(gpio_dev->base + pin * 4);
>> +    pin_reg &= ~mask;
>> +    writel(pin_reg, gpio_dev->base + pin * 4);
>> +    raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>> +}
>>   -        pin_reg = readl(gpio_dev->base + i * 4);
>> -        pin_reg &= ~mask;
>> -        writel(pin_reg, gpio_dev->base + i * 4);
>> +static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
>> +{
>> +    struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
>> +    int i;
>>   -        raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>> -    }
>> +    for (i = 0; i < desc->npins; i++)
>> +        amd_gpio_irq_init_pin(gpio_dev, i);
>>   }
>>     #ifdef CONFIG_PM_SLEEP
>> @@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
>>       for (i = 0; i < desc->npins; i++) {
>>           int pin = desc->pins[i].number;
>>   -        if (!amd_gpio_should_save(gpio_dev, pin))
>> +        if (!amd_gpio_should_save(gpio_dev, pin)) {
>> +            amd_gpio_irq_init_pin(gpio_dev, pin);
>>               continue;
>> +        }
>>             raw_spin_lock_irqsave(&gpio_dev->lock, flags);
>>           gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) 
>> & PIN_IRQ_PENDING;
>
> Hello Kornel,
>
> I've found that this commit which was included in 6.3-rc5 is causing a 
> regression waking up from lid on a Lenovo Z13.
observed "unable to wake from power button" on AMD based Dell platform. 
Reverting "pinctrl: amd: Disable and mask interrupts on resume" on the 
top of 6.3-rc6 does fix the issue.
>
> Reverting it on top of 6.3-rc6 resolves the problem.
>
> I've collected what I can into this bug report:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=217315
>
> Linus Walleij,
>
> It looks like this was CC to stable.  If we can't get a quick solution 
> we might want to pull this from stable.

this commit landed into 6.1.23 as well

         d9c63daa576b2 pinctrl: amd: Disable and mask interrupts on resume

>
> Thanks,
>
>
Regards,

Richard

