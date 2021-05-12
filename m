Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063F37C4CD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhELPd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235689AbhELP2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FC5C61C2C;
        Wed, 12 May 2021 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832476;
        bh=jBAmgW0M8eG1kt+B57Fl1YFYwztiG5+6w9uRTB0xKb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2JWNVZRMRtqeQ79EMFGezYA3BLlY+vnGoVSuHx2gpqDk/YZjIev/QAr/HHGR/JHN
         DkQZtC18I5K/B9COaGgPaKZlP83jM8aUPgF715qoAgsYOW7GQPFmtCXVqVEcbVI9Ko
         q+kvlI2SUsyhPzJwWjFSzqs5tPJwNV/FLuYoc3Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/530] ARM: dts: aspeed: Rainier: Fix humidity sensor bus address
Date:   Wed, 12 May 2021 16:46:10 +0200
Message-Id: <20210512144828.377185447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 1d5d46a1adafafce2b0c9105eab563709c84e3db ]

The si7021 was incorrectly placed at 0x20 on i2c bus 7. It is at 0x40.

Fixes: 9c44db7096e0 ("ARM: dts: aspeed: rainier: Add i2c devices")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index 21ae880c7530..c76b0046b402 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -707,9 +707,9 @@
 	multi-master;
 	status = "okay";
 
-	si7021-a20@20 {
+	si7021-a20@40 {
 		compatible = "silabs,si7020";
-		reg = <0x20>;
+		reg = <0x40>;
 	};
 
 	tmp275@48 {
-- 
2.30.2



