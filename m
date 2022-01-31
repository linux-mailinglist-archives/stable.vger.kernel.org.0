Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575324A4320
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376508AbiAaLRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:17:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48888 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376447AbiAaLPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:15:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99969611DE;
        Mon, 31 Jan 2022 11:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB00C340E8;
        Mon, 31 Jan 2022 11:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627722;
        bh=RneQH2Th2LT+NVL5Ld6yWCekJbzwRyeGIcbV1Qo75Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9WSvF28E0ghJfUoxME9sVPF3joJvgrYUmkqoiYTbv0fbgU+eCB7wbCHlDZA+COQi
         A9ySNLcLt1iWiXwG5icMb/mt3LFojEyTiQhkh0le7Bink5PA6bFLWIEXJ32GDxZjZy
         /xDDEI+qjpULCuro/d3HGxIHKwZgHezpTjXOZ9jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 169/171] usr/include/Makefile: add linux/nfc.h to the compile-test coverage
Date:   Mon, 31 Jan 2022 11:57:14 +0100
Message-Id: <20220131105235.731202299@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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


