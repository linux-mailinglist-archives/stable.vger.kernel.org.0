Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6BE6B8DD5
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 09:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCNIxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 04:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCNIxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 04:53:17 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C8C8A39E;
        Tue, 14 Mar 2023 01:53:14 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 45E565C03BB;
        Tue, 14 Mar 2023 04:53:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 14 Mar 2023 04:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1678783994; x=1678870394; bh=Y
        fRag4RaJbmFZLq23UegojAbSloHWv/0bH+Ovb8o3+Y=; b=QUiu0pIhodu4GwUh+
        x+eeDqWIA43vQJjlWu6Cx5nn431UN85l++CUaNe5SlBusitnAA5kzsUIfAwlxFHB
        r3/tPQy4F8VVxGogTatSxeCS25gXhb0aIcD5H6H7L74YtplyRGhrQAvUYCZ5fqMk
        O9M4S2cY2kie+hU7bAYEu4sioa+MwvVhO4c04l8aNh+yiOohY+GerQV69z/icwjr
        iZuovAB5jC2/taEGRLVDfDZ0xuJOrWYOejIbBXMOSwXDpqIM8Ur0WKbwgGgPiRVI
        3PF4VRbjsEf9TER6xoOqQa+ipNTyBu9nGM6zuQIYookVhT1exIBWSnlEu9c4OiKY
        Pu83w==
X-ME-Sender: <xms:-TUQZKdhCPn-SNkkCnfxnVA8P9TJnVptt1fcUI9ELNxZ92RFt20YCg>
    <xme:-TUQZEO6N7BKflRmxHHeXt0hKqs8AuKPQK7dqphyo-G5ciFBwca_EwXlpIjqj3WLh
    pTrEC3l-mV-4Z-opdE>
X-ME-Received: <xmr:-TUQZLjYNuANzoss61NOfdBFVz1KKvsYYr1TryPB9LdNaPl35spkTo31GIACH2SwT-S7Bd1niADDaOqW5EbChM-ri-lmbvPmJ4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvvefkhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheffgfegfeevgeevtdeiffefveeutdeghfeuheeiteffjeefgfegveefuedvudel
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:-jUQZH8Ck1yOZdDfnxjcZHzSrjO9TvUVsOlVPTolGOt9T2dQPpWioQ>
    <xmx:-jUQZGvuLSpy-p-qOpcsYu0qi7eBYg9nxyDtm42B26XYtn4Z2wGBbg>
    <xmx:-jUQZOFBTU8MG0baSBzaNtfQ4P3Nq9SJuJz8SSq6y-FKhJ_uRfNksQ>
    <xmx:-jUQZP49Qp4s0C-RVMpkF4NYFTWb6-CY3uJQNLNXLzMeuIvYhAuLYA>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Mar 2023 04:53:11 -0400 (EDT)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
Message-Id: <d4e2a586e793cc8d9442595684ab8a077c0fe726.1678783919.git.fthain@linux-m68k.org>
From:   Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH] nubus: Partially revert proc_create_single_data() conversion
Date:   Tue, 14 Mar 2023 19:51:59 +1100
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The conversion to proc_create_single_data() introduced a regression
whereby reading a file in /proc/bus/nubus results in a seg fault:

 # grep -r . /proc/bus/nubus/e/
Data read fault at 0x00000020 in Super Data (pc=0x1074c2)
BAD KERNEL BUSERR
Oops: 00000000
Modules linked in:
PC: [<001074c2>] PDE_DATA+0xc/0x16
SR: 2010  SP: 38284958  a2: 01152370
d0: 00000001    d1: 01013000    d2: 01002790    d3: 00000000
d4: 00000001    d5: 0008ce2e    a0: 00000000    a1: 00222a40
Process grep (pid: 45, task=142f8727)
Frame format=B ssw=074d isc=2008 isb=4e5e daddr=00000020 dobuf=01199e70
baddr=001074c8 dibuf=ffffffff ver=f
Stack from 01199e48:
        01199e70 00222a58 01002790 00000000 011a3000 01199eb0 015000c0 00000000
        00000000 01199ec0 01199ec0 000d551a 011a3000 00000001 00000000 00018000
        d003f000 00000003 00000001 0002800d 01052840 01199fa8 c01f8000 00000000
        00000029 0b532b80 00000000 00000000 00000029 0b532b80 01199ee4 00103640
        011198c0 d003f000 00018000 01199fa8 00000000 011198c0 00000000 01199f4c
        000b3344 011198c0 d003f000 00018000 01199fa8 00000000 00018000 011198c0
