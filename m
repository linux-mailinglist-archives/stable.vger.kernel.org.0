Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CF2E3CC1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438033AbgL1OGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437924AbgL1OGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C71A207BC;
        Mon, 28 Dec 2020 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164336;
        bh=BnjtGCpuaFuFJFkol+5rKAlmnRQM9Y89QpDu+4o2x8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKI2vmNpOfmOPU2qBTdo3wv9HcBXo1JU/2E5vsp6wobZpXlZ11nFaDvBJmUuIbCen
         rIODK7xXknqyXP62ST5f29/yFz+lLxVotLfAJmZT5ZcwtKeIJn1oQU/0oxC2cosU5H
         xbJvhlR2trHTiAxAWalE+NegUPJU1bKAHVkdoAvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/717] scripts: kernel-doc: Restore anonymous enum parsing
Date:   Mon, 28 Dec 2020 13:41:51 +0100
Message-Id: <20201228125026.374628132@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ae5b17e464146ddb8fee744fa2150922d6072916 ]

The commit d38c8cfb0571 ("scripts: kernel-doc: add support for typedef enum")
broke anonymous enum parsing. Restore it by relying on members rather than
its name.

Fixes: d38c8cfb0571 ("scripts: kernel-doc: add support for typedef enum")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/20201102170637.36138-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index f699cf05d4098..9b6ddeb097e93 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1390,7 +1390,7 @@ sub dump_enum($$) {
 	$members = $2;
     }
 
-    if ($declaration_name) {
+    if ($members) {
 	my %_members;
 
 	$members =~ s/\s+$//;
-- 
2.27.0



