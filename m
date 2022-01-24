Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC8499033
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351862AbiAXT7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344754AbiAXTxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC2EC061340;
        Mon, 24 Jan 2022 11:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE7F6149A;
        Mon, 24 Jan 2022 19:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB4DC340E5;
        Mon, 24 Jan 2022 19:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052404;
        bh=TwdPhdXhXkecM3Z8zXwBoX/gGUgexIZjp4FmZkHH3so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtJrgN1w+SOUYt6L9S4kkQcS4VbrYqRtMXktbxFMuBOOVyxhYWKB+ZpITpJRFrToD
         wkBAw/sNi2IRRGbT/mRVhq+BbjHCYD3HVFFS4mM1xlgJpIvUHsOFs0ywkhzGH4N469
         k3X751Mig6UDTcConL6tEi9buKv2xnGX/adtXz3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/320] arm64: dts: meson-gxbb-wetek: fix missing GPIO binding
Date:   Mon, 24 Jan 2022 19:40:31 +0100
Message-Id: <20220124183955.346783603@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index d7d0b65713841..e94f09c2d4e32 100644
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



