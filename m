Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DFB4F35C4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiDEKyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346301AbiDEJor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF421D95C9;
        Tue,  5 Apr 2022 02:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A892616B2;
        Tue,  5 Apr 2022 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC27C385A2;
        Tue,  5 Apr 2022 09:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151020;
        bh=XnCP0BcId1i2zXLkrOfs43050SHHb18Q3J3t3MuLkQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeCrh87weRiP6DK36+ShaNGOYwHHNIH89U+fyj6Gtnn942LY1wLujW6bFtUuXg6Va
         FrDSC0jb0IHFMzb2x9kBEWFsdxovBsCa2ymurXBy1ZK8NYYjKrvEI+pMt6PrQjvf/2
         iXuzmqEDnersKa4y30/D0wu9tVzCqmOBJo0RpTdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/913] sched/core: Export pelt_thermal_tp
Date:   Tue,  5 Apr 2022 09:21:50 +0200
Message-Id: <20220405070347.291265751@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 77cf151b7bbdfa3577b3c3f3a5e267a6c60a263b ]

We can't use this tracepoint in modules without having the symbol
exported first, fix that.

Fixes: 765047932f15 ("sched/pelt: Add support to track thermal pressure")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211028115005.873539-1-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a0747eaa2dba..c51bd3692316 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -36,6 +36,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(pelt_rt_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(pelt_dl_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(pelt_irq_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(pelt_se_tp);
+EXPORT_TRACEPOINT_SYMBOL_GPL(pelt_thermal_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_cpu_capacity_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_overutilized_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_util_est_cfs_tp);
-- 
2.34.1



