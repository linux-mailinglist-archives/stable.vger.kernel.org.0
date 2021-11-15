Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A17845148D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbhKOUKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344709AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B6B60296;
        Mon, 15 Nov 2021 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002974;
        bh=oTkyhWfmYqDWnLLRDCHxv5pyj66b4y3nYOLkGXkxXoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yY83a8jWBqeALWbTGtwBNtlCB/1tDk+KbsUBKM1lhT1wlksQVeM4u4fLvIiPyVEDm
         KteSsFHdm9N+9DLHme80BeYD4m4ulhU0AWcuXsLWAdSfwbhBPStmF6JfxVVLXU0iIq
         Ekz9saxAuNFchtnc2lb4zVBGX7xw2k53VNfeGh/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 764/917] kselftests/net: add missed icmp.sh test to Makefile
Date:   Mon, 15 Nov 2021 18:04:19 +0100
Message-Id: <20211115165454.831672223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit ca3676f94b8f40f52d285f9aef36dfd6725bfc14 ]

When generating the selftests to another folder, the icmp.sh test will
miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7e9838b7915e ("selftests/net: Add icmp.sh for testing ICMP dummy address responses")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 492b273743b4e..9b1c2dfe12530 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -12,7 +12,7 @@ TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_a
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
 TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
-TEST_PROGS += altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
+TEST_PROGS += altnames.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh
 TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
-- 
2.33.0



