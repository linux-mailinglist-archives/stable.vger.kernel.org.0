Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3734C699
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhC2IIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhC2IIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E7461477;
        Mon, 29 Mar 2021 08:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005290;
        bh=2puVpHFuiEsBtNgPixUzUs9VzL0ity44VWnQpojPA6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uyo3waTrTBMlflhYBgMyFHqCVgXnq/MzVu6iJ60v5nznW2BHrL338Fe1LwpBafsG1
         4QS3V7eMoHwY7T05QL4GUYdlh/qNsEtFbiK4qeOFnQtk2mBb4oGvLJBl4b+RlWsOhT
         gUOX9ozyQnQeKH8oAoQr5SiruVz8RIVVJiL452sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.19 30/72] arm64: dts: ls1043a: mark crypto engine dma coherent
Date:   Mon, 29 Mar 2021 09:58:06 +0200
Message-Id: <20210329075611.258808993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 4fb3a074755b7737c4081cffe0ccfa08c2f2d29d upstream.

Crypto engine (CAAM) on LS1043A platform is configured HW-coherent,
mark accordingly the DT node.

Lack of "dma-coherent" property for an IP that is configured HW-coherent
can lead to problems, similar to what has been reported for LS1046A.

Cc: <stable@vger.kernel.org> # v4.8+
Fixes: 63dac35b58f4 ("arm64: dts: ls1043a: add crypto node")
Link: https://lore.kernel.org/linux-crypto/fe6faa24-d8f7-d18f-adfa-44fa0caa1598@arm.com
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi
@@ -237,6 +237,7 @@
 			ranges = <0x0 0x00 0x1700000 0x100000>;
 			reg = <0x00 0x1700000 0x0 0x100000>;
 			interrupts = <0 75 0x4>;
+			dma-coherent;
 
 			sec_jr0: jr@10000 {
 				compatible = "fsl,sec-v5.4-job-ring",


