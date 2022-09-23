Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10635E81A1
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiIWSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiIWSPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:15:02 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042C32B24C;
        Fri, 23 Sep 2022 11:14:57 -0700 (PDT)
Received: from p508fdd76.dip0.t-ipconnect.de ([80.143.221.118] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1obnCL-0000GC-Bj; Fri, 23 Sep 2022 20:14:49 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Quentin Schulz <foss+kernel@0leil.net>
Cc:     linus.walleij@linaro.org, brgl@bgdev.pl, jay.xu@rock-chips.com,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        foss+kernel@0leil.net,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: rockchip: add pinmux_ops.gpio_set_direction callback
Date:   Fri, 23 Sep 2022 20:14:48 +0200
Message-ID: <2890748.BddDVKsqQX@phil>
In-Reply-To: <20220923145141.3463754-2-foss+kernel@0leil.net>
References: <20220923145141.3463754-1-foss+kernel@0leil.net> <20220923145141.3463754-2-foss+kernel@0leil.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, 23. September 2022, 16:51:40 CEST schrieb Quentin Schulz:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> 
> Before the split of gpio and pinctrl sections in their own driver,
> rockchip_set_mux was called in pinmux_ops.gpio_set_direction for
> configuring a pin in its GPIO function.
> 
> This is essential for cases where pinctrl is "bypassed" by gpio
> consumers otherwise the GPIO function is not configured for the pin and
> it does not work. Such was the case for the sysfs/libgpiod userspace
> GPIO handling.
> 
> Let's re-implement the pinmux_ops.gpio_set_direction callback so that
> the gpio subsystem can request from the pinctrl driver to put the pin in
> its GPIO function.
> 
> Fixes: 9ce9a02039de ("pinctrl/rockchip: drop the gpio related codes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>



