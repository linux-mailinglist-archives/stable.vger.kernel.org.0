Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B576827300A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgIURCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgIUQil (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974D1239A1;
        Mon, 21 Sep 2020 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706319;
        bh=wai9WqQSNiM8ftRi5EgtjQyT7Ml5PI4KuMDQCjrSvCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCbg2GCo+/fYZoHTkLW/4YxlGCJN1tQS5MC/VIvkXyEPZdfRHYT8J4i0Mx67qTkIP
         M010VADP3SYQrnyl03Qt96D4/7zkfHvr58iqKKhWqoZho80fmmfp7WGSSVVc8dWejH
         VtM2dWaF/1hWQwrtFRtG90pL/aSjSbCiDyIfoHu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Stefan Agner <stefan@agner.ch>,
        Chris Healy <cphealy@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 51/94] ARM: dts: vfxxx: Add syscon compatible with OCOTP
Date:   Mon, 21 Sep 2020 18:27:38 +0200
Message-Id: <20200921162037.903587129@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -527,7 +527,7 @@
 			};
 
 			ocotp: ocotp@400a5000 {
-				compatible = "fsl,vf610-ocotp";
+				compatible = "fsl,vf610-ocotp", "syscon";
 				reg = <0x400a5000 0x1000>;
 				clocks = <&clks VF610_CLK_OCOTP>;
 			};


