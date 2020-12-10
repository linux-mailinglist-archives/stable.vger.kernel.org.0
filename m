Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88E2D688D
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 21:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390103AbgLJUUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 15:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390065AbgLJO13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:27:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 12/39] powerpc: Stop exporting __clear_user which is now inlined.
Date:   Thu, 10 Dec 2020 15:26:23 +0100
Message-Id: <20201210142601.497869378@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

Stable commit 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP
enabled") redefines __clear_user as inline function but does not remove
the export.

Fixes: 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP enabled")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/lib/ppc_ksyms.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/lib/ppc_ksyms.c
+++ b/arch/powerpc/lib/ppc_ksyms.c
@@ -24,7 +24,6 @@ EXPORT_SYMBOL(csum_tcpudp_magic);
 #endif
 
 EXPORT_SYMBOL(__copy_tofrom_user);
-EXPORT_SYMBOL(__clear_user);
 EXPORT_SYMBOL(copy_page);
 
 #ifdef CONFIG_PPC64


