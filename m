Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAD0450AC8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKOROn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232425AbhKORNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FFF76320D;
        Mon, 15 Nov 2021 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996210;
        bh=MRU56tOId8Mxj+TZyUhEIfrnQSLnb0L6uby7nVDXcGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNxuusq/Itdf4DZyiJMNWBTEOz7dWWydxY2KU8IXjd42S+Bs6V9wFWt8ItKW6aUie
         qBCrBjVSRY0bX0RE8HAzHuQGcU1kxR9+TQK7eJ88Q7qikvq8sHQMLsi7GvhmyKTGbL
         GjTlCyEehg+//Ec34JzpaTy21YlOc52zra8bsQ2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janghyub Seo <jhyub06@gmail.com>,
        Rushab Shah <rushabshah32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/355] r8169: Add device 10ec:8162 to driver r8169
Date:   Mon, 15 Nov 2021 17:59:40 +0100
Message-Id: <20211115165315.627928304@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janghyub Seo <jhyub06@gmail.com>

[ Upstream commit 72f898ca0ab85fde6facf78b14d9f67a4a7b32d1 ]

This patch makes the driver r8169 pick up device Realtek Semiconductor Co.
, Ltd. Device [10ec:8162].

Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
Suggested-by: Rushab Shah <rushabshah32@gmail.com>
Link: https://lore.kernel.org/r/1635231849296.1489250046.441294000@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 623d86e5e970f..8d2b184ff5758 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -212,6 +212,7 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
 	{ PCI_VDEVICE(REALTEK,	0x8129) },
 	{ PCI_VDEVICE(REALTEK,	0x8136), RTL_CFG_NO_GBIT },
 	{ PCI_VDEVICE(REALTEK,	0x8161) },
+	{ PCI_VDEVICE(REALTEK,	0x8162) },
 	{ PCI_VDEVICE(REALTEK,	0x8167) },
 	{ PCI_VDEVICE(REALTEK,	0x8168) },
 	{ PCI_VDEVICE(NCUBE,	0x8168) },
-- 
2.33.0



