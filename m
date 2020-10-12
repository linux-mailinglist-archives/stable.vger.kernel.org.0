Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DBD28B76E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbgJLNnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731546AbgJLNms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D69B22202;
        Mon, 12 Oct 2020 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510154;
        bh=k78XAI5isEK/D5oZDtstYulxItLHO5vvYCvSyiP5twM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qh6e9icFiDcrNm4Z3mUqjeXp5TpLavbLjLB+5jsSFdF3KoFO7dIGGCgOQp/5Hs8OH
         gc9AVzNOeAOW//Ap8h3UeMve4UFhwDyMmiIu54Dy6l1713RjcEhIF3E/Izwtzvnvzn
         IqX2MEPyHR/2aFKibdaOBdbelZCJf5jgApkHl8z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/85] net: usb: ax88179_178a: fix missing stop entry in driver_info
Date:   Mon, 12 Oct 2020 15:27:26 +0200
Message-Id: <20201012132635.874229686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

[ Upstream commit 9666ea66a74adfe295cb3a8760c76e1ef70f9caf ]

Adds the missing .stop entry in the Belkin driver_info structure.

Fixes: e20bd60bf62a ("net: usb: asix88179_178a: Add support for the Belkin B2B128")
Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index df2f7cc6dc03a..8e37e1f58c4b9 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1719,6 +1719,7 @@ static const struct driver_info belkin_info = {
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
-- 
2.25.1



