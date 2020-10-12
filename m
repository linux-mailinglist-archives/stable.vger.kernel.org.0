Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1128B844
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390090AbgJLNuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgJLNsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B506204EA;
        Mon, 12 Oct 2020 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510450;
        bh=F+qkMl6KMVqlXzx7JDD+1l+y/Ak3Qf5lN4+M2ejDddo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/Cbquu5J3+tfVSF+38MMY3g7YoL35W1NRKmOqtVTKsJhyJWgJFM63kt1XDw0qRZn
         W9+y2DgbnhIXglegOT3boyWP9ePykGq2krZjwjN56ufFAWIZ7imLFMt0jEBfzVSa85
         nFmLBtGAuv1hhk+3mBdlWdp2ByZldxCdFE7BJKqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 104/124] net: mscc: ocelot: rename ocelot_board.c to ocelot_vsc7514.c
Date:   Mon, 12 Oct 2020 15:31:48 +0200
Message-Id: <20201012133151.895635620@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 589aa6e7c9de322d47eb33a5cee8cc38838319e6 ]

To follow the model of felix and seville where we have one
platform-specific file, rename this file to the actual SoC it serves.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/Makefile                             | 2 +-
 drivers/net/ethernet/mscc/{ocelot_board.c => ocelot_vsc7514.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/ethernet/mscc/{ocelot_board.c => ocelot_vsc7514.c} (100%)

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 91b33b55054e1..ad97a5cca6f99 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
 mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o ocelot_ptp.o
-obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
+obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_vsc7514.o
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_board.c
rename to drivers/net/ethernet/mscc/ocelot_vsc7514.c
-- 
2.25.1



