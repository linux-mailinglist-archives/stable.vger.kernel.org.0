Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7782E126DCA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfLSTMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfLSSgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C4224672;
        Thu, 19 Dec 2019 18:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780603;
        bh=wPJ8Eff7+YJjxgaQlzD1lfkJRng/4VLIGf6uMqVMwxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYtxiiPzrOhxv3MnHdVCt6kgzzbjX/mwwKeG6MNLZllYhnisurId1qZcmwPsWVjl+
         VxV4lYLt/qFzklCPRRKIis6puZAQbeX6Mn+r9J9ZsKJXg2cz19uGSAJn8ArG6/8qNr
         KRHtEf+hjVq7Aoao6Ij1rqO5BBAqk/h4FIAzMo5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Pavel Machek <pavel@ucw.cz>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 042/162] ARM: dts: mmp2: fix the gpio interrupt cell number
Date:   Thu, 19 Dec 2019 19:32:30 +0100
Message-Id: <20191219183210.488179479@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 400583983f8a8e95ec02c9c9e2b50188753a87fb ]

gpio-pxa uses two cell to encode the interrupt source: the pin number
and the trigger type. Adjust the device node accordingly.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mmp2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 47e5b63339d18..e95deed6a7973 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -180,7 +180,7 @@
 				clocks = <&soc_clocks MMP2_CLK_GPIO>;
 				resets = <&soc_clocks MMP2_CLK_GPIO>;
 				interrupt-controller;
-				#interrupt-cells = <1>;
+				#interrupt-cells = <2>;
 				ranges;
 
 				gcb0: gpio@d4019000 {
-- 
2.20.1



