Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44FAD161F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbfJIR1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732338AbfJIRY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:29 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA2420B7C;
        Wed,  9 Oct 2019 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641868;
        bh=qfCF2CBKHLavLO5gpk2z0LNY6BLuAcfk78Lkz8xYQFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOkMSEgbYh/sh4zlUwZS9QYxUQq8Hfo5Z/1L2mcAMt+uFPp0iqy5IZzve2gwWN/zf
         WnB8t/QnkfQ54Z6mBVuuYvlMvZVHnFRFgjbMgqBuELX5/nUwzwMqOcIl2Z8NAK1vvl
         AWysbGe4Rqj+nccueSWQRnboYjPGCCzudcj2U8JE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 11/21] MIPS: dts: ar9331: fix interrupt-controller size
Date:   Wed,  9 Oct 2019 13:06:04 -0400
Message-Id: <20191009170615.32750-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170615.32750-1-sashal@kernel.org>
References: <20191009170615.32750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0889d07f3e4b171c453b2aaf2b257f9074cdf624 ]

It is two registers each of 4 byte.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/qca/ar9331.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/qca/ar9331.dtsi b/arch/mips/boot/dts/qca/ar9331.dtsi
index efd5f07222060..39b6269610d41 100644
--- a/arch/mips/boot/dts/qca/ar9331.dtsi
+++ b/arch/mips/boot/dts/qca/ar9331.dtsi
@@ -99,7 +99,7 @@
 
 			miscintc: interrupt-controller@18060010 {
 				compatible = "qca,ar7240-misc-intc";
-				reg = <0x18060010 0x4>;
+				reg = <0x18060010 0x8>;
 
 				interrupt-parent = <&cpuintc>;
 				interrupts = <6>;
-- 
2.20.1

