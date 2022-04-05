Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20074F2E14
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiDEJDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiDEIRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9912A6948F;
        Tue,  5 Apr 2022 01:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB42AB81B18;
        Tue,  5 Apr 2022 08:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A45C385A0;
        Tue,  5 Apr 2022 08:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145958;
        bh=iv1kBfVa6k9z7IeqmAd0Oj3LUlWaENspS4p26LDfOl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGyQjFTHA+ccAF2LKbCM7pnfgOARICGDx4nksW4nnh6pwLR49+xjKRG6Cl7Wk9nP0
         BgMfmVeX+7xOP4W483gp7kDOsfbjzFaha6T4X3Fghw29rwU1VCLPMpywBZL3fIr2pW
         /x/Biho0p/omHnLxTdglQA7JDhRToSgdCeBKANtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0553/1126] cxl/core/port: Rename bus.c to port.c
Date:   Tue,  5 Apr 2022 09:21:40 +0200
Message-Id: <20220405070423.865113800@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 0ff0af18216436d0151af4e410400c7a19ca9437 ]

Given it is dominated by port infrastructure, and will only acquire
more, rename bus.c to port.c.

Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Link: https://lore.kernel.org/r/164298416136.3018233.15442880970000855425.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/cxl/memory-devices.rst | 4 ++--
 drivers/cxl/core/Makefile                       | 2 +-
 drivers/cxl/core/{bus.c => port.c}              | 0
 tools/testing/cxl/Kbuild                        | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/cxl/core/{bus.c => port.c} (100%)

diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index 3b8f41395f6b..c8f7a16cd0e3 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -36,10 +36,10 @@ CXL Core
 .. kernel-doc:: drivers/cxl/cxl.h
    :internal:
 
-.. kernel-doc:: drivers/cxl/core/bus.c
+.. kernel-doc:: drivers/cxl/core/port.c
    :doc: cxl core
 
-.. kernel-doc:: drivers/cxl/core/bus.c
+.. kernel-doc:: drivers/cxl/core/port.c
    :identifiers:
 
 .. kernel-doc:: drivers/cxl/core/pmem.c
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 40ab50318daf..a90202ac88d2 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_CXL_BUS) += cxl_core.o
 
 ccflags-y += -I$(srctree)/drivers/cxl
-cxl_core-y := bus.o
+cxl_core-y := port.o
 cxl_core-y += pmem.o
 cxl_core-y += regs.o
 cxl_core-y += memdev.o
diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/port.c
similarity index 100%
rename from drivers/cxl/core/bus.c
rename to drivers/cxl/core/port.c
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 1acdf2fc31c5..3299fb0977b2 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -25,7 +25,7 @@ cxl_pmem-y += config_check.o
 
 obj-m += cxl_core.o
 
-cxl_core-y := $(CXL_CORE_SRC)/bus.o
+cxl_core-y := $(CXL_CORE_SRC)/port.o
 cxl_core-y += $(CXL_CORE_SRC)/pmem.o
 cxl_core-y += $(CXL_CORE_SRC)/regs.o
 cxl_core-y += $(CXL_CORE_SRC)/memdev.o
-- 
2.34.1



