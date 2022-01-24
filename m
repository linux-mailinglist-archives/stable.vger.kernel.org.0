Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F24996D5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349752AbiAXVHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42638 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358034AbiAXUsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D243160C44;
        Mon, 24 Jan 2022 20:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E51BC340E5;
        Mon, 24 Jan 2022 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057325;
        bh=waB+9LUVqnckRupSe5o4AhePh0a/nlEjGKrVjtO3D4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd/9DpTF6TZTmEiYpZS7cAevGI7EsVUTiwN4M/RyrgUKn4mNXLlFQIC2BjW8Zv7Y9
         pKWGZYBGN0RTuCuiV2yLZokqeySJUGhWQiPvcikWQQTfVdqBJH/A2RBTi9LSykfESr
         1c0EgPwDixLeOgfFd4IJ8q8nUmtIZgJtn7gmfDLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 775/846] riscv: dts: microchip: mpfs: Drop empty chosen node
Date:   Mon, 24 Jan 2022 19:44:52 +0100
Message-Id: <20220124184127.692830124@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 53ef07326ad0d6ae7fefded22bc53b427d542761 upstream.

It does not make sense to have an (empty) chosen node in an SoC-specific
.dtsi, as chosen is meant for system-specific configuration.
It is already provided in microchip-mpfs-icicle-kit.dts anyway.

Fixes: 0fa6107eca4186ad ("RISC-V: Initial DTS for Microchip ICICLE board")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -9,9 +9,6 @@
 	model = "Microchip PolarFire SoC";
 	compatible = "microchip,mpfs";
 
-	chosen {
-	};
-
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;


