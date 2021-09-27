Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9F41A10E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhI0VFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbhI0VEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:54 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A54C06176E;
        Mon, 27 Sep 2021 14:03:16 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w19so16996333pfn.12;
        Mon, 27 Sep 2021 14:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=BhgIhf3pF0/fF3D7M8SD1R2rSyzbVDt92gPENJBRZwq/gewYzqA44On2xUvcprSFYN
         XlVrTpYAArnwmAmi5q1FZpLffouCAr0wYVD7hhEprcOiQEgIitS7DWcahrZT5Q2JX16Z
         0TCweoONmXgJlN/l0rx1KWuLBvAHKcdjRj1WXKo2BSQr4d8hIg91cdDC5rMzRaAdy7O7
         tNczDAAC2BsVD2OrgEOwWfyUCntqUbYRpeg+fKc+PaVAe8hEMsX1YGBJRtMEvPO4m5UG
         +cRDVgWMlxWtRQB58F+MulTTSkWxN0ancNDlIAvPa7ySpc/BW0rgZjLOh3hJfHuY0zD8
         eFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETleUGqj8okouLW+8qnjHS0760cK4CL53iB0k0eC4GY=;
        b=aqor6bvDP8Rq5c3xh1oDbWBxbSZeBDXDiPIyXgSCY+Fr4H1vVnmtDK8r4XJNctPp+9
         GMXHGYs0rb4lKX6d/cMV1zhyXZ1TWQv+3mUt0HJeVIcE1eYdTBbWybNL3rjLlPnqaqvX
         cHfEVPg+mqJXJOOo0QMX7jGfVCui+xu8dTn9qoFJzwWmg4ItxyMHrQiD/I+Z5K4HutoN
         Hiea8QRNhgAXXxvHXzUUXrpEczG5DC3bM540gk3k9vfle8t3Df+hNHH+ul+kKDECI10H
         96e3DSYqvTWX2vdYHjR/0hiFgdTTRqXs3Yf9sLenPt8NfL34jTq+7SPDEMym/8NXR518
         zwGQ==
X-Gm-Message-State: AOAM532H7vVP84dj0SyX+xDVCaYnioLZZtHEYueLajS/YL71AgibAOsE
        KQhqbPjNNLhnfttWDJUbV/wIciw3Up0=
X-Google-Smtp-Source: ABdhPJxhcTA/oRZRlsyJvsgZ532edZsaP37vj4aJ1ceyJqTiY60SD7F5OAJw7bmpEg869ihGkD8A1w==
X-Received: by 2002:aa7:82d0:0:b0:413:5e93:2f7a with SMTP id f16-20020aa782d0000000b004135e932f7amr1938782pfn.16.1632776595564;
        Mon, 27 Sep 2021 14:03:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm19227652pgv.29.2021.09.27.14.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:03:14 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v3 4/4] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Mon, 27 Sep 2021 14:02:59 -0700
Message-Id: <20210927210259.3216965-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210259.3216965-1-f.fainelli@gmail.com>
References: <20210927210259.3216965-1-f.fainelli@gmail.com>
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

