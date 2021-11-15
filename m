Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B7E450F4D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbhKOS31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241284AbhKOSYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34B2E61B51;
        Mon, 15 Nov 2021 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998885;
        bh=/RyQmy7alRRUROKr1MUoMElgjp4RGg5lKLKbd/ODoGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6V/6sRwsAUcGSs4Azro5MoS6RLP9W7fXGTZZEFQjkFk1bKAMPMnL8GAhXSygLJCs
         tq9e2zI99+umIArB6U/fjycuMPJy5SAzQPGJHxuqMnSMPpil03ul9hpduPoQDR03Wg
         r3QyVGogtiCNU+QL1K77yBNjCeR7JZcQZ1ymPuAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/849] net/smc: Correct spelling mistake to TCPF_SYN_RECV
Date:   Mon, 15 Nov 2021 17:52:59 +0100
Message-Id: <20211115165423.334804774@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index c038efc23ce38..78b663dbfa1f9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1057,7 +1057,7 @@ static void smc_connect_work(struct work_struct *work)
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



