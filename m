Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFF31454FF
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAVNSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:01 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BEA020678;
        Wed, 22 Jan 2020 13:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699080;
        bh=Tv5VPWmDajiGPiRyV5i0B5GdSfT+JFgoH0S4oLjldbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT6OJ7K2FKqzjD4WFfwo1bLj0VG0MjVQcs9BJQhNp0sxn0aRCH27cRUAIx4fsWMWf
         voib7P6zCO7GK9aKDPUvAkWu4vG7A3iVFEhAdILhnKSSYM4N0BJCthowBYaB3XfYUb
         63w1nX0A90Ns0or8MrTO3em81wPwarDR6ahReD5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 007/222] arm64: dts: ls1028a: fix endian setting for dcfg
Date:   Wed, 22 Jan 2020 10:26:33 +0100
Message-Id: <20200122092833.889112687@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinbo Zhu <yinbo.zhu@nxp.com>

commit 33eae7fb2e593fdbaac15d843e2558379c6d1149 upstream.

DCFG block uses little endian.  Fix it so that register access becomes
correct.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Yangbo Lu <yangbo.lu@nxp.com>
Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -158,7 +158,7 @@
 		dcfg: syscon@1e00000 {
 			compatible = "fsl,ls1028a-dcfg", "syscon";
 			reg = <0x0 0x1e00000 0x0 0x10000>;
-			big-endian;
+			little-endian;
 		};
 
 		rst: syscon@1e60000 {


