Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10B651CF8
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiLTJQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 04:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLTJQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 04:16:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2117.outbound.protection.outlook.com [40.107.105.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0269FF1
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:16:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kgap1nE4qUYmmNpxB+AtyONdh+M+V+QVg9VDGz8x9TdN5xj35IRM3TMcHwpEtWC9/Z00ElV2DEbZKdMX9W6Z+FziYCFsfDCoSYmLEvVviwuIkXyDkDQqSCGLGYIdEqCbRb/SonlhfeNlDizHGlovzGG0b0RqCLAhmjqe1zNoIUxZsH53Rvg66u8J9b1Co4B7ldOTdAd9VhBDlGmHdKpqFb8dHRf0Usuq5Z6i/qAE4Dm2XaGQOLxdexXe6zlU6SMG7lfG9E5ROS/9u1lfQjz1nQV77bShay+AWKuvXTARQ0oWhnnhqfk/25HvkJp5q+fT0eQMfHPoBjjcJdP+nzV6lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n0lOhO0BNfmKSQVuTPheAFUmrAG42B9LZkNq6Ct20M=;
 b=O38mjJ/lQlK4gj8z0UTHJMLc+Msj4qFk/ht6dWzsdVOwh0OfM05bh0ldGsAHmTRXp3vEe6+DGKE4RDajbRR1YTxW7wEk+tZSWq1HHFGiVF/JFhTPSCJlLY2yMiomI7hr6PgLIQP3nwAny1GamQTuvj5O09g8wVJ9O0dmcGKYJxnTJYy5cfKOWKd89XDDTkBkbI0f/2L7tJ56u/AszwQ+xRZ2pUOs77Gmbc2gi5buCPWpdI6SWhPABmoASyHLI3cgziiMX7URTrtOLwlNGP6AqHujndTliWGsHU477AproWz2ZwxFow1Qmv7CYaC2uw3aL6Tvs7haxNkriUHDtmM66Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/n0lOhO0BNfmKSQVuTPheAFUmrAG42B9LZkNq6Ct20M=;
 b=AvqIFiUxfipEcbkvPF4NQezjH3Vkfa/IhiHdiJWBZ3n6vVK91UxjV7JdWwnyY1YoQC8W3ZakQgf2HLhte7KJiXjH0EsRDDIN8Zdg6sJ/ds5jl3GecqHnyELUnBQwZ1xbfVb0t4D7cmmbhIsQKg6I0eO9OG3dAp05fWfWtHdPQ+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34a::22)
 by DB9PR10MB7122.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:45b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 09:16:40 +0000
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::722b:5d41:9862:10e5]) by DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::722b:5d41:9862:10e5%8]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 09:16:40 +0000
Message-ID: <38a93e7d-f716-e908-7fba-7570299a6fd3@prevas.dk>
Date:   Tue, 20 Dec 2022 10:16:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US, da
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: commit b079d3775237 in 5.15.y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0053.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::32) To DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:34a::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB5266:EE_|DB9PR10MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae43247-0118-43c0-b127-08dae26ae73d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTLESP8lMENeRg8dXB5dRz0XiwlQKY1BGHH4X2VACdKKzcUBvEIEHbsnlP+18ErikK6SZELHteC1WXftEmy2e5tXF2uGoWoGPPSujeMEbFCCFrjWNloZ8EfoetV5humw57+HUPKQRITKZkDB3jx+AUzS5rkkJr76neDhHkanpO38fySgI8BYdpQ3eiq7FCA9C1rQuZlgaCXStQgKxUZNjLXD65DvVOaXfb9EdWXvjwVfTVzGKhLicx2oRqpzfrMLZMhJrWbz03miTc6m15uGXYhgNzxHbkuMG4L/Sb+ayPBujFzAHBDjiqwyzl3c1tAUge1gZK6n4xL42Nn3LWF0XaO12woFUEPsYVmfgMkz+LtzTIcQMXzw/NSY0ampZLOTEYWWZ7Mm1z6qZ41onHTFrd3kqJnZ7uGONLVSgo4+xav/6Uz9nPmZRLOSYOSgGRp0yVZoHDiRs8Zp8/6zZl5dCYoXVtGkRb5rfzqn2fy4REgKzG7muoswqsidwWZppzkSfXAwkVnNXDkDMg/A7ksqN+gyEtnB/TmLZ5fQPNxbZPRWKb8er/BnCIrkxB27bag1JT8pnW3b/7lqLtGlGttOES4DPZmwHeUA98wwJAY2AlhuPeY2a959G2XvPgA97O9MLYzJh3hYX9pNGCys+Qn+WA0eWJ14U9rVkqwtRVGSo2IY++7y0yqJXRIrrJC3pczbXD+grbi9jwKrW2FoJdDQodNPthhedPorCT+cXGyq5HviSh1ZaRvV0wpdgaPX5THC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(376002)(396003)(346002)(136003)(451199015)(31686004)(2906002)(38100700002)(4744005)(38350700002)(44832011)(5660300002)(41300700001)(83380400001)(66476007)(8676002)(66556008)(66946007)(4326008)(8976002)(8936002)(36756003)(316002)(31696002)(6512007)(26005)(2616005)(6916009)(52116002)(186003)(54906003)(86362001)(478600001)(6506007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjZVVjF5Skt1cXNyQXBKWHB1WEF2dHdGdUl4bGpqc1lEcnZuK2FhbmI4V2hN?=
 =?utf-8?B?aXNUK1B1WldmSERteVdLcnlob2czRkZZazZCRmZLdytIZjBhODUyMTkwdTBU?=
 =?utf-8?B?WnJPNHNndmIxMmd6dEtuUnpNNlJJZ0hHSlFDQ1k5cjJhUEpBQnMxcjZVaWpp?=
 =?utf-8?B?dGFTeEhHdklQSEdUTFJSSEtVdTVMYnBNSGtrNlJtUlU3MkxGbmlUSEcwdHlt?=
 =?utf-8?B?TWRHYTRFY1UzdWRrbHZnZ3d0T2g0S3h6aklaUkg2NHZkM1A3bUoxdFdOWWEz?=
 =?utf-8?B?VlRPaFhReGpSTHJXNXZnbkZlNkF3eVdmN2laaUNYTzZnRThKMEFudEk3MkNv?=
 =?utf-8?B?S2I1c0E4d1QzN3NzbjYrTnBFeGJ4TE51YUdGZ0ltWlNRaUV2VEtvbExNNE15?=
 =?utf-8?B?Z0Y5TE9DaHNPS25abk1zRjNIM0lLRjcvdmQyTlN6MzljOWdSVHYweEwxejFV?=
 =?utf-8?B?bzFPWDRNbCtzZ3VtL1VwMkNXampHZENQSmdLdUtIZUtKQ2lvQ2dWV0FXeUJy?=
 =?utf-8?B?MnJ2TlR5VC8rZkEvdVczTkRkN1orY0VqM3c3Vk0rV1hzM1BvNWhGWkpBUTF6?=
 =?utf-8?B?V0V6a3luelNDbjl0QXR4c3dNaEtsNGlHSmMxcHFNUVpvSllGLyt0a056Q1Js?=
 =?utf-8?B?NDVXRTZDYjJWbzA3WDZGRythNTRCeXhKSVVkOHN6RWFrNUZzMHl3RUdhcjdm?=
 =?utf-8?B?akZEakdiK0NuMTN6ck1Jd0tZdWIvNjB4blRRaFc5UHg4SG5CRHJhVEVlRkc0?=
 =?utf-8?B?TnBKQjFFekRsVys2YW9XeS9zQm5WQnMxQXBOeUE0bnlHZlZlWlE5a1YvS1h2?=
 =?utf-8?B?N0kzb3Z4K0JtSnUzYy82aEQ4aVpnNWhKaS81NEw4cE5tVzBLNzE0ZjdRQjN5?=
 =?utf-8?B?UkQ5VGFJQ0llVWVkeS9vQkNBKzVhN3hmNGRNMDY5WjZobmcwbkpvVE16VGN5?=
 =?utf-8?B?TkowcUlCVVJjVGRKa2xpN01KYllrMUIyS1llTjcrUVMrZ2QyM2EyOW95NlVq?=
 =?utf-8?B?My93MGdIUVVxb3Boa1dlNk9ONGNRZzRZSGxORS8zbCs0QWZlRWpjRkZJMU12?=
 =?utf-8?B?UEsveG5sdlN3M0RSMCtoOVlMcnJrbVdXRWlOZEQrNWoyeXhRZ3BOdlVUZEJr?=
 =?utf-8?B?aHVmRG9TRVFFL3hxME1FU0ZHZnBJQjZSN2ZRS3dZdmREQ1dMWWlkWjFEZ1JO?=
 =?utf-8?B?ek9SUnMwL1pjNmhtTG01UE4wTGR1UGlpazNaQndjSlVkVDFEbWdrLzJUbmVs?=
 =?utf-8?B?RkdxSjF5dnkyTjVFTytsZHAwY2ZQMmladXFGamh6THJnK29Vam5jOStEaDJ2?=
 =?utf-8?B?R2Z0VTJXaXM5b3JoYjVLa2UyeEFDNmlodlRvbWtSQWp3bHlsVkhEaTJJSHJZ?=
 =?utf-8?B?TDgxT1ZJZXhEQ2ZsZks2RjVjZ01ndFI2dnNDdW9DQTFqZ2wvNW5ucVRySkhu?=
 =?utf-8?B?cWNRT1BnMkFnTDZEa01IcEFjQlFlVmlaNVhSdTVDZFpyZFBiVDVtVUxSQ3Rx?=
 =?utf-8?B?cVdLdTRES2xJWjhjc2R5eUM3a3BuWlBjbklDS3ZrV3JrTXJjT3JRSkdGNFVO?=
 =?utf-8?B?N080eWxHc0RmbFpHTENWdm1CTkdrWm1HWXVFOTk0Q0lsekI0STdtMU16L0hH?=
 =?utf-8?B?ZXB3NVZ2OFNPUmNVM2xYMU96ZHFXb0VxaW5ORTVIUWM5b0E4ajNBanlVUTNM?=
 =?utf-8?B?c3QzKzIvbXZvR00yOExFcXEzT2V5ZTNsWEF6OTVuZFZSQmpqQVlYYjBXcVhK?=
 =?utf-8?B?RktMZS9BNi82cmNiSXRUV2xtTHZLck44clFocHFobHJQYzFDQ0Q1aysvVHFO?=
 =?utf-8?B?QVRFS0ZyRTZDY29SR0YyKzJMS0VPUFpVSEVIRzVmTldGcDZrOUVob2JtRkV6?=
 =?utf-8?B?QmhQQ2g4WlFoemtJcFkxR0psNmNHUDhKd1dQU3JBblU0KzArQVZxeU9mNjJT?=
 =?utf-8?B?UEhIWnorY0ZsdVBBYkswSDFwNkZDUVU1ckkrOTBYaWFEM2V5NGM1cUVsU3FO?=
 =?utf-8?B?L2JhcmJwL3FQZThPODh1enpyQ29VNHBXTDdXRnlTS2Z5aEpuKzFyL0ZpSE5t?=
 =?utf-8?B?WVdTL3hFWDZUdXhrdDEwRGtSTDJHUmNUamJucENpL3l3ZktHVWFvL2dCZ0hH?=
 =?utf-8?B?b1NjcFI3MW8xcGM0NWdvcENzZjVINy9UYm80c3NnQmpJelVTU09GTHFDMk1D?=
 =?utf-8?B?MUE9PQ==?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae43247-0118-43c0-b127-08dae26ae73d
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 09:16:40.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDF8x8ZyZv8aXWb1+RERuIz5DmfvRBl4b1ALKIx5fuPZYb+tdVM2xZH8ake7UlTfJU/LtCSaunRsnouPsHOcr9tig3NkDvgyzsJ7SBbg94A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB7122
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I think something went slightly wrong when 7c7f9bc98 (serial: Deassert
Transmit Enable on probe in driver-specific way) got backported to
5.15.y. In fsl_lpuart.c, the original had this

 failed_irq_request:
-failed_get_rs485:
        uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_get_rs485:
 failed_reset:
        lpuart_disable_clks(sport);
        return ret;

in the error path, but that is missing in the backport. So if we now hit
the 'goto failed_get_rs485;', we'll do uart_remove_one_port() while
uart_add_one_port() hasn't been done.

Rasmus
