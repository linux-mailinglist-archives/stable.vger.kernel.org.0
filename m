Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDAF4AB6FF
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 10:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241983AbiBGI5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbiBGIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:54:13 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 00:54:13 PST
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BC8C043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:54:13 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9AC3F40257
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644223450;
        bh=TJNZ+zUd3S8HoAhxtcYJss8tid7CleqrdrazIaaybsg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=qSuLgpv8gWA6Pd15Dy2HxaWHHIU2G+tsKgPWNHeAcWbdIsrcmAm2ZeavNwp2ea4KH
         wJDsb0nMMwgg+YEc6BfwyxUa90PCe0ye26YINwX59uXUatrJqxJl1BmR4kWfG0LlzN
         57g6AMqFeCWpk4sKCjX7qEPIFIXk1EsIPAY2qBjWLIkcDJOF7tuTWDCDUzZTAuiMsX
         74VhOTF0CAf2F9tm8u7kdIUpk7bbkkmmkjbY8B+MgNfA+115rhj9KTv+WRikQZLnX3
         Ert/g4mzfBXM08P+HrDviqAiEV9X12/eY1sCD0nUsZWSCKUMwq8/wBdYMzK5rE9Fsk
         EBdo6JvSUTxGg==
Received: by mail-ed1-f69.google.com with SMTP id ee7-20020a056402290700b0040f680071c9so1392212edb.9
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 00:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TJNZ+zUd3S8HoAhxtcYJss8tid7CleqrdrazIaaybsg=;
        b=Dknsi+0uimPSWvzOwjM7NvVYk6znsCLWPR17uIWrW8lnUxYt8eWrBp0pJoplOZJJ15
         iurGSXUHKlCBNuCcwij42Z7qpoKClpW6x35miMTRQ4IhD4YMF4rYYz0q9PiC6r27YDbc
         z3PitdgsJrLFHORoCrPZp4ThsM0nX+5sn17/igNkMDokw8VE5mRbh3r1rFL0ywrowvQX
         Wc9F3u8am0gm3fi31s89kohz2+9tBV9/KLMUoxcxwglNJN/ENKGBy4+E5vSnA6DlvIkn
         GI3Q9iKlwbEkiZmQq7TK3bG/Fvhv3FLX2VgPfu2OjxApSJJnKKGejZaqOVLLLRgti31y
         kpgw==
X-Gm-Message-State: AOAM5309dUUbuze1/9qXunZ2yWCEynwOJCuQ/7WQ+I8PwyuP5l589585
        y1uf53hsRhd15N554tn3BRE1aooxBv36m3SRXXtHZOu13Z5dDortHfi9mXrelrR+oBU7l2ugxeB
        NVXHT/jozNjNfT8u+pLi9IjOxt9qACMu+Cw==
X-Received: by 2002:a17:907:1c9f:: with SMTP id nb31mr9276001ejc.24.1644223450272;
        Mon, 07 Feb 2022 00:44:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxR/JRVVOHBqPXj/NpqeWB6ncqoJamzNzUx/kg+twC2HcWYf4L37Jq+4pk44F+v6qIcq4BTmA==
X-Received: by 2002:a17:907:1c9f:: with SMTP id nb31mr9275993ejc.24.1644223450061;
        Mon, 07 Feb 2022 00:44:10 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id y11sm1636935edu.2.2022.02.07.00.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 00:44:09 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Dinh Nguyen <dinguyen@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: socfpga: fix missing RESET_CONTROLLER
Date:   Mon,  7 Feb 2022 09:44:04 +0100
Message-Id: <20220207084404.212017-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SocFPGA machine since commit b3ca9888f35f ("reset: socfpga: add an
early reset driver for SoCFPGA") uses reset controller, so it should
select RESET_CONTROLLER explicitly.  Selecting ARCH_HAS_RESET_CONTROLLER
is not enough because it affects only default choice still allowing a
non-buildable configuration:

  /usr/bin/arm-linux-gnueabi-ld: arch/arm/mach-socfpga/socfpga.o: in function `socfpga_init_irq':
  arch/arm/mach-socfpga/socfpga.c:56: undefined reference to `socfpga_reset_init'

Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: b3ca9888f35f ("reset: socfpga: add an early reset driver for SoCFPGA")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm/mach-socfpga/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index 43ddec677c0b..594edf9bbea4 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -2,6 +2,7 @@
 menuconfig ARCH_INTEL_SOCFPGA
 	bool "Altera SOCFPGA family"
 	depends on ARCH_MULTI_V7
+	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
@@ -18,6 +19,7 @@ menuconfig ARCH_INTEL_SOCFPGA
 	select PL310_ERRATA_727915
 	select PL310_ERRATA_753970 if PL310
 	select PL310_ERRATA_769419
+	select RESET_CONTROLLER
 
 if ARCH_INTEL_SOCFPGA
 config SOCFPGA_SUSPEND
-- 
2.32.0

