Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6015E20DFD2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbgF2UkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731714AbgF2UkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 16:40:01 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA9D920724;
        Mon, 29 Jun 2020 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593463201;
        bh=VHaWWzDFtJkhJiWEwI8eDTH4AO8AA2VEFRChzPwKg6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiDA0Uh2ciIB440llF+JBrfX9Kin0MN2AbTjIFWqx7GqfnCVzpquQ0J1xwUH07TO8
         zrupfHUtgm+N4p1jLzQB/F71bdVgk/BgR1+NP7PJdXZFlgpdBR92EqWQTSNdoL3SAf
         G+M6HAbOUNV6hwQRqIOtpCazuF4drAe14cOXxUWQ=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     dinguyen@kernel.org, devicetree@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] arm64: dts: stratix10: add status to qspi dts node
Date:   Mon, 29 Jun 2020 15:39:48 -0500
Message-Id: <20200629203949.6601-2-dinguyen@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629203949.6601-1-dinguyen@kernel.org>
References: <20200629203949.6601-1-dinguyen@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add status = "okay" to QSPI node.

Fixes: 0cb140d07fc75 ("arm64: dts: stratix10: Add QSPI support for
Stratix10")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.6
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts      | 1 +
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index f6c4a15079d3..feadd21bc0dc 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -155,6 +155,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
index 9946515b8afd..4000c393243d 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -188,6 +188,7 @@
 };
 
 &qspi {
+	status = "okay";
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.17.1

