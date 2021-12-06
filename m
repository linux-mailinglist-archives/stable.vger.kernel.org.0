Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1105469B6F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350664AbhLFPR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47452 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357956AbhLFPQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3EF8B810E7;
        Mon,  6 Dec 2021 15:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24552C341C2;
        Mon,  6 Dec 2021 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803571;
        bh=GD3/rPmxSQKdnMFtYDYc5S1YQcsfgwwjZqXkIBHwTWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDFGnv2XAAc28AhxweMrNZK6Msqb+lwx32ZUZQUzi4Qalxz9hLnS23DazFHNMHK8b
         NAE9hmZIJg+QpAGT/kixH3kc1X9LuOkGG9jwEWOCo6weUj64XE9xjCrK7HJBtPixKr
         ZhOIukxiPfa0wY3IcE1HpGAzZUl3WoUhkr7ui7U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 41/70] selftests: net: Correct case name
Date:   Mon,  6 Dec 2021 15:56:45 +0100
Message-Id: <20211206145553.357765896@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

commit a05431b22be819d75db72ca3d44381d18a37b092 upstream.

ipv6_addr_bind/ipv4_addr_bind are function names. Previously, bind test
would not be run by default due to the wrong case names

Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
Fixes: 75b2b2b3db4c ("selftests: Add ipv4 address bind tests to fcnal-test")
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fcnal-test.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3450,8 +3450,8 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime ipv6_netfilter"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter"
 TESTS_OTHER="use_cases"
 
 PAUSE_ON_FAIL=no


