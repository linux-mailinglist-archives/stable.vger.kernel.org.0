Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4059F9616F
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfHTNrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730205AbfHTNkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:46 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19ABD233FF;
        Tue, 20 Aug 2019 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308445;
        bh=uUiyTOYTGJTtIk3PtX7pyYoHvRoI1mjuDgQV82cdJwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwQ2Ai1APoszcX2qOdg5ews/GfCixn/Pt5LIPxVLhVDIqVhoLlaYf0aHsOQvabP5p
         5EjNY1gXnmwQa7PdClfrIPXJAbDJx5tSf77OZrM+J1LwTtAgbOrsKjLTDAPPZu4M4c
         B+JPCNnAfD2rRWU35vjhQkhsTW8s7fgQUTXMIPdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 18/44] soundwire: cadence_master: fix register definition for SLAVE_STATE
Date:   Tue, 20 Aug 2019 09:40:02 -0400
Message-Id: <20190820134028.10829-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

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
index 682789bb8ab30..18afb2e21dc9a 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -80,8 +80,8 @@
 
 #define CDNS_MCP_INTSET				0x4C
 
-#define CDNS_SDW_SLAVE_STAT			0x50
-#define CDNS_MCP_SLAVE_STAT_MASK		BIT(1, 0)
+#define CDNS_MCP_SLAVE_STAT			0x50
+#define CDNS_MCP_SLAVE_STAT_MASK		GENMASK(1, 0)
 
 #define CDNS_MCP_SLAVE_INTSTAT0			0x54
 #define CDNS_MCP_SLAVE_INTSTAT1			0x58
-- 
2.20.1

