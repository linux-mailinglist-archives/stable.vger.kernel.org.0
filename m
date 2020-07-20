Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF002268F9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbgGTQFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732930AbgGTQFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B582176B;
        Mon, 20 Jul 2020 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261101;
        bh=erffx3k8jVgl0Xf9ti2xAmllVE/bSCxeXZxcgTckQvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rg2UuTPtxG3m+eQNB5kSjtEdiu4IBAqG70iYPcyiWu6SCfPDH5qsiHyTANd7U4mKI
         s65IqWBtINNHBVvQ88UguAxaYOA8uSnFSzvjpoWpJRs8pFqZ/vtg2+EuyNvOxEa+NH
         BhkccSouwlqXdC6FO6IJCVR2ScKcGq1eZlndil7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 210/215] rxrpc: Fix trace string
Date:   Mon, 20 Jul 2020 17:38:12 +0200
Message-Id: <20200720152830.139485092@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit aadf9dcef9d4cd68c73a4ab934f93319c4becc47 upstream.

The trace symbol printer (__print_symbolic()) ignores symbols that map to
an empty string and prints the hex value instead.

Fix the symbol for rxrpc_cong_no_change to " -" instead of "" to avoid
this.

Fixes: b54a134a7de4 ("rxrpc: Fix handling of enums-to-string translation in tracing")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/rxrpc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -400,7 +400,7 @@ enum rxrpc_tx_point {
 	EM(rxrpc_cong_begin_retransmission,	" Retrans") \
 	EM(rxrpc_cong_cleared_nacks,		" Cleared") \
 	EM(rxrpc_cong_new_low_nack,		" NewLowN") \
-	EM(rxrpc_cong_no_change,		"") \
+	EM(rxrpc_cong_no_change,		" -") \
 	EM(rxrpc_cong_progress,			" Progres") \
 	EM(rxrpc_cong_retransmit_again,		" ReTxAgn") \
 	EM(rxrpc_cong_rtt_window_end,		" RttWinE") \


