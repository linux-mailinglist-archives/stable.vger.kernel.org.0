Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A224EC07
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 09:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgHWHzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 03:55:50 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:44119 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgHWHzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 03:55:50 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 4EF9DA53;
        Sun, 23 Aug 2020 03:55:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 23 Aug 2020 03:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=EA40zx6RBV16MKKgEbqmJbniCx
        UVG6iebRrFErn1WXk=; b=aBN92EfdulBYc/G6Ik9jOrW7DEMo8quqOChzdDeFto
        9COCNeVXOj/OKkyoUhCmEmAm1+IXTkijHMyLiUoDfamNPEV40ppeenk5Nz2PstwW
        UHO2K0p52zXalvY0DmoSLuvHPFICU+rrKh4dSV80nPChgudS+6j2vCJKv8fxJPQ/
        HZ5d47Agc0nA7RdEdjYlbBBBQVFX4mFaYv4HVtM/WW35Psyp7gxNmaOMuzSZpVfN
        tsBHOJ8wPFd2IpiJR9GX+KIq33vZZzUSP8jrLTWvGah3KC6Ls7G5wZODzUbanCi7
        5xWc7Ev7Xi7jMrAJTV3R1u357uJMORuc0xshzgUdTDTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EA40zx6RBV16MKKgE
        bqmJbniCxUVG6iebRrFErn1WXk=; b=guV4SBDqoUhNCiyiR6mlTr8VhOobiFsHB
        gwTO68WJXtoHvAGiP8tIz7fH04Ivznx3xi7snAq8ZPCUuL/EfELvvdTy7ZpfAFrm
        qmSlVxDMSrwTV0bDYLofuVKSJmyTbj8yjwzJ11oz4ALlrvTpEfFhNjOy8KUitkvD
        p5rfPiGpLinUAGnDWyHYfuUI/dPwQ6UWv7Rd4jum1oCFE8n2r89YIpGpPDeC43nJ
        4OQV+P2iPiqSacFx1W11Mej64JNQybLGnQYoAF81T4YeV9Y3a+nk4bA2xnlW4Pvp
        ptMbilGTtbtRJB/UAa17QDPDBKiVTZAuvSAtGWbQz3pBqg5sNcKUA==
X-ME-Sender: <xms:BCFCXx7FC6IoBJDXNlYupJm61Z96VkOrSRG8IHb3xBD8pJ5WfuivXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduhedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepvfgrkhgrshhh
    ihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
    eqnecuggftrfgrthhtvghrnhepudejteelhfdttdekgfdtueeilefhgfetjeejheekgeev
    uddvveegieehueeukeejnecukfhppedukedtrddvfeehrdefrdehgeenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehoqdhtrghkrghshhhisehs
    rghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:BCFCX-79uZXurSxLWGpcWALPFvtpgpcwekIFxbJZ1Q-cEOMqK2Yf0A>
    <xmx:BCFCX4dKHU13h-P0fxtylolNU1i_Mfjzna0AVaghuF3ZpGOpiXP37w>
    <xmx:BCFCX6JxxTExm86PdIimV5ucSrDoWmK72CLAE0PRrca43trokhnKUg>
    <xmx:BCFCXzhPyDGB6nmVkIr8WSmrL3hc5yJv37KjRQGcEoWhp21e9MO81Q>
Received: from workstation.flets-east.jp (ad003054.dynamic.ppp.asahi-net.or.jp [180.235.3.54])
        by mail.messagingengine.com (Postfix) with ESMTPA id 902B1328005A;
        Sun, 23 Aug 2020 03:55:47 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        Simon Wood <simon@mungewell.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] ALSA: firewire-digi00x: exclude Avid Adrenaline from detection
Date:   Sun, 23 Aug 2020 16:55:45 +0900
Message-Id: <20200823075545.56305-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/firewire/digi00x/digi00x.c | 5 +++++
 1 file changed, 5 insertions(+)

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
-- 
2.25.1

