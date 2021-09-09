Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E1405993
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbhIIOsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 10:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbhIIOru (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 10:47:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995DC0560C0;
        Thu,  9 Sep 2021 07:38:41 -0700 (PDT)
Date:   Thu, 09 Sep 2021 14:38:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631198320;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPZpbJd2daHQSXgVbGO91hNefnBWiw5AIN/0LgYhGwY=;
        b=mjm7JmEWI0bVrDXR3zbiIS0JiVyODYyGZixrA4lWh/Hh+64jhoFsaKFEGWzvjxx6meWD1z
        ixltfYcsTNFSO3LAByoNgrRXc7p1uftcbHhMyeExR2eMXZwsd+CC97kYtLh8f3nen8yKZL
        nOb7aYdz5GY/O7GjIOuouuZLcVnYlqT+eOJ2Ln+eQXIbLn/t20tmQdS9Y2F4cSrJEnlsUb
        /uKPOGLXERHFHRfaTUZKEXQ1843NH/HfCXR9XVOjoe0MoqkKAmeLSyN3RZuK+w6wnJIHpd
        Ftuk+OVJraGhV84lbbCB4Tfz2jz1x9YBROs28IC+C8sPKyxsaJhxH5UQJWjBdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631198320;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPZpbJd2daHQSXgVbGO91hNefnBWiw5AIN/0LgYhGwY=;
        b=9Q6UdJoCASwIIJ4FVwu6WVG++HYdsnjJSwr6HRjg6TCY7XFKPbJh0yzwIcMjynggqn3fAN
        yUwk6X2as40ieWDw==
From:   "thermal-bot for Rolf Eike Beer" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-pm@vger.kernel.org
To:     linux-pm@vger.kernel.org
Subject: [thermal: thermal/next] tools/thermal/tmon: Add cross compiling support
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        rui.zhang@intel.com, amitk@kernel.org
In-Reply-To: <31302992.qZodDJZGDc@devpool47>
References: <31302992.qZodDJZGDc@devpool47>
MIME-Version: 1.0
Message-ID: <163119831971.25758.1729820784227436969.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the thermal/next branch of thermal:

Commit-ID:     b5f7912bb604b47a0fe024560488a7556dce8ee7
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git//b5f7912bb604b47a0fe024560488a7556dce8ee7
Author:        Rolf Eike Beer <eb@emlix.com>
AuthorDate:    Fri, 30 Jul 2021 13:51:54 +02:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Sat, 14 Aug 2021 15:33:19 +02:00

tools/thermal/tmon: Add cross compiling support

Default to prefixed pkg-config when crosscompiling, this matches what
other parts of the tools/ directory already do.

[dlezcano] : Reworked description

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/31302992.qZodDJZGDc@devpool47
---
 tools/thermal/tmon/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/Makefile b/tools/thermal/tmon/Makefile
index 3e65087..f9c52b7 100644
--- a/tools/thermal/tmon/Makefile
+++ b/tools/thermal/tmon/Makefile
@@ -10,7 +10,7 @@ override CFLAGS+= $(call cc-option,-O3,-O1) ${WARNFLAGS}
 # Add "-fstack-protector" only if toolchain supports it.
 override CFLAGS+= $(call cc-option,-fstack-protector-strong)
 CC?= $(CROSS_COMPILE)gcc
-PKG_CONFIG?= pkg-config
+PKG_CONFIG?= $(CROSS_COMPILE)pkg-config
 
 override CFLAGS+=-D VERSION=\"$(VERSION)\"
 TARGET=tmon
