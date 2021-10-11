Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC2D429098
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhJKOK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239625AbhJKOIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99DE61222;
        Mon, 11 Oct 2021 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960878;
        bh=Hf2n9xfbqFkxvyar5vNGFeR2VXs0Bc4gXJF2VAyjc10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjmL5IFZAX7f9Tj3EkNIj1SBQMsqSPWQDCMtLYsA7hPLBp5TXGFE6MF0yC+0Drzqo
         ZwJ3+GLIgSD6+Kuvf50MUT1IN5QP2g5cgietguRaqgJylbnHQx7WOyJwSdc/neM1w7
         Ej4cgYtw7dPw5/CayF7iC7ya3mcx7Cb+GDM7Kd0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Scott Wood <oss@buserror.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 074/151] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Date:   Mon, 11 Oct 2021 15:45:46 +0200
Message-Id: <20211011134520.246866595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit eed183abc0d3b8adb64fd1363b7cea7986cd58d6 ]

Property phy-connection-type contains invalid value "sgmii-2500" per scheme
defined in file ethernet-controller.yaml.

Correct phy-connection-type value should be "2500base-x".

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the board device tree(s)")
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
index 5ba6fbfca274..f82f85c65964 100644
--- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
@@ -154,7 +154,7 @@
 
 			fm1mac3: ethernet@e4000 {
 				phy-handle = <&sgmii_aqr_phy3>;
-				phy-connection-type = "sgmii-2500";
+				phy-connection-type = "2500base-x";
 				sleep = <&rcpm 0x20000000>;
 			};
 
-- 
2.33.0



