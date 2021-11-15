Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0EB450CFC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhKORri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238593AbhKORpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF64063304;
        Mon, 15 Nov 2021 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997342;
        bh=zG4N/pQ9zYolyd0rmOxJS0gQCaw8RfF3fnGAOMjwAnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0o1LFq8gyBs9ap27IkSveMDFiA/bWXMavB/WHF7RVNZT3Ak3A5mM0kufjRwvXJr15
         zdl/m49tBjkLXDjZCssSgRRj0wX7tQViUJCBNkI6nyjKezooXbuR2syTELcVs42znc
         in9eVbLjQ/Jn02FzGgjQwVHL8N+BLC2P/5W3nLEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/575] net/smc: Correct spelling mistake to TCPF_SYN_RECV
Date:   Mon, 15 Nov 2021 17:56:46 +0100
Message-Id: <20211115165346.450812820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit f3a3a0fe0b644582fa5d83dd94b398f99fc57914 ]

There should use TCPF_SYN_RECV instead of TCP_SYN_RECV.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 030d7f30b13fe..cc2af94e74507 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1018,7 +1018,7 @@ static void smc_connect_work(struct work_struct *work)
 	if (smc->clcsock->sk->sk_err) {
 		smc->sk.sk_err = smc->clcsock->sk->sk_err;
 	} else if ((1 << smc->clcsock->sk->sk_state) &
-					(TCPF_SYN_SENT | TCP_SYN_RECV)) {
+					(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		rc = sk_stream_wait_connect(smc->clcsock->sk, &timeo);
 		if ((rc == -EPIPE) &&
 		    ((1 << smc->clcsock->sk->sk_state) &
-- 
2.33.0



