Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3014B34C63C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhC2IGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231785AbhC2IFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7975E619AE;
        Mon, 29 Mar 2021 08:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005106;
        bh=cPtpdCwZKVRc8k84qWAHSiZocYWCCmPitO+YUJc2QEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nE2OhAtdmlAtay6QWvRwHMz5aLpY78GJkMwWQ/YjuFw829w+yAS0wIZwt6rDeJbW
         dEs7j8xAcqXJOZYFQF/mNGOF4WbO2VKg5By6njAGZlNOzCpnjgGR7yJ7LYuGMYKRUX
         OIivJs/X7kgNZEzHdyfRIbMNaD/Sy5F6DjkZOhjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 25/59] arm64: dts: ls1012a: mark crypto engine dma coherent
Date:   Mon, 29 Mar 2021 09:58:05 +0200
Message-Id: <20210329075609.715433564@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit ba8da03fa7dff59d9400250aebd38f94cde3cb0f upstream.

Crypto engine (CAAM) on LS1012A platform is configured HW-coherent,
mark accordingly the DT node.

Lack of "dma-coherent" property for an IP that is configured HW-coherent
can lead to problems, similar to what has been reported for LS1046A.

Cc: <stable@vger.kernel.org> # v4.12+
Fixes: 85b85c569507 ("arm64: dts: ls1012a: add crypto node")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
@@ -164,6 +164,7 @@
 			ranges = <0x0 0x00 0x1700000 0x100000>;
 			reg = <0x00 0x1700000 0x0 0x100000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			dma-coherent;
 
 			sec_jr0: jr@10000 {
 				compatible = "fsl,sec-v5.4-job-ring",


