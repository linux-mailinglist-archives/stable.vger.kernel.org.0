Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980EA3CAB99
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244933AbhGOTU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245050AbhGOTTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905196117A;
        Thu, 15 Jul 2021 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376438;
        bh=COoZCc+eFb4JzRvAhkfm+WtrTWnPMWOmgUmp+hmww/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y04LkgCBkC9VgS2+2/7ymOAlJJxI1gbX2sFy6wzTC0cOUG7yqWO5sHttsi9KZBAou
         Sr32wrkWEndNpysZ5j5EfyfMznyPQ3gUyxUzOfJczcm+t7jL/0MHnw9Kn1XuGu9ptI
         5JW43I+eh9GHAr77N3KPZWjczu6c+tEuSzxjcHBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.13 256/266] s390/vdso: rename VDSO64_LBASE to VDSO_LBASE
Date:   Thu, 15 Jul 2021 20:40:11 +0200
Message-Id: <20210715182652.655331868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 43e1f76b0b69b86b2175ef755243e61fe40c75db upstream.

Will be used by both vdso32 and vdso64, so change the name.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/vdso.h         |    2 +-
 arch/s390/kernel/vdso64/vdso64.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -5,7 +5,7 @@
 #include <vdso/datapage.h>
 
 /* Default link address for the vDSO */
-#define VDSO64_LBASE	0
+#define VDSO_LBASE	0
 
 #define __VVAR_PAGES	2
 
--- a/arch/s390/kernel/vdso64/vdso64.lds.S
+++ b/arch/s390/kernel/vdso64/vdso64.lds.S
@@ -17,7 +17,7 @@ SECTIONS
 #ifdef CONFIG_TIME_NS
 	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
 #endif
-	. = VDSO64_LBASE + SIZEOF_HEADERS;
+	. = VDSO_LBASE + SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
 	.gnu.hash	: { *(.gnu.hash) }


