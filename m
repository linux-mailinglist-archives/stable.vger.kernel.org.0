Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590AE6644A6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjAJP0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238922AbjAJP0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:26:21 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C575D418;
        Tue, 10 Jan 2023 07:25:46 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pFGVO-0005YW-Jl; Tue, 10 Jan 2023 16:25:38 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Michael Turquette <mturquette@baylibre.com>,
        Xing Zheng <zhengxing@rock-chips.com>,
        Quentin Schulz <foss+kernel@0leil.net>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     Heiko Stuebner <heiko@sntech.de>, stable@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent
Date:   Tue, 10 Jan 2023 16:25:37 +0100
Message-Id: <167336433299.2636594.362082360376536202.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com>
References: <20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Nov 2022 13:04:31 +0100, Quentin Schulz wrote:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> 
> clk_cifout is derived from clk_cifout_src through an integer divider
> limited to 32. clk_cifout_src is a child of either cpll, gpll or npll
> without any possibility of a divider of any sort. The default clock
> parent is cpll.
> 
> [...]

Applied, thanks!

[1/1] clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent
      commit: 3ad07d73ae650057fe64b2d85721c644a30428c1

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
