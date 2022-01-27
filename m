Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E094849DBAD
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiA0HdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiA0HdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:33:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD59C061714;
        Wed, 26 Jan 2022 23:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C625619F1;
        Thu, 27 Jan 2022 07:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2530C340E4;
        Thu, 27 Jan 2022 07:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643268788;
        bh=X209WTDmnGeNp6FZX0ifKOXpvPZFNlG77Rw2X/799zg=;
        h=From:To:Cc:Subject:Date:From;
        b=QkbueVr7bCBWcjnSWii2RBrd8pvuu7mimSKCI/aVmQWQCiAb+WdEu3NVVkJsefUAQ
         BK64sx2dtyMVr5Wso5LfFwY36FoI3a7Mstpeg4oqQk+9AwNhoxJMbBIXqULNDse1oT
         ervpCFR2sasDqvxDWRG+5q/ttuyYcgUnevJKf3s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>,
        "Maciej W. Rozycki" <macro@embecosm.com>
Subject: [PATCH] kbuild: remove include/linux/cyclades.h from header file check
Date:   Thu, 27 Jan 2022 08:33:04 +0100
Message-Id: <20220127073304.42399-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1158; h=from:subject; bh=X209WTDmnGeNp6FZX0ifKOXpvPZFNlG77Rw2X/799zg=; b=owGbwMvMwCRo6H6F97bub03G02pJDImfvNanij5vdno5YZdgMV8Jm9i+Dcy52/l1prycKhPQr/9/ XfPNjlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZjIEw+G+VHVx25e71BZVt3Y/aDj6C 15w1arXIYFxyO2iYr/Xn8icFe13FOlhAe3Ba9+BwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The file now rightfully throws up a big warning that it should never be
included, so remove it from the header_check test.

Fixes: f23653fe6447 ("tty: Partially revert the removal of the Cyclades public API")
Cc: stable <stable@vger.kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Cc: "Maciej W. Rozycki" <macro@embecosm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
As the offending commit is in the tty.git tree, I'll take this through
there as well.

 usr/include/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/include/Makefile b/usr/include/Makefile
index 7be7468c177b..83822c33e9e7 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -28,6 +28,7 @@ no-header-test += linux/am437x-vpfe.h
 no-header-test += linux/android/binder.h
 no-header-test += linux/android/binderfs.h
 no-header-test += linux/coda.h
+no-header-test += linux/cyclades.h
 no-header-test += linux/errqueue.h
 no-header-test += linux/fsmap.h
 no-header-test += linux/hdlc/ioctl.h
-- 
2.35.0

