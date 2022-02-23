Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA81B4C202C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 00:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245037AbiBWXoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 18:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiBWXov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 18:44:51 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D923649272;
        Wed, 23 Feb 2022 15:44:22 -0800 (PST)
Received: from [185.156.123.69] (helo=phil.sntech)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1nN1Is-0005mN-Ig; Thu, 24 Feb 2022 00:44:14 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     "quentin.schulz@theobroma-systems.com" 
        <quentin.schulz@theobroma-systems.com>
Cc:     Heiko Stuebner <heiko@sntech.de>, sboyd@kernel.org,
        linux-rockchip@lists.infradead.org, linux-clk@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Quentin Schulz <foss+kernel@0leil.net>,
        mturquette@baylibre.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: re-add rational best approximation algorithm to the fractional divider
Date:   Thu, 24 Feb 2022 00:44:11 +0100
Message-Id: <164565984101.1356028.16253191967940444197.b4-ty@sntech.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131163224.708002-1-quentin.schulz@theobroma-systems.com>
References: <20220131163224.708002-1-quentin.schulz@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 17:32:24 +0100, quentin.schulz@theobroma-systems.com wrote:
> In commit 4e7cf74fa3b2 ("clk: fractional-divider: Export approximation
> algorithm to the CCF users"), the code handling the rational best
> approximation algorithm was replaced by a call to the core
> clk_fractional_divider_general_approximation function which did the same
> thing back then.
> 
> However, in commit 82f53f9ee577 ("clk: fractional-divider: Introduce
> POWER_OF_TWO_PS flag"), this common code was made conditional on
> CLK_FRAC_DIVIDER_POWER_OF_TWO_PS flag which was not added back to the
> rockchip clock driver.
> 
> [...]

Applied, thanks!

[1/1] clk: rockchip: re-add rational best approximation algorithm to the fractional divider
      commit: 10b74af310735860510a533433b1d3ab2e05a138

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
