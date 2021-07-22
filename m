Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970A63D2A5A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhGVQK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235234AbhGVQIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DC7561DB0;
        Thu, 22 Jul 2021 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972518;
        bh=3u9vpWa25zjBxq5IidMDYt9eUPZhUvlec/IPMhDqFts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjKzm9Hhn7UItPyp641jpKtbCCTjjXn9MsQIYjXRbfeKMgeZbvuNACLb1Sxm6h5Lx
         1wC9CUAtDKUUnqO3/xllibfltZElKl9hqwD588FbMkvDugTAEFN0uAjjjjJWzeohtG
         w1zc3wo4s00mQSM57618b2Xe+FtBUNKdZTQecg+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.13 142/156] ARM: dts: everest: Add phase corrections for eMMC
Date:   Thu, 22 Jul 2021 18:31:57 +0200
Message-Id: <20210722155632.939875101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>

commit faffd1b2bde3ee428d6891961f6a60f8e08749d6 upstream.

The values were determined experimentally via boot tests, not by
measuring the bus behaviour with a scope. We plan to do scope
measurements to confirm or refine the values and will update the
devicetree if necessary once these have been obtained.

However, with the patch we can write and read data without issue, where
as booting the system without the patch failed at the point of mounting
the rootfs.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20210628013605.1257346-1-andrew@aj.id.au
Fixes: 2fc88f92359d ("mmc: sdhci-of-aspeed: Expose clock phase controls")
Fixes: a5c5168478d7 ("ARM: dts: aspeed: Add Everest BMC machine")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -1068,6 +1068,7 @@
 
 &emmc {
 	status = "okay";
+	clk-phase-mmc-hs200 = <180>, <180>;
 };
 
 &fsim0 {


