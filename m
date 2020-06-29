Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F120D190
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgF2SmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:16 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53523 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbgF2Slw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D263B8A8;
        Mon, 29 Jun 2020 05:24:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 05:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=12ulBg
        Brho6TCB93oF1ARkXP8oUDULy9SNDYJX0ECE0=; b=AmiesVwhjXmX7IemshpDKp
        6WZnRR/KScQyFi7i1djIdD9Ir/1FMfDf4JY8u9KHGoUVKEDyD9roMha73Zp5WG0s
        yNnMYMQSpORPHrXn4sD2MeYeoh8fTtE4uDAN5e6WIYQuOJrcuu6W0xAQ1KpNJB++
        4CUWazEbALsFOGDrgmNbUI/ZtSeJHr9pst1rh5pvyC8fB2oaEuhofT3cDFCryIlV
        LcCZkfY0flrS4EdJmRBP2C5NAbueEuKvbalxYOWNIQ4a5QB7h60+H7zupBV5XY1q
        heBLzwqPU7/Fc1x/yo6lADKF3oaAZ3vEljHb2C7rEfEbKOthrwBk6G5POpqqeo2g
        ==
X-ME-Sender: <xms:NbP5Xnh3ND49oDjvYDhGfRzXKiRTLFOfHpjXSWVU0_fblXfqFkZwMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NbP5XkDKQhprGvd3Hm6GkHmzZO8FmklqGHg7MVAEkP9Adaezhnr5zg>
    <xmx:NbP5XnH1hRo4diEu_yq4b9XNVdYTSqje97it_yZx71wj3IvXu1pv6w>
    <xmx:NbP5XkRznCwXAB4yJliRPWl8wICD3lOG_1PA5ieqXJ_gpJoRdvpjug>
    <xmx:NbP5XhsFPkkYW4PxDgHTpaDHm9gDpPYPPIcei90Jw5YdzzavZYYPKrZvm50>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF1A2328005E;
        Mon, 29 Jun 2020 05:24:04 -0400 (EDT)
Subject: WTF: patch "[PATCH] efi: Make it possible to disable efivar_ssdt entirely" was seriously submitted to be applied to the 5.7-stable tree?
To:     pjones@redhat.com, ardb@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 11:23:55 +0200
Message-ID: <1593422635243184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.7-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 435d1a471598752446a72ad1201b3c980526d869 Mon Sep 17 00:00:00 2001
From: Peter Jones <pjones@redhat.com>
Date: Mon, 15 Jun 2020 16:24:08 -0400
Subject: [PATCH] efi: Make it possible to disable efivar_ssdt entirely

In most cases, such as CONFIG_ACPI_CUSTOM_DSDT and
CONFIG_ACPI_TABLE_UPGRADE, boot-time modifications to firmware tables
are tied to specific Kconfig options.  Currently this is not the case
for modifying the ACPI SSDT via the efivar_ssdt kernel command line
option and associated EFI variable.

This patch adds CONFIG_EFI_CUSTOM_SSDT_OVERLAYS, which defaults
disabled, in order to allow enabling or disabling that feature during
the build.

Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Jones <pjones@redhat.com>
Link: https://lore.kernel.org/r/20200615202408.2242614-1-pjones@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e6fc022bc87e..3939699e62fe 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -278,3 +278,14 @@ config EFI_EARLYCON
 	depends on SERIAL_EARLYCON && !ARM && !IA64
 	select FONT_SUPPORT
 	select ARCH_USE_MEMREMAP_PROT
+
+config EFI_CUSTOM_SSDT_OVERLAYS
+	bool "Load custom ACPI SSDT overlay from an EFI variable"
+	depends on EFI_VARS && ACPI
+	default ACPI_TABLE_UPGRADE
+	help
+	  Allow loading of an ACPI SSDT overlay from an EFI variable specified
+	  by a kernel command line option.
+
+	  See Documentation/admin-guide/acpi/ssdt-overlays.rst for more
+	  information.
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index edc5d36caf54..5114cae4ec97 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -189,7 +189,7 @@ static void generic_ops_unregister(void)
 	efivars_unregister(&generic_efivars);
 }
 
-#if IS_ENABLED(CONFIG_ACPI)
+#ifdef CONFIG_EFI_CUSTOM_SSDT_OVERLAYS
 #define EFIVAR_SSDT_NAME_MAX	16
 static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX] __initdata;
 static int __init efivar_ssdt_setup(char *str)

