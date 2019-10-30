Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E0EA070
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbfJ3P4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbfJ3P4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:56:36 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9B820656;
        Wed, 30 Oct 2019 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450995;
        bh=HE82Gu0srBbHPVO2IXUmKw/tid8jQwbjFCwCHNinGWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocPAesrhNudM3+hlqZWFfPIAT2Y/vOwc5Pp7SNMeosd936NbTTH0Z/GCp/ce6Uy5+
         0k/84Rh+hOq8UKJscievuU4wst7pe67O8AZ3mnRnKjKq2azjSEVFzLj8CgwCBExFXQ
         cMtvZj9QI1iEqe2PJZMC8k4aZT1E3hFTpWkBaMXU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 16/24] ARM: davinci: dm365: Fix McBSP dma_slave_map entry
Date:   Wed, 30 Oct 2019 11:55:47 -0400
Message-Id: <20191030155555.10494-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155555.10494-1-sashal@kernel.org>
References: <20191030155555.10494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 564b6bb9d42d31fc80c006658cf38940a9b99616 ]

dm365 have only single McBSP, so the device name is without .0

Fixes: 0c750e1fe481d ("ARM: davinci: dm365: Add dma_slave_map to edma")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/dm365.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 8be04ec95adf5..d80b2290ac2e0 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -856,8 +856,8 @@ static s8 dm365_queue_priority_mapping[][2] = {
 };
 
 static const struct dma_slave_map dm365_edma_map[] = {
-	{ "davinci-mcbsp.0", "tx", EDMA_FILTER_PARAM(0, 2) },
-	{ "davinci-mcbsp.0", "rx", EDMA_FILTER_PARAM(0, 3) },
+	{ "davinci-mcbsp", "tx", EDMA_FILTER_PARAM(0, 2) },
+	{ "davinci-mcbsp", "rx", EDMA_FILTER_PARAM(0, 3) },
 	{ "davinci_voicecodec", "tx", EDMA_FILTER_PARAM(0, 2) },
 	{ "davinci_voicecodec", "rx", EDMA_FILTER_PARAM(0, 3) },
 	{ "spi_davinci.2", "tx", EDMA_FILTER_PARAM(0, 10) },
-- 
2.20.1

