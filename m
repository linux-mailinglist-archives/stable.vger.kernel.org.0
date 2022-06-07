Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7339E54063B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346980AbiFGReJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347697AbiFGRa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919E411AFCB;
        Tue,  7 Jun 2022 10:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B53B8220B;
        Tue,  7 Jun 2022 17:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A8C385A5;
        Tue,  7 Jun 2022 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622880;
        bh=K0QWiNF3r/Zjfy7ARiaA4el2hHfsXadyhFLa3hz1gMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EprLPHjK/DGRp48Yem/6XXKYStpQlQsaAVDyOueRdChj8YcanYtivEd5i7nK5VU5G
         JBIYmfFaoVGdfZe9iA2B4+AETjQtF35Hf1cJpeO9TaaIgIlMzUg39WSkphVs84AbbW
         HPXrMGiY8heOmellHngAnGuCnAigSbtdMC+4QAVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/452] Bluetooth: L2CAP: Rudimentary typo fixes
Date:   Tue,  7 Jun 2022 19:01:14 +0200
Message-Id: <20220607164915.027409327@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

[ Upstream commit 5153ceb9e622f4e27de461404edc73324da70f8c ]

s/minium/minimum/
s/procdure/procedure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 012c1a0abda8..ad33c592cde4 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1689,7 +1689,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
 		smp_conn_security(hcon, hcon->pending_sec_level);
 
 	/* For LE slave connections, make sure the connection interval
-	 * is in the range of the minium and maximum interval that has
+	 * is in the range of the minimum and maximum interval that has
 	 * been configured for this connection. If not, then trigger
 	 * the connection update procedure.
 	 */
@@ -7540,7 +7540,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
 	/* If we receive data on a fixed channel before the info req/rsp
-	 * procdure is done simply assume that the channel is supported
+	 * procedure is done simply assume that the channel is supported
 	 * and mark it as ready.
 	 */
 	if (chan->chan_type == L2CAP_CHAN_FIXED)
-- 
2.35.1



