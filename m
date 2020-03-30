Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC9197951
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 12:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgC3Kcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 06:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbgC3Kcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 06:32:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092B320716;
        Mon, 30 Mar 2020 10:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585564354;
        bh=OJiofvJJdkFuZv3l/ni382jQ7nPGMi0ZU0MYitxmsO0=;
        h=Subject:To:From:Date:From;
        b=uaEoDtKkTFV3lSMcGQgGmC4tsMACbDvYz/RlKr+4GCZBA1X+niu9M01YWkAqhEUuk
         KfPLtJXGIvwHk27iaChwLROL9tbtwjpoRR9S59JUXmEjFP8aO/pjy7ijGutO4JNg9N
         PxJjicjHPVsgzReVYby/nzfiFq4KjLBLQaDm18Is=
Subject: patch "misc: rtsx: set correct pcr_ops for rts522A" added to char-misc-next
To:     yuehaibing@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 12:32:12 +0200
Message-ID: <15855643324964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: rtsx: set correct pcr_ops for rts522A

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 10cea23b6aae15e8324f4101d785687f2c514fe5 Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 26 Mar 2020 11:26:18 +0800
Subject: misc: rtsx: set correct pcr_ops for rts522A

rts522a should use rts522a_pcr_ops, which is
diffrent with rts5227 in phy/hw init setting.

Fixes: ce6a5acc9387 ("mfd: rtsx: Add support for rts522A")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200326032618.20472-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rts5227.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cardreader/rts5227.c b/drivers/misc/cardreader/rts5227.c
index 423fecc19fc4..3a9467aaa435 100644
--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -394,6 +394,7 @@ static const struct pcr_ops rts522a_pcr_ops = {
 void rts522a_init_params(struct rtsx_pcr *pcr)
 {
 	rts5227_init_params(pcr);
+	pcr->ops = &rts522a_pcr_ops;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(20, 20, 11);
 	pcr->reg_pm_ctrl3 = RTS522A_PM_CTRL3;
 
-- 
2.26.0


