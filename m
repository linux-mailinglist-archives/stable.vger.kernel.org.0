Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644F46C749
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbfGRDHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390423AbfGRDHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:07:23 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90881205F4;
        Thu, 18 Jul 2019 03:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419242;
        bh=X0M2v2sf0ofblhQb50767Ec2ORYCSlxb5bG2R5CIYzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XR5lSUzOHlxL53PMGBdVs+ymWvjuOmjJjjdY+T3GpMhvdL5X9eb5Tj0E61inNEgrS
         3nCsf/db+qSTDtsP1tjZj2z4kRVOlbGNN+JHQmGZZE4aXnTRX/15FsnkhKPILz7bGP
         kFNDP7+SF7Sv9/4HSE3F7F8C18JfPl78k+11S2RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/47] ARM: dts: gemini Fix up DNS-313 compatible string
Date:   Thu, 18 Jul 2019 12:01:25 +0900
Message-Id: <20190718030049.557496896@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 36558020128b1a48b7bddd5792ee70e3f64b04b0 ]

It's a simple typo in the DNS file, which was pretty serious.
No scripts were working properly. Fix it up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-dlink-dns-313.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dns-313.dts b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
index d1329322b968..361dccd6c7ee 100644
--- a/arch/arm/boot/dts/gemini-dlink-dns-313.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "D-Link DNS-313 1-Bay Network Storage Enclosure";
-	compatible = "dlink,dir-313", "cortina,gemini";
+	compatible = "dlink,dns-313", "cortina,gemini";
 	#address-cells = <1>;
 	#size-cells = <1>;
 
-- 
2.20.1



