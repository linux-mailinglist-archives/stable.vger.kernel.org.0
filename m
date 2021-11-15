Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3043A451EDB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244758AbhKPAhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344717AbhKOTZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7FC636BA;
        Mon, 15 Nov 2021 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002982;
        bh=wQ3ijpmlWoNmTCBki1mPMfUrL5bgRaFJxUnxnd64jSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffk5ArpLLZVaQkHpzyZ5Sq+A40KitEPn5qyYb0Q/MGYV8gFVyFaRMy6+TukcrCaDi
         pEe1Y8DeWBCkLTZIYKzx+zpUs0fsW/br1nSnywTyu3yWputjuftGDStX9qkiwsPSUM
         uVJ/2Pq0bNFp90g8LRt6l9xLbpFKzjG43L4uirok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 766/917] kselftests/net: add missed SRv6 tests
Date:   Mon, 15 Nov 2021 18:04:21 +0100
Message-Id: <20211115165454.907002266@linuxfoundation.org>
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

[ Upstream commit 653e7f19b4a0a632cead2390281bde352d3d3273 ]

When generating the selftests to another folder, the SRv6 tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Fixes: 2bc035538e16 ("selftests: add selftest for the SRv6 End.DT6 (VRF) behavior")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 63ee01c1437b6..8a6264da52763 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,6 +28,9 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
+TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.33.0



