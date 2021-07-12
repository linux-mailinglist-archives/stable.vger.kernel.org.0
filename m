Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535F43C4DA8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhGLHNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242244AbhGLHMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF4061151;
        Mon, 12 Jul 2021 07:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073791;
        bh=1iRiAaJHNFSjiz4dzRp8ZDIttGeT8AVcwI4yk62Girc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6usGVNlcGhvGf/kPZkFWj3xnUDkK4lZqR5TQOm2l1iAUoXvQyxFuSonIA9GNzEv1
         lEDIcncdyZieIQMh2mecti64l1VpMeLhn6/6FyIQt140JPTQrLwPQy8FUuYkLmdrDV
         ffFZrLueY9anY/uSdxk11WgMB0I20kZZP0aP8cQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 362/700] pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
Date:   Mon, 12 Jul 2021 08:07:25 +0200
Message-Id: <20210712061014.876586461@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 702a5fa2fe4d7e7f28fed92a170b540acfff9d34 ]

Hence remove the SH_PFC_PIN_CFG_PULL_DOWN flags from their pin
descriptions.

Fixes: 83f6941a42a5e773 ("pinctrl: sh-pfc: r8a77990: Add bias pinconf support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/da4b2d69955840a506412f1e8099607a0da97ecc.1619785375.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a77990.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a77990.c b/drivers/pinctrl/renesas/pfc-r8a77990.c
index 0a32e3c317c1..95bcacf1275d 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77990.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77990.c
@@ -54,10 +54,10 @@
 	PIN_NOGP_CFG(FSCLKST_N, "FSCLKST_N", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(MLB_REF, "MLB_REF", fn, CFG_FLAGS),		\
 	PIN_NOGP_CFG(PRESETOUT_N, "PRESETOUT_N", fn, CFG_FLAGS),	\
-	PIN_NOGP_CFG(TCK, "TCK", fn, CFG_FLAGS),			\
-	PIN_NOGP_CFG(TDI, "TDI", fn, CFG_FLAGS),			\
-	PIN_NOGP_CFG(TMS, "TMS", fn, CFG_FLAGS),			\
-	PIN_NOGP_CFG(TRST_N, "TRST_N", fn, CFG_FLAGS)
+	PIN_NOGP_CFG(TCK, "TCK", fn, SH_PFC_PIN_CFG_PULL_UP),		\
+	PIN_NOGP_CFG(TDI, "TDI", fn, SH_PFC_PIN_CFG_PULL_UP),		\
+	PIN_NOGP_CFG(TMS, "TMS", fn, SH_PFC_PIN_CFG_PULL_UP),		\
+	PIN_NOGP_CFG(TRST_N, "TRST_N", fn, SH_PFC_PIN_CFG_PULL_UP)
 
 /*
  * F_() : just information
-- 
2.30.2



