Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4214EEEE97
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388517AbfKDWFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389819AbfKDWFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:17 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD971217F5;
        Mon,  4 Nov 2019 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905117;
        bh=Paqb7OqL+I6rrIchpLW5US/fo31+mNb4aU/UsTEfsTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUgrf0lRl+9AGrhg4VEtC8WrPF+cjE2/yBrvFM2X6VbeXHnr8BYvpCFV7GA+xQj/F
         l+kWjUad5TMqpaKFXJw1KVLliIFrKiEjSMTqHWvqVyU9Cd3lsf+l7Yeua5G/Kaimf6
         NPkbMjJGEBfIceMsdYqiaISKHZr6OjYUSJCClcyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 034/163] serial/sifive: select SERIAL_EARLYCON
Date:   Mon,  4 Nov 2019 22:43:44 +0100
Message-Id: <20191104212142.716077799@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7e2a165de5a52003d10a611ee3884cdb5c44e8cd ]

The sifive serial driver implements earlycon support, but unless
another driver is built in that supports earlycon support it won't
be usable.  Explicitly select SERIAL_EARLYCON instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>
Link: https://lore.kernel.org/r/20190910055923.28384-1-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3083dbae35f7e..3b436ccd29dad 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1075,6 +1075,7 @@ config SERIAL_SIFIVE_CONSOLE
 	bool "Console on SiFive UART"
 	depends on SERIAL_SIFIVE=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 	help
 	  Select this option if you would like to use a SiFive UART as the
 	  system console.
-- 
2.20.1



