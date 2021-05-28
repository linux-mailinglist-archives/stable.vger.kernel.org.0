Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114B53946C7
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 20:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhE1SL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 14:11:28 -0400
Received: from gloria.sntech.de ([185.11.138.130]:44696 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhE1SL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 May 2021 14:11:28 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1lmgvf-0006Ve-5R; Fri, 28 May 2021 20:09:51 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     linux-kernel@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>
Cc:     Heiko Stuebner <heiko@sntech.de>, stable@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] drm/rockchip: dsi: remove extra component_del() call
Date:   Fri, 28 May 2021 20:09:45 +0200
Message-Id: <162222530163.2887132.8458225826944784611.b4-ty@sntech.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <201385acb0eeb5dfb037afdc6a94bfbcdab97f99.1618797778.git.tommyhebb@gmail.com>
References: <201385acb0eeb5dfb037afdc6a94bfbcdab97f99.1618797778.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 18 Apr 2021 19:03:04 -0700, Thomas Hebb wrote:
> commit cf6d100dd238 ("drm/rockchip: dsi: add dual mipi support") added
> this devcnt field and call to component_del(). However, these both
> appear to be erroneous changes left over from an earlier version of the
> patch. In the version merged, nothing ever modifies devcnt, meaning
> component_del() runs unconditionally and in addition to the
> component_del() calls in dw_mipi_dsi_rockchip_host_detach(). The second
> call fails to delete anything and produces a warning in dmesg.
> 
> [...]

Applied, thanks!

[1/1] drm/rockchip: dsi: remove extra component_del() call
      commit: b354498bbe65c917d521b3b56317ddc9ab217425

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
