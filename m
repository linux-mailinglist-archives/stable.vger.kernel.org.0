Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21924412193
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358427AbhITSGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357337AbhITSD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003E663241;
        Mon, 20 Sep 2021 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158217;
        bh=rYpuYWuL85NPJVb7hEvBG/6OSBru/NwAp5iRIDttqi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaSYwz3xpM13N8XnFStpp4xSwLGUVdpRmopWPgm/OYp+sbVOuoQv5UbG4xNOvaR1s
         bOiB2Q974/aEcZcZaMUwsYc8rK5k93SgJ0S98rVso2Bxf213rSb/Elo74/XHQMtOXf
         iLPzQLqPd82ZvSG4o70l96flqOnqD8JV3fokFhHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 011/260] tools/thermal/tmon: Add cross compiling support
Date:   Mon, 20 Sep 2021 18:40:29 +0200
Message-Id: <20210920163931.509064195@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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


