Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169952469D9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgHQP0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729822AbgHQP0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 713E123444;
        Mon, 17 Aug 2020 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678012;
        bh=BXqg6wkzqyR/Y63P+K0fbD/on/ZEu4WGrjQVB5n/Qtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PT3/Vrz21KJSoeKZI2u8qypnV++1CUsFCLDXFCtZ6BdDmVfHIx7QGKnHTYrnb9Kr7
         4g6YP2uZF2nKU52qV7VzLCJWJdQahkYRSuVl03MGAMlhxHhLwufu/Ak3CPYm4nnw7s
         +XqYgkt7Hbw6u7mvqojcejyDgbx47tw5p5qFu/QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 158/464] Bluetooth: hci_qca: Increase SoC idle timeout to 200ms
Date:   Mon, 17 Aug 2020 17:11:51 +0200
Message-Id: <20200817143841.376165824@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balakrishna Godavarthi <bgodavar@codeaurora.org>

[ Upstream commit 2d68476cfc2afa1a1a2d9007a23264ffc6308e77 ]

In some version of WCN399x, SoC idle timeout is configured
as 80ms instead of 20ms or 40ms. To honor all the SoC's
supported in the driver increasing SoC idle timeout to 200ms.

Fixes: 41d5b25fed0a0 ("Bluetooth: hci_qca: add PM support")
Signed-off-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 74245f20a309e..483766b745178 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -46,7 +46,7 @@
 #define HCI_MAX_IBS_SIZE	10
 
 #define IBS_WAKE_RETRANS_TIMEOUT_MS	100
-#define IBS_BTSOC_TX_IDLE_TIMEOUT_MS	40
+#define IBS_BTSOC_TX_IDLE_TIMEOUT_MS	200
 #define IBS_HOST_TX_IDLE_TIMEOUT_MS	2000
 #define CMD_TRANS_TIMEOUT_MS		100
 #define MEMDUMP_TIMEOUT_MS		8000
-- 
2.25.1



