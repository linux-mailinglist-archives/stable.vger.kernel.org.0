Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95D47AE8E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbhLTPB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47940 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239883AbhLTO70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A3560F4E;
        Mon, 20 Dec 2021 14:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C419CC36AE8;
        Mon, 20 Dec 2021 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012365;
        bh=VscA6re06IZiVuKiuB3/YSaZB08/xHaOqYDWWyb1dKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsFqlkBo6JDSWBv3+O2KlRPUGHYxGSrx752Bw9Arh3NVHNqsgMAFvf2tJQnwsuS0o
         2Zh8xxNDYOjTrddmn0iSsr2kboaAP5irvcumVCYBZTaSwEvI9s1RgXHEOhsY4TIzqV
         zKi8Y2Q1jHHgvwDzSbAfqE0Le7ul9Z44GlnCBsKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bin.meng@windriver.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 142/177] riscv: dts: unleashed: Add gpio card detect to mmc-spi-slot
Date:   Mon, 20 Dec 2021 15:34:52 +0100
Message-Id: <20211220143044.865450214@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

commit 6331b8765cd0634a4e4cdcc1a6f1a74196616b94 upstream.

Per HiFive Unleashed schematics, the card detect signal of the
micro SD card is connected to gpio pin #11, which should be
reflected in the DT via the <gpios> property, as described in
Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt.

[1] https://sifive.cdn.prismic.io/sifive/c52a8e32-05ce-4aaf-95c8-7bf8453f8698_hifive-unleashed-a00-schematics-1.pdf

Signed-off-by: Bin Meng <bin.meng@windriver.com>
Fixes: d573b5558abb ("riscv: dts: add initial board data for the SiFive HiFive Unmatched")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -80,6 +80,7 @@
 		spi-max-frequency = <20000000>;
 		voltage-ranges = <3300 3300>;
 		disable-wp;
+		gpios = <&gpio 11 GPIO_ACTIVE_LOW>;
 	};
 };
 


