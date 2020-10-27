Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FF29BA45
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368950AbgJ0P7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804274AbgJ0PyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6868A2225C;
        Tue, 27 Oct 2020 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814042;
        bh=/UpGJSqZVZlNiVuhj4Mdx26q/M7kQMCbPS706LOA/yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWEKH2ADrv8HceJkkhjJojIkI64R7WJLzYeBM2qLa4Dk5VvCGXgNQLKDn4S+I0jk3
         ZXzlBxjvkEgCIQNDyEWLoZjUsmnFvOOkHyNMzaDNJ09nP33f33M1Gh2t7cIRiAD9WH
         6jcUoEbnboEqvCI6b2HuVjtaes2+GN2nSEMMWg0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>
Subject: [PATCH 5.9 756/757] eeprom: at25: set minimum read/write access stride to 1
Date:   Tue, 27 Oct 2020 14:56:46 +0100
Message-Id: <20201027135525.957300818@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
@@ -358,7 +358,7 @@ static int at25_probe(struct spi_device
 	at25->nvmem_config.reg_read = at25_ee_read;
 	at25->nvmem_config.reg_write = at25_ee_write;
 	at25->nvmem_config.priv = at25;
-	at25->nvmem_config.stride = 4;
+	at25->nvmem_config.stride = 1;
 	at25->nvmem_config.word_size = 1;
 	at25->nvmem_config.size = chip.byte_len;
 


