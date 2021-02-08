Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C46D31370A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhBHPTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230310AbhBHPNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E077E64EFC;
        Mon,  8 Feb 2021 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797021;
        bh=xPmlSbqPZzFnC7AoymwoOGLZwfZ5b2rnUxebi3BD/mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fpbn2B3vhNlHQhdfXWzA3gYqleKToKYKSGJp2TXY1+3UG9TqgcseFW5g8KrSbSG+p
         YRV1u822c1RfffI8n8yY1qHalwLCN1t2eM6z+40b81YQFFTdI1KsIiIHWoni2Fz45p
         5A6TPr+H1uJn84wfJgHWYv7KTACUTWcdHdVDDmNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Lo <kevlo@kevlo.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/65] igc: check return value of ret_val in igc_config_fc_after_link_up
Date:   Mon,  8 Feb 2021 16:00:46 +0100
Message-Id: <20210208145810.792280441@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
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
index 5eeb4c8caf4ae..08adf103e90b4 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -647,7 +647,7 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	}
 
 out:
-	return 0;
+	return ret_val;
 }
 
 /**
-- 
2.27.0



