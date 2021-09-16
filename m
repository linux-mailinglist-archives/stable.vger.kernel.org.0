Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A2840E56C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350521AbhIPRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347394AbhIPRJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B006360F70;
        Thu, 16 Sep 2021 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810214;
        bh=rYpuYWuL85NPJVb7hEvBG/6OSBru/NwAp5iRIDttqi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKxlLaJXDH6k1JBIFIsBNM4QsMWMb/KzFohCAvBD8QLJ0k+XYySxLlw82htG0bmpU
         yA4EaYYp1YqikZRJv7WyYrk5zATULXUs9cmgTjifXdnBkPzIKE17Ytaz4NtU6Sm1dy
         VtvcfO4+lHsA1K2ogCR0UJ2xpVI5ndm77QN0cIPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.14 026/432] tools/thermal/tmon: Add cross compiling support
Date:   Thu, 16 Sep 2021 17:56:15 +0200
Message-Id: <20210916155811.706720707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

commit b5f7912bb604b47a0fe024560488a7556dce8ee7 upstream.

Default to prefixed pkg-config when crosscompiling, this matches what
other parts of the tools/ directory already do.

[dlezcano] : Reworked description

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/31302992.qZodDJZGDc@devpool47
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/thermal/tmon/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/thermal/tmon/Makefile
+++ b/tools/thermal/tmon/Makefile
@@ -10,7 +10,7 @@ override CFLAGS+= $(call cc-option,-O3,-
 # Add "-fstack-protector" only if toolchain supports it.
 override CFLAGS+= $(call cc-option,-fstack-protector-strong)
 CC?= $(CROSS_COMPILE)gcc
-PKG_CONFIG?= pkg-config
+PKG_CONFIG?= $(CROSS_COMPILE)pkg-config
 
 override CFLAGS+=-D VERSION=\"$(VERSION)\"
 LDFLAGS+=


