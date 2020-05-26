Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111151A7F6D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389483AbgDNOSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:18:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39167 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389449AbgDNOSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:18:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 392E541C;
        Tue, 14 Apr 2020 10:18:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PImCmR
        jHmgb5BXOxWRLkQDHzl0cgb/pT+Y4tyEEsrFo=; b=gUU0tmdTcB8R/vEkPMusIg
        rGUDnA2+KcYmZf8XR62pAeuBywlN800u65cU+ss2OBX219KJhcr+d64/eXSdcGfw
        2dHkjK3FB1tdokyixhzFHmNbgKxPc28vUC7UjRaopHGV4DpfzaZ/hC5Z6z2AX6Dw
        ve+DIsS2chfMD1ZtT37UEfSJTdxs+sf3zgEOyKUaOXTuzI4BJZFsNP+OGGonv/n5
        N2n8/HO63FAqPLlYLtDjZRcRzLBkGaYDCzdVl6KAupG+LYdyEAACKHqwnZcGjqfI
        asA6HBEIEW7vCE+zDkYB1MjbWnP2lUm3sv2xCx8fIu4uKCK6OwJ3pEC0qyi0YohA
        ==
X-ME-Sender: <xms:OsaVXlYFgvKr2R6mjjqIrheyu7Nk7PvBiVGnjDv1JMU6hjy8NfirLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OsaVXiRJtZEZ3nTuNogmETFtNsgovO5OFmVzaZW5NkS3MhlNwsGYpQ>
    <xmx:OsaVXqac3iq8r8btDVAlL5uSzbkL0Q8IKv0MZ4nKwIvBKmqRqmLiXA>
    <xmx:OsaVXkyc4teKt75-iHbwOTPqKDmxGzguR4_S9n8EYa-Vbg5OcHdmUA>
    <xmx:OsaVXuhom5MLc9gL47ToFpXzHR10Ca8Hf5KpdAsYdYeB33T4Lv3G1A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B0B9328005E;
        Tue, 14 Apr 2020 10:18:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: Fix NULL pointer dereference in" failed to apply to 4.4-stable tree
To:     NShubin@topcon.com, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:18:32 +0200
Message-ID: <158687391220636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 791c13b709dd51eb37330f2a5837434e90c87c27 Mon Sep 17 00:00:00 2001
From: Nikita Shubin <NShubin@topcon.com>
Date: Fri, 6 Mar 2020 10:24:53 +0300
Subject: [PATCH] remoteproc: Fix NULL pointer dereference in
 rproc_virtio_notify

Undefined rproc_ops .kick method in remoteproc driver will result in
"Unable to handle kernel NULL pointer dereference" in rproc_virtio_notify,
after firmware loading if:

 1) .kick method wasn't defined in driver
 2) resource_table exists in firmware and has "Virtio device entry" defined

Let's refuse to register an rproc-induced virtio device if no kick method was
defined for rproc.

