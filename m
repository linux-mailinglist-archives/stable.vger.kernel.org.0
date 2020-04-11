Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565021A5024
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgDKMOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgDKMOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E39820673;
        Sat, 11 Apr 2020 12:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607288;
        bh=bGVoUHi+q6EB8N/jVwXEfvkGbUWke4Vm0+3man+KGeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZVgtDD1Vo8CkYaXHmZqXlynQbPv04AsBmDR6yE2zvxsgZN8cQAsYwW1boz6nl9q4
         64Roy4sJE3yXejl5ts3nRfvfeQoolVvqB1hf1fGTEO5WzdDtVo4GJwfreDoBc3hgnr
         bHZdp3z1+YYCBI7D3xe3mQa0FPmwIfcLP1T0FPEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takashi Kanamaru <neuralassembly@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 13/54] media: rc: IR signal for Panasonic air conditioner too long
Date:   Sat, 11 Apr 2020 14:08:55 +0200
Message-Id: <20200411115509.542364986@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 5c4c8b4a999019f19e770cb55cbacb89c95897bd upstream.

The IR signal to control the Panasonic ACXA75C00600 air conditioner has
439 pulse/spaces. Increase limit to make it possible to transmit signal.

Reported-by: Takashi Kanamaru <neuralassembly@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/lirc_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -29,7 +29,7 @@
 #include "rc-core-priv.h"
 #include <uapi/linux/lirc.h>
 
-#define LIRCBUF_SIZE	256
+#define LIRCBUF_SIZE	1024
 
 static dev_t lirc_base_dev;
 


