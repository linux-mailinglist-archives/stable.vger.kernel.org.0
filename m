Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B5113501
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfLDR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbfLDR5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:31 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39722081B;
        Wed,  4 Dec 2019 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482251;
        bh=2pvz7k7ks7n8vDwaO2xAszVgOitfYuzPzhsoGkM5liE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWCOBEy3cFWTAAdIJfp7XphLxsUCpC4E1IaaLuxUQ1Zt9+DBWiS/UGMOEAg3yQDeX
         uBL1Qg8ybgm8RjjkJlUhYbP/3c19whbXsKd7JlFSpebmAs79pEhIrtoZB6BrgpJNlU
         YHyH4fpnXPh3K+aVlxbvxJP7y8FT+O75RNCIRRGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/92] reset: fix reset_control_ops kerneldoc comment
Date:   Wed,  4 Dec 2019 18:49:04 +0100
Message-Id: <20191204174328.643568539@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
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
index ce6b962ffed43..842f70fcfc486 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -6,7 +6,7 @@
 struct reset_controller_dev;
 
 /**
- * struct reset_control_ops
+ * struct reset_control_ops - reset controller driver callbacks
  *
  * @reset: for self-deasserting resets, does all necessary
  *         things to reset the device
-- 
2.20.1



