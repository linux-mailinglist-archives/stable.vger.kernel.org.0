Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61746323379
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhBWVu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:50:26 -0500
Received: from gloria.sntech.de ([185.11.138.130]:33040 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231721AbhBWVu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 16:50:26 -0500
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1lEfYl-0004jo-Qk; Tue, 23 Feb 2021 22:49:35 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     dri-devel@lists.freedesktop.org, daniels@collabora.com,
        hjc@rock-chips.com, daniel@ffwll.ch,
        linux-rockchip@lists.infradead.org, airlied@linux.ie,
        andrzej.p@collabora.com,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Cc:     Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH] drm/rockchip: Require the YTR modifier for AFBC
Date:   Tue, 23 Feb 2021 22:49:31 +0100
Message-Id: <161411675671.3338515.9688232276427844069.b4-ty@sntech.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
References: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Aug 2020 16:26:31 -0400, Alyssa Rosenzweig wrote:
> The AFBC decoder used in the Rockchip VOP assumes the use of the
> YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
> buffers, which covers the RGBA8 and RGB565 formats supported in
> vop_convert_afbc_format. Use of YTR is signaled with the
> AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
> such, a producer would have to generate buffers that do not use YTR,
> which the VOP would erroneously decode as YTR, leading to severe visual
> corruption.
> 
> [...]

Applied, thanks!

[1/1] drm/rockchip: Require the YTR modifier for AFBC
      commit: 0de764474e6e0a74bd75715fed227d82dcda054c

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
