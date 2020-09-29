Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC427C728
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgI2Lvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbgI2LsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0A1206E5;
        Tue, 29 Sep 2020 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380093;
        bh=rpuIwHjr5pp8dtzsOLBHJuohrMMKLDs8y2804w8H0RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9XJspHHC/B1lCaoCxVIWp9XeTU3Sjco1k9QkSDDSedxS/3ieziTMUUFETZGFBiqw
         MCNbAC77DAfsK6KB92zoM4L7pUsuOcABebduMttJWLbnY//ZvHbDWI/kJb0sf4+E2S
         0ZkuwBylhJNH2y16Mm1ipX3N2GFD826R+Rzv//Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 65/99] MIPS: Add the missing CPU_1074K into __get_cpu_type()
Date:   Tue, 29 Sep 2020 13:01:48 +0200
Message-Id: <20200929105932.929447184@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
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
index 75a7a382da099..3288cef4b168c 100644
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



