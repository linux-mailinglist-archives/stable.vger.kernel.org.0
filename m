Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEFF50BA52
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 16:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448765AbiDVOlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 10:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448757AbiDVOlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 10:41:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66A35BD3A;
        Fri, 22 Apr 2022 07:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBh2S0A97qoUAvSAPfC3LD044kpdL9REqE+aCuVWM+8xygZwCcKQ8mFehJSPNghLMARuvCjdYAXw4a7RCvMyPLMQeC5lJBhtJUHEyk3CbPP3ClBZVbui0pLLzqM0uf2us7Lvzlv+JYw6FOvf4mz77gC45dWTxsbEDoyTRoFGAqgv9KhcCheWxJDH5UjPl5vXaUnKG5DwWnWx+rMU8JTbRlyS4tlE6kp/rEHUm2XbRGuL6iYOkCek/KzfxDCckZVATJB/COwt+EAMjdZV9EYBPc1COD5+enAc0wQwH2pmcEYwAZNQnitti5hTrz+3ARZbVXXT/kIo9evZro7MpwuIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ldpWoQ2FMaC6Bx8KapOF0Fb1x+Raqocg+nqTG6yIzw=;
 b=BdP5TBYBe4vFObx2+f15peMtcubv1ZV2fUq34qsyL9vjHXEDWzjee/EoHBafyf8/80gSNGbn1h+ZpOXDsNMy674Bm2MyE8L6AzxyWSPNrXl7ahcNkom0Lj5YT4vVN036F9TM8iQm75aw+rvkIrODCCiT0dum83CwfGSmhUkN//CkSV28g7CpDlCBbJ5CdQRofCUhofxtlEXwXtXKwCAz+SfE3y/ExRQAD2TfvK7veBL8DNl5CuYFGyG72efp1OsObqcb22MdjffaLwxASPK5aOM6N+PrSM8KxNYywtoUn4k8Ns80TMuB0CSxoUP0ygLy0U3eW9RDf0rhp3HDpszIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ldpWoQ2FMaC6Bx8KapOF0Fb1x+Raqocg+nqTG6yIzw=;
 b=zyhQEK9kT1lw5AJ96hVyoDreuvVuHvr7oI/pOfuPag5Hw9LD+mIXh6wrp/9PqanrQ46gvkXJHP1dWNDBRWUbu2UEE9KEdMsAti/GKgwOLswjMkgzv+Al9dAjUN2pbhIfZDSD74ycmvmA8syt98dlSECU8DOFg+emveQPdH11m2g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BYAPR12MB3447.namprd12.prod.outlook.com (2603:10b6:a03:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 14:38:17 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%8]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 14:38:17 +0000
Message-ID: <65720c2c-2d26-23e0-95f8-22c297270cb6@amd.com>
Date:   Fri, 22 Apr 2022 09:38:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/1] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     torvalds@linux-foundation.org
Cc:     Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Gong Richard <Richard.Gong@amd.com>,
        regressions@lists.linux.dev,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Samuel_=c4=8cavoj?= <samuel@cavoj.net>,
        lukeluk498@gmail.com, tiwai@suse.de
References: <20220422131452.20757-1-mario.limonciello@amd.com>
 <20220422131452.20757-2-mario.limonciello@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220422131452.20757-2-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::11) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cd7c277-e58b-4c62-9553-08da246dbd5e
