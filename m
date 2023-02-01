Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B366686D4A
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 18:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjBARoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 12:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjBARoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 12:44:23 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23AF86A9;
        Wed,  1 Feb 2023 09:44:22 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id bb40so10326105qtb.2;
        Wed, 01 Feb 2023 09:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAlxWpOyE8wRsJOXBCXiv/nkAGyEl3lqtZ+cp+0vZ6c=;
        b=VFb8UYsu27ate0K8pAh48CNR3pqQhmRGgiSyBDRK0lzMpMUsrcVnUpLiSKGsialNLV
         /rFkNSg9fYlJxkOJG/qdY29EY/pR5c39wYsP1tVdE1Im55dztHN27Xh0jTe7enyE/AsQ
         Ls6q+ANEVBUhgHHC18NLip8YeBO7ZGHdaSjqexvxrSdmwl5LGTSzmXPHlEqR05KJS1dP
         y7MJzd7sHXtqxWKrAVeB6KXfAsqA316biylGwtFkrwdShf3EtRX9IoIPKjNQntGGeXEF
         7zbWDF97IwaTdc+Km4U3T8LUNKoY9B4tyJQaMyHtxSW1k1/NlhGypoGONjsoU7lAvFfz
         gRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAlxWpOyE8wRsJOXBCXiv/nkAGyEl3lqtZ+cp+0vZ6c=;
        b=hBoJKQ0XulTdWdlYGG46kJFSocZA6vF3enhH637PHJkgAZ6EPFDT2v3zu0riwcwxEL
         CFELg5CNW3ft7SJ/DjruWWNQdC88yS2rBh9sJFBcoPAKxnp7elwyzKC6PFR4Q2hsfYaP
         1Jl9zdbKM96cElJFRiAAQnivPQYebOqhIIAn5kcbhjEvVKHZ1vVYNG8d5nBTq69tbHVt
         6fK8Omx/oOUckjoCZ+1YQGntmSiknd9euakIp+p9/0h1F8/l5JXVy5dk5Tn7tVK6HFbK
         1WNPRrc5+0H2tkr8mlHFxjbktLJWTbhhj7SYxa4NkfEuDMgbPxSEC8l0Wc9ABPjQIVtP
         LoFQ==
X-Gm-Message-State: AO0yUKW4cqWePyuDpIYTmkjJHr5NXo62skYcmlumpT2F5dK2BNUnrBvQ
        XyKRdTq8dJwgVO258/pJdtriVrn+zFMqkQ==
X-Google-Smtp-Source: AK7set+QbyAcgXy8WrKOyJRLFrf+LvOGfIhSPA8/MmWZSwkSBalSbo/WwY3bOQuvcpdF5twAPvdYYg==
X-Received: by 2002:a05:622a:130b:b0:3a8:2f65:6ccb with SMTP id v11-20020a05622a130b00b003a82f656ccbmr5619884qtk.65.1675273461541;
        Wed, 01 Feb 2023 09:44:21 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f23-20020ac80157000000b003b868cdc689sm6681784qtg.5.2023.02.01.09.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 09:44:19 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        linux-usb@vger.kernel.org (open list:USB XHCI DRIVER)
Subject: [PATCH stable 4.19] usb: host: xhci-plat: add wakeup entry at sysfs
Date:   Wed,  1 Feb 2023 09:44:03 -0800
Message-Id: <20230201174404.32777-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201174404.32777-1-f.fainelli@gmail.com>
References: <20230201174404.32777-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit  4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream

With this change, there will be a wakeup entry at /sys/../power/wakeup,
and the user could use this entry to choose whether enable xhci wakeup
features (wake up system from suspend) or not.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index adc437ca83b8..cb3ba2adae64 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -261,7 +261,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->clk = clk;
 	xhci->reg_clk = reg_clk;
-- 
2.34.1

