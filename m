Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A77235306
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHAPnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 11:43:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45325 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725841AbgHAPnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 11:43:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A07B85C00F2;
        Sat,  1 Aug 2020 11:43:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 01 Aug 2020 11:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=fLE/BR/AfO59g
        KvBp7sezPVqGqn3x1Dpcq3I+BQXhzk=; b=eE/HQiHcfS6C4NSf1tO8GS2lYvR5H
        hrP+ldGh07Y9Na2k7bNzc26W4B3qFTJJTk3+7FlTFi/wzg9RVxOGdRF3ZLZWNI3R
        bV4dM+H1Om289XgEfl8iak/ukyHfPAbOIizEDQT5HqaulHJnt4b3DKIfKV1e7JN9
        rlRjLWNIn+Bg1treek5BFfHFNEETIbKrfmmpkkVI4TH+mADUwnmxqcMLWJOjKaxz
        dAR5PD3ODcHeIgNYhhUd3RAKaOCt4tVtPY8o1rRvbcpfyhpj21vl2aUcN5IpHBby
        ksA6BaUxtrRA6u+JOQwM6TLOzmp5DC6P2oNvb0zbc8UCYr6ky4ahXAwoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fLE/BR/AfO59gKvBp7sezPVqGqn3x1Dpcq3I+BQXhzk=; b=mfEefv+m
        vSv3Xb/8LImHvLtDoKGu697+xhp8O+BBscg6LkD3bJ0zaGy6TVXO5HaAUAmPQxXm
        +LR2AtAvwxQD5RiIwv5ZzgD4sKvZBWe0w0FRPLmmeBHrWCIHhn9PhhJJxYZjuKBO
        2WSLEIlenj2dD7F492XCpJsjfLT9nn48vVxmY8TspWgN9rGElsdz6L28XyUemvw8
        2PscoXwh8qsAwxW7MzxszSJjLxRB6k/B9yqb4kM1W/+yWIe4HarmCnYjDuVv1S0o
        snv+w3f78SqtVlOExORtScb9aHydAvVp7CfUMmc2Rwh8svlUF5QDPEtk+3pqVlGw
        rxjKo+yKlvI/1Q==
X-ME-Sender: <xms:tI0lX-4LxBE8hH486tCytiUjTvK6S3wdGa274cDkXvHIUuyPhaybhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:tI0lX34Ej15o3lvQCJWF6OSME-HGqO5HRla88vPA-OziF47yPZV_TQ>
    <xmx:tI0lX9d1diDL1Q_BYHL8DfPWp91tub_stNBt48dWZvzUozh6WJSmjw>
    <xmx:tI0lX7LCZpkkEzbdcYJdoM8YEJg13-cygRmR33u99Ubnae5xjawyAg>
    <xmx:tI0lX-3H-s4LZSwR8lq5k3jcC_F2x9q2FnS2ZnaMEq2vzKG2ng2N-w>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20CF73060272;
        Sat,  1 Aug 2020 11:43:48 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] Bluetooth: hci_serdev: Fix crash with HCI_UART_INIT_PENDING
Date:   Sat,  1 Aug 2020 10:43:46 -0500
Message-Id: <20200801154346.63882-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801154346.63882-1-samuel@sholland.org>
References: <20200801154346.63882-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using HCI_UART_INIT_PENDING, hci_register_dev is not called from
hci_uart_register_device. Instead, it is called by hci_uart_init_work,
which is enqueued by hci_uart_init_ready (as hu->init_ready). In the
case of the hci_h5 proto, hci_uart_init_ready is called only after
handshaking with the hardware. If that handshake never completes,
hci_register_dev is never called. When later unregistering the device,
the kernel crashes:

  Unable to handle kernel write to read-only memory at virtual address 0000000000000008
  Internal error: Oops: 96000045 [#1] PREEMPT SMP
  Modules linked in: hci_uart(-) btrtl bnep bluetooth 8723cs(C) [...]
  CPU: 3 PID: 516 Comm: rmmod Tainted: G         C        5.8.0-rc7-00277-gd87641cb644c-dirty #1
  Hardware name: Pine64 PinePhone Braveheart (1.1) (DT)
  pstate: 80400005 (Nzcv daif +PAN -UAO BTYPE=--)
  pc : hci_unregister_dev+0x58/0x4b0 [bluetooth]
  lr : hci_unregister_dev+0x54/0x4b0 [bluetooth]
  sp : ffffffc011b5bc60
  x29: ffffffc011b5bc60 x28: ffffff8075d23800
  x27: 0000000000000000 x26: 0000000000000000
  x25: 0000000000000000 x24: 0000000000000000
  x23: 0000000000000000 x22: ffffffc008d86000
  x21: ffffff8079dd2000 x20: ffffff8078026000
  x19: ffffffc008f4f6d0 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000
  x15: 0000000000000004 x14: ffffff807b15c110
  x13: 0000000000000000 x12: ffffff80778e6720
  x11: ffffff80778e66c8 x10: ffffff807ac6ada2
  x9 : ffffffc010c95864 x8 : 0000000000210d00
  x7 : 0000000000000000 x6 : 0000000000000001
  x5 : 0000000000000001 x4 : 0000000000000001
  x3 : 0000000000000000 x2 : 0000000000000000
  x1 : 0000000000000000 x0 : 0000000000000000
  Call trace:
   hci_unregister_dev+0x58/0x4b0 [bluetooth]
   hci_uart_unregister_device+0x40/0x74 [hci_uart]
   h5_serdev_remove+0x18/0x20 [hci_uart]
   serdev_drv_remove+0x28/0x4c
   __device_release_driver+0x174/0x210
   driver_detach+0xc4/0x100
   bus_remove_driver+0x5c/0xb0
   driver_unregister+0x34/0x60
   h5_deinit+0x14/0xd10 [hci_uart]
   hci_uart_exit+0xc/0x30 [hci_uart]
   __arm64_sys_delete_module+0x1b0/0x260
   el0_svc_common.constprop.0+0x60/0x100
   do_el0_svc+0x20/0x30
   el0_sync_handler+0x88/0x1b4
   el0_sync+0x138/0x140
  Code: aa1303e0 79408297 95f69770 a9400682 (f9000441)
  ---[ end trace b68f9044c8f92379 ]---

Fix the crash by flushing the hu->init_ready work to ensure
hci_register_dev is not being called concurrently, and then only
calling hci_unregister_dev if the HCI was previously registered.

Cc: stable@vger.kernel.org
Fixes: fdee6d8fc630 ("Bluetooth: hci_serdev: Fix HCI_UART_INIT_PENDING not working")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/bluetooth/hci_serdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index 599855e4c57c..3977bba485c2 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -355,7 +355,10 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 	struct hci_dev *hdev = hu->hdev;
 
 	clear_bit(HCI_UART_PROTO_READY, &hu->flags);
-	hci_unregister_dev(hdev);
+
+	cancel_work_sync(&hu->init_ready);
+	if (test_bit(HCI_UART_REGISTERED, &hu->flags))
+		hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 
 	cancel_work_sync(&hu->write_work);
-- 
2.26.2

