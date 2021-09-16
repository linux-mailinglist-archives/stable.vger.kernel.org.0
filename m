Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8232040E173
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbhIPQal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241601AbhIPQ1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B321B61284;
        Thu, 16 Sep 2021 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809067;
        bh=rYpuYWuL85NPJVb7hEvBG/6OSBru/NwAp5iRIDttqi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8q5hTJtyGRxoDs9C+KbgklVHfYLtzPUF2BMn6hcvmEWUuPt7SNDUcFfp+N/Nh7L5
         P45UqWPqO+1rxNgHkDy4x7t0ImA8k0f9JKkGd9fLRaNI4982FAtoCLUd0Bgl5Nlpy2
         Q7mL6qhsPvyvnKCQWMOFjV3fx/fB5ML5QK193JT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.13 019/380] tools/thermal/tmon: Add cross compiling support
Date:   Thu, 16 Sep 2021 17:56:16 +0200
Message-Id: <20210916155804.628166718@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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


