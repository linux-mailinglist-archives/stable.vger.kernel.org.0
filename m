Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C361E145653
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgAVN0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbgAVN0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:05 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D2F2467B;
        Wed, 22 Jan 2020 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699564;
        bh=1F2zi7pq1RSBl+NUKdEC8uEGfqm9GnKVSvaEqmsslZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hzvn/HiF4fqin8sUltqjnQAKIe1hcm/o4QLMSB1Lcp4jDXp05gMx6X7+4y5QBm0je
         dc2wDUvOAxRbK7t2343hen4vpVJ4pF3o5RBupLKTiU/5AxXBnnD4plM+qxhBW/MmZk
         tagmM3o89aOPPPx6HWUyXL+tPo3wcWWRfQvQ1nIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.4 180/222] arm64: dts: marvell: Add AP806-dual missing CPU clocks
Date:   Wed, 22 Jan 2020 10:29:26 +0100
Message-Id: <20200122092846.580105305@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit e231c6d47cca4b5df51bcf72dec1af767e63feaf upstream.

CPU clocks have been added to AP806-quad but not to the -dual
variant.

Fixes: c00bc38354cf ("arm64: dts: marvell: Add cpu clock node on Armada 7K/8K")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi
@@ -21,6 +21,7 @@
 			reg = <0x000>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
+			clocks = <&cpu_clk 0>;
 		};
 		cpu1: cpu@1 {
 			device_type = "cpu";
@@ -28,6 +29,7 @@
 			reg = <0x001>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
+			clocks = <&cpu_clk 0>;
 		};
 	};
 };


