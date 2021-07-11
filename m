Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA913C3BFA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhGKLsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:48:40 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53877 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232376AbhGKLsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:48:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E03221940817;
        Sun, 11 Jul 2021 07:45:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 07:45:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=c3bw9m
        8mTLSV5J1W6dBNk2TVoNSGwgP7SY1Xp09dHCk=; b=hvuysfIv1UlU0syu6v/AfE
        suX16RHzEkRc0gheMuPjOnZ+k7/W9s0/r0mJaImuVuDE5XprO5LTA/jOkVW1JMeW
        5F4X/ubEwjiH5qBRv7Pg8A1ZncVB6W7roXnhASnD+7VKNF2DWCKHAJwVgG6re82W
        pIPi9BBXMLzEwxfuyrHZkz7kv2eI+pJETgdSrbzH75gPSqDUzYLut7D/xrWR0HLM
        niBT5Q9Nfu1OCPrd6rxlx4+HeqCe5i5Vl376oKoPiM2oNiMz6q/tWs87vQ+/15Fc
        zDd/BKDVpUfP95WCbMgNoPyI/qAAgFBVcpBcNEm9wWqpRuP2mluhdo7s5NhVUKHw
        ==
X-ME-Sender: <xms:8NnqYH2vxvZsp5doF0-7swN6TkPfi0mpLeOZpkkmJVSV4sXxJLqQKQ>
    <xme:8NnqYGEidQmi_yoFTQjTXfI5OyuHs0yTPt6E5DO93mekFyxy0kHGjmV20oDPqbtW-
    yuFs_90QFE0yw>
X-ME-Received: <xmr:8NnqYH4hjwpXtBuleCIpZosrrvZI1dORIFn6EMuJaxF3Hefb6U2i0GUjSuaWzQ-uoNaoVKbB3dOx_L9eo0zeA3HOzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8NnqYM3iE4BIYMpDz5Uioa-SSqaJQGpxXa8LeaRQrPwKnj-cvzNvWQ>
    <xmx:8NnqYKGDe31QuU5MQjkthF1WgmdaHMiwbK3RCPO1u6Yc2bqoDPEfHw>
    <xmx:8NnqYN9NLN0uWNydo9l3t5-Y-YrZO0uedDsWwzQWtnUqcGIlFJmO4w>
    <xmx:8NnqYPQDvaXWk7QRcvzd331HaIO7sH0hShOmSWMCr2D-4fobNQYUZw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:45:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Bluetooth: btqca: Don't modify firmware contents in-place" failed to apply to 5.4-stable tree
To:     cwabbott0@gmail.com, gubbaven@codeaurora.org, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:45:45 +0200
Message-ID: <1626003945148220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b43ca511178ed0ab6fd2405df28cf9e100273020 Mon Sep 17 00:00:00 2001
From: Connor Abbott <cwabbott0@gmail.com>
Date: Fri, 7 May 2021 14:27:33 +0200
Subject: [PATCH] Bluetooth: btqca: Don't modify firmware contents in-place

struct firmware::data is marked const, and when the firmware is
compressed with xz (default at least with Fedora) it's mapped read-only
which results in a crash:

