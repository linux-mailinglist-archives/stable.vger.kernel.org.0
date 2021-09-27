Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B319941A102
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhI0VEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbhI0VEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEBAC061575;
        Mon, 27 Sep 2021 14:02:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c1so16990286pfp.10;
        Mon, 27 Sep 2021 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=kth8zCT5pd0yh7lFUIW6AiDcPQ2eBSU6lNLQd07LX32o7zuLJJ6unzMLDFo5TtS1KU
         acpZjS1vbEo65WeKkNTowTViGZl1Zt+Q3ZYlWEY5fPm3jyC8+yg08JRtimawBFkcqIsX
         HdRxZA4Px5WyQ0UbDXURYxtRcLZPqY6z3VPUsJQ61ILBD1fEzbRgaI0pIXzS3TGR3id+
         +LRswv4nzejzTb/v9BXklMieRbVppm3dnxNLIPf4BdEHdpGUUPKYMWz8HpaPl/HIRHnM
         YLxvnMQkgh3tJ/sXxZJiNITDEPp8nT6jKHeVq4gfUTD+OfnnMz1815zy6Xj187JEk0Fq
         84Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=cYFpkqBn9KhLUWmkgvSWOlp3aLmsik9EiWkh0xGGpLXnzIt68oYkcVIc6xKdeJ3XRT
         dy4S9rVhrWEY2s/41cpp1PLN9KxxGt1Zj4dx+szWbnSTX3D+Cv4gSjjFCq6UThlMjwwn
         LQoCY4BZUde4j7L8SB2xR5cv1sAy1FFepR8BdQYr/HWZyT163XZQjOTjSppBKzac6Lqu
         MGYgFIb2VA44nwQ0cOYshfMGkQnmou0lmECn+FLQ60lEGEHUo0H5aKDo9HcbYZacrYKh
         1ynh51Fro3a91eNjBhQ9LulruBNhshrbicN5fiUZv+5xzYYUivn1ikVM7hRlxSeUF9MZ
         xhUg==
X-Gm-Message-State: AOAM532IyTHH9FPsM395IPjfX9njlYgX8cTSYVAHC3vSh8KHNoL9MK5T
        6yl0NE7HuqLueZilLadwM5S4ZKE2AbA=
X-Google-Smtp-Source: ABdhPJxjOG9ZIU3qVbiLgYc0uxevcnsAj/QvebUFqDe1UJZoQX1zQs6sei/5wDFjC8H0FP0wvbXd5g==
X-Received: by 2002:a05:6a00:bcf:b0:44b:8d5c:e2dc with SMTP id x15-20020a056a000bcf00b0044b8d5ce2dcmr1949463pfu.66.1632776579053;
        Mon, 27 Sep 2021 14:02:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm310537pjg.7.2021.09.27.14.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:02:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        kernel test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.19 v3 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Mon, 27 Sep 2021 14:02:46 -0700
Message-Id: <20210927210246.3216892-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210246.3216892-1-f.fainelli@gmail.com>
References: <20210927210246.3216892-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 6fa630bf473827aee48cbf0efbbdf6f03134e890 upstream

FTRACE_ADDR is only defined when CONFIG_DYNAMIC_FTRACE is defined, the
latter is even stronger requirement than CONFIG_FUNCTION_TRACER (which is
enough for MCOUNT_ADDR).

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

Fixes: 1f12fb25c5c5d22f ("ARM: 9079/1: ftrace: Add MODULE_PLTS support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/kernel/module-plts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index 6804a145be11..ed0e09cc735f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -24,7 +24,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif
-- 
2.25.1

