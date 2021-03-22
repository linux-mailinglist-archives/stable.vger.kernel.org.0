Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D7C3441D2
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCVMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhCVMe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5AAE61994;
        Mon, 22 Mar 2021 12:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416487;
        bh=eFgDG8jrJe3csEPIkOtUCqvNqVZ6BGdi99gwMmRN5tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQX0W53fAMnsSNgcDhMbdx7icUIjnAPVh7b3sC4kSGRtr87NgoGLZN8fWMFVW5SGr
         Z5C0tM1zjWwaHGgb9zS9eTUjr5ErNWS0o8XsSeDHWzMftE/UwPuRiG66ntIap2xNIm
         DTUd7pEUY20bmIXED6OJJzrV8r1jKZfwkCap3spY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyn Welch <martyn@welchs.me.uk>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH 5.11 114/120] MAINTAINERS: move some real subsystems off of the staging mailing list
Date:   Mon, 22 Mar 2021 13:28:17 +0100
Message-Id: <20210322121933.465772363@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f8d70fd6a5a7a38a95eb8021e00d2e547f88efec upstream.

The VME and Android drivers still have their MAINTAINERS entries
pointing to the "driverdevel" mailing list, due to them having their
codebase move out of the drivers/staging/ directory, but no one
remembered to change the mailing list entries.

Move them both to linux-kernel for lack of a more specific place at the
moment.  These are both low-volume areas of the kernel, so this
shouldn't be an issue.

Cc: Martyn Welch <martyn@welchs.me.uk>
Cc: Manohar Vanga <manohar.vanga@gmail.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Martijn Coenen <maco@android.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Reported-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Link: https://lore.kernel.org/r/YEzE6u6U1jkBatmr@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1169,7 +1169,7 @@ M:	Joel Fernandes <joel@joelfernandes.or
 M:	Christian Brauner <christian@brauner.io>
 M:	Hridya Valsaraju <hridya@google.com>
 M:	Suren Baghdasaryan <surenb@google.com>
-L:	devel@driverdev.osuosl.org
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 F:	drivers/android/
@@ -18993,7 +18993,7 @@ VME SUBSYSTEM
 M:	Martyn Welch <martyn@welchs.me.uk>
 M:	Manohar Vanga <manohar.vanga@gmail.com>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-L:	devel@driverdev.osuosl.org
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
 F:	Documentation/driver-api/vme.rst


