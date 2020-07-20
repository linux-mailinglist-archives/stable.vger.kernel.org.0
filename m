Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6F4226624
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgGTQAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732429AbgGTQAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF1A20684;
        Mon, 20 Jul 2020 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260838;
        bh=8+F1xvidluSTrZ/um2PpFkWZI11lB1bsHhGjws3CU2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OigXwxwOthGw+A3QBQnN7W4Hdaur0bYll9cE7R2rSZAjkPH2IJR/Kz5UlXlHo5ykD
         T9ys5yH2PnRXpDqWcWXfrDl9qZl+Oe3KhNREZdKUshwQxlWGOPJdCD+0dIH03+44Dg
         kxHxD4lMXxuR8s5+NP7AzxpGMSc6b9h8Q4WRZ/qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/215] arm64: dts: meson: add missing gxl rng clock
Date:   Mon, 20 Jul 2020 17:36:19 +0200
Message-Id: <20200720152824.826299352@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 95ca6f06dd4827ff63be5154120c7a8511cd9a41 ]

The peripheral clock of the RNG is missing for gxl while it is present
for gxbb.

Fixes: 1b3f6d148692 ("ARM64: dts: meson-gx: add clock CLKID_RNG0 to hwrng node")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20200617125346.1163527-1-jbrunet@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 49ff0a7d0210f..e3cfa24dca5ab 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -288,6 +288,11 @@ clkc: clock-controller {
 	};
 };
 
+&hwrng {
+	clocks = <&clkc CLKID_RNG0>;
+	clock-names = "core";
+};
+
 &i2c_A {
 	clocks = <&clkc CLKID_I2C>;
 };
-- 
2.25.1



