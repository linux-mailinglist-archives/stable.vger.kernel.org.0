Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C8178168
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgCCSCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387746AbgCCSCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49619206D5;
        Tue,  3 Mar 2020 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258535;
        bh=wtzmxt4IUQZwQeiPQbCPbGhcqVFoVsKHdba80U9RxoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ9v/pq6NAUHsx+zsT6O7F9b21XinBBxZRR67Oi8kC/g1M4a0Z9HFwUwqeC1ZDrl4
         WYaBbDkWL/c2qnDo/XkcjSwUszvpzmGNJkWmjybwQRIRiSAOX/7CrWO8WOHcJpNWw1
         TFXgnpoNHxkr+wwmZ7aEPbRCxzOPkSXRbmVgqQbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 69/87] mwifiex: delete unused mwifiex_get_intf_num()
Date:   Tue,  3 Mar 2020 18:44:00 +0100
Message-Id: <20200303174356.492876271@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 1c9f329b084b7b8ea6d60d91a202e884cdcf6aae upstream.

Commit 7afb94da3cd8 ("mwifiex: update set_mac_address logic") fixed the
only user of this function, partly because the author seems to have
noticed that, as written, it's on the borderline between highly
misleading and buggy.

Anyway, no sense in keeping dead code around: let's drop it.

Fixes: 7afb94da3cd8 ("mwifiex: update set_mac_address logic")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/main.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1294,19 +1294,6 @@ mwifiex_copy_rates(u8 *dest, u32 pos, u8
 	return pos;
 }
 
-/* This function return interface number with the same bss_type.
- */
-static inline u8
-mwifiex_get_intf_num(struct mwifiex_adapter *adapter, u8 bss_type)
-{
-	u8 i, num = 0;
-
-	for (i = 0; i < adapter->priv_num; i++)
-		if (adapter->priv[i] && adapter->priv[i]->bss_type == bss_type)
-			num++;
-	return num;
-}
-
 /*
  * This function returns the correct private structure pointer based
  * upon the BSS type and BSS number.


