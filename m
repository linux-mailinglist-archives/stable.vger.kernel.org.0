Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261D659289B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 06:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiHOEVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 00:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiHOEVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 00:21:54 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5C67651
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 21:21:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 25C2532000EB;
        Mon, 15 Aug 2022 00:21:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 00:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1660537312; x=
        1660623712; bh=LAs4Krl1pDfjVbOvCDbGmqh0A3sEDGBtvwY9nnQEdLs=; b=z
        7+ReQKAwTHnlw64z/co1t5gf/Wjtv9Ml7LH2Lq5BCOoKAY4zRGnO86LHNfAaKRqs
        HG6mh4Dk84AowCwipgfJTNBpY+uMXvFr4Dk74yFwXw5h/FOHc2+L1CIGBfaI3ClD
        +PPZCHy4BeUP24LG98OCKU6KEBoYlxJ7hSCo7RvPdLgfITo0Ku4vZoNztB025x42
        RIC63WzcJhAb51EV9G4Qvb2yjTn0P8wfFOROo+xevcfGgpOGN6b9d6E/+rp3L/1i
        2yDCaZHF5zA8O+9EQA8eYzsjPZUW0ZTe8kAlfExtyWRes6Bp7WjnRCwDBrKv2dbl
        7bxJKIhhaB4to7aIpvJIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660537312; x=
        1660623712; bh=LAs4Krl1pDfjVbOvCDbGmqh0A3sEDGBtvwY9nnQEdLs=; b=0
        z3WqxdPCFW0tR6nxkkkz0SoIrCAMRNEa8cGgTGE6MTgACg9gggDMqgypcs0b0mQp
        8IE9bkNAbRi57XsrLqIvd58bpUNfrKWdGcIYVlJLJIdcBBPhBVRb5x84XsRmPYeB
        cv1Lghw54yRaizWtx5dA9wI3VuMGLnCrejINxUxCLxCufulAoupYGnDl8V2A37c7
        lgrZ/FQJFT2HSCw3VV5V+ybTSO/7eW5DO255yXzw2vRQOGowyGc1ex33l+LyHCRC
        Qr9xa9WBzybJHCEtgdEaojsO/FZlTLEEYKFGFilkckHTecjrc2hvNjkR4+1NpQ8g
        d1KR5sX49hKfP4dCLKaow==
X-ME-Sender: <xms:4Mn5YnZe9hrdDg6akK9649IZrq5myTCWrhTKlrWO0c3FId7h1mutpw>
    <xme:4Mn5YmZYgoQZehPD3_632bNOpscilPd22VftCeam8UCtw6DA-Vde4gBm8cKiDcf0h
    EszyYHjOTz7XOVKhA>
X-ME-Received: <xmr:4Mn5Yp-fU3C6WwFgNv84NZ1m2wF2lhdYo06-9ceqk1wfTZvPP5bVnAPz0iJCdP6zna3NzMHJgC40ogcMWyvML20hhaaN-9rz6acieiM5iuFzLHt660XNGlrQxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvvehfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeelteejffdvgeehkedtkeevueeuteffteffhedufeeujedvudef
    udetieeijeevleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhl
    rghnugdrohhrgh
X-ME-Proxy: <xmx:4Mn5Yto8e0LCw7GBjE8MWzIfeyj6j_susPNJeF7ypuMhKdehDLyMYQ>
    <xmx:4Mn5YiqJYGhR7dnQQ6CzOAl2XdsKRuvhkqvKeqV0KxGNOBktBaZ94A>
    <xmx:4Mn5YjS_9Iv701BamTHwPx0oplMwln89B6EBcJeC8MA6Sf3dId5daA>
    <xmx:4Mn5Yp3Rfw8Mw7gvSPScerlanBgF44IZj_E_cyuf4BUd6L0az16wXQ>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 00:21:51 -0400 (EDT)
Subject: Re: Patch "genirq: GENERIC_IRQ_IPI depends on SMP" has been added to
 the 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
References: <20220813225008.2015117-1-sashal@kernel.org>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <089a8281-000e-d275-1b50-77c03a5eb06c@sholland.org>
Date:   Sun, 14 Aug 2022 23:21:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20220813225008.2015117-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 8/13/22 5:50 PM, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     genirq: GENERIC_IRQ_IPI depends on SMP
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      genirq-generic_irq_ipi-depends-on-smp.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This commit should not be backported further than 8190cc572981
("irqchip/mips-gic: Only register IPI domain when SMP is enabled"), which it
depends on. It looks like that commit only went back to 5.10.

Regards,
Samuel

> commit 1ac66168f6a589c3f91104eb692fab83bae9ed73
> Author: Samuel Holland <samuel@sholland.org>
> Date:   Fri Jul 1 15:00:50 2022 -0500
> 
>     genirq: GENERIC_IRQ_IPI depends on SMP
>     
>     [ Upstream commit 0f5209fee90b4544c58b4278d944425292789967 ]
>     
>     The generic IPI code depends on the IRQ affinity mask being allocated
>     and initialized. This will not be the case if SMP is disabled. Fix up
>     the remaining driver that selected GENERIC_IRQ_IPI in a non-SMP config.
>     
>     Reported-by: kernel test robot <lkp@intel.com>
>     Signed-off-by: Samuel Holland <samuel@sholland.org>
>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>     Link: https://lore.kernel.org/r/20220701200056.46555-3-samuel@sholland.org
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 20f44ef9c4c9..e50b5516bbef 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -178,7 +178,7 @@ config MADERA_IRQ
>  config IRQ_MIPS_CPU
>  	bool
>  	select GENERIC_IRQ_CHIP
> -	select GENERIC_IRQ_IPI if SYS_SUPPORTS_MULTITHREADING
> +	select GENERIC_IRQ_IPI if SMP && SYS_SUPPORTS_MULTITHREADING
>  	select IRQ_DOMAIN
>  	select IRQ_DOMAIN_HIERARCHY if GENERIC_IRQ_IPI
>  	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index 4e11120265c7..3a8a631044f0 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -81,6 +81,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
>  # Generic IRQ IPI support
>  config GENERIC_IRQ_IPI
>  	bool
> +	depends on SMP
>  	select IRQ_DOMAIN_HIERARCHY
>  
>  # Generic MSI interrupt support
> 

