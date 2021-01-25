Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A54302AD4
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbhAYSyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbhAYSxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E5D122460;
        Mon, 25 Jan 2021 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600817;
        bh=6u95SOw7y/uqzQ1KFj4jjpCMM4zUQdSZONEzPtlPIbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocp6jGX96YygzAWxFwBykWSvHbWf8yCmzwji9ardSgZFes6RNasSpSAwKfn6/Pkuo
         OVijsTfyrSJT4tlEC8U/zALtzLz7cp3sOugxbLal/jsBqfjlPM6hzRE+1HevxOsuLx
         fxeBLEL3O2gXIYxU7op5PFWpgxVskGhZiqCf05Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
        Rich Felker <dalias@libc.org>
Subject: [PATCH 5.10 155/199] sh: Remove unused HAVE_COPY_THREAD_TLS macro
Date:   Mon, 25 Jan 2021 19:39:37 +0100
Message-Id: <20210125183222.748348658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

commit 19170492735be935747b0545b7eed8bb40cc1209 upstream.

Fixes: 	e1cc9d8d596e ("sh: switch to copy_thread_tls()")
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -30,7 +30,6 @@ config SUPERH
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_COPY_THREAD_TLS
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE


