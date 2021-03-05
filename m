Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA132EAF7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCEMlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhCEMkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632CB64F44;
        Fri,  5 Mar 2021 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948052;
        bh=NYwiH+5EuGAV3ozikYUwsigLCl1JjdhMMqp81bVPGlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MasPNZKiVvyIA0XedfgUezfqWvHfzm0iqY25SL2ViVXgUg7a6yqNAuxJlEhuW0OgF
         iy0NzUeK6TmDRDCj6ILVTHXsXpfFT4G7351Vr/AcVfIR41eKqJ6jxFjzUcsytZo4eb
         EvSaVKW3KNKDuzTaTVufnn0eS2fm/J2a5gVEv7N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rolf Eike Beer <eb@emlix.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 11/41] scripts: set proper OpenSSL include dir also for  sign-file
Date:   Fri,  5 Mar 2021 13:22:18 +0100
Message-Id: <20210305120851.837437806@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
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
@@ -26,6 +26,7 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFIC
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_sign-file = $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o = $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_extract-cert = $(CRYPTO_LIBS)


