Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA62D45D4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgLIPwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:52:09 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:47233 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729726AbgLIPwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:52:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 451B01943835;
        Wed,  9 Dec 2020 02:46:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 02:46:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2kqy1s
        feFyNlL8Tuse7rwCD1OPnlg3K24HGQIabHTFA=; b=g1+Hw/tu/BHGEojh9L7jfp
        B7lC+xcROLHOgwD65TO8dNyJD8EHq+yT/GnnuLKiFzF5p9hJ4rWK3eohJ95e/Fr9
        ia04PXyCO2PK36h2aqiH28DLJAF63G7REqS89pazo8WtfNjXCPp6AdVZ9sgsnvMy
        GxpBsD71FpOubW5YgXtHUd9reC5Af3PhrfVbX51HOnmGRxRjsQE+lAecYvyuat0k
        NYbY/xvGE6w1fvObcfffEv+qAzMfSPc+Odd1gTPFRHsYK5/siaLeM4srOl4t0ueC
        7/R6Yt2b7bb6lkxO1T4P/Cjv/kX8gKb+Mgmr24ATFXDEsqOqW1Kav4o2Bc0mDSUg
        ==
X-ME-Sender: <xms:yYDQX4GGoMbONvO317UmkRFQhQzljj5Xtu4b78HzCkWrg-uQFAi4Uw>
    <xme:yYDQXxVHE_AnIuCrDOd-2GfaMyIOfSw5P8ENhym11AJ2igYFkJmHt99zKo6QoB5cw
    LRhQNrMFZfgVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:yYDQXyJ6zj77e7StPKMBzZT8v6cezNANMU6KtFFiLtCikQwgKSiSBg>
    <xmx:yYDQX6H435fPZI2WSFYD4pBnw1RvqQRNvSKt8Mn4GboxW7wRH4FWeg>
    <xmx:yYDQX-VGbfKze41LIvMohMmEi1zGG2MbO1raPJjgwqHUIDZw2oVfrw>
    <xmx:yYDQXxcX57hXR0Nse8ORRdM5rAhwc4MljiFRvOMRcISe8HnZA6PPAA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAA8124005C;
        Wed,  9 Dec 2020 02:46:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] speakup: Reject setting the speakup line discipline outside" failed to apply to 4.4-stable tree
To:     samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        qinshisong1205@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 08:47:29 +0100
Message-ID: <1607500049106150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0992098cadb4c9c6a00703b66cafe604e178fea Mon Sep 17 00:00:00 2001
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Sun, 29 Nov 2020 20:35:23 +0100
Subject: [PATCH] speakup: Reject setting the speakup line discipline outside
 of speakup

Speakup exposing a line discipline allows userland to try to use it,
while it is deemed to be useless, and thus uselessly exposes potential
bugs. One of them is simply that in such a case if the line sends data,
spk_ttyio_receive_buf2 is called and crashes since spk_ttyio_synth
is NULL.

This change restricts the use of the speakup line discipline to
speakup drivers, thus avoiding such kind of issues altogether.

Cc: stable@vger.kernel.org
Reported-by: Shisong Qin <qinshisong1205@gmail.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Tested-by: Shisong Qin <qinshisong1205@gmail.com>
Link: https://lore.kernel.org/r/20201129193523.hm3f6n5xrn6fiyyc@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/accessibility/speakup/spk_ttyio.c b/drivers/accessibility/speakup/spk_ttyio.c
index 669392f31d4e..6284aff434a1 100644
--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -47,27 +47,20 @@ static int spk_ttyio_ldisc_open(struct tty_struct *tty)
 {
 	struct spk_ldisc_data *ldisc_data;
 
+	if (tty != speakup_tty)
+		/* Somebody tried to use this line discipline outside speakup */
+		return -ENODEV;
+
 	if (!tty->ops->write)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&speakup_tty_mutex);
-	if (speakup_tty) {
-		mutex_unlock(&speakup_tty_mutex);
-		return -EBUSY;
-	}
-	speakup_tty = tty;
-
 	ldisc_data = kmalloc(sizeof(*ldisc_data), GFP_KERNEL);
-	if (!ldisc_data) {
-		speakup_tty = NULL;
-		mutex_unlock(&speakup_tty_mutex);
+	if (!ldisc_data)
 		return -ENOMEM;
-	}
 
 	init_completion(&ldisc_data->completion);
 	ldisc_data->buf_free = true;
-	speakup_tty->disc_data = ldisc_data;
-	mutex_unlock(&speakup_tty_mutex);
+	tty->disc_data = ldisc_data;
 
 	return 0;
 }
@@ -191,9 +184,25 @@ static int spk_ttyio_initialise_ldisc(struct spk_synth *synth)
 
 	tty_unlock(tty);
 
+	mutex_lock(&speakup_tty_mutex);
+	speakup_tty = tty;
 	ret = tty_set_ldisc(tty, N_SPEAKUP);
 	if (ret)
-		pr_err("speakup: Failed to set N_SPEAKUP on tty\n");
+		speakup_tty = NULL;
+	mutex_unlock(&speakup_tty_mutex);
+
+	if (!ret)
+		/* Success */
+		return 0;
+
+	pr_err("speakup: Failed to set N_SPEAKUP on tty\n");
+
+	tty_lock(tty);
+	if (tty->ops->close)
+		tty->ops->close(tty, NULL);
+	tty_unlock(tty);
+
+	tty_kclose(tty);
 
 	return ret;
 }

