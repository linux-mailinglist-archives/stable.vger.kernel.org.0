Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2865B438
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 16:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbjABP33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 10:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbjABP32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 10:29:28 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980F910DC;
        Mon,  2 Jan 2023 07:29:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iprGI7XcIkd+1nlWErkdShrJ/Ee3fxESeaJUtlWE3LqboZhGvdUQlH+jEUk3BLugR4wPLkxJHS2tCmhtuEXs4QYLe9bEs/ZkvKkNOzxN3LEbgHQqgQgi1fd1z01EOxrvKtAUae6Ryz9wO4ScIa9t79AlAM4gj1dCc0P1nQZ2D3VKxiBbj3Yr2wYYhFRSlTmc41ptiCnRj1w6HyK2V/AuUvVJVsRtTGU9Mw5P3SRz3nexRh1wpazlRYViI4hzoUBKdGkhE1w6auzucFMscbhmPziXpdXumA7DHSAIpKJiJAOMPU8PId9FT6UH8k69H8gBYoDjju9Ck7e8zDjCzS6QVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0tPBYCm/yrksBjxeVdXfxI8+ebPHM0MyKydnnih1tU=;
 b=PJScIc07BivQWGQlQ5kh0nQGBXTBovmGgDO11ACpffmbB/WYJ/z9LGB6XMhqA73yOoYHLl7d5NtBEf/geVd0SHQBTIl8FjTTbx9gokXUelM2eLkp44uCdA+j6USqQrtden68GhSMQx8hJ2v7N6z5yZEmnif2QmVtc91IGqR+E6uF2Q5UfGKq4Eyv963BT+rlTEHnUs311989aRjSqyAEFfJ3Dni7eqksEGDoFxYOTH6Rj12O61YNnw0af+hxxav/swwzm6byKWfRHXXW2+N1xyZmBN13dVkZ2VEm21iTufXpM5WrBFDew6SSChPS1TyIv35SjVKDalpoJvKqWTNU/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=theobroma-systems.com; dmarc=pass action=none
 header.from=theobroma-systems.com; dkim=pass header.d=theobroma-systems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theobroma-systems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0tPBYCm/yrksBjxeVdXfxI8+ebPHM0MyKydnnih1tU=;
 b=OBQ5Dr9mpT9W/zEvTMnVz4D9oq/a6gGX4qHaa9P6rLwz6VzX2P1q8gVzIpQq3gECvWZ4TU7bDdqKAKZx9+mrGbdvpRu/QMQUlZn8T5DcKYDQdGfdTqqb3Fk4wYaciPqqz01/O1ebrHDy+/INY40XBIlFYBtvDN5R5OuownRgFp7WxRDDJHcm9ymw5NUITZS0sn8L/DPoM/t2jMhVDkD7vao1XoWHE5/wxEJzxsARL9uBPfXJUmN2ojGZr2AL0uCJmVVwHVhR5dtyQm/nfymGoj9IZyHUkZ6LI6l/kOEXLkLoSGGHvourLNrWbpo0pDbLFsO6GRTCAYymGDGJ+n3amA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=theobroma-systems.com;
