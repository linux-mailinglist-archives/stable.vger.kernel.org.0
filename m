Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788C3A918D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfIDSSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389736AbfIDSL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89A3A208E4;
        Wed,  4 Sep 2019 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620689;
        bh=WCkSDHhDod0dNyN+ga/qSbI1H/xENw8joAUwSfjiOqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPEQ33TKwdNGQpGlPbfIqHJLF4vbBv9xx4WKQte4RK4ie3PB/5hHNtqfG0esro/tf
         zlxnqqVgEbcnuS/LF3fLn2ZOGUKxVoNsWavntzhSGQ/qcG+frc3hgknM7FM/o+PsW6
         YZsy337S8LtvqB3ttWxtll6FDT2qkuxApOsxU0vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 017/143] soundwire: cadence_master: fix register definition for SLAVE_STATE
Date:   Wed,  4 Sep 2019 19:52:40 +0200
Message-Id: <20190904175314.755664261@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
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



