Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1CB3DD9A0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhHBOCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhHBOAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA302611C4;
        Mon,  2 Aug 2021 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912579;
        bh=1RJNlDgxjwTRj8QaxVR1lvEESJEU3rryxWrpvzeXMls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpFpwc+LKJkMxbZG6k4RCpTqTgVUD1iLV/yGkb1z8xesvm3sN3zhnBkOcHWOGSJ1q
         Tuu/wr9STxr+MXos1Qdu+TF+unmgzSkb6TnZf5RERYuAgjb5woAq6/JLpavE04Dg6V
         WTcB/lmOGGkmF04HNtMXr/CDYLE7eDmHriuUTkQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 023/104] net: stmmac: add est_irq_status callback function for GMAC 4.10 and 5.10
Date:   Mon,  2 Aug 2021 15:44:20 +0200
Message-Id: <20210802134344.782108284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

commit 94cbe7db7d757c2d481c3617ab5579a28cfc2175 upstream.

Assign dwmac5_est_irq_status to est_irq_status callback function for
GMAC 4.10 and 5.10. With this, EST related interrupts could be handled
properly.

Fixes: e49aa315cb01 ("net: stmmac: EST interrupts handling and error reporting")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Acked-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -1249,6 +1249,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.est_irq_status = dwmac5_est_irq_status,
 	.fpe_configure = dwmac5_fpe_configure,
 	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
 	.fpe_irq_status = dwmac5_fpe_irq_status,
@@ -1300,6 +1301,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.est_irq_status = dwmac5_est_irq_status,
 	.fpe_configure = dwmac5_fpe_configure,
 	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
 	.fpe_irq_status = dwmac5_fpe_irq_status,


