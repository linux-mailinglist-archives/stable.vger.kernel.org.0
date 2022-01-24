Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048E349967C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353817AbiAXVEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50102 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358037AbiAXU7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9174360C17;
        Mon, 24 Jan 2022 20:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB34C340E5;
        Mon, 24 Jan 2022 20:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057960;
        bh=V3QOwk8IW3ZkXrK9Ww4HIPJ27Oj/Lc/7eiEjo3TghfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4WRYyiGkN1bFxiA4fnxYLAhwz8JdVicJnx8Rl0Wy2l85slIDsW2oMn6SppwvAWJz
         ItgNFPJyCLYIsjPv47beSJXOvxnCIFl1EsxW/2W7RXRdVFUmQS4UQmhnwIcNoZLvcU
         S19FlMGDLRKgoAWVlr4QwkIBf7X7csJZJOWGHMxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0136/1039] arm64: dts: meson-gxbb-wetek: fix missing GPIO binding
Date:   Mon, 24 Jan 2022 19:32:05 +0100
Message-Id: <20220124184129.748140768@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit c019abb2feba3cbbd7cf7178f8e6499c4fa6fced ]

The absence of this binding appears to be harmless in Linux but it breaks
Ethernet support in mainline u-boot. So add the binding (which is present
in all other u-boot supported GXBB device-trees).

Fixes: fb72c03e0e32 ("ARM64: dts: meson-gxbb-wetek: add a wetek specific dtsi to cleanup hub and play2")

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211012052522.30873-3-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
index 8e2af986cebaf..a4d34398da358 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
@@ -6,6 +6,7 @@
  */
 
 #include "meson-gxbb.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	aliases {
-- 
2.34.1



