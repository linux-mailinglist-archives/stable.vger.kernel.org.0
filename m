Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59789616E
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfHTNks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbfHTNkr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:47 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A9622DD3;
        Tue, 20 Aug 2019 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308446;
        bh=15y7qHeOKSIhTgwQgQ1ckkwHIVzV/AWfqhAgF+EoTqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zod1oeP7f+VOAdeP5ru79A+1hzloF0vRH2TMoP49y3lb2DbPqcfOsZXh2iPvprYgc
         axWfriBMQQ31wG5pnjAEiOSBt9iuaKy2GyKNtvT8ySnuCoPEo7fvT+IR6k4RrPiz6h
         yzzz2XC9hhMiAVe0bYt7pi7zpAJaX6fX/rk+P1rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 19/44] soundwire: cadence_master: fix definitions for INTSTAT0/1
Date:   Tue, 20 Aug 2019 09:40:03 -0400
Message-Id: <20190820134028.10829-19-sashal@kernel.org>
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

[ Upstream commit 664b16589f882202b8fa8149d0074f3159bade76 ]

Two off-by-one errors: INTSTAT0 missed BIT(31) and INTSTAT1 is only
defined on first 16 bits.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190725234032.21152-15-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 18afb2e21dc9a..57ed2e2024bf4 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -95,8 +95,8 @@
 #define CDNS_MCP_SLAVE_INTMASK0			0x5C
 #define CDNS_MCP_SLAVE_INTMASK1			0x60
 
-#define CDNS_MCP_SLAVE_INTMASK0_MASK		GENMASK(30, 0)
-#define CDNS_MCP_SLAVE_INTMASK1_MASK		GENMASK(16, 0)
+#define CDNS_MCP_SLAVE_INTMASK0_MASK		GENMASK(31, 0)
+#define CDNS_MCP_SLAVE_INTMASK1_MASK		GENMASK(15, 0)
 
 #define CDNS_MCP_PORT_INTSTAT			0x64
 #define CDNS_MCP_PDI_STAT			0x6C
-- 
2.20.1

