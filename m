Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759E72C07B5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbgKWMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbgKWMnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840572078E;
        Mon, 23 Nov 2020 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135402;
        bh=rHyctRfZhyusAX1YcbUnm/XQFHRH3I2TLqDIyDvESXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuBUzg8UZ2V4AajCUCKaJaoElhXxdnSt34hJY5pbWABsG7w5DMFGehh0Wb7gcrBN1
         aA3aHJ7HlWSsHX6LUH3k8noYMQ1+xvnmrXuWU+asaagCCsFBirBBNU2eLT11Qt3K+n
         KRhWD9fwG6txqOf6i6RH2/ZrPfF1Hpl1xxt1U5E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 056/252] habanalabs/gaudi: mask WDT error in QMAN
Date:   Mon, 23 Nov 2020 13:20:06 +0100
Message-Id: <20201123121838.295017374@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



