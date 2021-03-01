Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F17328B4D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbhCAScp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239579AbhCASXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:23:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30120652E4;
        Mon,  1 Mar 2021 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620352;
        bh=DnEXBEgLSQq0dS3zHxsf4TgSIOOsvwY5gs3HOpsBycs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYqwhIT4Wwb3RmWs7QMuGVAiOsRrbNG5BEwYNybFR69CKXWN5t6TJrK0dvBhBIp/S
         iH++P2YJg/AgmDQvLNdTGM03gw//6ESm6IlTxeByfLGtWI4BSAm7NvHbj9R5PHn6A6
         Ag20X+Q+OEkfcXihU5rwr5A2Rr2Sm1sEvCBrvmXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 122/775] selftests: mptcp: fix ACKRX debug message
Date:   Mon,  1 Mar 2021 17:04:50 +0100
Message-Id: <20210301161207.700705117@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit f384221a381751508f390b36d0e51bd5a7beb627 ]

Info from received MPCapable SYN were printed instead of the ones from
received MPCapable 3rd ACK.

Fixes: fed61c4b584c ("selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 2cfd87d94db89..e927df83efb91 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -493,7 +493,7 @@ do_transfer()
 		echo "${listener_ns} SYNRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
 	fi
 	if [ $expect_ackrx -ne $stat_ackrx_now_l ] ;then
-		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
+		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_ackrx}, got ${stat_ackrx_now_l} "
 	fi
 
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
-- 
2.27.0



