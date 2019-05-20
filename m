Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD04A2379C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbfETMwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387812AbfETMTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D9F820656;
        Mon, 20 May 2019 12:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354771;
        bh=7msc1tKFakpzZ9gI2yrE7V/oN5Mph5vD65JhgljuaQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdsSu4wiYWp4YEzaJJ/sHQTr3+ql45yQWAunxl3RdkscoiSOXERTU+6ysE0WCa9iz
         hquUmBTFyjEOZug/jzJkacQdawKwblo2XP6EtefUWVksre5N0kejQYJ/Nisti9oL8S
         cVQ56YwaBieChfgPvGf4xKkA0J/f9gl5aAkrIHZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 36/63] mfd: max77620: Fix swapped FPS_PERIOD_MAX_US values
Date:   Mon, 20 May 2019 14:14:15 +0200
Message-Id: <20190520115235.210391284@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit ea611d1cc180fbb56982c83cd5142a2b34881f5c upstream.

The FPS_PERIOD_MAX_US definitions are swapped for MAX20024 and MAX77620,
fix it.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mfd/max77620.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mfd/max77620.h
+++ b/include/linux/mfd/max77620.h
@@ -136,8 +136,8 @@
 #define MAX77620_FPS_PERIOD_MIN_US		40
 #define MAX20024_FPS_PERIOD_MIN_US		20
 
-#define MAX77620_FPS_PERIOD_MAX_US		2560
-#define MAX20024_FPS_PERIOD_MAX_US		5120
+#define MAX20024_FPS_PERIOD_MAX_US		2560
+#define MAX77620_FPS_PERIOD_MAX_US		5120
 
 #define MAX77620_REG_FPS_GPIO1			0x54
 #define MAX77620_REG_FPS_GPIO2			0x55


