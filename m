Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B95B187F8C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgCQLCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbgCQLCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:02:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1703720753;
        Tue, 17 Mar 2020 11:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442942;
        bh=IU13o9mi6MI7gTr6yP0H7azxbuYAal33zHQozvYAp4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6/V32TIpqt/rN2Oub8MvEuMlj98PGNE2uPJgo4NMO06Kgpk4ssOsxZ29/PFyxyqF
         Oz2EBxuGJCzgGUO8YXF6z/h1dhYuk79aymUHarmCWrMLw9P/cqR8r+IHVFuM2qpHXD
         6TAgyY0Fav8qoN+z6Hpb5XPXnud52cXgKq/I6mSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 043/123] net: fq: add missing attribute validation for orphan mask
Date:   Tue, 17 Mar 2020 11:54:30 +0100
Message-Id: <20200317103312.236358175@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
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
@@ -745,6 +745,7 @@ static const struct nla_policy fq_policy
 	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
 	[TCA_FQ_BUCKETS_LOG]		= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_REFILL_DELAY]	= { .type = NLA_U32 },
+	[TCA_FQ_ORPHAN_MASK]		= { .type = NLA_U32 },
 	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
 	[TCA_FQ_CE_THRESHOLD]		= { .type = NLA_U32 },
 };