Call Trace: [<00222a58>] nubus_proc_rsrc_show+0x18/0xa0
 [<000d551a>] seq_read+0xc4/0x510
 [<00018000>] fp_fcos+0x2/0x82
 [<0002800d>] __sys_setreuid+0x115/0x1c6
 [<00103640>] proc_reg_read+0x5c/0xb0
 [<00018000>] fp_fcos+0x2/0x82
 [<000b3344>] __vfs_read+0x2c/0x13c
 [<00018000>] fp_fcos+0x2/0x82
 [<00018000>] fp_fcos+0x2/0x82
 [<000b8aa2>] sys_statx+0x60/0x7e
 [<000b34b6>] vfs_read+0x62/0x12a
 [<00018000>] fp_fcos+0x2/0x82
 [<00018000>] fp_fcos+0x2/0x82
 [<000b39c2>] ksys_read+0x48/0xbe
 [<00018000>] fp_fcos+0x2/0x82
 [<000b3a4e>] sys_read+0x16/0x1a
 [<00018000>] fp_fcos+0x2/0x82
 [<00002b84>] syscall+0x8/0xc
 [<00018000>] fp_fcos+0x2/0x82
 [<0000c016>] not_ext+0xa/0x18
Code: 4e5e 4e75 4e56 0000 206e 0008 2068 ffe8 <2068> 0020 2008 4e5e 4e75 4e56 0000 2f0b 206e 0008 2068 0004 2668 0020 206b ffe8
Disabling lock debugging due to kernel taint

Segmentation fault

The proc_create_single_data() conversion does not work because
single_open(file, nubus_proc_rsrc_show, PDE_DATA(inode)) is not
equivalent to the original code.

Fixes: 3f3942aca6da ("proc: introduce proc_create_single{,_data}")
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/nubus/proc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index 1fd667852271..cd4bd06cf309 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -137,6 +137,18 @@ static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int nubus_rsrc_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nubus_proc_rsrc_show, inode);
+}
+
+static const struct proc_ops nubus_rsrc_proc_ops = {
+	.proc_open	= nubus_rsrc_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+};
+
 void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,
 			     const struct nubus_dirent *ent,
 			     unsigned int size)
@@ -152,8 +164,8 @@ void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,
 		pded = nubus_proc_alloc_pde_data(nubus_dirptr(ent), size);
 	else
 		pded = NULL;
-	proc_create_single_data(name, S_IFREG | 0444, procdir,
-			nubus_proc_rsrc_show, pded);
+	proc_create_data(name, S_IFREG | 0444, procdir,
+			 &nubus_rsrc_proc_ops, pded);
 }
 
 void nubus_proc_add_rsrc(struct proc_dir_entry *procdir,
@@ -166,9 +178,9 @@ void nubus_proc_add_rsrc(struct proc_dir_entry *procdir,
 		return;
 
 	snprintf(name, sizeof(name), "%x", ent->type);
-	proc_create_single_data(name, S_IFREG | 0444, procdir,
-			nubus_proc_rsrc_show,
-			nubus_proc_alloc_pde_data(data, 0));
+	proc_create_data(name, S_IFREG | 0444, procdir,
+			 &nubus_rsrc_proc_ops,
+			 nubus_proc_alloc_pde_data(data, 0));
 }
 
 /*
-- 
2.37.5

