Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9031D34C74C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhC2IOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232034AbhC2ING (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E6561477;
        Mon, 29 Mar 2021 08:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005585;
        bh=+zP0ABLRRc2hPhyeSSLBrxVtLxNsL4UThJPbaTza8nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S189skl+4Vcwn8S5sr/0N5rME/CgyYUFw8cqDLuWtLqkFYEIglMoyfVwPg81GhoZB
         O5mB3dhhbH453XPedAuxpsikjXek+I5jpFvRO5StUnC3qGj4UCXL5Y4Z1j2d5OfokH
         MC8gimoeOKDvnysvFBodPu3lcXVDLdGe5aDUWO9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 048/111] arm64: dts: ls1043a: mark crypto engine dma coherent
Date:   Mon, 29 Mar 2021 09:57:56 +0200
Message-Id: <20210329075616.791971442@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
@@ -241,6 +241,7 @@
 			ranges = <0x0 0x00 0x1700000 0x100000>;
 			reg = <0x00 0x1700000 0x0 0x100000>;
 			interrupts = <0 75 0x4>;
+			dma-coherent;
 
 			sec_jr0: jr@10000 {
 				compatible = "fsl,sec-v5.4-job-ring",


