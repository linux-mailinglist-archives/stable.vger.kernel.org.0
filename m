Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5E18805F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgCQLJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbgCQLJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB8D20719;
        Tue, 17 Mar 2020 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443376;
        bh=OYEWaCPqZTDX9qCgwnlLOmEk8osMuwE31g8YAdQZNzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGycsFf/0f42aFqBE2ds6LTnhkkbB+lJ9B75TrLdbI9eWDD1sY8vIvRAU6Otk0H4r
         eB7w+cgM8nOVIYGzogu+HUJkdS0muf2ZlLOdiibb2vNekCEB9nAtUE75Pc+lPaN9AU
         QxrJtUCfTjnwn6r06y2y/pWu1bPIviS2qdbnPeVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 055/151] net: taprio: add missing attribute validation for txtime delay
Date:   Tue, 17 Mar 2020 11:54:25 +0100
Message-Id: <20200317103330.474024503@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
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


