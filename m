Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2B3D628D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhGZPgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237040AbhGZPfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E7960240;
        Mon, 26 Jul 2021 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316177;
        bh=c14dfRxq1gmZ49vdBkjU05NPkI/FJJLBGXEkwr2xzeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJ1zdUoTW7ggSDpNCmjFGGRrRt3J8nKsA4EMC8LmSDIb0pdvlh0N2DrwTIegGJkpg
         jl4BOuYmjSKlvjCvxXbFdZwSDdmH2Mb6EIFDqaE0vwRk7Z2XiV42dN2eDztNCBb5bR
         7s+k6S3LvEiqpzwJSSCy7tPC9MjhdXLABNuj9/qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.13 218/223] Documentation: Fix intiramfs script name
Date:   Mon, 26 Jul 2021 17:40:10 +0200
Message-Id: <20210726153853.312265066@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@amd.com>

commit 5e60f363b38fd40e4d8838b5d6f4d4ecee92c777 upstream.

Documentation was not changed when renaming the script in commit
80e715a06c2d ("initramfs: rename gen_initramfs_list.sh to
gen_initramfs.sh"). Fixing this.

Basically does:

 $ sed -i -e s/gen_initramfs_list.sh/gen_initramfs.sh/g $(git grep -l gen_initramfs_list.sh)

Fixes: 80e715a06c2d ("initramfs: rename gen_initramfs_list.sh to gen_initramfs.sh")
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/early-userspace/early_userspace_support.rst |    8 ++++----
 Documentation/filesystems/ramfs-rootfs-initramfs.rst                 |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/driver-api/early-userspace/early_userspace_support.rst
+++ b/Documentation/driver-api/early-userspace/early_userspace_support.rst
@@ -69,17 +69,17 @@ early userspace image can be built by an
 
 As a technical note, when directories and files are specified, the
 entire CONFIG_INITRAMFS_SOURCE is passed to
-usr/gen_initramfs_list.sh.  This means that CONFIG_INITRAMFS_SOURCE
+usr/gen_initramfs.sh.  This means that CONFIG_INITRAMFS_SOURCE
 can really be interpreted as any legal argument to
-gen_initramfs_list.sh.  If a directory is specified as an argument then
+gen_initramfs.sh.  If a directory is specified as an argument then
 the contents are scanned, uid/gid translation is performed, and
 usr/gen_init_cpio file directives are output.  If a directory is
-specified as an argument to usr/gen_initramfs_list.sh then the
+specified as an argument to usr/gen_initramfs.sh then the
 contents of the file are simply copied to the output.  All of the output
 directives from directory scanning and file contents copying are
 processed by usr/gen_init_cpio.
 
-See also 'usr/gen_initramfs_list.sh -h'.
+See also 'usr/gen_initramfs.sh -h'.
 
 Where's this all leading?
 =========================
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.rst
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.rst
@@ -170,7 +170,7 @@ Documentation/driver-api/early-userspace
 The kernel does not depend on external cpio tools.  If you specify a
 directory instead of a configuration file, the kernel's build infrastructure
 creates a configuration file from that directory (usr/Makefile calls
-usr/gen_initramfs_list.sh), and proceeds to package up that directory
+usr/gen_initramfs.sh), and proceeds to package up that directory
 using the config file (by feeding it to usr/gen_init_cpio, which is created
 from usr/gen_init_cpio.c).  The kernel's build-time cpio creation code is
 entirely self-contained, and the kernel's boot-time extractor is also


