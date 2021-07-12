Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9D3C52B1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbhGLHsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346700AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E37A4611AC;
        Mon, 12 Jul 2021 07:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075738;
        bh=CwDiPq/Z3SwvXLFtvE1cZS3CHB9pPj9yayODUp1y3/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVbe0xdyIaEYSWBps07/9mKTHV+ZbTIyoZ+UGf33cfqJct7NmTU3MjbWSeAXL9u5c
         cJZ5oS4+nDSKhDcXXtRaXxZIYxWRe8jas6h0+0bZOeXgiZR4wcz0nBmUbPDQWwZvK7
         RpH0fjXo+d1IBqGd2EX/dCXjA8FCW3w6REt4ZNz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 344/800] x86/sev: Use "SEV: " prefix for messages from sev.c
Date:   Mon, 12 Jul 2021 08:06:07 +0200
Message-Id: <20210712061003.553507151@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 8d9d46bbf3b6b7ff8edcac33603ab45c29e0e07f ]

The source file has been renamed froms sev-es.c to sev.c, but the
messages are still prefixed with "SEV-ES: ". Change that to "SEV: " to
make it consistent.

Fixes: e759959fe3b8 ("x86/sev-es: Rename sev-es.{ch} to sev.{ch}")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210622144825.27588-4-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f4641d8ee6a7..d66a33d24f4f 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -7,7 +7,7 @@
  * Author: Joerg Roedel <jroedel@suse.de>
  */
 
-#define pr_fmt(fmt)	"SEV-ES: " fmt
+#define pr_fmt(fmt)	"SEV: " fmt
 
 #include <linux/sched/debug.h>	/* For show_regs() */
 #include <linux/percpu-defs.h>
-- 
2.30.2



