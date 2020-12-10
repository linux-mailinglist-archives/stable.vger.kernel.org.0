Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BE52D5E0C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391126AbgLJOiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391122AbgLJOh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 21/75] ftrace: Fix DYNAMIC_FTRACE_WITH_DIRECT_CALLS dependency
Date:   Thu, 10 Dec 2020 15:26:46 +0100
Message-Id: <20201210142607.100047313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 49a962c075dfa41c78e34784772329bc8784d217 upstream.

DYNAMIC_FTRACE_WITH_DIRECT_CALLS should depend on
DYNAMIC_FTRACE_WITH_REGS since we need ftrace_regs_caller().

Link: https://lkml.kernel.org/r/fc4b257ea8689a36f086d2389a9ed989496ca63a.1606412433.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: 763e34e74bb7d5c ("ftrace: Add register_ftrace_direct()")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -202,7 +202,7 @@ config DYNAMIC_FTRACE_WITH_REGS
 
 config DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	def_bool y
-	depends on DYNAMIC_FTRACE
+	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
 config FUNCTION_PROFILER


