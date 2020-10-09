Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B417288330
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgJIHFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:05:24 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:36878 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgJIHFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:05:24 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 09975HT7020437; Fri, 9 Oct 2020 16:05:18 +0900
X-Iguazu-Qid: 34trqomzZ2LL9WyQWa
X-Iguazu-QSIG: v=2; s=0; t=1602227117; q=34trqomzZ2LL9WyQWa; m=SlPfDZcGjaSlRM13ke347cxtICRNFpb9NtNEu+CxrZU=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1513) id 09975H6W013266;
        Fri, 9 Oct 2020 16:05:17 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 09975HhT007325;
        Fri, 9 Oct 2020 16:05:17 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 09975EZ7021908;
        Fri, 9 Oct 2020 16:05:16 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.19, 5.4] arm64: dts: stratix10: add status to qspi dts node
Date:   Fri,  9 Oct 2020 16:05:06 +0900
X-TSB-HOP: ON
Message-Id: <20201009070506.549956-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 263a0269a59c0b4145829462a107fe7f7327105f upstream.

Add status = "okay" to QSPI node.

Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
[iwamatsu: Drop arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index 66e4ffb4e929d2..2c8c2b322c727e 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -155,6 +155,7 @@
 };

 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
--
2.28.0

