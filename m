Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9707A66EA3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfGLMZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbfGLMZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5726D2084B;
        Fri, 12 Jul 2019 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934355;
        bh=hIN7jpa6cDFxGD84PjJS/F189Tiq4VOhhLQwt2EQzhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFqgb7g2WkBrOHhwcx0n8scA5Wwk4H0vuourjoKcSDPLXcm9SFO7oFGMu4CG/IVlK
         rzWjqhZeyz9qy+3kF4Ij+lW0SjrGm8O70fbB5lv6iuv3lCBj54BUnB34QKMJdssm9e
         gA/tKDrmm/WB6fXrFlIdsfGuOBmy1ZWrNSeJ3IMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 005/138] ARM: dts: dra76x: Disable usb4_tm target module
Date:   Fri, 12 Jul 2019 14:17:49 +0200
Message-Id: <20190712121628.933834412@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b07bd27e02b9108ce8412cc2dc6faf621f57d224 ]

usb4_tm is unsed on dra76 and accessing the module
with ti,sysc is causing a boot crash hence disable its target
module.

Fixes: 549fce068a3112 ("ARM: dts: dra7: Add l4 interconnect hierarchy and ti-sysc data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra76x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dra76x.dtsi b/arch/arm/boot/dts/dra76x.dtsi
index 5c437271d307..82b3dc90b7d6 100644
--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -85,3 +85,7 @@
 &rtctarget {
 	status = "disabled";
 };
+
+&usb4_tm {
+	status = "disabled";
+};
-- 
2.20.1



