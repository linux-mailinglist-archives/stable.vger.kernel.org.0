Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6046AA6F74
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbfICQ2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731065AbfICQ2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A59F23878;
        Tue,  3 Sep 2019 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528093;
        bh=xU+nruY6QlSv28Q++5C1PZ0BWWkDc0iYhQct2wtmjiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnH4gY9i4wOdu0jcElWmRYxmLzqPHF5fMnO+qfyGPZchB6xfY4RPYj93ZvgiAfGj6
         u71i0XMKLA2oSS/aEVw4cLuqq3zLmkI8XPf+Hlgmoa/AJy+ZFQ1ptfuRiWko+BggDW
         t/CW9fBxMEp/Vp40H2zjvzwuU9hbH5gAMjnsdiEw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Muellner <christoph.muellner@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/167] dt-bindings: mmc: Add disable-cqe-dcmd property.
Date:   Tue,  3 Sep 2019 12:24:14 -0400
Message-Id: <20190903162519.7136-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Muellner <christoph.muellner@theobroma-systems.com>

[ Upstream commit 28f22fb755ecf9f933f045bc0afdb8140641b01c ]

Add disable-cqe-dcmd as optional property for MMC hosts.
This property allows to disable or not enable the direct command
features of the command queue engine.

Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Signed-off-by: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index cdbcfd3a4ff21..c269dbe384fea 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -64,6 +64,8 @@ Optional properties:
   whether pwrseq-simple is used. Default to 10ms if no available.
 - supports-cqe : The presence of this property indicates that the corresponding
   MMC host controller supports HW command queue feature.
+- disable-cqe-dcmd: This property indicates that the MMC controller's command
+  queue engine (CQE) does not support direct commands (DCMDs).
 
 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"
-- 
2.20.1