[   13.180049][  T415] 8<--- cut here ---
[   13.190558][  T415] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   13.212544][  T415] pgd = (ptrval)
[   13.217052][  T415] [00000000] *pgd=00000000
[   13.224692][  T415] Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
[   13.231318][  T415] Modules linked in: rpmsg_char imx_rproc virtio_rpmsg_bus rpmsg_core [last unloaded: imx_rproc]
[   13.241687][  T415] CPU: 0 PID: 415 Comm: unload-load.sh Not tainted 5.5.2-00002-g707df13bbbdd #6
[   13.250561][  T415] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   13.257009][  T415] PC is at 0x0
[   13.260249][  T415] LR is at rproc_virtio_notify+0x2c/0x54
[   13.265738][  T415] pc : [<00000000>]    lr : [<8050f6b0>]    psr: 60010113
[   13.272702][  T415] sp : b8d47c48  ip : 00000001  fp : bc04de00
[   13.278625][  T415] r10: bc04c000  r9 : 00000cc0  r8 : b8d46000
[   13.284548][  T415] r7 : 00000000  r6 : b898f200  r5 : 00000000  r4 : b8a29800
[   13.291773][  T415] r3 : 00000000  r2 : 990a3ad4  r1 : 00000000  r0 : b8a29800
[   13.299000][  T415] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   13.306833][  T415] Control: 10c5387d  Table: b8b4806a  DAC: 00000051
[   13.313278][  T415] Process unload-load.sh (pid: 415, stack limit = 0x(ptrval))
[   13.320591][  T415] Stack: (0xb8d47c48 to 0xb8d48000)
[   13.325651][  T415] 7c40:                   b895b680 00000001 b898f200 803c6430 b895bc80 7f00ae18
[   13.334531][  T415] 7c60: 00000035 00000000 00000000 b9393200 80b3ed80 00004000 b9393268 bbf5a9a2
[   13.343410][  T415] 7c80: 00000e00 00000200 00000000 7f00aff0 7f00a014 b895b680 b895b800 990a3ad4
[   13.352290][  T415] 7ca0: 00000001 b898f210 b898f200 00000000 00000000 7f00e000 00000001 00000000
[   13.361170][  T415] 7cc0: 00000000 803c62e0 80b2169c 802a0924 b898f210 00000000 00000000 b898f210
[   13.370049][  T415] 7ce0: 80b9ba44 00000000 80b9ba48 00000000 7f00e000 00000008 80b2169c 80400114
[   13.378929][  T415] 7d00: 80b2169c 8061fd64 b898f210 7f00e000 80400744 b8d46000 80b21634 80b21634
[   13.387809][  T415] 7d20: 80b2169c 80400614 80b21634 80400718 7f00e000 00000000 b8d47d7c 80400744
[   13.396689][  T415] 7d40: b8d46000 80b21634 80b21634 803fe338 b898f254 b80fe76c b8d32e38 990a3ad4
[   13.405569][  T415] 7d60: fffffff3 b898f210 b8d46000 00000001 b898f254 803ffe7c 80857a90 b898f210
[   13.414449][  T415] 7d80: 00000001 990a3ad4 b8d46000 b898f210 b898f210 80b17aec b8a29c20 803ff0a4
[   13.423328][  T415] 7da0: b898f210 00000000 b8d46000 803fb8e0 b898f200 00000000 80b17aec b898f210
[   13.432209][  T415] 7dc0: b8a29c20 990a3ad4 b895b900 b898f200 8050fb7c 80b17aec b898f210 b8a29c20
[   13.441088][  T415] 7de0: b8a29800 b895b900 b8a29a04 803c5ec0 b8a29c00 b898f200 b8a29a20 00000007
[   13.449968][  T415] 7e00: b8a29c20 8050fd78 b8a29800 00000000 b8a29a20 b8a29c04 b8a29820 b8a299d0
[   13.458848][  T415] 7e20: b895b900 8050e5a4 b8a29800 b8a299d8 b8d46000 b8a299e0 b8a29820 b8a299d0
[   13.467728][  T415] 7e40: b895b900 8050e008 000041ed 00000000 b8b8c440 b8a299d8 b8a299e0 b8a299d8
[   13.476608][  T415] 7e60: b8b8c440 990a3ad4 00000000 b8a29820 b8b8c400 00000006 b8a29800 b895b880
[   13.485487][  T415] 7e80: b8d47f78 00000000 00000000 8050f4b4 00000006 b895b890 b8b8c400 008fbea0
[   13.494367][  T415] 7ea0: b895b880 8029f530 00000000 00000000 b8d46000 00000006 b8d46000 008fbea0
[   13.503246][  T415] 7ec0: 8029f434 00000000 b8d46000 00000000 00000000 8021e2e4 0000000a 8061fd0c
[   13.512125][  T415] 7ee0: 0000000a b8af0c00 0000000a b8af0c40 00000001 b8af0c40 00000000 8061f910
[   13.521005][  T415] 7f00: 0000000a 80240af4 00000002 b8d46000 00000000 8061fd0c 00000002 80232d7c
[   13.529884][  T415] 7f20: 00000000 b8d46000 00000000 990a3ad4 00000000 00000006 b8a62d80 008fbea0
[   13.538764][  T415] 7f40: b8d47f78 00000000 b8d46000 00000000 00000000 802210c0 b88f2900 00000000
[   13.547644][  T415] 7f60: b8a62d80 b8a62d80 b8d46000 00000006 008fbea0 80221320 00000000 00000000
[   13.556524][  T415] 7f80: b8af0c00 990a3ad4 0000006c 008fbea0 76f1cda0 00000004 80101204 00000004
[   13.565403][  T415] 7fa0: 00000000 80101000 0000006c 008fbea0 00000001 008fbea0 00000006 00000000
[   13.574283][  T415] 7fc0: 0000006c 008fbea0 76f1cda0 00000004 00000006 00000006 00000000 00000000
[   13.583162][  T415] 7fe0: 00000004 7ebaf7d0 76eb4c0b 76e3f206 600d0030 00000001 00000000 00000000
[   13.592056][  T415] [<8050f6b0>] (rproc_virtio_notify) from [<803c6430>] (virtqueue_notify+0x1c/0x34)
[   13.601298][  T415] [<803c6430>] (virtqueue_notify) from [<7f00ae18>] (rpmsg_probe+0x280/0x380 [virtio_rpmsg_bus])
[   13.611663][  T415] [<7f00ae18>] (rpmsg_probe [virtio_rpmsg_bus]) from [<803c62e0>] (virtio_dev_probe+0x1f8/0x2c4)
[   13.622022][  T415] [<803c62e0>] (virtio_dev_probe) from [<80400114>] (really_probe+0x200/0x450)
[   13.630817][  T415] [<80400114>] (really_probe) from [<80400614>] (driver_probe_device+0x16c/0x1ac)
[   13.639873][  T415] [<80400614>] (driver_probe_device) from [<803fe338>] (bus_for_each_drv+0x84/0xc8)
[   13.649102][  T415] [<803fe338>] (bus_for_each_drv) from [<803ffe7c>] (__device_attach+0xd4/0x164)
[   13.658069][  T415] [<803ffe7c>] (__device_attach) from [<803ff0a4>] (bus_probe_device+0x84/0x8c)
[   13.666950][  T415] [<803ff0a4>] (bus_probe_device) from [<803fb8e0>] (device_add+0x444/0x768)
[   13.675572][  T415] [<803fb8e0>] (device_add) from [<803c5ec0>] (register_virtio_device+0xa4/0xfc)
[   13.684541][  T415] [<803c5ec0>] (register_virtio_device) from [<8050fd78>] (rproc_add_virtio_dev+0xcc/0x1b8)
[   13.694466][  T415] [<8050fd78>] (rproc_add_virtio_dev) from [<8050e5a4>] (rproc_start+0x148/0x200)
[   13.703521][  T415] [<8050e5a4>] (rproc_start) from [<8050e008>] (rproc_boot+0x384/0x5c0)
[   13.711708][  T415] [<8050e008>] (rproc_boot) from [<8050f4b4>] (state_store+0x3c/0xc8)
[   13.719723][  T415] [<8050f4b4>] (state_store) from [<8029f530>] (kernfs_fop_write+0xfc/0x214)
[   13.728348][  T415] [<8029f530>] (kernfs_fop_write) from [<8021e2e4>] (__vfs_write+0x30/0x1cc)
[   13.736971][  T415] [<8021e2e4>] (__vfs_write) from [<802210c0>] (vfs_write+0xac/0x17c)
[   13.744985][  T415] [<802210c0>] (vfs_write) from [<80221320>] (ksys_write+0x64/0xe4)
[   13.752825][  T415] [<80221320>] (ksys_write) from [<80101000>] (ret_fast_syscall+0x0/0x54)
[   13.761178][  T415] Exception stack(0xb8d47fa8 to 0xb8d47ff0)
[   13.766932][  T415] 7fa0:                   0000006c 008fbea0 00000001 008fbea0 00000006 00000000
[   13.775811][  T415] 7fc0: 0000006c 008fbea0 76f1cda0 00000004 00000006 00000006 00000000 00000000
[   13.784687][  T415] 7fe0: 00000004 7ebaf7d0 76eb4c0b 76e3f206
[   13.790442][  T415] Code: bad PC value
[   13.839214][  T415] ---[ end trace 1fe21ecfc9f28852 ]---

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Nikita Shubin <NShubin@topcon.com>
Fixes: 7a186941626d ("remoteproc: remove the single rpmsg vdev limitation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200306072452.24743-1-NShubin@topcon.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index eb817132bc5f..e61d738d9b47 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -335,6 +335,13 @@ int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 	struct rproc_mem_entry *mem;
 	int ret;
 
+	if (rproc->ops->kick == NULL) {
+		ret = -EINVAL;
+		dev_err(dev, ".kick method not defined for %s",
+				rproc->name);
+		goto out;
+	}
+
 	/* Try to find dedicated vdev buffer carveout */
 	mem = rproc_find_carveout_by_name(rproc, "vdev%dbuffer", rvdev->index);
 	if (mem) {

