Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE05BDD4C2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406364AbfJRW1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfJRWEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455DF20679;
        Fri, 18 Oct 2019 22:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436246;
        bh=Paqb7OqL+I6rrIchpLW5US/fo31+mNb4aU/UsTEfsTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJYUHN+qi8jJ5KKOZD51mRXmqL4+BwDa5gQPb0jHTS9EMq+TmwN1ce9Eg73hoGlbQ
         UTEeLVXsDIJ4DU8mUcZTMbWjYVsc1cGR9cflyDtQVu9VDXZuT2k72Lh/i5IMjMhRVI
         VYZFjo68LVdwOMNfs3Xfx5hCo2YuktXFSIABP/x4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 30/89] serial/sifive: select SERIAL_EARLYCON
Date:   Fri, 18 Oct 2019 18:02:25 -0400
Message-Id: <20191018220324.8165-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

