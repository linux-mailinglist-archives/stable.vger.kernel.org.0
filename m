Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35C37CC65
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhELQor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242029AbhELQbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF5C361A36;
        Wed, 12 May 2021 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835085;
        bh=Os5tOKqe2SUe42EtNQWjyiSOfJ5/YIBz8/jUfIGQy8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4p5afGhGbD3hKV9VDYhIjw8e225kDPR4Sak604KyJ92ZjL5xb/gWBwasPIORKK56
         u1yBCTMo682eWNi/gKoWuqnN8H0WdazsULhuo/kq/G3QOQM1XP1I1bZmAt27IQ6JbL
         CzQJGz8mg5Rf9sz5yfA0wF3JfhSgP/iKVcUjtsho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 203/677] arm64: dts: broadcom: bcm4908: set Asus GT-AC5300 port 7 PHY mode
Date:   Wed, 12 May 2021 16:44:09 +0200
Message-Id: <20210512144843.992707936@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 5ccb9f9cf05bbd729430c6d6d30d40c96a15c56a ]

Port 7 is connected to the external BCM53134S switch using RGMII.

Fixes: 527a3ac9bdf8 ("arm64: dts: broadcom: bcm4908: describe internal switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts
index 6e4ad66ff536..8d5d368dbe90 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts
@@ -65,6 +65,7 @@
 	port@7 {
 		label = "sw";
 		reg = <7>;
+		phy-mode = "rgmii";
 
 		fixed-link {
 			speed = <1000>;
-- 
2.30.2



