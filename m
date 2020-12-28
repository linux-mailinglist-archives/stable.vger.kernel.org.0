Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438BE2E416E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438976AbgL1OKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438993AbgL1OKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07F63206E5;
        Mon, 28 Dec 2020 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164576;
        bh=BTGsb7eondIfyiPcBaXYx2fmSUSt38aFYjHwfLNKu6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05WLfuER/16N0jWuSCq/fxHTyRnMnb+7gzZB+LeyHmndK+dJUd6ps9EvPm5RuGjlW
         mei6HGRGqdJYY5ltt5UqnX5edz0z+jy+AUKCWpoLkyVQbT44YPCXVnYGbWXrtbHoen
         gj51OU+tDHf3f0blWqXaBSKspzCTKQzKMVIqbmDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/717] drm/mediatek: Use correct aliases name for ovl
Date:   Mon, 28 Dec 2020 13:43:42 +0100
Message-Id: <20201228125031.712726817@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 414562b0ef36ce658f0ffec00e7039c7911e4cdc ]

Aliases property name must include only lowercase and '-', so fix this
in the driver, so we're not tempted to do "ovl_2l0 = &ovl_2l0" in the
device-tree instead of the right one which is "ovl-2l0 = &ovl_2l0".

Fixes: b17bdd0d7a73 ("drm/mediatek: add component OVL_2L0")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 8eba44be3a8ae..3064eac1a7507 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -359,7 +359,7 @@ static const struct mtk_ddp_comp_funcs ddp_ufoe = {
 
 static const char * const mtk_ddp_comp_stem[MTK_DDP_COMP_TYPE_MAX] = {
 	[MTK_DISP_OVL] = "ovl",
-	[MTK_DISP_OVL_2L] = "ovl_2l",
+	[MTK_DISP_OVL_2L] = "ovl-2l",
 	[MTK_DISP_RDMA] = "rdma",
 	[MTK_DISP_WDMA] = "wdma",
 	[MTK_DISP_COLOR] = "color",
-- 
2.27.0



