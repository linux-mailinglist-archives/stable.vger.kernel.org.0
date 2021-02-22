Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498CD32197F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhBVNzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 08:55:49 -0500
Received: from mx1.emlix.com ([136.243.223.33]:41598 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhBVNza (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 08:55:30 -0500
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id C7EC75F9F8
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:54:46 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4/5.19 2/2] scripts: set proper OpenSSL include dir also for  sign-file
Date:   Mon, 22 Feb 2021 14:54:39 +0100
Message-ID: <4164976.57TKVydYaC@devpool47>
Organization: emlix GmbH
In-Reply-To: <2934400.eNZDa4x5nO@devpool47>
References: <2934400.eNZDa4x5nO@devpool47>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f upstream.

Fixes: 2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto")
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile b/scripts/Makefile
index 5f8d3671a709..b4b7d8b58cd6 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -26,6 +26,7 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE) += insert-sys-cert
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)
-- 
2.30.0




