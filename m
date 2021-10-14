Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDC42DC74
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhJNO7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhJNO62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D374A610D1;
        Thu, 14 Oct 2021 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223383;
        bh=k50ZKT8agpX/HBWINfIl13FTeAPQEn1UItCaWf+ONEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPqZtwKug+9PsGCxeNkg38lQAdpCbgzNEMVtMyYeSO+ahk3H3Bwy9FB7J50fUC0OR
         MaH6NHVcsX8hRaWTaiyGN/qLVFbjeGW/VQNlEL0G2+IOcQ6QNHY/Don/SNGmHEWjUl
         C0ePTZlv1t/P8610ihuh7majP5A+WxIfy8w8IBJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.9 06/25] ARM: dts: omap3430-sdp: Fix NAND device node
Date:   Thu, 14 Oct 2021 16:53:37 +0200
Message-Id: <20211014145207.780130790@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@kernel.org>

commit 80d680fdccba214e8106dc1aa33de5207ad75394 upstream.

Nand is on CS1 so reg properties first field should be 1 not 0.

Fixes: 44e4716499b8 ("ARM: dts: omap3: Fix NAND device nodes")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/omap3430-sdp.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -104,7 +104,7 @@
 
 	nand@1,0 {
 		compatible = "ti,omap2-nand";
-		reg = <0 0 4>; /* CS0, offset 0, IO size 4 */
+		reg = <1 0 4>; /* CS1, offset 0, IO size 4 */
 		interrupt-parent = <&gpmc>;
 		interrupts = <0 IRQ_TYPE_NONE>, /* fifoevent */
 			     <1 IRQ_TYPE_NONE>;	/* termcount */


