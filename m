Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245AA4ADFB8
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345869AbiBHRf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241572AbiBHRf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:35:27 -0500
X-Greylist: delayed 1370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 09:35:25 PST
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB18C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 09:35:25 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1nHU2U-00034v-M7; Tue, 08 Feb 2022 18:12:26 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Brian Norris <briannorris@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Heiko Stuebner <heiko@sntech.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org, Mark Yao <markyao0591@gmail.com>
Subject: Re: [PATCH] drm/rockchip: vop: Correct RK3399 VOP register fields
Date:   Tue,  8 Feb 2022 18:12:25 +0100
Message-Id: <164434033775.248576.1440613083224554584.b4-ty@sntech.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid>
References: <20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Jan 2022 16:11:22 -0800, Brian Norris wrote:
> Commit 7707f7227f09 ("drm/rockchip: Add support for afbc") switched up
> the rk3399_vop_big[] register windows, but it did so incorrectly.
> 
> The biggest problem is in rk3288_win23_data[] vs.
> rk3368_win23_data[] .format field:
> 
>   RK3288's format: VOP_REG(RK3288_WIN2_CTRL0, 0x7, 1)
>   RK3368's format: VOP_REG(RK3368_WIN2_CTRL0, 0x3, 5)
> 
> [...]

Applied, thanks!

[1/1] drm/rockchip: vop: Correct RK3399 VOP register fields
      commit: 9da1e9ab82c92d0e89fe44cad2cd7c2d18d64070

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
