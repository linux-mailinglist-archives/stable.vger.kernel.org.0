Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61AC187FB9
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgCQLEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727564AbgCQLEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905DA2071C;
        Tue, 17 Mar 2020 11:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443040;
        bh=tU1sCskEZyRGbiY69yQ86F1d2qmqMz4UIRtAJdbj7Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P75Hh8v8ShYPLsQhTfCo7vfh6bX+UN2rwoYAhrp6f/8cL6N8mwtkqaODYrq6gso11
         KFTn9x8qCk6BT2GgPVaKCFNbdMSeLSJZxf099LD8HNlv1X/N/SEzLVSXpFCIo5Zi69
         PUFakC9LUeGuppWhq5and0p1Y8rTmdKijT5d9/Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 038/123] fib: add missing attribute validation for tun_id
Date:   Tue, 17 Mar 2020 11:54:25 +0100
Message-Id: <20200317103311.793996925@linuxfoundation.org>
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

[ Upstream commit 4c16d64ea04056f1b1b324ab6916019f6a064114 ]

Add missing netlink policy entry for FRA_TUN_ID.

Fixes: e7030878fc84 ("fib: Add fib rule match on tunnel id")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/fib_rules.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -108,6 +108,7 @@ struct fib_rule_notifier_info {
 	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
 	[FRA_FWMARK]	= { .type = NLA_U32 }, \
+	[FRA_TUN_ID]	= { .type = NLA_U64 }, \
 	[FRA_FWMASK]	= { .type = NLA_U32 }, \
 	[FRA_TABLE]     = { .type = NLA_U32 }, \
 	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 }, \


