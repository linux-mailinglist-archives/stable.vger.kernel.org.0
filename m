Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DE49E9CD
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244952AbiA0SKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47058 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbiA0SJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0434161D00;
        Thu, 27 Jan 2022 18:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77FEC340E4;
        Thu, 27 Jan 2022 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306989;
        bh=+FWXiszUeksTbgAqjRCIYjRqShTt5d5rJhmS/5F/rNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrKpFSh+AGnymOLZzTh2CBc1xSVty2lgJltKkjOzvYEbsOnwP/6nf824XWrCL58P4
         qPIj/WtSlXcdSOza144Hozvx8UMicpS2eNjXuY1CHBfPN88wUEWjNQ/9qItRRCZ6Vc
         7BZwvHxg8y8+7uwpeaFlSJi0ucl+SXkWaB5sYq3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 03/11] pinctrl: bcm2835: Drop unused define
Date:   Thu, 27 Jan 2022 19:09:04 +0100
Message-Id: <20220127180258.472150189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit be30d5de0a5a52c6ee2cc453a51301037ab94aa upstream

There is no usage for this define, so drop it.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1580148908-4863-2-git-send-email-stefan.wahren@i2se.com
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -40,9 +40,6 @@
 #define BCM2835_NUM_BANKS 2
 #define BCM2835_NUM_IRQS  3
 
-#define BCM2835_PIN_BITMAP_SZ \
-	DIV_ROUND_UP(BCM2835_NUM_GPIOS, sizeof(unsigned long) * 8)
-
 /* GPIO register offsets */
 #define GPFSEL0		0x0	/* Function Select */
 #define GPSET0		0x1c	/* Pin Output Set */


