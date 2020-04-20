Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CBF1B0B32
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgDTMyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgDTMq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:46:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13FCB206DD;
        Mon, 20 Apr 2020 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386787;
        bh=7CwSGAnApzkj0TifNjJBsWcj8qqd9Xu9EoZHAW2GmvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQE6TJngJA1w/4OKEOpyZKTjLhs0siYNhbFpMX2UxP0BtLgzKScwzZqOYjNYYm/AQ
         RIWAWl1paJmfjN1EIZ0VdCy9OP1BbJzKDj7fJe8KU4tL0qx1cWTTMkUgq32np67VfZ
         apkZD/morSius8048n7QTuug8vRfSTi2cVCsTepI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Meneguele <bmeneg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 26/60] net/bpfilter: remove superfluous testing message
Date:   Mon, 20 Apr 2020 14:39:04 +0200
Message-Id: <20200420121508.801804622@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruno Meneguele <bmeneg@redhat.com>

commit 41c55ea6c2a7ca4c663eeec05bdf54f4e2419699 upstream.

A testing message was brought by 13d0f7b814d9 ("net/bpfilter: fix dprintf
usage for /dev/kmsg") but should've been deleted before patch submission.
Although it doesn't cause any harm to the code or functionality itself, it's
totally unpleasant to have it displayed on every loop iteration with no real
use case. Thus remove it unconditionally.

Fixes: 13d0f7b814d9 ("net/bpfilter: fix dprintf usage for /dev/kmsg")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bpfilter/main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -35,7 +35,6 @@ static void loop(void)
 		struct mbox_reply reply;
 		int n;
 
-		fprintf(debug_f, "testing the buffer\n");
 		n = read(0, &req, sizeof(req));
 		if (n != sizeof(req)) {
 			fprintf(debug_f, "invalid request %d\n", n);


