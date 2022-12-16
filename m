Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1C64EF48
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiLPQhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiLPQhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:37:41 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2085.outbound.protection.outlook.com [40.107.249.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765772DAB9;
        Fri, 16 Dec 2022 08:37:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOhKHBbU7NbYvDt+ME2Uqiv2FRDjak6tuTWYskOspRofZn/oPRxq4iFR9uxBqhp1nqQB5Oxconsp48KQoA3DAsVfdtKDsQoUnyWmWKxBrsfWvwcN7VRn+5Eh4nyNfMh7MDD7uyjn8YItg17BZ/UjOgSeTzhb2I7VM4jqWBUEz3saOQz1TDHXsV2+Tdr+0cEvq3ieYGV0Z8LBycKWS7N752DPRdZgik62thRuKtG+9ClngDmVudDYAlrGaalZHqMgGue9DeNPIqSoJgBrYexOJXQyAUe/AGZiPlp6GFYAduhtNHvxc5h4RuSHUZP1PtQa13DFAfyu0Agfs4nhhSUJ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n708eu4gmQawkD9vaUfhFUJO5EOVc+WlVw2BNm80Xlo=;
 b=li7xkuELkwoD4Y9Tq062nIqwcbKkI9P4u/eo7xA2XgDK2bCh3BtppiBChK02JLTvGyagvam2e4euNXQGTxy6oxu3MeZ66GtV2rKk96OVSrlH7pegPCfb3H+pAmqCuB0NdK6MCjQKmYdri8bPXhN5GYIoyVE8fkh4JHttdPEY3WceeeXZh02CRDHh2uPgNec3EvjqwQl+DaCqD1SA0wGj2GFdrlC5bOnTxXxd/XvSDxSPirp+0t32Q2f0I7gYAn/623v0SIzTAFa0fRGI46EiwoT7cf8AQb8hFCuvHkf7cu5ycQS5vvjPScTAKu/mMSrMJkbeU40LI58Enb20Ti31sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n708eu4gmQawkD9vaUfhFUJO5EOVc+WlVw2BNm80Xlo=;
 b=sIxkhM9QDrzyhQYinIoP4nf8/wNb5Ml8uBthAjOCD00MfeHtmAJQGueBZsYAj1e3NZzwEyyF4fh6dqjTod+dth5IfIstTpidbytO6Lhet8wAUV4HOISK4Ai7Y39jERuw2AXeHOHK3fSsqkioSf0vfzoTvpTnzGpueggqRP4ccREDpJc9q8FcorSqYvPBt8pwyA3plMykm6+J+uivy3AsE6RAzfiIc4ItG5ea7Rz2Uq2EkKJt2P0KW3GiWVwrCvLG4xUa2dUXD3eWZFPf2JvPw+mIPXml/53k988UH9/4hitKN81GJqMp4pdyDnotIYrERaTss7A6r5jwFiZ4nebSBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB6757.eurprd03.prod.outlook.com (2603:10a6:20b:292::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:37:37 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:37:37 +0000
Message-ID: <8e8bfa5e-f713-4590-95db-66ed6454881b@seco.com>
Date:   Fri, 16 Dec 2022 11:37:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [irqchip: irq/irqchip-next] irqchip/ls-extirq: Fix endianness
 detection
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
References: <20221201212807.616191-1-sean.anderson@seco.com>
 <167023926482.4906.17012979311813913704.tip-bot2@tip-bot2>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <167023926482.4906.17012979311813913704.tip-bot2@tip-bot2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0021.prod.exchangelabs.com (2603:10b6:208:10c::34)
 To DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c2ced3-d1fc-471e-f020-08dadf83d74c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfSYbIqQAnA6v0MEjJib/qfodLCapeulEjdNuI8JUeMZdKJqJZYcSvPuZWM5ZuEdrYJ1zzsEn6i6mnPgHGv0R/tC2rRnEjMBlnzi+eF4O8qHg6HpCdOM7lCVfY4IZo/ibr4IBFXW4preZ86k2Ltg00qKm6TS6r81hwjn/ZP6fywOgBytPLb1k4MHkR76VoP09MIDOgnuRTMRZ2Yp0ykhEtjUAiEQcwPuEY/z6lyrmTjkHeQfUry+AsNpPyPcg2Ck+DVRUKd6HxKbQXxjMTQpNGJDMu/uDnNrISFKhRRsCthkCfAKAIXCv/84gls+8cWPtSGiUurEVbvTMAxPsq4b72YAsUHfS3hAVk+kZ9YT0md6jjfrMyb04NOow/g+ufFtAHO0cH66xqccHdkboTZR7+pY48V+OYvb0OXAcnv0JyWHk3TG0GqXG+nFgCO+j9FAG1BAmAVyH+TQq9pQ13wXEs/1hMLrkJMGujykaD+ObD3L5wrAueCAweYrprWmasi7+1rA1tByzSVHtBTx/i774lJ00GltWNNnyGusc6N1XT+Y9ormsD4/oXNeXFQ/tO64HH9TlsLv7YinCojIfl2A8OkoRNKTXFBCy5Ut7tjaPXUuI3wzHyreJpv+7VYNF0klZ5Gd6CoQYlnZKe/sTQ1nu61poIgHlYXiiJVYXhgp9eV3h6M5fmyJt2cap3gGk5UxZ5ncNU7lJuwA8dMCJhSAL3MhhP5NdXF8pzP5mSVuRCZnpTZjiQpbHbXygYow7F3psJaGunpdfD6cSOWoQN45Tg728yjMHVG/a5Z6nbflge4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39850400004)(136003)(376002)(451199015)(2616005)(83380400001)(66899015)(31686004)(478600001)(316002)(31696002)(186003)(86362001)(36756003)(53546011)(6486002)(38100700002)(26005)(6512007)(6506007)(2906002)(966005)(44832011)(8676002)(52116002)(8936002)(41300700001)(5660300002)(6666004)(38350700002)(66476007)(4326008)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzhoVEZBNVJ3bDBNeDNUQXJ2TXBnTzZ6MFZMVHg4MGRsRkNicVV0UTZSazhE?=
 =?utf-8?B?dHNwY2xqN3RQZnhEeTY3MG9DV0RlcFRFZFhkc2ZqTkhoM0x2U0Y1cC81UE5G?=
 =?utf-8?B?ZC9KZGFDVmtqNkxzd2ZuSFFoWGdiWEZXVU0xcHd2cXE5ei9WblhTK3pMa0g4?=
 =?utf-8?B?T2ExNmY5MGJJa3d6aWFlNUgrMGVIL0tUL2JTMWVFd2NUTk9kYVBtTjYxL253?=
 =?utf-8?B?RnRPSkJ5T1d2YjFRbmdMTExZOTYzZS9iNENpZDE5UDlvUlM5d0lwK3QyTENK?=
 =?utf-8?B?cjN5MnB5bTlyN3dnSzgyME9ZQy9lOUw0bklncEp5UFlKNXZtZkJSWWJJMXFy?=
 =?utf-8?B?OE15YncwSUpabHYvaEYwT24xMnlyOHVjTGhac0pLeWtnYWJwSi9EcHFtNzBp?=
 =?utf-8?B?K05Nend1ZzVwOU9MYmEzNW4vZEowTTdqVHdUZW9vc2JnUDdJQlhRSGwvWllL?=
 =?utf-8?B?cjhKUmVabW11R2ZQS0pLQXIyaDlXbExucEEwMEJjQzFHazU0Q3JFeFNiNEVt?=
 =?utf-8?B?WVBCNmFyQ2x6cklUb0x2ZkhQWFVJUE9SWWxyL0dkalVLWlFGK3RTbzFTakJC?=
 =?utf-8?B?ajJtS042Y0ZZQk5xdjVjM3Nyc1lveHhTV1l0SCtIWDBRU2ZXNFU4aWg3K2g1?=
 =?utf-8?B?Y0JDZmpJb1o3RzdNdTQydHAvNXh5NTBvQ0FBekNlVlhwZ2wwZFUwZWdwL3d3?=
 =?utf-8?B?N2VycnJlNjZNR0s4aGtiKy90eXFzaHlwK3RiMHVmMEl5YXU3K3g5UzA5VHNX?=
 =?utf-8?B?dEZ2NmQyeDNVZ0dyYjMrUGtsajVORCtFRktiSDBLQ01WQ0pjaGwyOWdDejU3?=
 =?utf-8?B?OVRMdHBYUUphS0VCYjNHN0gxVEM0UmJJM0UrSWluc3lEV0pGUXY4NG9DVW9h?=
 =?utf-8?B?YVJma0p2bVZpaE56NTQvQm9UNHNTaUhtZHAzQnJ3VHhIeXBYTGc3Y3N4ZkFl?=
 =?utf-8?B?UGJSY0phcjFqenVadDFERlBReEpkaVFIT3VsZFBxbEkzSThHSVU0cHArUDBJ?=
 =?utf-8?B?WVkwL1RHdVo0cngxVVRiaTZPWjlLQXdMOFlVRXc4VDNUTTJOOWRNTmhwcXVG?=
 =?utf-8?B?SFVHd1RtSDE2eEZUN0NaZnpyYUZaeTlUcGhFdGpEc1BGZ3FBd0kxakxHaW1L?=
 =?utf-8?B?cDRaNFpNNGxSNFlRek43ZzE2d280cE9DcU54RFFtV3pRZDZXSEVRNndSZStH?=
 =?utf-8?B?cWhFaTNsMGo1dDVyczQycTNwT3F2UEpwZkZaYzdEV2tCRENqeWhXT1o5OENE?=
 =?utf-8?B?TE1yMUJhaU9pKzEwVjdUTWZqRUs3L25wNEN6MVFoSCtkb3VFMmVpcStBRjBP?=
 =?utf-8?B?K2lqNlorTk9RL3pIYkpIRHc0TGViQlNkR3M0OEgrZldhb2s4L1FnVmpWdVE0?=
 =?utf-8?B?VkJuVnhNa3FYcGZlTlNoV01TdVc2OGJIZG5CTkNvZVRISTJtYmdCQjQ4VnRy?=
 =?utf-8?B?V1FPRDFUcFAwZDN6cFFoVXZXd3Jsci9NM2ZmcGhoQkE4N3U1S3hOYklHYzVJ?=
 =?utf-8?B?clVrb1dMa2dZaVp2U2hzV2pUTkVKOVp4cy80NVFDTXEybnBVUFp3S0JXMEwr?=
 =?utf-8?B?aDVUUVR1YVJGMkVYZlZ0Q2laVU9WUXFROWxNVG0xQTNjNWV2dFhsOTdBSEhx?=
 =?utf-8?B?eEpPQ2o2ekFBWTVqeERVVTdkczZSMDREdFdRM3laOFMvOWxHMG9iUXVBYk1B?=
 =?utf-8?B?czFWcklwT01GbGNQcDg5QVMrakpJY21wQkVqQkN2VTg1eFZ2TjBxWDY4dlNQ?=
 =?utf-8?B?T1lDMkxJcEIyVVY4NmVaVlNJcDBJWEs0dWlhZnI4RXR5SFkwdGFjMG5qWTBa?=
 =?utf-8?B?VllvS3dsczZaaFUzT2lpZFhyY21DT0RIM1ZPLzFlaDEzQmRaQjdzaERIN1RG?=
 =?utf-8?B?bng3M1hGZE85KzJBdThpUGtmS1BGdE5sd0ovbUdvei8rMlNIQnRsY0cxTytZ?=
 =?utf-8?B?RGR6cHZuMVBnRE1nMy9EY1F4c1MrbnhHMEVQSlJ2MWpVdzRBSU5KWmJ1R2hv?=
 =?utf-8?B?OWluQVNsaUJIdnZDNlFkWjluanJZS3M3bGp3MmNGQks0cnpidDRsVVMzZVBC?=
 =?utf-8?B?RW1OQVZVMVBRTXVDSHZVUGJ3YVhZLzdncVBWRTlmSFp5U0FKQ0xKYmg4c3Yz?=
 =?utf-8?B?czUwdTZ0OUtNdGVxZlRVS3ZDS2dxeEdNVGQrTXYwZ1VhQVZTN1VnTDVtUDgw?=
 =?utf-8?B?TUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c2ced3-d1fc-471e-f020-08dadf83d74c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:37:37.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OlaVyUZqyfu4w/g3zBMF/4TB7hGek6Rx9Ueif+Q9zl5dvcKeilOWdKttnWLUrMNKD8UcakpXhYwK0e+LWnJnsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6757
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stable maintainers,

On 12/5/22 06:21, irqchip-bot for Sean Anderson wrote:
> The following commit has been merged into the irq/irqchip-next branch of irqchip:
> 
> Commit-ID:     3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
> Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd
> Author:        Sean Anderson <sean.anderson@seco.com>
> AuthorDate:    Thu, 01 Dec 2022 16:28:07 -05:00
> Committer:     Marc Zyngier <maz@kernel.org>
> CommitterDate: Mon, 05 Dec 2022 10:39:52
> 
> irqchip/ls-extirq: Fix endianness detection
> 
> parent is the interrupt parent, not the parent of node. Use
> node->parent. This fixes endianness detection on big-endian platforms.
> 
> Fixes: 1b00adce8afd ("irqchip/ls-extirq: Fix invalid wait context by avoiding to use regmap")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20221201212807.616191-1-sean.anderson@seco.com
> ---
>  drivers/irqchip/irq-ls-extirq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-ls-extirq.c b/drivers/irqchip/irq-ls-extirq.c
> index d8d48b1..139f26b 100644
> --- a/drivers/irqchip/irq-ls-extirq.c
> +++ b/drivers/irqchip/irq-ls-extirq.c
> @@ -203,7 +203,7 @@ ls_extirq_of_init(struct device_node *node, struct device_node *parent)
>         if (ret)
>                 goto err_parse_map;
> 
> -       priv->big_endian = of_device_is_big_endian(parent);
> +       priv->big_endian = of_device_is_big_endian(node->parent);
>         priv->is_ls1021a_or_ls1043a = of_device_is_compatible(node, "fsl,ls1021a-extirq") ||
>                                       of_device_is_compatible(node, "fsl,ls1043a-extirq");
>         raw_spin_lock_init(&priv->lock);

This patch has made it into linux/master, but it should also get
backported to 6.1. Just want to make sure this doesn't fall through the
cracks, since this was a really annoying bug to deal with (causes an IRQ
storm).

--Sean
