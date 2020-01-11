Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B574B137EDF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgAKKOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgAKKOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:14:40 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE5320673;
        Sat, 11 Jan 2020 10:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737679;
        bh=8ly01OGIEPnk2p8j5+xPUt2405IE4J4LAvf+++GTJN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SKnDQNmsBgHyXMqwsX/Xv5mPfmqZZql8aUPyYU7fCIwqX/7OvX8Qg9fGjdozMstB
         7KCjLIfYJUODuPSs7ADdSCK1ql0LNNWJA0GCXJjt0hr8TiG3UezpgNpTvUHaCOfiGF
         Fs9lAL5SuiLoVNp/oAIbYTVcCWVC4STd/JXv8mb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/84] ARM: dts: BCM5301X: Fix MDIO node address/size cells
Date:   Sat, 11 Jan 2020 10:49:58 +0100
Message-Id: <20200111094853.429814088@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 093c3f94e922d83a734fc4da08cc5814990f32c6 ]

The MDIO node on BCM5301X had an reversed #address-cells and
 #size-cells properties, correct those, silencing checker warnings:

.../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected

Reported-by: Simon Horman <simon.horman@netronome.com>
Fixes: 23f1eca6d59b ("ARM: dts: BCM5301X: Specify MDIO bus in the DT")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index bc607d11eef8..a678fb7c9e3b 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -350,8 +350,8 @@
 	mdio: mdio@18003000 {
 		compatible = "brcm,iproc-mdio";
 		reg = <0x18003000 0x8>;
-		#size-cells = <1>;
-		#address-cells = <0>;
+		#size-cells = <0>;
+		#address-cells = <1>;
 	};
 
 	mdio-bus-mux {
-- 
2.20.1



