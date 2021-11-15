Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6CD451EDC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349372AbhKPAhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344716AbhKOTZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF236636C5;
        Mon, 15 Nov 2021 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002985;
        bh=D4GaJTJLQMbZqhGCWyYLGkSy5VWZRYXYx5cN52JO1XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tu6aOqLVm/2v5cRQAnjpz7hNWy/eKH/3XqYuXm+mW1bWQ1SrfROuV8bmzrJFrsvYg
         i5cnVq/Rx9od163dPM5ImafIxILw1N8KY8Rg+wDivLw8VFrQD5S7V+Gs3bTYhqgBYw
         YBoFlKu7Fta/Uy0VoSVnqAJ0AINnClucsY7anVHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 767/917] kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
Date:   Mon, 15 Nov 2021 18:04:22 +0100
Message-Id: <20211115165454.940230208@linuxfoundation.org>
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

[ Upstream commit 8883deb50eb6529ae1fd4641e402da8ab4f720d2 ]

When generating the selftests to another folder, the
vrf_strict_mode_test.sh test will miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 8735e6eaa438 ("selftests: add selftest for the VRF strict mode")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8a6264da52763..7328bede35f05 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -31,6 +31,7 @@ TEST_PROGS += gre_gso.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
+TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.33.0



