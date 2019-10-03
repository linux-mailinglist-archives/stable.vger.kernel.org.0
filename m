Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E6ACA32F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbfJCQNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388179AbfJCQNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:13:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B06F2054F;
        Thu,  3 Oct 2019 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119195;
        bh=9nGv8GP1WGb+HJj7APrzz5eL3Z92PFIFl4Q0ahUFkgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDfSeIby40kjXUKc/xPruqURUGaYHtkaqtO8JwCiRGJ0oLfLjZmAoIqtkPEF3RENk
         TYVAW20pUybxlnOXgVfkqSx6OtaWedfAbmFRhxHEWLnG4ueRvkynx+5IL1dYEUEpcM
         VzUbHCNKBVNnxQjNuxHkiy5YQLuBF+4LIbbsuu5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Liang Chen <cl@rock-chips.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.14 160/185] arm64: dts: rockchip: limit clock rate of MMC controllers for RK3328
Date:   Thu,  3 Oct 2019 17:53:58 +0200
Message-Id: <20191003154515.349272868@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 03e61929c0d227ed3e1c322fc3804216ea298b7e upstream.

150MHz is a fundamental limitation of RK3328 Soc, w/o this limitation,
eMMC, for instance, will run into 200MHz clock rate in HS200 mode, which
makes the RK3328 boards not always boot properly. By adding it in
rk3328.dtsi would also obviate the worry of missing it when adding new
boards.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Cc: stable@vger.kernel.org
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Liang Chen <cl@rock-chips.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -685,6 +685,7 @@
 			 <&cru SCLK_SDMMC_DRV>, <&cru SCLK_SDMMC_SAMPLE>;
 		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
+		max-frequency = <150000000>;
 		status = "disabled";
 	};
 
@@ -696,6 +697,7 @@
 			 <&cru SCLK_SDIO_DRV>, <&cru SCLK_SDIO_SAMPLE>;
 		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
+		max-frequency = <150000000>;
 		status = "disabled";
 	};
 
@@ -707,6 +709,7 @@
 			 <&cru SCLK_EMMC_DRV>, <&cru SCLK_EMMC_SAMPLE>;
 		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
+		max-frequency = <150000000>;
 		status = "disabled";
 	};
 


