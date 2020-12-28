Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EDF2E655C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbgL1P7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387830AbgL1Nc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 464C620719;
        Mon, 28 Dec 2020 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162362;
        bh=OBsQR/1RGwJkIal+UEwrsvtNd/nlVETJ1k/lt38u53A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOl9v7TqnLfALq1Le8iZvGIltBCHopKsDOiv7MIg4NfRzmVUm4oyvkIf6XEZH2oNa
         FknRecRT4jsZi0iFIZMaVC+l8cUt7Xlr6dyLFAflB/5b0vAlmTSxL1oEEsT7LSr1Bz
         IfjQdHjARKjyf3yW7lkiiCzeqMeBWHJmrdWM0pDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Kocialkowski <contact@paulk.fr>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 252/346] ARM: sunxi: Add machine match for the Allwinner V3 SoC
Date:   Mon, 28 Dec 2020 13:49:31 +0100
Message-Id: <20201228124931.966448836@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <contact@paulk.fr>

[ Upstream commit ad2091f893bd5dfe2824f0d6819600d120698e9f ]

The Allwinner V3 SoC shares the same base as the V3s but comes with
extra pins and features available. As a result, it has its dedicated
compatible string (already used in device trees), which is added here.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201031182137.1879521-2-contact@paulk.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-sunxi/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index de4b0e932f22e..aa08b8cb01524 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -66,6 +66,7 @@ static const char * const sun8i_board_dt_compat[] = {
 	"allwinner,sun8i-h2-plus",
 	"allwinner,sun8i-h3",
 	"allwinner,sun8i-r40",
+	"allwinner,sun8i-v3",
 	"allwinner,sun8i-v3s",
 	NULL,
 };
-- 
2.27.0



