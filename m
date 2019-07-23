Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0E715C6
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbfGWKLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:11:50 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35093 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731433AbfGWKLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:11:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 135355D2;
        Tue, 23 Jul 2019 06:11:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NOFEA4
        YYU3rRkRs0AC3CZ/dgIxvVZbHqpqcKS6jUP94=; b=MC0RGptQdcVo1W3es/WQsm
        +VZ+CavDEJMCs9OYVJXMVBRtLR18EMQamM9JnQIHAhe0WhwYVHhyGrdp98nhcake
        0Otc00CCuOPT13o6qdpY+Q9leZDUwmjKJhpfzSX8CCNnsypXQTBRoQuKH2hHwimp
        SLBJsjZeUb7vnPqdZX3NN4tQXDfnj67YPBiFCsLb85XsQcjoCks6hEiw/bNTf9YJ
        eVvAGkgVkuljArjeJl8xau3NojlIBlXshsNliHpIFMQTyPibztka8B+nYcmuj6zb
        taeeDk4LtP4R+RiSg362uJf/fNtfnvNHJEVauCSXc0VEiyCtivpSMeKKx7fbC1Eg
        ==
X-ME-Sender: <xms:ZN02XdCoDhAYSW8S_txfkfIhpIfAayI1mo_KIzPk_HTgYGasn-sDUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:ZN02XT13a8HOp_iQ7eLfizcl0XOQSlXG_Aaz29-x6v7-gKRx3K9kdQ>
    <xmx:ZN02XSkahT0OhlnvSOUJlXKOfObwDMUC9lWETd-bZaKlxAJ3Y7BcKg>
    <xmx:ZN02XVnjYIyMgLsYucUWHyXbBdkDelKNLhd5nzYoMWnk9zS8QVcsoQ>
    <xmx:ZN02XRUScXkQR5VeLldE3fqHoYUjIOcChQEWy-CtGz07nnMy06AJdQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 297F1380074;
        Tue, 23 Jul 2019 06:11:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kconfig: fix missing choice values in auto.conf" failed to apply to 4.19-stable tree
