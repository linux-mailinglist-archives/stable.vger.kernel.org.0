Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC21F47AF36
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhLTPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhLTPJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16714C0619D8;
        Mon, 20 Dec 2021 06:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA204B80EE9;
        Mon, 20 Dec 2021 14:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C82EC36AE7;
        Mon, 20 Dec 2021 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012086;
        bh=o559lHm/Zen814t1bp4YnrRHLiihTw3nOOmnrHt60/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rs6xC5HwvAlJBAwQbmjTDlmMNBN2+MBqZtNzyoXeK8WUygKmiqCZyeU41ye43e7hI
         VDV6z++HtRFiVJWy2Bxr9oR2FJoIp/uLoEKjzk9FNBO6hzManjxURK0QJQOm+jsgVX
         BMxiw2aAGu7Ld3nCoCUCtvgqzZj5Is3OPntUyT3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/177] selftest/net/forwarding: declare NETIFS p9 p10
Date:   Mon, 20 Dec 2021 15:33:46 +0100
Message-Id: <20211220143042.669492870@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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



