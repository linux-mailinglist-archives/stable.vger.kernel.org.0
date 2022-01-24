Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD74998D3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453510AbiAXVaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42878 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450166AbiAXVTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4159961320;
        Mon, 24 Jan 2022 21:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8D4C340E4;
        Mon, 24 Jan 2022 21:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059190;
        bh=ZraSDlyB3Ox8MuBaGkawHRM3GvAIGMwaK8tbx1y+SJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4qR++ms+xO0bCdK++jtlfM1FLYh5H/ofKXa42Wlt4KLyeEcLBzJmHsl7p+VjEzQ6
         rWzvvGZMs3Nh47nFkZUdXrvSwonBB658/3NgYsZSdD017PlJSuqO8VOkudu0nvamCy
         C1oAUYDQHIusYy1eU76Kq0gyVvfbZQmdxzL48c98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0533/1039] mailbox: fix gce_num of mt8192 driver data
Date:   Mon, 24 Jan 2022 19:38:42 +0100
Message-Id: <20220124184143.200649646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jason-jh.lin <jason-jh.lin@mediatek.com>

[ Upstream commit 35ca43710f792ce183312fdc7e4b2bb0b721a173 ]

Because mt8192 only have 1 gce, the gce_num should be 1.

Fixes: 85dfdbfc13ea ("mailbox: cmdq: add multi-gce clocks support for mt8195")
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index a8845b162dbfa..9aae13e9e050e 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -658,7 +658,7 @@ static const struct gce_plat gce_plat_v5 = {
 	.thread_nr = 24,
 	.shift = 3,
 	.control_by_sw = true,
-	.gce_num = 2
+	.gce_num = 1
 };
 
 static const struct gce_plat gce_plat_v6 = {
-- 
2.34.1



