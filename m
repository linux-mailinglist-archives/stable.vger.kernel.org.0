Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914EF24BB77
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgHTM31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729818AbgHTJve (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7F2220855;
        Thu, 20 Aug 2020 09:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917094;
        bh=q9H5XmIJpocvD6R6zSBseg3DFaubfPFuuWk1/FmItbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaVdu8dMM8AjqlBJzu1CINXdDca+Vzec6mEn+uRdty+MJWRL61i3idnD+Wn7MSrE/
         G2U+2+aqc79Rfnui9Nxn1t7TQ3f6YqPeYZPUcvC70ewHHwqFq1qGK+E3MQUMzHwVwv
         BJ8NvOI/5rGn+izyZ+05+PSqxHsXW+KtdTAKi/HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/152] perf/x86/rapl: Fix missing psys sysfs attributes
Date:   Thu, 20 Aug 2020 11:21:50 +0200
Message-Id: <20200820091601.134965722@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4bb5fcb97a5df0bbc0a27e0252b1e7ce140a8431 ]

This fixes a problem introduced by commit:

  5fb5273a905c ("perf/x86/rapl: Use new MSR detection interface")

that perf event sysfs attributes for psys RAPL domain are missing.

Fixes: 5fb5273a905c ("perf/x86/rapl: Use new MSR detection interface")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20200811153149.12242-2-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 3c222d6fdee3b..187c72a58e69c 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -642,7 +642,7 @@ static const struct attribute_group *rapl_attr_update[] = {
 	&rapl_events_pkg_group,
 	&rapl_events_ram_group,
 	&rapl_events_gpu_group,
-	&rapl_events_gpu_group,
+	&rapl_events_psys_group,
 	NULL,
 };
 
-- 
2.25.1



