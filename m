Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1AB4FD662
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353731AbiDLHvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357157AbiDLHjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9834213DD3;
        Tue, 12 Apr 2022 00:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A80B81B62;
        Tue, 12 Apr 2022 07:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A3AC385A8;
        Tue, 12 Apr 2022 07:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747584;
        bh=P982WA0OnbBbtgqrPXIZFhga1DDONaAzPMFsDGWMByU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faNa/+ek7w+2VRuRhtJDv+1t0+vZsR0CXrdmCNQzUPVtwtITTP/I6YBWH494gWf7y
         JFOldUOngfFnq0b9P92/s8NHVnRV7AaEwC/8cLeNR36l/A6RFZBws4mlIsLgSSm/eV
         UamVJr/OwDG0oKOZMzab969uOyqBAAIOkDYBQ46k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 132/343] platform/x86: x86-android-tablets: Depend on EFI and SPI
Date:   Tue, 12 Apr 2022 08:29:10 +0200
Message-Id: <20220412062955.193655986@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
2.35.1



