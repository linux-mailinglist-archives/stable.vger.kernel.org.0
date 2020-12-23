Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253072E1DA5
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLWO47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:56:59 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55145 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbgLWO47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:56:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 29AFD1E74;
        Wed, 23 Dec 2020 09:55:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 23 Dec 2020 09:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XsWlpm
        apsgec/3q8UBr8FJfxbeqtilxqBNBJs7VRy3U=; b=dcuQ5ykHgqyyHJsBeC30fU
        Vp6lI0yZM8iJV4wwsAfeENTdMFoP95DrInVTbjTk1XO5Ou/jZwDLABKf567TpXmr
        w12A2DQlTlKiENWfz+mLNL6R3UmH13oeuClCnEfa8Shgkk4qNuSSSBsDT7EJCCRf
        OIcIezjEIlzn78ozKisYl7NMKpwtwXnc+VF0WRKNcrwGE4kV51blU52L/BCzZ8t5
        mXFsi8jil1UQk5Y0oF+PWLEspFSem/q0Ah5Uel0PUq8niQIckNTtgKpOb/yTRChU
        xT/I5tIklKQsQ7Gb9rrQcWX5D6Gz0aWMsJJh+FOnDrIB2GycwVDXj/67bkyOuVkg
        ==
X-ME-Sender: <xms:eFrjX1Dv5MTgmCXJXx7baj1dn8Eh87_Saho1Hk94gtH3T6msLULHNQ>
    <xme:eFrjXwqCUbezNrOASJ2idkVk2bcdALwDAGR4q-sS2E6gnxySdFTmTcEg0XNt6Flxp
    lsF7U_3UL38NA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepjedttdeifeejiefgleelfeffudeujeevgffgjeetue
    fgffeuveeftedvtedujeetnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:eFrjX_mzvdlS-yTnGgZzike-E-OpPHnl4-8x_m_bbeJ3KkstOP6wKA>
    <xmx:eFrjXwyfPFMYfOqRu1l4oIEE9DsX9ZXWa5yUwwzvAG67vSgoXZw4AQ>
    <xmx:eFrjX3_BNeaHLDWr8AuMKtW6lNMSvMDT1-parwBl_YupSGkmDbh1Tg>
    <xmx:eFrjX0xNY3xdVktQw2uYqoZCaM0WDX3LDp1G5omK3Unei8yOWlLQ8xI27Rc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65CC71080059;
        Wed, 23 Dec 2020 09:55:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] Bluetooth: Fix slab-out-of-bounds read in" failed to apply to 4.14-stable tree
To:     yepeilin.cs@gmail.com, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:56:55 +0100
Message-ID: <160873541518385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

