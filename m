Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD31CAADA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEHMhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgEHMhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF46621835;
        Fri,  8 May 2020 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941442;
        bh=ZsjH6NjkSmYZr/yEHka8q/nXwXe0HKZnlTZkrJkYLNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upccLzEloiFBNi5DhApvI8zGPRXE6jfi12jrkAaFJliTJwc9L9tK8ljy46JyFQcpC
         VTH7aKJNR/3dUfhAODR8tVMR6nIwmzUG/Lwi4tSRRwmcRxmnnDrorLBXn7dNyQhBEB
         IAFAr7BCdoVZLYGzhRrPa701GisFjoujlzxOR9KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 4.4 034/312] ARM: dts: armadillo800eva Correct extal1 frequency to 24 MHz
Date:   Fri,  8 May 2020 14:30:25 +0200
Message-Id: <20200508123126.876628511@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c61f30a255550bbfc6b83c1ca720661489cac4c0 upstream.

On r8a7740/armadillo, actual clock rates are ca. 4% lower than reported
by /sys/kernel/debug/clk/clk_summary. Correct the extal1 frequency from
25 MHz to 24 MHz to fix this.

This matches the Armadillo-800 EVA Product Manual, which claims the main
crystal runs at 24 MHz, and the old legacy/reference board code.

Fixes: 25aa7ba3fdfb ("ARM: shmobile: armadillo800eva: Sync DTS")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/r8a7740-armadillo800eva.dts
+++ b/arch/arm/boot/dts/r8a7740-armadillo800eva.dts
@@ -180,7 +180,7 @@
 };
 
 &extal1_clk {
-	clock-frequency = <25000000>;
+	clock-frequency = <24000000>;
 };
 &extal2_clk {
 	clock-frequency = <48000000>;


