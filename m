Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D53667F3A
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 20:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbjALT3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 14:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbjALT2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 14:28:54 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33170183B7;
        Thu, 12 Jan 2023 11:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673551438; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=d1H0iHv3eINUjSVI/qw9sh3R6EuiW1xEagXO3p1EoN13ZdLqGwzJ/wIuvVNY9EI3bb
    jiMlT6NDAqNLIw+0dNlJJ8q6/8xgTsKUWWkBqSE4VbvMQbkTsiCTY0tmmrstQTVaAL9s
    dTYMggaSQ2xfsdNDyJncWbVo/kGqLii9djag27E0E9yeGFQSjzgHZfPqpMFQAtNA4tF3
    BXCLjFDgocr6Whpzd77PUrVZ85ZqN5Gxt5Mdm8csA1vOQ25N2/UTbaQilmVWleHeSInP
    m2JQjMnxDtEYzECBvMP755bRRoXlJ4i1OLKJ+1ykR8cqT8F1uBFmG0TXdfrkzba/KlBC
    +BJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1673551438;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=3S1+jFNEPkXS93Zqg3C7m1AxZE5xUILlZQ/gHF3AgC8=;
    b=UxP/8Dcfm/T8pifgoABs9Eg8ZSstrAAlY58NVBexS4OEZpTEk93+VPSNJqyfzDXm7v
    TqXlorGee/GzMHM4mv4j7H+pWQjxHz5Cw0xlhRg4Hc9e/WXjctD4nw4wtwKssWQT3Rra
    yU2Vy/I6UPHqhVool7u7zZwh/jazELB5LzRGUMIJg5tiBBc3jXLDPx0nYG6Rj1fjsHnm
    qvcFITQSBDk/tgtaPEfufQuR0W7M5fGY4wkHGz8iMWmkh+Q2TVdbkRgG0f4jkxV8UZyM
    PYIfYHAa2JfBt8PC2l9b1K5/kjOjzf1/E3K3CGSGZ41yqOq7gtnEdg+q9uh82xPg/XxL
    DRbA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1673551438;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=3S1+jFNEPkXS93Zqg3C7m1AxZE5xUILlZQ/gHF3AgC8=;
    b=XMOd94Y1jZJQ4pz0ZvpcUcTQbZBQaz4QT2UvbOKiWYVAMijAqOJrliF7zEoiVYmfZl
    6OAjC27FidlckvJXcUpyQFlyngVMjWquaDyLjc3dlypeLtf02FqUgv/V11h0KEA8dkSq
    b0olrWkwN2BLfHiyUYCeJRFzuzdaTOa2Pb0KZrLzlvKwAwKSY4leeCfZ3IqUbFrsFqHX
    TVq5SyXp62CNg6IQKYaFsod/rU0V/ZYNi3GQqkcRrmBfAiLygiBk5PeUMQRosYAqxDnY
    28lNJvFTR0KRpLSEln0PTlJDm70vW25vV/JRsN7QJQG4PooE5n6h3Z3/KUzma3fOZt7U
    RK/Q==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJygjsS+Kjg=="
Received: from silver.lan
    by smtp.strato.de (RZmta 48.6.2 DYNA|AUTH)
    with ESMTPSA id ifa639z0CJNw4OA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 12 Jan 2023 20:23:58 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, stable@vger.kernel.org
Subject: [PATCH v4] can: isotp: handle wait_event_interruptible() return values
Date:   Thu, 12 Jan 2023 20:23:47 +0100
Message-Id: <20230112192347.1944-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When wait_event_interruptible() has been interrupted by a signal the
tx.state value might not be ISOTP_IDLE. Force the state machines
into idle state to inhibit the timer handlers to continue working.

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx
processing")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---

V2: fixed checkpatch warnings m(
V3: added 'Fixes:' tag
V4: change 'Fixes:' tag to reduce WARN(1) possibility

 net/can/isotp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 0476a506d4a4..fc81d77724a1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1150,10 +1150,14 @@ static int isotp_release(struct socket *sock)
 	net = sock_net(sk);
 
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occurred */
+	so->tx.state = ISOTP_IDLE;
+	so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);
 		schedule_timeout_uninterruptible(1);
 		spin_lock(&isotp_notifier_lock);
-- 
2.30.2

