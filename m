Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3361128B942
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388948AbgJLN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388831AbgJLNkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069D8221FF;
        Mon, 12 Oct 2020 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510020;
        bh=y5FT2GJf9TW6Y0VgJnAu8jhSXIO5GmntzAzd9OrCVWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDAI9JTrP5RsuZ1HzvpYThzYMxnCa1bTp9tRvSp/kjLLewwk0EFLLK28i0zeSRv8g
         45cF3OYP46FOzigzOIS9xzBpm8+7rlXwbTyVsVZ9j5AUMTNHLp8YydfBFhgqXSBQX5
         sXm31qkl+BGMptoWe52WMiVraM5I75JbKCK5R5lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/49] net: usb: ax88179_178a: fix missing stop entry in driver_info
Date:   Mon, 12 Oct 2020 15:27:25 +0200
Message-Id: <20201012132631.241589077@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
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
index 8455f72007b9e..a9d0df435e266 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1735,6 +1735,7 @@ static const struct driver_info belkin_info = {
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
-- 
2.25.1



