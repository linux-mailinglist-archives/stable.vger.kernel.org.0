Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED65B45BA60
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhKXMKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241334AbhKXMIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:08:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C171A610A2;
        Wed, 24 Nov 2021 12:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755509;
        bh=MIv2PVE0hYJ/DibRIv6CQED5BS/nlyXUll2BwE/PMrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDwi0SjHUwnR9W6SAwwn++BVhV0e0xRhW/AiMr0HhzRpyEDa8YrHm9pTkCn94GSgd
         kMieCpZbJv3ylx7lKokMvfJhsf8fAekJ5ueX8TQKbrkiueWuM2r9teMJkx86NXkCgG
         qZnEspryuj7SPzBwJx2xETkJ9HUrpCXaf0H8AARg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 120/162] ARM: dts: omap: fix gpmc,mux-add-data type
Date:   Wed, 24 Nov 2021 12:57:03 +0100
Message-Id: <20211124115702.195994418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 51b9e22ffd3c4c56cbb7caae9750f70e55ffa603 ]

gpmc,mux-add-data is not boolean.

Fixes the below errors flagged by dtbs_check.

"ethernet@4,0:gpmc,mux-add-data: True is not of type 'array'"

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi         | 2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi b/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
index 73e272fadc202..58d288fddd9c2 100644
--- a/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
+++ b/arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi
@@ -28,7 +28,7 @@
 		compatible = "smsc,lan9221","smsc,lan9115";
 		bank-width = <2>;
 
-		gpmc,mux-add-data;
+		gpmc,mux-add-data = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <42>;
 		gpmc,cs-wr-off-ns = <36>;
diff --git a/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi b/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
index 82e98ee3023ad..3dbeb7a6c569c 100644
--- a/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
+++ b/arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi
@@ -25,7 +25,7 @@
 		compatible = "smsc,lan9221","smsc,lan9115";
 		bank-width = <2>;
 
-		gpmc,mux-add-data;
+		gpmc,mux-add-data = <0>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <42>;
 		gpmc,cs-wr-off-ns = <36>;
-- 
2.33.0



