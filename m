Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07AD47ADFE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbhLTO5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhLTOzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B29C08EC68;
        Mon, 20 Dec 2021 06:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DAEB80EE3;
        Mon, 20 Dec 2021 14:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED36C36AF9;
        Mon, 20 Dec 2021 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011697;
        bh=o559lHm/Zen814t1bp4YnrRHLiihTw3nOOmnrHt60/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fc4qvWXpbAgOKVdeRIFOUmxF/vLPWTJ+b2IaeOrRRQLRzybhkaXezaS8gfxx9xCpf
         KatMl2CSa8MbfUbhEdjdzBogvM3o7O83AZAZMFmoNkB9Tfq/1E2qVP5YPwCrJ7Qtjc
         ipp2xApfp8hi2QfKLq4KwFR9UPwLGN6M6xFMqpEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/99] selftest/net/forwarding: declare NETIFS p9 p10
Date:   Mon, 20 Dec 2021 15:34:14 +0100
Message-Id: <20211220143030.764487682@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index e5e2fbeca22ec..e51def39fd801 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -13,6 +13,8 @@ NETIFS[p5]=veth4
 NETIFS[p6]=veth5
 NETIFS[p7]=veth6
 NETIFS[p8]=veth7
+NETIFS[p9]=veth8
+NETIFS[p10]=veth9
 
 # Port that does not have a cable connected.
 NETIF_NO_CABLE=eth8
-- 
2.33.0



