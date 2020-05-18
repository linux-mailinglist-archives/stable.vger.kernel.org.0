Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEB41D82C1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgERR7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731986AbgERR7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21BA220826;
        Mon, 18 May 2020 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824739;
        bh=x2k6H2u4z4R3Mw2PyUDpbwdtIYEjroK2GYUDNPg6l3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYK5aDb4mjmO5yOu3rkDoliXAAb0+5LPTYK7FKnzEYo5EOPqt12okt0SC2P+eMwVL
         QRvSYI1VPA99R8n0aRMpY03BcdVANtqF5XLWG2llF6ixQRkjqO5n/W+BQ/k5YXv0Dr
         FIj294FlNGRuNWEsamQ57vG6FQ3QaqMH17/DWLnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.4 133/147] arm64: dts: meson-g12b-khadas-vim3: add missing frddr_a status property
Date:   Mon, 18 May 2020 19:37:36 +0200
Message-Id: <20200518173529.894863202@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 5ac0869fb39b1c1ba84d4d75c550f82e0bf44c96 upstream.

In the process of moving the VIM3 audio nodes to a G12B specific dtsi
for enabling the SM1 based VIM3L, the frddr_a status = "okay" property
got dropped.
This re-enables the frddr_a node to fix audio support.

Fixes: 4f26cc1c96c9 ("arm64: dts: khadas-vim3: move common nodes into meson-khadas-vim3.dtsi")
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20191018140216.4257-1-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi
@@ -152,6 +152,10 @@
 	clock-latency = <50000>;
 };
 
+&frddr_a {
+	status = "okay";
+};
+
 &frddr_b {
 	status = "okay";
 };


