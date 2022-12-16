Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03164F173
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiLPTLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 14:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLPTLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 14:11:21 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2055.outbound.protection.outlook.com [40.107.105.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D034717594;
        Fri, 16 Dec 2022 11:11:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNoNd0l8txLLa8ASYWHjDmOhQRYU5b6ATjl1iQYjNEo8LmpxC5phdlW1XSjjrRle4La1aZdNVbeLwl3909jPR6laNZCM38Auqkd9y/TZFFgSQG35/3deoMuehris9HZkQWVhTQtQ/N54WohPfeXJwG7akUPOr/7kBsJtBk5LabUF6Zu+8ZLnmK+/8UtItgy5Jw8WGUoLDMWwImA6awrd+8+rr/bCvKpOac8Oy64+LA0vGeIFzAcuBaelGZQNwt8yCFQFB8zK2Znx7SftbWGrvpa44jgkBch2rLfYZYfbu1s+gbj7kOydZvhfAvqbmzODq3u24QXTPghm+Xopr+p5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6VFmtnMYjWnDnKZsa3NGMgtgDHJoOs4jg4tBsdYabM=;
 b=AGIUPWCa2bLL4lOu8RE1QOeecDNHUzpQuv2fsmOL0k8UaeG9HfrcVA6eQkrFMNaiI64m7l1JeFA1Jk0fbWXiFzFETKvL9B+p4Rub9MoHIPV8UCMkznaDfA9x+Dv1Eyys8VcRVVZ8vzLr7XekNmyJ/AO+N8yb1n0X3/TPhXqsOISsbvDO95WucOqzf2Oj/l9EsRwflrmqjlP8wJ4i7aP3vUFZnQ+gVTgTl/DoZTRhA+cVBEYn9f/Ctae4YrmjYXceGrSLDZBJ5prSY4OVvq9u6AYz+S987jz2Vmyf9mV+ypowLtvm9tBEVWx7SCzlUpvFYNare5o22E1t2UZVewgung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6VFmtnMYjWnDnKZsa3NGMgtgDHJoOs4jg4tBsdYabM=;
 b=LZ9OXqCB+4nhD+gFf28NZQubVTY6kP89BushIk5/WAmnqE5hTl2RRy6G2h52AflS/tSRDqy5hQHEna4qLV+KhzoQxhzJL17fYkNKMG3x6kINLRXEnYX+iYON8FSWet9BOdDJpqb3PFcCiOxxQbxnMuz3wwoT2iFFZZmQw5sfUbv6KBMot+kjVGjSk5vhu2us9ciRfKVxNECT75pZ6nZSNpYrrD9850fpnidAq6qLEWVzHsxqcmOA3ZjFO34nuI5vd7eFv5rzIJ4Kz3SYZVLVzDjhwsi80QupOqWO6M4TxKhuzRWXIHKwxcn8o+xAnwW6mVrL7L4nC7Ub2L07iPxiAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB6719.eurprd03.prod.outlook.com (2603:10a6:102:ed::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.15; Fri, 16 Dec
 2022 19:11:16 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 19:11:16 +0000
Message-ID: <3c8c4cf8-9987-31d6-a19c-c18d9f41c7c1@seco.com>
Date:   Fri, 16 Dec 2022 14:11:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [irqchip: irq/irqchip-next] irqchip/ls-extirq: Fix endianness
 detection
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de
References: <20221201212807.616191-1-sean.anderson@seco.com>
 <167023926482.4906.17012979311813913704.tip-bot2@tip-bot2>
 <8e8bfa5e-f713-4590-95db-66ed6454881b@seco.com>
 <9a7ef68d94e7d0ca879b9f55f7634df5@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <9a7ef68d94e7d0ca879b9f55f7634df5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:207:17::42) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB6719:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6762f5-eb5f-4f14-ef39-08dadf994d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mRMD4UxBySzraFNbPMXNG6IFjCVOV8ArI+9cR3/3zDdq2rrQ/vuTsZ1qvhdVHWU3CPjYvMO/whSHM3NtST6uOjh9UpbUedeiORkJiD/wHX/5MP1ocV4GmcYoHWPFh2nxkmZei9SsnqfVxAsxCCIEAoxTevMO/HsN8/+W8J2LlNpVq+1sG/C+XgEIguz7hau6QzrHutlx6dkhWX3/zUKwhsiwyzeSkKaUELNAjz+1BKGClUPuiIU2hTVmaoRkC45qhOSVOAIEjWvM0GB0nMys9vDkxaTr9Wp34CggHkT2Qmbxpbl5vMZHkPU8+rCeKJ/P3DNB5gH+wcEZq7nG04IUYMCJjV73Vh4OiMFsSx6JGW39Tm3R4NaQZZng8oTNn8LyG4VutNhyyKqSZGB/roN4MZEeAbUd0gpz5n0f2pupOCaJTc8cBfDy6KoUSMizuJaJILHkybz8hL5a4+HH51M3TgBo1v39+083DPOXvSZuY33Ry7bbLHxiE/SH9iaFxhOesOecqAn/M/nrBiZk32QqRjs6dOmlzKYlu8E6PphiZ7B/fWN5vY6lWIOP6EugczSkiC1Qd6ci+0DT27r5jyA2OjLBbC+c+zM0YC4c+ypDxMkR46Sqx3yC7HOMXtAeSsKTbcc+jlQdAjcWmFRXQUt6L///yGnXpJH7t0dhmjKPkRNprMhbO4KeTWIaDkR3l2iukN52g1DtF4oYJdZtuUuIRy8Gwt3acNsS8UskOSEcHftDPG+XiHUVT1VDUegOBQ0NqASpmNaHdSuklkVPyXzOwRkdjREAr0npJ/TSbfh/+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(376002)(396003)(39850400004)(451199015)(2906002)(44832011)(4001150100001)(36756003)(66899015)(31686004)(6506007)(6666004)(86362001)(31696002)(83380400001)(2616005)(52116002)(186003)(6512007)(53546011)(966005)(6486002)(26005)(478600001)(316002)(6916009)(4326008)(8676002)(66476007)(66946007)(41300700001)(66556008)(8936002)(5660300002)(38100700002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjE0Zmp4akdtVXY3NzQ0MjRBallUT3Q4akdVRUVCYXBSNXdCZjJJYml5c1N0?=
 =?utf-8?B?S1FlR3lJcnloS0luMDZoQk4rb2xUSEc3d1NKcFc2UkxMQ3Y5SXByV2xNSml6?=
 =?utf-8?B?U3ZQcFdEVXZEcEFGUHo1ZDJtdVA2NTRCdXBGT2sxbFZBdUxaUjdMWUxLVGJ2?=
 =?utf-8?B?V2dtR2xTVDBlSHhBSDRPU1BVWkdGZjlXRnB3Mkw5YWx0TEZ4SW9yQjZ1eVZZ?=
 =?utf-8?B?MmNIZEtYQ3NRZHM3aldZOElDSGtWT3hhZ0R1RlhrZDMyaVZOdUR1R296V1Bi?=
 =?utf-8?B?MHRldkk2NWJXWW5sTGk3VklxQnJ1QWcwSGtScmwvQ2lxZ3BNT0J0UGF4SE1U?=
 =?utf-8?B?QW0vdnIrUm5abGpGOWd6U2RwcGhieVVXaEF6ekV6TzViY3pVaGd6YTQrT1FK?=
 =?utf-8?B?dmNPcnp4andNN3dhdTE4RjZHcm0wR0tRT2d6eThhcWV5Ylc4cVlTV2VsYlBE?=
 =?utf-8?B?elhRVUx2M0hWZDBLYnh2VEY3ZG9aeEFsMTZKNDljd1V6YlVNTDJoc3dWOWRi?=
 =?utf-8?B?NGVzNGF0OWo0eS9GSlJIb1MyZTdXN1A3cElJTWlGaHRROGdzakJLNzlHNlhw?=
 =?utf-8?B?cG1wOG9SeDFsUDNuMytlb2t2MCtNNHdzNmhvaTlBOWo1bUJta0didDA3QUNq?=
 =?utf-8?B?S2d0MSt1empreFN6bVpiTThqd2QvSFI5Tno0a3k0YVB0Wm9STklsQzhjNSsw?=
 =?utf-8?B?ejVqRWlnV1puT2Y3d0xwZnJuYjVXS1AwYkdicHcyd3JVUEFnWitXcmllb0Qz?=
 =?utf-8?B?SS9RTjFIbENPcWYrSGYrZk5Wa245MTdGNEZqU2dBT1pYamtmK3dPMjVKSTdw?=
 =?utf-8?B?THoxcUgvdmJRZkRCS2ZqK0VZbWc3NC94ckJ3WGEybzUwd25uTElQSDQycDh5?=
 =?utf-8?B?U0ppdER2NFlEZHpXSWd4MFQxZ2puajNGK0ZCRjNTRytXWGQ1MVVxT1BnNGxF?=
 =?utf-8?B?QUxRUFV0RW92V1Q0MDAvVTU0QXpzRDlQVlRzbWxnMGMrWnZXcFplak0rZENC?=
 =?utf-8?B?L3U1WjcwQlh1UEtBT0twWGZoaVh0aDFhUlo3N1o4VHNIWjRqTzlIL2MwZlN5?=
 =?utf-8?B?NDNOWG1tanliTDF2QVM1dFlON1R3VnJhS1BKd3RLNmVjcmF4TkFNVmxObCtq?=
 =?utf-8?B?NmJ5QXhmWlN2NlYrOGRBaXoxS1pqVGhLdE1qcnRJUm9aQkpGTzBGRjhSUTZV?=
 =?utf-8?B?VG1nODFBWU4xd3pSR3F6amozVXdlcjAvVDdrQUp4eC9oLzdTcjBwME80Z25K?=
 =?utf-8?B?bG1WeGp0ZCtFR251SW1qb0VreTJIelhPL24yMzVDSFNKUWxqMmNaZzNDN3pa?=
 =?utf-8?B?MFdscE1JVW5hK1hoRHZUQVhVYkhiNCswSHJrbitBczNFencxanlRRmVtRHVH?=
 =?utf-8?B?eXVrOGN6bjBpeVdSQThNaThIUnRnak42ekM5Wms2YUgvU21BUCtWMUY5ZjdE?=
 =?utf-8?B?Uk1pZkd1eGtIY3dUc0hUWGI1cFRsdW91d3dVVGxUWFNiWjg2bnExVFpia3c3?=
 =?utf-8?B?SXdsbmtBZ1pFZmMvc2orYkhOUllBNHZTZzlHTGlmR09WTEZxMTRici85WXV0?=
 =?utf-8?B?aU4xMjEybS9FR2M5d1BpVjdsemVlQXRQLzRseDJKeTFuWkQyOWFzbEhna2pR?=
 =?utf-8?B?QVJNbjZVeHlIc2RwZ1BqakVQYVJ0UUc5eEpCd1crWFAzT0lZbGwwRjZEbmlo?=
 =?utf-8?B?NUtpTE9xZGJVWit4bE5QdTlmUy8zWjh0YVdxNTJOVlhYVmhQMTNWVjVCUXU0?=
 =?utf-8?B?dS92bUd2d01Fb2kyNUJqbVp4aStoYUdTeXdDRHNOLzF4QlM5UEUybVVmZFBE?=
 =?utf-8?B?Si94dnJYZ2JtQW1ybnY2TklaSWg0SkZLOWpaTmpYY3VVRVF3T3FmN0xWNUx5?=
 =?utf-8?B?TURwM0JwSHpaYXhhQWJuSlY2d2ZGZmxsdTBFaFBET093YmtVdHlqVU5pUG9m?=
 =?utf-8?B?M0E4NTRya0cyNEtnMk1waFpwNzdrZkZqR3lXYkVXYloxYnBMNTBwdEtaMzNY?=
 =?utf-8?B?eklWQTdrUXdqaldGZ0piRnhFY1pLdlFWT08weWF3QWlkekZQWDBYaGlkVG11?=
 =?utf-8?B?TGhOYjByTGRTcjRKcDgzZ0FwcVEwWC9qdTNjd0g2QkNacW5QSzk2MmtpU0ZB?=
 =?utf-8?B?NG1jcDliWHFuZnRIQnV5QXg4c1UvK0dDdnkxYXFLaVNUakUxTG9kcm9LK2lr?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6762f5-eb5f-4f14-ef39-08dadf994d57
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 19:11:16.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxYFa2EsyaVICTh9RSVrHdJqqFcgo6OmGVB0HER3PrCj0+7L4MnKaeI5nqlOIljC1kV1P6YXQzlzEdaUwrFkYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6719
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/16/22 13:22, Marc Zyngier wrote:
> On 2022-12-16 16:37, Sean Anderson wrote:
>> Hi Stable maintainers,
>>
>> On 12/5/22 06:21, irqchip-bot for Sean Anderson wrote:
>>> The following commit has been merged into the irq/irqchip-next branch of irqchip:
>>>
>>> Commit-ID:     3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
>>> Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
>>> Author:        Sean Anderson <sean.anderson@seco.com>
>>> AuthorDate:    Thu, 01 Dec 2022 16:28:07 -05:00
>>> Committer:     Marc Zyngier <maz@kernel.org>
>>> CommitterDate: Mon, 05 Dec 2022 10:39:52
>>>
>>> irqchip/ls-extirq: Fix endianness detection
>>>
>>> parent is the interrupt parent, not the parent of node. Use
>>> node->parent. This fixes endianness detection on big-endian platforms.
>>>
>>> Fixes: 1b00adce8afd ("irqchip/ls-extirq: Fix invalid wait context by avoiding to use regmap")
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Link: https://lore.kernel.org/r/20221201212807.616191-1-sean.anderson@seco.com
>>> ---
>>>  drivers/irqchip/irq-ls-extirq.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/irqchip/irq-ls-extirq.c b/drivers/irqchip/irq-ls-extirq.c
>>> index d8d48b1..139f26b 100644
>>> --- a/drivers/irqchip/irq-ls-extirq.c
>>> +++ b/drivers/irqchip/irq-ls-extirq.c
>>> @@ -203,7 +203,7 @@ ls_extirq_of_init(struct device_node *node, struct device_node *parent)
>>>         if (ret)
>>>                 goto err_parse_map;
>>>
>>> -       priv->big_endian = of_device_is_big_endian(parent);
>>> +       priv->big_endian = of_device_is_big_endian(node->parent);
>>>         priv->is_ls1021a_or_ls1043a = of_device_is_compatible(node, "fsl,ls1021a-extirq") ||
>>>                                       of_device_is_compatible(node, "fsl,ls1043a-extirq");
>>>         raw_spin_lock_init(&priv->lock);
>>
>> This patch has made it into linux/master, but it should also get
>> backported to 6.1. Just want to make sure this doesn't fall through the
>> cracks, since this was a really annoying bug to deal with (causes an IRQ
>> storm).
> 
> If you wanted it backported, why didn't it have a Cc: stable
> the first place? In any case, if you want a backport to happen,
> you'll have to post that backport.

Usually, anything with a Fixes: tag gets picked up. Actually, I was
expecting you to submit a PR for 6.1, since this was submitted before
that release came out.

That said, this email is "option 2" of
Documentation/process/stable-kernel-rules.rst, so I don't think I need
to do "option 3".

--Sean
