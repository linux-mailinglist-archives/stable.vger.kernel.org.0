Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B35324D8B
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhBYKEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhBYKAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D14B64F23;
        Thu, 25 Feb 2021 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246932;
        bh=UBu0Do1tJBKsqNSF6lz//geyXMo1BLqDEoi/eFKxZ9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bn7gTzeZNN2ZDLi8x9qL/9N50EG0+DE7VeJ1TiG8xps2l4SBYtKkUdIl7qOgFDxad
         9joMvt0RgEuQ6EVOqZsrDT0GD67DJDUKgWw7DTv8zDcYSShFlys4h3cGWWkm9oMGCh
         MofJzP6GuTgUtyUHzRhDop6XIDVxY+WHoKpe4P84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/23] cxgb4: Add new T6 PCI device id 0x6092
Date:   Thu, 25 Feb 2021 10:53:51 +0100
Message-Id: <20210225092517.492816967@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit 3401e4aa43a540881cc97190afead650e709c418 ]

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Link: https://lore.kernel.org/r/20210202182511.8109-1-rajur@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h b/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
index 0c5373462cedb..0b1b5f9c67d47 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
@@ -219,6 +219,7 @@ CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN
 	CH_PCI_ID_TABLE_FENTRY(0x6089), /* Custom T62100-KR */
 	CH_PCI_ID_TABLE_FENTRY(0x608a), /* Custom T62100-CR */
 	CH_PCI_ID_TABLE_FENTRY(0x608b), /* Custom T6225-CR */
+	CH_PCI_ID_TABLE_FENTRY(0x6092), /* Custom T62100-CR-LOM */
 CH_PCI_DEVICE_ID_TABLE_DEFINE_END;
 
 #endif /* __T4_PCI_ID_TBL_H__ */
-- 
2.27.0



