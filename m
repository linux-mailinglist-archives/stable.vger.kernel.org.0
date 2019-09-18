Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381DBB6493
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfIRNe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:34:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34886 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfIRNe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:34:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so3203211plp.2
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 06:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=JFjlCZPkcdlA2GptrLxkPctYar5WORcZMXU0bqpvnXo=;
        b=Mpvv8PYUGN65gaM7+AUGeSKaK4xXryqmjh7sVL21ffKJsArXEjQJaFfrKwLVmMzF3A
         wZMYswGKsYyEXKGiuYfTIJMX9mT8kXwuCAzkMqmD7L0VdwuWhMeQRv1al3u+uS2497oW
         O4okdf4mEBnfASJcelmAdGXkMC375H8gqjaQykbj9frOJuLhsEshjpyGsXdScsJnVJg9
         XcyJOQtVkztEbt5JsGIQv209nUMZftQX+wMCpXEyh4DI3cVq1sjYNedFtoCeTT12UPkg
         xmwzcl74gjnfPeBwela+xd3vodX1iSfd00vmR7s0Pno3ZuH26f7DA4aX7F2qTkct+4Oe
         RuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=JFjlCZPkcdlA2GptrLxkPctYar5WORcZMXU0bqpvnXo=;
        b=t1cr8CA8i2FbHRSXEaJMmwp7UzxQM/Wf3vCkiQCZXuIMSRs5ETfH7x9EAUQJT4OXyg
         HEWhLekIYIx41R73qmfzaNNwUyaD2trqsZSrBow8iDWm4/xPbCwvW7XcaKQvhJpBZCSP
         uhD/jnYN2EM280NAJEmhMkxBQjkRCB6uwRBf8rZlwHRw9sIAkH4wIifHh7ay79XROFla
         e3st/Sb8CmWRr/5LmW7mipVKU0MUnON5q8ZqttFNv+i40q0m0PPr/zCHmULWfQnw7sT8
         yMq6OkCfzGmoN4+T+qi0L+bOT5SNEGYwlYbFgTo/8XySDJc9LOqhWUU/upKPMaCPd/jh
         CqQw==
X-Gm-Message-State: APjAAAXei5ehnbyGQuUfI83PWiIh9u2GTjxGuhvHYdYEAZ4g4AU8bFWE
        akYQEbsDSaPBl25Dh2vBOBk=
X-Google-Smtp-Source: APXvYqxg0DTsK4y1mEZrTM5LyMl8XnFh69EYfgFB4cNrKBXNqIUD9G59NBErQkejWj4iJlmG7iEa6g==
X-Received: by 2002:a17:902:7002:: with SMTP id y2mr4272599plk.303.1568813666313;
        Wed, 18 Sep 2019 06:34:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h8sm6735487pfo.64.2019.09.18.06.34.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 06:34:25 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.4] ARC: configs: Remove CONFIG_INITRAMFS_SOURCE from defconfigs
Date:   Wed, 18 Sep 2019 06:34:23 -0700
Message-Id: <20190918133423.17639-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>

commit 64234961c145606b36eaa82c47b11be842b21049 upstream.

We used to have pre-set CONFIG_INITRAMFS_SOURCE with local path
to intramfs in ARC defconfigs. This was quite convenient for
in-house development but not that convenient for newcomers
who obviusly don't have folders like "arc_initramfs" next to
the Linux source tree. Which leads to quite surprising failure
of defconfig building:
------------------------------->8-----------------------------
  ../scripts/gen_initramfs_list.sh: Cannot open '../../arc_initramfs_hs/'
../usr/Makefile:57: recipe for target 'usr/initramfs_data.cpio.gz' failed
make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
------------------------------->8-----------------------------

