Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05017652122
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 14:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiLTNCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 08:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbiLTNCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 08:02:10 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2097.outbound.protection.outlook.com [40.107.20.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A9615829
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 05:02:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6AJShqNBR/HYnZ/WTmSUEFFg3A5WOV+6/4BDxJeCa/u30aFF6FCfeFWTxN+/xLc3/80Xj9wbW3NIGfOB9HKy+VLG4cH0aIoe/5OAx2OTPZPQVoUDou+GAlMi6O6dH0vh3t4yScshsCrJqLoa5eCLCoPejCh6G13mq1cmzUI5KHdA9OD/7fQ8Tck5S+ZrcA4UFSeMxLd+C2er6326ITVc0ETK8v3wYZ4DaL4sZPzsXvxG8qIphHCW4A6ujh5FKjLrSV3b2FOFqsvV2lkeHKCoPQi3I/TYbrvFgbHUqXIXn7QCchgq7UzcLLlzASWHDfcQN24y188HP8xwDCNT5wqEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxUW4VeYocYXhBMc4ob2R+LS0Cy7hloT15P3QQ6X1PU=;
 b=EqbNuzBFZxIeOJmFLXKD2VXJ3tGA3NrWfcLS/LGufuxaDbzP7Bu6RiFadsrwUNEAzxVw/xgAXDgVmVjf4Ok4Rypbv9uKXqN1oXDoxmBuR3UozFH+pwmska/h37t53CQPeIdBASScUjzu+6kq+LHRvQY6ZT+3M0wKBiYMUwYQlOwh5+XPPzvUv2tbVdYh/pnGgbtYU6yfEUbhWNZ34CNwa+dMOq0ObxC30AzuDw0H7nCsSiIwNyOFMRN1xuHwBg8JIFaRkxNNJPV/ggCEvPGyPPSvB3SjrAi0GvtoA5OngSYd5/BHtj3WtbfEJmcoa0u54xLvBQf/Sg1odRmGp9u+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxUW4VeYocYXhBMc4ob2R+LS0Cy7hloT15P3QQ6X1PU=;
 b=LAhs5yYZVf+7q1M0S/2w1tJbJ/J59H5IPPAYl7HO//0a6s7cjQVMykxn4ihHpfhZ1uHY01HMGWReM5sleYQujX8BUfitdnN/8NZcGIypHZOlnlRqbygM93RBP47wMhh01IGPU6zMVy3c5NWNQNfmoEyHeLKp93LGH7r86GYhKbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34a::22)
 by GVXPR10MB5790.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 13:02:02 +0000
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::722b:5d41:9862:10e5]) by DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::722b:5d41:9862:10e5%8]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 13:02:02 +0000
Message-ID: <e50b4810-c787-2e33-5cb4-b068c878fb0f@prevas.dk>
Date:   Tue, 20 Dec 2022 14:02:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: commit b079d3775237 in 5.15.y
Content-Language: en-US, da
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Al Cooper <alcooperx@comcast.net>
References: <38a93e7d-f716-e908-7fba-7570299a6fd3@prevas.dk>
 <Y6GCluSzwrnmoENo@kroah.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
