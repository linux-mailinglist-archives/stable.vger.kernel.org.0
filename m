Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D242F79A5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbhAOMjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388279AbhAOMjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD0823356;
        Fri, 15 Jan 2021 12:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714310;
        bh=m/xcYm1HRXoPHGCDcU1w3VhFJWdUhN2QimTywFBeXyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRTJENX1KqkHuGOLdoveeAZQ5uiBzAAnSdbh9cwRB68jYQF515KOcFFG2maR4K/oM
         YfsaUvGNWgG5QmfEFOzHZTWjDqHPRJSL9Vd/7Rk4MmnzBhcWwgGLJ3t0iB8h9zOSPX
         wEJi9zAPXxaArA3z00527ajuUTasey3/O0OmjLYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.10 079/103] zonefs: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:12 +0100
Message-Id: <20210115122009.848313856@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 4f8b848788f77c7f5c3bd98febce66b7aa14785f upstream.

When CRC32 is disabled, zonefs cannot be linked:

ld: fs/zonefs/super.o: in function `zonefs_fill_super':

Add a Kconfig 'select' statement for it.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/zonefs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/zonefs/Kconfig
+++ b/fs/zonefs/Kconfig
@@ -3,6 +3,7 @@ config ZONEFS_FS
 	depends on BLOCK
 	depends on BLK_DEV_ZONED
 	select FS_IOMAP
+	select CRC32
 	help
 	  zonefs is a simple file system which exposes zones of a zoned block
 	  device (e.g. host-managed or host-aware SMR disk drives) as files.