BUG: unable to handle page fault for address: ffffae57c0ca5047
PGD 100000067 P4D 100000067 PUD 1001ce067 PMD 10165a067 PTE 8000000112bba161
Oops: 0003 [#1] SMP NOPTI
CPU: 3 PID: 204 Comm: kworker/u17:0 Not tainted 5.12.1-test+ #1
Hardware name: Dell Inc. XPS 13 9310/0F7M4C, BIOS 1.2.5 12/10/2020
Workqueue: hci0 hci_power_on [bluetooth]
RIP: 0010:qca_download_firmware+0x27c/0x4e0 [btqca]
Code: 1b 75 04 80 48 0c 01 0f b7 c6 8d 54 02 0c 41 39 d7 0f 8e 62 fe ff ff 48 63 c2 4c 01 e8 0f b7 38 0f b7 70 02 66 83 ff 11 75 d3 <80> 48 0c 80 41 83 fc 03 7e 6e 88 58 0d eb ce 41 0f b6 45 0e 48 8b
RSP: 0018:ffffae57c08dfc68 EFLAGS: 00010246
RAX: ffffae57c0ca503b RBX: 000000000000000e RCX: 0000000000000000
RDX: 0000000000000037 RSI: 0000000000000006 RDI: 0000000000000011
RBP: ffff978d9949e000 R08: ffff978d84ed7540 R09: ffffae57c0ca5000
R10: 000000000010cd00 R11: 0000000000000001 R12: 0000000000000005
R13: ffffae57c0ca5004 R14: ffff978d98ca8680 R15: 00000000000016a9
FS:  0000000000000000(0000) GS:ffff9794ef6c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffae57c0ca5047 CR3: 0000000113d5a004 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 qca_uart_setup+0x2cb/0x1390 [btqca]
 ? qca_read_soc_version+0x136/0x220 [btqca]
 qca_setup+0x288/0xab0 [hci_uart]
 hci_dev_do_open+0x1f3/0x780 [bluetooth]
 ? try_to_wake_up+0x1c1/0x4f0
 hci_power_on+0x3f/0x200 [bluetooth]
 process_one_work+0x1ec/0x380
 worker_thread+0x53/0x3e0
 ? process_one_work+0x380/0x380
 kthread+0x11b/0x140
 ? kthread_associate_blkcg+0xa0/0xa0
 ret_from_fork+0x1f/0x30
Modules linked in: llc ip_set nf_tables nfnetlink snd_soc_skl_hda_dsp(+) ip6table_filter snd_soc_hdac_hdmi ip6_tables qrtr_mhi iptable_filter snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic s>
 dell_wmi_sysman(+) dell_smbios snd dcdbas mhi vfat videobuf2_vmalloc i2c_i801 videobuf2_memops videobuf2_v4l2 dell_wmi_descriptor fat wmi_bmof soundcore i2c_smbus videobuf2_common libarc4 mei_me mei hid_se>
 i2c_hid_acpi i2c_hid video pinctrl_tigerlake fuse
CR2: ffffae57c0ca5047

This also seems to fix a failure to suspend due to the firmware
download on bootup getting interrupted by the crash:

Bluetooth: hci0: SSR or FW download time out
PM: dpm_run_callback(): acpi_subsys_suspend+0x0/0x60 returns -110
PM: Device serial0-0 failed to suspend: error -110
PM: Some devices failed to suspend, or early wake event detected

Fixes: 83e8196 ("Bluetooth: btqca: Introduce generic QCA ROME support")
Cc: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Cc: stable@vger.kernel.org
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 25114f0d1319..bd71dfc9c974 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -183,7 +183,7 @@ int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
 EXPORT_SYMBOL_GPL(qca_send_pre_shutdown_cmd);
 
 static void qca_tlv_check_data(struct qca_fw_config *config,
-		const struct firmware *fw, enum qca_btsoc_type soc_type)
+		u8 *fw_data, enum qca_btsoc_type soc_type)
 {
 	const u8 *data;
 	u32 type_len;
@@ -194,7 +194,7 @@ static void qca_tlv_check_data(struct qca_fw_config *config,
 	struct tlv_type_nvm *tlv_nvm;
 	uint8_t nvm_baud_rate = config->user_baud_rate;
 
-	tlv = (struct tlv_type_hdr *)fw->data;
+	tlv = (struct tlv_type_hdr *)fw_data;
 
 	type_len = le32_to_cpu(tlv->type_len);
 	length = (type_len >> 8) & 0x00ffffff;
@@ -390,8 +390,9 @@ static int qca_download_firmware(struct hci_dev *hdev,
 				 enum qca_btsoc_type soc_type)
 {
 	const struct firmware *fw;
+	u8 *data;
 	const u8 *segment;
-	int ret, remain, i = 0;
+	int ret, size, remain, i = 0;
 
 	bt_dev_info(hdev, "QCA Downloading %s", config->fwname);
 
@@ -402,10 +403,22 @@ static int qca_download_firmware(struct hci_dev *hdev,
 		return ret;
 	}
 
-	qca_tlv_check_data(config, fw, soc_type);
+	size = fw->size;
+	data = vmalloc(fw->size);
+	if (!data) {
+		bt_dev_err(hdev, "QCA Failed to allocate memory for file: %s",
+			   config->fwname);
+		release_firmware(fw);
+		return -ENOMEM;
+	}
+
+	memcpy(data, fw->data, size);
+	release_firmware(fw);
+
+	qca_tlv_check_data(config, data, soc_type);
 
-	segment = fw->data;
-	remain = fw->size;
+	segment = data;
+	remain = size;
 	while (remain > 0) {
 		int segsize = min(MAX_SIZE_PER_TLV_SEGMENT, remain);
 
@@ -435,7 +448,7 @@ static int qca_download_firmware(struct hci_dev *hdev,
 		ret = qca_inject_cmd_complete_event(hdev);
 
 out:
-	release_firmware(fw);
+	vfree(data);
 
 	return ret;
 }