In-Reply-To: <Y6GCluSzwrnmoENo@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0021.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::26) To DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:34a::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB5266:EE_|GVXPR10MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d25195-9352-42a3-5e62-08dae28a6305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Qm69CvXoXTnFwnfVwtzcBLVkCOaDsuvnOO4R0OoQ98924GX39ji/3ccbDuJDqceNepA69iwuHQGPwiHJHSr7q+vucaXQNMQLvvhYtO3EGjZlBQnkE2qWc3CDo+NDJi/a90U4qn/vGd7skNPT1UpDEzfCzLECt8cYK8S2l5U/kXfkM7dtDWGdtQHMekAlTpAHS4AfbDJqWhtCww31viOaHo6c5VYe328/ZR/5YWMjJY3TSpli86XlCF0ZW1CKroN36v4qt4gexiXETwtRD0x65p3xpELoM6e8fAkJv+ICGO/2rkehoegjDdnh0Qn7xBp6Xf9gU0NB7TvCOrWHzhsLhBKVSOJrTNSv8Jzx9UKL2xcvVNAZIQXCooNI2/81dWZHzfefNeb+3YpnXfiUelGY7IXn2Ljc41OkERiF868r+Ed61qhcZMT3l/CWiD64Th8GHkY6o6429McX4t6pYUAsH7m1I0CR6vfGOhanXnNF4Mhhr39K+CFQtEkX8oAKgF0JfNrhCu0oTyOoEmhkjeb8e7vPWt5HIl8NVIxqtWQMPis42pqd7zXDUiBL9uOkR2DxXdB64avBvKQKfRGNO6i2OjtKw+RVhsjMuTWZQ186RxuDN79IY59Ye0wumZYMK9zv82bE/mqHKgIs22djY5S3Eu9LOLusVnlRIZjdmNfYVzcn9TBqdJ7YgdKhm370ObLvLTJBQCAhZUJLgizH7FtaaHlgaL5rN40aVv+yqjIputB5fF3t/Ox8HatF/+09L/g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39850400004)(396003)(376002)(346002)(451199015)(54906003)(6916009)(6506007)(316002)(478600001)(6486002)(38100700002)(52116002)(8676002)(2616005)(36756003)(86362001)(4326008)(66946007)(31696002)(66476007)(66556008)(38350700002)(31686004)(5660300002)(83380400001)(8936002)(8976002)(2906002)(186003)(41300700001)(26005)(6512007)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG5Nck5LNHhHNWtUOEJDNTYwWGNUemtjS1llQkhMU1pZb3BaRVJLUDloTnl0?=
 =?utf-8?B?c1pQUmpKSFBPc0d2SlZEbDdFbVVRYUlJUlVJdmswVUdISXd4bVhaaWxOL0Zx?=
 =?utf-8?B?dmhBYXZYaHl1V2NneU00VmtuSHY3WjlzYWJIREtEbEJQdkliVnQxVDg2TC9m?=
 =?utf-8?B?a0NidGowZG9ZbStYS2pWOUpjbHcrWVVYckZtbjhud3dqWTQyWHl5K0xXdHpS?=
 =?utf-8?B?ME1NYzZEZkFqMnFoVmVicWdQMDRCelpvTXc3ajhaNVVTZE9IVWh0U3QrNFRD?=
 =?utf-8?B?Ky91TzVHMERsN2FCZXNSY2EvZWJ2bWw1Tk1uNUdNRlJmSDluMWh6cnNnTWVD?=
 =?utf-8?B?OXFqeGkzbGZ4KyszNEtZVXNveGMvczhpZXczc3dLS2hab0t3SXBwYnFMa3FM?=
 =?utf-8?B?QXRPQkxKbjNRd2V0SEJMS2FtWU45clBkM3AzR3BYbnVFYUFMV29Hc2NVazFx?=
 =?utf-8?B?MWJkMVd3VDFINjRHMVlySVREMlJmMTFmeFJEZVRpK2M0SE1DV2lYMm5YalB0?=
 =?utf-8?B?S3hrWWwvVW9PRTBUeVMwVm0zdytYcE1QaS9ndXEwV2ZwbkthckdsbC9qTW1Z?=
 =?utf-8?B?Q1FOU1J3VkxlemxRVGtQc3pHUUlFMndqQmdwSTFvRk5pYng3MlExWUxvbUNi?=
 =?utf-8?B?MGwxWnpPL0pVcjgrbkRyemlvNnNFQjBCYkNaVi9aaG1GSkZSRS9aeFkvbkVV?=
 =?utf-8?B?WmJ5R1N1M2lmN2pEWGUxL09jUHFUdjNlTXkzSTREOTV0RGxhUWlJNG1NVi90?=
 =?utf-8?B?VTQ3WWNvNWJIUzhTZXRJVnVjQkJEMVBNVmUybW9OdVhkSGpoSnNSTERjYzlT?=
 =?utf-8?B?Z2VCd0JTRTByU2FUNVFaeEhlVnBVZWIzZU85ZENPbUFPbGFySGNZcnVLRWhM?=
 =?utf-8?B?MUZVcDBrTkllOERBaDQwSHlJaFVnZ3VyNnJSQXd3TFltNFllM3BFMjduTUkw?=
 =?utf-8?B?MEo1T2htZGVqREZpaklOR1ZFNFlUZGd5SElUWEFibWFWYUptZkxrZTFJTFJR?=
 =?utf-8?B?Q0t4N296T1dRb2wrTTU2bmtrRHdUN2V4RllyUURrbzNCekptQzUzWDV1a0Vj?=
 =?utf-8?B?cmt2UHg5aEl1aGl5V3M1QU05bWFoWnJCeTVlTC9PTVV3RThtemtOeEt6UjZG?=
 =?utf-8?B?ZFVwWnlyRTBTeGlyS0VHa25BbzZxQ0FNTkwvamFGcFRQYWVFdFRaNTh5UFlr?=
 =?utf-8?B?OGw0MUg5bXBkbVZSVUY4K0pOMDhjRFVZSkwrc1IzVENWSU4rUncxTDEySGtS?=
 =?utf-8?B?Yk1ITnN6My9nYTZxQXRGN3B5UHFyL2tYRDJKS2FyYmUzekNBTmE4d1VmY1lZ?=
 =?utf-8?B?M0dQUm1iUzBsc2ptWFphb0Q1MFR5ZGhMeUpoUUpzV2dqNjRBRmU5dXRLcnU2?=
 =?utf-8?B?TkIyVE5Xc0NXZmh0c0lqTllJbnJpRzFVZ2hXcUx1U3A5U09pcWVlSVBZM3NX?=
 =?utf-8?B?aWxSYlUxOHZSQnZLZ0hUUVYrdXdKTWRZeld5cWlzendrbVFPaW9CVWJ5K3Vj?=
 =?utf-8?B?K3NHS1hPTGFvK0xSR05NaFB0TEczYldSSE5uOGxPNVJDS3o1RnF2c1RUT29K?=
 =?utf-8?B?bE5WNEJrTXBMd295VTA5SjFWNVNnczN6REdzcmhKajVNMmFLUGJnN0dtSmtn?=
 =?utf-8?B?Q2l0SFU1dm8wZ1RKNzhWYTJ5am5FNnpXT2hUcXBZK1FNUkk3ZHBnSjJZdE5Z?=
 =?utf-8?B?MVBSYnpVdHdjV3NWdGpwRDVqS216KzVydEVwck9qblRTMXpJOUpkL0ZiOTF2?=
 =?utf-8?B?YUFoNUg3b29jMjM1MjY5cnJtL1F1bnVpd1h5RzBNY3pZT2JXTUhzdW02WTZ2?=
 =?utf-8?B?WkIzZ3hCSEtlOWFHZmMxUXZRK1ZIVzkxYS80T0ZwdUwwa0NBUEVDb3pENzRx?=
 =?utf-8?B?VWVQZ0VhcTQxc3JMNkNpQmNic3U2M0FESDRZSWxwM2RqZ1B6WWVEdTd1cm13?=
 =?utf-8?B?a0tJSTZiQnpsaVVoSlY1Ujl5aTZhRVZkRHVLVnY3dDRBNXpDZzR6eitMSUhJ?=
 =?utf-8?B?MHJmcFNkbGd4NGtSUUtwdTJUamYycGtoa0tHNWdMclN5TU5MV0puMDd4bGs4?=
 =?utf-8?B?RnZvSkdjUmZ5dnczUHJYdkFmYWFPeGxEMFpHbzRRNENlUEJYU1VIOGRPeXRX?=
 =?utf-8?B?ZGpxQ0RaN3NWN1NBVHlmWkNIRFRsSFpWZzFJSFc0eElRNEtEbFY4VmJ4dzZM?=
 =?utf-8?B?L3c9PQ==?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d25195-9352-42a3-5e62-08dae28a6305
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 13:02:02.2569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fduE0Ionc/A8Nzpo9MSdpz1EeRymO44ZRRKWn+NYaxjnAAqxMd9+eyvw/pEU4mJCmR/UIB0EvDw1XkrWh86TZB/XkH2U2KqgDYaSMabkrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR10MB5790
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/12/2022 10.38, Greg Kroah-Hartman wrote:
> On Tue, Dec 20, 2022 at 10:16:38AM +0100, Rasmus Villemoes wrote:
>> Hi,
>>
>> I think something went slightly wrong when 7c7f9bc98 (serial: Deassert
>> Transmit Enable on probe in driver-specific way) got backported to
>> 5.15.y. In fsl_lpuart.c, the original had this
>>
>>  failed_irq_request:
>> -failed_get_rs485:
>>         uart_remove_one_port(&lpuart_reg, &sport->port);
>>  failed_attach_port:
>> +failed_get_rs485:
>>  failed_reset:
>>         lpuart_disable_clks(sport);
>>         return ret;
>>
>> in the error path, but that is missing in the backport. So if we now hit
>> the 'goto failed_get_rs485;', we'll do uart_remove_one_port() while
>> uart_add_one_port() hasn't been done.
> 
> Ick, can you send a patch to fix this up?

Done.

But a colleague just spotted another difference. In uart_suspend_port()
in serial_core.c, this hunk

                spin_lock_irq(&uport->lock);
                ops->stop_tx(uport);
-               ops->set_mctrl(uport, 0);
+               if (!(uport->rs485.flags & SER_RS485_ENABLED))
+                       ops->set_mctrl(uport, 0);
                /* save mctrl so it can be restored on resume */
                mctrl = uport->mctrl;
                uport->mctrl = 0;
                ops->stop_rx(uport);
                spin_unlock_irq(&uport->lock);

is also missing. The context is different; the /* save mctrl... */
comment doesn't exist in 5.15.y, but was added in commit 18c9d4a3c2 (5.19).

I don't know if 18c9d4a3c2 should also be backported - the description
does sound like it fixes a real bug. But probably the ->set_mctrl()
should be guarded by the !rs485 regardless.

Rasmus

