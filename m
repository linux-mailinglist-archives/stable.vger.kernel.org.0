Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F414A91A9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbfIDSWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389198AbfIDSFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:05:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3CB206BA;
        Wed,  4 Sep 2019 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620307;
        bh=JVMkUiNi1mC+2p6+ITIHy1TPRAyipRK4jUwnLWfxZTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpfiAzIx88tHk2+p95Ielc5RM7BasT28+Tx78E8enXs6ogL478vdB44y6fYLa0VHn
         1f0K6yB/XeCt0AUcsdkIi9JnVYyAKd8Vi8jZp6s945aTQPq3SSVi7Gt3bGDd4TcYCc
         nRUEwqdpsgWkGmOpYNBTLC7R0L8uCpwVDoPPorKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/93] soundwire: cadence_master: fix register definition for SLAVE_STATE
Date:   Wed,  4 Sep 2019 19:53:12 +0200
Message-Id: <20190904175304.057403828@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b07dd9b400981f487940a4d84292d3a0e7cd9362 ]

wrong prefix and wrong macro.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190725234032.21152-14-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index cb6a331f448ab..d3d7de5a319c5 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -81,8 +81,8 @@
 
 #define CDNS_MCP_INTSET				0x4C
 
-#define CDNS_SDW_SLAVE_STAT			0x50
-#define CDNS_MCP_SLAVE_STAT_MASK		BIT(1, 0)
+#define CDNS_MCP_SLAVE_STAT			0x50
+#define CDNS_MCP_SLAVE_STAT_MASK		GENMASK(1, 0)
 
 #define CDNS_MCP_SLAVE_INTSTAT0			0x54
 #define CDNS_MCP_SLAVE_INTSTAT1			0x58
-- 
2.20.1



