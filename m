Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A582B5FF6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgKQM5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgKQM47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:56:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F6C2464E;
        Tue, 17 Nov 2020 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617818;
        bh=rHyctRfZhyusAX1YcbUnm/XQFHRH3I2TLqDIyDvESXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ9oRJmn/d/AusZnChx97giQLcDzQ+771nzHzIhE8l8Kyn+Dgu+A0IvZj/N7zY+m8
         DDxOar+X9p7IsFf9t7L3EFETgT64mhW39z4IkqH7ZfsJHC9Vg2C6zJlYUxDdjhy7Dx
         5qDIZ6Arw5zlrFf/u6C/V9hwH5t+X96q1BvCym0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 03/21] habanalabs/gaudi: mask WDT error in QMAN
Date:   Tue, 17 Nov 2020 07:56:34 -0500
Message-Id: <20201117125652.599614-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit f83f3a31b2972ddc907fbb286c6446dd9db6e198 ]

This interrupt cause is not relevant because of how the user use the
QMAN arbitration mechanism. We must mask it as the log explodes with it.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/include/gaudi/gaudi_masks.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
index 3510c42d24e31..b734b650fccf7 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
@@ -452,7 +452,6 @@ enum axi_id {
 
 #define QM_ARB_ERR_MSG_EN_MASK		(\
 					QM_ARB_ERR_MSG_EN_CHOISE_OVF_MASK |\
-					QM_ARB_ERR_MSG_EN_CHOISE_WDT_MASK |\
 					QM_ARB_ERR_MSG_EN_AXI_LBW_ERR_MASK)
 
 #define PCIE_AUX_FLR_CTRL_HW_CTRL_MASK                               0x1
-- 
2.27.0

