Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616EF38A1BE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhETJen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232626AbhETJcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F050613EC;
        Thu, 20 May 2021 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502901;
        bh=BJZWuPlOfRIpUPB/asClPwuWMv56Nr+MykmBPYnkELk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjd2TcZhHZOYdpBPLuJqBI3DrGfROlOyb7WN8MHjipdxWqglBAowg66EGrSw1Iem4
         BrOYqNceJAwgWooNEC1IzR2Qd8Jt388lg8gYK88YXy2/ylNIcjxb0rcHu07DOHLU6F
         wNWA9eLkD4bVgqyEMRTsMVbFQw6fHD0cgoL3pDJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tosk Robot <tencent_os_robot@tencent.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 04/37] cxgb4: Fix the -Wmisleading-indentation warning
Date:   Thu, 20 May 2021 11:22:25 +0200
Message-Id: <20210520092052.414383120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
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
@@ -2690,7 +2690,7 @@ do { \
 	seq_printf(seq, "%-12s", s); \
 	for (i = 0; i < n; ++i) \
 		seq_printf(seq, " %16" fmt_spec, v); \
-		seq_putc(seq, '\n'); \
+	seq_putc(seq, '\n'); \
 } while (0)
 #define S(s, v) S3("s", s, v)
 #define T3(fmt_spec, s, v) S3(fmt_spec, s, tx[i].v)


