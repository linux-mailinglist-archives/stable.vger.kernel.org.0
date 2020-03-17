Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165F8187F8E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCQLC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgCQLCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:02:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8EAE20658;
        Tue, 17 Mar 2020 11:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442945;
        bh=OYEWaCPqZTDX9qCgwnlLOmEk8osMuwE31g8YAdQZNzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lh3wsku4p94/ATgBv6fwdIYWztGBVOcOuK4Pfz904xqI/8Nq0XsSBNPj59JzZqcGj
         VZKb0k+yALx+YXBsx1rqi6BvxlaWbjWadiCAi9AYXEwRMLD5xQC6vJaAXE4laUqtsT
         Zr8UzCHXK4FnVp086A3eyVMnBSbp2Ixclqz3/eR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 044/123] net: taprio: add missing attribute validation for txtime delay
Date:   Tue, 17 Mar 2020 11:54:31 +0100
Message-Id: <20200317103312.321516007@linuxfoundation.org>
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

[ Upstream commit e13aaa0643da10006ec35715954e7f92a62899a5 ]

Add missing attribute validation for TCA_TAPRIO_ATTR_TXTIME_DELAY
to the netlink policy.

Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -774,6 +774,7 @@ static const struct nla_policy taprio_po
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]           = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
 };
 
 static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,


