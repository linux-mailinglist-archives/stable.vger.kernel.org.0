Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A027C438
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgI2LMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgI2LMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D3220848;
        Tue, 29 Sep 2020 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377929;
        bh=mBq3HRnZpYAa0n/BmMqY8IXTKdIxNWbjeafZfJ4ORB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYd1dLMJO/sIrvDdCdEz1RyHSFNYxBoTHQDW5dwZC0GJlRF4qYppmqzBtU0HD0qPu
         H6eAKqTRZnNRDyuNvfgO/p8youpOMOAQpjS9fcdNxlg+WV7RzekcmdycpE6Z1+ENYN
         SezikXyPbEJiSrxvnusm5hMwaOMsTmnCye1/HPoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/121] MIPS: Add the missing CPU_1074K into __get_cpu_type()
Date:   Tue, 29 Sep 2020 13:01:00 +0200
Message-Id: <20200929105935.931581357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit e393fbe6fa27af23f78df6e16a8fd2963578a8c4 ]

Commit 442e14a2c55e ("MIPS: Add 1074K CPU support explicitly.") split
1074K from the 74K as an unique CPU type, while it missed to add the
'CPU_1074K' in __get_cpu_type(). So let's add it back.

Fixes: 442e14a2c55e ("MIPS: Add 1074K CPU support explicitly.")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-type.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/include/asm/cpu-type.h b/arch/mips/include/asm/cpu-type.h
index bdd6dc18e65c6..941efd8783344 100644
--- a/arch/mips/include/asm/cpu-type.h
+++ b/arch/mips/include/asm/cpu-type.h
@@ -47,6 +47,7 @@ static inline int __pure __get_cpu_type(const int cpu_type)
 	case CPU_34K:
 	case CPU_1004K:
 	case CPU_74K:
+	case CPU_1074K:
 	case CPU_M14KC:
 	case CPU_M14KEC:
 	case CPU_INTERAPTIV:
-- 
2.25.1



