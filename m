Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2E2ABC3D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbgKINEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbgKINEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:04:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30939206C0;
        Mon,  9 Nov 2020 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927093;
        bh=JGWW1lVL9yp4941ji1knFbaPIsZ+n9HqmGpmQ5dB3Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDgvHo9T/fmsSRl96Bvk4/FVnIoDejAu1gou18qJvXOGbV9VfVdU3W0zv/fxZ32Qo
         7mO+2dxtd9tYb/5CEaPVUMwTTi9qVLANs1EXdtAe7o9O6N2pswE34JgTj8fXVl2sKF
         bOMSeoiAMfU8fSZjpBaALG4c2AtblQSgKDnTWNl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.9 081/117] arm64: berlin: Select DW_APB_TIMER_OF
Date:   Mon,  9 Nov 2020 13:55:07 +0100
Message-Id: <20201109125029.531168729@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit b0fc70ce1f028e14a37c186d9f7a55e51439b83a upstream.

Berlin SoCs always contain some DW APB timers which can be used as an
always-on broadcast timer.

Link: https://lore.kernel.org/r/20201009150536.214181fb@xhacker.debian
Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Kconfig.platforms |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -41,6 +41,7 @@ config ARCH_BCM_IPROC
 config ARCH_BERLIN
 	bool "Marvell Berlin SoC Family"
 	select DW_APB_ICTL
+	select DW_APB_TIMER_OF
 	select GPIOLIB
 	select PINCTRL
 	help


