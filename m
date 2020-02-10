Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2508E157B81
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgBJNaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgBJMgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:12 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CB2724650;
        Mon, 10 Feb 2020 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338171;
        bh=rD34lhKh+FQB4mc6OPyXfZnwI4SJbbFmn3ilKrwnvLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJW3XMscZXC5zn6fhZRR8Hw53xJZsfC219+AYy+3SzawTxFH5YrphDMaUJCYsxWm/
         fx7VG36GCCHbqsdT6fl7nqYnyw2a7qxlooxvkUuwe/04qlx/apuNl3fBNhXnwK1q9+
         wteWuDG/9+zpcEP0VN53wDr7plRMexQyYiqfCLDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 155/195] net: smc911x: Adjust indentation in smc911x_phy_configure
Date:   Mon, 10 Feb 2020 04:33:33 -0800
Message-Id: <20200210122320.540699490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 5c61e223004b3b5c3f1dd25718e979bc17a3b12d upstream.

Clang warns:

../drivers/net/ethernet/smsc/smc911x.c:939:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         if (!lp->ctl_rfduplx)
         ^
../drivers/net/ethernet/smsc/smc911x.c:936:2: note: previous statement
is here
        if (lp->ctl_rspeed != 100)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 0a0c72c9118c ("[PATCH] RE: [PATCH 1/1] net driver: Add support for SMSC LAN911x line of ethernet chips")
Link: https://github.com/ClangBuiltLinux/linux/issues/796
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/smsc/smc911x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -947,7 +947,7 @@ static void smc911x_phy_configure(struct
 	if (lp->ctl_rspeed != 100)
 		my_ad_caps &= ~(ADVERTISE_100BASE4|ADVERTISE_100FULL|ADVERTISE_100HALF);
 
-	 if (!lp->ctl_rfduplx)
+	if (!lp->ctl_rfduplx)
 		my_ad_caps &= ~(ADVERTISE_100FULL|ADVERTISE_10FULL);
 
 	/* Update our Auto-Neg Advertisement Register */


