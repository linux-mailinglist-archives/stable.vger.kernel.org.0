Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC1612317
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJ2NBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 09:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJ2NBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 09:01:02 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AF75B725;
        Sat, 29 Oct 2022 06:01:01 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oolSE-0006ID-AS; Sat, 29 Oct 2022 15:00:50 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        dri-devel@lists.freedesktop.org,
        Helen Koike <helen.koike@collabora.com>,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/rockchip: dsi: Clean up 'usage_mode' when failing to attach
Date:   Sat, 29 Oct 2022 15:00:45 +0200
Message-Id: <166704843775.1532410.17134222926830396000.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid>
References: <20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid>
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

On Wed, 19 Oct 2022 17:03:48 -0700, Brian Norris wrote:
> If we fail to attach the first time (especially: EPROBE_DEFER), we fail
> to clean up 'usage_mode', and thus will fail to attach on any subsequent
> attempts, with "dsi controller already in use".
> 
> Re-set to DW_DSI_USAGE_IDLE on attach failure.
> 
> This is especially common to hit when enabling asynchronous probe on a
> duel-DSI system (such as RK3399 Gru/Scarlet), such that we're more
> likely to fail dw_mipi_dsi_rockchip_find_second() the first time.
> 
> [...]

Applied, thanks!

[1/2] drm/rockchip: dsi: Clean up 'usage_mode' when failing to attach
      commit: 0be67e0556e469c57100ffe3c90df90abc796f3b
[2/2] drm/rockchip: dsi: Force synchronous probe
      commit: 81e592f86f7afdb76d655e7fbd7803d7b8f985d8

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
