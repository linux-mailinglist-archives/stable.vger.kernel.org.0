Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02273324DA0
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhBYKHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhBYKBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D5064F32;
        Thu, 25 Feb 2021 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246984;
        bh=/08kOTvtWnoDP/4PO9mP0Dvrc6F4ejLsOtsGp//5fQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IENphGvxJyXH2pRb/ztdkoVtAlSQlnQPbpCwpkke0w/KHQYm6SVPTk8lXSLXiiBx6
         5oIANSqwhq2Xeq1fAfsx75X6aBjM82cuiqeFpYuPeGufoW2HuGx4M/5xzSRGsi83k2
         jg1HiBb73MLEFdQsap1UeTxG32mxq9noGaq3FEcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 08/17] scripts: set proper OpenSSL include dir also for sign-file
Date:   Thu, 25 Feb 2021 10:53:53 +0100
Message-Id: <20210225092515.408097659@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
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
Cc: stable@vger.kernel.org # 5.6.x
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -26,6 +26,7 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFIC
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)


