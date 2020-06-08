Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C671F2E5A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgFIAkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgFHXMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA35920B80;
        Mon,  8 Jun 2020 23:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657971;
        bh=Yf6tijfTtkC0daEZSzoDMhzmrg/OWgETF9rfSQTSNGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/nmDo6tmPGgBdJDjGiJKR5FYeQQxJIC6ss1nCQ099jMorsuL2M6lyxjNxW2BtUBM
         NU7g61fvlN2XHm47aY7oxLIyjr/x/YIiCkKvOrCPbShWr65ls2lt3UDdBh3VyNkL6i
         OUnz7pb8nEMrwozIY5+fn2K6b0ciQ9kTDZ2wRq9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 034/606] ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection
Date:   Mon,  8 Jun 2020 19:02:39 -0400
Message-Id: <20200608231211.3363633-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Vokáč <michal.vokac@ysoft.com>

commit cbe63a8358310244e6007398bd2c7c70c7fd51cd upstream.

The Y Soft yapp4 platform supports up to two Ethernet ports.
The Ursa board though has only one Ethernet port populated and that is
the port@2. Since the introduction of this platform into mainline a wrong
port was deleted and the Ethernet could never work. Fix this by deleting
the correct port node.

Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6dl-yapp4-ursa.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts b/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
index 0d594e4bd559..a1173bf5bff5 100644
--- a/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
+++ b/arch/arm/boot/dts/imx6dl-yapp4-ursa.dts
@@ -38,7 +38,7 @@ &reg_usb_h1_vbus {
 };
 
 &switch_ports {
-	/delete-node/ port@2;
+	/delete-node/ port@3;
 };
 
 &touchscreen {
-- 
2.25.1

