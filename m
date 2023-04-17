Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2549E6E459D
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDQKuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 06:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQKuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 06:50:20 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C699493E3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:49:33 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1poMKr-0002c5-0t; Mon, 17 Apr 2023 12:43:49 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     dri-devel@lists.freedesktop.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Chris Morgan <macroalpha82@gmail.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
Date:   Mon, 17 Apr 2023 12:43:42 +0200
Message-Id: <168172821104.3902783.8715720558110042171.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230413144347.3506023-1-s.hauer@pengutronix.de>
References: <20230413144347.3506023-1-s.hauer@pengutronix.de>
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

On Thu, 13 Apr 2023 16:43:47 +0200, Sascha Hauer wrote:
> During a suspend/resume cycle the VO power domain will be disabled and
> the VOP2 registers will reset to their default values. After that the
> cached register values will be out of sync and the read/modify/write
> operations we do on the window registers will result in bogus values
> written. Fix this by re-initializing the register cache each time we
> enable the VOP2. With this the VOP2 will show a picture after a
> suspend/resume cycle whereas without this the screen stays dark.
> 
> [...]

Applied, thanks!

[1/1] drm/rockchip: vop2: fix suspend/resume
      commit: afa965a45e01e541cdbe5c8018226eff117610f0

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
