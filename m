Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C09D1C2A0C
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 06:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgECE5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 00:57:25 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36837 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgECE5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 00:57:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 629D95C02C9;
        Sun,  3 May 2020 00:57:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 03 May 2020 00:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=a01vPk5jSMbZLWQ4MSCaHLAiq4
        QZ7Nwd4TNYnIPTX0U=; b=QrnEy/66w78ae+lUHdhrZrcycr/bTmQjF0Mlgr7Vs5
        hBPHsy0+YNFV+4d076IiUE6ZtkMyBltxjkd3jCAbdUm6w65wCjk3s/edSkMPM0OS
        7e9oNUIi5FT1+GQet79G/gScJBlvWYWqqngLYB/VczZU1ETdmGDLuLyqJqP5Ov5u
        swYbSDUbMXyzLCgs9Ksh2/KXdzdxfUtKRbSkR+EQPoWAYu0r9CW4ljvQkZD2FWaT
        ng1D8+QlVLrvJdY3u2Uv9s758j7NcutPZkYIzmdjKN3GR8MBtXsRSB7a7WgFbjB6
        /0ko1mvar1C91KyU5O/AR4he9opXtLAoOC9Z29/QEwdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a01vPk5jSMbZLWQ4M
        SCaHLAiq4QZ7Nwd4TNYnIPTX0U=; b=qNVuaFb1F8mMW0mEiN4V+S9lnK00VKBa2
        iunyumhUFLtZRVwZeX0Xe9T1KwWUv7LOErhoae1BX0nGPNmPGHBwukxXoICHdVgA
        ouJqpiRlHLBru3oUSY5ptI4kBR7sDBsiEMgMUFt0IwHBWNH4y8dKjQ2OWplFjBcT
        oiLa+w2Sw6XzYy0t6/UCUqEXCuqkw2JKD/WviGIAiwvbbfO7jE/42gH4rAPbSes8
        2fDneVqOW1DYvzXbCkutqkCy1Sk4CF5El6w5FEXxXyAa04jRJ36n8NbH1tIrs0v0
        z85rMsAToq3RFjetQ/AkWAfgSP70IlC+VSJ4dAHiW76OSeOISI4pQ==
X-ME-Sender: <xms:M0-uXsCZgqBeHnXQFQx_IX4kuGKEyYkc_jN_PUvMVLRgsBGbopjf0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjedtgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpedujeetlefhtddtke
    fgtdeuieelhffgteejjeehkeegveduvdevgeeiheeuueekjeenucfkphepudektddrvdef
    hedrfedrheegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:M0-uXvMCBtDmPAsjHkeu1iyuD9AcZwmQ5PQMGrao-t2_zPY9NUZEUA>
    <xmx:M0-uXqr6MJqINEWB1SJTC3T3LrU29-FYL1Gr-sKUOijHWX-U2I6PLg>
    <xmx:M0-uXixImIvHtjYqMAEQW60hUmo-6CHylmWLLkydik9yZ5dkrXGsyQ>
    <xmx:NE-uXshJEiTUSGYEjmtq11TpHNEBV1olBQBuUEDqqGtm1iAm1HQtGw>
Received: from workstation.flets-east.jp (ad003054.dynamic.ppp.asahi-net.or.jp [180.235.3.54])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7FFF3280067;
        Sun,  3 May 2020 00:57:21 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-lib: fix 'function sizeof not defined' error of tracepoints format
Date:   Sun,  3 May 2020 13:57:18 +0900
Message-Id: <20200503045718.86337-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The snd-firewire-lib.ko has 'amdtp-packet' event of tracepoints. Current
printk format for the event includes 'sizeof(u8)' macro expected to be
extended in compilation time. However, this is not done. As a result,
perf tools cannot parse the event for printing:

$ mount -l -t debugfs
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
$ cat /sys/kernel/debug/tracing/events/snd_firewire_lib/amdtp_packet/format
...
print fmt: "%02u %04u %04x %04x %02d %03u %02u %03u %02u %01u %02u %s",
  REC->second, REC->cycle, REC->src, REC->dest, REC->channel,
  REC->payload_quadlets, REC->data_blocks, REC->data_block_counter,
  REC->packet_index, REC->irq, REC->index,
  __print_array(__get_dynamic_array(cip_header),
                __get_dynamic_array_len(cip_header),
                sizeof(u8))

$ sudo perf record -e snd_firewire_lib:amdtp_packet
  [snd_firewire_lib:amdtp_packet] function sizeof not defined
  Error: expected type 5 but read 0

This commit fixes it by obsoleting the macro with actual size.

Cc: <stable@vger.kernel.org>
Fixes: bde2bbdb307a: ("ALSA: firewire-lib: use dynamic array for CIP header of tracing events")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-stream-trace.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/firewire/amdtp-stream-trace.h b/sound/firewire/amdtp-stream-trace.h
index 16c7f6605511..26e7cb555d3c 100644
--- a/sound/firewire/amdtp-stream-trace.h
+++ b/sound/firewire/amdtp-stream-trace.h
@@ -66,8 +66,7 @@ TRACE_EVENT(amdtp_packet,
 		__entry->irq,
 		__entry->index,
 		__print_array(__get_dynamic_array(cip_header),
-			      __get_dynamic_array_len(cip_header),
-			      sizeof(u8)))
+			      __get_dynamic_array_len(cip_header), 1))
 );
 
 #endif
-- 
2.25.1

