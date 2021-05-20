Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D238AB96
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbhETL0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241064AbhETLYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E647661D96;
        Thu, 20 May 2021 10:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505540;
        bh=mio6hPhY83PnYqXdFIxOZPZ39f5ZW9oWjV6w6IBh27Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZTCm7Y5kUh1HU42+uOExafBs5gU+JJB4UrY+4v2oE0Qd9PNk+iz1kjLtd2ngzQuI
         x9ZiabNfgMKMZS2JaEqjWBWFCUrMwr+ppVthKNaNpAlXrv0NQTw1HnV1xLCJFd4RNx
         SWomk+y7VU64aX3k4XfxuwuzpxQGschbEy3Bu12A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tosk Robot <tencent_os_robot@tencent.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 180/190] cxgb4: Fix the -Wmisleading-indentation warning
Date:   Thu, 20 May 2021 11:24:04 +0200
Message-Id: <20210520092108.111522383@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

commit ea8146c6845799142aa4ee2660741c215e340cdf upstream.

Fix the gcc warning:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c:2673:9: warning: this 'for' clause does not guard... [-Wmisleading-indentation]
 2673 |         for (i = 0; i < n; ++i) \

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Link: https://lore.kernel.org/r/1604467444-23043-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2263,7 +2263,7 @@ do { \
 	seq_printf(seq, "%-12s", s); \
 	for (i = 0; i < n; ++i) \
 		seq_printf(seq, " %16" fmt_spec, v); \
-		seq_putc(seq, '\n'); \
+	seq_putc(seq, '\n'); \
 } while (0)
 #define S(s, v) S3("s", s, v)
 #define T3(fmt_spec, s, v) S3(fmt_spec, s, tx[i].v)


