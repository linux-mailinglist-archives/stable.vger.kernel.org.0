Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7033E2D910A
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 23:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbgLMW4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 17:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730613AbgLMW4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Dec 2020 17:56:03 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0193DC0613CF
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 14:55:22 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r24so25539598lfm.8
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 14:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJzcPpylnKaiFhjUaTGCdHTSB4HDtxk1bXFCHW9lZ18=;
        b=UNjGuQdEso2eA+quGXUi3dqpChaI3xl6pywwJHljSQn4Amqp6x7Sd37UVYaN8iIKK1
         pD6VgfTfObaIg00FmW5G8pIySxGYjW6a/t2vk7fNNY1nPqa99PQpE3bCCuxuUY8gj85b
         +rJuSvTQ2Sd/8mzzPTfzo8iuTokluufuWvYxhx7pUSzIb8zQ7LDLbGQd2OKQXDVsG+fw
         3LG16SSkaIypmOdZN+85m1Zf5MUr2aaAt4cc6y488qm2nHO8rcg4UpgqIPTKMhrBlnDW
         jc4cSg6z1Q3U8MEgNpW0Uzs/UnIj2H6lmjZ4Xh4xMACFP+30ZMUSaxrWK5ROeF6Um7NQ
         doPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJzcPpylnKaiFhjUaTGCdHTSB4HDtxk1bXFCHW9lZ18=;
        b=am6SqJQI2ynwNZvnemXYu7cHLRMBvpF1R9Z8xGHriFvA2YxUK32eCxJXe+Dt2DEtST
         isDu7mFjeLinPcFCwVkdFSFdsio2BLVWxAn36YlxXu0hMx2dmaM/79KPi7SAJ3asO6nD
         AzB+e0Kdmz6MCyc9fLoK2RkcIszHMRKT0oJNQS4M1jpO9lFaoYVaBAZVjDITvWV2fkXv
         +0/U9itn6BSwvo+tjqIRLexNqIe8OqmC7XEVPwdQTed8fXU0VieZNHeLgEzRUGXLDZKT
         MgFt83iw1Jkr4CH6HF4ETFdU37JxrQnX2n18g4NSLWDGuNTzc3IBsceey2H3UkBBXsKh
         64Xw==
X-Gm-Message-State: AOAM5313ULjPBj8pqBdkXnJ+kensNHDNpFGtqiyXpE+LcQ9hn2ZnYtsX
        3ucuR8nrt1jY7gYI0HL4CH7Hunv+IfNLgnUO
X-Google-Smtp-Source: ABdhPJzIkRam6r3ZhdelkPNNTAZ2SBJCyzMf1RRdtAFLV12V8gU3HTlsHA6xTT5vGOz0RyAzFzXEAw==
X-Received: by 2002:a19:848f:: with SMTP id g137mr3929696lfd.622.1607900121382;
        Sun, 13 Dec 2020 14:55:21 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id q9sm1074545ljm.113.2020.12.13.14.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 14:55:20 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH] ARM: dts: ux500: Reserve memory carveouts
Date:   Sun, 13 Dec 2020 23:55:17 +0100
Message-Id: <20201213225517.3838501-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Ux500 platforms have some memory carveouts set aside for
communicating with the modem and for the initial secure software
(ISSW). These areas are protected by the memory controller
and will result in an external abort if accessed like common
read/write memory.

On the legacy boot loaders, these were set aside by using
cmdline arguments such as this:

  mem=96M@0 mem_mtrace=15M@96M mem_mshared=1M@111M
  mem_modem=16M@112M mali.mali_mem=32M@128M mem=96M@160M
  hwmem=127M@256M mem_issw=1M@383M mem_ram_console=1M@384M
  mem=638M@385M

Reserve the relevant areas in the device tree instead. The
"mali", "hwmem", "mem_ram_console" and the trailing 1MB at the
end of the memory reservations in the list are not relevant for
the upstream kernel as these are nowadays replaced with
upstream technologies such as CMA. The modem and ISSW
reservations are necessary.

