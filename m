Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DB31BE35
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhBOQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231827AbhBOPtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:49:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB32964EF3;
        Mon, 15 Feb 2021 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403321;
        bh=5qym+tpOI/9fLuI4H74SkeEQAT59U/MCv5StovGbBGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZHkapJAxTZ4mT74cd0OZGy9yJaNFc4hXZRU5wxlxfXkI2JYEywchJK4fYIjH1yev
         5rhMobWrG934SvGm8lWRVaMYl0EhaNngDXs3MIBOyqYg87nrwP0eSsC0MQq0Iqn67q
         sCmUxJvywBnUR7TKsY85oYc8b+m1/npHIsVft3Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 084/104] scripts: set proper OpenSSL include dir also for sign-file
Date:   Mon, 15 Feb 2021 16:27:37 +0100
Message-Id: <20210215152722.170015503@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
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
@@ -17,6 +17,7 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_C
 
 HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_sign-file = $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
 HOSTLDLIBS_extract-cert = $(CRYPTO_LIBS)


