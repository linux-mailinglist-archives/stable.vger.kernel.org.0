Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79A33CDCB7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238306AbhGSOxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237352AbhGSOuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CADD601FD;
        Mon, 19 Jul 2021 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708642;
        bh=G6B7gHckaRcgU/0/HuY5T4oUEBS0LrVwtcpeZ2b8lYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOyaA6HR6IyhQv7DtE3NoBQfrqOmqP79TQC/gailYbn9dVJepGX53go49bv/V4NQZ
         i19opUkGF4HDGWhDauecGL8VxfX1z7/vgSAgLRAt70emPK5rAMdPqjVI+sfC/GatSS
         OwgdBdAOv/bhk8VXYYFTu+XH7u3qpEfhvwqhrtvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>
Subject: [PATCH 4.19 038/421] serial_cs: Add Option International GSM-Ready 56K/ISDN modem
Date:   Mon, 19 Jul 2021 16:47:29 +0200
Message-Id: <20210719144947.552959508@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

commit d495dd743d5ecd47288156e25c4d9163294a0992 upstream.

Add support for Option International GSM-Ready 56K/ISDN PCMCIA modem
card.

Signed-off-by: Ondrej Zary <linux@zary.sk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210611201940.23898-2-linux@zary.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/serial_cs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -780,6 +780,7 @@ static const struct pcmcia_device_id ser
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT2834LT", 0x5f73be51, 0x4cd7c09e),
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("Option International", "V34bis GSM/PSTN Data/Fax Modem", 0x9d7cd6f5, 0x5cb8bf41),
+	PCMCIA_DEVICE_PROD_ID12("Option International", "GSM-Ready 56K/ISDN", 0x9d7cd6f5, 0xb23844aa),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),


