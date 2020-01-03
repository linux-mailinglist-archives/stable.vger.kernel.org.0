Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C195212F6DA
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgACKss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKss (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:48:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCD021835;
        Fri,  3 Jan 2020 10:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048527;
        bh=gSr0IfMvQ0AYPDXXmTer2JafSwKuRKUy3x4YQ9YE8TI=;
        h=Subject:To:From:Date:From;
        b=YH+SIVg0odcJS5W86KS4C3xth/on5tToq3rAgj8NAnHksCRGjb0gxbAnhfTucOrkC
         LNNhlD3J75GcQB95UuADr9rtVZ7B5yw4S9i+HTC4/fbcS7KOM8RXZwt+sfg/ucIx1q
         TYDDHUWTlyL4P4obIWLcJry/GV/b3TTd2y7gBJZQ=
Subject: patch "staging: vt6656: correct return of vnt_init_registers." added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:37 +0100
Message-ID: <157804851746248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: correct return of vnt_init_registers.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7de6155c8968a3342d1bef3f7a2084d31ae6e4be Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Fri, 20 Dec 2019 21:15:09 +0000
Subject: staging: vt6656: correct return of vnt_init_registers.

The driver standard error returns remove bool false conditions.

Cc: stable <stable@vger.kernel.org> # v5.3+
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/072ec0b3-425f-277e-130c-1e3a116c90d6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4ac85ecb0921..4a5d741f94f5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -949,7 +949,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 
 int vnt_init(struct vnt_private *priv)
 {
-	if (!(vnt_init_registers(priv)))
+	if (vnt_init_registers(priv))
 		return -EAGAIN;
 
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->permanent_net_addr);
-- 
2.24.1


