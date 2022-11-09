Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2726229A0
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 12:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKILHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 06:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKILHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 06:07:35 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E3A1A047;
        Wed,  9 Nov 2022 03:07:34 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 85DE13200A3C;
        Wed,  9 Nov 2022 06:07:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 09 Nov 2022 06:07:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1667992053; x=
        1668078453; bh=PtXlGxu5pHm04GVMp9fkQqlVpuB3Y1JtbfwxVosbUzs=; b=j
        1d3Ye6iodxIBcobDJ4jPLQmX77Ts7LeEuNx2Ld9Sx+Qcr2wnEWicj231rjZ/n89p
        XG7so0qsFFJcnfrDuAhE/+wGO2hUV3QAIHaVU4wbaJgyGneszDcgVPfuzufW3ihq
        2zrxNK5IeaWNFpPhKs0ZP8Zl4T6wzUOJobJ4utUCArtwBuEEjwBTrD3svDQDqYFP
        OHkPF6QCGfU9sh4Rs2cnQQHEB1Dt9ZJXpvXztP4nk74zOiTy1QFt8+Ndo8f1BHvy
        0CMGN8zlmQx5kouOFpinp2+H9zPQRTOsEwLk7SOumiljDNhvQqPdL52Rmu8LzASb
        PlaMC9eN0P55xVV5f6shw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1667992053; x=
        1668078453; bh=PtXlGxu5pHm04GVMp9fkQqlVpuB3Y1JtbfwxVosbUzs=; b=I
        Yc3t4YdziTHLywjI+YFY6zpSxIVbNH9hzmeisqHIJgHabF55nkH9kheIkbi6j1QI
        N9alZGLD0AFTWJ/Iwc/tcJZsxwqXfSy20YLzmzhGFDdVuNT1EH5wN36OAHsKRlGT
        H829vg431NZO2U4l+MG7jXySBAOtmvbIUj900U0rV/4mGGoKoM2MWDZV4DE5M/rz
        UAsMgwJGXW3ImwWXs9bopRqrlsUlUJSaTAlO26Bzl6q9NFtGicMRChP4O/R1Z6Wr
        /IUhvCgKoRM+ZVAPwfK0MUeruKiO6oJJmk48ednJHuou2hrI9VRbLeKjp5T3QoPi
        buHDk9v32rRG+fE0OEuEg==
X-ME-Sender: <xms:84lrY8dfLs5n4KJHIHsoocSthNsOOjxmYeRvwnyeNwX2wI55MbZ2Yg>
    <xme:84lrY-OtNZmA5t6tDLeNxuUOaGMbJ2n35SFVnqnktxmC__vdvwnt29-qO_s4rxpEv
    THORMzK5Y5m3XNom1I>
X-ME-Received: <xmr:84lrY9hTuZQlrnXLlD3Ec4uXJSZd4e3Lrobn25mqWcBrecs44_OIl1anOxK100US>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfevfhfhjggtgfesthekredttdefjeenucfhrhhomheplfhirgig
    uhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeduhfekvedvtdeukeeffefgteelgfeugeeuledttdeijeegieeh
    vefghefgvdefgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:84lrYx8vQLR9iBrsZ1bvuhWotdsmB--UhFGHhFvdmNTgYnkPU6ESlg>
    <xmx:84lrY4uugfgyJb3i5TNXlbM1KBth0AjzkNlEpodFdM63kEjQFFp74Q>
    <xmx:84lrY4HPEkVVu2pSm8Gj9stvYwYaQAjip66M93gIYH2O3V7iIPDa6Q>
    <xmx:9YlrYyWm8bYblbQn03_co7Fr3d6MUc6ykBQobXT1Ottkq1S9x-Yvug>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 06:07:30 -0500 (EST)
Message-ID: <7cf55c95-540e-b182-b4b3-e641535752e1@flygoat.com>
Date:   Wed, 9 Nov 2022 11:07:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] MIPS: jump_label: Fix compat branch range check
Content-Language: en-US
To:     tsbogend@alpha.franken.de
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        ardb@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
References: <20221103151053.213583-1-jiaxun.yang@flygoat.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20221103151053.213583-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/11/3 15:10, Jiaxun Yang 写道:
> Cast upper bound of branch range to long to do signed compare,
> avoid negative offset trigger this warning.
>
> Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Ping :-)

Thanks
- Jiaxun

> ---
> v2: Fix typo, collect review tags.
> ---
>   arch/mips/kernel/jump_label.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
> index 71a882c8c6eb..f7978d50a2ba 100644
> --- a/arch/mips/kernel/jump_label.c
> +++ b/arch/mips/kernel/jump_label.c
> @@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
>   			 * The branch offset must fit in the instruction's 26
>   			 * bit field.
>   			 */
> -			WARN_ON((offset >= BIT(25)) ||
> +			WARN_ON((offset >= (long)BIT(25)) ||
>   				(offset < -(long)BIT(25)));
>   
>   			insn.j_format.opcode = bc6_op;

