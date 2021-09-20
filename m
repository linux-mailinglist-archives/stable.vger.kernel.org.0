Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F6412105
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350794AbhITSBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356223AbhITR66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0C306121E;
        Mon, 20 Sep 2021 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158117;
        bh=mD3Y1Swba7p5OKXN7LUcqKT8n4nkWOLGJ60OQ7oHtKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnbdwVFeOkJ5o+8aPK8udc+g/EGJ9aPdAlLvRimpuLdlP+nGLNFN4IPIWSGX683oc
         v8p1e3kg1GE64sRYoSziFx8zgwvhHQxq1msajNPld4PkPC3+fjdaU0UEzErlHrG3jt
         D5gxncDX+/fji6sH0SZ9BaJ0VKmkSOcFkkrpcnmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Bambura <jenneron@protonmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 001/260] rtc: tps65910: Correct driver module alias
Date:   Mon, 20 Sep 2021 18:40:19 +0200
Message-Id: <20210920163931.174169698@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -460,6 +460,6 @@ static struct platform_driver tps65910_r
 };
 
 module_platform_driver(tps65910_rtc_driver);
-MODULE_ALIAS("platform:rtc-tps65910");
+MODULE_ALIAS("platform:tps65910-rtc");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL");


