Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328A8111F34
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfLCWpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbfLCWpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060CF2073C;
        Tue,  3 Dec 2019 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413133;
        bh=CFbyICVMg0BGL5eCOv0DJz8yDGSEwWUHhTT7v4gPrhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+5pc2nSFr7HYmQWPa7SDK8wU87nDfhdHHHUs0thBlWUkBpa30C+87rQkMkoHjkGH
         VJmY6dQ2qpWOGE5foSbQIGpVQwHP34p/h7eQC4ysRkgMNhUvAwlxW/bThbr/Iz5r70
         CkvOmruZQsEEWl6hLN+oa4aR9fE6k9m2Kr2MPKi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/321] reset: fix reset_control_ops kerneldoc comment
Date:   Tue,  3 Dec 2019 23:31:18 +0100
Message-Id: <20191203223427.758333833@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f430c7ed8bc22992ed528b518da465b060b9223f ]

Add a missing short description to the reset_control_ops documentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
[p.zabel@pengutronix.de: rebased and updated commit message]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/reset-controller.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index 9326d671b6e6c..8675ec64987bb 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -7,7 +7,7 @@
 struct reset_controller_dev;
 
 /**
- * struct reset_control_ops
+ * struct reset_control_ops - reset controller driver callbacks
  *
  * @reset: for self-deasserting resets, does all necessary
  *         things to reset the device
-- 
2.20.1



