Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD85411A8C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbhITQuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244154AbhITQtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7A7B611AE;
        Mon, 20 Sep 2021 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156465;
        bh=pnj+i46sPGEq1JTAZMpVNBwQm4VbW67pGIAfAs2Ew3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDKlyEJUqXxinPFVZT3urgSMCWcs2i+RBttBcDY+rd3IwGoeDrznTJsR7SNM1S2Dj
         FEqYUIRa1VsaK9zS0DuYwdMk0pqfV2/XhVe+rxT6Hr0eyodqrSAJcvvlXpXFblmzwt
         qGekRkyRMg7XrFsL6toEA7+/bhLMPQTy6/dqKEpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Bambura <jenneron@protonmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.4 072/133] rtc: tps65910: Correct driver module alias
Date:   Mon, 20 Sep 2021 18:42:30 +0200
Message-Id: <20210920163915.002282517@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 8d448fa0a8bb1c8d94eef7647edffe9ac81a281e upstream.

The TPS65910 RTC driver module doesn't auto-load because of the wrong
module alias that doesn't match the device name, fix it.

Cc: stable@vger.kernel.org
Reported-by: Anton Bambura <jenneron@protonmail.com>
Tested-by: Anton Bambura <jenneron@protonmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210808160030.8556-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -332,6 +332,6 @@ static struct platform_driver tps65910_r
 };
 
 module_platform_driver(tps65910_rtc_driver);
-MODULE_ALIAS("platform:rtc-tps65910");
+MODULE_ALIAS("platform:tps65910-rtc");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL");


