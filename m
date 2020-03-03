Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5944177FEF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgCCRxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732414AbgCCRxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6011F206D5;
        Tue,  3 Mar 2020 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258023;
        bh=b0T7XcKyF7fdfoO4CCzBX1iv4p+VefjFERsskt64TYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNuOKdoSE04fW9+E3zvAGpyzyhd6esmcllfRD7IZCPseUn0LY+koB80XlqgVzAk6V
         nyuf3Ua7qJisfyFA4XciVfeERkSPXDUAYOwUkdFVCBfaYywR/cEft+gT3uraXFIXex
         kLtHLgfTGvhoq0OpHoQ7z4hStpVxWWPqU4VuRxys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/152] ARM: dts: sti: fixup sound frame-inversion for stihxxx-b2120.dtsi
Date:   Tue,  3 Mar 2020 18:42:18 +0100
Message-Id: <20200303174306.966171908@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit f24667779b5348279e5e4328312a141a730a1fc7 ]

frame-inversion is "flag" not "uint32".
This patch fixup it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 60e11045ad762..d051f080e52ec 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -46,7 +46,7 @@
 			/* DAC */
 			format = "i2s";
 			mclk-fs = <256>;
-			frame-inversion = <1>;
+			frame-inversion;
 			cpu {
 				sound-dai = <&sti_uni_player2>;
 			};
-- 
2.20.1



