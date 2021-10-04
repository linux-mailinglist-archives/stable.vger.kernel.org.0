Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A5142104F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhJDNmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238489AbhJDNkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D0A63257;
        Mon,  4 Oct 2021 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353524;
        bh=9a1cAP4z/EvByEgNLNZaOGNxAthBCtun9wgjHMIVnTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+hz55D9CIaJt+rtNKF8TftCfNHrPfIS3o0/GHUIy1OcMyXR0s3w+4pchQnFqErJo
         DNXW3TvauqPjZPJVHXqt004OeDHxTEQBbeWtA/H90xvuZemAngPG3W+lWtYIPNqO+8
         AyabTXc2eZLTl2iZHUT6g8rST0xHLasKGNHnxvaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.14 161/172] NIOS2: setup.c: drop unused variable dram_start
Date:   Mon,  4 Oct 2021 14:53:31 +0200
Message-Id: <20211004125050.171737048@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 9523b33cc31cf8ce703f8facee9fd16cba36d5ad upstream.

This is a nuisance when CONFIG_WERROR is set, so drop the variable
declaration since the code that used it was removed.

../arch/nios2/kernel/setup.c: In function 'setup_arch':
../arch/nios2/kernel/setup.c:152:13: warning: unused variable 'dram_start' [-Wunused-variable]
  152 |         int dram_start;

Fixes: 7f7bc20bc41a ("nios2: Don't use _end for calculating min_low_pfn")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andreas Oetken <andreas.oetken@siemens.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -149,8 +149,6 @@ static void __init find_limits(unsigned
 
 void __init setup_arch(char **cmdline_p)
 {
-	int dram_start;
-
 	console_verbose();
 
 	memory_start = memblock_start_of_DRAM();


