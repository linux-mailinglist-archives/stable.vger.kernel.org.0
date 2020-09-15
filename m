Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7CB26B6FB
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgIPAP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88438222C4;
        Tue, 15 Sep 2020 14:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179501;
        bh=092x1AY9sFPqFDWF5HvyIY0yBDR20OqPiqh55KgKms0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hod/n5VYJGxlZvbyxKtkA3x02ujBUHMa1+hoDn03YEiV/NAZqSSSodbMCrzqxKo/f
         pHR1bTcgq/VHGlPkN9XSWsm25SnLvKCsuK7IrQk7McEOVVVj8bkm+poc/alUaaaT3H
         SAcoHowcqPgM8L2R167N5dvKY43zCo1N8ILzkSPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Stefan Agner <stefan@agner.ch>,
        Chris Healy <cphealy@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.19 69/78] ARM: dts: vfxxx: Add syscon compatible with OCOTP
Date:   Tue, 15 Sep 2020 16:13:34 +0200
Message-Id: <20200915140637.043736203@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

commit 2a6838d54128952ace6f0ca166dd8706abe46649 upstream.

Add syscon compatibility with Vybrid OCOTP node. This is required to
access the UID.

Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/vfxxx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -532,7 +532,7 @@
 			};
 
 			ocotp: ocotp@400a5000 {
-				compatible = "fsl,vf610-ocotp";
+				compatible = "fsl,vf610-ocotp", "syscon";
 				reg = <0x400a5000 0x1000>;
 				clocks = <&clks VF610_CLK_OCOTP>;
 			};