This was manifested in a bug that surfaced in response to
commit 7fef431be9c9 ("mm/page_alloc: place pages to tail in __free_pages_core()")
which changes the behaviour of memory allocations
in such a way that the platform will sooner run into these
dangerous areas, with "Unhandled fault: imprecise external
abort (0xc06) at 0xb6fd83dc" or similar: the real reason
turns out to be that the PTE is pointing right into one of
the reserved memory areas. We were just lucky until now.

We need to augment the DB8500 and DB8520 SoCs similarly
and also create a new include for the DB9500 used in the
Snowball since this does not have a modem and thus does
not need the modem memory reservation, albeit it needs
the ISSW reservation.

Cc: stable@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC folks: please apply this directly for fixes.

David: just FYI if you run into more of these type of
regressions. Actually the patch is unintentionally good
at smoking out other bugs :D
---
 arch/arm/boot/dts/ste-db8500.dtsi  | 38 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-db8520.dtsi  | 38 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-db9500.dtsi  | 35 +++++++++++++++++++++++++++
 arch/arm/boot/dts/ste-snowball.dts |  2 +-
 4 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/ste-db9500.dtsi

diff --git a/arch/arm/boot/dts/ste-db8500.dtsi b/arch/arm/boot/dts/ste-db8500.dtsi
index d309fad32229..344d29853bf7 100644
--- a/arch/arm/boot/dts/ste-db8500.dtsi
+++ b/arch/arm/boot/dts/ste-db8500.dtsi
@@ -12,4 +12,42 @@ cpu@300 {
 					    200000 0>;
 		};
 	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Modem trace memory */
+		ram@06000000 {
+			reg = <0x06000000 0x00f00000>;
+			no-map;
+		};
+
+		/* Modem shared memory */
+		ram@06f00000 {
+			reg = <0x06f00000 0x00100000>;
+			no-map;
+		};
+
+		/* Modem private memory */
+		ram@07000000 {
+			reg = <0x07000000 0x01000000>;
+			no-map;
+		};
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/ste-db8520.dtsi b/arch/arm/boot/dts/ste-db8520.dtsi
index 48bd8728ae27..287804e9e183 100644
--- a/arch/arm/boot/dts/ste-db8520.dtsi
+++ b/arch/arm/boot/dts/ste-db8520.dtsi
@@ -12,4 +12,42 @@ cpu@300 {
 					    200000 0>;
 		};
 	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Modem trace memory */
+		ram@06000000 {
+			reg = <0x06000000 0x00f00000>;
+			no-map;
+		};
+
+		/* Modem shared memory */
+		ram@06f00000 {
+			reg = <0x06f00000 0x00100000>;
+			no-map;
+		};
+
+		/* Modem private memory */
+		ram@07000000 {
+			reg = <0x07000000 0x01000000>;
+			no-map;
+		};
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/ste-db9500.dtsi b/arch/arm/boot/dts/ste-db9500.dtsi
new file mode 100644
index 000000000000..0afff703191c
--- /dev/null
+++ b/arch/arm/boot/dts/ste-db9500.dtsi
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "ste-dbx5x0.dtsi"
+
+/ {
+	cpus {
+		cpu@300 {
+			/* cpufreq controls */
+			operating-points = <1152000 0
+					    800000 0
+					    400000 0
+					    200000 0>;
+		};
+	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * Initial Secure Software ISSW memory
+		 *
+		 * This is probably only used if the kernel tries
+		 * to actually call into trustzone to run secure
+		 * applications, which the mainline kernel probably
+		 * will not do on this old chipset. But you can never
+		 * be too careful, so reserve this memory anyway.
+		 */
+		ram@17f00000 {
+			reg = <0x17f00000 0x00100000>;
+			no-map;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index be90e73c923e..27d8a07718a0 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -4,7 +4,7 @@
  */
 
 /dts-v1/;
-#include "ste-db8500.dtsi"
+#include "ste-db9500.dtsi"
 #include "ste-href-ab8500.dtsi"
 #include "ste-href-family-pinctrl.dtsi"
 
-- 
2.26.2

