Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBE4996F9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbiAXVIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445258AbiAXVCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688AE60916;
        Mon, 24 Jan 2022 21:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7F4C340E5;
        Mon, 24 Jan 2022 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058155;
        bh=agaYuHmMsceCY7fMVhfpeJqZyroFBz/itKzXugsUnlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGpDR5TzvHzsS2uKhDULMTbyxKj+NtKkG49+f1QPHeDoS4dHBKaTBgCcIDFriaEu4
         9o1/gadEUGj/yMEbGH5MNFNNiUzqFIFY9EO7Tc6KxXvHENvoEGsNLwdVlMUKn+aZgb
         ZPV5XzsP5OkS4vHW7sB8Hooa+uAI0J3eoAlWwIS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0155/1039] arm64: dts: renesas: cat875: Add rx/tx delays
Date:   Mon, 24 Jan 2022 19:32:24 +0100
Message-Id: <20220124184130.375230465@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit e1a9faddffe7e555304dc2e3284c84fbee0679ee ]

The CAT875 sub board from Silicon Linux uses a Realtek PHY.

The phy driver commit bbc4d71d63549bcd003 ("net: phy: realtek: fix
rtl8211e rx/tx delay config") introduced NFS mount failures.  Now it
needs both rx/tx delays for the NFS mount to work.

This patch fixes the NFS mount failure issue by adding "rgmii-id" mode
to the avb device node.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: bbc4d71d63549bcd ("net: phy: realtek: fix rtl8211e rx/tx delay config")
Link: https://lore.kernel.org/r/20211115142830.12651-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/cat875.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi b/arch/arm64/boot/dts/renesas/cat875.dtsi
index a69d24e9c61db..8c9da8b4bd60b 100644
--- a/arch/arm64/boot/dts/renesas/cat875.dtsi
+++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
@@ -18,6 +18,7 @@
 	pinctrl-names = "default";
 	renesas,no-ether-link;
 	phy-handle = <&phy0>;
+	phy-mode = "rgmii-id";
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-- 
2.34.1



