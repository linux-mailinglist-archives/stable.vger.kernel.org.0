Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C573224F8FD
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgHXJj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgHXIq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FBA1204FD;
        Mon, 24 Aug 2020 08:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258789;
        bh=DpOnkbPZw4SB30cqBU97Llu/uZnXc+6xv7pwrG8oUQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkzqsBRImjYCLCGPQidjbw1K8ehitnWDJ+OjJLo1fmiJT1quaHTBCxoalTCyXgv3C
         Ozpam0ExPdvgITQGfiZUcI9Ej/DN+J4JhUvH8IHdnMeUBxC6vPPzOImkPU0plgWN0Q
         enDjzRfSi+tigdlDpOO9Duy0G53hzwSYcJYc50Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.4 006/107] kbuild: remove PYTHON2 variable
Date:   Mon, 24 Aug 2020 10:29:32 +0200
Message-Id: <20200824082405.351431962@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 94f7345b712405b79647a6a4bf8ccbd0d78fa69d upstream.

Python 2 has retired. There is no user of this variable.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -423,7 +423,6 @@ INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 PERL		= perl
 PYTHON		= python
-PYTHON2		= python2
 PYTHON3		= python3
 CHECK		= sparse
 BASH		= bash
@@ -474,7 +473,7 @@ CLANG_FLAGS :=
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
-export PERL PYTHON PYTHON2 PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
+export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS


