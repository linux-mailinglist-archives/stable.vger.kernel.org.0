Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E30EA001
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfJ3Pwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbfJ3Pwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:52:41 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C7320656;
        Wed, 30 Oct 2019 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450761;
        bh=NiLmu7S3WOmZnESuvykKVnjTskYiKGz3RvrEO3masJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUsVIPkyaJl4YP5JCVLCAR3I6S3jY6YV1EMNiz7OZn0VdK3AlibiHu2R6nzl+hGer
         t+4ORdk1TlFGi2J9rxlUHK5NUh21susKgEHIHp12+gaKtu5oae9i1SyqmIs8cfLXJ5
         aI7FDjkKbYc6mGBVgQSqxEqKwbqKPs99Zx8tuw3I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 44/81] ARM: dts: imx6q-logicpd: Re-Enable SNVS power key
Date:   Wed, 30 Oct 2019 11:48:50 -0400
Message-Id: <20191030154928.9432-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 52f4d4043d1edc4e9e66ec79cae3e32cfe0e44d6 ]

A previous patch disabled the SNVS power key by default which
breaks the ability for the imx6q-logicpd board to wake from sleep.
This patch re-enables this feature for this board.

Fixes: 770856f0da5d ("ARM: dts: imx6qdl: Enable SNVS power key according to board design")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6-logicpd-som.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6-logicpd-som.dtsi b/arch/arm/boot/dts/imx6-logicpd-som.dtsi
index 7ceae35732486..547fb141ec0c9 100644
--- a/arch/arm/boot/dts/imx6-logicpd-som.dtsi
+++ b/arch/arm/boot/dts/imx6-logicpd-som.dtsi
@@ -207,6 +207,10 @@
 	vin-supply = <&sw1c_reg>;
 };
 
+&snvs_poweroff {
+	status = "okay";
+};
+
 &iomuxc {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_hog>;
-- 
2.20.1

