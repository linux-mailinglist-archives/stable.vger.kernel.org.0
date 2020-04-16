Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E62D1AC292
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896095AbgDPN3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896093AbgDPN3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:29:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2848821D91;
        Thu, 16 Apr 2020 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043790;
        bh=rXkh2aRrbIIG14idHHtgzlWycyi8V8ynYJ10c0RNDbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ov3kO5HRcjAJg3s9dXN8SFZ+UYtYVsIb+XuvUBv+q2WJpOWffKXY3kq2H3XzOAHU
         CnenPiZnyc2DhLVEp7nJAeBIbWSmLqauFTKj4W39qnie6bnuaGqgybhI65bJMx6mdM
         ojyt5sbO2fUa3IYaP2c0HnPkjoTTFDcV/PGd3iIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 101/146] arm64: dts: allwinner: h6: Fix PMU compatible
Date:   Thu, 16 Apr 2020 15:24:02 +0200
Message-Id: <20200416131256.549627724@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 4c7eeb9af3e41ae7d840977119c58f3bbb3f4f59 upstream.

The commit 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
introduced support for the PMU found on the Allwinner H6. However, the
binding only allows for a single compatible, while the patch was adding
two.

Make sure we follow the binding.

Fixes: 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -70,8 +70,7 @@
 	};
 
 	pmu {
-		compatible = "arm,cortex-a53-pmu",
-			     "arm,armv8-pmuv3";
+		compatible = "arm,cortex-a53-pmu";
 		interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,


