Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C29EB2025
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389971AbfIMNRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389358AbfIMNQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:57 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A995F206A5;
        Fri, 13 Sep 2019 13:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380617;
        bh=Kqu/VrO/mpmLtoK8H3KRuX8r9I/9w5Ay0xDT+Jj7MFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShLfGJSf6LFHWDkPPYXMDV0J2hrId7HeSI5nSfC9/LkVSa5XoGZHu10foNLcOsdsg
         pZsF+9j7aQ1XSuDX0bvQgV5SPNg5l53G+NS5dYYgNFYfP+94eJ3AVWR41G6Az7LbeI
         mVPKxQr5YMaUum4gQubESiR5zyqemWT6fSqjOkGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Muellner <christoph.muellner@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/190] dt-bindings: mmc: Add disable-cqe-dcmd property.
Date:   Fri, 13 Sep 2019 14:06:18 +0100
Message-Id: <20190913130609.667502839@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



