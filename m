Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72201654BFA
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 05:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiLWEYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 23:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLWEYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 23:24:32 -0500
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8A723BF7
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 20:24:30 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 61D406031F
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 13:24:29 +0900 (JST)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 8EC406010E
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 13:24:28 +0900 (JST)
Received: by mail-pg1-f200.google.com with SMTP id r22-20020a63ce56000000b00478f1cfb0fbso2147567pgi.0
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 20:24:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBDC9ChAeeQBia/ZUlsALV6hFzA+pCEINYLDDXbpoLE=;
        b=5cd2XOAe17Z1YcGeW/7ZjnGemspbi7jGxTKWi7732lhvK1MXXEOYqMx2S6ZSjfFkm0
         AQA7zmffBhe1nTKgPA9QKA3ljbikfA9hgnW+6EE47T+9FCIYw5Pe4iQhMbBixRsm8NTn
         +b9ajdLOPUTMtgkf2mWNp1YaurqvJ3MvnoJkICU/d56fp3kJApHR+gsiQou77yiB9b4x
         mq+4ao57FE87iEsH7bPVhOEC5P6h/bl+UQD8qidazQMRcpE3rOlAw1Qg3rWLgTauTkuu
         mYXe3RH0iSUFstR3yG/Ll4xzcl6c7UDyveCFPN3DNtbunl/NDWhfjuhwrJzByRi80rAd
         zZqQ==
X-Gm-Message-State: AFqh2krkGullWKTgV4GAUPTdXr1ZkOw+VKs8+C00pU8AW5jZFR9ukYsB
        bOyIUopc9VEw+LtQp1e8ippjtMgPs2SScUR15hT4C50n1ShRcUe2KuaEB6A+ebV43MWWHUZAi6J
        Ay0Sxp9DoAJAjGF42KtAl
X-Received: by 2002:a17:90b:1989:b0:219:f1a2:b665 with SMTP id mv9-20020a17090b198900b00219f1a2b665mr9786156pjb.5.1671769467528;
        Thu, 22 Dec 2022 20:24:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv7B5arxTkr0s2RS7gyNogNZ7TKCvV+Zp4rTfz1L9JK8wCUpHA+itk2hYbI0HMM53TWY+Hy2g==
X-Received: by 2002:a17:90b:1989:b0:219:f1a2:b665 with SMTP id mv9-20020a17090b198900b00219f1a2b665mr9786138pjb.5.1671769467304;
        Thu, 22 Dec 2022 20:24:27 -0800 (PST)
Received: from pc-zest.atmarktech (162.198.187.35.bc.googleusercontent.com. [35.187.198.162])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a8c8800b00213c7cf21c0sm1350295pjo.5.2022.12.22.20.24.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Dec 2022 20:24:26 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1p8Zbd-00H7dX-0o;
        Fri, 23 Dec 2022 13:24:25 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Daisuke Mizobuchi <mizo@atmark-techno.com>, stable@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 2/2] serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"
Date:   Fri, 23 Dec 2022 13:23:54 +0900
Message-Id: <20221223042354.4080724-2-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221223042354.4080724-1-dominique.martinet@atmark-techno.com>
References: <20221223042354.4080724-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
driver-specific way") got backported to 5.10.y, there known as
26a2b9c468de, some hunks were accidentally left out.

In serial_core.c, it is possible that the omission in
uart_suspend_port() is harmless, but the backport did have the
corresponding hunk in uart_resume_port(), it runs counter to the
original commit's intention of

  Skip any invocation of ->set_mctrl() if RS485 is enabled.

and it's certainly better to be aligned with upstream.

Link: https://lkml.kernel.org/r/20221222114414.1886632-1-linux@rasmusvillemoes.dk
Fixes: 26a2b9c468de ("serial: Deassert Transmit Enable on probe in driver-specific way")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
[the fsl_lpuart part of the 5.15 patch is not required on 5.10,
because the code before 26a2b9c468de was incorrectly not calling
uart_remove_one_port on failed_get_rs485]
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---

The part in v2 of the patch still makes sense, so here's just that for
5.10.
(I've kept Rasmus as author for the 5.10 version as well, thanks again!)


 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 605f928f0636..40fff38588d4 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2254,7 +2254,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 
 		spin_lock_irq(&uport->lock);
 		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		ops->stop_rx(uport);
 		spin_unlock_irq(&uport->lock);
 
-- 
2.35.1


