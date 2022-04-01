Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37C34EF106
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347762AbiDAOf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348306AbiDAOdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F168B86E;
        Fri,  1 Apr 2022 07:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58128B8250D;
        Fri,  1 Apr 2022 14:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A4FC34111;
        Fri,  1 Apr 2022 14:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823518;
        bh=ByhBYzofePU6Tas8c4DovQWKKLR8w9G3c/X2fMZCPFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcW86vdqUNyfc6148X4vXlajq8712UxiPDFaLOw92U7o8DGK++qIdQU/FeqCEZjPe
         4GA5tmYYvIPyaALjq8PYxO5h3njp9OSVhxoTv2BNWY/sXEUIUbFKxC0kx7qKzNUYhX
         ZnZAtXEW59QIWWZiEVcwqB4toCd6sHp1jH6Gb7wLSmU9pp8a+tORfHUg1r36J/Q2ms
         X2X23tk67vHrQZBTBoENXKXxIx7bbZq1pLgbFXyh/ASwK1dyabSNbQPbudpD9C5Z57
         dMXn/EfWeNJ2F26QAvFXSOIqUtTpS3uHoiIHKfaqjQSUyCHYphpsRrURNdgIy3ffnB
         rcGJVE0llGogw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 126/149] platform/x86: x86-android-tablets: Depend on EFI and SPI
Date:   Fri,  1 Apr 2022 10:25:13 -0400
Message-Id: <20220401142536.1948161-126-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e8aa2aa1274953e8e595f0630436744597d0d64 ]

The recently added support for Lenovo Yoga Tablet 2 tablets uses
symbols from EFI and SPI add "depends on EFI && SPI" to the
X86_ANDROID_TABLETS Kconfig entry.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220308152942.262130-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 24deeeb29af2..53abd553b842 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1027,7 +1027,7 @@ config TOUCHSCREEN_DMI
 
 config X86_ANDROID_TABLETS
 	tristate "X86 Android tablet support"
-	depends on I2C && SERIAL_DEV_BUS && ACPI && GPIOLIB
+	depends on I2C && SPI && SERIAL_DEV_BUS && ACPI && EFI && GPIOLIB
 	help
 	  X86 tablets which ship with Android as (part of) the factory image
 	  typically have various problems with their DSDTs. The factory kernels
-- 
2.34.1

