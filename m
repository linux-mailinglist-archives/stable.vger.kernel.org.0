Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4EE41200D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349733AbhITRsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349714AbhITRqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E636C60F4B;
        Mon, 20 Sep 2021 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157822;
        bh=gYcDscaYwLFu8fHV+1gkT+CnZNs5DG4/LZ/Dgqq3ohM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/u2EQk3NlfC2KxNvQzF+ptp6JJWK3mywWwc5Qc3cE9YHQ/gA48In4bCthcBW+FSY
         zjadRc2q9TJhfRU2Ug0994zxBMsIJK3FgYoOnzI31+ujjODKz3ccNds9wgCy4Lcd6c
         ypmHIOjKbeXrwNcqrlJUcIJHDGkw6zEepIgHBKjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.19 140/293] tools/thermal/tmon: Add cross compiling support
Date:   Mon, 20 Sep 2021 18:41:42 +0200
Message-Id: <20210920163938.076644637@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -10,7 +10,7 @@ CFLAGS+= -O1 ${WARNFLAGS}
 # Add "-fstack-protector" only if toolchain supports it.
 CFLAGS+= $(call cc-option,-fstack-protector)
 CC?= $(CROSS_COMPILE)gcc
-PKG_CONFIG?= pkg-config
+PKG_CONFIG?= $(CROSS_COMPILE)pkg-config
 
 CFLAGS+=-D VERSION=\"$(VERSION)\"
 LDFLAGS+=