X-MS-TrafficTypeDiagnostic: BYAPR12MB3447:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3447A5EED6D0DC81F2F5538FE2F79@BYAPR12MB3447.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EihdSwIyGnbdT5tK0Nhyn9AdNUdj2eJ5vk8l/4YMktTdL4Opu9p8enN/Y/qkNfUo4KJV6l8g8UHG52WaxGyhnH4B4ZDERiQfFDEcAl+s+ioY0Fn8XyVt6THnvxnxf53rBQfG3jrdGWtVHM362XhwqBBg1u6cAmvFf9h11oCuowmJcET/9+MP9vVbrfreg1QKv3Kj3YCWP3uastS76jfG/KCETrTWoYvnX95yCd7/0sneH2pTZJuTsqjl5eyhfony8roIwengUAULZs7deaRpCkTtWvRdUoLfXErLsS3ctS9fQwDHZZ0EDwKWF5kS3Ncum5uVrjEdOZwhK669EdFjA+FJT7RXraDpWCF80BxwUMOwChNsTzO5Jnas9fD6JkiUCLmmZ92b73J2tD72Mi//pxeMWEGtCOPfHhMvQYKJ/gjkem7RoJrtWFYyYhQbECCq7Yu62dfW22HdFbgN2e2EGJDULTZ5t418UR3eNs+WUbUGxeR09JBHdSKsRtARgnRfZa9iq/PjU0ctalVYiGRvMHC3DdgQyXOEvO5Bb00vVmK5Gf5Xowjgy++dhRk3dJ/NHMHx4Ckfz+6LbcpJkLSl6z4hlNF5n2kIKsy5yP5yz9105kM1iVtgNYakhYIVX/5k3GFYlWJMWwkOxD8XEdN8O28rlT2/GpoWOIRowC9mbgsKQWgJQKe+uzbLanNusKFBHaBrJNC956w5XTdrkV4NoqwuwfW8+iIdptFGU+eFy9y2ZUhKYM1dhAmANrzRhWJ1Xiwwqw88TbYNXXXvFyS/yI0WMni5NlUOkj3GxT5ANaWObkGHr1tIvHLfERrVIt13uArr+7PLb+69NC5fd9FTPGIINAxcuL8AH7SxmyHzMd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(66946007)(66574015)(316002)(38100700002)(186003)(86362001)(31696002)(2616005)(5660300002)(36756003)(54906003)(83380400001)(6916009)(26005)(31686004)(508600001)(66556008)(6486002)(45080400002)(8936002)(6506007)(2906002)(6512007)(966005)(66476007)(53546011)(7416002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWJTM0RidzhXb3dtYXN0VkZhbGdxTjJTMFpKUVl3VVJBWXRjYThrQTExaVRi?=
 =?utf-8?B?Qk9EZXQwdCtYWFVBcXk0aU9UU29WZlFHQnNPa01QbmpLSGhLb08wcG5qYkRE?=
 =?utf-8?B?NlpBMjFtYWozcUVPWDJLMm5xS21ydlBlSUsxcXpSUHkvRmplZWUyeSt5dERB?=
 =?utf-8?B?OGJZbTJWRUNtSFRtQWtHTkNsMlFNcUJnK2R5aG1NSk8vOHhuTmd2aUwxOFFs?=
 =?utf-8?B?RjFyc1kzVW9VQWx0RmUzYkpsRkN0bGY5MzJsUDQvZmIwMzl1aGZtQ0F4d3dB?=
 =?utf-8?B?S2p5YUplUEFpbFdFZzhNL3d5aEhUWTBjeFdBMFBnbXhQZk0wWGx6cVVEYUhR?=
 =?utf-8?B?dkFRQlZQUk5FSjNiUnFKcUk2QjZ1L0Q0ZjFhMVgwTnBaRXhpY2lQMnZsTUdG?=
 =?utf-8?B?Ums5QmltN3Z2ZWxnZVEvaDR0UjUyRjRFdGZkMnZpMUV5SkU1SHJpTlREbDdy?=
 =?utf-8?B?TGhNakQ4Q3lpdDJtV2RweGdyRDRjV1dLVWwyZGdxRFJydXpwVEVGbm5QWWk0?=
 =?utf-8?B?ZHgwa0c1SFZrbS93dVV5S2NKNW5wWFI2c05rL3ovaVE1SDJSeXFzZlVmTmZm?=
 =?utf-8?B?NGdxN1hHdXJJWHZPNnlsdVNiM1BDSXNPWGErU0pFOE1Jc1QzSjdPM3hUNUxT?=
 =?utf-8?B?bmNja0p4R3lUZk5oUlRocUhoMWNtQzFXNForT01sZzJJRVZGVUtKekhNaHdK?=
 =?utf-8?B?ZERjVzMzL1pldENocVZqYzFNZHNwdUp2RGl4V3phOGlhSkljMUd6K0l4L3Bh?=
 =?utf-8?B?NUtIOWJyaTNncG5DbG80d2REaGFZL09BeWFESmpLbDZCTDA2eGp1MVNXeWtL?=
 =?utf-8?B?c0ZWcTN4dkdIT0p0MWI5RlZnNE1tOER3Wk5GVnROTUs3ZGVDYmoxYnBNdkh5?=
 =?utf-8?B?UDdlSHhicWdIWmc2VklXMGV6MDNkODF5Z2ZmdFdHMWhPZEFkV2F5SFMxVVh1?=
 =?utf-8?B?WVQzMjVIWXo2ZjF6YUtSclNGVlNhMEk4TGVkNkpZZWVwbWFUZUdMa2xmME5U?=
 =?utf-8?B?OGdRRlJaU0RmMThoMVhyVkpsOFJRdk0xVVQ4OWhySWoyUDRabEs2ZFNFSnZw?=
 =?utf-8?B?cHMxMDhYa2k2NldUSlRKVUYvSWpkWEtiZHJseDRvQnZMTWJrQ2ZhS29qWGhP?=
 =?utf-8?B?WUowaTBxbUUwdytvcjhyVUx1czE1U3VLTXRwZGNoNFRZVXhob003T29KR0pq?=
 =?utf-8?B?bFVKTzV3ODJ2UkJBRlFsUUlaa0ZNcVU2ZVE2MVlJTGNuYlFNQVl6UkJCa1dU?=
 =?utf-8?B?MW1CUk9mWFF1U240Tjk0SVNHV3NzcjNvOHRMNnArWGZiN0NvQ0lmV3UzUkpz?=
 =?utf-8?B?MHZXc25ocFhXRzdST3pha3B1OXZkcTJjenZhY2hJWk9BU2ZBUk9KRG5tNXVG?=
 =?utf-8?B?SW9MMXZRVUhDRDFtbHR0THlEMzU4WVBmaWt5NjlYTSthdFRyUkdXYXZkb3I5?=
 =?utf-8?B?S0N4UTNicjNYNkx4Y2s5VnFDR0NQSUhPYXhjOWpoSVg5S3UzYnNwZ3NVY1VJ?=
 =?utf-8?B?T1dXM0xZaWlSOVpVK1lQaU9TL1RndDlPTUt4c0RsTTBJSXRIdlVPSUhzMTZz?=
 =?utf-8?B?UjhFRXF0alhvT01PQTFDZGp3YTJrTllRQldTcHN2dkZOck9YZnlHWWJ5SnBi?=
 =?utf-8?B?UjgxRjZaNVVQdlpTTTg3eFVuT2lKME9rWi9qazNLV09nbU5GbDJpVlpnRXU3?=
 =?utf-8?B?U041QzVGc3JxcUF5RFpWd3Jxczd6aXozUytnMmdkYU5jNHJoeWV4WFdGSVdB?=
 =?utf-8?B?ak8xVkg4azlpcFNickw3TTVMSzBvZmNRblZYYjhsRUl3N3BFOWZGK3A3dkx0?=
 =?utf-8?B?RlZUd2ljS3l3OVEzUWZEUlorTStiUERMeFY3MGxxT0FCV24wVzVhZS9sVVFR?=
 =?utf-8?B?TDJTM0QvS0hGSTVyZWFHbVAzV0dnVEJKRDh3TUlGUVJtV2c1T3ArWS9jWWY0?=
 =?utf-8?B?VkhaaHFjQUk2SkU5c3FkZEhsdEtEWlE4NkVicnlBRGt3eTJVR1pRSWN3bkN3?=
 =?utf-8?B?MEYrK0JycklkQjZka2RHZ1dhdlVSRGYxNE1vYjdZcEhBOXVRUGk4ZWtmVWZH?=
 =?utf-8?B?emVDN1ZHQm52VldEdE56V1oxYk1nUFF2ZWNNUHNOY3ZOK0tJVldWLzFWTE0r?=
 =?utf-8?B?My9lL0lFVDhOMGU1QS9nRitlNWd5Tm05NWU2RFJPNWVSM0NUQ2xueW9qY3V0?=
 =?utf-8?B?YlJ2WXRldi9jNDZkajB6MzNBcU5xRkp5UTlTUk11RCtSejdoYk83MWpaZHpH?=
 =?utf-8?B?Vk1idkdrQ2FQTnZIK293cFRwSFY1UEV0NmtZL3dIMkpaQWV6Y0t2K053YWtO?=
 =?utf-8?B?ekdOTWJDWTFvdDFmZzRKckdCUE9TSlc0K3dCMVVjb1NrejNsSXJmQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd7c277-e58b-4c62-9553-08da246dbd5e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 14:38:17.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blqVURABGbIyAWfMCZVgq9fEPYm2dNhk51xQaFAQLPNtI/Zl0wjvnJ86VYvDxgd6eyu7jXZPoTaHtFffJl5YIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3447
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/2022 08:14, Mario Limonciello wrote:
> commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before
> initialization") attempted to fix a race condition that lead to a NULL
> pointer, but in the process caused a regression for _AEI/_EVT declared
> GPIOs. This manifests in messages showing deferred probing while trying
> to allocate IRQs like so:
> 
> [    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
> [    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
> [    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
> [    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to IRQ, err -517
> [    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to IRQ, err -517
> [    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to IRQ, err -517
> [    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to IRQ, err -517
> [    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to IRQ, err -517
> [    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to IRQ, err -517
> [    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to IRQ, err -517
> 
> The code for walking _AEI doesn't handle deferred probing and so this leads
> to non-functional GPIO interrupts.
> 
> Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` to
> occur after gc->irc.initialized is set.
> 
> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: Shreeya Patel <shreeya.patel@collabora.com>
> Tested-By: Samuel Čavoj <samuel@cavoj.net>
> Tested-By: lukeluk498@gmail.com Link:
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1979
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215850
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Takashi hit this as well recently and provided a few more tags.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1198697
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Takashi Iwai <tiwai@suse.de>


> ---
> v1->v2:
>   * Pick up acked-by/reviewed-by/link/tested-by
> 
>   drivers/gpio/gpiolib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gpiochip_set_irq_hooks(gc);
>   
> -	acpi_gpiochip_request_interrupts(gc);
> -
>   	/*
>   	 * Using barrier() here to prevent compiler from reordering
>   	 * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gc->irq.initialized = true;
>   
> +	acpi_gpiochip_request_interrupts(gc);
> +
>   	return 0;
>   }
>   


