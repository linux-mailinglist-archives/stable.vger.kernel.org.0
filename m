Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905B8261FBC
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgIHUGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:12 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43545 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730206AbgIHPVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 78E41B81;
        Tue,  8 Sep 2020 07:58:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 07:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gRJUQS
        e4Kn4Zb1fx57sn8ZFF13tIeG3mEQk81uduyS8=; b=sJe62uUMYleYPvyD3H47Oa
        DxsgvqW2Wa2F1FAzxMOVpeiPSHw8QZdGknwQHqnZ6m+wKAklW1BE8Tjv10imNJmh
        5UtznqQFeAR7lhRuYsaceRXTMk0Dl60psIGjKjHMjzQQcHTfiTeOu516NZxQOMb8
        uAisHyN2SBeE4XdQ0OYyJjWKpbpUNMft8DOshG+YGWgTjCCGTyhBP8DorinPCah8
        iUn3oP2RXlKx38uuHN9FMViYwTYysCi37xq8QL2D5OOqN0zW70hw1LIiznBV6SKy
        rhor5BLyaQMp6Fysw4gMQoSmqS8EPdzYi/8DvbWNCElJuOBkV09Qnp3BIjY0Yb6Q
        ==
X-ME-Sender: <xms:8XFXXxdT1o-Cu5KnJnXCNsCe21LPxyA3j_urG_M1zfrFS4Qj0MQh9g>
    <xme:8XFXX_MmEqCvrlRU74EF45CJxVMd4T6H01yKvNtnz_kNlVp4_htv2ouJS-BxVplQR
    8SNdijPg6t-wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8XFXX6g_HRA0Vc5HW73Afu8b-3HJf2nbktMyCCRSJDOvl4DyDLvSig>
    <xmx:8XFXX692aMel7_iw7fdzwfhLKmbVFy_UmMOoHLMrQEAh6KJ2LkHcFQ>
    <xmx:8XFXX9uGsylvSaB_cUWubZzhKI0tNXZ9iDaBLl37AuLS1_lJzWtG3g>
    <xmx:8nFXX-UI0Ikco6xg1netbIKXvn2IJngO0D57MJjbkSGutk2y-4yBu4zx30Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59E233064683;
        Tue,  8 Sep 2020 07:58:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ALSA: firewire-digi00x: exclude Avid Adrenaline from" failed to apply to 4.4-stable tree
To:     o-takashi@sakamocchi.jp, simon@mungewell.org,
        stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 13:58:51 +0200
Message-ID: <1599566331230110@kroah.com>
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

From acd46a6b6de88569654567810acad2b0a0a25cea Mon Sep 17 00:00:00 2001
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Date: Sun, 23 Aug 2020 16:55:45 +0900
Subject: [PATCH] ALSA: firewire-digi00x: exclude Avid Adrenaline from
 detection

Avid Adrenaline is reported that ALSA firewire-digi00x driver is bound to.
However, as long as he investigated, the design of this model is hardly
similar to the one of Digi 00x family. It's better to exclude the model
from modalias of ALSA firewire-digi00x driver.

This commit changes device entries so that the model is excluded.

$ python3 crpp < ~/git/am-config-rom/misc/avid-adrenaline.img
               ROM header and bus information block
               -----------------------------------------------------------------
400  04203a9c  bus_info_length 4, crc_length 32, crc 15004
404  31333934  bus_name "1394"
408  e064a002  irmc 1, cmc 1, isc 1, bmc 0, cyc_clk_acc 100, max_rec 10 (2048)
40c  00a07e01  company_id 00a07e     |
410  00085257  device_id 0100085257  | EUI-64 00a07e0100085257

               root directory
               -----------------------------------------------------------------
414  0005d08c  directory_length 5, crc 53388
418  0300a07e  vendor
41c  8100000c  --> descriptor leaf at 44c
420  0c008380  node capabilities
424  8d000002  --> eui-64 leaf at 42c
428  d1000004  --> unit directory at 438

               eui-64 leaf at 42c
               -----------------------------------------------------------------
42c  0002410f  leaf_length 2, crc 16655
430  00a07e01  company_id 00a07e     |
434  00085257  device_id 0100085257  | EUI-64 00a07e0100085257

               unit directory at 438
               -----------------------------------------------------------------
438  0004d6c9  directory_length 4, crc 54985
43c  1200a02d  specifier id: 1394 TA
440  13014001  version: Vender Unique and AV/C
444  17000001  model
448  81000009  --> descriptor leaf at 46c

               descriptor leaf at 44c
               -----------------------------------------------------------------
44c  00077205  leaf_length 7, crc 29189
450  00000000  textual descriptor
454  00000000  minimal ASCII
458  41766964  "Avid"
45c  20546563  " Tec"
460  686e6f6c  "hnol"
464  6f677900  "ogy"
468  00000000

               descriptor leaf at 46c
               -----------------------------------------------------------------
46c  000599a5  leaf_length 5, crc 39333
470  00000000  textual descriptor
474  00000000  minimal ASCII
478  41647265  "Adre"
47c  6e616c69  "nali"
480  6e650000  "ne"

Reported-by: Simon Wood <simon@mungewell.org>
Fixes: 9edf723fd858 ("ALSA: firewire-digi00x: add skeleton for Digi 002/003 family")
Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200823075545.56305-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/firewire/digi00x/digi00x.c b/sound/firewire/digi00x/digi00x.c
index c84b913a9fe0..ab8408966ec3 100644
--- a/sound/firewire/digi00x/digi00x.c
+++ b/sound/firewire/digi00x/digi00x.c
@@ -14,6 +14,7 @@ MODULE_LICENSE("GPL v2");
 #define VENDOR_DIGIDESIGN	0x00a07e
 #define MODEL_CONSOLE		0x000001
 #define MODEL_RACK		0x000002
+#define SPEC_VERSION		0x000001
 
 static int name_card(struct snd_dg00x *dg00x)
 {
@@ -175,14 +176,18 @@ static const struct ieee1394_device_id snd_dg00x_id_table[] = {
 	/* Both of 002/003 use the same ID. */
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_VERSION |
 			       IEEE1394_MATCH_MODEL_ID,
 		.vendor_id = VENDOR_DIGIDESIGN,
+		.version = SPEC_VERSION,
 		.model_id = MODEL_CONSOLE,
 	},
 	{
 		.match_flags = IEEE1394_MATCH_VENDOR_ID |
+			       IEEE1394_MATCH_VERSION |
 			       IEEE1394_MATCH_MODEL_ID,
 		.vendor_id = VENDOR_DIGIDESIGN,
+		.version = SPEC_VERSION,
 		.model_id = MODEL_RACK,
 	},
 	{}

