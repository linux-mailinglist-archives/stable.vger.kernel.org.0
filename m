Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246CB2E1DA4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgLWO4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:56:49 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39877 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727215AbgLWO4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:56:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 709BA1E87;
        Wed, 23 Dec 2020 09:55:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TxOjwF
        xtPHDUrX4y+Kdgru0X/aYaBL8rhmi/YbKxFAA=; b=Q+b6keKrDMHrYkysob1Kbo
        aAUUg9jAyrBODFvHLC91e17N/ZHTyxiBOKK6irEBHNHavvoG50HeMNoq2EUUgmj0
        L4LwwS20KSsDFG07dkjo7iPCZ6cWfNF0XSlfMq1RE5Md/PnOOq/9Rs9tEqy7tIkx
        loxW9Hqvsrg/IMB/fGFJ5SEYLtCT1H1Icb8Wg7w/gafLxnXVJ0iF9rtcGWSP8DUi
        cAgViC/I5BxJt8q0HH6+vp2v7/Oa+JXeyLHCRXbIL0QS4tYMxPDY5zbbZNP25zYM
        VZPxyKOUGjC5P8qwSNSUshm6RoVVTAWG5Cm9VmRU4ba+ImZk8SEjGLAxkv+Sal4A
        ==
X-ME-Sender: <xms:blrjX_AN2RWlRiKkfIULwMAMqshlHcqlzPk7rFqUTghnw8UO5VkkoA>
    <xme:blrjX1irJpEiLBuilxQk-ZV0Gr-7Jm1JTFeljCd05jglMNIctK9cHkWf06N2iDiDY
    EBGYtFknz5s7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepjedttdeifeejiefgleelfeffudeujeevgffgjeetue
    fgffeuveeftedvtedujeetnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:blrjX6lc6MdRu6rzPr0zsCTF4mPy1gxyhXLUgqU-LLv60NOjhX88fw>
    <xmx:blrjXxy23h_PoO_xOMpyOghBx1BORdWCHVW367bMNWL1qei3kegvRQ>
    <xmx:blrjX0R2hA8wKo2-2eTwV4gOP1ughUzKVWD4ufYOczRXYg9AfEoE5Q>
    <xmx:b1rjX94FO5r-dV4OmPzZH0ZnRJ6rW9ZCu-QKVInSgdkbaGhGPV3BIp9wXKU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F828108005F;
        Wed, 23 Dec 2020 09:55:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] Bluetooth: Fix slab-out-of-bounds read in" failed to apply to 4.4-stable tree
To:     yepeilin.cs@gmail.com, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:56:54 +0100
Message-ID: <160873541418391@kroah.com>
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

From f7e0e8b2f1b0a09b527885babda3e912ba820798 Mon Sep 17 00:00:00 2001
From: Peilin Ye <yepeilin.cs@gmail.com>
Date: Wed, 9 Sep 2020 03:17:00 -0400
Subject: [PATCH] Bluetooth: Fix slab-out-of-bounds read in
 hci_le_direct_adv_report_evt()

`num_reports` is not being properly checked. A malformed event packet with
a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
of bounds. Fix it.

Cc: stable@vger.kernel.org
Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e72982b69f6b..17a72695865b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5873,21 +5873,19 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
 	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
 
-	hci_dev_lock(hdev);
+	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
+		return;
 
-	while (num_reports--) {
-		struct hci_ev_le_direct_adv_info *ev = ptr;
+	hci_dev_lock(hdev);
 
+	for (; num_reports; num_reports--, ev++)
 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 				   ev->bdaddr_type, &ev->direct_addr,
 				   ev->direct_addr_type, ev->rssi, NULL, 0,
 				   false);
 
-		ptr += sizeof(*ev);
-	}
-
 	hci_dev_unlock(hdev);
 }
 

