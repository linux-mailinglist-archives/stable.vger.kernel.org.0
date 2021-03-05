Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F5732EB70
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhCEMoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232332AbhCEMni (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:43:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17BA265027;
        Fri,  5 Mar 2021 12:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948217;
        bh=uagZ98ZKMYU9+CBthWXRtBD5o1t+vO/J7CFB6GNBFDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPIziOEthjP6lNi6pcG7wBF19/BCOaIgEYpKMkkG54VBrDF2dopN/VfbCbhVClaWI
         rwZK/yl0fvgHqqd38xZNzNAcZP9bgQ75zcMFxXzuN7uqNJMoZwJFtiM1p8oxfnRDST
         P92rN8pP7Moyv+pYU6fa56WGOIONP1fP1ZIAXGIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.4 06/30] scripts: set proper OpenSSL include dir also for  sign-file
Date:   Fri,  5 Mar 2021 13:22:35 +0100
Message-Id: <20210305120849.715327622@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

commit fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f upstream.

Fixes: 2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto")
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -25,6 +25,7 @@ hostprogs-$(CONFIG_SYSTEM_TRUSTED_KEYRIN
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_sign-file = $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_extract-cert = $(CRYPTO_LIBS)


