Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D099C6C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392389AbfHVRdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404450AbfHVRZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:36 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3978C2341E;
        Thu, 22 Aug 2019 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494735;
        bh=8y6LThwS1iDw3wBEKn53hyWVhA31tU2OGD4DW8G0fX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTWLhetXD3/t3Bcwmf3YVzmOY7LZsc3twNT91e6WgufTu8OIoba9Phyz42+8TxTBU
         ywf29F1UKTzCY1pCOBqo7+OQdTwAgSvpaisRF1rgs1ovBdVJMkqHSe5v+HwSRVaLQ8
         fQtpDH6clemLAhGrdebIW6MsbmEFAiU0ZWEyIKB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/85] clk: sprd: Select REGMAP_MMIO to avoid compile errors
Date:   Thu, 22 Aug 2019 10:19:00 -0700
Message-Id: <20190822171732.337800878@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c9a67cbb5189e966c70451562b2ca4c3876ab546 ]

Make REGMAP_MMIO selected to avoid undefined reference to regmap symbols.

Fixes: d41f59fd92f2 ("clk: sprd: Add common infrastructure")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/sprd/Kconfig b/drivers/clk/sprd/Kconfig
index 87892471eb96c..bad8099832d48 100644
--- a/drivers/clk/sprd/Kconfig
+++ b/drivers/clk/sprd/Kconfig
@@ -2,6 +2,7 @@ config SPRD_COMMON_CLK
 	tristate "Clock support for Spreadtrum SoCs"
 	depends on ARCH_SPRD || COMPILE_TEST
 	default ARCH_SPRD
+	select REGMAP_MMIO
 
 if SPRD_COMMON_CLK
 
-- 
2.20.1



