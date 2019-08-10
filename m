Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709CB88BF2
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfHJPma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 11:42:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34133 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfHJPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 11:42:30 -0400
Received: by mail-qt1-f193.google.com with SMTP id q4so1647176qtp.1;
        Sat, 10 Aug 2019 08:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mwsS2ZsTKCEtenoWuLBWP+hTnBEfiLyyggIfIFvVfjw=;
        b=KVFKwVwGAdQ+rlpFo+lKcwVU52kK/iIaZbeoc5J5G6kWJ26LTiNn7FnkgAlYvw3BMc
         dEKihvAHwF//CJSl3JHPH/YzNuyRNGyHOl+MNTnA+0R4CPY+sFEmyFDoLZ1bF7RkV3GW
         McIpYbMvnxiNiiIFONCAHeM2CHN04N4D4BJCLUPWjmwAELs0Wkln4N37zO5/A0x2rExi
         2Z5VW99XUq3ojHNU0apfbPe3TdnMBJo2a5fQk6Z1PORA5aes8CMmweFuGSm4LgU7n0n3
         owo1End+3d9KiTiZkBLy86T6p5k6JLpbOXHOOxVdM4VNpvmaNInSz9DhSzXPCo/IArw0
         53EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mwsS2ZsTKCEtenoWuLBWP+hTnBEfiLyyggIfIFvVfjw=;
        b=HeBZSoNhNiwtbYXD9cIgWBnbuvX2zj1xtZ6nKLZYLlKKwqS50m/hmuiChmhIqKf132
         k7WmnXyLa7dKnGfkId6mHFDTP4Eciw2BpXpfW7Q+LAD3Q3lW38owFqeGpDvpSAbUbVCj
         7xMWJYf2fY5pKuIXQN5ix1W3TmzL6tqybHoV5tCOyCWyHftTTjsVvOnlJBbauNyy46Va
         DfzHX0MaLJWuCAsbx4KuAUXCTx0T6/OQLE7D1GZMkWngG5v9h5BWAD5EFidzRToJfhsg
         GVr8CCndPte8aRiBBVQXZs6PHNRBQEeEtRtcQLm7ObGlVkFtSb435WdoKPdY6rHcASgB
         /Kfg==
X-Gm-Message-State: APjAAAWq7Y5R8ahgtIOlMIT/eyLdmRhexRrGngvFIhx7bVk1hKxq6e14
        gGJZE/AvJRV6Wys142VmoYo=
X-Google-Smtp-Source: APXvYqwm8IwMbT3NuhKV33K5D8G/9g0qt/WXx7uhs1Ot7wh+CR+mBOcFhf1tzXBgVzMLx19EZ8PBCQ==
X-Received: by 2002:a0c:8690:: with SMTP id 16mr23713158qvf.228.1565451749188;
        Sat, 10 Aug 2019 08:42:29 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([2804:14c:482:22a::1])
        by smtp.gmail.com with ESMTPSA id o50sm16534808qtj.17.2019.08.10.08.42.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 08:42:28 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, andrew.smirnov@gmail.com,
        cphealy@gmail.com, l.stach@pengutronix.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/2] mfd: rave-sp: Bump command timeout to 5 seconds
Date:   Sat, 10 Aug 2019 12:42:59 -0300
Message-Id: <20190810154300.25950-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

Command to erase application firmware on RAVE SP takes longer than one
second (it takes ~3s). Bump command timeout duration to 5 seconds in
order to avoid bogus timeouts.

Cc: <stable@vger.kernel.org>
Fixes: 538ee27290fa ("mfd: Add driver for RAVE Supervisory Processor")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/mfd/rave-sp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rave-sp.c b/drivers/mfd/rave-sp.c
index 26c7b63e008a..546763d8a3e5 100644
--- a/drivers/mfd/rave-sp.c
+++ b/drivers/mfd/rave-sp.c
@@ -371,7 +371,7 @@ int rave_sp_exec(struct rave_sp *sp,
 
 	rave_sp_write(sp, data, data_size);
 
-	if (!wait_for_completion_timeout(&reply.received, HZ)) {
+	if (!wait_for_completion_timeout(&reply.received, 5 * HZ)) {
 		dev_err(&sp->serdev->dev, "Command timeout\n");
 		ret = -ETIMEDOUT;
 
