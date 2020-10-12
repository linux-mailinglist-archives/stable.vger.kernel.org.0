Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAACA28B997
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgJLOB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730904AbgJLNiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60D922244;
        Mon, 12 Oct 2020 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509863;
        bh=5Ex+mXH27rZvA7S/asn1Wb6Cz7VFNrhQORRj7MTgRhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWMEHkRV3II7pTRclxiuDJxvveekGkk7Vbg4oOw1ly3HfScmwy1p8AdLtPI/Fmp0y
         BwbJgwtKmNtdEzH88iwIJ87X6Da7S3AEd7eY5fr+LvVA3l+Ct0hhNSo/gKNjFIYs8n
         NHIcTyFkVJYD7I3uDisuPVGJ5i9jnnAy0aZAL+G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/70] net: usb: ax88179_178a: fix missing stop entry in driver_info
Date:   Mon, 12 Oct 2020 15:27:18 +0200
Message-Id: <20201012132633.183992972@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
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
index 875639b0e9d56..e7193a541244b 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1736,6 +1736,7 @@ static const struct driver_info belkin_info = {
 	.status = ax88179_status,
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
 	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
-- 
2.25.1



