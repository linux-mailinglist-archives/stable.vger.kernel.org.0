Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C302E3D31
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439895AbgL1OMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439893AbgL1OMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C81B207B6;
        Mon, 28 Dec 2020 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164713;
        bh=4HnUAQA1v3CGXo3EcwLeA/p9SuGNJwcQ+9Jg52p0b0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmbQrWwZ2Qoq0EEaXts+tsu2thyJk1VaokM00v5wev6LonYfMY+OTSDMkb5CDczDw
         iDubEytwIjsWIu18dlcg2tGZInbpPJrOorDIMEjPBv9nZK/QHQgZAbur2LfRPqm13Y
         FojEK+8Yq3iqEaIdMQ9HdMBl237eyEoaklSUs9ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/717] arm64: dts: meson: fix spi-max-frequency on Khadas VIM2
Date:   Mon, 28 Dec 2020 13:44:02 +0100
Message-Id: <20201228125032.672969024@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Lapkin <art@khadas.com>

[ Upstream commit b6c605e00ce8910d7ec3d9a54725d78b14db49b9 ]

The max frequency for the w25q32 (VIM v1.2) and w25q128 (VIM v1.4) spifc
chip should be 104Mhz not 30MHz.

Fixes: b8b74dda3908 ("ARM64: dts: meson-gxm: Add support for Khadas VIM2")
Signed-off-by: Artem Lapkin <art@khadas.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20201125024001.19036-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
index bff8ec2c1c70c..e2bd9c7c817d7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -341,7 +341,7 @@
 		#size-cells = <1>;
 		compatible = "winbond,w25q16", "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <3000000>;
+		spi-max-frequency = <104000000>;
 	};
 };
 
-- 
2.27.0



