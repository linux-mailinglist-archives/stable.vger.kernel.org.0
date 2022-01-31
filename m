Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062894A45AB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiAaLqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbiAaLkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43857C02B741;
        Mon, 31 Jan 2022 03:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0556FB82A5C;
        Mon, 31 Jan 2022 11:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D70C340E8;
        Mon, 31 Jan 2022 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628325;
        bh=RneQH2Th2LT+NVL5Ld6yWCekJbzwRyeGIcbV1Qo75Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhYdONSm6/6+H5c+w0Q6sBZoIbqzDKre0e7A6u9nDwE52DXwvPhPny3ZSOfCN0TJU
         cRBiJECuM0Dgc7BR4jMwbS7aB3V7iWiQt1+AYAwZGEWr91mHoM+GOz5Y/2pHeNJLCu
         F1zHmrR2nX0FUKUR7YU0y0HHlXRVToYR2PsZuah4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.16 195/200] usr/include/Makefile: add linux/nfc.h to the compile-test coverage
Date:   Mon, 31 Jan 2022 11:57:38 +0100
Message-Id: <20220131105240.098884053@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry V. Levin <ldv@altlinux.org>

commit 10756dc5b02bff370ddd351d7744bc99ada659c2 upstream.

As linux/nfc.h userspace compilation was finally fixed by commits
79b69a83705e ("nfc: uapi: use kernel size_t to fix user-space builds")
and 7175f02c4e5f ("uapi: fix linux/nfc.h userspace compilation errors"),
there is no need to keep the compile-test exception for it in
usr/include/Makefile.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 usr/include/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -35,7 +35,6 @@ no-header-test += linux/hdlc/ioctl.h
 no-header-test += linux/ivtv.h
 no-header-test += linux/kexec.h
 no-header-test += linux/matroxfb.h
-no-header-test += linux/nfc.h
 no-header-test += linux/omap3isp.h
 no-header-test += linux/omapfb.h
 no-header-test += linux/patchkey.h


