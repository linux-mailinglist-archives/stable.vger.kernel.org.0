Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C4B1333E3
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgAGVWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgAGVC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C182077B;
        Tue,  7 Jan 2020 21:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430947;
        bh=cqLQ1sbgU+vrRUMiMJlpuJO9wl/r6iZX6UVS87pB9uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZ0hZiGEKOXJPcp+n2AROUPCNfcLlIt0smgBXZ36ucaEBSNU210OLzDOlMl+Ut0Gh
         gzU+yyfdxWSCrocXk+MBmqmIwnb1QVrUwx8uYpPuMY9Nl3dAPw+9QTRnGeRWuuQ3OD
         88oqTUJv3No6OSmFr8Onkq/JUTIyUQIEgLhQ0uvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.4 161/191] arm64: dts: meson-gxl-s905x-khadas-vim: fix uart_A bluetooth node
Date:   Tue,  7 Jan 2020 21:54:41 +0100
Message-Id: <20200107205341.602729402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

commit 1c6d575574ec87dbccf7af20ef9dc0df02614069 upstream.

Fixes: dd5297cc8b8b ("arm64: dts: meson-gxl-s905x-khadas-vim enable Bluetooth")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts
@@ -192,6 +192,9 @@
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		shutdown-gpios = <&gpio GPIOX_17 GPIO_ACTIVE_HIGH>;
+		max-speed = <2000000>;
+		clocks = <&wifi32k>;
+		clock-names = "lpo";
 	};
 };
 


