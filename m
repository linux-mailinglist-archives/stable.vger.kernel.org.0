Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2268C3137BA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhBHP3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233781AbhBHPZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBBD364F15;
        Mon,  8 Feb 2021 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797312;
        bh=ENr10oo4+echbZs6T0K0LX0onPBQjQdwBvim5b1/xLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlslHvW5G53DW4lwFXQFat0J7ZO3/uh+w8k6f9mp6Zh+Q1FlfX9K4RigWXQEqwwms
         WSBzzpxqcejh3yk0cJtvXk7tB5mFAbjIS7cdbbirzIZRb541Cv5WVZDYSs0xNNtoYF
         KqUaO2J9gFXFagwVwFB5Zn59InaNir+bWfsEt130=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zyta Szpak <zr@semihalf.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/120] arm64: dts: ls1046a: fix dcfg address range
Date:   Mon,  8 Feb 2021 16:00:21 +0100
Message-Id: <20210208145819.754921766@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zyta Szpak <zr@semihalf.com>

[ Upstream commit aa880c6f3ee6dbd0d5ab02026a514ff8ea0a3328 ]

Dcfg was overlapping with clockgen address space which resulted
in failure in memory allocation for dcfg. According regs description
dcfg size should not be bigger than 4KB.

Signed-off-by: Zyta Szpak <zr@semihalf.com>
Fixes: 8126d88162a5 ("arm64: dts: add QorIQ LS1046A SoC support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 1fa39bacff4b3..0b4545012d43e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -385,7 +385,7 @@
 
 		dcfg: dcfg@1ee0000 {
 			compatible = "fsl,ls1046a-dcfg", "syscon";
-			reg = <0x0 0x1ee0000 0x0 0x10000>;
+			reg = <0x0 0x1ee0000 0x0 0x1000>;
 			big-endian;
 		};
 
-- 
2.27.0



