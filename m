Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2329B13E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901857AbgJ0O2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759181AbgJ0O2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:28:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D14220754;
        Tue, 27 Oct 2020 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808891;
        bh=Ndvajv7/az6UWkd/DmI6idAGK3bclTCf9c6SNZcMMeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpEzQxVaWx9JmwbqMspbkl9Orh/8Bxfz1LdJ/JERo3ZOpbNC1+6os+j18iM7yo0g3
         cZEVZIBPDXvp/jgLZs/NM2aP3+uNg9GcWtGMwBqNMfREvMDw9eBx9VHfjso3upysx3
         6AxQgdqUE3QVJ92lacjwhQ5qj5db+0xxg5fXDZvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>
Subject: [PATCH 4.19 263/264] eeprom: at25: set minimum read/write access stride to 1
Date:   Tue, 27 Oct 2020 14:55:21 +0100
Message-Id: <20201027135443.001416611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit 284f52ac1c6cfa1b2e5c11b84653dd90e4e91de7 upstream.

SPI eeproms are addressed by byte.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200728092959.24600-1-ceggers@arri.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/eeprom/at25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -362,7 +362,7 @@ static int at25_probe(struct spi_device
 	at25->nvmem_config.reg_read = at25_ee_read;
 	at25->nvmem_config.reg_write = at25_ee_write;
 	at25->nvmem_config.priv = at25;
-	at25->nvmem_config.stride = 4;
+	at25->nvmem_config.stride = 1;
 	at25->nvmem_config.word_size = 1;
 	at25->nvmem_config.size = chip.byte_len;
 


