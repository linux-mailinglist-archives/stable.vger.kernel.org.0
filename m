Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD123068D
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 11:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgG1Jac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 05:30:32 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:56279 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgG1Jac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 05:30:32 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4BGBH86rDNz37nY;
        Tue, 28 Jul 2020 11:30:28 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BGBGw23Tfz2TTLd;
        Tue, 28 Jul 2020 11:30:16 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.116) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 28 Jul
 2020 11:30:15 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Christian Eggers <ceggers@arri.de>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] eeprom: at25: set minimum read/write access stride to 1
Date:   Tue, 28 Jul 2020 11:29:59 +0200
Message-ID: <20200728092959.24600-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.116]
X-RMX-ID: 20200728-113016-4BGBGw23Tfz2TTLd-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SPI eeproms are addressed by byte.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/misc/eeprom/at25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 0e7c8dc01195..4e57eb145fcc 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -358,7 +358,7 @@ static int at25_probe(struct spi_device *spi)
 	at25->nvmem_config.reg_read = at25_ee_read;
 	at25->nvmem_config.reg_write = at25_ee_write;
 	at25->nvmem_config.priv = at25;
-	at25->nvmem_config.stride = 4;
+	at25->nvmem_config.stride = 1;
 	at25->nvmem_config.word_size = 1;
 	at25->nvmem_config.size = chip.byte_len;
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

