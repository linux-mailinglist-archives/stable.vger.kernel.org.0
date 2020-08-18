Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0348824911D
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 00:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgHRWlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 18:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHRWlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B05520786;
        Tue, 18 Aug 2020 22:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790474;
        bh=ILm6PYAHR9zoYRR/F9/v/nsmW1S+3S1F0Bf1JqdVsWc=;
        h=Date:From:To:Subject:From;
        b=VwIRIYDwlCLVfIwR3btm2qsToWwDSS6YqWktUvc8zjHx6ukfEKr7Naa8MBtURzy1I
         omG4FpZ1/E8VSxcEL51FB3mtDLahU6WZrdCuLv5WbtYDmAFOLTUBoL7m11OFWsk4Th
         EYzFtNo8ADOv4SZrKrCMPqxmpLRSBvWBmEVwcERk=
Date:   Tue, 18 Aug 2020 15:41:14 -0700
From:   akpm@linux-foundation.org
To:     amodra@gmail.com, arnd@arndb.de, bin.meng@windriver.com,
        chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        romain.naour@gmail.com, sam@ravnborg.org, stable@vger.kernel.org,
        ysato@users.sourceforge.jp
Subject:  [merged]
 include-asm-generic-vmlinuxldsh-align-ro_after_init.patch removed from -mm
 tree
Message-ID: <20200818224114.DVsPR2YH-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: include/asm-generic/vmlinux.lds.h: align ro_after_init
has been removed from the -mm tree.  Its filename was
     include-asm-generic-vmlinuxldsh-align-ro_after_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Romain Naour <romain.naour@gmail.com>
Subject: include/asm-generic/vmlinux.lds.h: align ro_after_init

Since the patch [1], building the kernel using a toolchain built with
binutils 2.33.1 prevents booting a sh4 system under Qemu.  Apply the patch
provided by Alan Modra [2] that fix alignment of rodata.

[1] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=ebd2263ba9a9124d93bbc0ece63d7e0fae89b40e
[2] https://www.sourceware.org/ml/binutils/2019-12/msg00112.html

Link: https://marc.info/?l=linux-sh&m=158429470221261
Signed-off-by: Romain Naour <romain.naour@gmail.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-align-ro_after_init
+++ a/include/asm-generic/vmlinux.lds.h
@@ -394,6 +394,7 @@
  */
 #ifndef RO_AFTER_INIT_DATA
 #define RO_AFTER_INIT_DATA						\
+	. = ALIGN(8);							\
 	__start_ro_after_init = .;					\
 	*(.data..ro_after_init)						\
 	JUMP_TABLE_DATA							\
_

Patches currently in -mm which might be from romain.naour@gmail.com are


