Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0FC409474
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbhIMObW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345104AbhIMO3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E52361361;
        Mon, 13 Sep 2021 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541027;
        bh=twOMXZktG8V7/Fr8eLHC4z84Z+gJSE45nP4rVSlH0B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDicVEZ1hJHAV0b5o/Ao9YDxxRLjgzHMDWQOiAxFIHRU3oTpH1YC+2Prw+Tbu2Mtm
         Dvd+O9wUzQ58JoC92zGcK9h62uaxGClxuA89+meslJIEffTL5raJmbojn8hACe0GUe
         UGmhvfRV4cOgYB+wUVMblq/qP7nADF9GsyxdKjjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 099/334] ARM: dts: everest: Add phase corrections for eMMC
Date:   Mon, 13 Sep 2021 15:12:33 +0200
Message-Id: <20210913131116.721604541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

[ Upstream commit ded3e2864c735f33ba5abbbe2d7b1c6605242f9b ]

The values were determined via scope measurements.

With the patch we can write and read data without issue where as booting
the system without the patch failed at the point of mounting the rootfs.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20210712233642.3119722-1-andrew@aj.id.au
Fixes: faffd1b2bde3 ("ARM: dts: everest: Add phase corrections for eMMC")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index aa24cac8e5be..44b03a5e2416 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -2832,7 +2832,7 @@
 
 &emmc {
 	status = "okay";
-	clk-phase-mmc-hs200 = <180>, <180>;
+	clk-phase-mmc-hs200 = <210>, <228>;
 };
 
 &fsim0 {
-- 
2.30.2



