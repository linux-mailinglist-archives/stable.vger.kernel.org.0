Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC13F6E5411
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDQVo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 17:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDQVo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 17:44:26 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9ADC3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 14:44:23 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1poWe0-0006wK-FQ; Mon, 17 Apr 2023 23:44:16 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     dri-devel@lists.freedesktop.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sandy Huang <hjc@rock-chips.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        stable@vger.kernel.org,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Chris Morgan <macroalpha82@gmail.com>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume
Date:   Mon, 17 Apr 2023 23:44:14 +0200
Message-Id: <168176784870.3951774.15858460527087012477.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230417123747.2179695-1-s.hauer@pengutronix.de>
References: <20230417123747.2179695-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Apr 2023 14:37:47 +0200, Sascha Hauer wrote:
> afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume") uses
> regmap_reinit_cache() to fix the suspend/resume issue with the VOP2
> driver. During discussion it came up that we should rather use
> regcache_sync() instead. As the original patch is already applied
> fix this up in this follow-up patch.
> 
> 
> [...]

Applied, thanks!

[1/1] drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume
      commit: b63a553e8f5aa6574eeb535a551817a93c426d8c

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
