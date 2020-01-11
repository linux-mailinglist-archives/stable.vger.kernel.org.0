Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15AC913808E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgAKKbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:31:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgAKKbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:31:20 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F4B20842;
        Sat, 11 Jan 2020 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738679;
        bh=IcAf5GWaWV+M9qR9GNjimHZIHg9mUcpicUl2jZMA1JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUEmNxT/QntqFbKTpUcGhyWSldCq7KfoOgONPpvEyGB4QpWsbaXk4+qzGf0f5Jjw3
         pbpHWcLJdSykE7tjSTDsQkQvZ2hRE7PbwCJQJ6p2iRnol1VI8IWY+NFO8k4/Bmw9cx
         p0a+jYJur2WyW7O/i69YBevDBEDKYClTxx912RCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/165] selftests: pmtu: fix init mtu value in description
Date:   Sat, 11 Jan 2020 10:50:55 +0100
Message-Id: <20200111094937.214323515@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 152044775d0b9a9ed9509caed40efcba2677951d ]

There is no a_r3, a_r4 in the testing topology.
It should be b_r1, b_r2. Also b_r1 mtu is 1400 and b_r2 mtu is 1500.

Fixes: e44e428f59e4 ("selftests: pmtu: add basic IPv4 and IPv6 PMTU tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index d697815d2785..71a62e7e35b1 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -11,9 +11,9 @@
 #	R1 and R2 (also implemented with namespaces), with different MTUs:
 #
 #	  segment a_r1    segment b_r1		a_r1: 2000
-#	.--------------R1--------------.	a_r2: 1500
-#	A                               B	a_r3: 2000
-#	'--------------R2--------------'	a_r4: 1400
+#	.--------------R1--------------.	b_r1: 1400
+#	A                               B	a_r2: 2000
+#	'--------------R2--------------'	b_r2: 1500
 #	  segment a_r2    segment b_r2
 #
 #	Check that PMTU exceptions with the correct PMTU are created. Then
-- 
2.20.1



