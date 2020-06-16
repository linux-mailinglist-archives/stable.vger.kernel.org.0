Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228351FB9AF
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgFPQFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731397AbgFPPsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:48:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B7F21475;
        Tue, 16 Jun 2020 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322521;
        bh=dGUE12/42yvGP/krDtbWrOV0Sj51B3xIa7MIrNpMlhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD4WKLBS4jOO22brm7d1HeG9eBDQaKacAEtma8ii5jSJdaYolaxSrBQqncaSSoCe6
         vQ1lC/PtAI4/399AQfwPPWjN7Q1DsjJG+5qWzmpVVkq/QNU3VmvHdVErZMqm3TMheW
         r0aqnfyV5n6ilGKlnnOwOrxUP8VYj/+nVCLTKJDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.7 155/163] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description
Date:   Tue, 16 Jun 2020 17:35:29 +0200
Message-Id: <20200616153114.230506967@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@microchip.com>

commit a1af7f36c70369b971ee1cf679dd68368dad23f0 upstream.

Remove non-removable and mmc-ddr-1_8v properties from the sdmmc0
node which come probably from an unchecked copy/paste.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes:42ed535595ec "ARM: dts: at91: introduce the sama5d2 ptc ek board"
Cc: stable@vger.kernel.org # 4.19 and later
Link: https://lore.kernel.org/r/20200401221504.41196-1-ludovic.desroches@microchip.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -125,8 +125,6 @@
 			bus-width = <8>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_sdmmc0_default>;
-			non-removable;
-			mmc-ddr-1_8v;
 			status = "okay";
 		};
 


