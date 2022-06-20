Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413095511D9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiFTHvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbiFTHvo (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52810540
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C89B4B80EB5
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244EEC3411B;
        Mon, 20 Jun 2022 07:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711501;
        bh=FWneyhzLb551Iiqb6ThF8o3W4fEs1K4B0M9efLtHx6k=;
        h=Subject:To:From:Date:From;
        b=B1rRhdEjQY4YIXxWljVCT7m0P3URY+HJ3tMX3NVk9jr6a6qGgBfwutpUOVzf4wiTB
         9ZgyIATvzmA7IG3IbLfgwZojH7eqb05uhr5/pFbel6M/SrQ5YgcIUWwb6j18GTRjpj
         XDwju7BGrPWJ/b3fNECVQJLmipmrthjnIeCegOnc=
Subject: patch "iio: test: fix missing MODULE_LICENSE for IIO_RESCALE=m" added to char-misc-linus
To:     liambeguin@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, masahiroy@kernel.org, rdunlap@infradead.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:48 +0200
Message-ID: <1655711448239249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: test: fix missing MODULE_LICENSE for IIO_RESCALE=m

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a2f6f61e8ee016b75e1b1dd62fbd03e6d6db37d Mon Sep 17 00:00:00 2001
From: Liam Beguin <liambeguin@gmail.com>
Date: Wed, 1 Jun 2022 10:21:38 -0400
Subject: iio: test: fix missing MODULE_LICENSE for IIO_RESCALE=m

When IIO_RESCALE_KUNIT_TEST=y and IIO_RESCALE=m,
drivers/iio/afe/iio-rescale.o is built twice causing the
MODULE_LICENSE() to be lost, as shown by:

  ERROR: modpost: missing MODULE_LICENSE() in drivers/iio/afe/iio-rescale.o

Rework the build configuration to have the dependency specified in the
Kconfig.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 8e74a48d17d5 ("iio: test: add basic tests for the iio-rescale driver")
Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20220601142138.3331278-1-liambeguin@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/test/Kconfig  | 2 +-
 drivers/iio/test/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/test/Kconfig b/drivers/iio/test/Kconfig
index 56ca0ad7e77a..4c66c3f18c34 100644
--- a/drivers/iio/test/Kconfig
+++ b/drivers/iio/test/Kconfig
@@ -6,7 +6,7 @@
 # Keep in alphabetical order
 config IIO_RESCALE_KUNIT_TEST
 	bool "Test IIO rescale conversion functions"
-	depends on KUNIT=y && !IIO_RESCALE
+	depends on KUNIT=y && IIO_RESCALE=y
 	default KUNIT_ALL_TESTS
 	help
 	  If you want to run tests on the iio-rescale code say Y here.
diff --git a/drivers/iio/test/Makefile b/drivers/iio/test/Makefile
index f15ae0a6394f..880360f8d02c 100644
--- a/drivers/iio/test/Makefile
+++ b/drivers/iio/test/Makefile
@@ -4,6 +4,6 @@
 #
 
 # Keep in alphabetical order
-obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o ../afe/iio-rescale.o
+obj-$(CONFIG_IIO_RESCALE_KUNIT_TEST) += iio-test-rescale.o
 obj-$(CONFIG_IIO_TEST_FORMAT) += iio-test-format.o
 CFLAGS_iio-test-format.o += $(DISABLE_STRUCTLEAK_PLUGIN)
-- 
2.36.1


