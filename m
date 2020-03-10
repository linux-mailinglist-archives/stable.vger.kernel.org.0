Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0820817FD77
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgCJMzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728580AbgCJMzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4172253D;
        Tue, 10 Mar 2020 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844903;
        bh=0TQYR1CoOeat+OC33dAfyJD1V5YNNLKHuNChSjJvb24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlKYwrKDs/uTg3uMvCEkMKGiZIS8IkLN9g39Jw9Hfu26P3u2Y0ekcv7/J9hLiVgyL
         BCwE2nNvdvDscQ5Zy9Y3aYZsFlkeRMlzur2haXViLW6t76Hu1WJ2OGx07YpnCPnPFf
         +IyP+Nm49N8D0T6MgRzq9YqDsXeOwYC8Nc0Foxyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Art Nikpal <email2tema@gmail.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.4 162/168] arm64: dts: meson: fix gxm-khadas-vim2 wifi
Date:   Tue, 10 Mar 2020 13:40:08 +0100
Message-Id: <20200310123651.956446886@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

commit 146033562e7e5d1c9aae9653986806664995f1d5 upstream.

before

[6.418252] brcmfmac: F1 signature read @0x18000000=0x17224356
[6.435663] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
[6.551259] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
[6.551275] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading 2048 membytes at 0x00184000
[6.551352] brcmfmac: brcmf_sdio_download_firmware: dongle image file download failed

after

[6.657165] brcmfmac: F1 signature read @0x18000000=0x17224356
[6.660807] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
[6.918643] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
[6.918734] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
[6.922724] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4356/2 wl0: Jun 16 2015 14:25:06 version 7.35.184.r1 (TOB) (r559293) FWID 01-b22ae69c

Fixes: adc52bf7ef16 ("arm64: dts: meson: fix mmc v2 chips max frequencies")
Suggested-by: Art Nikpal <email2tema@gmail.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/1582212790-11402-1-git-send-email-christianshewitt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -327,7 +327,7 @@
 	#size-cells = <0>;
 
 	bus-width = <4>;
-	max-frequency = <50000000>;
+	max-frequency = <60000000>;
 
 	non-removable;
 	disable-wp;


