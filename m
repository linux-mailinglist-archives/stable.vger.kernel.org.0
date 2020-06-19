Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED09201298
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405399AbgFSPxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393003AbgFSPW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A529D21548;
        Fri, 19 Jun 2020 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580146;
        bh=A2+BCgXzsTy6M9FbSpUV6W6SaqFDrv7zQvC2USjwbbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4sKLI1ABCkDnBAYDmKGQPuo/t79RzBa0yLfpQinQyclZqG6OxySOEFGJklLn1/ie
         2FCCf0G8mASE/SX41KeG6zePMdnotVyxL0hGerG+GUd+dcTfm4EvwEoZpCyU2f4FUo
         JMbjY0uUKPFfA64FwpTylr3WJ5yUNEaWRwzlCNTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 139/376] drivers/perf: hisi: Fix typo in events attribute array
Date:   Fri, 19 Jun 2020 16:30:57 +0200
Message-Id: <20200619141716.914080032@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

[ Upstream commit 88562f06ebf56587788783e5420f25fde3ca36c8 ]

Fix up one typo: wr_dr_64b -> wr_ddr_64b.

Fixes: 2bab3cf9104c ("perf: hisi: Add support for HiSilicon SoC HHA PMU driver")
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1587643530-34357-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
index 6a1dd72d8abb..e5af9d7e6e14 100644
--- a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
@@ -283,7 +283,7 @@ static struct attribute *hisi_hha_pmu_events_attr[] = {
 	HISI_PMU_EVENT_ATTR(rx_wbip,		0x05),
 	HISI_PMU_EVENT_ATTR(rx_wtistash,	0x11),
 	HISI_PMU_EVENT_ATTR(rd_ddr_64b,		0x1c),
-	HISI_PMU_EVENT_ATTR(wr_dr_64b,		0x1d),
+	HISI_PMU_EVENT_ATTR(wr_ddr_64b,		0x1d),
 	HISI_PMU_EVENT_ATTR(rd_ddr_128b,	0x1e),
 	HISI_PMU_EVENT_ATTR(wr_ddr_128b,	0x1f),
 	HISI_PMU_EVENT_ATTR(spill_num,		0x20),
-- 
2.25.1



