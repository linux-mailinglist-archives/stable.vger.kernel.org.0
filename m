Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D016149DBF5
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiA0Hv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiA0Hv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F4BC061714
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 23:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0E90B821B3
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B0C340EB;
        Thu, 27 Jan 2022 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643269885;
        bh=6bcZZXpxneQuF8vYKjwhdC5QmHYJWd9af3MPzHxVs20=;
        h=Subject:To:From:Date:From;
        b=uVflWFYTf/cd6HvY+68Ztf6Hy1aIIUn/qg5JLCXNDWNhwXsDaGN8oBrHHOB+ti57d
         Kl4WuI//vTyyDKX4CA050Egm/8hl9f7pORMXO9TjNujCb2jDvqkcE78GJQMg2TD2y9
         4cnHTlY9h1K7UDv90ApFaJNJEaA4Hf6d4CxKrg3Y=
Subject: patch "kbuild: remove include/linux/cyclades.h from header file check" added to tty-linus
To:     gregkh@linuxfoundation.org, lkp@intel.com, macro@embecosm.com,
        masahiroy@kernel.org, sfr@canb.auug.org.au, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Jan 2022 08:51:18 +0100
Message-ID: <164326987844214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    kbuild: remove include/linux/cyclades.h from header file check

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d1ad2721b1eb05d54e81393a7ebc332d4a35c68f Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 27 Jan 2022 08:33:04 +0100
Subject: kbuild: remove include/linux/cyclades.h from header file check

The file now rightfully throws up a big warning that it should never be
included, so remove it from the header_check test.

Fixes: f23653fe6447 ("tty: Partially revert the removal of the Cyclades public API")
Cc: stable <stable@vger.kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "Maciej W. Rozycki" <macro@embecosm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220127073304.42399-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
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