To:     yamada.masahiro@socionext.com, joonas.kylmala@iki.fi,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:11:45 +0200
Message-ID: <156387670510932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e2442a5f86e1f77b86401fce274a7f622740bc4 Mon Sep 17 00:00:00 2001
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 12 Jul 2019 15:07:09 +0900
Subject: [PATCH] kconfig: fix missing choice values in auto.conf
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 00c864f8903d ("kconfig: allow all config targets to write
auto.conf if missing"), Kconfig creates include/config/auto.conf in the
defconfig stage when it is missing.

Joonas Kylmälä reported incorrect auto.conf generation under some
circumstances.

To reproduce it, apply the following diff:

|  --- a/arch/arm/configs/imx_v6_v7_defconfig
|  +++ b/arch/arm/configs/imx_v6_v7_defconfig
|  @@ -345,14 +345,7 @@ CONFIG_USB_CONFIGFS_F_MIDI=y
|   CONFIG_USB_CONFIGFS_F_HID=y
|   CONFIG_USB_CONFIGFS_F_UVC=y
|   CONFIG_USB_CONFIGFS_F_PRINTER=y
|  -CONFIG_USB_ZERO=m
|  -CONFIG_USB_AUDIO=m
|  -CONFIG_USB_ETH=m
|  -CONFIG_USB_G_NCM=m
|  -CONFIG_USB_GADGETFS=m
|  -CONFIG_USB_FUNCTIONFS=m
|  -CONFIG_USB_MASS_STORAGE=m
|  -CONFIG_USB_G_SERIAL=m
|  +CONFIG_USB_FUNCTIONFS=y
|   CONFIG_MMC=y
|   CONFIG_MMC_SDHCI=y
|   CONFIG_MMC_SDHCI_PLTFM=y

And then, run:

$ make ARCH=arm mrproper imx_v6_v7_defconfig

You will see CONFIG_USB_FUNCTIONFS=y is correctly contained in the
.config, but not in the auto.conf.

Please note drivers/usb/gadget/legacy/Kconfig is included from a choice
block in drivers/usb/gadget/Kconfig. So USB_FUNCTIONFS is a choice value.

This is probably a similar situation described in commit beaaddb62540
("kconfig: tests: test defconfig when two choices interact").

When sym_calc_choice() is called, the choice symbol forgets the
SYMBOL_DEF_USER unless all of its choice values are explicitly set by
the user.

The choice symbol is given just one chance to recall it because
set_all_choice_values() is called if SYMBOL_NEED_SET_CHOICE_VALUES
is set.

When sym_calc_choice() is called again, the choice symbol forgets it
forever, since SYMBOL_NEED_SET_CHOICE_VALUES is a one-time aid.
Hence, we cannot call sym_clear_all_valid() again and again.

It is crazy to repeat set and unset of internal flags. However, we
cannot simply get rid of "sym->flags &= flags | ~SYMBOL_DEF_USER;"
Doing so would re-introduce the problem solved by commit 5d09598d488f
("kconfig: fix new choices being skipped upon config update").

To work around the issue, conf_write_autoconf() stopped calling
sym_clear_all_valid().

conf_write() must be changed accordingly. Currently, it clears
SYMBOL_WRITE after the symbol is written into the .config file. This
is needed to prevent it from writing the same symbol multiple times in
case the symbol is declared in two or more locations. I added the new
flag SYMBOL_WRITTEN, to track the symbols that have been written.

Anyway, this is a cheesy workaround in order to suppress the issue
as far as defconfig is concerned.

Handling of choices is totally broken. sym_clear_all_valid() is called
every time a user touches a symbol from the GUI interface. To reproduce
it, just add a new symbol drivers/usb/gadget/legacy/Kconfig, then touch
around unrelated symbols from menuconfig. USB_FUNCTIONFS will disappear
from the .config file.

I added the Fixes tag since it is more fatal than before. But, this
has been broken since long long time before, and still it is.
We should take a closer look to fix this correctly somehow.

Fixes: 00c864f8903d ("kconfig: allow all config targets to write auto.conf if missing")
Cc: linux-stable <stable@vger.kernel.org> # 4.19+
Reported-by: Joonas Kylmälä <joonas.kylmala@iki.fi>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Joonas Kylmälä <joonas.kylmala@iki.fi>

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 501fdcc5e999..1134892599da 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -895,7 +895,8 @@ int conf_write(const char *name)
 				     "# %s\n"
 				     "#\n", str);
 			need_newline = false;
-		} else if (!(sym->flags & SYMBOL_CHOICE)) {
+		} else if (!(sym->flags & SYMBOL_CHOICE) &&
+			   !(sym->flags & SYMBOL_WRITTEN)) {
 			sym_calc_value(sym);
 			if (!(sym->flags & SYMBOL_WRITE))
 				goto next;
@@ -903,7 +904,7 @@ int conf_write(const char *name)
 				fprintf(out, "\n");
 				need_newline = false;
 			}
-			sym->flags &= ~SYMBOL_WRITE;
+			sym->flags |= SYMBOL_WRITTEN;
 			conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);
 		}
 
@@ -1063,8 +1064,6 @@ int conf_write_autoconf(int overwrite)
 	if (!overwrite && is_present(autoconf_name))
 		return 0;
 
-	sym_clear_all_valid();
-
 	conf_write_dep("include/config/auto.conf.cmd");
 
 	if (conf_touch_deps())
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 8dde65bc3165..017843c9a4f4 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -141,6 +141,7 @@ struct symbol {
 #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
 #define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
 #define SYMBOL_CHANGED    0x0400  /* ? */
+#define SYMBOL_WRITTEN    0x0800  /* track info to avoid double-write to .config */
 #define SYMBOL_NO_WRITE   0x1000  /* Symbol for internal use only; it will not be written */
 #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
 #define SYMBOL_WARNED     0x8000  /* warning has been issued */

