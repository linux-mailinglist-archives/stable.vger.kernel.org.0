Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC6C101789
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfKSFmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfKSFmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF00121939;
        Tue, 19 Nov 2019 05:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142144;
        bh=X7NG4wmYTuoVYks3yIU/4gmZJ3ruY5WnIP5G6l/juW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMikNVdhCpzDoNLDwRl6OdFN8aRs6bz4EYYfFVgDoFN+Y5dUgvwNDS7FfT43CnU+1
         MSYKdflRiN461SuIQhj+/5AkiQu91EK0Qx3UKp+iY/gGZ7FihamuyCh/D+QwItb9k+
         +j0s+5wYXtdcYN2atrLN3wrx5xw7TiCJpJNjAeuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 353/422] slimbus: ngd: return proper error code instead of zero
Date:   Tue, 19 Nov 2019 06:19:10 +0100
Message-Id: <20191119051421.892624663@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 9652e6aa62a1836494ebb8dbd402587c083b568c ]

It looks like there is a typo in probe return. Fix it.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index a9abde2f4088b..e587be9064e74 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1393,7 +1393,7 @@ wq_err:
 	if (ctrl->mwq)
 		destroy_workqueue(ctrl->mwq);
 
-	return 0;
+	return ret;
 }
 
 static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
-- 
2.20.1



