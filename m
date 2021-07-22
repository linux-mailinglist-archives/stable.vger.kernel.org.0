Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1A3D29A5
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhGVQFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233484AbhGVQDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E68B61CA2;
        Thu, 22 Jul 2021 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972249;
        bh=jx/1t1Iq8e7GUNGcJw2QIdaffisGdgNPqkBjVcZL53w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPmgLezhTQLr6zE1a3NteJzDbxd6roMnY0nmiMPJ6QZLRpidTQssjhrGl/+NjjSXj
         O9ZfcV2p8jCKCuem1PDgIqQJfsGy6lhHXh0g3B1ei8NVeBS7c1mj8Uhjogu/j0fE3p
         2zW5mQziQ3dT/kFlLQfWLtdgI8mDUnAnzNbsakHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/156] arm64: dts: ti: k3-am654x/j721e/j7200-common-proc-board: Fix MCU_RGMII1_TXC direction
Date:   Thu, 22 Jul 2021 18:30:18 +0200
Message-Id: <20210722155629.806356008@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 69db725cdb2b803af67897a08ea54467d11f6020 ]

The MCU RGMII MCU_RGMII1_TXC pin is defined as input by mistake, although
this does not make any difference functionality wise it's better to update
to avoid confusion.

Hence fix MCU RGMII MCU_RGMII1_TXC pin pinmux definitions to be an output
in K3 am654x/j721e/j7200 board files.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210526132041.6104-1-grygorii.strashko@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts        | 2 +-
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts | 2 +-
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
index 1b947e2c2e74..faa8e280cf2b 100644
--- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
@@ -136,7 +136,7 @@
 			AM65X_WKUP_IOPAD(0x007c, PIN_INPUT, 0) /* (L5) MCU_RGMII1_RD2 */
 			AM65X_WKUP_IOPAD(0x0080, PIN_INPUT, 0) /* (M6) MCU_RGMII1_RD1 */
 			AM65X_WKUP_IOPAD(0x0084, PIN_INPUT, 0) /* (L6) MCU_RGMII1_RD0 */
-			AM65X_WKUP_IOPAD(0x0070, PIN_INPUT, 0) /* (N1) MCU_RGMII1_TXC */
+			AM65X_WKUP_IOPAD(0x0070, PIN_OUTPUT, 0) /* (N1) MCU_RGMII1_TXC */
 			AM65X_WKUP_IOPAD(0x0074, PIN_INPUT, 0) /* (M1) MCU_RGMII1_RXC */
 		>;
 	};
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
index bedd01b7a32c..d14f3c18b65f 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -90,7 +90,7 @@
 			J721E_WKUP_IOPAD(0x008c, PIN_INPUT, 0) /* MCU_RGMII1_RD2 */
 			J721E_WKUP_IOPAD(0x0090, PIN_INPUT, 0) /* MCU_RGMII1_RD1 */
 			J721E_WKUP_IOPAD(0x0094, PIN_INPUT, 0) /* MCU_RGMII1_RD0 */
-			J721E_WKUP_IOPAD(0x0080, PIN_INPUT, 0) /* MCU_RGMII1_TXC */
+			J721E_WKUP_IOPAD(0x0080, PIN_OUTPUT, 0) /* MCU_RGMII1_TXC */
 			J721E_WKUP_IOPAD(0x0084, PIN_INPUT, 0) /* MCU_RGMII1_RXC */
 		>;
 	};
diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index ffccbc53f1e7..de3c3f7f2b7a 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -238,7 +238,7 @@
 			J721E_WKUP_IOPAD(0x007c, PIN_INPUT, 0) /* MCU_RGMII1_RD2 */
 			J721E_WKUP_IOPAD(0x0080, PIN_INPUT, 0) /* MCU_RGMII1_RD1 */
 			J721E_WKUP_IOPAD(0x0084, PIN_INPUT, 0) /* MCU_RGMII1_RD0 */
-			J721E_WKUP_IOPAD(0x0070, PIN_INPUT, 0) /* MCU_RGMII1_TXC */
+			J721E_WKUP_IOPAD(0x0070, PIN_OUTPUT, 0) /* MCU_RGMII1_TXC */
 			J721E_WKUP_IOPAD(0x0074, PIN_INPUT, 0) /* MCU_RGMII1_RXC */
 		>;
 	};
-- 
2.30.2



