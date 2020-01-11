Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43483137FC0
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgAKKWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgAKKWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:48 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9162082E;
        Sat, 11 Jan 2020 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738168;
        bh=3cMs4tT+RemEJnmuF4khxgCvz9o2HcNgNZpneHdQLRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMYMCVjy52RJ2MHYmgNveMmzwbjLhM+4e4iJRSKMNojvDjSjBjPmH4O0pcp3Ya66d
         Y+P3WyWGLgBLVvOf95LK5WI9oDOsDbwOkKbbThBbNDDxBofDMTmNKcVUl+mCAR/HE5
         jcmoXgh5N9U4unv71YpcifWIYkL7DsZraQJfXKZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/165] ARM: dts: Cygnus: Fix MDIO node address/size cells
Date:   Sat, 11 Jan 2020 10:49:21 +0100
Message-Id: <20200111094924.462913621@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit fac2c2da3596d77c343988bb0d41a8c533b2e73c ]

The MDIO node on Cygnus had an reversed #address-cells and
 #size-cells properties, correct those.

Fixes: 40c26d3af60a ("ARM: dts: Cygnus: Add the ethernet switch and ethernet PHY")
Reported-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-cygnus.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 2dac3efc7640..1bc45cfd5453 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -174,8 +174,8 @@
 		mdio: mdio@18002000 {
 			compatible = "brcm,iproc-mdio";
 			reg = <0x18002000 0x8>;
-			#size-cells = <1>;
-			#address-cells = <0>;
+			#size-cells = <0>;
+			#address-cells = <1>;
 			status = "disabled";
 
 			gphy0: ethernet-phy@0 {
-- 
2.20.1



