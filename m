Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FFCA8F44
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbfIDSCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388422AbfIDSCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:02:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0B522CF5;
        Wed,  4 Sep 2019 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620163;
        bh=IRnDFMFoLiFLP/Eybumclhwuki5Ux8C0dWpNaSumgJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlVQSHl3l8sPTSyaaqMM/pXLpmDtXNG4Ilrhyu28dUujhtENO7yuui5+b+Bn2lg21
         C4KGvgA5tESyhC51bsBqYDKos0wkVxRqcYMQQVVxw7lLfF+AKFhnb02h4qTKEdySxX
         z0rDiIiQZ5xZagfUkr5KZZnBOgfmUc39N8W+7xB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pedro Sousa <sousa@synopsys.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/57] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
Date:   Wed,  4 Sep 2019 19:53:42 +0200
Message-Id: <20190904175303.327466376@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ebcb8f8508c5edf428f52525cec74d28edea7bcb ]

Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
according to MIPI Alliance MPHY specification.

Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
Signed-off-by: Pedro Sousa <sousa@synopsys.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/unipro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 23129d7b2678d..c77e365264478 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -52,7 +52,7 @@
 #define RX_HS_UNTERMINATED_ENABLE		0x00A6
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
-#define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_TERMINATION_FORCE_ENABLE		0x00A9
 #define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
 #define RX_HIBERN8TIME_CAPABILITY		0x0092
 #define RX_REFCLKFREQ				0x00EB
-- 
2.20.1



