Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9592C111EB2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLCWv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfLCWv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9B02084F;
        Tue,  3 Dec 2019 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413517;
        bh=NuGwt9UuVhd1Ho4x3f8+0NO0nzyik9SvmiHRiNlBNRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfV4/p3B8Z5D9hqy4E89xwnjq9ib1+r6HUtfB16gmd+IhQscVA0uyC3d24zpXvNdp
         APnpDWNYH7DHdw0aKdoxg+JOvr6MxPRylmmRWSr1Kep0d/TVBAvfY0Cq69byBzKXRu
         sp3fIVaOIaGpilB7CQeoNl6EfNwlNzJ5XjUDoddk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/321] openrisc: Fix broken paths to arch/or32
Date:   Tue,  3 Dec 2019 23:33:43 +0100
Message-Id: <20191203223435.311990013@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 57ce8ba0fd3a95bf29ed741df1c52bd591bf43ff ]

OpenRISC was mainlined as "openrisc", not "or32".
vmlinux.lds is generated from vmlinux.lds.S.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/entry.S | 2 +-
 arch/openrisc/kernel/head.S  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 0c826ad6e994c..ee6159d2ed22e 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -240,7 +240,7 @@ handler:							;\
  *	 occured. in fact they never do. if you need them use
  *	 values saved on stack (for SPR_EPC, SPR_ESR) or content
  *       of r4 (for SPR_EEAR). for details look at EXCEPTION_HANDLE()
- *       in 'arch/or32/kernel/head.S'
+ *       in 'arch/openrisc/kernel/head.S'
  */
 
 /* =====================================================[ exceptions] === */
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 9fc6b60140f00..31ed257ff0618 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -1728,7 +1728,7 @@ _string_nl:
 
 /*
  * .data section should be page aligned
- *	(look into arch/or32/kernel/vmlinux.lds)
+ *	(look into arch/openrisc/kernel/vmlinux.lds.S)
  */
 	.section .data,"aw"
 	.align	8192
-- 
2.20.1



