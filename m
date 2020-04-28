Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC2F1BC9FC
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbgD1Som (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbgD1Sol (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1758320575;
        Tue, 28 Apr 2020 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099481;
        bh=PN4jNn1Z7lHaLyEx2Q1Lay4Up6Z1l3Ol4zb6ZLUoIsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFlSbV0gUBcTNjxwHCV/l7FBebdlualTzRYDFNaT0Yz5zmWYeuiKNJyzn7pfYoDrA
         ltiLwYfDtll/kywAIMPwVJhaQnbYOXcFMzv06M+drVdkRVOE5zlTe8HXtSlBh39VxE
         jsIZyc+TOHdrkxmn7ibOWLIf8R09i57zApbpXx3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.4 167/168] compat: ARM64: always include asm-generic/compat.h
Date:   Tue, 28 Apr 2020 20:25:41 +0200
Message-Id: <20200428182251.735456158@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 556d687a4ccd54ab50a721ddde42c820545effd9 upstream.

In order to use compat_* type defininitions in device drivers
outside of CONFIG_COMPAT, move the inclusion of asm-generic/compat.h
ahead of the #ifdef.

All other architectures already do this.

Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/compat.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -4,6 +4,9 @@
  */
 #ifndef __ASM_COMPAT_H
 #define __ASM_COMPAT_H
+
+#include <asm-generic/compat.h>
+
 #ifdef CONFIG_COMPAT
 
 /*
@@ -13,8 +16,6 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
-#include <asm-generic/compat.h>
-
 #define COMPAT_USER_HZ		100
 #ifdef __AARCH64EB__
 #define COMPAT_UTS_MACHINE	"armv8b\0\0"


