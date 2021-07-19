Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32283CD75E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241562AbhGSOQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241505AbhGSOQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C187D61003;
        Mon, 19 Jul 2021 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706615;
        bh=d1YeHnAYCSCX86FB15LjiCMM2stS15QsqSkTGYZKgIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6sG+TOWoaUMnSPauqU/UOhIPEbEhLoSPvNyBvX8GYewSgW0lnMA7k7aUDoX7EXZv
         Rc/rvpreWw0neC8ajJLNm9EekjlHnbDVZ+nEsmaw9UtOxKnMfKkhNYMUjQdqGGAHPB
         PpjVxf6xwXrB4NXbKWEobtuMx0rOoOuXHcOj6w0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>
Subject: [PATCH 4.4 022/188] serial_cs: Add Option International GSM-Ready 56K/ISDN modem
Date:   Mon, 19 Jul 2021 16:50:06 +0200
Message-Id: <20210719144918.243336899@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
@@ -771,6 +771,7 @@ static const struct pcmcia_device_id ser
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT2834LT", 0x5f73be51, 0x4cd7c09e),
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("Option International", "V34bis GSM/PSTN Data/Fax Modem", 0x9d7cd6f5, 0x5cb8bf41),
+	PCMCIA_DEVICE_PROD_ID12("Option International", "GSM-Ready 56K/ISDN", 0x9d7cd6f5, 0xb23844aa),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),


