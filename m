Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F41E424E06
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 09:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhJGHXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 03:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhJGHXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 03:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F7F1610FB;
        Thu,  7 Oct 2021 07:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633591310;
        bh=5BZDea3SADaMMlkBbinICsGx/kxi8BLmPXvCecxqhSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IBcHnl0YUabHSkrhtkv6vxMSJhjJbljEb3/qj+Y9zkT96qXtpB6ZQYH6tBhhpusW
         uV662Usi7ne+RuNBzbDfF6Auq9fzxoG0igkRiiShrgGnu1DR8Q0BV66sGfmga2Yg5F
         gjX7E4jgneKIOkKhWEtBucuKgnFleUAHPlv6l6xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.287
Date:   Thu,  7 Oct 2021 09:21:39 +0200
Message-Id: <163359121978201@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163359121918232@kroah.com>
References: <163359121918232@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 34ad8ef93d40..fc14cb0bf5e0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 286
+SUBLEVEL = 287
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6cd79888944e..10d6627673cb 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -55,7 +55,7 @@
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __ro_after_init;
+unsigned long __stack_chk_guard __read_mostly;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
