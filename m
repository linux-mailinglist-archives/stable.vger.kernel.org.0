Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B313C5361
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352350AbhGLHyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350300AbhGLHut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC5E613DB;
        Mon, 12 Jul 2021 07:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075876;
        bh=/JHcOw9963y7mAcrP53w/s5JsRn5rCznbAORxLRDIYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1qREwQGq6gXFbTy7OloE7zPb7BgQ7Z1Szm1zkyHlLg36QQS+jk15jtMxFeAlo/+b
         ++WWz3YBJv/Qbc+gR3OUEFRHNtWCyM6RZQMPSOFB5sjj77e3+Jho4JXz8h4ZbAdJS9
         QlJ23Fzf86zim8MpPpvWoA6MSPGmtFD8MxVlI02A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 402/800] pinctrl: renesas: r8a77990: JTAG pins do not have pull-down capabilities
Date:   Mon, 12 Jul 2021 08:07:05 +0200
Message-Id: <20210712061009.931523053@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index d040eb3e305d..eeebbab4dd81 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77990.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77990.c
@@ -53,10 +53,10 @@
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



