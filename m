Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86681450E9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbgAVJi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733027AbgAVJi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D74A2467F;
        Wed, 22 Jan 2020 09:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685906;
        bh=FwLbWFeFbvdUrH5giB50SJAEdUAePu1BlpASRib3hG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IINMkjGF4qQrSNAUvfXcpZUu5fknQPZKw8WqY3bwWWwvsUneFXRNG3+pQw4NWeC7X
         4NR5o9ww5wpqELbJx+tMhuO/kVJYDmQaeaNqFdP7NY6LB4JyNarHmnLqqn4dAf59rk
         HGFP4uNFvykfe6/3S+UOPyk2gGwo4mlMZULw/4iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 07/65] ARM: dts: am571x-idk: Fix gpios property to have the correct  gpio number
Date:   Wed, 22 Jan 2020 10:28:52 +0100
Message-Id: <20200122092752.331828273@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 0c4eb2a6b3c6b0facd0a3bccda5db22e7b3b6f96 upstream.

commit d23f3839fe97d8dce03d ("ARM: dts: DRA7: Add pcie1 dt node for
EP mode") while adding the dt node for EP mode for DRA7 platform,
added rc node for am571x-idk and populated gpios property with
"gpio3 23". However the GPIO_PCIE_SWRST line is actually connected
to "gpio5 18". Fix it here. (The patch adding "gpio3 23" was tested
with another am57x board in EP mode which doesn't rely on reset from
host).

Cc: stable <stable@vger.kernel.org> # 4.14+
Fixes: d23f3839fe97d8dce03d ("ARM: dts: DRA7: Add pcie1 dt node for EP mode")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am571x-idk.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -93,7 +93,7 @@
 
 &pcie1_rc {
 	status = "okay";
-	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
+	gpios = <&gpio5 18 GPIO_ACTIVE_HIGH>;
 };
 
 &pcie1_ep {