Received: from DU2PR04MB8536.eurprd04.prod.outlook.com (2603:10a6:10:2d7::10)
 by AM7PR04MB6791.eurprd04.prod.outlook.com (2603:10a6:20b:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 15:29:23 +0000
Received: from DU2PR04MB8536.eurprd04.prod.outlook.com
 ([fe80::9ebd:cd48:9396:76f6]) by DU2PR04MB8536.eurprd04.prod.outlook.com
 ([fe80::9ebd:cd48:9396:76f6%6]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 15:29:23 +0000
Message-ID: <09bd4e26-3e1e-061f-e228-a06ac2e4ab90@theobroma-systems.com>
Date:   Mon, 2 Jan 2023 16:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] clk: rockchip: rk3399: allow clk_cifout to force
 clk_cifout_src to reparent
Content-Language: en-US
To:     Quentin Schulz <foss+kernel@0leil.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Xing Zheng <zhengxing@rock-chips.com>,
        Michael Turquette <mturquette@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        stable@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com>
From:   Quentin Schulz <quentin.schulz@theobroma-systems.com>
In-Reply-To: <20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0502CA0030.eurprd05.prod.outlook.com
 (2603:10a6:803:1::43) To DU2PR04MB8536.eurprd04.prod.outlook.com
 (2603:10a6:10:2d7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8536:EE_|AM7PR04MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f235ad-7e92-4ed0-6fd9-08daecd62033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DlYA/MA8+WvqK+gwma7BBHx+8lzlFmMF162gzhV/uZ0TXI2/7Lyo5T+blVEr23S467vMcsCJNOGI6+wY0BPbrwtMaKJMJAi1468hmIHRd5frgxiYZpjRNagH6iCVwZtHvp24tPhK+TP2oVclXoyW97M+lDKYwyeZpWPAkh8wTBvXZUbAcceLDQh4coFnfRp/U7AAUrrupAZmpYhlNi5FMoqfM1/99VsXzmH8wrsMI9XVWsIWgxx3l5UdJ76Q+zDyYCYfflzka0JWo6C9OkGYGDjA9O0iy88ZfCaYEpJDQ6kw5tsLYdreKhOMAfGZ7QoS2f2FEcQA3zSgjEY9oPW6IAGKcDwWLGvijOb9ifKFCT9bPjL7bhuN7CpWaFQV2LYwEtXTZ/P0IrYfDIhnQmvSYhHYC3s0kTloRGQ7pQ++gKQ0jP18LDB5vpeazJq+g/NvoE/lfhyv2pvC/rLJcql1ywh3TVs8N/oVFA04b9rVdyoLlpA7UK/3z4TVOHc6Y6UFl5bUYXqqInw0WghqxgK40zWT0fP4QUtMV7t3FtQz4get+OHa2Z0OyZdctPOgh9DBAteDrtVGig47SWh47NpSALnrwS6cAdbfbC3AfikLtMfxxTwmCBM6rXi8HOQkk3G+wiA9J4WNOC1Fsf44pV40Z1KGUw1sGXjwDbARLPGtn+rTcwCHqqItWydOlpHiJE6OoLr8cnUVn0ONPC17sEK0KNGrmk/EmYfmtw3v8YNFMaOdU8TDCZL5jT40QBXus8+/zEknulDoTHb/o8wFTjFAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8536.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39840400004)(451199015)(83380400001)(186003)(6512007)(53546011)(2616005)(6506007)(31696002)(86362001)(36756003)(38100700002)(41300700001)(8676002)(4326008)(2906002)(5660300002)(7416002)(8936002)(44832011)(6486002)(66556008)(31686004)(478600001)(66946007)(316002)(66476007)(110136005)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3RhRGUrbk1TU2JCOWtnVzVMOFJ3Y253Y1JnZE1FdDZ2ZWNCVjJOOWNSdGtE?=
 =?utf-8?B?VWtPTnNUb0tTRFJMdktzOTQ4WlhvUUlQUDgxVnZkZS9qTHlobm5Nanh0dnBG?=
 =?utf-8?B?UkJxWGJWUXhqTWE5cGR6OE1qZHk4NjlDZWV5UVo1Zm5ZU0Y3ZFJCbW83TGVP?=
 =?utf-8?B?dStFbklONVI1UVNEdklOcmdQRkRPTzlzRW9TTU0yMUVjTEpydVpVNHcwT01H?=
 =?utf-8?B?cTVLaTA2NGt4MTdXVEtWQU53aFM2MHNBTTB3enUzeWE0eHpGM2VlUVY2R0Zi?=
 =?utf-8?B?VTBPWXFzR2Z5VmRpNmU4bFVNaDVuOW1kQm9HZ240dWkxQzJPaUEwQ3REZ2xG?=
 =?utf-8?B?MXZSSTZaKzA2Y1JGMzFLQjRBbUNhK1ppNkdzd1N3UGRPN01heWNKRllYeU1s?=
 =?utf-8?B?ZXBmZkE4NUMrNFZEQlZoVWZndnNMV01xWGZ4VGtMT3NrWCt1WlNVZDR2QmVq?=
 =?utf-8?B?dzdiK1NQbmRzbDNWdDVxcG1saHZ6TEtSYi9xbjZHd0hTR1FhMUFNc3dTcTVC?=
 =?utf-8?B?a2h5MEhLL3ppMU1vZko4OFBxV0x6ZmNzbGJDeUJkc1FtMW9halFKb3VUeWhB?=
 =?utf-8?B?L3RWVVN0TlRNR2xLT1RpdVFrUmJremplS3BIVnlRNFFnQWIyQlcvMlp3UDFx?=
 =?utf-8?B?M0hjalFXOVlFRDNETmloak9kN1NKVTE5VE1xVWF6TXBzdStkZ0I1ckEzTlVj?=
 =?utf-8?B?Y3pGbmkvbzIxYVUraWN0TW1WUHRZb2ozTERMRXlmUGtEaHhZdjlCTDF5UTd4?=
 =?utf-8?B?N2J4M2ZPQ3pCSzZzTGdYOEdWOGhSUk1OcXg1SWxLWEs1MU9xUGZhaTlab0pY?=
 =?utf-8?B?eW1tdm4vVVJsL1lOWnlxY2R0MndEaTU5L1hpbmRkeFUzVW5yaEcvZEVIVm9y?=
 =?utf-8?B?c1VnTzlQTHRCSmZXQUZic254OTk2cGZQSkRia3J3NWlQMjc0cGt0MGE3NnhD?=
 =?utf-8?B?QkJ6SzV4bGFhSytCZDVxRDN4MENiQnIyWUQ0SXBsbHVrRXU1alZHY2NTZGhN?=
 =?utf-8?B?dGtuMWNLT1NjVjNEOTAxSHpORmFEOEhGcTA0UzArN01WOFpvVkZJTGl5ZHVL?=
 =?utf-8?B?MEg3Sk91QW1VWmQ3Y3JYUW5DcUU4K3BnQi9jUkphN2xRWHhMcmtCc1I1V2NY?=
 =?utf-8?B?SjkxbFdSZnZuMUdNaWFWRjZBQ3RQaTVIRjRvdVhRMWo1a3IrMlNsNTB1VUZv?=
 =?utf-8?B?NE8wNXpsQmFqK3hrVmZIaXk5N1I1RzVpTis2ZDZ1dk1pT3VkcW5DTTVDbzU4?=
 =?utf-8?B?SWhERkplL0J6VlRYdDlBZE1seWRYdVNnQytuUmRQN1VVUlY4N2pTOGE0T2Fr?=
 =?utf-8?B?NkVOb0FJSVE1UnhHOHphMWZmWVVFNW5kY1k4Q1d3TnlzSkxBUk9BclFTeFBt?=
 =?utf-8?B?SkozM2ErbnhRdno2U3FOdkpQbUh6TFJLUE5CNFNmb29GTUhPM3pjYml5ci9j?=
 =?utf-8?B?ZThFYk5mL1VLaEVBOHhyaWhCZkN2NXFSWkRtQ3o0Z21BbU00NVNtQkxOelBD?=
 =?utf-8?B?NG5KNGpiZUNVbi9VOXlrZGVHUDRINjZpdndsVEFIdzRUV1U4TGh5ZWI3cktM?=
 =?utf-8?B?S1picHdNU3Znd0VIMlo3cGkxSVpaMkpVL1d1dFJXMEU5V21pellDQ2ZFMW5m?=
 =?utf-8?B?THBCZE9LZitoTG9oRmVJVUhrelVueUlCRjZVcjgvY0RhcnRTOEZpN3FpWkcr?=
 =?utf-8?B?bnFpQUFjbkd1eGFzQTQwT1NiYmNRVDdCQXNXc0xjZ1hWM2xiOHN1L2J5NkNO?=
 =?utf-8?B?QktXY0F6UVh6YUVsYitKcmhwOGZEbDdjeUp0TzZMWmMyR01BOHJyazRLc1d0?=
 =?utf-8?B?TlRjRnJ0QlVkVGErUVI4S3IzQmQvYVNKQTBoU0RZcEJRTVU0ZTREUTNzc2Js?=
 =?utf-8?B?UGJlaDlzS0lhSDhQa3M3TmplSU0zVmEwRzVWWUJGNHFKZGhuQ2FSeW4zZ2FL?=
 =?utf-8?B?V3JFSWJvSHk4dnZ1cVpRZW8wVlRuNFRXeEQ2d1dkMWVBR1h4MzB5OVBvVTVm?=
 =?utf-8?B?bWxzNXpqMlJpTzhPeXVWUUZvREk2YkVDUzBzRXZEUkhoOVR1Ny8vSFdRR3VB?=
 =?utf-8?B?N2thUXp2eFFRVkdXdG1tY0R5Y3RaOFZ6UzZ1ZExrZnNxRStMVW5hbXlnNnB1?=
 =?utf-8?B?MVhBL3g1QlduUEdjR054ckpFblVpcVFybVBBelFiaGFTQkZaUkc4ZXlsU0RD?=
 =?utf-8?B?T1B2ckRxN0NCZUFFTUp0M3hsSHFEUnlMV0srTFA3UDFSOVd4cjhSYkowdk5Z?=
 =?utf-8?B?YjhoZkxyNHo1eEtsK0dKNnhnRWR3PT0=?=
X-OriginatorOrg: theobroma-systems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f235ad-7e92-4ed0-6fd9-08daecd62033
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8536.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 15:29:23.5443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e0e1b52-21b5-4e7b-83bb-514ec460677e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPCLSEADM4cBBY/6OhsIaRAKzHj2tqQgymBi/mzqybYCRwXaeCG/1xqKpsecQTdvTg53kZTIt1Ggm3iU75bKpfNY6fQwbw0NDRwx+d8sP7Dm9Eb7VDW54XsxSoj8N8dI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6791
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Gently pinging as it hasn't received any review and I couldn't find the 
patch in a branch in the linux-clk tree.

Cheers,
Quentin

On 11/17/22 13:04, Quentin Schulz wrote:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> 
> clk_cifout is derived from clk_cifout_src through an integer divider
> limited to 32. clk_cifout_src is a child of either cpll, gpll or npll
> without any possibility of a divider of any sort. The default clock
> parent is cpll.
> 
> Let's allow clk_cifout to ask its parent clk_cifout_src to reparent in
> order to find the real closest possible rate for clk_cifout and not one
> derived from cpll only.
> 
> Cc: stable@vger.kernel.org # 4.10+
> Fixes: fd8bc829336a ("clk: rockchip: fix the rk3399 cifout clock")
> Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> ---
> clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent
> 
> This used to be correct before v4.10 but commit fd8bc829336a ("clk: rockchip:
> fix the rk3399 cifout clock") incorrectly removed this ability while reworking
> it.
> 
> Note: this has been tested on top of v6.0.2 only but no changes were made to
> this driver since. As for older stable releases, the git context seems identical
> and there does not seem to have been any logical change introduced since v4.10
> so it should be pretty safe to apply.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Heiko Stuebner <heiko@sntech.de>
> To: Xing Zheng <zhengxing@rock-chips.com>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/clk/rockchip/clk-rk3399.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3399.c b/drivers/clk/rockchip/clk-rk3399.c
> index 306910a3a0d38..9ebd6c451b3db 100644
> --- a/drivers/clk/rockchip/clk-rk3399.c
> +++ b/drivers/clk/rockchip/clk-rk3399.c
> @@ -1263,7 +1263,7 @@ static struct rockchip_clk_branch rk3399_clk_branches[] __initdata = {
>   			RK3399_CLKSEL_CON(56), 6, 2, MFLAGS,
>   			RK3399_CLKGATE_CON(10), 7, GFLAGS),
>   
> -	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, 0,
> +	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, CLK_SET_RATE_PARENT,
>   			 RK3399_CLKSEL_CON(56), 5, 1, MFLAGS, 0, 5, DFLAGS),
>   
>   	/* gic */
> 
> ---
> base-commit: cc675d22e422442f6d230654a55a5fc5682ea018
> change-id: 20221117-rk3399-cifout-set-rate-parent-1fbf0173ef2d
> 
> Best regards,
