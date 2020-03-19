Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B15918B509
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgCSNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgCSNO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BCD821556;
        Thu, 19 Mar 2020 13:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623697;
        bh=pSEs/hEnsGS9DdFtBvKtx6cusZIGkWIBMY4c2zhPwDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crqltxumXTN9Gurdnv/0ht1O0CyQLE0MbHBNVTrvn4S26gEN0ozVdIWvLMR0MG84L
         XqL9MqYVTMfow4HkyXqLdxGuTdwyrktFCXs0WIed4Q4kBwpEVZXScIwO9iBA80+/ms
         aL/7CvAPi96jpRTUIYMq445q0o/jZbsIUneqTRdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 23/99] net: fq: add missing attribute validation for orphan mask
Date:   Thu, 19 Mar 2020 14:03:01 +0100
Message-Id: <20200319123948.805531082@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e6dc03eeb023e18427a373522f1d247b916a641 ]

Add missing attribute validation for TCA_FQ_ORPHAN_MASK
to the netlink policy.

Fixes: 06eb395fa985 ("pkt_sched: fq: better control of DDOS traffic")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -695,6 +695,7 @@ static const struct nla_policy fq_policy
 	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
 	[TCA_FQ_BUCKETS_LOG]		= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_REFILL_DELAY]	= { .type = NLA_U32 },
+	[TCA_FQ_ORPHAN_MASK]		= { .type = NLA_U32 },
 	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
 };
 


