Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD4118A5BC
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgCRVDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728354AbgCRUzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4359E208DB;
        Wed, 18 Mar 2020 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564935;
        bh=JPCMMDsUwERJIXy175RNLP9ZgO/AEaV/j6hHU6P+eJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcMnpkAd0OhEiiu1ikrhCanyy9NXVDeLLd88zICCIB7PJVpCnJuBkTr8lWsqOainZ
         QNMhBW4nz9Zd5nyj/910jIBH/C0dkoceVK/8CD/mOgCHWCU0dPW/TATw4czu7EvNpg
         yAJOtPUcitZO1pnjchzorErhd+8xfdXNkIUOMEho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/37] arm64: dts: ls1043a: FMan erratum A050385
Date:   Wed, 18 Mar 2020 16:54:53 -0400
Message-Id: <20200318205509.17053-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit b54d3900862374e1bb2846e6b39d79c896c0b200 ]

The LS1043A SoC is affected by the A050385 erratum stating that
FMAN DMA read or writes under heavy traffic load may cause FMAN
internal resource leak thus stopping further packet processing.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
index 6082ae0221364..d237162a87446 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi
@@ -20,6 +20,8 @@
 };
 
 &fman0 {
+	fsl,erratum-a050385;
+
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
 	};
-- 
2.20.1

