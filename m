Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD637F844
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhEMM6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:58:15 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44979 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230488AbhEMM6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:58:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A9405C015B;
        Thu, 13 May 2021 08:57:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 13 May 2021 08:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=SiO+pcMbXuqv/
        hZDxQNoTDJaePDS0BK45FBgOaKHkO8=; b=ZfgjOlnIFq2XKoKgC/RLXTEH2HlP+
        ElYAi0sA46POLCRCzyr7Yv34m13+kc3llxeCq8nvaI7gMFBTAz03EA9sz1vkOjSr
        x+EpR5UDN0i+y91ZcXV39ox30YfgH2JQ63rY63Gl96fsPPpsd05drmtM9OIgPwBp
        ZG7fPt9DxkQU+oSuGdPAvqW47RuYV6cf5a+nTa6TodehYVnNggNcud25rantFefr
        CwYfEg/Q1PPmDBfv4oEmXq+2EHaM+PcXbo0A0m+vv5bJY4XTs7isXk4Ehx7SybMY
        a7AyfcHwJiTMp4qXudcJL3cqI/+3X4D6VzrEBAq4JSbkkTmcL4AuJ10tQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SiO+pcMbXuqv/hZDxQNoTDJaePDS0BK45FBgOaKHkO8=; b=IvO94Jyt
        aOibRRVNPpiMC6ddlbAuJ8LPhg0TvZBrx+fd7+37NIeSTEgukTvNvikWtlBo6jy2
        xTmbyBXS7KYbLhUVmMVEbPwmotsYWkRqk0IOT1IFggnNDIt+RJCUYWAsuJoGuK2N
        myfHQeYPSA2Q3/g4ToUxjwrwZd76WlwKdZcjBbePioj0m3vokcdWf/iREAJIycrr
        brG98PI8dH/JduMLGZy+QjCzcAwaPfGsapQEavQuq02eaNb9aJdaq0F+pI9pnQ+R
        QeU/AT8C5dNaOqf4UNUtwvls9w13k/EcVmZKBPt+tcMg/2vxcUs0wpD88MdLENFc
        KllaFok+GuO4qA==
X-ME-Sender: <xms:ICKdYN6TyQS4H_-tG0YfVP-vHoKLssTy6UlwuTrlH-G6mCpMBDx9sQ>
    <xme:ICKdYK6FS0GKx2oHVtxTSwH5AJtzdtDY0ARsH67uFmsdgBYEI4clfvG7y2SlTXXKt
    0g8fAASXi6W-CTK17Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgr
    shhhihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepveefffefke
    etgfevgeefleehfffhueejtdejveethfekveektdejjedvtdejhfejnecukfhppedugedr
    fedrieehrddujeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:ICKdYEeXCr-rjkeuyANvqX2aMdqa3OfPgNrc3JzjjJZwccPoN9Yc3w>
    <xmx:ICKdYGKfwyf1A9pLB_sbweopJ3OEZsrocBDhTBIDwwVt5RSTsusXLQ>
    <xmx:ICKdYBKtGNahp-Lv4ODpKg4FQJ4VpeJGXg4_0NWlOViZQg7zkOp8wQ>
    <xmx:ICKdYPh0tqKokmvoKguMSjjedclh0a2QEa13Z4HdoffMEB769mJXlw>
Received: from workstation.flets-east.jp (ae065175.dynamic.ppp.asahi-net.or.jp [14.3.65.175])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 13 May 2021 08:57:02 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 4/5] ALSA: firewire-lib: fix calculation for size of IR context payload
Date:   Thu, 13 May 2021 21:56:51 +0900
Message-Id: <20210513125652.110249-5-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
References: <20210513125652.110249-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The quadlets for CIP header is handled as a part of IR context header,
thus it doesn't join in IR context payload. However current calculation
includes the quadlets in IR context payload.

Cc: <stable@vger.kernel.org>
Fixes: f11453c7cc01 ("ALSA: firewire-lib: use 16 bytes IR context header to separate CIP header")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-stream.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index b53971bf4b90..73aff017dc9a 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -1071,23 +1071,22 @@ static int amdtp_stream_start(struct amdtp_stream *s, int channel, int speed,
 		s->data_block_counter = 0;
 	}
 
-	/* initialize packet buffer */
+	// initialize packet buffer.
+	max_ctx_payload_size = amdtp_stream_get_max_payload(s);
 	if (s->direction == AMDTP_IN_STREAM) {
 		dir = DMA_FROM_DEVICE;
 		type = FW_ISO_CONTEXT_RECEIVE;
-		if (!(s->flags & CIP_NO_HEADER))
+		if (!(s->flags & CIP_NO_HEADER)) {
+			max_ctx_payload_size -= 8;
 			ctx_header_size = IR_CTX_HEADER_SIZE_CIP;
-		else
+		} else {
 			ctx_header_size = IR_CTX_HEADER_SIZE_NO_CIP;
-
-		max_ctx_payload_size = amdtp_stream_get_max_payload(s) -
-				       ctx_header_size;
+		}
 	} else {
 		dir = DMA_TO_DEVICE;
 		type = FW_ISO_CONTEXT_TRANSMIT;
 		ctx_header_size = 0;	// No effect for IT context.
 
-		max_ctx_payload_size = amdtp_stream_get_max_payload(s);
 		if (!(s->flags & CIP_NO_HEADER))
 			max_ctx_payload_size -= IT_PKT_HEADER_SIZE_CIP;
 	}
-- 
2.27.0

