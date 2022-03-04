Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D954CCC7C
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 05:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiCDENL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 23:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiCDENL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 23:13:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0CE17FD21
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 20:12:19 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso6269133pjb.0
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 20:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=jVhPAeQvfccS3InyfAH/VFAxekIO5TliK8fvjkyoplY=;
        b=ftr3cH8qXWFbFsT4bq3I6LWs4JamRi0VDgwKeaxLMfkV+a0sQyUl/mX3oXRSVzVWk7
         6WVzg//gyYFs63l8zoyk9PFYLvwApNTsqhCzvsDD6v6mo4puzhTK0XcRqHIn55QkPT0a
         QMmyBSu9pvD+ln8Eh42shjIcq6/sPdaJQY29svxLYBgQH3cJq95AFBzY28X5/otxJqB+
         vzunfjI6ST1ZDjgoP9IkWNnoPK9EH6XohXcL5b/D6+QDj2iP3UMigL/rEqcWY9KY2smY
         SeuFJWUwL3i+wOUQiIwwhlgxmJEe08urBL45x1QSJlQ0WT+lxevhsd1hC2epltcQrdLj
         vY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=jVhPAeQvfccS3InyfAH/VFAxekIO5TliK8fvjkyoplY=;
        b=dwhyicfJZXwECiXuqdIlN1xK6k/4+9/5OWbkInz/6mxQoCeENQ7VLUx6Q2lIgwJ+d5
         i3CEkkRQtPfgSQRXEtiENhSGaW0KfeJxdo4ZADqURbfTYcX8s8u9aHMpl4/VFK6vOjYX
         2g/tNPbJwugHUgb8IEIkLyE6Y/PBEtKV49Br+an//i1vzc6VNOzakrKgPecwfkA/gasv
         pM2imsITogngYAf1sA9ezjXmwFwRIfv3nC+tW2oF+ptEJ6USVXsTWep+uIB9BbqMpyS+
         /FXBBa6IkM4nKTQ9/ZuXif8ig5bAPrIc9ReifH/YCDSKkLu23H8IQ+8aXU7OHeNcNa5M
         anAw==
X-Gm-Message-State: AOAM5333V5MD8mekK346087pYW/xKKOlviTTC16FPx1BpISGaYVfKgQ/
        O4CuhYf8SNdLVdgORX87Lzu8YQ==
X-Google-Smtp-Source: ABdhPJyh/bqxk2p19R3L8t5CykBngFNqYXe+ZhPQwN8ZZjvpIfw8l2JFUflj+e7kn8xvdVpOrlGuDA==
X-Received: by 2002:a17:90b:1a8a:b0:1bf:d9c:f206 with SMTP id ng10-20020a17090b1a8a00b001bf0d9cf206mr6528144pjb.95.1646367138913;
        Thu, 03 Mar 2022 20:12:18 -0800 (PST)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id pj12-20020a17090b4f4c00b001bc97c5b255sm3313105pjb.44.2022.03.03.20.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 20:12:18 -0800 (PST)
Date:   Thu, 03 Mar 2022 20:12:18 -0800 (PST)
X-Google-Original-Date: Thu, 03 Mar 2022 19:59:03 PST (-0800)
Subject:     Re: [PATCH] riscv: dts: k210: fix broken IRQs on hart1
In-Reply-To: <ac991e09-40b1-8fd9-d178-84b48af43a55@wdc.com>
CC:     Niklas.Cassel@wdc.com, robh+dt@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Damien.LeMoal@wdc.com
Message-ID: <mhng-cd1e7d68-785e-4203-a845-de918ca4eebf@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 03 Mar 2022 09:59:31 PST (-0800), Damien.LeMoal@wdc.com wrote:
> On 2022/03/01 2:44, Niklas Cassel wrote:
>> From: Niklas Cassel <niklas.cassel@wdc.com>
>> 
>> Commit 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
>> incorrectly removed two entries from the PLIC interrupt-controller node's
>> interrupts-extended property.
>> 
>> The PLIC driver cannot know the mapping between hart contexts and hart ids,
>> so this information has to be provided by device tree, as specified by the
>> PLIC device tree binding.
>> 
>> The PLIC driver uses the interrupts-extended property, and initializes the
>> hart context registers in the exact same order as provided by the
>> interrupts-extended property.
>> 
>> In other words, if we don't specify the S-mode interrupts, the PLIC driver
>> will simply initialize the hart0 S-mode hart context with the hart1 M-mode
>> configuration. It is therefore essential to specify the S-mode IRQs even
>> though the system itself will only ever be running in M-mode.
>> 
>> Re-add the S-mode interrupts, so that we get working IRQs on hart1 again.
>> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> ---
>>  arch/riscv/boot/dts/canaan/k210.dtsi | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/canaan/k210.dtsi
>> index 56f57118c633..44d338514761 100644
>> --- a/arch/riscv/boot/dts/canaan/k210.dtsi
>> +++ b/arch/riscv/boot/dts/canaan/k210.dtsi
>> @@ -113,7 +113,8 @@ plic0: interrupt-controller@c000000 {
>>  			compatible = "canaan,k210-plic", "sifive,plic-1.0.0";
>>  			reg = <0xC000000 0x4000000>;
>>  			interrupt-controller;
>> -			interrupts-extended = <&cpu0_intc 11>, <&cpu1_intc 11>;
>> +			interrupts-extended = <&cpu0_intc 11>, <&cpu0_intc 9>,
>> +					      <&cpu1_intc 11>, <&cpu1_intc 9>;
>>  			riscv,ndev = <65>;
>>  		};
>>  
> 
> Looks good to me.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

Thanks, this is on fixes.

Just FIY: A bunch of WDC email is getting munged on my end.  I wouldn't 
be surprised if it was my fault (my email client is a broken mess), but 
it does seem to be specific to this use case.