So now when more and more people start to deal with our defconfigs
let's make their life easier with removal of CONFIG_INITRAMFS_SOURCE.

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: stable@vger.kernel.org

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
[backport: Fix context conflicts, drop non-existing configuration files]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This patch fixes various build errors observed at kernelci.

 arch/arc/configs/axs101_defconfig          | 1 -
 arch/arc/configs/axs103_defconfig          | 1 -
 arch/arc/configs/axs103_smp_defconfig      | 1 -
 arch/arc/configs/nsim_700_defconfig        | 1 -
 arch/arc/configs/nsim_hs_defconfig         | 1 -
 arch/arc/configs/nsim_hs_smp_defconfig     | 1 -
 arch/arc/configs/nsimosci_defconfig        | 1 -
 arch/arc/configs/nsimosci_hs_defconfig     | 1 -
 arch/arc/configs/nsimosci_hs_smp_defconfig | 1 -
 9 files changed, 9 deletions(-)

diff --git a/arch/arc/configs/axs101_defconfig b/arch/arc/configs/axs101_defconfig
index 3023f91c77c2..9843e52bbb13 100644
--- a/arch/arc/configs/axs101_defconfig
+++ b/arch/arc/configs/axs101_defconfig
@@ -11,7 +11,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs/"
 CONFIG_EMBEDDED=y
 CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/arc/configs/axs103_defconfig b/arch/arc/configs/axs103_defconfig
index f18107185f53..27c6cb573686 100644
--- a/arch/arc/configs/axs103_defconfig
+++ b/arch/arc/configs/axs103_defconfig
@@ -11,7 +11,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../../arc_initramfs_hs/"
 CONFIG_EMBEDDED=y
 CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/arc/configs/axs103_smp_defconfig b/arch/arc/configs/axs103_smp_defconfig
index 6e1dd8521d2a..72f34534983f 100644
--- a/arch/arc/configs/axs103_smp_defconfig
+++ b/arch/arc/configs/axs103_smp_defconfig
@@ -11,7 +11,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../../arc_initramfs_hs/"
 CONFIG_EMBEDDED=y
 CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/arc/configs/nsim_700_defconfig b/arch/arc/configs/nsim_700_defconfig
index 86e5a62556a8..c93370cc840a 100644
--- a/arch/arc/configs/nsim_700_defconfig
+++ b/arch/arc/configs/nsim_700_defconfig
@@ -11,7 +11,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs/"
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/arc/configs/nsim_hs_defconfig b/arch/arc/configs/nsim_hs_defconfig
index f68838e8068a..27c73028b798 100644
--- a/arch/arc/configs/nsim_hs_defconfig
+++ b/arch/arc/configs/nsim_hs_defconfig
@@ -12,7 +12,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs_hs/"
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/arc/configs/nsim_hs_smp_defconfig b/arch/arc/configs/nsim_hs_smp_defconfig
index 96bd1c20fb0b..c3605874487b 100644
--- a/arch/arc/configs/nsim_hs_smp_defconfig
+++ b/arch/arc/configs/nsim_hs_smp_defconfig
@@ -9,7 +9,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs_hs/"
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/arc/configs/nsimosci_defconfig b/arch/arc/configs/nsimosci_defconfig
index a4d7b919224a..b7dbb20cd28b 100644
--- a/arch/arc/configs/nsimosci_defconfig
+++ b/arch/arc/configs/nsimosci_defconfig
@@ -12,7 +12,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs/"
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/arc/configs/nsimosci_hs_defconfig b/arch/arc/configs/nsimosci_hs_defconfig
index b3fb49c8bd14..ce22594bb0c7 100644
--- a/arch/arc/configs/nsimosci_hs_defconfig
+++ b/arch/arc/configs/nsimosci_hs_defconfig
@@ -12,7 +12,6 @@ CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs_hs/"
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/arc/configs/nsimosci_hs_smp_defconfig b/arch/arc/configs/nsimosci_hs_smp_defconfig
index 710c167bbdd8..f9e5aef7e04e 100644
--- a/arch/arc/configs/nsimosci_hs_smp_defconfig
+++ b/arch/arc/configs/nsimosci_hs_smp_defconfig
@@ -9,7 +9,6 @@ CONFIG_IKCONFIG_PROC=y
 # CONFIG_UTS_NS is not set
 # CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_INITRAMFS_SOURCE="../arc_initramfs_hs/"
 # CONFIG_COMPAT_BRK is not set
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
-- 
2.17.1

