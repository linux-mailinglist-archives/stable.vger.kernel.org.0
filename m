Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32B326B879
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgIPAoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:44:25 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55543 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbgIONBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 09:01:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DD05C1941466;
        Tue, 15 Sep 2020 09:01:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 09:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6I6Y0i
        eD2hQb0UrZ8hsEC14wtCTbmo8geOe4QybbDRg=; b=LK6JYJk4Ddn/rmrxSA5x3T
        CHlg76jk5WSzl7gtWKS48wuiW8tWXOdeZ/J52fkc4kfLbdpy1AREzdAsiA2tBDlm
        2GoBF6mdvKOKx5wVyi+dovtbqwOpc8p/LTcJNrE7gKWaq2Oub54VQm04FjOQ9jzt
        rgDzeRbGBGsluifaC1hdmx58hNZpDiR/DtTSZZ3rsiS6SkjPwNZdAmXLgV9PQ5im
        ISFAvXDr7s+fYQ8zQrVNfeKlgH8JMLY3ddx4DB7klLDfzSaXzDwnh65dXZUEEixD
        4ehKm2w3Rv7ti5Du4WT5TGXRNhDCLHaFh+natosj49260QluROfKRYjm6MI/TArw
        ==
X-ME-Sender: <xms:HrtgX-1XWNr_-2rxv4KgfPQGiTcBoaHXr8FChWDt1VJZcITVGQF4Bw>
    <xme:HrtgXxF6DjObUSPsl8TB6GxKYo0eplMWzNlc3T2lnhfgjshY8NMMBaxxpx6jX1i-r
    aL_qY6dzPLgTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeejtddtieefjeeigfelleefffduueejvefggfejteeugf
    ffueevfeetvdetudejteenucffohhmrghinhepshihiihkrghllhgvrhdrrghpphhsphho
    thdrtghomhenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:H7tgX26X4fsH6m6th8kq5DoPhYfLD3S3gd2TTOhYSWBr1sB-I_0xMw>
    <xmx:H7tgX_25ZS9pEBl2R0kXWB-MF5HWW2YzIIV95UvSElcDwbOKwrzbRA>
    <xmx:H7tgXxFD6aoXIsPmOWrLjaGybXvUmFV9UxYrSPmmb9MJ6TCjcHeLyA>
    <xmx:H7tgX_MniWpZWYaoGiJ3HLwlYlbRo1S_RuICGGqbGUSTcNYZTyT8hQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 863FE328005E;
        Tue, 15 Sep 2020 09:01:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: fix memory leak in kvm_io_bus_unregister_dev()" failed to apply to 4.9-stable tree
To:     rkovhaev@gmail.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 15:01:07 +0200
Message-ID: <160017486795186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f65886606c2d3b562716de030706dfe1bea4ed5e Mon Sep 17 00:00:00 2001
From: Rustam Kovhaev <rkovhaev@gmail.com>
Date: Mon, 7 Sep 2020 11:55:35 -0700
Subject: [PATCH] KVM: fix memory leak in kvm_io_bus_unregister_dev()

when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
the bus, we should iterate over all other devices linked to it and call
kvm_iodevice_destructor() for them

Fixes: 90db10434b16 ("KVM: kvm_io_bus_unregister_dev() should never fail")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200907185535.233114-1-rkovhaev@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67cd0b88a6b6..cf88233b819a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			       struct kvm_io_device *dev)
 {
-	int i;
+	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
@@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
-	if (!new_bus)  {
+	if (new_bus) {
+		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
+		new_bus->dev_count--;
+		memcpy(new_bus->range + i, bus->range + i + 1,
+		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
+	} else {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
-		goto broken;
+		for (j = 0; j < bus->dev_count; j++) {
+			if (j == i)
+				continue;
+			kvm_iodevice_destructor(bus->range[j].dev);
+		}
 	}
 
-	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
-	new_bus->dev_count--;
-	memcpy(new_bus->range + i, bus->range + i + 1,
-	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
-
-broken:
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);

