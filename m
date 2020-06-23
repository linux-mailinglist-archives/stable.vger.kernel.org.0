Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D63205C63
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbgFWUBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbgFWUBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB643206C3;
        Tue, 23 Jun 2020 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942494;
        bh=+Xs/HUlxg1DyVqM6VD+587PpPAcfdfjAHJ3jTcdWD3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXC2PPo4sf1m60ExFqbguCUKzmL608ccs1Uc5qJRFnIs4nsKR8AJMeKwoXsWnUAui
         e29Vf1GbTY9bAEBC+Y9jzFK+P5YuhJOa1DVu9JDS8cNpHGKSJ+mHwC/7+wruPQ+gPR
         e9vtsaMdalwuVoENxKzAku5hfX0EIHYgk2OsS09o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 020/477] arm64: dts: meson-gxbb-kii-pro: fix board compatible
Date:   Tue, 23 Jun 2020 21:50:17 +0200
Message-Id: <20200623195408.562273004@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit d120b5f98031eefc22164ae8c6ea3711e7a04c19 ]

Remove the uneeded "amlogic,p201", "amlogic,s905" in the board compatible list.

It fixes:
meson-gxbb-kii-pro.dt.yaml: /: compatible: ['videostrong,kii-pro', 'amlogic,p201', 'amlogic,s905', 'amlogic,meson-gxbb'] is not valid under any of the given schemas

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20200326165958.19274-5-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index 6c9cc45fb417e..e8394a8269ee1 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -11,7 +11,7 @@
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/leds/common.h>
 / {
-	compatible = "videostrong,kii-pro", "amlogic,p201", "amlogic,s905", "amlogic,meson-gxbb";
+	compatible = "videostrong,kii-pro", "amlogic,meson-gxbb";
 	model = "Videostrong KII Pro";
 
 	leds {
-- 
2.25.1



