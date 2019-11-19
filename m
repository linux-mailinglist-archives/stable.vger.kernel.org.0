Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5B3101674
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbfKSFxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732008AbfKSFxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:53:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A04021783;
        Tue, 19 Nov 2019 05:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142803;
        bh=aMaEl/Y4i82mrDr4/b3sW0Sxvu7MJqdXskOmPynBcZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZwSwY2wAtcBPToJZpCdnHPfjTBX2hrdYQ0cIt5OlowrSM8j0MIVtqzY1GaNY7Jw5
         WCE7XIdILLwfup8ci1oElEBlcFa1HIww4pv6QfQkdUEXqx27AWAsK4S3QfjwbCkn6g
         /S3G0gyJHqzpThPFfNPN506ELMfDclfE/teiBy80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dietrich <marvin24@gmx.de>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 204/239] ARM: dts: paz00: fix wakeup gpio keycode
Date:   Tue, 19 Nov 2019 06:20:04 +0100
Message-Id: <20191119051336.775480628@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dietrich <marvin24@gmx.de>

[ Upstream commit ebea2a43fdafdbce918bd7e200b709d6c33b9f3b ]

The power key is controlled solely by the EC, which only tiggeres this
gpio after wakeup.
Fixes immediately return to suspend after wake from LP1.

Signed-off-by: Marc Dietrich <marvin24@gmx.de>
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-paz00.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 30436969adc0e..1b8db91277b1c 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -524,10 +524,10 @@
 	gpio-keys {
 		compatible = "gpio-keys";
 
-		power {
-			label = "Power";
+		wakeup {
+			label = "Wakeup";
 			gpios = <&gpio TEGRA_GPIO(J, 7) GPIO_ACTIVE_LOW>;
-			linux,code = <KEY_POWER>;
+			linux,code = <KEY_WAKEUP>;
 			wakeup-source;
 		};
 	};
-- 
2.20.1



