Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5515A304B7C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAZEpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbhAYSmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56AA5206B2;
        Mon, 25 Jan 2021 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600134;
        bh=kQ38umAKWVsDV+fLqjxbuXs7+lKRqag3m1nfj79qei0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RqqeUh3ZXVCFmbgjdRkxxwuwo7ayPwKHX66IJEJu3yfO8PixEbJTtWndL2aL12Sw
         B2y7SMJMVveGquy4qVY1E8O7YG+ugkSsJkhKCTfQ6S16EPHqCOrJi6remO5zKmcBA4
         vfh1u4+MPpWthMV1rn2FX3ZiFN5NzyppaDYxZW4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/58] selftests: net: fib_tests: remove duplicate log test
Date:   Mon, 25 Jan 2021 19:39:28 +0100
Message-Id: <20210125183157.861861091@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit fd23d2dc180fccfad4b27a8e52ba1bc415d18509 ]

The previous test added an address with a specified metric and check if
correspond route was created. I somehow added two logs for the same
test. Remove the duplicated one.

Reported-by: Antoine Tenart <atenart@redhat.com>
Fixes: 0d29169a708b ("selftests/net/fib_tests: update addr_metric_test for peer route testing")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20210119025930.2810532-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_tests.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 67048f922ff20..a5ba149761bf9 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -987,7 +987,6 @@ ipv6_addr_metric_test()
 
 	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 260"
 	log_test $? 0 "Set metric with peer route on local side"
-	log_test $? 0 "User specified metric on local address"
 	check_route6 "2001:db8:104::2 dev dummy2 proto kernel metric 260"
 	log_test $? 0 "Set metric with peer route on peer side"
 
-- 
2.27.0



