Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4496412AEB
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbhIUCD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbhIUB4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:56:44 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8EBC035478
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:43:23 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id u21so17334794qtw.8
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MjcIxwLGpuWlV5sBMWzGdiilrJIH0VyjT2mEd87OWzE=;
        b=RiEn9rJKGLRxU5L2+xMnznjxfTyP5ZQSIgKxRFIITja89c7Wcl7k/c7d6yMj2VzbQX
         uZA6XekF6rOp/38zvDKkwqdqlK0GWmXmqAqMTVcS0rulpfcCvoNIuStK1szoofmTFO3B
         pAYSgsLjkCd8l9hHFfi6NpAzSW7z1xldUKx15PN5vwCXIi0VMfvsgOE6uIzzf/fis89F
         h8FR8kAvSQNPHP+L9Xf2pOBHek6kJ5ojJKKJ/du6sJ9gN4paRsPagoU4mwJ4aFZDDVvh
         rQV0flBu8UlTkSrAMP+bfpOyansaxEEZvkh9rcO8RPnjC0qQPGdODLA8CTOgI/fT85yY
         kVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MjcIxwLGpuWlV5sBMWzGdiilrJIH0VyjT2mEd87OWzE=;
        b=SWHnKA3czJU2MRUL610W2pAZAZOLFiaLQ3DxP+mWb0hp2Nfe3MZk34X8AG+WziZ2hy
         Q4pSBvwXx0V59GZyAjotwEtnf2nRzI4bE7012KxJcWwjsMuacaIVHy/Owq/CYjXGwfpP
         ZlHAkOaed2ZTwP6qSeoeVwUa6BAjg+tW65YBlZdBKFjMeE/QFr3bqawMeQUmalONv/DW
         uzDTTxCxy15UwpRHxp418hZlxdCMOa4uo5bpbwgFo2XfkgMXAP18GjEUgASfBUWxIC3X
         j+BuEyDMRMAHTI1zNTzKJsdlj8C5bjekVnlOLdH8Z5s+QHJe02jQpZ6ekepCQqaR+S7z
         pqrA==
X-Gm-Message-State: AOAM533oyMFb8ByKpoZ4itLBa7vnDZMJq3hUKacs3DM62Pp/S2AF8he+
        IoGAoJI1OCTCZnltWm2tvKg=
X-Google-Smtp-Source: ABdhPJzmRQnelIozIxUOWEjCsnPh6xhMdv4/OWjaPEXW6cdMnKd/Aw29EH/84BWQKlxGqvxhqCL9Hg==
X-Received: by 2002:a05:622a:1350:: with SMTP id w16mr3429371qtk.354.1632181401124;
        Mon, 20 Sep 2021 16:43:21 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:504a:ec78:bbc7:c220:a982])
        by smtp.gmail.com with ESMTPSA id p10sm8312657qkk.10.2021.09.20.16.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 16:43:20 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        m.felsch@pengutronix.de, tharvey@gateworks.com,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "ARM: imx6q: drop of_platform_default_populate() from init_machine"
Date:   Mon, 20 Sep 2021 20:43:11 -0300
Message-Id: <20210920234311.682163-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit cc8870bf4c3ab0af385538460500a9d342ed945f.
 
Since commit cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate()
from init_machine") the following errors are seen on boot:

[    0.123372] imx6q_suspend_init: failed to find ocram device!
[    0.123537] imx6_pm_common_init: No DDR LPM support with suspend -19! 

, which break suspend/resume on imx6q/dl.

Revert the offeding commit to avoid the regression.

Thanks to Tim Harvey for bisecting this problem.

Cc: stable@vger.kernel.org
Fixes: cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate() from  init_machine")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/mach-imx/mach-imx6q.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 11dcc369ec14..c9d7c29d95e1 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -172,6 +172,9 @@ static void __init imx6q_init_machine(void)
 				imx_get_soc_revision());
 
 	imx6q_enet_phy_init();
+
+	of_platform_default_populate(NULL, NULL, NULL);
+
 	imx_anatop_init();
 	cpu_is_imx6q() ?  imx6q_pm_init() : imx6dl_pm_init();
 	imx6q_1588_init();
-- 
2.25.1

