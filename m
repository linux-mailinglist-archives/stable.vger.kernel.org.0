Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7FB328A7C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbhCASR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239350AbhCASLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7812764FBA;
        Mon,  1 Mar 2021 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620233;
        bh=GBYnIhzviYEskKBCbud2gg9Box+OSWeHeuOJIooZhPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSOw4RElCjt/eEWMby5zYYmlSlVLCufrPZjFQKS0eFAkEgxfJpPB4vmiKp4dvX/WX
         95ycfZOeBIfN0oQVPHXAanJ/oJBQmojh2nyL3sr6sQqk7P8wJbi6MYnWffiBWDYVha
         63UTDP/oKbSKlIx6TWDwIlrEqpEA2J6BE7M2Nn6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 079/775] arm64: dts: meson: fix broken wifi node for Khadas VIM3L
Date:   Mon,  1 Mar 2021 17:04:07 +0100
Message-Id: <20210301161205.584625576@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Lapkin <email2tema@gmail.com>

[ Upstream commit 39be8f441f78908e97ff913571e10ec03387a63a ]

move &sd_emmc_a ... from /* */ commented area, because cant load wifi fw
without sd-uhs-sdr50 option on VIM3L

[   11.686590] brcmfmac: brcmf_chip_cores_check: CPU core not detected
[   11.696382] brcmfmac: brcmf_sdio_probe_attach: brcmf_chip_attach failed!
[   11.706240] brcmfmac: brcmf_sdio_probe: brcmf_sdio_probe_attach failed
[   11.715890] brcmfmac: brcmf_ops_sdio_probe: F2 error, probe failed -19...
[   13.718424] brcmfmac: brcmf_chip_recognition: chip backplane type 15 is not supported

Signed-off-by: Artem Lapkin <art@khadas.com>
Fixes: f1bb924e8f5b ("arm64: dts: meson: fix mmc0 tuning error on Khadas VIM3")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20210129085041.1408540-1-art@khadas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
index 4b517ca720597..06de0b1ce7267 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts
@@ -89,13 +89,12 @@
 	status = "okay";
 };
 
-&sd_emmc_a {
-	sd-uhs-sdr50;
-};
-
 &usb {
 	phys = <&usb2_phy0>, <&usb2_phy1>;
 	phy-names = "usb2-phy0", "usb2-phy1";
 };
  */
 
+&sd_emmc_a {
+	sd-uhs-sdr50;
+};
-- 
2.27.0



