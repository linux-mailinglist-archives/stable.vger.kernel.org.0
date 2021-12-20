Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC047ACFE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhLTOsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:48:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbhLTOqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:46:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8802611CE;
        Mon, 20 Dec 2021 14:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDF3C36AE8;
        Mon, 20 Dec 2021 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011572;
        bh=I9BrpdqXY6pVxx7JIhpk5iWnUyuoNCQ+K0xmjUxsctc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqzvaCBzWla3fWhJ0hwqzbDGSpdM8tdSx38RZ02ch7Wk0wg9ZiwsF0F17lUoJsua1
         orTTAEiO/6g6+3IzR0hbXjNopswFNetuEcKmZyW+L45eEXkWDEJYYgZDdiS/dUxWwS
         TwrVah/kmYv0ULPq8Lqr9xhJ1+65bWRgZasYi504=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/71] selftest/net/forwarding: declare NETIFS p9 p10
Date:   Mon, 20 Dec 2021 15:34:15 +0100
Message-Id: <20211220143026.567415734@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 71da1aec215290e249d09c44c768df859f3a3bba ]

The recent GRE selftests defined NUM_NETIFS=10. If the users copy
forwarding.config.sample to forwarding.config directly, they will get
error "Command line is not complete" when run the GRE tests, because
create_netif_veth() failed with no interface name defined.

Fix it by extending the NETIFS with p9 and p10.

Fixes: 2800f2485417 ("selftests: forwarding: Test multipath hashing on inner IP pkts for GRE tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/forwarding.config.sample | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index e2adb533c8fcb..e71c61ee4cc67 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -13,6 +13,8 @@ NETIFS[p5]=veth4
 NETIFS[p6]=veth5
 NETIFS[p7]=veth6
 NETIFS[p8]=veth7
+NETIFS[p9]=veth8
+NETIFS[p10]=veth9
 
 ##############################################################################
 # Defines
-- 
2.33.0



