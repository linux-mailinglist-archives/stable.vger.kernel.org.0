Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8671483A7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgAXLhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404386AbgAXLcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F49120718;
        Fri, 24 Jan 2020 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865521;
        bh=vqhb0ybn2UXmVxsoONoc0XgFue24dWCp3CZJtDvflRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tz2TX0nj2eeAJ3GxGIDqv4hws/yGq+6j9AHfTHBGyfuUfkRsTvfjoAAh4FHK8CIvz
         N6qGbE2vG9lIicK4EELwJgc9mZmMmZgUvKj5PsgsoexMP/s3+2L0n88v3f64A0W5y/
         ylcsFBBNeYLcfho0M01Jfb4aq/uvoX2h3urdlXvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 568/639] mailbox: qcom-apcs: fix max_register value
Date:   Fri, 24 Jan 2020 10:32:18 +0100
Message-Id: <20200124093200.517407020@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

[ Upstream commit 556a0964e28c4441dcdd50fb07596fd042246bd5 ]

The mailbox length is 0x1000 hence the max_register value is 0xFFC.

Fixes: c6a8b171ca8e ("mailbox: qcom: Convert APCS IPC driver to use
regmap")
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-apcs-ipc-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-apcs-ipc-mailbox.c b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
index 5255dcb551a78..d8b4f08f613b2 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -36,7 +36,7 @@ static const struct regmap_config apcs_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = 0x1000,
+	.max_register = 0xFFC,
 	.fast_io = true,
 };
 
-- 
2.20.1



