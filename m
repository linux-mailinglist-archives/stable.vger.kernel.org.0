Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B07279C3F
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIZTsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 15:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIZTsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 15:48:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C0CC0613CE
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 12:42:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so6001581pfn.8
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 12:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=sl+PbqQM6zKU6OzSuHlucAlpdcjvMRLZvonIss7WfIg=;
        b=AqILSeTxE1hr7FW5OY4qwKVHgIpVSLzOMF7VcIcmZJhFYo93tcWFotkN32LYluLsPa
         NmgWwMfnDLDZBGJqf9m0o6r9nmP3CV8QKDbtC86YOScFWRwmJ1kR6CLSGAsZJsGIYToi
         lsaaXBBwTLe1OlfR2RGVsxeMXiOwl/aIuVhncz9XVGKKBoAQjI3YS8rgY1LiQbW5/CcH
         i3YLDf3vRhmO8Xjhe3wYfj1xnzoU0Sb/Ggax4hPYjOCcYv+Q8wQo1TrF0iZWjLLrhY8O
         ZzJ/FRZ3J4BBSaQwYm9bQiS8oT5pNYkTsUQ+PGNHGEsUj8ETgRcQ4IShHdI0eTd4t24q
         LaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=sl+PbqQM6zKU6OzSuHlucAlpdcjvMRLZvonIss7WfIg=;
        b=D7qoGr39pjTgo6ydVxApQhg5g0pOeYwv02UAnMo122pTiwQRmg/vctxmpe2ZAPHImR
         HdbJZEsYiMPJ8f15h/HT4AYQS5w0GI7QhV2f7bauBWZLs0EoKnb4ODsaKJwiQgVdu4n3
         Yn2hRN3rVaDJBMqiZEbZK6MM3ZGH1UChz8rIdjPceOGdpPkrR0lC9JDFhx/ktByWqgKJ
         tfzMqrjGKX9OM823qTNeE7clTKH0BYDPT48c4XIziLbFyP0E3Ehp/Y/eOV4tm1Tvv3oH
         7KLOPK7ObYtN3b1+1GtNVTt4zZz5tEK7sSEiDynpRQ7sX0hAiKD65U0SjI7VMj5vJ2VM
         +WBw==
X-Gm-Message-State: AOAM530ST35s6imKIke2ncBPOVXRJhN7miFqoLf2MRm85AfsCagGVU6r
        vx0pFsTcqJup7ZuoyRlbDGiEeQ==
X-Google-Smtp-Source: ABdhPJwDm088vYVEZecm77Rvz3ZyvKHOxZFUXoAqMcVnAOy+PMCy2Sgdk2td8bswV7Tj/v9tZrkqMw==
X-Received: by 2002:a63:a546:: with SMTP id r6mr738000pgu.160.1601149363758;
        Sat, 26 Sep 2020 12:42:43 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id gj6sm2458790pjb.10.2020.09.26.12.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 12:42:42 -0700 (PDT)
Date:   Sat, 26 Sep 2020 12:42:42 -0700 (PDT)
X-Google-Original-Date: Sat, 26 Sep 2020 12:42:40 PDT (-0700)
Subject:     Re: [PATCH AUTOSEL 5.8 20/20] riscv: Fix Kendryte K210 device tree
In-Reply-To: <CY4PR04MB3751BE40C3EC0BD2F392E9EEE7380@CY4PR04MB3751.namprd04.prod.outlook.com>
CC:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <mhng-ed52d354-09cf-4708-8b07-5e6559a7b5e8@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>On Tue, 22 Sep 2020 17:27:42 PDT (-0700), Damien Le Moal wrote:
>> On 2020/09/21 23:41, Sasha Levin wrote:
>> From: Damien Le Moal <damien.lemoal@wdc.com>
>> 
>> [ Upstream commit f025d9d9934b84cd03b7796072d10686029c408e ]
>> 
>> The Kendryte K210 SoC CLINT is compatible with Sifive clint v0
>> (sifive,clint0). Fix the Kendryte K210 device tree clint entry to be
>> inline with the sifive timer definition documented in
>> Documentation/devicetree/bindings/timer/sifive,clint.yaml.
>> The device tree clint entry is renamed similarly to u-boot device tree
>> definition to improve compatibility with u-boot defined device tree.
>> To ensure correct initialization, the interrup-cells attribute is added
>> and the interrupt-extended attribute definition fixed.
>> 
>> This fixes boot failures with Kendryte K210 SoC boards.
>> 
>> Note that the clock referenced is kept as K210_CLK_ACLK, which does not
>> necessarilly match the clint MTIME increment rate. This however does not
>> seem to cause any problem for now.
>> 
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/riscv/boot/dts/kendryte/k210.dtsi | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/riscv/boot/dts/kendryte/k210.dtsi b/arch/riscv/boot/dts/kendryte/k210.dtsi
>> index c1df56ccb8d55..d2d0ff6456325 100644
>> --- a/arch/riscv/boot/dts/kendryte/k210.dtsi
>> +++ b/arch/riscv/boot/dts/kendryte/k210.dtsi
>> @@ -95,10 +95,12 @@ sysctl: sysctl@50440000 {
>>  			#clock-cells = <1>;
>>  		};
>>  
>> -		clint0: interrupt-controller@2000000 {
>> +		clint0: clint@2000000 {
>> +			#interrupt-cells = <1>;
>>  			compatible = "riscv,clint0";
>>  			reg = <0x2000000 0xC000>;
>> -			interrupts-extended = <&cpu0_intc 3>,  <&cpu1_intc 3>;
>> +			interrupts-extended =  <&cpu0_intc 3 &cpu0_intc 7
>> +						&cpu1_intc 3 &cpu1_intc 7>;
>>  			clocks = <&sysctl K210_CLK_ACLK>;
>>  		};
>>  
>> 
>
>Sasha,
>
>This is a fix for a problem in 5.9 tree. 5.8 kernel is fine without this patch.
>And I think applying it to 5.8 might actually break things since the proper
>clint driver was added to kernel 5.9 and does not exist in 5.8.

IIUC this won't actually break anything on 5.8, as the reason nobody noticed
that the old one was broken is because the old CLINT driver just didn't care
about what's in the device tree.  These interrupt numbers are defined by the
ISA manual so we jut had them encoded into the arch/riscv first-level interrupt
controller driver.

That said, it definately doesn't fix anything so it seems safer to just not
backport it.
