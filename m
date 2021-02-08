Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7179313795
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhBHP2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233778AbhBHPWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CAC64F08;
        Mon,  8 Feb 2021 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797228;
        bh=TUXENHIZ2Rbq0PFi5duugq/gf3J7F9KvCg99k/ZuPeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj+jdkaxWbO+AebOz53Cc7qg9dXGEpflZIbC8uFM7bJqydd1MOw/HrFI7WoHd1JGJ
         ytta3V2JB5RZsVimjWuUDbDEwxp85CltGp/fO4Z80OHjbrpanjfg8V6takQ6t9A5HP
         6iOXquiIouLdi50WNZipk7eHCPACjHsWYtJQNT4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Lo <kevlo@kevlo.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/120] igc: check return value of ret_val in igc_config_fc_after_link_up
Date:   Mon,  8 Feb 2021 16:00:24 +0100
Message-Id: <20210208145819.879564680@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

[ Upstream commit b881145642ce0bbe2be521e0882e72a5cebe93b8 ]

Check return value from ret_val to make error check actually work.

Fixes: 4eb8080143a9 ("igc: Add setup link functionality")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 09cd0ec7ee87d..67b8ffd21d8af 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -638,7 +638,7 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	}
 
 out:
-	return 0;
+	return ret_val;
 }
 
 /**
-- 
2.27.0



